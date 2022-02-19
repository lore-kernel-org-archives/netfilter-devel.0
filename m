Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1A4AC433F5
	for <netfilter-devel@archiver.kernel.org>; Sat, 19 Feb 2022 13:20:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbiBSNUz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 19 Feb 2022 08:20:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbiBSNUz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Feb 2022 08:20:55 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55E2D65409
        for <netfilter-devel@vger.kernel.org>; Sat, 19 Feb 2022 05:20:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=4MI4QUtZiYbB18K9/hz7sgkZn25T0nNpDY1xGkirbsk=; b=Oe4K1tx6tc0ccyyh4GgMPoh2qz
        aia5IqKZnCuj1CCX/1y5G5IHO6Ok5POJYUqc4TMvUFx3YBXAAqFBnFVgJeVGFuxgmj0qRQ9QJsfEl
        0wJgJjEG+vnWb/7Sk2TwFlA1+02LHYiDeIehrUVrkHHiLnLNYM/7LN7LHckdRL+iCzT2zP+/NoNw7
        3xPUlbVddn0Qr44utc/cpQ4XqnMNGgqUX5u7XLsYuU8xREmyC/ASLH73CQnuYwgZBMRDEBQ1hBKro
        /Ny0Fs072g6tBD/21G4bG/1aLQ6xGWGb20KIjFYO8UXz9H5NaTacx5uY3bazG+rWFu2+xHK6vPHBv
        0zWK7kzw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nLPf7-0002S3-6A; Sat, 19 Feb 2022 14:20:33 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: [nf-next PATCH] netfilter: conntrack: Relax helper auto-assignment warning for nftables
Date:   Sat, 19 Feb 2022 14:20:24 +0100
Message-Id: <20220219132024.29328-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

With nftables, no template is being used and instead helper assignment
happens after conntrack initialization. With helper auto assignment
being disabled by default, this leads to this spurious kernel log
suggesting to use iptables CT target.

To avoid the bogus and confusing message, check helper's refcount: It is
initialized to 1 by nf_conntrack_helper_register() and incremented by
nf_conntrack_helper_try_module_get() during nft_ct_helper_obj_init(). So
if its value is larger than 1, it must be in use *somewhere*.

This approach is not perfect since there is no guarantee the helper will
actually be assigned to the packet's flow. Yet it should still cover the
intended use-case of merely loading the module.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nf_conntrack_helper.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index ae4488a13c70c..828957f1802d8 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -213,11 +213,13 @@ static struct nf_conntrack_helper *
 nf_ct_lookup_helper(struct nf_conn *ct, struct net *net)
 {
 	struct nf_conntrack_net *cnet = nf_ct_pernet(net);
+	struct nf_conntrack_helper *helper =
+		__nf_ct_helper_find(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
 
 	if (!cnet->sysctl_auto_assign_helper) {
 		if (cnet->auto_assign_helper_warned)
 			return NULL;
-		if (!__nf_ct_helper_find(&ct->tuplehash[IP_CT_DIR_REPLY].tuple))
+		if (!helper || refcount_read(&helper->refcnt) > 1)
 			return NULL;
 		pr_info("nf_conntrack: default automatic helper assignment "
 			"has been turned off for security reasons and CT-based "
@@ -227,7 +229,7 @@ nf_ct_lookup_helper(struct nf_conn *ct, struct net *net)
 		return NULL;
 	}
 
-	return __nf_ct_helper_find(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
+	return helper;
 }
 
 int __nf_ct_try_assign_helper(struct nf_conn *ct, struct nf_conn *tmpl,
-- 
2.34.1

