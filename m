From: Duncan Roe <duncan_roe@optusnet.com.au>
Subject: [PATCH] doc: nft.8 aim for consistent synopses throughout
Date: Sat,  2 Dec 2017 22:04:43 +1100
Message-ID: <20171202110443.11770-1-duncan_roe@optusnet.com.au>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:55104 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751445AbdLBLE4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 2 Dec 2017 06:04:56 -0500
Received: from dimstar.local.net (c220-239-53-24.eburwd6.vic.optusnet.com.au [220.239.53.24])
        by mail104.syd.optusnet.com.au (Postfix) with SMTP id 24BB242917F
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Dec 2017 22:04:43 +1100 (AEDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Single items in braces have the braces removed as per wiki Scripting:
"It is simply overkill to define a set that only stores one single element".
Items that were in braces or square brackets are made consistent, e.g. {family}
expands to single wor Ip, inet &c., but (type) in set spec expands to
"type type_name ;".

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 doc/nft.xml | 147 ++++++++++++++++++++++++++++++------------------------------
 1 file changed, 73 insertions(+), 74 deletions(-)

diff --git a/doc/nft.xml b/doc/nft.xml
index a1bfecd..cbb3b80 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -552,7 +552,7 @@ filter input iif $int_ifs accept
 				</group>
 				<command>table</command>
 				<arg choice="opt"><replaceable>family</replaceable></arg>
-				<arg choice="req"><replaceable>table</replaceable></arg>
+				<replaceable>table</replaceable>
 			</cmdsynopsis>
 		</para>
 
@@ -626,11 +626,11 @@ filter input iif $int_ifs accept
 				<arg choice="plain"><replaceable>chain</replaceable></arg>
 				<arg choice="opt">
 					<arg choice="req">
-						<arg choice="req"><replaceable>type</replaceable></arg>
-						<arg choice="req"><replaceable>hook</replaceable></arg>
-						<arg choice="opt"><replaceable>device</replaceable></arg>
-						<arg choice="req"><replaceable>priority</replaceable> ;</arg>
-						<arg choice="opt"><replaceable>policy</replaceable> ;</arg>
+						type <replaceable>type</replaceable>
+						hook <replaceable>hook</replaceable>
+						<arg choice="opt">device <replaceable>device</replaceable></arg>
+						priority <replaceable>priority</replaceable> ;
+						<arg choice="opt">policy <replaceable>policy</replaceable> ;</arg>
 					</arg>
 				</arg>
 			</cmdsynopsis>
@@ -642,16 +642,16 @@ filter input iif $int_ifs accept
 				</group>
 				<command>chain</command>
 				<arg choice="opt"><replaceable>family</replaceable></arg>
-				<arg choice="req"><replaceable>table</replaceable></arg>
-				<arg choice="req"><replaceable>chain</replaceable></arg>
+				<replaceable>table</replaceable>
+				<replaceable>chain</replaceable>
 			</cmdsynopsis>
 			<cmdsynopsis>
-				<arg choice="req">rename</arg>
+				<literal>rename</literal>
 				<command>chain</command>
 				<arg choice="opt"><replaceable>family</replaceable></arg>
-				<arg choice="req"><replaceable>table</replaceable></arg>
-				<arg choice="req"><replaceable>chain</replaceable></arg>
-				<arg choice="req"><replaceable>newname</replaceable></arg>
+				<replaceable>table</replaceable>
+				<replaceable>chain</replaceable>
+				<replaceable>newname</replaceable>
 			</cmdsynopsis>
 		</para>
 
@@ -798,27 +798,27 @@ filter input iif $int_ifs accept
 				</group>
 				<command>rule</command>
 				<arg choice="opt"><replaceable>family</replaceable></arg>
-				<arg choice="req"><replaceable>table</replaceable></arg>
-				<arg choice="req"><replaceable>chain</replaceable></arg>
+				<replaceable>table</replaceable>
+				<replaceable>chain</replaceable>
 				<arg choice="opt">position <replaceable>position</replaceable></arg>
-				<arg choice="req" rep="repeat"><replaceable>statement</replaceable></arg>
+				<replaceable>statement</replaceable>...
 			</cmdsynopsis>
 			<cmdsynopsis>
-				<arg choice="req">replace</arg>
-				<command>rule</command>
+
+				<literal>replace </literal><command>rule</command>
 				<arg choice="opt"><replaceable>family</replaceable></arg>
-				<arg choice="req"><replaceable>table</replaceable></arg>
-				<arg choice="req"><replaceable>chain</replaceable></arg>
-				<arg choice="req">handle <replaceable>handle</replaceable></arg>
-				<arg choice="req" rep="repeat"><replaceable>statement</replaceable></arg>
+				<replaceable>table</replaceable>
+				<replaceable>chain</replaceable>
+				<literal> handle </literal><replaceable>handle</replaceable>
+				<replaceable>statement</replaceable>...
 			</cmdsynopsis>
 			<cmdsynopsis>
-				<arg choice="req">delete</arg>
+				<literal>delete</literal>
 				<command>rule</command>
 				<arg choice="opt"><replaceable>family</replaceable></arg>
-				<arg choice="req"><replaceable>table</replaceable></arg>
-				<arg choice="req"><replaceable>chain</replaceable></arg>
-				<arg choice="req">handle <replaceable>handle</replaceable></arg>
+				<replaceable>table</replaceable>
+				<replaceable>chain</replaceable>
+				<literal> handle </literal><replaceable>handle</replaceable>
 			</cmdsynopsis>
 		</para>
 		<para>
@@ -869,19 +869,19 @@ filter input iif $int_ifs accept
 		<title>Sets</title>
 		<para>
 			<cmdsynopsis>
-				<arg choice="req">add</arg>
+				<literal>add</literal>
 				<command> set</command>
 				<arg choice="opt"><replaceable>family</replaceable></arg>
-				<arg choice="req"><replaceable>table</replaceable></arg>
-				<arg choice="req"><replaceable>set</replaceable></arg>
-				{
-				<arg choice="req"><replaceable>type</replaceable></arg>
-				<arg choice="opt"><replaceable>flags</replaceable></arg>
-				<arg choice="opt"><replaceable>timeout</replaceable></arg>
-				<arg choice="opt"><replaceable>gc-interval</replaceable></arg>
-				<arg choice="opt"><replaceable>elements</replaceable></arg>
-				<arg choice="opt"><replaceable>size</replaceable></arg>
-				<arg choice="opt"><replaceable>policy</replaceable></arg>
+				<replaceable>table</replaceable>
+				<replaceable>set</replaceable>
+				{ type
+				<replaceable>type</replaceable> ;
+				<arg choice="opt">flags <replaceable>flags</replaceable> ;</arg>
+				<arg choice="opt">timeout <replaceable>timeout</replaceable> ;</arg>
+				<arg choice="opt">gc-interval <replaceable>gc-interval</replaceable> ;</arg>
+				<arg choice="opt">elements = { <replaceable>element</replaceable>[,...] } ;</arg>
+				<arg choice="opt">size <replaceable>size</replaceable> ;</arg>
+				<arg choice="opt">policy <replaceable>policy</replaceable> ;</arg>
 				}
 			</cmdsynopsis>
 			<cmdsynopsis>
@@ -892,8 +892,8 @@ filter input iif $int_ifs accept
 				</group>
 				<command> set</command>
 				<arg choice="opt"><replaceable>family</replaceable></arg>
-				<arg choice="req"><replaceable>table</replaceable></arg>
-				<arg choice="req"><replaceable>set</replaceable></arg>
+				<replaceable>table</replaceable>
+				<replaceable>set</replaceable>
 			</cmdsynopsis>
 			<cmdsynopsis>
 				<group choice="req">
@@ -902,11 +902,10 @@ filter input iif $int_ifs accept
 				</group>
 				<command> element</command>
 				<arg choice="opt"><replaceable>family</replaceable></arg>
-				<arg choice="req"><replaceable>table</replaceable></arg>
-				<arg choice="req"><replaceable>set</replaceable></arg>
+				<replaceable>table</replaceable>
+				<replaceable>set</replaceable>
 				{
-				<arg choice="req"><replaceable>elements</replaceable></arg>
-				}
+				<replaceable>element</replaceable>[,...] }
 			</cmdsynopsis>
 		</para>
 		<para>
@@ -1022,17 +1021,17 @@ filter input iif $int_ifs accept
 		<title>Maps</title>
 		<para>
 			<cmdsynopsis>
-				<arg choice="req">add</arg>
+				<literal>add</literal>
 				<command> map</command>
 				<arg choice="opt"><replaceable>family</replaceable></arg>
-				<arg choice="req"><replaceable>table</replaceable></arg>
-				<arg choice="req"><replaceable>map</replaceable></arg>
-				{
-				<arg choice="req"><replaceable>type</replaceable></arg>
-				<arg choice="opt"><replaceable>flags</replaceable></arg>
-				<arg choice="opt"><replaceable>elements</replaceable></arg>
-				<arg choice="opt"><replaceable>size</replaceable></arg>
-				<arg choice="opt"><replaceable>policy</replaceable></arg>
+				<replaceable>table</replaceable>
+				<replaceable>map</replaceable>
+				{ type
+				<replaceable>type</replaceable>
+				<arg choice="opt">flags <replaceable>flags</replaceable> ;</arg>
+				<arg choice="opt">elements = { <replaceable>element</replaceable>[,...] } ;</arg>
+				<arg choice="opt">size <replaceable>size</replaceable> ;</arg>
+				<arg choice="opt">policy <replaceable>policy</replaceable> ;</arg>
 				}
 			</cmdsynopsis>
 			<cmdsynopsis>
@@ -1043,8 +1042,8 @@ filter input iif $int_ifs accept
 				</group>
 				<command> map</command>
 				<arg choice="opt"><replaceable>family</replaceable></arg>
-				<arg choice="req"><replaceable>table</replaceable></arg>
-				<arg choice="req"><replaceable>map</replaceable></arg>
+				<replaceable>table</replaceable>
+				<replaceable>map</replaceable>
 			</cmdsynopsis>
 			<cmdsynopsis>
 				<group choice="req">
@@ -1053,10 +1052,10 @@ filter input iif $int_ifs accept
 				</group>
 				<command> element</command>
 				<arg choice="opt"><replaceable>family</replaceable></arg>
-				<arg choice="req"><replaceable>table</replaceable></arg>
-				<arg choice="req"><replaceable>map</replaceable></arg>
+				<replaceable>table</replaceable>
+				<replaceable>map</replaceable>
 				{
-				<arg choice="req"><replaceable>elements</replaceable></arg>
+				elements = { <replaceable>element</replaceable>[,...] } ;
 				}
 			</cmdsynopsis>
 		</para>
@@ -1171,8 +1170,8 @@ filter input iif $int_ifs accept
 				</group>
 				<command> type</command>
 				<arg choice="opt"><replaceable>family</replaceable></arg>
-				<arg choice="req"><replaceable>table</replaceable></arg>
-				<arg choice="req"><replaceable>object</replaceable></arg>
+				<replaceable>table</replaceable>
+				<replaceable>object</replaceable>
 			</cmdsynopsis>
 		</para>
 		<para>
@@ -1219,13 +1218,15 @@ filter input iif $int_ifs accept
 			<para>
 				<cmdsynopsis>
 					<command>ct</command>
-					<arg choice="req">helper</arg>
-					<arg choice="req">type</arg>
-					<arg choice="req"><replaceable>type</replaceable></arg>
-					<arg choice="req">protocol</arg>
-					<arg choice="req"><replaceable>protocol</replaceable></arg>
-					<arg choice="opt">l3proto</arg>
-					<arg choice="opt"><replaceable>family</replaceable></arg>
+					<literal>helper</literal>
+					<replaceable>helper</replaceable>
+					<literal> { type </literal>
+					<replaceable>type</replaceable>
+					<literal> protocol </literal>
+					<replaceable>protocol</replaceable>
+					<literal> ;</literal>
+					<arg choice="opt"><literal>l3proto </literal><replaceable>family</replaceable><literal> ;</literal></arg>
+					<literal> }</literal>
 				</cmdsynopsis>
 			</para>
 			<para>
@@ -1382,7 +1383,7 @@ table inet myhelpers {
 			<para>
 				<cmdsynopsis>
 					<command>describe</command>
-					<arg choice="req"><replaceable>expression</replaceable></arg>
+					<replaceable>expression</replaceable>
 				</cmdsynopsis>
 			</para>
 			<para>
@@ -2736,7 +2737,7 @@ filter output oif eth0
 					<group choice="req">
 						<arg>saddr</arg>
 						<arg>daddr</arg>
-					<group choice="opt">
+					<group choice="req">
 						<arg>mark</arg>
 						<arg>iif</arg>
 						<arg>oif</arg>
@@ -4178,7 +4179,7 @@ ip6 filter input frag more-fragments 1 counter
 						<arg>jump</arg>
 						<arg>goto</arg>
 					</group>
-					<arg choice="req"><replaceable>chain</replaceable></arg>
+					<replaceable>chain</replaceable>
 				</cmdsynopsis>
 			</para>
 			<para>
@@ -4451,9 +4452,7 @@ ip6 filter output log flags all
 				<cmdsynopsis>
 					<command>reject</command>
 					<arg choice="opt">
-						<arg choice="none">with</arg>
-						<arg choice="req">tcp</arg>
-						<arg choice="req">reset</arg>
+						<literal> with tcp reset </literal>
 					</arg>
 				</cmdsynopsis>
 			</para>
@@ -4509,10 +4508,10 @@ ip6 filter output log flags all
 			<para>
 				<cmdsynopsis>
 					<command>counter</command>
-					<arg choice="req">packets
+					<arg choice="opt">
+					<literal>packets</literal>
 					<replaceable>number</replaceable>
-					</arg>
-					<arg choice="req">bytes
+					<literal>bytes</literal>
 					<replaceable>number</replaceable>
 					</arg>
 				</cmdsynopsis>
-- 
2.9.0

