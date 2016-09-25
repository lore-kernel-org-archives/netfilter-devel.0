From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nft 2/3] doc: add description about log flags
Date: Sun, 25 Sep 2016 17:07:00 +0800
Message-ID: <1474794421-5365-3-git-send-email-zlpnobody@163.com>
References: <1474794421-5365-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-11.163.com ([220.181.12.11]:43401 "EHLO m12-11.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965681AbcIYJIG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 25 Sep 2016 05:08:06 -0400
In-Reply-To: <1474794421-5365-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

Update usage description about tcpseq, tcpopt, ipopt, uid and macdecode
flags in log statement.

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 doc/nft.xml | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/doc/nft.xml b/doc/nft.xml
index 3b215f8..f4b21de 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -2238,6 +2238,7 @@ ip forward ip dscp set 42
 					<replaceable>quoted_string</replaceable></arg>
 					<arg choice="opt">level
 					<replaceable>syslog-level</replaceable></arg>
+					<arg choice="opt">tcpseq,tcpopt,ipopt,uid,macdecode</arg>
 				</cmdsynopsis>
 				<cmdsynopsis>
 					<command>log</command>
@@ -2297,6 +2298,41 @@ ip forward ip dscp set 42
 						</tbody>
 					</tgroup>
 				</table>
+				<table frame="all">
+					<title>log statement flags</title>
+					<tgroup cols='2' align='left' colsep='1' rowsep='1'>
+						<colspec colname='c1'/>
+						<colspec colname='c2'/>
+						<thead>
+							<row>
+								<entry>Flag</entry>
+								<entry>Description</entry>
+							</row>
+						</thead>
+						<tbody>
+							<row>
+								<entry>tcpseq</entry>
+								<entry>Log TCP sequence numbers.</entry>
+							</row>
+							<row>
+								<entry>tcpopt</entry>
+								<entry>Log options from the TCP packet header.</entry>
+							</row>
+							<row>
+								<entry>ipopt</entry>
+								<entry>Log options from the IP/IPv6 packet header.</entry>
+							</row>
+							<row>
+								<entry>uid</entry>
+								<entry>Log the userid of the process which generated the packet.</entry>
+							</row>
+							<row>
+								<entry>macdecode</entry>
+								<entry>Decode MAC addresses and protocol.</entry>
+							</row>
+						</tbody>
+					</tgroup>
+				</table>
 			</para>
                 </refsect2>
 		<refsect2>
-- 
2.5.5


