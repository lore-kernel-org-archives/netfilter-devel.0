Return-Path: <SRS0=eo3W=4M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16CA8C35671
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Feb 2020 12:36:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7ADC20828
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Feb 2020 12:36:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="iG7QezRu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727474AbgBXMgt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 24 Feb 2020 07:36:49 -0500
Received: from kadath.azazel.net ([81.187.231.250]:56788 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727405AbgBXMgt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Feb 2020 07:36:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ufeDXE82FxWIRZch66/zTHWAi5GTG/5jG1ngxJOIGgg=; b=iG7QezRui7ptOPUiWtB9gKVrDi
        6lhIHVP+UPUyOk0uhF4egMh4Qe4LiqgF7D4HreOT0FjGkXfggAo1AniIihbxN5hC4votaLOHhCWbj
        /YB5kpfGgjGD1ymcE5TXyQgAlvUK7Etq50CSZgF9jpMqaZaBqEN3iSDOcg8Hne65BZHkqxv6PQ5nC
        NrHChbQDAUYSxBXK19Z1XZNvyFEskxT+LSWEgWbL2NLFFY38f3dq7l5suYaOozQQqJbUIwIvzm2Tc
        ODOnZlc0c7J0LZFo5JvSwYjLoMWzGQCJnBLUzmKaCUNh5/vGkTgac98FOUgPaocH+YCRUHi+II5cb
        TxPlieUA==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1j6Cyd-0001U9-9b; Mon, 24 Feb 2020 12:36:47 +0000
Date:   Mon, 24 Feb 2020 12:36:46 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft] evaluate: don't eval unary arguments.
Message-ID: <20200224123646.GA505545@azazel.net>
References: <20200128184918.d663llqkrmaxyusl@salvia>
 <20200223221411.GA121279@azazel.net>
 <20200223222321.kjfsxjl6ftbcrink@salvia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="SLDf9lqlvOQaIe6s"
Content-Disposition: inline
In-Reply-To: <20200223222321.kjfsxjl6ftbcrink@salvia>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2020-02-23, at 23:23:21 +0100, Pablo Neira Ayuso wrote:
> On Sun, Feb 23, 2020 at 10:14:11PM +0000, Jeremy Sowden wrote:
> > On 2020-01-28, at 19:49:18 +0100, Pablo Neira Ayuso wrote:
> > > On Mon, Jan 27, 2020 at 11:13:43AM +0000, Jeremy Sowden wrote:
> > > > On 2020-01-27, at 10:33:04 +0100, Pablo Neira Ayuso wrote:
> > > > > On Sun, Jan 19, 2020 at 06:12:03PM +0000, Jeremy Sowden wrote:
> > > > > > When a unary expression is inserted to implement a
> > > > > > byte-order conversion, the expression being converted has
> > > > > > already been evaluated and so expr_evaluate_unary doesn't
> > > > > > need to do so.  For most types of expression, the double
> > > > > > evaluation doesn't matter since evaluation is idempotent.
> > > > > > However, in the case of payload expressions which are munged
> > > > > > during evaluation, it can cause unexpected errors:
> > > > > >
> > > > > >   # nft add table ip t
> > > > > >   # nft add chain ip t c '{ type filter hook input priority filter; }'
> > > > > >   # nft add rule ip t c ip dscp set 'ip dscp | 0x10'
> > > > > >   Error: Value 252 exceeds valid range 0-63
> > > > > >   add rule ip t c ip dscp set ip dscp | 0x10
> > > > > >                               ^^^^^^^
> > > > >
> > > > > I'm still hitting this after applying this patch.
> > > > >
> > > > > nft add rule ip t c ip dscp set ip dscp or 0x10
> > > > > Error: Value 252 exceeds valid range 0-63
> > > > > add rule ip t c ip dscp set ip dscp or 0x10
> > >
> > > [...]
> > >
> > > I think stmt_evaluate_payload() is incomplete, this function was
> > > not made to deal with non-constant expression as values.
> > >
> > > [...]
> > >
> > > Probably you can start making a patchset make this work:
> > >
> > >         add rule ip t c tcp dport set tcp dport lshift 1
> > >
> > > which triggers:
> > >
> > > BUG: invalid binary operation 4
> > > nft: netlink_linearize.c:592: netlink_gen_binop: Assertion `0'
> > > failed.
> > >
> > > since it's missing the bytecode to generate the left-shift. Not
> > > very useful for users, but we can get something already merged
> > > upstream and you'll be half-way done. Merge also a few tests.
> >
> > This assertion failure had already been fixed by the bitwise shift
> > patches you had recently applied.  However, the rule itself doesn't
> > yet quite work because `tcp dport lshift 1` has the wrong
> > endianness.  Thus given an original `tcp dport` of 40, we end up
> > with 20480, instead of 80.
>
> I think the generated bytecode should be like this:
>
>         r1 <- payload to fetch value
>         swap byteorder in r1
>         shift value in r1
>         cmp r1 and immediate value (in host byteorder)

Currently, nft generates this:

  [ meta load l4proto => reg 1 ]
  [ cmp eq reg 1 0x00000006 ]
  [ payload load 2b @ transport header + 0 => reg 1 ]
  [ byteorder reg 1 = ntoh(reg 1, 2, 2) ]
  [ bitwise reg 1 = ( reg 1 << 0x00000001 ) ]
  [ payload write reg 1 => 2b @ transport header + 2 csum_type 1 csum_off 16 csum_flags 0x0 ]

I have a patch to insert the missing hton:

  --- a/src/evaluate.c
  +++ b/src/evaluate.c
  @@ -2218,6 +2218,11 @@ static int stmt_evaluate_payload(struct eval_ctx *ctx, struct stmt *stmt)
                                payload->byteorder, &stmt->payload.val) < 0)
                  return -1;

  +       if (!expr_is_constant(stmt->payload.val) &&
  +           byteorder_conversion(ctx, &stmt->payload.val,
  +                                payload->byteorder) < 0)
  +               return -1;
  +
          need_csum = stmt_evaluate_payload_need_csum(payload);

          if (!payload_needs_adjustment(payload)) {

giving:

  [ meta load l4proto => reg 1 ]
  [ cmp eq reg 1 0x00000006 ]
  [ payload load 2b @ transport header + 0 => reg 1 ]
  [ byteorder reg 1 = ntoh(reg 1, 2, 2) ]
  [ bitwise reg 1 = ( reg 1 << 0x00000001 ) ]
  [ byteorder reg 1 = hton(reg 1, 2, 2) ]
  [ payload write reg 1 => 2b @ transport header + 2 csum_type 1 csum_off 16 csum_flags 0x0 ]

> > > Then, once the more fundamental rshift/lshift bits are merged,
> > > look at this 'harder' path. Just a proposal.
> > >
> > > For reference, the expression tree that stmt_evaluate_payload() to
> > > make the checksum adjustment looks like this:
> > >
> > >            xor
> > >           /   \
> > >         and   value
> > >         / \
> > > payload_   mask
> > >  bytes
> > >
> > > payload_bytes extends the payload expression to get up to 16-bits.
> > > The left hand side is there to fetch bits that need to be left
> > > untouched. The right hand side represent the bits that need to be
> > > set.
> > >
> > > In the new non-constant scenario, the 'value' tree is actually a
> > > binary operation:
> > >
> > >          shift
> > >         /    \
> > >    payload   imm
> > >
> > > The unary should not really be there, it's likely related to some
> > > incorrect byteorder issue that kicks in with non-constant
> > > expression.
> > >
> > > So more work on stmt_evaluate_payload() is required.
> >
> > After giving this some thought, it occurred to me that this could be
> > fixed by extending bitwise boolean operations to support a variable
> > righthand operand (IIRC, before Christmas Florian suggested
> > something along these lines to me in another, related context), so
> > I've gone down that route.  Patches to follow shortly.
>
> Would this require a new kernel extensions? What's the idea behind
> this?

In addition to what Florian has mentioned elsewhere (and the original
reason I started looking at this), is Kevin Darbyshire-Bryant's desire
to be able to do something like:

  nft add rule t c ct mark set ip dscp lshift 16 or 0x10

That specific example wouldn't require a variable RHS (but would require
other changes), but Florian suggested generalizing the solution, and
setting payload fields using non-constant expressions would.

J.

--SLDf9lqlvOQaIe6s
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEEd/6/sDFjb+OCRmRMonv1GCHZ79cFAl5Tw1YACgkQonv1GCHZ
79fvVQv/SMEaTHrfD9ssDoHGBNVqBO5eG3QuWdDk9MKMTwrSL85saWGkO9wtzwrK
6WKKbE5ALGx9b8GCITuwhbb2RqwAs2xsZ6cdQ0Oy6uSsk93JcUiUFgUfaFzjhzTn
BmZwA50s3angfRN+f75VN5ha9ky8soygEMnFAhDN2e3ZnGblGFrRPWkxrt2vN+Ic
cwvlU/sGkgOQmXtUZWhdEUe+yzFsGLnhpUV7WN2bGbHHeaNJAXsxEQr4YKU+qvUm
DNIfo/uHFJCLdrGDTil1MH8GO031J6mAa+UcWhjIsq1QSPT7CBMPJ6G7OmzEnreZ
4Z19s73LDg78pSsw6YCLf3jYa0txr2XqEP2NOLn08yediyKkh8ZlyjHxxmRrLkMP
UB5qZRknoSnl428wN3f0x6DIv1cpbEgOFkpvPA0vYVc9LKUKC53jisEPqQ6EzJ8k
W6PeuEGrDEiX090QawhLajYpvf2ezZ6ZQeEF+LE9wfeRBP2punhxOEGw5uzZ1E0y
xXqQQAfx
=Pvpc
-----END PGP SIGNATURE-----

--SLDf9lqlvOQaIe6s--
