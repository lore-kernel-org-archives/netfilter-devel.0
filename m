Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB017C4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Nov 2022 01:41:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbiKCBl0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Nov 2022 21:41:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiKCBlZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Nov 2022 21:41:25 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CD4E1114D
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Nov 2022 18:41:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=kh0nCX/DnvyXSwKLzlshCoK3MKacGAWhUMR5ByFnhI0=; b=QtvqB92LQAjE/HlX00aVWk0qx3
        ZfNl90QjzG5g9TmgG8PIZaNghDb2z8Z2mj0Mnm27prbSdJAGYAbr/OCIXufc7ND5aIOXJdF9ZBjHZ
        Am3p93oWr93KAwn9OejGnO40fqjhnwQB9dhSc4y+EAxvSZvv8CV/G+JxWGPo+qfG6BusShvxxrRru
        3wqd5/cyLyAa6ZWB147vnWoEuOy0gQiMWpfIurrxpyPdDa5eDg8/IncYoanTjV3iIZ+a7tstgXTAA
        m4h2NP4rKw940gqgXIdY0nUQnvAWkXDAN1/x7raDRT7O3WpooNttZWUcjbCLUR6tANMG5GcXBYI2m
        27kqLzxg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1oqPEP-0005Fm-P5
        for netfilter-devel@vger.kernel.org; Thu, 03 Nov 2022 02:41:21 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 2/6] extensions: *NAT: Drop NF_NAT_RANGE_PROTO_RANDOM* flag checks
Date:   Thu,  3 Nov 2022 02:41:09 +0100
Message-Id: <20221103014113.10851-3-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221103014113.10851-1-phil@nwl.cc>
References: <20221103014113.10851-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

SNAT, DNAT and REDIRECT extensions tried to prevent
NF_NAT_RANGE_PROTO_RANDOM flag from being set if no port or address was
also given.

With SNAT and DNAT, this is not possible as the respective
--to-destination or --to-source parameters are mandatory anyway.

Looking at the kernel code, doing so with REDIRECT seems harmless.
Moreover, nftables supports 'redirect random' without specifying a
port-range.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libip6t_SNAT.c        | 20 +++++---------------
 extensions/libipt_SNAT.c         | 16 ++++++----------
 extensions/libxt_DNAT.c          | 28 ++++------------------------
 extensions/libxt_REDIRECT.t      |  1 +
 extensions/libxt_REDIRECT.txlate |  3 +++
 5 files changed, 19 insertions(+), 49 deletions(-)

diff --git a/extensions/libip6t_SNAT.c b/extensions/libip6t_SNAT.c
index 4fe272b262a3d..8bf7b035f84b6 100644
--- a/extensions/libip6t_SNAT.c
+++ b/extensions/libip6t_SNAT.c
@@ -20,9 +20,6 @@ enum {
 	O_RANDOM,
 	O_RANDOM_FULLY,
 	O_PERSISTENT,
-	F_TO_SRC       = 1 << O_TO_SRC,
-	F_RANDOM       = 1 << O_RANDOM,
-	F_RANDOM_FULLY = 1 << O_RANDOM_FULLY,
 };
 
 static void SNAT_help(void)
@@ -166,19 +163,13 @@ static void SNAT_parse(struct xt_option_call *cb)
 	case O_PERSISTENT:
 		range->flags |= NF_NAT_RANGE_PERSISTENT;
 		break;
-	}
-}
-
-static void SNAT_fcheck(struct xt_fcheck_call *cb)
-{
-	static const unsigned int f = F_TO_SRC | F_RANDOM;
-	static const unsigned int r = F_TO_SRC | F_RANDOM_FULLY;
-	struct nf_nat_range *range = cb->data;
-
-	if ((cb->xflags & f) == f)
+	case O_RANDOM:
 		range->flags |= NF_NAT_RANGE_PROTO_RANDOM;
-	if ((cb->xflags & r) == r)
+		break;
+	case O_RANDOM_FULLY:
 		range->flags |= NF_NAT_RANGE_PROTO_RANDOM_FULLY;
+		break;
+	}
 }
 
 static void print_range(const struct nf_nat_range *range)
@@ -295,7 +286,6 @@ static struct xtables_target snat_tg_reg = {
 	.userspacesize	= XT_ALIGN(sizeof(struct nf_nat_range)),
 	.help		= SNAT_help,
 	.x6_parse	= SNAT_parse,
-	.x6_fcheck	= SNAT_fcheck,
 	.print		= SNAT_print,
 	.save		= SNAT_save,
 	.x6_options	= SNAT_opts,
diff --git a/extensions/libipt_SNAT.c b/extensions/libipt_SNAT.c
index 211a20bc45bfe..9c8cdb46a1585 100644
--- a/extensions/libipt_SNAT.c
+++ b/extensions/libipt_SNAT.c
@@ -13,9 +13,6 @@ enum {
 	O_RANDOM,
 	O_RANDOM_FULLY,
 	O_PERSISTENT,
-	F_TO_SRC       = 1 << O_TO_SRC,
-	F_RANDOM       = 1 << O_RANDOM,
-	F_RANDOM_FULLY = 1 << O_RANDOM_FULLY,
 };
 
 static void SNAT_help(void)
@@ -141,20 +138,19 @@ static void SNAT_parse(struct xt_option_call *cb)
 	case O_PERSISTENT:
 		mr->range->flags |= NF_NAT_RANGE_PERSISTENT;
 		break;
+	case O_RANDOM:
+		mr->range->flags |= NF_NAT_RANGE_PROTO_RANDOM;
+		break;
+	case O_RANDOM_FULLY:
+		mr->range->flags |= NF_NAT_RANGE_PROTO_RANDOM_FULLY;
+		break;
 	}
 }
 
 static void SNAT_fcheck(struct xt_fcheck_call *cb)
 {
-	static const unsigned int f = F_TO_SRC | F_RANDOM;
-	static const unsigned int r = F_TO_SRC | F_RANDOM_FULLY;
 	struct nf_nat_ipv4_multi_range_compat *mr = cb->data;
 
-	if ((cb->xflags & f) == f)
-		mr->range->flags |= NF_NAT_RANGE_PROTO_RANDOM;
-	if ((cb->xflags & r) == r)
-		mr->range->flags |= NF_NAT_RANGE_PROTO_RANDOM_FULLY;
-
 	mr->rangesize = 1;
 }
 
diff --git a/extensions/libxt_DNAT.c b/extensions/libxt_DNAT.c
index 7bfefc7961fac..af44518798aef 100644
--- a/extensions/libxt_DNAT.c
+++ b/extensions/libxt_DNAT.c
@@ -31,9 +31,6 @@ enum {
 	O_TO_PORTS,
 	O_RANDOM,
 	O_PERSISTENT,
-	F_TO_DEST  = 1 << O_TO_DEST,
-	F_TO_PORTS = 1 << O_TO_PORTS,
-	F_RANDOM   = 1 << O_RANDOM,
 };
 
 static void DNAT_help(void)
@@ -229,6 +226,9 @@ static void __DNAT_parse(struct xt_option_call *cb, __u16 proto,
 	case O_PERSISTENT:
 		range->flags |= NF_NAT_RANGE_PERSISTENT;
 		break;
+	case O_RANDOM:
+		range->flags |= NF_NAT_RANGE_PROTO_RANDOM;
+		break;
 	}
 }
 
@@ -250,21 +250,12 @@ static void DNAT_parse(struct xt_option_call *cb)
 		mr->range->max = range.max_proto;
 		/* fall through */
 	case O_PERSISTENT:
+	case O_RANDOM:
 		mr->range->flags |= range.flags;
 		break;
 	}
 }
 
-static void __DNAT_fcheck(struct xt_fcheck_call *cb, unsigned int *flags)
-{
-	static const unsigned int redir_f = F_TO_PORTS | F_RANDOM;
-	static const unsigned int dnat_f = F_TO_DEST | F_RANDOM;
-
-	if ((cb->xflags & redir_f) == redir_f ||
-	    (cb->xflags & dnat_f) == dnat_f)
-		*flags |= NF_NAT_RANGE_PROTO_RANDOM;
-}
-
 static void DNAT_fcheck(struct xt_fcheck_call *cb)
 {
 	struct nf_nat_ipv4_multi_range_compat *mr = cb->data;
@@ -274,8 +265,6 @@ static void DNAT_fcheck(struct xt_fcheck_call *cb)
 	if (mr->range[0].flags & NF_NAT_RANGE_PROTO_OFFSET)
 		xtables_error(PARAMETER_PROBLEM,
 			      "Shifted portmap ranges not supported with this kernel");
-
-	__DNAT_fcheck(cb, &mr->range[0].flags);
 }
 
 static char *sprint_range(const struct nf_nat_range2 *r, int family)
@@ -388,11 +377,6 @@ static void DNAT_parse_v2(struct xt_option_call *cb)
 	__DNAT_parse(cb, entry->ip.proto, cb->data, AF_INET);
 }
 
-static void DNAT_fcheck_v2(struct xt_fcheck_call *cb)
-{
-	__DNAT_fcheck(cb, &((struct nf_nat_range2 *)cb->data)->flags);
-}
-
 static void DNAT_print_v2(const void *ip, const struct xt_entry_target *target,
                        int numeric)
 {
@@ -428,8 +412,6 @@ static void DNAT_fcheck6(struct xt_fcheck_call *cb)
 	if (range->flags & NF_NAT_RANGE_PROTO_OFFSET)
 		xtables_error(PARAMETER_PROBLEM,
 			      "Shifted portmap ranges not supported with this kernel");
-
-	__DNAT_fcheck(cb, &range->flags);
 }
 
 static void DNAT_print6(const void *ip, const struct xt_entry_target *target,
@@ -619,7 +601,6 @@ static struct xtables_target dnat_tg_reg[] = {
 		.print		= DNAT_print_v2,
 		.save		= DNAT_save_v2,
 		.x6_parse	= DNAT_parse_v2,
-		.x6_fcheck	= DNAT_fcheck_v2,
 		.x6_options	= DNAT_opts,
 		.xlate		= DNAT_xlate_v2,
 	},
@@ -634,7 +615,6 @@ static struct xtables_target dnat_tg_reg[] = {
 		.print		= DNAT_print6_v2,
 		.save		= DNAT_save6_v2,
 		.x6_parse	= DNAT_parse6_v2,
-		.x6_fcheck	= DNAT_fcheck_v2,
 		.x6_options	= DNAT_opts,
 		.xlate		= DNAT_xlate6_v2,
 	},
diff --git a/extensions/libxt_REDIRECT.t b/extensions/libxt_REDIRECT.t
index f607dd0a12c51..362efa8428ed4 100644
--- a/extensions/libxt_REDIRECT.t
+++ b/extensions/libxt_REDIRECT.t
@@ -14,3 +14,4 @@
 -p tcp -j REDIRECT --to-ports ftp-ssh;;FAIL
 -p tcp -j REDIRECT --to-ports 10-ssh;;FAIL
 -j REDIRECT --to-ports 42;;FAIL
+-j REDIRECT --random;=;OK
diff --git a/extensions/libxt_REDIRECT.txlate b/extensions/libxt_REDIRECT.txlate
index 2c536495b35a2..36419a46bb366 100644
--- a/extensions/libxt_REDIRECT.txlate
+++ b/extensions/libxt_REDIRECT.txlate
@@ -16,6 +16,9 @@ nft add rule ip nat prerouting tcp dport 80 counter redirect to :10-22
 iptables-translate -t nat -A prerouting -p tcp --dport 80 -j REDIRECT --to-ports 8080 --random
 nft add rule ip nat prerouting tcp dport 80 counter redirect to :8080 random
 
+iptables-translate -t nat -A prerouting -j REDIRECT --random
+nft add rule ip nat prerouting counter redirect random
+
 ip6tables-translate -t nat -A prerouting -p tcp --dport 80 -j REDIRECT
 nft add rule ip6 nat prerouting tcp dport 80 counter redirect
 
-- 
2.38.0

