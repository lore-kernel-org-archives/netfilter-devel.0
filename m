Return-Path: <SRS0=DSQd=3Y=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A95E9C2D0B1
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Feb 2020 11:02:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 733052051A
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Feb 2020 11:02:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="EGl/BvET"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbgBDLCo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 4 Feb 2020 06:02:44 -0500
Received: from kadath.azazel.net ([81.187.231.250]:59668 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726741AbgBDLCn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 4 Feb 2020 06:02:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=rYGf4nZRSfrOvRbX1a1cm4y+i9V8rRogYST3ZiQ7cXk=; b=EGl/BvET8XIg3AYF/AcKWw6ffM
        tXJQb5eNmReICDQpuJqZRLBXCZD0KFBsWPPzS06S0AsTdxBmd9w9oyvuNNKd/PZ9eSgG9f2fE5PeG
        8n6A5hABZCiMGCYlQxFvLUmQ0d8PYZWMo5AEqkEPihqEt4DbRmBrlO2kE+PK0o2TDCg/1cicEXX8O
        K2OpDR6MXRP56lOeFLERrQ+0BkeE9mkjRxwyOxvOazqa+Axo/cyAxuAHLkqap0iVRXNWrFoRyoO3s
        xOm31OI0RLd/dqze+XassAs8Q5WYE0CvuHXeNNW6lGnSVXjU+qtpPagZcbmyMmT62sq3WR4xMgjY4
        cXmifTlQ==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1iyvyZ-0001e3-Ft; Tue, 04 Feb 2020 11:02:40 +0000
Date:   Tue, 4 Feb 2020 11:02:37 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft] evaluate: don't eval unary arguments.
Message-ID: <20200204110237.GA659701@azazel.net>
References: <20200119181203.60884-1-jeremy@azazel.net>
 <20200127093304.pqqvrxgyzveemert@salvia>
 <20200127111343.GB377617@azazel.net>
 <20200128184918.d663llqkrmaxyusl@salvia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline
In-Reply-To: <20200128184918.d663llqkrmaxyusl@salvia>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2020-01-28, at 19:49:18 +0100, Pablo Neira Ayuso wrote:
> On Mon, Jan 27, 2020 at 11:13:43AM +0000, Jeremy Sowden wrote:
> > On 2020-01-27, at 10:33:04 +0100, Pablo Neira Ayuso wrote:
> > > On Sun, Jan 19, 2020 at 06:12:03PM +0000, Jeremy Sowden wrote:
> > > > When a unary expression is inserted to implement a byte-order
> > > > conversion, the expression being converted has already been
> > > > evaluated and so expr_evaluate_unary doesn't need to do so.  For
> > > > most types of expression, the double evaluation doesn't matter since
> > > > evaluation is idempotent.  However, in the case of payload
> > > > expressions which are munged during evaluation, it can cause
> > > > unexpected errors:
> > > >
> > > >   # nft add table ip t
> > > >   # nft add chain ip t c '{ type filter hook input priority filter; }'
> > > >   # nft add rule ip t c ip dscp set 'ip dscp | 0x10'
> > > >   Error: Value 252 exceeds valid range 0-63
> > > >   add rule ip t c ip dscp set ip dscp | 0x10
> > > >                               ^^^^^^^
> > >
> > > I'm still hitting this after applying this patch.
> > >
> > > nft add rule ip t c ip dscp set ip dscp or 0x10
> > > Error: Value 252 exceeds valid range 0-63
> > > add rule ip t c ip dscp set ip dscp or 0x10
> > >                             ^^^^^^
> > > Probably problem is somewhere else? I'm not sure why we can assume
> > > here that the argument of the unary expression should not be
> > > evaluated.
> >
> > I'll take another look.

I think what happened here is that I came across this problem while
working on using payload expressions to set CT and packet marks, and in
that specific case stopping the double-evaluation in expr_evaluate_unary
fixed it.  However, when I looked for another example that was allowed
by the current grammar to put into the commit message, the one I found
was caused by stmt_evaluate_payload instead, but on the assumption that
the cause was the same, I didn't actually verify it.  Whoops.

> I think stmt_evaluate_payload() is incomplete, this function was not
> made to deal with non-constant expression as values.
>
> Look:
>         tcp dport set tcp sport
>
> works because it follows the 'easy path', ie. no adjustment to make
> the checksum calculation happy (see payload_needs_adjustment() in
> stmt_evaluate_payload().
>
> However:
>
>         ip dscp set ip dscp
>
> bails out with:
>
>         nft add rule ip t c ip dscp set ip dscp
>         Error: Value 252 exceeds valid range 0-63
>         add rule ip t c ip dscp set ip dscp
>                                     ^^^^^^^
>
> because this follows the more complicated path. Looking at this code,
> this path assumes a constant value, ie. ip dscp set 10. A more complex
> thing such a non-constant expression (as in the example above) will
> need a bit of work.
>
> Probably you can start making a patchset make this work:
>
>         add rule ip t c tcp dport set tcp dport lshift 1
>
> which triggers:
>
> BUG: invalid binary operation 4
> nft: netlink_linearize.c:592: netlink_gen_binop: Assertion `0' failed.
>
> since it's missing the bytecode to generate the left-shift. Not very
> useful for users, but we can get something already merged upstream and
> you'll be half-way done. Merge also a few tests.
>
> Then, once the more fundamental rshift/lshift bits are merged, look at
> this 'harder' path. Just a proposal.
>
> For reference, the expression tree that stmt_evaluate_payload() to
> make the checksum adjustment looks like this:
>
>            xor
>           /   \
>         and   value
>         / \
> payload_   mask
>  bytes
>
> payload_bytes extends the payload expression to get up to 16-bits.
> The left hand side is there to fetch bits that need to be left
> untouched. The right hand side represent the bits that need to be set.
>
> In the new non-constant scenario, the 'value' tree is actually a
> binary operation:
>
>          shift
>         /    \
>    payload   imm
>
> The unary should not really be there, it's likely related to some
> incorrect byteorder issue that kicks in with non-constant expression.
>
> So more work on stmt_evaluate_payload() is required.

Thanks for the analysis, Pablo.  I'll get started.

J.

--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEEd/6/sDFjb+OCRmRMonv1GCHZ79cFAl45T0YACgkQonv1GCHZ
79dY9gwAkjvZJ0AlW7cZc4iQK3gena6l1DGkr/MJMwLLLqWQLmqeysll3CCNZW4s
QoGlfRccQEKLUptoqEP9HNOk+aH9nGJoHV/hHX/rUNiMQTPpz9nDkmjz5OJSUXNZ
76RJ5CHCtkG3Fma1C8AFsz8qj3gKijZHS63hXPEsKkoxvQkicmCH1N9p1mmJbpnr
w2Qsi+Mf6E+6l041mtfKu52/i4UD238sXwof854nAcilSg7aEBM0SqOpnDSp8JNK
QFJZEeWO2jTefIqYR0oaMtjqjSbXwsqOH7evCnBpQ2ZnDROcAKNoZlQLS04ymP59
IwGn3rDcfFpGroymB+KOIF49mh3ecZAD3HGURg60G0zFgZGcfcBi4lX36JOZq/pq
9JslSFPa3DkmMkZTX5nfgm9erk4aDH2xUHb5bSUx1xiW1o6ejA12bPl6puJSOA2R
C6d0y1074f7toe+rg9ir07kMBNfMxr5oTHgsC6zN4cMzd/F6KUzd7f9dXqt35nRr
F1nYtLgF
=Cc2O
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
