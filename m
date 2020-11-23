Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B264C63697
	for <netfilter-devel@archiver.kernel.org>; Mon, 23 Nov 2020 19:05:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF052208B8
	for <netfilter-devel@archiver.kernel.org>; Mon, 23 Nov 2020 19:05:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729557AbgKWTEl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 23 Nov 2020 14:04:41 -0500
Received: from mg.ssi.bg ([178.16.128.9]:58590 "EHLO mg.ssi.bg"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728868AbgKWTEl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 23 Nov 2020 14:04:41 -0500
Received: from mg.ssi.bg (localhost [127.0.0.1])
        by mg.ssi.bg (Proxmox) with ESMTP id 29E92306C1
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Nov 2020 21:04:40 +0200 (EET)
Received: from ink.ssi.bg (ink.ssi.bg [178.16.128.7])
        by mg.ssi.bg (Proxmox) with ESMTP id 80016306B7
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Nov 2020 21:04:39 +0200 (EET)
Received: from ja.ssi.bg (unknown [178.16.129.10])
        by ink.ssi.bg (Postfix) with ESMTPS id 5A6F13C09BE;
        Mon, 23 Nov 2020 21:04:30 +0200 (EET)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id 0ANJ4RHZ004531;
        Mon, 23 Nov 2020 21:04:28 +0200
Date:   Mon, 23 Nov 2020 21:04:27 +0200 (EET)
From:   Julian Anastasov <ja@ssi.bg>
To:     "wanghai (M)" <wanghai38@huawei.com>
cc:     Simon Horman <horms@verge.net.au>, pablo@netfilter.org,
        christian@brauner.io, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net v2] ipvs: fix possible memory leak in
 ip_vs_control_net_init
In-Reply-To: <66825441-bb06-3d18-0424-df355d596c5f@huawei.com>
Message-ID: <9c409f4a-42df-1dd8-e69a-d5d3bab8d0c0@ssi.bg>
References: <20201120082610.60917-1-wanghai38@huawei.com> <21af4c92-8ca6-cce9-64bc-c4e88b6d1e8a@ssi.bg> <66825441-bb06-3d18-0424-df355d596c5f@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-1463811672-1178358999-1606158270=:3814"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811672-1178358999-1606158270=:3814
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT


	Hello,

On Mon, 23 Nov 2020, wanghai (M) wrote:

> 在 2020/11/22 19:20, Julian Anastasov 写道:
> >  Hello,
> >
> > On Fri, 20 Nov 2020, Wang Hai wrote:
> >
> >> +	if (!proc_create_net_single("ip_vs_stats_percpu", 0,
> >> ipvs->net->proc_net,
> >> +			ip_vs_stats_percpu_show, NULL))
> >> +		goto err_percpu;
> > 	Make sure the parameters are properly aligned to function open
> > parenthesis without exceeding 80 columns:
> >
> > linux# scripts/checkpatch.pl --strict /tmp/file.patch
> Thanks, I'll perfect it.
> > 	It was true only for first call due to some
> > renames for the others two in commit 3617d9496cd9 :(
> It does indeed rename in commit 3617d9496cd9.
> But I don't understand what's wrong with my patch here.

	Visually, they should look like this:

        if (!proc_create_net("ip_vs", 0, ipvs->net->proc_net,
                             &ip_vs_info_seq_ops, sizeof(struct ip_vs_iter)))
                goto err_vs;
        if (!proc_create_net_single("ip_vs_stats", 0, ipvs->net->proc_net,
                                    ip_vs_stats_show, NULL))
                goto err_stats;
        if (!proc_create_net_single("ip_vs_stats_percpu", 0,
                                    ipvs->net->proc_net,
                                    ip_vs_stats_percpu_show, NULL))
                goto err_percpu;

	The first one explained:

<1  TAB>if (!proc_create_net("ip_vs", 0, ipvs->net->proc_net,
<  open parenthesis is here  ^ and all next lines align to first parameter>
<1  TAB><1  TAB><1 TAB><5 SP>&ip_vs_info_seq_ops, sizeof(struct ip_vs_iter)))
<1  TAB><1  TAB>goto err_vs;

Regards

--
Julian Anastasov <ja@ssi.bg>
---1463811672-1178358999-1606158270=:3814--

