"
Examples for the Iceberg git chat tools.
"
Class {
	#name : #GtLGitRepositoryToolExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-Git-Tools'
}

{ #category : #examples }
GtLGitRepositoryToolExamples >> gitStatusAdapter [
	<gtExample>
	| repository call result |
	repository := self registeredRepository.
	call := GtLFunctionToolCall new arguments: { 'repository' -> repository name } asDictionary.
	result := GtLToolForGitStatus new privatePerformToolCall: call inContext: nil.
	self assert: (result isKindOf: GtLObjectStorageValueResult).
	self assert: (result object isKindOf: GtLGitRepositoryStatus).
	^ result
]

{ #category : #examples }
GtLGitRepositoryToolExamples >> registeredRepository [
	<gtExample>
	| repository |
	repository := GtLToolForGitStatus new repositoryNamed: 'gt4llm'.
	repository ifNil: [ repository := IceRepository registry detect: [ :each | [ each branchName. true ] on: Error do: [ false ] ] ifNone: [ nil ] ].
	self assert: repository notNil.
	^ repository
]

{ #category : #examples }
GtLGitRepositoryToolExamples >> statusSerializesForResponses [
	<gtExample>
	| result wrapped out |
	result := self gitStatusAdapter.
	wrapped := GtLToolForGitStatus new resultObjectFromDomainObject: result.
	out := wrapped serializeToOpenAIResponseOutput.
	self assert: (out asString includesSubstring: result object branchName).
	^ out
]

{ #category : #examples }
GtLGitRepositoryToolExamples >> statusSummaryMentionsBranch [
	<gtExample>
	| status |
	status := self gitStatusAdapter object.
	self assert: (status summaryString includesSubstring: status branchName).
	^ status
]

{ #category : #examples }
GtLGitRepositoryToolExamples >> toolSchemasAreAvailable [
	<gtExample>
	| tools |
	tools := self tools.
	tools do: [ :tool | self assert: tool functionOpenAI notNil ].
	^ tools
]

{ #category : #examples }
GtLGitRepositoryToolExamples >> tools [
	<gtExample>
	^ { GtLToolForGitStatus new }
]

{ #category : #examples }
GtLGitRepositoryToolExamples >> toolsHaveDistinctNames [
	<gtExample>
	| tools names |
	tools := self tools.
	names := tools collect: #name.
	self assert: names asSet size equals: 1.
	^ tools
]

{ #category : #examples }
GtLGitRepositoryToolExamples >> unknownRepositoryIsRejected [
	<gtExample>
	| call result |
	call := GtLFunctionToolCall new arguments: { 'repository' -> 'repository-that-does-not-exist' } asDictionary.
	result := GtLToolForGitStatus new privatePerformToolCall: call inContext: nil.
	self assert: (result isKindOf: GtLProblemDomainObject).
	^ result
]
