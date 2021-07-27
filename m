Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5C43C4320E
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Jul 2021 21:05:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC60360F6E
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Jul 2021 21:05:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232208AbhG0VFL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 27 Jul 2021 17:05:11 -0400
Received: from mail.netfilter.org ([217.70.188.207]:36386 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232664AbhG0VFL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 27 Jul 2021 17:05:11 -0400
Received: from netfilter.org (bl11-146-165.dsl.telepac.pt [85.244.146.165])
        by mail.netfilter.org (Postfix) with ESMTPSA id 6B985642A7;
        Tue, 27 Jul 2021 23:04:39 +0200 (CEST)
Date:   Tue, 27 Jul 2021 23:05:03 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Tom Yan <tom.ty89@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 2/3] netlink_linearize: incorrect netlink bytecode
 with binary operation and flags
Message-ID: <20210727210503.GA15429@salvia>
References: <20210727153741.14406-1-pablo@netfilter.org>
 <20210727153741.14406-2-pablo@netfilter.org>
 <CAGnHSE=e-iYaz3KOMBq1JSVRd0HTL=TKQ_HHMadfyd2Nr8__yg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAGnHSE=e-iYaz3KOMBq1JSVRd0HTL=TKQ_HHMadfyd2Nr8__yg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jul 28, 2021 at 02:36:18AM +0800, Tom Yan wrote:
> Hmm, that means `tcp flags & (fin | syn | rst | ack) syn` is now
> equivalent to 'tcp flags & (fin | syn | rst | ack) == syn'.

Yes, those two are equivalent.

> Does that mean `tcp flags syn` (was supposed to be and) is now
> equivalent to `tcp flags == syn`

tcp flag syn

is a shortcut to match on the syn bit regarless other bit values, it's
a property of the bitmask datatypes.

tcp flags == syn

is an exact match, it checks that the syn bit is set on.

> instead of `tcp flags & syn == syn` / `tcp flags & syn != 0`?

these two above are equivalent, I just sent a patch to fix the
tcp flags & syn == syn case.

> Suppose `tcp flags & syn != 0` should then be translated to `tcp flags
> syn / syn` instead, please note that while nft translates `tcp flags &
> syn == syn` to `tcp flags syn / syn`, it does not accept the
> translation as input (when the mask is not a comma-separated list):
> 
> # nft --debug=netlink add rule meh tcp_flags 'tcp flags syn / syn'
> Error: syntax error, unexpected newline, expecting comma
> add rule meh tcp_flags tcp flags syn / syn
>                                           ^

The most simple way to express this is: tcp flags == syn.

> Also, does that mean `tcp flags & (fin | syn | rst | ack) fin,syn,ack`
> will now be equivalent to `tcp flags & (fin | syn | rst | ack) = (fin
> | syn | ack)`

Yes, those two are equivalent. This is the same example as the one you
have used at the beginning of this email.

> instead of (ultimately) `tcp flags & (fin | syn | ack)  != 0`?

That's equivalent to:

tcp flags fin,syn,ack

A quick summary:

- If you want an exact match:

tcp flags == fin,syn,ack

- If you want to check that those three bits are set on (regardless
  the remaining bits):

tcp flags fin,syn,ack / fin,syn,ack

- If you want to check that any of these three bits is set on:

tcp flags fin,syn,ack

> Which means `tcp flags & (fin | syn | ack) != 0` should not be
> translated to `tcp flags fin,syn,ack`?

tcp flags & (fin | syn | ack) != 0 is checking for any of these three
bits to be set on, this translation is correct.
