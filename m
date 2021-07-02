Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C535EC11F67
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Jul 2021 00:56:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A56A861410
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Jul 2021 00:56:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234384AbhGBA7B (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Jul 2021 20:59:01 -0400
Received: from mail.netfilter.org ([217.70.188.207]:41992 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230369AbhGBA7B (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Jul 2021 20:59:01 -0400
Received: from netfilter.org (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id A781A60705;
        Fri,  2 Jul 2021 02:56:22 +0200 (CEST)
Date:   Fri, 2 Jul 2021 02:56:26 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Vasily Averin <vvs@virtuozzo.com>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH NETFILTER v2] netfilter: gre: nf_ct_gre_keymap_flush()
 removal
Message-ID: <20210702005626.GB29227@salvia>
References: <0e3cdbe6-33f7-60b0-64ca-72f6f6a42df8@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <0e3cdbe6-33f7-60b0-64ca-72f6f6a42df8@virtuozzo.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jul 01, 2021 at 08:02:24AM +0300, Vasily Averin wrote:
> nf_ct_gre_keymap_flush() is useless.
> It is called from nf_conntrack_cleanup_net_list() only and tries to remove
> nf_ct_gre_keymap entries from pernet gre keymap list. Though:
> a) at this point the list should already be empty, all its entries were
> deleted during the conntracks cleanup, because
> nf_conntrack_cleanup_net_list() executes nf_ct_iterate_cleanup(kill_all)
> before nf_conntrack_proto_pernet_fini():
>  nf_conntrack_cleanup_net_list
>   +- nf_ct_iterate_cleanup
>   |   nf_ct_put
>   |    nf_conntrack_put
>   |     nf_conntrack_destroy
>   |      destroy_conntrack
>   |       destroy_gre_conntrack
>   |        nf_ct_gre_keymap_destroy
>   `- nf_conntrack_proto_pernet_fini
>       nf_ct_gre_keymap_flush
> 
> b) Let's say we find that the keymap list is not empty. This means netns
> still has a conntrack associated with gre, in which case we should not free
> its memory, because this will lead to a double free and related crashes.
> However I doubt it could have gone unnoticed for years, obviously
> this does not happen in real life. So I think we can remove
> both nf_ct_gre_keymap_flush() and nf_conntrack_proto_pernet_fini().

Also applied.

I think nf_ct_gre_keymap_flush() became useless when the GRE was
de-modularized (built-in into nf_conntrack).
