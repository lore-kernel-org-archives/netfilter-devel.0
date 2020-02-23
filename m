Return-Path: <SRS0=J2Vc=4L=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57900C35673
	for <netfilter-devel@archiver.kernel.org>; Sun, 23 Feb 2020 22:13:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9C72206ED
	for <netfilter-devel@archiver.kernel.org>; Sun, 23 Feb 2020 22:13:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="JxG00/lm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727150AbgBWWNn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 23 Feb 2020 17:13:43 -0500
Received: from kadath.azazel.net ([81.187.231.250]:52610 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726302AbgBWWNn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 23 Feb 2020 17:13:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=uVZiF86h5hgHVw9xFX7A0Ekd7eudwR8j6PR05mZKIbE=; b=JxG00/lmpz37j7NNxvTuUIVvQ5
        bRXwGeWBxLLcJnJVrPgbQub4Lmn3eSNED7tZyg4RN8Htyud9pAutS7XGhmZy+IAci7lQo0ItHeB9R
        fx6IHkhAER7T90/DqaaE848jf4Vn6gqwt8RZHv3CM7gaC5dcamsWvbjHDXclCVcjsJcS+nRrfrHnH
        B/+WOAwH9IsB3n+RuzAmVt3kt66FYqC0VpkuaQkBcoex6t02Ss/KkQ9BoloyNWMMcbmcwGRK+K0B/
        LiS3s1j/XM2uxlqgdOB6eSR0NlfeI99oh8zObXAcyKfWV8QXdrYGAvh2KWEb2vLx6sVUEI7wkSFVS
        incRMZSw==;
Received: from celephais.dreamlands ([192.168.96.3] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1j5zVM-0006X1-IQ; Sun, 23 Feb 2020 22:13:40 +0000
Date:   Sun, 23 Feb 2020 22:14:11 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft] evaluate: don't eval unary arguments.
Message-ID: <20200223221411.GA121279@azazel.net>
References: <20200128184918.d663llqkrmaxyusl@salvia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ZGiS0Q5IWpPtfppv"
Content-Disposition: inline
In-Reply-To: <20200128184918.d663llqkrmaxyusl@salvia>
X-SA-Exim-Connect-IP: 192.168.96.3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2020-01-28, at 19:49:18 +0100, Pablo Neira Ayuso wrote:
> On Mon, Jan 27, 2020 at 11:13:43AM +0000, Jeremy Sowden wrote:
> > On 2020-01-27, at 10:33:04 +0100, Pablo Neira Ayuso wrote:
> > > On Sun, Jan 19, 2020 at 06:12:03PM +0000, Jeremy Sowden wrote:
> > > > When a unary expression is inserted to implement a byte-order
> > > > conversion, the expression being converted has already been
> > > > evaluated and so expr_evaluate_unary doesn't need to do so.  For
> > > > most types of expression, the double evaluation doesn't matter
> > > > since evaluation is idempotent.  However, in the case of payload
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
>
> [...]
>
> I think stmt_evaluate_payload() is incomplete, this function was not
> made to deal with non-constant expression as values.
>
> Look: tcp dport set tcp sport
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

This assertion failure had already been fixed by the bitwise shift
patches you had recently applied.  However, the rule itself doesn't yet
quite work because `tcp dport lshift 1` has the wrong endianness.  Thus
given an original `tcp dport` of 40, we end up with 20480, instead of 80.

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

After giving this some thought, it occurred to me that this could be
fixed by extending bitwise boolean operations to support a variable
righthand operand (IIRC, before Christmas Florian suggested something
along these lines to me in another, related context), so I've gone down
that route.  Patches to follow shortly.

J.

--ZGiS0Q5IWpPtfppv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEEd/6/sDFjb+OCRmRMonv1GCHZ79cFAl5S+SkACgkQonv1GCHZ
79cMVgv+N9Ow1YqmsHArodCDwhwIn2+KNVEiDrFZrcqlAnzaBpY+6attp/x0lJb3
Gz4o1461ISSEddxUupZq1HbBfTAgq0PfDw6tKLcc4G8fMGiA3tEfSfaCOrf5LEpy
Vicm+Kg4wdOZFiS+fUPPj/kUm//wVozHCBRtDImuRFLqvINXOwfuA9I2i8gWTkUH
NDfOhEfGHKXOfcG2vXO0C/RhHKMpPdatjCyHhVaIF0jGWfz6ashspPudKu8t1Ni1
J1NHBqUVLmFxHsnqy3bNabXAOMG8yq7WAI2upLfuHGAEKN3j7OD3ROiXHqQGB3e8
V7rgQf/Vsqg50XEGGhe5STXs6ixP7FRSv2GPfVJyr+9OF8RQaJGSqzMwYA/x9O25
1ThFu8IiEw2pvt9pccj4NSvek/UIQl+Az2cs2aLyedmhU0iHKruAH3kBgSyhcPFI
rivO78BK3iHCRVqwT+OINxDCQLQoVkC8MjTfsckaR533G0sam9TY1armlrOLmURu
e8NfrTu8
=4Hsh
-----END PGP SIGNATURE-----

--ZGiS0Q5IWpPtfppv--
