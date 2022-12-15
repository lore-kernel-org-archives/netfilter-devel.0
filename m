Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2725C4332F
	for <netfilter-devel@archiver.kernel.org>; Thu, 15 Dec 2022 16:18:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbiLOQSK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 15 Dec 2022 11:18:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiLOQSJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 15 Dec 2022 11:18:09 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48E1F25EBB
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Dec 2022 08:18:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=V4O+J6g/YYnc7WfVFDQvvQxB+GNuwFnvpaTf2NDtQAs=; b=epcjVLUC3S8fgqXHYRGwZr2p2R
        V41QhxPsJum9Nbl1BHIts55b8bJr53lkU2f5WbTF+ym408WAXaqTkF7eqcoggW6Mpivr1bD842jD1
        //awgu/ApZyQpOOGMGlAPIX3JXR61eI8g1bU0XrLRnLeVa2h9WSUF82nnfjb7CBGCoovancmTFSNb
        diOPzUpxYUTQFg6P6mzxs5T6k4+yTB5yIkIx5+EXhVM1wvRXQoCw7inrwmtpWi8i0u6lG2L4hLpO0
        qpyMO7ehp/TFxXrUvjVz9Brx3mEVVbo5d3e5VokI8KAUBfFl5FHsbZdS6SvOVse6jBX1CI2bS7etW
        OJ57t4Ng==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1p5qvs-0001tz-R7; Thu, 15 Dec 2022 17:18:04 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [iptables PATCH 1/4] nft: Parse icmp header matches
Date:   Thu, 15 Dec 2022 17:17:53 +0100
Message-Id: <20221215161756.3463-2-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221215161756.3463-1-phil@nwl.cc>
References: <20221215161756.3463-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

These were previously ignored.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-shared.c                         | 74 +++++++++++++++++++
 .../nft-only/0010-iptables-nft-save.txt       |  6 +-
 2 files changed, 77 insertions(+), 3 deletions(-)

diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 56acbd4555f4b..d4b21921077d9 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -833,6 +833,65 @@ static void nft_parse_tcp(struct nft_xt_ctx *ctx,
 				   op, dport, XT_TCP_INV_DSTPT);
 }
 
+static void nft_parse_icmp(struct nft_xt_ctx *ctx,
+			   struct iptables_command_state *cs,
+			   struct nft_xt_ctx_reg *sreg,
+			   uint8_t op, const char *data, size_t dlen)
+{
+	struct xtables_match *match;
+	struct ipt_icmp icmp = {
+		.type = UINT8_MAX,
+		.code = { 0, UINT8_MAX },
+	};
+
+	if (dlen < 1)
+		goto out_err_len;
+
+	switch (sreg->payload.offset) {
+	case 0:
+		icmp.type = data[0];
+		if (dlen == 1)
+			break;
+		dlen--;
+		data++;
+		/* fall through */
+	case 1:
+		if (dlen > 1)
+			goto out_err_len;
+		icmp.code[0] = icmp.code[1] = data[0];
+		break;
+	default:
+		ctx->errmsg = "unexpected payload offset";
+		return;
+	}
+
+	switch (ctx->h->family) {
+	case NFPROTO_IPV4:
+		match = nft_create_match(ctx, cs, "icmp");
+		break;
+	case NFPROTO_IPV6:
+		if (icmp.type == UINT8_MAX) {
+			ctx->errmsg = "icmp6 code with any type match not supported";
+			return;
+		}
+		match = nft_create_match(ctx, cs, "icmp6");
+		break;
+	default:
+		ctx->errmsg = "unexpected family for icmp match";
+		return;
+	}
+
+	if (!match) {
+		ctx->errmsg = "icmp match extension not found";
+		return;
+	}
+	memcpy(match->m->data, &icmp, sizeof(icmp));
+	return;
+
+out_err_len:
+	ctx->errmsg = "unexpected RHS data length";
+}
+
 static void nft_parse_th_port(struct nft_xt_ctx *ctx,
 			      struct iptables_command_state *cs,
 			      uint8_t proto,
@@ -915,6 +974,21 @@ static void nft_parse_transport(struct nft_xt_ctx *ctx,
 		return;
 	}
 
+	switch (proto) {
+	case IPPROTO_UDP:
+	case IPPROTO_TCP:
+		break;
+	case IPPROTO_ICMP:
+	case IPPROTO_ICMPV6:
+		nft_parse_icmp(ctx, cs, sreg, op,
+			       nftnl_expr_get(e, NFTNL_EXPR_CMP_DATA, &len),
+			       len);
+		return;
+	default:
+		ctx->errmsg = "unsupported layer 4 protocol value";
+		return;
+	}
+
 	switch(sreg->payload.offset) {
 	case 0: /* th->sport */
 		switch (len) {
diff --git a/iptables/tests/shell/testcases/nft-only/0010-iptables-nft-save.txt b/iptables/tests/shell/testcases/nft-only/0010-iptables-nft-save.txt
index 73d7108c5094e..5ee4c23113aa8 100644
--- a/iptables/tests/shell/testcases/nft-only/0010-iptables-nft-save.txt
+++ b/iptables/tests/shell/testcases/nft-only/0010-iptables-nft-save.txt
@@ -13,9 +13,9 @@
 -A INPUT -d 0.0.0.0/2 -m ttl --ttl-gt 2 -j ACCEPT
 -A INPUT -d 0.0.0.0/3 -m ttl --ttl-lt 254 -j ACCEPT
 -A INPUT -d 0.0.0.0/4 -m ttl ! --ttl-eq 255 -j DROP
--A INPUT -d 8.0.0.0/5 -p icmp -j ACCEPT
--A INPUT -d 8.0.0.0/6 -p icmp -j ACCEPT
--A INPUT -d 10.0.0.0/7 -p icmp -j ACCEPT
+-A INPUT -d 8.0.0.0/5 -p icmp -m icmp --icmp-type 1 -j ACCEPT
+-A INPUT -d 8.0.0.0/6 -p icmp -m icmp --icmp-type 2/3 -j ACCEPT
+-A INPUT -d 10.0.0.0/7 -p icmp -m icmp --icmp-type 8 -j ACCEPT
 -A INPUT -m pkttype --pkt-type broadcast -j ACCEPT
 -A INPUT -m pkttype ! --pkt-type unicast -j DROP
 -A INPUT -p tcp
-- 
2.38.0

