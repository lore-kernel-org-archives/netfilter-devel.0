Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC071C4338F
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Jul 2021 07:03:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 906C261040
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Jul 2021 07:03:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234461AbhG2HDx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 29 Jul 2021 03:03:53 -0400
Received: from mail.netfilter.org ([217.70.188.207]:40374 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234347AbhG2HDw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 03:03:52 -0400
Received: from netfilter.org (bl11-146-165.dsl.telepac.pt [85.244.146.165])
        by mail.netfilter.org (Postfix) with ESMTPSA id C89BD6164A;
        Thu, 29 Jul 2021 09:03:17 +0200 (CEST)
Date:   Thu, 29 Jul 2021 09:03:45 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Tom Yan <tom.ty89@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 2/3] netlink_linearize: incorrect netlink bytecode
 with binary operation and flags
Message-ID: <20210729070345.GB15962@salvia>
References: <20210727153741.14406-1-pablo@netfilter.org>
 <20210727153741.14406-2-pablo@netfilter.org>
 <CAGnHSE=e-iYaz3KOMBq1JSVRd0HTL=TKQ_HHMadfyd2Nr8__yg@mail.gmail.com>
 <20210727210503.GA15429@salvia>
 <CAGnHSEn_oyCqrUoNgKZyE3sO--5RMqkGhepGobSjGKTz1-0=vQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAGnHSEn_oyCqrUoNgKZyE3sO--5RMqkGhepGobSjGKTz1-0=vQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jul 29, 2021 at 09:48:21AM +0800, Tom Yan wrote:
> I'm not sure it's just me or you that are missing something here.
> 
> On Wed, 28 Jul 2021 at 05:05, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >
> > On Wed, Jul 28, 2021 at 02:36:18AM +0800, Tom Yan wrote:
> > > Hmm, that means `tcp flags & (fin | syn | rst | ack) syn` is now
> > > equivalent to 'tcp flags & (fin | syn | rst | ack) == syn'.
> >
> > Yes, those two are equivalent.
> >
> > > Does that mean `tcp flags syn` (was supposed to be and) is now
> > > equivalent to `tcp flags == syn`
> >
> > tcp flag syn
> >
> > is a shortcut to match on the syn bit regarless other bit values, it's
> > a property of the bitmask datatypes.
> 
> Don't you think the syntax will be inconsistent then? As a user, it
> looks pretty irrational to me: with a mask, just `syn` checks the
> exact value of the flags (combined); without a mask, it checks and
> checks only whether the specific bit is on.
> 
> At least to me I would then expect `tcp flags syn` should be
> equivalent / is a shortcut to `tcp flags & (fin | syn | rst | psh |
> ack | urg | ecn | cwr) syn` hence `tcp flags & (fin | syn | rst | psh
> | ack | urg | ecn | cwr) == syn` hence `tcp flags == syn`.

As I said, think of a different use-case:

        ct state new,established

people are _not_ expecting to match on both flags to be set on (that
will actually never happen).

Should ct state and tcp flags use the same syntax (comma-separated
values) but intepret things in a different way? I don't think so.

You can use:

        nft describe ct state

to check for the real datatype behind this selector: it's a bitmask.
For this datatype the implicit operation is not ==.

> > tcp flags == syn
> >
> > is an exact match, it checks that the syn bit is set on.
> >
> > > instead of `tcp flags & syn == syn` / `tcp flags & syn != 0`?
> >
> > these two above are equivalent, I just sent a patch to fix the
> > tcp flags & syn == syn case.
> >
> > > Suppose `tcp flags & syn != 0` should then be translated to `tcp flags
> > > syn / syn` instead, please note that while nft translates `tcp flags &
> > > syn == syn` to `tcp flags syn / syn`, it does not accept the
> > > translation as input (when the mask is not a comma-separated list):
> > >
> > > # nft --debug=netlink add rule meh tcp_flags 'tcp flags syn / syn'
> > > Error: syntax error, unexpected newline, expecting comma
> > > add rule meh tcp_flags tcp flags syn / syn
> > >                                           ^
> >
> > The most simple way to express this is: tcp flags == syn.
> 
> That does not sound right to me at all. Doesn't `syn / syn` means
> "with the mask (the second/"denominator" `syn`) applied on the flags,
> we get the value (the first/"nominator" `syn`), which means `tcp flags
> & syn == syn` instead of `tcp flags == syn` (which in turn means all
> bits but syn are cleared).

tcp flags syn / syn makes no sense, it's actually: tcp flags syn.

The goal is to provide a compact syntax for most common operations, so
users do not need to be mingling with explicit binary expressions
(which is considered to be a "more advanced" operation).
