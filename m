Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22995C43334
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Jun 2022 13:48:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236124AbiFQNsC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Jun 2022 09:48:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233590AbiFQNsB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Jun 2022 09:48:01 -0400
X-Greylist: delayed 1647 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 17 Jun 2022 06:47:56 PDT
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC4E2BE16
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Jun 2022 06:47:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=tVCUVfGJFpk6JN57HVudBcDbOszKTac/J9NkbM51O6Y=; b=uEmrDTDuf5Fd6KvIoneWZjKfnC
        EtJDsrsW7gjPbL+m8xkgFoNnzqZ/3LsYrHUymkcwloQBYHax0mq+hIrYTXoDqbDx8As76trqCDuTn
        8rfRiaZnjjsGC3ElBJU05YEYODFBnDz831Ti8JTJmT9YHP5vIptSgjFwTgG7+bE8krZiovboHzCRN
        tLfMHOicFhOMv/qsmHMOgmn+3QhxAC8cR/DoLzt5LXkcKTMX2eWXRsd/fmhlKW3klOB/0YRYJJ49q
        eAWD+0cxKpqei6Cr3PQ40OQTSWdspZ8fUoF9qUzae4i4y5Ezm/NxGDyDAxuR+YxklZ1fN8UqIJqwE
        2IvqU8eA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1o2Bth-0058ek-ID; Fri, 17 Jun 2022 14:20:25 +0100
Date:   Fri, 17 Jun 2022 14:20:08 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Mailing List <netfilter-devel@vger.kernel.org>
Cc:     Markus Mayer <mmayer@broadcom.com>
Subject: Re: [PATCH] netfilter: add nf_log.h
Message-ID: <Yqx/iKXMvESE0RDt@ulthar.dreamlands>
References: <20220616224818.2720999-1-mmayer@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="QdQHmYSQYrX4l6hI"
Content-Disposition: inline
In-Reply-To: <20220616224818.2720999-1-mmayer@broadcom.com>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--QdQHmYSQYrX4l6hI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2022-06-16, at 15:48:18 -0700, Markus Mayer wrote:
> Since libxt_NFLOG is now using the UAPI version of nf_log.h, it should
> be bundled alongside the other netfilter kernel headers.

Ah, yes.  Agreed.

J.

> This copy of nf_log.h was taken from Linux 5.18.
>
> Signed-off-by: Markus Mayer <mmayer@broadcom.com>
> ---
>
> Not bundling the header with iptables leads to one of two scenarios:
>
> * building iptables >=1.8.8 fails due to the missing header
>
> * building iptables >=1.8.8 succeeds, but silently uses the header copy it
>   finds under /usr/include/linux/netfilter, which may not match the version
>   of the other netfilter headers, resulting in a potential "Franken-build"
>   that would be difficult to detect (unlikely for nf_log.h, since it seems
>   pretty stable, but not impossible)
>
>  include/linux/netfilter/nf_log.h | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
>  create mode 100644 include/linux/netfilter/nf_log.h
>
> diff --git a/include/linux/netfilter/nf_log.h b/include/linux/netfilter/nf_log.h
> new file mode 100644
> index 000000000000..2ae00932d3d2
> --- /dev/null
> +++ b/include/linux/netfilter/nf_log.h
> @@ -0,0 +1,15 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +#ifndef _NETFILTER_NF_LOG_H
> +#define _NETFILTER_NF_LOG_H
> +
> +#define NF_LOG_TCPSEQ		0x01	/* Log TCP sequence numbers */
> +#define NF_LOG_TCPOPT		0x02	/* Log TCP options */
> +#define NF_LOG_IPOPT		0x04	/* Log IP options */
> +#define NF_LOG_UID		0x08	/* Log UID owning local socket */
> +#define NF_LOG_NFLOG		0x10	/* Unsupported, don't reuse */
> +#define NF_LOG_MACDECODE	0x20	/* Decode MAC header */
> +#define NF_LOG_MASK		0x2f
> +
> +#define NF_LOG_PREFIXLEN	128
> +
> +#endif /* _NETFILTER_NF_LOG_H */
> --
> 2.25.1
>
>

--QdQHmYSQYrX4l6hI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmKsf4IACgkQKYasCr3x
BA3cABAAsFpj0U/and8ABGmsFeu5ccMPkuRP3QwxAlghOmKktopULeLfmpceVBAR
z4lhUKxOx9NZM3jLgXNkd6GgREmbVYC5C1aEK4MifG2dHtlbYu2xLvNFxE7gTIED
ryn5FXh1b0sjfiBKyE0x0rqWpSeRtT8o6e1Y1er6llI6QBe2GuAGLtGAsVH2KJgP
GgY7HnWR0g6LQ0TEKY6rBm4dr4I23WIJ7mC+rWbp8zzJ7DdAyRbZIm0Npbi+ddcF
COShbOcYvWsLnW73fUTqS6bBL9gl3A01My28mcge37o96WCb4iHwgUGnbCJQ/ubv
dXN+Gcmyh4D36eJ/sf7jQmJPW1mvZ7UKjaSaVLpV0KWTODuxV44l0UvTtn6Wbm3C
q76W9a15MJ4/+c7mGhZRm3N3b2hA7sm01ZIaZY19J4IdT2PnbUX4NlWWmG58NQm/
c7NhHr7iZuK9V1QcIwoxZlAKQ4E4rViVyRUmGR/gwMplhTpaEN7pCY1ChJtC85Yx
U+pSG9CzG2gMPVFXDBs/v63sdfFXYLrbcQPaaT83ww5IXhIeVV3cF6UP/0SOj6lw
BDcfJcnHhaiqRp798Uh+r7g+9vs6Ogt5OBE058Hxn1MRNuM7ue72BElR3LkCK7Zs
Who5pXWDB4/264zPpKyLebrR+YriR0qD1F2i4CEqL/KR8rV7v60=
=L8Uq
-----END PGP SIGNATURE-----

--QdQHmYSQYrX4l6hI--
