From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft v3 2/7] src: allow update of net base w. meta l4proto icmpv6
Date: Fri, 19 May 2017 22:11:06 +0200
Message-ID: <20170519201111.7402-3-fw@strlen.de>
References: <20170519201111.7402-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:34036 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751513AbdESULA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 May 2017 16:11:00 -0400
In-Reply-To: <20170519201111.7402-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nft add rule ip6 f i meta l4proto ipv6-icmp icmpv6 type nd-router-advert
<cmdline>:1:50-60: Error: conflicting protocols specified: unknown vs. icmpv6

add icmpv6 to nexthdr list so base gets updated correctly.

Reported-by: Thomas Woerner <twoerner@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Change since last version:
  - add test in same patch.

 src/proto.c                 | 1 +
 tests/py/any/meta.t         | 1 +
 tests/py/any/meta.t.payload | 7 +++++++
 3 files changed, 9 insertions(+)

diff --git a/src/proto.c b/src/proto.c
index 79e9dbf2b33e..fcdfbe73c735 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -779,6 +779,7 @@ const struct proto_desc proto_inet_service = {
 		PROTO_LINK(IPPROTO_TCP,		&proto_tcp),
 		PROTO_LINK(IPPROTO_DCCP,	&proto_dccp),
 		PROTO_LINK(IPPROTO_SCTP,	&proto_sctp),
+		PROTO_LINK(IPPROTO_ICMPV6,	&proto_icmp6),
 	},
 	.templates	= {
 		[0]	= PROTO_META_TEMPLATE("l4proto", &inet_protocol_type, NFT_META_L4PROTO, 8),
diff --git a/tests/py/any/meta.t b/tests/py/any/meta.t
index c3ac0a4c267a..2ff942ff039d 100644
--- a/tests/py/any/meta.t
+++ b/tests/py/any/meta.t
@@ -38,6 +38,7 @@ meta l4proto { 33, 55, 67, 88};ok;meta l4proto { 33, 55, 67, 88}
 meta l4proto != { 33, 55, 67, 88};ok
 meta l4proto { 33-55};ok
 meta l4proto != { 33-55};ok
+meta l4proto ipv6-icmp icmpv6 type nd-router-advert;ok;icmpv6 type nd-router-advert
 
 meta priority root;ok
 meta priority none;ok
diff --git a/tests/py/any/meta.t.payload b/tests/py/any/meta.t.payload
index e432656624b6..871f1ada5abe 100644
--- a/tests/py/any/meta.t.payload
+++ b/tests/py/any/meta.t.payload
@@ -187,6 +187,13 @@ ip test-ip4 input
   [ byteorder reg 1 = hton(reg 1, 2, 1) ]
   [ lookup reg 1 set __set%d 0x1 ]
 
+# meta l4proto ipv6-icmp icmpv6 type nd-router-advert
+ip test-ip4 input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x0000003a ]
+  [ payload load 1b @ transport header + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00000086 ]
+
 # meta mark 0x4
 ip test-ip4 input
   [ meta load mark => reg 1 ]
-- 
2.13.0

