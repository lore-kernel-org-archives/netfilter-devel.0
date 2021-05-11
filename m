Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B38B8C433B4
	for <netfilter-devel@archiver.kernel.org>; Tue, 11 May 2021 10:42:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8EAB0615FF
	for <netfilter-devel@archiver.kernel.org>; Tue, 11 May 2021 10:42:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbhEKKn7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 11 May 2021 06:43:59 -0400
Received: from mail.netfilter.org ([217.70.188.207]:56306 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231273AbhEKKn7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 11 May 2021 06:43:59 -0400
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id A7D7C6416E;
        Tue, 11 May 2021 12:42:03 +0200 (CEST)
Date:   Tue, 11 May 2021 12:42:49 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Arturo Borrero Gonzalez <arturo@netfilter.org>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        fw@strlen.de
Subject: Re: [PATCH nftables 2/2] src: add set element catch-all support
Message-ID: <20210511104249.GA18952@salvia>
References: <20210510165322.130181-1-pablo@netfilter.org>
 <20210510165322.130181-2-pablo@netfilter.org>
 <20210511082441.GN12403@orbyte.nwl.cc>
 <5fd6a58e-7fed-a1e8-c527-fae71873dc34@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5fd6a58e-7fed-a1e8-c527-fae71873dc34@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

I'll reply to both of you here. Cc'ing Florian.

On Tue, May 11, 2021 at 10:50:05AM +0200, Arturo Borrero Gonzalez wrote:
> On 5/11/21 10:24 AM, Phil Sutter wrote:
> > Hi Pablo,
> > 
> > On Mon, May 10, 2021 at 06:53:21PM +0200, Pablo Neira Ayuso wrote:
> > > Add a catchall expression (EXPR_SET_ELEM_CATCHALL).
> > > 
> > > Use the underscore (_) to represent the catch-all set element, e.g.
> > 
> > Why did you choose this over asterisk? We have the latter as wildcard
> > symbol already (although a bit limited), so I think it would be more
> > intuitive than underscore.

I looked at several programming languages, one of them is using it (a
very trendy one...), so I thought we have to use it / place it at the
deep core of Netfilter for this reason, even if it absolutely makes no
sense.

Actually, the real reason is that I was trying to reduce interactions
with bash, which most distros tend to use.

> Moreover,
> 
> instead of a symbol, perhaps an explicit word (string, like "default") may
> contribute to a more understandable syntax.

I also considered "default" to reduce interactions with bash, problem is
that it's likely to be a valid input value as a key, for example, there
are a few keys in /etc/iproute2/rt_* files that use default, and that
will clash with it.

So I'm more inclined to Phil's proposal to use asterisk, even if it
needs to be escaped in bash, I'll send a v2.
