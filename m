From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 1/2] doc: update meta expression
Date: Fri,  9 Sep 2016 00:16:55 +0200
Message-ID: <1473373016-24078-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:46582 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751229AbcIHWQo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Sep 2016 18:16:44 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 doc/nft.xml | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/doc/nft.xml b/doc/nft.xml
index 9eed883..6297674 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -1001,6 +1001,7 @@ filter output ip6 daddr ::1
 						<arg>iifgroup</arg>
 						<arg>oifgroup</arg>
 						<arg>cgroup</arg>
+						<arg>random</arg>
 					</group>
 				</cmdsynopsis>
 			</para>
@@ -1128,6 +1129,11 @@ filter output ip6 daddr ::1
 								<entry>control group id</entry>
 								<entry>integer (32 bits)</entry>
 							</row>
+							<row>
+								<entry>random</entry>
+								<entry>pseudo-random number</entry>
+								<entry>integer (32 bits)</entry>
+							</row>
 						</tbody>
 					</tgroup>
 				</table>
-- 
2.7.3

