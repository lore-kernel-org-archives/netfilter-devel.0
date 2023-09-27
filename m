Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7586E82CB2
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Sep 2023 17:14:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbjI0ROL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Sep 2023 13:14:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjI0ROK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Sep 2023 13:14:10 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 963BFA1
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Sep 2023 10:14:08 -0700 (PDT)
Received: from [78.30.34.192] (port=50592 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qlY6u-00Dgnm-KS; Wed, 27 Sep 2023 19:14:06 +0200
Date:   Wed, 27 Sep 2023 19:14:03 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 3/3] netlink_linearize: avoid strict-overflow warning
 in netlink_gen_bitwise()
Message-ID: <ZRRi2wA7dlqu6TO8@calendula>
References: <20230927122744.3434851-1-thaller@redhat.com>
 <20230927122744.3434851-4-thaller@redhat.com>
 <5abe71186c7dd1b78b58fcca9a3920deccad16fc.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5abe71186c7dd1b78b58fcca9a3920deccad16fc.camel@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Sep 27, 2023 at 07:06:26PM +0200, Thomas Haller wrote:
> On Wed, 2023-09-27 at 14:23 +0200, Thomas Haller wrote:
> > With gcc-13.2.1-1.fc38.x86_64:
> > 
> >   $ gcc -Iinclude -c -o tmp.o src/netlink_linearize.c -Werror -
> > Wstrict-overflow=5 -O3
> >   src/netlink_linearize.c: In function ‘netlink_gen_bitwise’:
> >   src/netlink_linearize.c:1790:1: error: assuming signed overflow
> > does not occur when changing X +- C1 cmp C2 to X cmp C2 -+ C1 [-
> > Werror=strict-overflow]
> >    1790 | }
> >         | ^
> >   cc1: all warnings being treated as errors
> > 
> > It also makes more sense this way, where "n" is the hight of the
> > "binops" stack, and we check for a non-empty stack with "n > 0" and
> > pop
> > the last element with "binops[--n]".
> > 
> > Signed-off-by: Thomas Haller <thaller@redhat.com>
> > ---
> >  src/netlink_linearize.c | 7 +++----
> >  1 file changed, 3 insertions(+), 4 deletions(-)
> > 
> > diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
> > index c91211582b3d..f2514b012a9d 100644
> > --- a/src/netlink_linearize.c
> > +++ b/src/netlink_linearize.c
> > @@ -712,14 +712,13 @@ static void netlink_gen_bitwise(struct
> > netlink_linearize_ctx *ctx,
> >         while (left->etype == EXPR_BINOP && left->left != NULL &&
> >                (left->op == OP_AND || left->op == OP_OR || left->op
> > == OP_XOR))
> >                 binops[n++] = left = left->left;
> 
> I wanted to ask, what ensures that binops buffer does not overflow?

This is stacking binops, then popping them out one by one to generate
code IIRC.

binops has 16 positions, if you manage to generate a large expression
with lots of bitwise, probably you can hit the buffer overflow.

Go explore :)
