Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D2C8C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 12:59:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5AA8660EFF
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 12:59:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbhJ3NCV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 30 Oct 2021 09:02:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbhJ3NCV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 Oct 2021 09:02:21 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:fb7d:d6d6:e0:4cff:fe83:e514])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 119D4C061570
        for <netfilter-devel@vger.kernel.org>; Sat, 30 Oct 2021 05:59:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=dpo1wPWn8wiJLFLH9ElhfH6n3aNf6YHEoMLOwXun6wM=; b=WN2YNnbZJEnMgJE3zLp5h7sVHU
        M9hKe70agUWjADX9YiD3dQMJV6hFv5CphxHx8X/qmrn1K0mepJdFt34ZPXpoSJfxSzGsBYyZXkqVh
        wUhrLAmKPuk5ZkDhytz+a9Ei3ZEnqTerPlANHlcGkcjhy86cCn08af4HNNYSmw+cGx4CdGFw8g+Bp
        wGzCo+M4vKI/O/ee3PPGqjRzOILaRDMCgszax/wnk3cFO9DhreQUf54hSeolmaCweWuLEWaNMfMkY
        +oxP6C1EqNt7/cLR9zWtguwVyF5VaPRsq7EAPo5kbrWTPtFcpYG09XiuypHzzCXSCWt7oisQu9fzA
        vRuvkHgQ==;
Received: from celephais.dreamlands ([192.168.96.3] helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mgnxT-00AB7D-Pt; Sat, 30 Oct 2021 13:59:40 +0100
Date:   Sat, 30 Oct 2021 13:59:31 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH ulogd 1/2] NFLOG: add NFULNL_CFG_F_CONNTRACK flag
Message-ID: <YX1Bs7C5KIBvw6QC@azazel.net>
References: <20211012111529.81354-1-chamas@h4.dion.ne.jp>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="TGHOy5M0gdYamp0+"
Content-Disposition: inline
In-Reply-To: <20211012111529.81354-1-chamas@h4.dion.ne.jp>
X-SA-Exim-Connect-IP: 192.168.96.3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--TGHOy5M0gdYamp0+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2021-10-12, at 20:15:30 +0900, Ken-ichirou MATSUZAWA wrote:
> acquiring conntrack information by specifying 'attack_conntrack=1'

"attach_conntrack=1"

> Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
> ---
>  input/packet/ulogd_inppkt_NFLOG.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
>
> diff --git a/input/packet/ulogd_inppkt_NFLOG.c b/input/packet/ulogd_inppkt_NFLOG.c
> index c314433..ea6fb0e 100644
> --- a/input/packet/ulogd_inppkt_NFLOG.c
> +++ b/input/packet/ulogd_inppkt_NFLOG.c
> @@ -33,7 +33,7 @@ struct nflog_input {
>  /* configuration entries */
>
>  static struct config_keyset libulog_kset = {
> -	.num_ces = 11,
> +	.num_ces = 12,
>  	.ces = {
>  		{
>  			.key 	 = "bufsize",
> @@ -102,6 +102,12 @@ static struct config_keyset libulog_kset = {
>  			.options = CONFIG_OPT_NONE,
>  			.u.value = 0,
>  		},
> +		{
> +			.key     = "attach_conntrack",
> +			.type    = CONFIG_TYPE_INT,
> +			.options = CONFIG_OPT_NONE,
> +			.u.value = 0,
> +		},
>  	}
>  };
>
> @@ -116,6 +122,7 @@ static struct config_keyset libulog_kset = {
>  #define nlsockbufmaxsize_ce(x) (x->ces[8])
>  #define nlthreshold_ce(x) (x->ces[9])
>  #define nltimeout_ce(x) (x->ces[10])
> +#define attach_conntrack_ce(x) (x->ces[11])
>
>  enum nflog_keys {
>  	NFLOG_KEY_RAW_MAC = 0,
> @@ -597,6 +604,8 @@ static int start(struct ulogd_pluginstance *upi)
>  		flags = NFULNL_CFG_F_SEQ;
>  	if (seq_global_ce(upi->config_kset).u.value != 0)
>  		flags |= NFULNL_CFG_F_SEQ_GLOBAL;

You have used spaces, not tabs here:

> +        if (attach_conntrack_ce(upi->config_kset).u.value != 0)
> +                flags |= NFULNL_CFG_F_CONNTRACK;
>  	if (flags) {
>  		if (nflog_set_flags(ui->nful_gh, flags) < 0)
>  			ulogd_log(ULOGD_ERROR, "unable to set flags 0x%x\n",
> --
> 2.30.2
>
>

--TGHOy5M0gdYamp0+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmF9QawACgkQKYasCr3x
BA09LQ//X69hHNI5CDdQbtopXlDMmb8VrjXr1kiw6kI7boWMRn4WDSbed2mJrQGS
YQkb0SsLu9j+3Z56vdDq/VK9AF/SPnemmpGeWJggWua4/AsYxa4vNADfi+F+mt0W
NIE0m8fQuxSVCnZkQRTqdJF07RLWMo7dY/TtyKqlZrtB8on2lc/68Ac7bNQhXgOo
vB7JjvxWjlRgK/UurWMP1J2rrCpmYzjXQzvT4ti62DT4oG3CjTcpV/dhC9C62Opq
EpoxOO1wrfhaBUlQTOOGmedS72WAJh2/n3Ei8Ed7vMiAWIFKsX6KHFlxYbmtHrya
O+qpRJkrFj7sKICuJoI9kk+l7EzEQukNkubLmCrUD8lbWZdlL0vvXJ8/5yZUlZJs
bdT67oI6evD0mh7XQrRVZyUII4ckE53kM4TJLPoedXK5mGT8q1f0HcaHdi0as3l+
Fgcl7ryOFmwirDJN0u5/K3u67wyBHQjuXL5WiZzEwOAqSYhbk1FOfl9tj/RQjCO+
LImSlSti/Uit7lgpDwc0TA3gzyEnWQlC60w7R3CIwKhTeBubu9jYxPGwOcf38AVn
xj0EwW2MS9rY2XM2tFKa9JzsM98Vlul11lDbXsP8+Z5wNr92z8LY/MZWG7ZrLLbc
Kbx9FE/tuI2v/ohVsfZ1J0imSpVTp44zRgiopnSiWUTvmN5SR28=
=moCo
-----END PGP SIGNATURE-----

--TGHOy5M0gdYamp0+--
