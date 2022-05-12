Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89049C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 12 May 2022 22:24:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356948AbiELWYH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 12 May 2022 18:24:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236178AbiELWYG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 12 May 2022 18:24:06 -0400
Received: from mg.ssi.bg (mg.ssi.bg [193.238.174.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2E710281348
        for <netfilter-devel@vger.kernel.org>; Thu, 12 May 2022 15:24:06 -0700 (PDT)
Received: from mg.ssi.bg (localhost [127.0.0.1])
        by mg.ssi.bg (Proxmox) with ESMTP id 8197E13C5D
        for <netfilter-devel@vger.kernel.org>; Fri, 13 May 2022 01:24:05 +0300 (EEST)
Received: from ink.ssi.bg (unknown [193.238.174.40])
        by mg.ssi.bg (Proxmox) with ESMTP id 65D0013C58
        for <netfilter-devel@vger.kernel.org>; Fri, 13 May 2022 01:24:04 +0300 (EEST)
Received: from ja.ssi.bg (unknown [178.16.129.10])
        by ink.ssi.bg (Postfix) with ESMTPS id 8CABF3C07C8;
        Fri, 13 May 2022 01:23:58 +0300 (EEST)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.16.1/8.16.1) with ESMTP id 24CMNqMj161753;
        Fri, 13 May 2022 01:23:54 +0300
Date:   Fri, 13 May 2022 01:23:52 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     Menglong Dong <menglong8.dong@gmail.com>
cc:     Simon Horman <horms@verge.net.au>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Menglong Dong <imagedong@tencent.com>
Subject: Re: [PATCH net-next] net: ipvs: random start for RR scheduler
In-Reply-To: <b8bf73ea-2ce9-2726-fde1-bd47d3b7a5d@ssi.bg>
Message-ID: <7e7b6a1-8d52-7274-e4b4-9b8ce3ddc4f9@ssi.bg>
References: <20220509122213.19508-1-imagedong@tencent.com> <cb8eaad0-83c5-a150-d830-e078682ba18b@ssi.bg> <CADxym3YH_76+5g29QF4Xp4gXJz5bwdQXD_gXv3esAVTgNGkXyg@mail.gmail.com> <b8bf73ea-2ce9-2726-fde1-bd47d3b7a5d@ssi.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


	Hello,

On Tue, 10 May 2022, Julian Anastasov wrote:

> 	What I see is that the value 128 is good but using
> 32 (MAX_STEP in the test) gives good enough results (3% diff).

	Looks like I forgot to add this example how to
reduce code under lock because add/del dest can run in
parallel with scheduling, something that is a drawback
in this solution:

+static void ip_vs_rr_random_start(struct ip_vs_service *svc)
+{
+	struct list_head *old = READ_ONCE(svc->sched_data), *cur = old;
+	u32 start;
+
+	if (!(svc->flags & IP_VS_SVC_F_SCHED_RR_RANDOM) ||
+		svc->num_dests <= 1)   
+		return;
+
+	start = prandom_u32_max(min(svc->num_dests, 32U));
+	while (start--)
+		cur = cur->next;
+	spin_lock_bh(&svc->sched_lock);
+	cmpxchg(&svc->sched_data, old, cur);
+	spin_unlock_bh(&svc->sched_lock);
+}

Regards

--
Julian Anastasov <ja@ssi.bg>

