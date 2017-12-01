From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] meta: add secpath support
Date: Fri,  1 Dec 2017 13:40:21 +0100
Message-ID: <20171201124021.20973-4-fw@strlen.de>
References: <20171201124021.20973-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:40880 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752424AbdLAMk3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Dec 2017 07:40:29 -0500
In-Reply-To: <20171201124021.20973-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This can be used to check if a packet has a secpath attached to it, i.e.
was subject to ipsec processing.  Example:

add rule inet raw prerouting meta secpath exists accept

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 doc/nft.xml                         | 10 ++++++++++
 include/linux/netfilter/nf_tables.h |  2 ++
 src/meta.c                          |  3 +++
 tests/py/inet/meta.t                |  2 ++
 tests/py/inet/meta.t.payload        |  9 +++++++++
 5 files changed, 26 insertions(+)

diff --git a/doc/nft.xml b/doc/nft.xml
index a1bfecd2654f..b9f7a909d244 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -2503,6 +2503,7 @@ filter output icmpv6 type { echo-request, echo-reply }
 						<arg>oifgroup</arg>
 						<arg>cgroup</arg>
 						<arg>random</arg>
+						<arg>secpath</arg>
 					</group>
 				</cmdsynopsis>
 			</para>
@@ -2640,6 +2641,12 @@ filter output icmpv6 type { echo-request, echo-reply }
 								<entry>pseudo-random number</entry>
 								<entry>integer (32 bits)</entry>
 							</row>
+							<row>
+								<entry>secpath</entry>
+								<entry>boolean</entry>
+								<entry>boolean (1 bit)</entry>
+							</row>
+
 						</tbody>
 					</tgroup>
 				</table>
@@ -2724,6 +2731,9 @@ filter output meta oif eth0
 
 # unqualified meta expression
 filter output oif eth0
+
+# packed was subject to ipsec processing
+raw prerouting meta secpath exists accept
 					</programlisting>
 				</example>
 			</para>
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index f32894431f82..c990bc987c2e 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -773,6 +773,7 @@ enum nft_exthdr_attributes {
  * @NFT_META_OIFGROUP: packet output interface group
  * @NFT_META_CGROUP: socket control group (skb->sk->sk_classid)
  * @NFT_META_PRANDOM: a 32bit pseudo-random number
+ * @NFT_META_SECPATH: boolean, secpath_exists (!!skb->sp)
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -800,6 +801,7 @@ enum nft_meta_keys {
 	NFT_META_OIFGROUP,
 	NFT_META_CGROUP,
 	NFT_META_PRANDOM,
+	NFT_META_SECPATH,
 };
 
 /**
diff --git a/src/meta.c b/src/meta.c
index 28aebe396f17..ac3e0333a489 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -428,6 +428,8 @@ static const struct meta_template meta_templates[] = {
 	[NFT_META_PRANDOM]	= META_TEMPLATE("random",    &integer_type,
 						4 * BITS_PER_BYTE,
 						BYTEORDER_BIG_ENDIAN), /* avoid conversion; doesn't have endianess */
+	[NFT_META_SECPATH]	= META_TEMPLATE("secpath", &boolean_type,
+						BITS_PER_BYTE, BYTEORDER_HOST_ENDIAN),
 };
 
 static bool meta_key_is_qualified(enum nft_meta_keys key)
@@ -439,6 +441,7 @@ static bool meta_key_is_qualified(enum nft_meta_keys key)
 	case NFT_META_PROTOCOL:
 	case NFT_META_PRIORITY:
 	case NFT_META_PRANDOM:
+	case NFT_META_SECPATH:
 		return true;
 	default:
 		return false;
diff --git a/tests/py/inet/meta.t b/tests/py/inet/meta.t
index bd225e3d8bc4..d68896dc0b9e 100644
--- a/tests/py/inet/meta.t
+++ b/tests/py/inet/meta.t
@@ -12,3 +12,5 @@ meta nfproto ipv4 tcp dport 22;ok
 meta nfproto ipv4 ip saddr 1.2.3.4;ok;ip saddr 1.2.3.4
 meta nfproto ipv6 meta l4proto tcp;ok;meta nfproto ipv6 meta l4proto 6
 meta nfproto ipv4 counter ip saddr 1.2.3.4;ok
+meta secpath exists;ok
+meta secpath missing;ok
diff --git a/tests/py/inet/meta.t.payload b/tests/py/inet/meta.t.payload
index 0323b30f487b..2d0a66fa5cf5 100644
--- a/tests/py/inet/meta.t.payload
+++ b/tests/py/inet/meta.t.payload
@@ -64,3 +64,12 @@ inet test-inet input
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ cmp eq reg 1 0x04030201 ]
 
+# meta secpath exists
+inet test-inet input
+  [ meta load secpath => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# meta secpath missing
+inet test-inet input
+  [ meta load secpath => reg 1 ]
+  [ cmp eq reg 1 0x00000000 ]
-- 
2.13.6

