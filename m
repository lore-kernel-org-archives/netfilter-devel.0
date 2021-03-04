Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79312C433DB
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Mar 2021 09:15:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44D7264F02
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Mar 2021 09:15:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237424AbhCDJM3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 4 Mar 2021 04:12:29 -0500
Received: from smtp2-g21.free.fr ([212.27.42.2]:40944 "EHLO smtp2-g21.free.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237428AbhCDJMR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 4 Mar 2021 04:12:17 -0500
Received: from r1.mshome.net (unknown [82.64.212.11])
        (Authenticated sender: linuxludo@free.fr)
        by smtp2-g21.free.fr (Postfix) with ESMTPSA id C223B20036C;
        Thu,  4 Mar 2021 10:10:51 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=free.fr;
        s=smtp-20201208; t=1614849061;
        bh=QgoT4mG2vtRqQM3Iyk6a/aM5PzvYQbJUKNtcpigXqo0=;
        h=Date:From:To:Cc:Subject:From;
        b=mJwExXVT3FJrI6yz2XNzrClzeChekDyaCY+S8QtMAmVLgX9XNtaqbIbCmu/9OHGvl
         Q+tRUgCxc0ShlfXkJNSYYVnndRK69Zdwz6nfsa8D1VghtPBsfK8rIWA/YkHlyeldyy
         LGA9L9Zl3Tge+q/kkhF2h7iiPcnhE1Jnxf+AlYechJ2xTD2ht2pc1J8TDQoVve9Pna
         HEaHLExEJPL0GZR3lnKJdpH80IKMB33xDkMF9nefysuLhGs5BQo4jGoZNnufF5NiNM
         SFpNyZSJhPmIpix9U0eP1Wo3B9SznCDP0ECdCzB+nAnfPw48FVO/JjHEbF6nz9NuFz
         2g7+19syVtblA==
Date:   Thu, 4 Mar 2021 04:10:50 -0500
From:   Ludovic Senecaux <linuxludo@free.fr>
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: [PATCH][nft,v2] conntrack: Fix gre tunneling over ipv6
Message-ID: <20210304090959.GA301692@r1.mshome.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This fix permits gre connections to be tracked within ip6tables rules

Signed-off-by: Ludovic Senecaux <linuxludo@free.fr>
---
 net/netfilter/nf_conntrack_proto_gre.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_gre.c b/net/netfilter/nf_conntrack_proto_gre.c
index 5b05487a60d2..db11e403d818 100644
--- a/net/netfilter/nf_conntrack_proto_gre.c
+++ b/net/netfilter/nf_conntrack_proto_gre.c
@@ -218,9 +218,6 @@ int nf_conntrack_gre_packet(struct nf_conn *ct,
 			    enum ip_conntrack_info ctinfo,
 			    const struct nf_hook_state *state)
 {
-	if (state->pf != NFPROTO_IPV4)
-		return -NF_ACCEPT;
-
 	if (!nf_ct_is_confirmed(ct)) {
 		unsigned int *timeouts = nf_ct_timeout_lookup(ct);
 
-- 
2.27.0

