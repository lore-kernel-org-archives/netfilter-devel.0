Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE2E9C4167B
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Dec 2022 15:04:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235743AbiLVPEQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 22 Dec 2022 10:04:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235677AbiLVPDv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Dec 2022 10:03:51 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69DBD29376
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Dec 2022 07:03:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=vrOcR5W+sw+Ui0TfhuAlmjzkT8O5CZXu6a2l79YmScY=; b=O2RxCWoFzhIBz6G7+ipwE209qc
        s1SLnmVDHKD5ucZRPdbc+MokcGmyQ8NlNKREJcwXQg8vro4MG4THHqMVR9YvjqsFY3lsWgi4jjQ6m
        WZr2pBawyWHXhsu/u9IhsXk0FiA2oIrJQJEr0EEgG3SRx1YjcctvnujyVLtwEqGOYZEI3z/ugMI/D
        7jUF2vwhvAhN5rkCKALPQe+oJ+l5DzQmxawn6n48M9gWkJpGu+NDVd9ALaIUkS96UkDFFxOshjpP5
        Fkj/7wCLGJkuqGWjWuSRMnOmskurPs0jQJpQK6pa1wqeADjG9YAl+ABFMOHiWOI3iRfxgLLrNWSnq
        t2Z5RsBQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1p8N6N-0006is-4p; Thu, 22 Dec 2022 16:03:19 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Subject: [iptables PATCH] nft: Reject tcp/udp extension without proper protocol match
Date:   Thu, 22 Dec 2022 16:03:10 +0100
Message-Id: <20221222150310.10977-1-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Internally, 'th' expression is used, which works but matches both
protocols. Since users won't expect '-m tcp --dport 1' to match UDP
packets, catch missing/wrong '-p' argument.

Fixes: c034cf31dd1a9 ("nft: prefer native expressions instead of udp match")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_tcp.t | 3 +++
 extensions/libxt_udp.t | 3 +++
 iptables/nft.c         | 6 ++++++
 3 files changed, 12 insertions(+)

diff --git a/extensions/libxt_tcp.t b/extensions/libxt_tcp.t
index b0e8006e51869..7a3bbd08952f0 100644
--- a/extensions/libxt_tcp.t
+++ b/extensions/libxt_tcp.t
@@ -22,5 +22,8 @@
 -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG SYN;=;OK
 -p tcp -m tcp ! --tcp-flags FIN,SYN,RST,PSH,ACK,URG SYN;=;OK
 -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG RST;=;OK
+-m tcp --dport 1;;FAIL
+-m tcp --dport 1 -p tcp;-p tcp -m tcp --dport 1;OK
+-m tcp --dport 1 -p 6;-p tcp -m tcp --dport 1;OK
 # should we accept this below?
 -p tcp -m tcp;=;OK
diff --git a/extensions/libxt_udp.t b/extensions/libxt_udp.t
index 1b4d3dd625759..f534770191a6e 100644
--- a/extensions/libxt_udp.t
+++ b/extensions/libxt_udp.t
@@ -18,5 +18,8 @@
 # -p udp -m udp --sport 65536;;FAIL
 -p udp -m udp --sport -1;;FAIL
 -p udp -m udp --dport -1;;FAIL
+-m udp --dport 1;;FAIL
+-m udp --dport 1 -p udp;-p udp -m udp --dport 1;OK
+-m udp --dport 1 -p 17;-p udp -m udp --dport 1;OK
 # should we accept this below?
 -p udp -m udp;=;OK
diff --git a/iptables/nft.c b/iptables/nft.c
index 430888e864a5f..63468cf3b1344 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1360,6 +1360,9 @@ static int add_nft_udp(struct nft_handle *h, struct nftnl_rule *r,
 		return ret;
 	}
 
+	if (nftnl_rule_get_u32(r, NFTNL_RULE_COMPAT_PROTO) != IPPROTO_UDP)
+		xtables_error(PARAMETER_PROBLEM, "UDP match requires '-p udp'");
+
 	return add_nft_tcpudp(h, r, udp->spts, udp->invflags & XT_UDP_INV_SRCPT,
 			      udp->dpts, udp->invflags & XT_UDP_INV_DSTPT);
 }
@@ -1410,6 +1413,9 @@ static int add_nft_tcp(struct nft_handle *h, struct nftnl_rule *r,
 		return ret;
 	}
 
+	if (nftnl_rule_get_u32(r, NFTNL_RULE_COMPAT_PROTO) != IPPROTO_TCP)
+		xtables_error(PARAMETER_PROBLEM, "TCP match requires '-p tcp'");
+
 	if (tcp->flg_mask) {
 		int ret = add_nft_tcpflags(h, r, tcp->flg_cmp, tcp->flg_mask,
 					   tcp->invflags & XT_TCP_INV_FLAGS);
-- 
2.38.0

