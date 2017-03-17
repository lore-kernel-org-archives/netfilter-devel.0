From: Elise Lennion <elise.lennion@gmail.com>
Subject: [PATCH nft 2/3] parser_bison: Allow flushing maps
Date: Fri, 17 Mar 2017 12:04:06 -0300
Message-ID: <20170317150406.GA1298@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:36830 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751140AbdCQPEX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Mar 2017 11:04:23 -0400
Received: by mail-qt0-f195.google.com with SMTP id n37so9781546qtb.3
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Mar 2017 08:04:14 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch enables the command flush on maps, which removes all
entries in it:

$ nft flush map filter map1

Command above flushes map 'map1' in table 'filter'.

The documentation was updated accordingly.

Signed-off-by: Elise Lennion <elise.lennion@gmail.com>
---
 doc/nft.xml        | 9 +++++++++
 src/parser_bison.y | 4 ++++
 2 files changed, 13 insertions(+)

diff --git a/doc/nft.xml b/doc/nft.xml
index b3e3d9e..a63b4c2 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -812,6 +812,7 @@ filter input iif $int_ifs accept
 				<group choice="req">
 					<arg>delete</arg>
 					<arg>list</arg>
+					<arg>flush</arg>
 				</group>
 				<command> map</command>
 				<arg choice="opt"><replaceable>family</replaceable></arg>
@@ -848,6 +849,14 @@ filter input iif $int_ifs accept
 					</para>
 				</listitem>
 			</varlistentry>
+			<varlistentry>
+				<term><option>flush</option></term>
+				<listitem>
+					<para>
+						Remove all elements from the specified map.
+					</para>
+				</listitem>
+			</varlistentry>
 		</variablelist>
 
 		<table frame="all">
diff --git a/src/parser_bison.y b/src/parser_bison.y
index e44ff44..841b2e1 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -1131,6 +1131,10 @@ flush_cmd		:	TABLE		table_spec
 			{
 				$$ = cmd_alloc(CMD_FLUSH, CMD_OBJ_SET, &$3, &@$, NULL);
 			}
+			|	MAP		set_spec
+			{
+				$$ = cmd_alloc(CMD_FLUSH, CMD_OBJ_SET, &$2, &@$, NULL);
+			}
 			|	RULESET		ruleset_spec
 			{
 				$$ = cmd_alloc(CMD_FLUSH, CMD_OBJ_RULESET, &$2, &@$, NULL);
-- 
2.7.4

