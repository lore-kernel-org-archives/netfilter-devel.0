Return-Path: <SRS0=8OCJ=4F=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBA39C34022
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Feb 2020 15:02:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ADEDF20801
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Feb 2020 15:02:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729392AbgBQPCH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Feb 2020 10:02:07 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:41370 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729347AbgBQPCH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Feb 2020 10:02:07 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1j3huP-0001ig-Le; Mon, 17 Feb 2020 16:02:05 +0100
Date:   Mon, 17 Feb 2020 16:02:05 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 2/2] netfilter: nf_tables: make all set structs
 const
Message-ID: <20200217150205.GD19559@breakpoint.cc>
References: <20200217095359.22791-1-fw@strlen.de>
 <20200217095359.22791-3-fw@strlen.de>
 <20200217155048.00c477a3@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200217155048.00c477a3@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Stefano Brivio <sbrivio@redhat.com> wrote:
> > -struct nft_set_type nft_set_pipapo_type __read_mostly = {
> > -	.owner		= THIS_MODULE,
> > +const struct nft_set_type nft_set_pipapo_type __read_mostly = {
> 
> const ... read_mostly should make no sense because const already forces
> the data to a read-only segment. It might actually cause some issues,
> see https://lore.kernel.org/patchwork/patch/439824/.
> 
> It's not there for the other set types, so I'm assuming it's a typo :)

Grrr, thanks for noticing.  This came from an old branch that
was before pipapo got merged.

I will wait some more and then send a v2.
