From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 2/3] rt: add path mtu support
Date: Tue, 22 Aug 2017 15:51:40 +0200
Message-ID: <20170822135141.10785-3-fw@strlen.de>
References: <20170822135141.10785-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:51060 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932660AbdHVNv3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Aug 2017 09:51:29 -0400
In-Reply-To: <20170822135141.10785-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Only use case is to allow similar behaviour to iptables
TCPMSS --clamp-mss-to-pmtu, by combining this with exthdr statement:

tcp option maxseg size set rt mtu

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v2: rename to 'rt mtu' instead of 'rt mss' to avoid
 adding a new MSS token to the scanner.

 doc/nft.xml                         | 7 +++++++
 include/linux/netfilter/nf_tables.h | 1 +
 src/parser_bison.y                  | 1 +
 src/rt.c                            | 5 +++++
 4 files changed, 14 insertions(+)

diff --git a/doc/nft.xml b/doc/nft.xml
index d3213d0281e1..4e2730f698cb 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -2836,6 +2836,11 @@ filter prerouting meta mark set 0xdead fib daddr . mark type vmap { blackhole :
 								<entry>Routing nexthop</entry>
 								<entry>ipv4_addr/ipv6_addr</entry>
 							</row>
+							<row>
+								<entry>mtu</entry>
+								<entry>TCP maximum segment size of route</entry>
+								<entry>integer (16 bit)</entry>
+							</row>
 						</tbody>
 					</tgroup>
 				</table>
@@ -4270,6 +4275,8 @@ ip forward ip dscp set 42
 					<title>change tcp mss</title>
 					<programlisting>
 tcp option maxseg size set 1360
+# set a size based on route information:
+tcp option maxseg size set rt mtu
 					</programlisting>
 				</example>
 			</para>
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 40096de04e96..5441b190852f 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -813,6 +813,7 @@ enum nft_rt_keys {
 	NFT_RT_CLASSID,
 	NFT_RT_NEXTHOP4,
 	NFT_RT_NEXTHOP6,
+	NFT_RT_TCPMSS,
 };
 
 /**
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 7898ea3fe7bc..18be53e88c77 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -3094,6 +3094,7 @@ rt_expr			:	RT	rt_key
 
 rt_key			:	CLASSID		{ $$ = NFT_RT_CLASSID; }
 			|	NEXTHOP		{ $$ = NFT_RT_NEXTHOP4; }
+			|	MTU		{ $$ = NFT_RT_TCPMSS; }
 			;
 
 ct_expr			: 	CT	ct_key
diff --git a/src/rt.c b/src/rt.c
index cd2d5a4ed7b9..91be5a11c5a2 100644
--- a/src/rt.c
+++ b/src/rt.c
@@ -73,6 +73,11 @@ static const struct rt_template rt_templates[] = {
 					      16 * BITS_PER_BYTE,
 					      BYTEORDER_BIG_ENDIAN,
 					      true),
+	[NFT_RT_TCPMSS]		= RT_TEMPLATE("mtu",
+					      &integer_type,
+					      2 * BITS_PER_BYTE,
+					      BYTEORDER_HOST_ENDIAN,
+					      false),
 };
 
 static void rt_expr_print(const struct expr *expr, struct output_ctx *octx)
-- 
2.13.0

