"
Read-only status of a registered Iceberg repository.
"
Class {
	#name : #GtLToolForGitStatus,
	#superclass : #GtLGitRepositoryTool,
	#category : #'Gt4Llm-Git-Tools'
}

{ #category : #accessing }
GtLToolForGitStatus >> description [
	^ 'Inspect status of a registered Iceberg Git repository: branch, dirty state, and incoming/outgoing commits. Read-only. The result is kept in the chat and offers an Overview view readable with getViewContent.'
]

{ #category : #accessing }
GtLToolForGitStatus >> name [
	^ 'gitStatus'
]

{ #category : #private }
GtLToolForGitStatus >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| repository status result |
	repository := self repositoryFromToolCall: aToolCall.
	(self repositoryErrorFrom: repository) ifTrue: [ ^ repository ].
	status := [ GtLGitRepositoryStatus forRepository: repository ]
		on: Error
		do: [ :error | ^ GtLProblemDomainObject new description: error messageText ].
	result := GtLObjectStorageValueResult forObject: status.
	[ result updateForToolCall: aToolCall withExecutionContext: anExecutionContext ]
		on: Error
		do: [ :updateError | "no object storage available: return the result without an id" ].
	^ result
]
