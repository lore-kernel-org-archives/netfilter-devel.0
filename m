From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: [PATCH] doc/nft.xml: Add deletion for objects via handles
Date: Wed, 24 Jan 2018 03:33:10 +0530
Message-ID: <20180123220310.1910-1-harshasharmaiitr@gmail.com>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org, harshasharmaiitr@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:44960 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932071AbeAWWD1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Jan 2018 17:03:27 -0500
Received: by mail-pg0-f66.google.com with SMTP id m20so1229290pgc.11
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Jan 2018 14:03:27 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add documentation for deletion of tables, chains, sets and objects
via unique handles.

Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
---
 doc/nft.xml | 37 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

diff --git a/doc/nft.xml b/doc/nft.xml
index 9e979af..c1ab48d 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -141,7 +141,7 @@ vi:ts=4 sw=4
 				<term><option>-a, --handle</option></term>
 				<listitem>
 					<para>
-						Show rule handles in output.
+						Show object handles in output.
 					</para>
 				</listitem>
 			</varlistentry>
@@ -555,6 +555,14 @@ filter input iif $int_ifs accept
 				<arg choice="opt"><replaceable>family</replaceable></arg>
 				<replaceable>table</replaceable>
 			</cmdsynopsis>
+			<cmdsynopsis>
+				<group choice="req">
+					<arg>delete</arg>
+				</group>
+				<command>table</command>
+				<arg choice="opt"><replaceable>family</replaceable></arg>
+				<literal> handle </literal><replaceable>handle</replaceable>
+			</cmdsynopsis>
 		</para>
 
 		<para>
@@ -646,6 +654,15 @@ filter input iif $int_ifs accept
 				<replaceable>table</replaceable>
 				<replaceable>chain</replaceable>
 			</cmdsynopsis>
+			<cmdsynopsis>
+				<group choice="req">
+					<arg>delete</arg>
+				</group>
+				<command>chain</command>
+				<arg choice="opt"><replaceable>family</replaceable></arg>
+				<replaceable>table</replaceable>
+				<literal> handle </literal><replaceable>handle</replaceable>
+			</cmdsynopsis>
 			<cmdsynopsis>
 				<literal>rename</literal>
 				<command>chain</command>
@@ -896,6 +913,15 @@ filter input iif $int_ifs accept
 				<replaceable>table</replaceable>
 				<replaceable>set</replaceable>
 			</cmdsynopsis>
+			<cmdsynopsis>
+				<group choice="req">
+					<arg>delete</arg>
+				</group>
+				<command> set</command>
+				<arg choice="opt"><replaceable>family</replaceable></arg>
+				<replaceable>table</replaceable>
+				<literal> handle </literal><replaceable>handle</replaceable>
+			</cmdsynopsis>
 			<cmdsynopsis>
 				<group choice="req">
 					<arg>add</arg>
@@ -1174,6 +1200,15 @@ filter input iif $int_ifs accept
 				<replaceable>table</replaceable>
 				<replaceable>object</replaceable>
 			</cmdsynopsis>
+			<cmdsynopsis>
+				<group choice="req">
+					<arg>delete</arg>
+				</group>
+				<command> type</command>
+				<arg choice="opt"><replaceable>family</replaceable></arg>
+				<replaceable>table</replaceable>
+				<literal> handle </literal><replaceable>handle</replaceable>
+			</cmdsynopsis>
 		</para>
 		<para>
 			Stateful objects are attached to tables and are identified by an unique name. They group stateful information from rules, to reference them in rules the keywords "type name" are used e.g. "counter name".
-- 
2.14.1

