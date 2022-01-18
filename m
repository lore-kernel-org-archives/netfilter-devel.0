Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4779C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jan 2022 01:23:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbiARBXv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Jan 2022 20:23:51 -0500
Received: from mail.netfilter.org ([217.70.188.207]:60690 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbiARBXu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jan 2022 20:23:50 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 3427D60027;
        Tue, 18 Jan 2022 02:20:53 +0100 (CET)
Date:   Tue, 18 Jan 2022 02:23:46 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH iptables v2 0/8] extensions: libxt_NFLOG: use nft
 back-end for iptables-nft
Message-ID: <YeYWorAwXOzoKVgn@salvia>
References: <20211001174142.1267726-1-jeremy@azazel.net>
 <YeQ0JeUznhEopHxI@azazel.net>
 <20220116190815.GB28638@breakpoint.cc>
 <YeVHs4oOQki9FIgj@orbyte.nwl.cc>
 <YeXlrL3v0CQJbxwD@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YeXlrL3v0CQJbxwD@azazel.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jan 17, 2022 at 09:54:52PM +0000, Jeremy Sowden wrote:
> On 2022-01-17, at 11:40:51 +0100, Phil Sutter wrote:
> > On Sun, Jan 16, 2022 at 08:08:15PM +0100, Florian Westphal wrote:
[...]
> > > Pablo, Phil, others -- what is your take?
> >
> > I think the change is OK if existing rulesets will continue to work
> > just as before and remain compatible with legacy. IMHO, new rulesets
> > created using iptables-nft may become incompatible if users explicitly
> > ask for it (e.g. by specifying an exceedingly long log prefix.
> >
> > What about --nflog-range? This series seems to drop support for it, at
> > least in the sense that ruleset dumps won't contain the option. In
> > theory, users could depend on identifying a specific rule via nflog
> > range value.
> 
> Fair enough.  I'll add a check so that nft is not used for targets that
> specify `--nflog-range`.

--nflog-range does work?

--nflog-size is used and can be mapped to 'snaplen' in nft_log.

Manpage also discourages the usage of --nflog-range for long time.

Not sure it is worth to add a different path for this case.
