Return-Path: <SRS0=+R7G=3E=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9561DC32771
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Jan 2020 20:48:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6600F2081E
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Jan 2020 20:48:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="eLHEgnq1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729375AbgAOUsB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Jan 2020 15:48:01 -0500
Received: from kadath.azazel.net ([81.187.231.250]:55006 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729263AbgAOUsA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Jan 2020 15:48:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=sHLzRYdkmwsveeGaOdwJIRx4m+CnLjCMpxSMi3iJgBg=; b=eLHEgnq1IFcd0SAs5tM6NCNWYd
        lOmSnWsUPYku3v8FkZg41VkbvMrvSI5fFaSH7MJA9fFR6/TDVxoqzHRpFQmNqY7g3yFutIpUT0PAo
        mQQZn9gbbfNEtklwofqqPB2Jri1fkosZIqFfEfTTa/2Ctvangq9PUDXgvSLJ1msmgq5LfhbrgrVZ8
        Wf385lgc6LQP07ZDLmWdw5rHVaWno1q7R5kFb3ADhmxo4uAwC+m+GLTOFNcP1zgjcsrlptLgYo11m
        Xl25hDFTs+ZYkD6JFQZpTJxSyzvzRCyXkCdLdPszj34b9o5QilKh5IyGSPfAbEA9NJBdg7K5fpPuz
        rcOSY/WQ==;
Received: from celephais.dreamlands ([192.168.96.3] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1irpa3-0006LG-Rv; Wed, 15 Jan 2020 20:47:59 +0000
Date:   Wed, 15 Jan 2020 20:48:00 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf-next v3 00/10] netfilter: nft_bitwise: shift support
Message-ID: <20200115204800.GF999973@azazel.net>
References: <20200115200557.26202-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="X3gaHHMYHkYqP6yf"
Content-Disposition: inline
In-Reply-To: <20200115200557.26202-1-jeremy@azazel.net>
X-SA-Exim-Connect-IP: 192.168.96.3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--X3gaHHMYHkYqP6yf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2020-01-15, at 20:05:47 +0000, Jeremy Sowden wrote:
> The connmark xtables extension supports bit-shifts.  Add support for
> shifts to nft_bitwise in order to allow nftables to do likewise, e.g.:
>
>   nft add rule t c oif lo ct mark set meta mark << 8 | 0xab
>   nft add rule t c iif lo meta mark & 0xff 0xab ct mark set meta mark >> 8
>
> Changes since v2:
>
>   * convert NFTA_BITWISE_DATA from u32 to nft_data;

There's a bug in the nft_data stuff.  Will fix and resend.

>   * add check that shift value is not too large;
>   * use BITS_PER_TYPE to get the size of u32, rather than hard-coding it
>     when evaluating shifts.
>
> Changes since v1:
>
>   * more white-space fixes;
>   * move bitwise op enum to UAPI;
>   * add NFTA_BITWISE_OP and NFTA_BITWISE_DATA;
>   * remove NFTA_BITWISE_LSHIFT and NFTA_BITWISE_RSHIFT;
>   * add helpers for initializaing, evaluating and dumping different
>     types of operation.
>
> Jeremy Sowden (10):
>   netfilter: nf_tables: white-space fixes.
>   netfilter: bitwise: remove NULL comparisons from attribute checks.
>   netfilter: bitwise: replace gotos with returns.
>   netfilter: bitwise: add NFTA_BITWISE_OP netlink attribute.
>   netfilter: bitwise: add helper for initializing boolean operations.
>   netfilter: bitwise: add helper for evaluating boolean operations.
>   netfilter: bitwise: add helper for dumping boolean operations.
>   netfilter: bitwise: only offload boolean operations.
>   netfilter: bitwise: add NFTA_BITWISE_DATA attribute.
>   netfilter: bitwise: add support for shifts.
>
>  include/uapi/linux/netfilter/nf_tables.h |  24 ++-
>  net/netfilter/nft_bitwise.c              | 217 ++++++++++++++++++-----
>  net/netfilter/nft_set_bitmap.c           |   4 +-
>  net/netfilter/nft_set_hash.c             |   2 +-
>  4 files changed, 200 insertions(+), 47 deletions(-)
>
> --
> 2.24.1
>
>

--X3gaHHMYHkYqP6yf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEEd/6/sDFjb+OCRmRMonv1GCHZ79cFAl4fenkACgkQonv1GCHZ
79dPDgv+JGyruicjTGs78+0ig49m8fvRMiUBsWCh0x/5/0Ibv/Mdy8reuUloFZCW
gntwBj+ZbtJGz3jfuSp5SnHKfTTbGn4p6A7eRzt7V3ibZOrxVv1bbK28p6cJvHpK
71T+wffHA4L2Qaj/EURhtBSPjVedPpz6Wr4xQ8K0d4ybXRInnFYl/1Yphty2yDn7
zOQ8OmIK17LTsxDPtyPfSGQpyXuNa7oJ9jv46BrN02BUtYU8vByWRdKI09607taF
jsI+B0Qguh0d06PQ6KHQUUALiAw+R+Ks2vWaWN7SHYy7VMnahkoqhYfHzwQlE6h0
yh5GbzDfGmNaBBQimyiZnuKWYTeu3n3dhzWGq9kA2xWGpvY1CpCDrzehUp/a9ivc
jrjBBLztVT9XnwNh9IRZVy+1lOHULRi0e0pDw6TbhQnWG9x74nr+mEDuRObg4Zh+
xv/nfLeETBi7pfyp9ZP4LYEQJghGZjtUJEAxuh3UNmNF4G3caxojdwHpsNnTkfAx
YEAisRBp
=hRP+
-----END PGP SIGNATURE-----

--X3gaHHMYHkYqP6yf--
