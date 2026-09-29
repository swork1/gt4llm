"
A focused, inspectable snapshot of a registered Iceberg repository status for chat tool results.
"
Class {
	#name : #GtLGitRepositoryStatus,
	#superclass : #Object,
	#instVars : [
		'repositoryName',
		'branchName',
		'headDescription',
		'isDirty',
		'hasIncomingCommits',
		'hasOutgoingCommits'
	],
	#category : #'Gt4Llm-Git-Tools'
}

{ #category : #'instance creation' }
GtLGitRepositoryStatus class >> forRepository: aRepository [
	^ self new
		repositoryName: aRepository name;
		branchName: aRepository branchName;
		headDescription: aRepository headDescription;
		isDirty: aRepository isDirty;
		hasIncomingCommits: aRepository hasIncomingCommits;
		hasOutgoingCommits: aRepository hasOutgoingCommits;
		yourself
]

{ #category : #accessing }
GtLGitRepositoryStatus >> branchName [
	^ branchName
]

{ #category : #accessing }
GtLGitRepositoryStatus >> branchName: aString [
	branchName := aString
]

{ #category : #views }
GtLGitRepositoryStatus >> gtOverviewFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Overview';
		priority: 10;
		items: [ self overviewPairs ];
		column: 'Property' text: #key;
		column: 'Value' text: #value;
		send: #value
]

{ #category : #accessing }
GtLGitRepositoryStatus >> hasIncomingCommits [
	^ hasIncomingCommits
]

{ #category : #accessing }
GtLGitRepositoryStatus >> hasIncomingCommits: aBoolean [
	hasIncomingCommits := aBoolean
]

{ #category : #accessing }
GtLGitRepositoryStatus >> hasOutgoingCommits [
	^ hasOutgoingCommits
]

{ #category : #accessing }
GtLGitRepositoryStatus >> hasOutgoingCommits: aBoolean [
	hasOutgoingCommits := aBoolean
]

{ #category : #accessing }
GtLGitRepositoryStatus >> headDescription [
	^ headDescription
]

{ #category : #accessing }
GtLGitRepositoryStatus >> headDescription: aString [
	headDescription := aString
]

{ #category : #accessing }
GtLGitRepositoryStatus >> isDirty [
	^ isDirty
]

{ #category : #accessing }
GtLGitRepositoryStatus >> isDirty: aBoolean [
	isDirty := aBoolean
]

{ #category : #views }
GtLGitRepositoryStatus >> llmModelDataViewsFor: aDataView [
	<gtLlmDataView>
	^ aDataView jsonObject: [ :jsonObject | jsonObject addAll: { 'repository' -> repositoryName asString. 'branch' -> branchName asString. 'head' -> headDescription asString. 'dirty' -> isDirty. 'incoming' -> hasIncomingCommits. 'outgoing' -> hasOutgoingCommits. 'summary' -> self summaryString } asDictionary ]
]

{ #category : #views }
GtLGitRepositoryStatus >> overviewPairs [
	^ { 'Repository' -> repositoryName. 'Branch' -> branchName. 'Head' -> headDescription. 'Dirty' -> isDirty asString. 'Incoming' -> hasIncomingCommits asString. 'Outgoing' -> hasOutgoingCommits asString }
]

{ #category : #accessing }
GtLGitRepositoryStatus >> repositoryName [
	^ repositoryName
]

{ #category : #accessing }
GtLGitRepositoryStatus >> repositoryName: aString [
	repositoryName := aString
]

{ #category : #accessing }
GtLGitRepositoryStatus >> summaryString [
	^ '{1} @ {2} · {3} · {4}' format: { repositoryName. branchName. (isDirty ifTrue: [ 'dirty' ] ifFalse: [ 'clean' ]). self syncState }
]

{ #category : #accessing }
GtLGitRepositoryStatus >> syncState [
	hasIncomingCommits ifTrue: [ hasOutgoingCommits ifTrue: [ ^ 'diverged' ] ifFalse: [ ^ 'behind' ] ].
	^ hasOutgoingCommits ifTrue: [ 'ahead' ] ifFalse: [ 'in sync' ]
]
