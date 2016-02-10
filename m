From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH] iptables: nft-ipv6: Fix ipv6 flags
Date: Wed, 10 Feb 2016 10:52:00 +0530
Message-ID: <20160210052200.GA11029@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:34371 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020AbcBJFWH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Feb 2016 00:22:07 -0500
Received: by mail-pa0-f41.google.com with SMTP id p2so1616420pav.1
        for <netfilter-devel@vger.kernel.org>; Tue, 09 Feb 2016 21:22:07 -0800 (PST)
Received: from gmail.com ([106.209.53.236])
        by smtp.gmail.com with ESMTPSA id a21sm1596440pfj.40.2016.02.09.21.22.05
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Tue, 09 Feb 2016 21:22:06 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Replace the flags with the correct ipv6 flags.

Details:
Ana found out the bug and submitted the patch, Shivani applied it
on the latest tree and compile tested it.

Signed-off-by: Ana Rey <anarey@gmail.com>
Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
 iptables/nft-ipv6.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index 77ac5b8..0ee7957 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -135,7 +135,7 @@ static void nft_ipv6_parse_payload(struct nft_xt_ctx *ctx,
 		}
 
 		if (inv)
-			cs->fw6.ipv6.invflags |= IPT_INV_SRCIP;
+			cs->fw6.ipv6.invflags |= IP6T_INV_SRCIP;
 		break;
 	case offsetof(struct ip6_hdr, ip6_dst):
 		get_cmp_data(e, &addr, sizeof(addr), &inv);
@@ -148,14 +148,14 @@ static void nft_ipv6_parse_payload(struct nft_xt_ctx *ctx,
 		}
 
 		if (inv)
-			cs->fw6.ipv6.invflags |= IPT_INV_DSTIP;
+			cs->fw6.ipv6.invflags |= IP6T_INV_DSTIP;
 		break;
 	case offsetof(struct ip6_hdr, ip6_nxt):
 		get_cmp_data(e, &proto, sizeof(proto), &inv);
 		cs->fw6.ipv6.flags |= IP6T_F_PROTO;
 		cs->fw6.ipv6.proto = proto;
 		if (inv)
-			cs->fw6.ipv6.invflags |= IPT_INV_PROTO;
+			cs->fw6.ipv6.invflags |= IP6T_INV_PROTO;
 	default:
 		DEBUGP("unknown payload offset %d\n", ctx->payload.offset);
 		break;
@@ -186,7 +186,7 @@ static void print_ipv6_addr(const struct iptables_command_state *cs,
 {
 	char buf[BUFSIZ];
 
-	fputc(cs->fw6.ipv6.invflags & IPT_INV_SRCIP ? '!' : ' ', stdout);
+	fputc(cs->fw6.ipv6.invflags & IP6T_INV_SRCIP ? '!' : ' ', stdout);
 	if (IN6_IS_ADDR_UNSPECIFIED(&cs->fw6.ipv6.src)
 	    && !(format & FMT_NUMERIC))
 		printf(FMT("%-19s ","%s "), "anywhere");
@@ -202,7 +202,7 @@ static void print_ipv6_addr(const struct iptables_command_state *cs,
 	}
 
 
-	fputc(cs->fw6.ipv6.invflags & IPT_INV_DSTIP ? '!' : ' ', stdout);
+	fputc(cs->fw6.ipv6.invflags & IP6T_INV_DSTIP ? '!' : ' ', stdout);
 	if (IN6_IS_ADDR_UNSPECIFIED(&cs->fw6.ipv6.dst)
 	    && !(format & FMT_NUMERIC))
 		printf(FMT("%-19s ","-> %s"), "anywhere");
@@ -266,9 +266,9 @@ static void nft_ipv6_save_firewall(const void *data, unsigned int format)
 			      cs->fw6.ipv6.outiface_mask);
 
 	save_ipv6_addr('s', &cs->fw6.ipv6.src,
-		       cs->fw6.ipv6.invflags & IPT_INV_SRCIP);
+		       cs->fw6.ipv6.invflags & IP6T_INV_SRCIP);
 	save_ipv6_addr('d', &cs->fw6.ipv6.dst,
-		       cs->fw6.ipv6.invflags & IPT_INV_DSTIP);
+		       cs->fw6.ipv6.invflags & IP6T_INV_DSTIP);
 
 	save_matches_and_target(cs->matches, cs->target,
 				cs->jumpto, cs->fw6.ipv6.flags, &cs->fw6);
-- 
1.9.1

