Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB244C433F5
	for <netfilter-devel@archiver.kernel.org>; Sun,  7 Nov 2021 16:03:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98EE161356
	for <netfilter-devel@archiver.kernel.org>; Sun,  7 Nov 2021 16:03:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235681AbhKGQGZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 7 Nov 2021 11:06:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234767AbhKGQGZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 7 Nov 2021 11:06:25 -0500
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C2FFC061570
        for <netfilter-devel@vger.kernel.org>; Sun,  7 Nov 2021 08:03:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=wz9LIktO4fBWe30EanIccTWywFLfcWpiZhqb7Y0GJco=; b=XdlGGX9oCyTbIuEsuOZ95ikgO0
        qwVsiOv6d1QRdHuji86yIsFaIqjWuVcji2OHQ2EJN0zDj1iuWznPnrh0ejw0FG/Qd8fx5EnyBKmIg
        bYdsCNSII8+KZ8GYYfhGaIWQ+TEDq6Giq5IPCzihNACrSsQc86LXiWZiYkCsfAYCopti37rWBCCiR
        2/WnqutlZlsl0BJeILSrwnc4ZU00M1QbJ4xLWV/VgGefM5glSMUd83lsmfCZYSDsGlOBgHMtIIROt
        vnOVwo0fY2QTtxURwni2aODXkrUG8CnSBNIYQNgfz6EKKAGsIIegGp5pgUrWFFFSqREzyCtMwNgm5
        1Cdyd92g==;
Received: from ec2-18-200-185-153.eu-west-1.compute.amazonaws.com ([18.200.185.153] helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mjkdu-005kg9-Bo; Sun, 07 Nov 2021 16:03:38 +0000
Date:   Sun, 7 Nov 2021 16:03:32 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] Unbreak xtables-translate
Message-ID: <YYf41EwPa8YBKNpY@azazel.net>
References: <20211106204544.13136-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ONPi9o/C72hRQu2x"
Content-Disposition: inline
In-Reply-To: <20211106204544.13136-1-phil@nwl.cc>
X-SA-Exim-Connect-IP: 18.200.185.153
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--ONPi9o/C72hRQu2x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2021-11-06, at 21:45:44 +0100, Phil Sutter wrote:
> Fixed commit broke xtables-translate which still relied upon
> do_parse() to properly initialize the passed iptables_command_state
> reference. To allow for callers to preset fields, this doesn't happen
> anymore so do_command_xlate() has to initialize itself. Otherwise
> garbage from stack is read leading to segfaults and program aborts.
>
> Although init_cs callback is used by arptables only and
> arptables-translate has not been implemented, do call it if set just
> to avoid future issues.
>
> Fixes: cfdda18044d81 ("nft-shared: Introduce init_cs family ops callback")
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  iptables/xtables-translate.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/iptables/xtables-translate.c b/iptables/xtables-translate.c
> index 086b85d2f9cef..e2948c5009dd6 100644
> --- a/iptables/xtables-translate.c
> +++ b/iptables/xtables-translate.c
> @@ -253,11 +253,18 @@ static int do_command_xlate(struct nft_handle *h, int argc, char *argv[],
>  		.restore	= restore,
>  		.xlate		= true,
>  	};
> -	struct iptables_command_state cs;
> +	struct iptables_command_state cs = {
> +		.jumpto = "",
> +		.argv = argv,
> +	};

No need to initialize .jumpto explicitly: initializing .argv will
zero-initialize all the other members.

> +
>  	struct xtables_args args = {
>  		.family = h->family,
>  	};
>
> +	if (h->ops->init_cs)
> +		h->ops->init_cs(&cs);
> +
>  	do_parse(h, argc, argv, &p, &cs, &args);
>
>  	cs.restore = restore;
> --
> 2.33.0
>
>

--ONPi9o/C72hRQu2x
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmGH+M0ACgkQKYasCr3x
BA271w/+LRFswGONIM2T0M2W9VpK9yo5NB4xIRDaafKuK9W2AYE0EiOXhJasOE2+
5ewv8uXWeEiIedOeTWhTLBplqWH3eTt90yTJv3P41DWiWYlciFNWjjJMYD7YNZ5F
F/j6aSnpyl2DmjqNdgwOQ+XqIK83vCpkSIknzKvxwJmrHdOPNfYZLLIlfR6VGa5d
QphwpKLIBghohrabGKmf7gQ0qd1r4GYlGSv5aLtPtXZXdkwoypFlXQjvDNLHK5L0
OEUV3msF8izQhxwD/IaMKelKWCcCBAI0zc9BtkyeP1RVdyWiGAJl60uSsrU8KtP5
8ZgjLXrDynVpVaedUuVipYsdH4tHTHJvDfcm8qcBfKMu+Dv+y8X7GLIYy0lQRtC+
GvY5q1UQO6Bdz3ulLnnWEcXf5MhB5dJ72AETtwytJVkeZFTfz6I/rIaS9ZigC2uD
1K5xpb5/SyvJgJeyh6h2v+Q/rK1vnJv6DswFoDPMteg2MszJ6TR3SO69iRIGCmd4
pQQf4CgLdLAgoBbep09xQC2SaGM0mAeJTAXiPZh6ZMEwMTbRQVxlHJgPqGmjQn6A
5IIiXoiAIvN/fBbXSdcQpX1SCUuG4NxOEVdcpKWG5uSU+W2Ym91WsQf4apDVXSa3
JaTfqRdr787ucnBvjzpnENaXvyGpLajeb4R8u/j/TCUhhJSkdYc=
=dHUQ
-----END PGP SIGNATURE-----

--ONPi9o/C72hRQu2x--
