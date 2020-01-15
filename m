Return-Path: <SRS0=+R7G=3E=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABD34C33CB1
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Jan 2020 09:30:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7DD3A207FF
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Jan 2020 09:30:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="pVb6j85/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729409AbgAOJai (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Jan 2020 04:30:38 -0500
Received: from kadath.azazel.net ([81.187.231.250]:54802 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729396AbgAOJai (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Jan 2020 04:30:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=grUmwqDlPiTtU1VOdJ1Y2P/vH+OrSHLaTEAOuSn5g+Y=; b=pVb6j85/na6j91XqvC4dztmWbM
        r5GZmuVB/Cqa3RzgjUvYsxNeNiMp9vf41eQhpxVrWi0e7D6mXBnsjJutik3Gcujvu3VwiLXfrnTHq
        6dovbomo2ejBVOnBrZQ9YRmAR7ZU8B7m+sPvBnQ3qmWQjpES1C+EkefNr9sAmbHxQ1H+HI1ylSOAD
        FP1LVCfb8Vie02IpucRP0jJEzNKt7R2Wdhv7B5NqK2IL9y5tlfDRLt1ZGBOU1QR/iJhgFm7do4zRZ
        p8uTDQiV3Q3wMlK20mqBHT5rw/GnpkdtPrGroNA6W4fmjJh6luR1paK3u1VV5CwIGhSQmaHRWDpMs
        VcKxYoXQ==;
Received: from celephais.dreamlands ([192.168.96.3] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1irf0W-00041Z-Vm; Wed, 15 Jan 2020 09:30:37 +0000
Date:   Wed, 15 Jan 2020 09:30:38 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf-next v2 09/10] netfilter: bitwise: add
 NFTA_BITWISE_DATA attribute.
Message-ID: <20200115093038.GE999973@azazel.net>
References: <20200114212918.134062-1-jeremy@azazel.net>
 <20200114212918.134062-10-jeremy@azazel.net>
 <20200115092907.subrj56hcjgtywze@salvia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="osDK9TLjxFScVI/L"
Content-Disposition: inline
In-Reply-To: <20200115092907.subrj56hcjgtywze@salvia>
X-SA-Exim-Connect-IP: 192.168.96.3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--osDK9TLjxFScVI/L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2020-01-15, at 10:29:07 +0100, Pablo Neira Ayuso wrote:
> On Tue, Jan 14, 2020 at 09:29:17PM +0000, Jeremy Sowden wrote:
> > Add a new bitwise netlink attribute that will be used by shift
> > operations to store the size of the shift.  It is not used by
> > boolean operations.
> >
> > Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
> > ---
> >  include/uapi/linux/netfilter/nf_tables.h | 2 ++
> >  net/netfilter/nft_bitwise.c              | 5 +++++
> >  2 files changed, 7 insertions(+)
> >
> > diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> > index cfda75725455..7cb85fd0d38e 100644
> > --- a/include/uapi/linux/netfilter/nf_tables.h
> > +++ b/include/uapi/linux/netfilter/nf_tables.h
> > @@ -503,6 +503,7 @@ enum nft_bitwise_ops {
> >   * @NFTA_BITWISE_MASK: mask value (NLA_NESTED: nft_data_attributes)
> >   * @NFTA_BITWISE_XOR: xor value (NLA_NESTED: nft_data_attributes)
> >   * @NFTA_BITWISE_OP: type of operation (NLA_U32: nft_bitwise_ops)
> > + * @NFTA_BITWISE_DATA: argument for non-boolean operations (NLA_U32)
> >   *
> >   * The bitwise expression performs the following operation:
> >   *
> > @@ -524,6 +525,7 @@ enum nft_bitwise_attributes {
> >  	NFTA_BITWISE_MASK,
> >  	NFTA_BITWISE_XOR,
> >  	NFTA_BITWISE_OP,
> > +	NFTA_BITWISE_DATA,
> >  	__NFTA_BITWISE_MAX
> >  };
> >  #define NFTA_BITWISE_MAX	(__NFTA_BITWISE_MAX - 1)
> > diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
> > index 1d9079ba2102..72abaa83a8ca 100644
> > --- a/net/netfilter/nft_bitwise.c
> > +++ b/net/netfilter/nft_bitwise.c
> > @@ -22,6 +22,7 @@ struct nft_bitwise {
> >  	u8			len;
> >  	struct nft_data		mask;
> >  	struct nft_data		xor;
> > +	u32			data;
>
> Could you make this struct nft_data?
>
> We can extend later on nft_bitwise to more operations. I was
> considering to (ab)use bitwise to implement increment and decrement. I
> think u32 should be enough in most cases, but I'd prefer to stick to
> one 128 bit word in this case. For shift this is obviously too much,
> but this would be leaving room for new operations requiring something
> larger than u32.

I did wonder about that. :) Will do.

J.

--osDK9TLjxFScVI/L
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEEd/6/sDFjb+OCRmRMonv1GCHZ79cFAl4e27YACgkQonv1GCHZ
79dLhQv/bU0sfpIgfyD3MZFlUm32DWqaKJjKyABVzYloubGHVhr8ONyHuTumdp0U
7w8zMSkBCSlEincCOBjE0PwupLgyLgW5IH42b/2rN9gb/1i9t6Q52VRsQ7kaP0Ft
xhWwITPkTMxnPtqzFkNWUi2K0bSoperP5vbEZ7PxiEEP+82+hylRjXaPD8iQs0JP
PLvY4O5saLsFnm0SXtsh3OhVN66YR/zTjGd7Ns1PlFFfAdi6rQzC1HtwSrYFlccX
19KjEn4MnFaSI2Oea8Np42yG2Bc+ISTJfmX2K4TClNu3bANBSCqPQWrxwL0QC34p
YJI/L0YiwyJ/V9y07cMyUD+xfZjaQwaEAXcS/vz/RCTyNFrrXoTCndlx2nf4sK3D
4aL0CCeJ7w42+LNY2xh7ochw+9wVLMdq9oKkCEF8qgpTBzzv9y0CnyHvD/AJC7m0
B9B8NxoPLeiqJ/i9TVcUJex/5YIJ8IV1DUekMb0i61N7ThAFy7ZIxaTAxGOEtRxL
Y21Uo/Ju
=Ss4q
-----END PGP SIGNATURE-----

--osDK9TLjxFScVI/L--
