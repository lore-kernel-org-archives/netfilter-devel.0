Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15A1FC11F65
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Jun 2021 09:54:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDB3C61D0F
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Jun 2021 09:54:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234018AbhF3J4c (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Jun 2021 05:56:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233943AbhF3J4c (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Jun 2021 05:56:32 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93E84C061756;
        Wed, 30 Jun 2021 02:54:03 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1lyWuv-0008Ii-LG; Wed, 30 Jun 2021 11:54:01 +0200
Date:   Wed, 30 Jun 2021 11:54:01 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Vasily Averin <vvs@virtuozzo.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH NETFILTER] netfilter: gre: nf_ct_gre_keymap_flush()
 removal
Message-ID: <20210630095401.GB18022@breakpoint.cc>
References: <cb5dbf85-302d-386d-7b57-b043063cea06@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb5dbf85-302d-386d-7b57-b043063cea06@virtuozzo.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Vasily Averin <vvs@virtuozzo.com> wrote:
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

Acked-by: Florian Westphal <fw@strlen.de>
