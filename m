Return-Path: <SRS0=aqP0=2Y=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8102BC2D0C2
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Jan 2020 17:13:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FD4D20866
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Jan 2020 17:13:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728314AbgACRMp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Jan 2020 12:12:45 -0500
Received: from correo.us.es ([193.147.175.20]:47292 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728296AbgACRMo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Jan 2020 12:12:44 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CDB521E2C64
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Jan 2020 18:12:41 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BC902DA702
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Jan 2020 18:12:41 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B2401DA703; Fri,  3 Jan 2020 18:12:41 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 85C90DA702;
        Fri,  3 Jan 2020 18:12:39 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 03 Jan 2020 18:12:39 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 68DA6426CCB9;
        Fri,  3 Jan 2020 18:12:39 +0100 (CET)
Date:   Fri, 3 Jan 2020 18:12:39 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu <wenxu@ucloud.cn>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nft_flow_offload: fix unnecessary use
 counter decrease in destory
Message-ID: <20200103171239.stghnammtqmyrzm5@salvia>
References: <1576832926-4268-1-git-send-email-wenxu@ucloud.cn>
 <c9e07a82-ea38-d0bc-3ffa-cb0b5bc7ff95@ucloud.cn>
 <20191230200245.wr3tknzvduzecvaw@salvia>
 <71d4dbd8-e7a7-82f1-d246-e61129de00b1@ucloud.cn>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="xdeqmjrzrscq5if2"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <71d4dbd8-e7a7-82f1-d246-e61129de00b1@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--xdeqmjrzrscq5if2
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Dec 31, 2019 at 08:45:27AM +0800, wenxu wrote:
> 
> 在 2019/12/31 4:02, Pablo Neira Ayuso 写道:
> > On Mon, Dec 30, 2019 at 09:25:36PM +0800, wenxu wrote:
> > > Hi pablo,
> > > 
> > > How about this patch?
> > This test still fails after a second run with this patch:
> > 
> > ./run-tests.sh testcases/flowtable/0009deleteafterflush_0
> > I: using nft binary ./../../src/nft
> > 
> > W: [FAILED]     testcases/flowtable/0009deleteafterflush_0: got 1
> > Error: Could not process rule: Device or resource busy
> > delete flowtable x f
> 
> Hi pablo,
> 
> I did the same test for testcase 0009deleteafterflush_0, It is okay even
> there is no this patch in my tree.

Thanks, I'm going to apply the patch that I'm attaching to this email.

--xdeqmjrzrscq5if2
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-netfilter-nft_flow_offload-fix-underflow-in-flowtabl.patch"

From 7c79a32304ccd7ee33f672a3b543ef62a664ce5d Mon Sep 17 00:00:00 2001
From: wenxu <wenxu@ucloud.cn>
Date: Fri, 20 Dec 2019 17:08:46 +0800
Subject: [PATCH] netfilter: nft_flow_offload: fix underflow in flowtable
 reference counter

The .deactivate and .activate interfaces already deal with the reference
counter. Otherwise, this results in spurious "Device is busy" errors.

Fixes: a3c90f7a2323 ("netfilter: nf_tables: flow offload expression")
Signed-off-by: wenxu <wenxu@ucloud.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_flow_offload.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index dd82ff2ee19f..b70b48996801 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -200,9 +200,6 @@ static void nft_flow_offload_activate(const struct nft_ctx *ctx,
 static void nft_flow_offload_destroy(const struct nft_ctx *ctx,
 				     const struct nft_expr *expr)
 {
-	struct nft_flow_offload *priv = nft_expr_priv(expr);
-
-	priv->flowtable->use--;
 	nf_ct_netns_put(ctx->net, ctx->family);
 }
 
-- 
2.11.0


--xdeqmjrzrscq5if2--
