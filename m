Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0256DC433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 12 May 2022 10:33:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352653AbiELKdy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 12 May 2022 06:33:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352660AbiELKdx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 12 May 2022 06:33:53 -0400
Received: from mg.ssi.bg (mg.ssi.bg [193.238.174.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2F29D223876;
        Thu, 12 May 2022 03:33:51 -0700 (PDT)
Received: from mg.ssi.bg (localhost [127.0.0.1])
        by mg.ssi.bg (Proxmox) with ESMTP id 27B1F100AB;
        Thu, 12 May 2022 13:33:50 +0300 (EEST)
Received: from ink.ssi.bg (unknown [193.238.174.40])
        by mg.ssi.bg (Proxmox) with ESMTP id B8C77100A6;
        Thu, 12 May 2022 13:33:48 +0300 (EEST)
Received: from ja.ssi.bg (unknown [178.16.129.10])
        by ink.ssi.bg (Postfix) with ESMTPS id 806553C07D0;
        Thu, 12 May 2022 13:33:44 +0300 (EEST)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.16.1/8.16.1) with ESMTP id 24CAXdov049309;
        Thu, 12 May 2022 13:33:40 +0300
Date:   Thu, 12 May 2022 13:33:39 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     Menglong Dong <menglong8.dong@gmail.com>
cc:     Simon Horman <horms@verge.net.au>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Menglong Dong <imagedong@tencent.com>,
        Jiang Biao <benbjiang@tencent.com>,
        Hao Peng <flyingpeng@tencent.com>
Subject: Re: [PATCH net-next v2] net: ipvs: randomize starting destination
 of RR/WRR scheduler
In-Reply-To: <CADxym3aREm=ZPucm=C6ZRnPbQJMvCxkcnKge2EAcy-Rs0CTtfg@mail.gmail.com>
Message-ID: <bb1d68e0-de27-985f-19b-208fb546a0b1@ssi.bg>
References: <20220510074301.480941-1-imagedong@tencent.com> <8983fedf-5095-59a4-b4b3-83f1864be055@ssi.bg> <CADxym3aREm=ZPucm=C6ZRnPbQJMvCxkcnKge2EAcy-Rs0CTtfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


	Hello,

On Thu, 12 May 2022, Menglong Dong wrote:

> Yeah, WLC and MH are excellent schedulers. As for SH, my
> fellows' feedback says that it doesn't work well. In fact, it's their
> fault, they just forget to enable port hash and just use the
> default ip hash. With my direction, this case is solved by sh.
> 
> Now, I'm not sure if this feature is necessary. Maybe someone
> needs it? Such as someone, who need RR/WRR and a random
> start......

	If there is some more clever way to add randomness.
The problem is that random start should be applied after
initial configuration only. But there is no clear point between
where configuration is completed and when service starts.
This is not bad for RR but is bad for WRR.

	One way would be the user tool to add dests in random
order. IIRC, this should not affect setups with backup servers
as long as they share the same set of real servers, i.e.
order in svc->destinations does not matter for SYNC but
the real servers should be present in all directors.

	Another option would be __ip_vs_update_dest() to
use list_add_rcu() or list_add_tail_rcu() per dest depending
on some switch that enables random ordering for the svc.
But it will affect only schedulers that do not order
later the dests. So, it should help for RR, WRR (random
order per same weight). In this case, scheduler's code
is not affected.

	For RR, the scheduler does not use weights and
dests are usually not updated. But for WRR the weights
can be changed and this affects order of selection without
changing the order in svc->destinations.

	OTOH, WRR is a scheduler that can support frequent
update of dest weights. This is not true for MH which can
easily change only between 0 and some fixed weight without
changing its table. As result, ip_vs_wrr_dest_changed()
can be called frequently even after the initial configuration,
at the same time while packets are scheduled.

	When you mentioned that ip_vs_wrr_gcd_weight() is
slow, I see that ip_vs_wrr_dest_changed() can be improved
to reduce the time while holding the lock. May be
in separate patch we can call ip_vs_wrr_gcd_weight() and
ip_vs_wrr_max_weight() before the spin_lock_bh() by using
two new tmp vars.

> Anyway, I have made a V3 according to your advice. I can
> send it with any positive reply :/

	You can use [RFC tag] for this, so that we can
at least review it and further decide what can be done.

Regards

--
Julian Anastasov <ja@ssi.bg>

