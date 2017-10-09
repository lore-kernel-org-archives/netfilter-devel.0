From: Duncan Roe <duncan_roe@optusnet.com.au>
Subject: [PATCH] doc: nft.8 Document rule replace
Date: Tue, 10 Oct 2017 01:58:41 +1100
Message-ID: <20171009145841.6046-1-duncan_roe@optusnet.com.au>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:37705 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754084AbdJIO6v (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 Oct 2017 10:58:51 -0400
Received: from dimstar.local.net (c220-239-36-238.eburwd6.vic.optusnet.com.au [220.239.36.238])
        by mail110.syd.optusnet.com.au (Postfix) with SMTP id A9C47103900
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Oct 2017 01:58:41 +1100 (AEDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Insert synopsis and description between those for add|insert and delete

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 doc/nft.xml | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/doc/nft.xml b/doc/nft.xml
index 80ffcd7..c7e12c9 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -839,6 +839,15 @@ filter input iif $int_ifs accept
 				<arg choice="req" rep="repeat"><replaceable>statement</replaceable></arg>
 			</cmdsynopsis>
 			<cmdsynopsis>
+				<arg choice="req">replace</arg>
+				<command>rule</command>
+				<arg choice="opt"><replaceable>family</replaceable></arg>
+				<arg choice="req"><replaceable>table</replaceable></arg>
+				<arg choice="req"><replaceable>chain</replaceable></arg>
+				<arg choice="req">handle <replaceable>handle</replaceable></arg>
+				<arg choice="req" rep="repeat"><replaceable>statement</replaceable></arg>
+			</cmdsynopsis>
+			<cmdsynopsis>
 				<arg choice="req">delete</arg>
 				<command>rule</command>
 				<arg choice="opt"><replaceable>family</replaceable></arg>
@@ -873,6 +882,14 @@ filter input iif $int_ifs accept
 				</listitem>
 			</varlistentry>
 			<varlistentry>
+				<term><option>replace</option></term>
+				<listitem>
+					<para>
+						Similar to the <command>add</command> command, but the rule replaces the specified rule.
+					</para>
+				</listitem>
+			</varlistentry>
+			<varlistentry>
 				<term><option>delete</option></term>
 				<listitem>
 					<para>
-- 
2.9.0

