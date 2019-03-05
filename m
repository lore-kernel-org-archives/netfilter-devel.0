Return-Path: <SRS0=Q+IM=RI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D158DC43381
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 Mar 2019 10:12:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1AC620684
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 Mar 2019 10:12:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727194AbfCEKM2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 5 Mar 2019 05:12:28 -0500
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:47964 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726107AbfCEKM2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 Mar 2019 05:12:28 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1h173h-0006xl-Tv; Tue, 05 Mar 2019 11:12:26 +0100
Date:   Tue, 5 Mar 2019 11:12:25 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Karuna Grewal <karunagrewal98@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: nft_meta: Extend support for
 NFT_META_TSTAMP_NS
Message-ID: <20190305101225.u72vgdapppkl24ce@breakpoint.cc>
References: <20190301104331.GA26805@nebula>
 <20190301110000.ofmenn5hjxf4nvb4@breakpoint.cc>
 <CAHRz_yZ4esKR2TJ=9AqtYbc5awDaNKHW6iuLXVLFZcuFAWLW1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHRz_yZ4esKR2TJ=9AqtYbc5awDaNKHW6iuLXVLFZcuFAWLW1Q@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Karuna Grewal <karunagrewal98@gmail.com> wrote:
> I've a doubt in the nftables implementation for implementing the `-m
> time` support.

Full -m time is complicated, do not worry about this yet.

> I'm unable to get a proper idea of where the start and
> stop time comparison with the dest register's value takes place.

Via the nftables evaluation loop.  You only need to worry about placing
the value (timestamp) in the dst register (on kernel side), so your
patch looks pretty complete aside from the missing 'break'.

Its userspace (nftables) responsibility to tell kernel to do something
with the register, such as a compare or range.

Have a look at
http://git.netfilter.org/nftables/commit/src/meta.c?id=512795a673f999fb04b84dbbbe41174e9c581430

It should be enough to follow this approach, adding e.g.
META_TEMPLATE("timestamp", ..

we have TYPE_TIME already, even though its a relative one, it
would/should work for a quick prototype.

> From my understanding of implementation, I've noticed that after
> parsing the rule and the meta expression is allocated, expression's
> primary evaluation function is invoked.
> Meanwhile, the kernel has the nft_meta_get_eval  function setting the
> register with the relevant field and in nf_tables_core.h  the
> registering of different nft_expr_types is accomplished.
> Could someone please give me some pointers about where this processing
> of the data set in the meta registers takes place?

For instance in nft_cmp.c, but thats just one possibility, there
are other consumers, such as nft_range.c, nft_lookup.c, and so on.
