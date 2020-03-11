Return-Path: <SRS0=fe67=44=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92F78C0044D
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Mar 2020 20:53:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8BA0420749
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Mar 2020 20:53:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="Y75oDhbS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbgCKUxv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 Mar 2020 16:53:51 -0400
Received: from kadath.azazel.net ([81.187.231.250]:42062 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726672AbgCKUxu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Mar 2020 16:53:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=1J8s9BZYxouLQDti2mlJdkHTX5ACdh6Y5vHLf8c29e8=; b=Y75oDhbSRejyCTr8FvgnbZMF6z
        GCUhsOG5bAmiHSV90DUVIFzFNO5O7gbhT35RQ0bepQCmgYE15gJnT/YNdur9mhTi3RcL3+g7i+Cir
        3glRxa59B4si4NY0DEOUOxc9bEZzuVYxqMxnWvg4IbMo9CKfE5w5l9JygHyYuVl6S3/OU4IQ4RoOt
        0YBpRYRmFvzMVuCWxYBpGtMzGDgeF7N8Qz8iUhThubzR5KGQmD3WKSVZZW7vjpI1KzL2x3tVGFBJI
        atugVnndh1n4j6y6a+dhktEF2hz7vzYmjvYbLqUarS20zKGJL8j4qcO7gbGb2051a15Vn856ThMIn
        yYHWkH6Q==;
Received: from celephais.dreamlands ([192.168.96.3] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1jC8MO-0007Pb-PT; Wed, 11 Mar 2020 20:53:48 +0000
Date:   Wed, 11 Mar 2020 20:54:13 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft v3 18/18] tests: py: add variable binop RHS tests.
Message-ID: <20200311205413.GD121279@azazel.net>
References: <20200303094844.26694-1-jeremy@azazel.net>
 <20200303094844.26694-19-jeremy@azazel.net>
 <20200310023913.uebkl7uywu4gkldn@salvia>
 <20200310093008.GA166204@azazel.net>
 <20200311132613.c2onkaxo7uizzofs@salvia>
 <20200311143535.GA184442@azazel.net>
 <20200311171752.cjv5kd6arsog4gia@salvia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="mJm6k4Vb/yFcL9ZU"
Content-Disposition: inline
In-Reply-To: <20200311171752.cjv5kd6arsog4gia@salvia>
X-SA-Exim-Connect-IP: 192.168.96.3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--mJm6k4Vb/yFcL9ZU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2020-03-11, at 18:17:52 +0100, Pablo Neira Ayuso wrote:
> On Wed, Mar 11, 2020 at 02:35:35PM +0000, Jeremy Sowden wrote:
> > On 2020-03-11, at 14:26:13 +0100, Pablo Neira Ayuso wrote:
> > > Do you think it would be to keep back this one from the nf-next
> > > tree until you evaluate an alternative way to extend nft_bitwise?
> > >
> > > commit 8d1f378a51fcf2f5e44e06ff726a91c885d248cc
> > > Author: Jeremy Sowden <jeremy@azazel.net>
> > > Date:   Mon Feb 24 12:49:31 2020 +0000
> > >
> > >     netfilter: bitwise: add support for passing mask and xor
> > >     values in registers.
> >
> > If we do move away from converting all boolean op's to:
> >
> >   d = (s & m) ^ x
> >
> > then it seems unlikely that the new attributes will be used.
>
> I see.
>
> > For me, it depends whether you rebase nf-next.  I'm guessing not.
> > In that case, I probably wouldn't bother reverting the patch now,
> > since it's not big or invasive, and it wouldn't much matter if it
> > went into 5.6 and got removed in a later patch-set.
>
> OK. I'm considering to rebase given this patch is not yet into
> net-next, unless anyone here is opposed to this in order to pass a
> pull-request with no add-patch-then-revert.

Fbm.

> Regarding the new extension, we only have to be careful when updating
> userspace, so only new code uses the new bitwise extension you make.
> Old code will still use the old boolean approach:
>
>     d = (s & m) ^ x
>
> So only the payload with non-constant right-hand side will be using
> your new extension for nft_bitwise.

The kernel should definitely continue to support the old way of doing
things.

> For libnftnl, I'm inclined to revert.

Agreed.

> Let me know, thanks.

J.

--mJm6k4Vb/yFcL9ZU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEEd/6/sDFjb+OCRmRMonv1GCHZ79cFAl5pT+0ACgkQonv1GCHZ
79f3GQv9F5vJdo7DBxXMaw0XetuE/P3I1jqhtwt6WO9ug/R2knGCdlB+zAFbDH8q
kV47/Rti8TEFtUVz2ooDJJqaw8FnNIvaDOrA9OJ4b0aWg8YN8dSc5BDQ+0Zv7hU6
sbaj8DewcKVxNyseQ/1EZNb6/IpqGhrI5OmA5ozUfAzakxW9MYdmf9Ig1F2uil5N
gPzPvKYTrTGtt8ZIO9FV/hQxFTxIqxDu8p1AyL/8ad+KXx8RJe1scaGbZ8WpckM9
1HCRqXN1CgU/6Apy45JNxkfUeKW0oOFiD0fHxhLOTnI8KfwsB3PN/4yQJUJZ0rMj
J6x3yQZ436MtC0VCOHsiuDBS7d6nZNVX2u6GLODlrcgOJYdMaD5fdqNtxbv+KiLb
dteYwNNA7elpwCMZ52LbcA6CPRLZ1E0Bw2veroUbicanIC7tnxCr1gUKB2OH7hrP
Qr16Hzm72j75g9vXBvBifYGEghIXH9onvMFEGENBOinNrQSjGprRcjNGL2dcMrMj
Nz+mCXD7
=1QpK
-----END PGP SIGNATURE-----

--mJm6k4Vb/yFcL9ZU--
