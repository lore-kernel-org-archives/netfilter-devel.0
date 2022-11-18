Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EF48C4332F
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Nov 2022 09:41:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242066AbiKRJlt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 18 Nov 2022 04:41:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241626AbiKRJlJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 18 Nov 2022 04:41:09 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EAE2397AAB
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Nov 2022 01:40:34 -0800 (PST)
Date:   Fri, 18 Nov 2022 10:40:30 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v2 0/4] xt: Implement dump and restore support
Message-ID: <Y3dTDj6OgEkyP/WD@salvia>
References: <20221117174546.21715-1-phil@nwl.cc>
 <20221117211347.GB15714@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221117211347.GB15714@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Nov 17, 2022 at 10:13:47PM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > If nft can't translate a compat expression, dump it in a format that can
> > be restored later without losing data, thereby keeping the ruleset
> > intact.
> 
> Why? :-( This cements nft_compat.c forever.
>
> If we're goping to do it lets at least dump it properly,
> i.e.  nft ... add rule compat "-m conntrack --ctstate NEW".

We might have to support this mixed syntax forever.  I proposed this
long long time ago, when nftables was supporting ~25% of the iptables
feature-set. These days, where they are almost on par (actually
nftables being a lot more expressive than iptables), I am not sure it
makes sense to follow this path anymore.

Unless you refer to dumping a listing which nft cannot load as a way
to provide a listing that is comprehensible, but that cannot be loaded
by the user.

> At this time I'd rather like a time machine to prevent nft_compat.c from
> getting merged :-(

I agree we should have added native translations for iptables-nft
sooner, but it was never a priority for anyone so far.

This "forward compatibility" issue (pretending old tool versions can
interpret new revisions / features loaded by newer tool versions) we
are trying to deal is hard, we already discussed none of the other
existing tooling (ethtool, iproute2, etc.) supports for this.

If you prefer to go for the _USERDATA area as a last resort, I'm OK
with it, this requires no kernel patches, and it will be used only for
the "forward compatibility" scenario (last resort)

We can also resort on displaying the raw expressions, so the user gets
a meaningful output that cannot be loaded again.

I think this more or less a summary of what we discussed in the NFWS.
