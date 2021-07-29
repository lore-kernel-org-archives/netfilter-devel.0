Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88556C4338F
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Jul 2021 06:55:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 644E861055
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Jul 2021 06:55:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234161AbhG2Gzz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 02:55:55 -0400
Received: from mail.netfilter.org ([217.70.188.207]:40358 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234079AbhG2Gzz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 02:55:55 -0400
Received: from netfilter.org (bl11-146-165.dsl.telepac.pt [85.244.146.165])
        by mail.netfilter.org (Postfix) with ESMTPSA id 579A46164A;
        Thu, 29 Jul 2021 08:55:20 +0200 (CEST)
Date:   Thu, 29 Jul 2021 08:55:46 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Tom Yan <tom.ty89@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 2/3] netlink_linearize: incorrect netlink bytecode
 with binary operation and flags
Message-ID: <20210729065546.GA15962@salvia>
References: <20210727153741.14406-1-pablo@netfilter.org>
 <20210727153741.14406-2-pablo@netfilter.org>
 <CAGnHSE=e-iYaz3KOMBq1JSVRd0HTL=TKQ_HHMadfyd2Nr8__yg@mail.gmail.com>
 <20210727210503.GA15429@salvia>
 <CAGnHSEnxcVjN2etN-LNCgpb1h_hmSWMMh3Zm-GqbkZ0XOxCN-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAGnHSEnxcVjN2etN-LNCgpb1h_hmSWMMh3Zm-GqbkZ0XOxCN-w@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jul 29, 2021 at 10:57:35AM +0800, Tom Yan wrote:
> On Wed, 28 Jul 2021 at 05:05, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
[...]
> > A quick summary:
> >
> > - If you want an exact match:
> >
> > tcp flags == fin,syn,ack
> >
> > - If you want to check that those three bits are set on (regardless
> >   the remaining bits):
> >
> > tcp flags fin,syn,ack / fin,syn,ack
> >
> > - If you want to check that any of these three bits is set on:
> >
> > tcp flags fin,syn,ack
> 
> This is exactly what I find absurd btw. IMHO it's much better if the
> latter just means `tcp flags == (fin | syn | ack)`.

Look at this from a different angle, ie. ct state

        ct state new,established

ct state also has a bitmask datatype, and people are not expecting
here to match to new AND established.

> I'd rather we keep `tcp flags & (fin | syn | ack) != 0` and so
> "unsimplified" or accept something like `tcp flags { fin / fin, syn
> / syn, ack / ack }`

The curly brace notation implies the use of sets. Sets only allow for
exact matches, therefore

tcp flags { fin, syn, ack}

is actually making exact matches on the tcp flags.
