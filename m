From: Eric Leblond <eric@regit.org>
Subject: [nftables PATCH 1/5] doc: fix inversion of operator and object.
Date: Sun,  2 Jun 2013 12:38:28 +0200
Message-ID: <1370169512-23500-2-git-send-email-eric@regit.org>
References: <1370169512-23500-1-git-send-email-eric@regit.org>
Cc: Eric Leblond <eric@regit.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:36291 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736Ab3FBKix (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 2 Jun 2013 06:38:53 -0400
In-Reply-To: <1370169512-23500-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Eric Leblond <eric@regit.org>
---
 doc/nftables.xml |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/doc/nftables.xml b/doc/nftables.xml
index ec6de38..055d4a6 100644
--- a/doc/nftables.xml
+++ b/doc/nftables.xml
@@ -150,13 +150,13 @@
 		<title>Tables</title>
 		<para>
 			<cmdsynopsis>
-				<command>table</command>
 				<group choice="req">
 					<arg>add</arg>
 					<arg>delete</arg>
 					<arg>list</arg>
 					<arg>flush</arg>
 				</group>
+				<command>table</command>
 				<arg choice="opt"><replaceable>family</replaceable></arg>
 				<arg choice="req"><replaceable>table</replaceable></arg>
 			</cmdsynopsis>
@@ -216,8 +216,8 @@
 		<title>Chains</title>
 		<para>
 			<cmdsynopsis>
-				<command>chain</command>
 				<arg choice="req">add</arg>
+				<command>chain</command>
 				<arg choice="opt"><replaceable>family</replaceable></arg>
 				<arg choice="req"><replaceable>table</replaceable></arg>
 				<arg choice="req"><replaceable>chain</replaceable></arg>
@@ -225,13 +225,13 @@
 				<arg choice="req"><replaceable>priority</replaceable></arg>
 			</cmdsynopsis>
 			<cmdsynopsis>
-				<command>chain</command>
 				<group choice="req">
 					<arg>add</arg>
 					<arg>delete</arg>
 					<arg>list</arg>
 					<arg>flush</arg>
 				</group>
+				<command>chain</command>
 				<arg choice="opt"><replaceable>family</replaceable></arg>
 				<arg choice="req"><replaceable>table</replaceable></arg>
 				<arg choice="req"><replaceable>chain</replaceable></arg>
@@ -287,11 +287,11 @@
 		<title>Rules</title>
 		<para>
 			<cmdsynopsis>
-				<command>rule</command>
 				<group choice="req">
 					<arg>add</arg>
 					<arg>delete</arg>
 				</group>
+				<command>rule</command>
 				<arg choice="opt"><replaceable>family</replaceable></arg>
 				<arg choice="req"><replaceable>table</replaceable></arg>
 				<arg choice="req"><replaceable>chain</replaceable></arg>
-- 
1.7.10.4

