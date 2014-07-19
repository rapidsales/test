<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>X15_mins_check</fullName>
        <field>X15mins__c</field>
        <literalValue>1</literalValue>
        <name>15 mins check</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Every 5 mins</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Account.X15mins__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Task reminder</fullName>
        <actions>
            <name>X15_mins_check</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Appointment_reminder</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <tasks>
        <fullName>Appointment_reminder</fullName>
        <assignedTo>honeysfdc@gmail.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>Reminder for Demo</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>In Progress</status>
        <subject>Appointment reminder</subject>
    </tasks>
</Workflow>
