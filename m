Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEB26C61DA3
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Feb 2023 23:25:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbjBUXZo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Feb 2023 18:25:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbjBUXZo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Feb 2023 18:25:44 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C07A030291;
        Tue, 21 Feb 2023 15:25:37 -0800 (PST)
Date:   Wed, 22 Feb 2023 00:25:34 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@openvz.org
Subject: Re: [PATCH] netfilter: fix percpu counter block leak on error path
 when creating new netns
Message-ID: <Y/VS7okXF1c6rN/I@salvia>
References: <20230213042505.334898-1-ptikhomirov@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230213042505.334898-1-ptikhomirov@virtuozzo.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Mon, Feb 13, 2023 at 12:25:05PM +0800, Pavel Tikhomirov wrote:
> Here is the stack where we allocate percpu counter block:
> 
>   +-< __alloc_percpu
>     +-< xt_percpu_counter_alloc
>       +-< find_check_entry # {arp,ip,ip6}_tables.c
>         +-< translate_table
> 
> And it can be leaked on this code path:
> 
>   +-> ip6t_register_table
>     +-> translate_table # allocates percpu counter block
>     +-> xt_register_table # fails
> 
> there is no freeing of the counter block on xt_register_table fail.
> Note: xt_percpu_counter_free should be called to free it like we do in
> do_replace through cleanup_entry helper (or in __ip6t_unregister_table).
> 
> Probability of hitting this error path is low AFAICS (xt_register_table
> can only return ENOMEM here, as it is not replacing anything, as we are
> creating new netns, and it is hard to imagine that all previous
> allocations succeeded and after that one in xt_register_table failed).
> But it's worth fixing even the rare leak.

Any suggestion as Fixes: tag here? This issue seems to be rather old?
