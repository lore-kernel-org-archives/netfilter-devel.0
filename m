Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 082F1C6FD19
	for <netfilter-devel@archiver.kernel.org>; Sun, 12 Mar 2023 20:19:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbjCLUTp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 12 Mar 2023 16:19:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbjCLUTo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 12 Mar 2023 16:19:44 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3819F2F781
        for <netfilter-devel@vger.kernel.org>; Sun, 12 Mar 2023 13:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=RUISPNjGRL7kw5SpKdBDiC1xV4Wjddi2iB7D6/FRKsM=; b=XxEXHZSx+qPfIAulfxH0aVKFRo
        m4xBaxPKdJ26yS8bxyHBS4zycYrrZKdpV7brAYMbG752X7w8TX3JXu9LtAnz1QfVOpjuKXwCMAIpc
        YdWUMrSrve8zozNzmoXia3y9DObV3e0V24dxmhOSEsytsMiBlKVTrpgDRwZP6v9BukOQy3SjF7HFE
        B46Vy1fsRaSBMjyANNnHRnfc5RufskXaT8UgvtuQFiEIt1xRiq10xWKGWMolQCFiBfzFRX5MTCfHr
        SsT7OcuVQdklJPPOBVAD9xRAlo20zB9MhUNaT2j1aNbXmDzmUVJgWfvhaPfksJHAoYBXIwAGRRRcV
        pD/a/ung==;
Received: from [2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] (helo=celephais.dreamlands)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1pbSAP-005lcF-Ht; Sun, 12 Mar 2023 20:19:41 +0000
Date:   Sun, 12 Mar 2023 20:19:40 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nftables] exthdr: add boolean DCCP option matching
Message-ID: <20230312201940.GI226246@celephais.dreamlands>
References: <20230312143707.158928-1-jeremy@azazel.net>
 <20230312200003.GB26312@breakpoint.cc>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="fECf9Kjl8wjwW/OE"
Content-Disposition: inline
In-Reply-To: <20230312200003.GB26312@breakpoint.cc>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--fECf9Kjl8wjwW/OE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2023-03-12, at 21:00:03 +0100, Florian Westphal wrote:
> Jeremy Sowden <jeremy@azazel.net> wrote:
> > - * @TCPE_DCCP_PKTTYPE:	DCCP packet type (integer subtype)
> > + * @TYPE_DCCP_PKTTYPE:	DCCP packet type (integer subtype)
>=20
> Can you isolate this as a spelling fix?
>=20
> I'm reluctant to add dccp support because there have been discussions
> wrt. removing dccp from kernel altogether.

No problem.

J.

--fECf9Kjl8wjwW/OE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmQOM9wACgkQKYasCr3x
BA22cBAAiSpxbyaWJctjEm+fkCZMoiXhJPEA1wfa62xw+0u4hy1EbhvTEAJxgRkT
Bk2iLngBNT1LZc4FhbiqEEYUD8X6jMlFerqtM4xDwHQH7OYbdpa4pylSxHLLkMBo
7DmyGNmDPHMWh9ORGfh/bgQfHbo7/IEy7eZuCYgRdhtRPa6P8BvkoOGZMdqjJstM
V99B+DS9ZaGJ+h+zk4+J4720wUV1V11oaFePhAyyQJSy9PMzMx49qh4G1FJpFlId
L5ZLN8IPceVeFvhtytyffvJS7yqThR0C9df+XjItfF81h0Pi9khSPDJl9b+OkIzp
mq5T+fO51NEHhdaQZlc8mpzA3nP/n/FZG0DrFMAOrlMs1P0GztSYY3Hgbhwy96/o
63hE/YPqOEXbFmZX+dTSkMSmvu8+OQUb5E7J1IBaQHmY4FdBGZ7p+iZy7sziwc4N
CLcOm0QpFgEBA4S1VS7SidvHXi+o9mXP7ibx5LcF85TVkUywzvFqktsIiVbGsRUU
735knfElkEKRG6jeOKCyuUmFn0BnNTGKoSuvIOHbWEDl7boMZKJu8inzS18SEzFb
/6yAUx4FMdfZtIVzCVQHmu1XnVhRfazMqoYl/xSbSf3GJbEQ6vXYeI08GNeA03+6
DHoHwz8vZ0U9KfF2+vAmB7MROxsdUsogGPR2vRRG7c453BjzBgw=
=+cpi
-----END PGP SIGNATURE-----

--fECf9Kjl8wjwW/OE--
