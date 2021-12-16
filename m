Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF578C433FE
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Dec 2021 17:54:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239625AbhLPRyn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Dec 2021 12:54:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236102AbhLPRym (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Dec 2021 12:54:42 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F99BC061574
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Dec 2021 09:54:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=CM7tzbw+8Y/L/glVoCmKBjPJEfxAbaAEePxvwKJodFM=; b=cRtLgm8+soeJ52jV6lbYfDujON
        YX2dMyR+u+R03ZM3+zxIih5EcnxH3vpqMZgYtTEYdHjaqR89Ew4UnDF/zg8Cu88QIvgnjHxm+BRY5
        jNV1B+FZXPfm8EV7LwOMuV5504uaDy8UyfwC6/lJy4wP+9BgPTrrNL6wHQdh9oiSPE+/AeTdEdeif
        b92JUK6HL1kOhTyswRxXJCg7bu0P/b4xLgwC4WOJSMi6g6+UiP3gRUQx7j5oDPvRrbCu1Egz8oTvC
        asBWq4VvTND7fVW0ZJPFuHBMg0yF/5+uNVI2EKvxxxwfnS2z6NtPOThNBzWe6UtStiqZqAZSIvawd
        3thheN+g==;
Received: from celephais.dreamlands ([192.168.96.3] helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mxuxj-009WUI-Nv; Thu, 16 Dec 2021 17:54:39 +0000
Date:   Thu, 16 Dec 2021 17:54:35 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] proto: revisit short-circuit loops over upper
 protocols
Message-ID: <Ybt9W9ha+TyQW1VK@azazel.net>
References: <20211215233607.170171-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Jr0nn2hvr+hFjC0V"
Content-Disposition: inline
In-Reply-To: <20211215233607.170171-1-pablo@netfilter.org>
X-SA-Exim-Connect-IP: 192.168.96.3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--Jr0nn2hvr+hFjC0V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2021-12-16, at 00:36:06 +0100, Pablo Neira Ayuso wrote:
> Move the check for NULL protocol description away from the loop to
> avoid too long line.

LGTM.

J.

> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
>
> ---
>  src/proto.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
>
> diff --git a/src/proto.c b/src/proto.c
> index 31a2f38065ad..a013a00d2c7b 100644
> --- a/src/proto.c
> +++ b/src/proto.c
> @@ -59,8 +59,9 @@ proto_find_upper(const struct proto_desc *base, unsigned int num)
>  {
>  	unsigned int i;
>
> -	for (i = 0; i < array_size(base->protocols) && base->protocols[i].desc;
> -	     i++) {
> +	for (i = 0; i < array_size(base->protocols); i++) {
> +		if (!base->protocols[i].desc)
> +			break;
>  		if (base->protocols[i].num == num)
>  			return base->protocols[i].desc;
>  	}
> @@ -78,8 +79,9 @@ int proto_find_num(const struct proto_desc *base,
>  {
>  	unsigned int i;
>
> -	for (i = 0; i < array_size(base->protocols) && base->protocols[i].desc;
> -	     i++) {
> +	for (i = 0; i < array_size(base->protocols); i++) {
> +		if (!base->protocols[i].desc)
> +			break;
>  		if (base->protocols[i].desc == desc)
>  			return base->protocols[i].num;
>  	}
> @@ -107,9 +109,9 @@ int proto_dev_type(const struct proto_desc *desc, uint16_t *res)
>  			*res = dev_proto_desc[i].type;
>  			return 0;
>  		}
> -		for (j = 0; j < array_size(base->protocols) &&
> -			     base->protocols[j].desc;
> -		     j++) {
> +		for (j = 0; j < array_size(base->protocols); j++) {
> +			if (!base->protocols[j].desc)
> +				break;
>  			if (base->protocols[j].desc == desc) {
>  				*res = dev_proto_desc[i].type;
>  				return 0;
> --
> 2.30.2
>
>

--Jr0nn2hvr+hFjC0V
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmG7fVEACgkQKYasCr3x
BA307g//QFrlWI3COTnTcqgwOkeicxFxC8qIgmP/EFLwUn0lMOtlKlkk4vfQ/KNH
m9NFYLAJvAw8kMnP9/yyzx4NfcolP/naLsGaBsC4IiH0jYaxqdK+mwd8DK+0dhRj
Mdn+rFMMWM5hn5eCkGg+y5k8BgpaHNBNBrD/uzZSqGT2oorjlRABha262KFKq3N6
hoikVM6BCM5IdAXpiQlPbErUwNHFMi7njXuQUoTP5Rfm36WX+tMjGes5ulA36H7N
1yLTSXQrF+6b0Uq49gZKsLqvQtBC08aRf1mhbN5VajwPqOD2f4H/YwnndutZz14o
EJC0oWjUqV/Jz0Ewy4o7IBGQGESxj1bottq9RfdpOrX1iieMJSH4QB129gXMaXT6
eo69ymlkfNY++zUyzXECp4JbrM5VdNFSlVonMWSgGoFanaVPCJ9GwDQ+GQxLwMLX
bbRWZ4/fTxOFK4Ia3qpaVmECNc6LGwRwa0J7zvk0y7bX9XtJp4HvfC1AOc8B5gf8
yLZIgSdyIQDSAOr2TtAQdlz7faf9F6ieE79+7Kg+C+veJeErZ5Id+dVR2PWh5iUG
vjJXK+qMZC02Ky0Ee83iGLs0oOpE8O0M9Js2Ljx2Xy7q2vhCQ9gVOTVb/6AQc4dS
hISc5Agn/jnct5F0cNaCSPWCNy6I8T+U8tHfgyyFB/Cb0DBLVTk=
=q68J
-----END PGP SIGNATURE-----

--Jr0nn2hvr+hFjC0V--
