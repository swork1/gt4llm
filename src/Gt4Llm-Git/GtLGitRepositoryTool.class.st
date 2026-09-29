"
Abstract base for chat tools that operate on a registered Iceberg repository.
"
Class {
	#name : #GtLGitRepositoryTool,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : #'Gt4Llm-Git-Tools'
}

{ #category : #accessing }
GtLGitRepositoryTool class >> allTools [
	^ GtLTools withAll: { GtLToolForGitStatus new }
]

{ #category : #accessing }
GtLGitRepositoryTool >> description [
	^ 'Abstract base for operations on a registered Iceberg repository.'
]

{ #category : #accessing }
GtLGitRepositoryTool >> name [
	^ 'gitRepositoryBase'
]

{ #category : #private }
GtLGitRepositoryTool >> repositoryArgumentFrom: aToolCall [
	^ (aToolCall arguments ifNil: [ Dictionary new ]) at: 'repository' ifAbsent: [ nil ]
]

{ #category : #private }
GtLGitRepositoryTool >> repositoryErrorFrom: aRepository [
	^ aRepository isKindOf: GtLProblemDomainObject
]

{ #category : #private }
GtLGitRepositoryTool >> repositoryFromToolCall: aToolCall [
	| name repository |
	name := self repositoryArgumentFrom: aToolCall.
	name ifNil: [ ^ GtLProblemDomainObject new description: 'Missing repository argument' ].
	repository := self repositoryNamed: name.
	repository ifNil: [ ^ GtLProblemDomainObject new description: 'Registered Iceberg repository not found: ' , name asString ].
	^ repository
]

{ #category : #accessing }
GtLGitRepositoryTool >> repositoryNameDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Repository';
		comment: 'Name of a registered Iceberg repository, e.g. as listed by the Git tool';
		accessor: #repository;
		beRequired
]

{ #category : #private }
GtLGitRepositoryTool >> repositoryNamed: aName [
	^ IceRepository repositories
		detect: [ :each | each name asString sameAs: aName asString ]
		ifNone: [ nil ]
]

{ #category : #private }
GtLGitRepositoryTool >> repositoryNames [
	^ IceRepository repositories collect: #name
]
