Return-Path: <SRS0=FqmY=XS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42716C4CEC4
	for <netfilter-devel@archiver.kernel.org>; Mon, 23 Sep 2019 16:46:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 191192054F
	for <netfilter-devel@archiver.kernel.org>; Mon, 23 Sep 2019 16:46:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437503AbfIWQqX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 23 Sep 2019 12:46:23 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:40088 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395280AbfIWQqX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 23 Sep 2019 12:46:23 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1iCRTh-0005kc-SW; Mon, 23 Sep 2019 18:46:21 +0200
Date:   Mon, 23 Sep 2019 18:46:21 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 07/14] nft Increase mnl_talk() receive buffer
 size
Message-ID: <20190923164621.GO9943@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20190916165000.18217-1-phil@nwl.cc>
 <20190916165000.18217-8-phil@nwl.cc>
 <20190920111329.g6nuxbpovzrtq2aq@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190920111329.g6nuxbpovzrtq2aq@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Fri, Sep 20, 2019 at 01:13:29PM +0200, Pablo Neira Ayuso wrote:
> On Mon, Sep 16, 2019 at 06:49:53PM +0200, Phil Sutter wrote:
> > This improves cache population quite a bit and therefore helps when
> > dealing with large rulesets. A simple hard to improve use-case is
> > listing the last rule in a large chain. These are the average program
> > run times depending on number of rules:
> > 
> > rule count	| legacy	| nft old	| nft new
> > ---------------------------------------------------------
> >  50,000		| .052s		| .611s		| .406s
> > 100,000		| .115s		| 2.12s		| 1.24s
> > 150,000		| .265s		| 7.63s		| 4.14s
> > 200,000		| .411s		| 21.0s		| 10.6s
> > 
> > So while legacy iptables is still magnitudes faster, this simple change
> > doubles iptables-nft performance in ideal cases.
> > 
> > Note that increasing the buffer even further didn't improve performance
> > anymore, so 32KB seems to be an upper limit in kernel space.
> 
> Here are the details for this 32 KB number:

Thanks for those!

[...]
> iproute2 is also using 32 KBytes buffer, in case you want to append
> this to your commit description before pushing this out.

Commit message adjusted and pushed.

Thanks, Phil
