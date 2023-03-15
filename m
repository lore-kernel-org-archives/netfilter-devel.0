Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2887C6FD1D
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Mar 2023 23:05:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231971AbjCOXFo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Mar 2023 19:05:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231820AbjCOXFn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Mar 2023 19:05:43 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 409EF78C8F
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Mar 2023 16:05:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=EucRmdh00jpqzK8awX3kr7nl0N9nm6j9cpHwcT6ESOM=; b=VI937yH14ePbXUaL0QxCBI1R8m
        9xQxcz/LjyuYKYuI5xx0J0kS1OAxT9HHu8HLSOKxtOpS45UqPUSF/BJVK2MrCtUr03JfOmz29YayL
        2tukEI81F0SGbiMD0b7pKQJCgjo7J1f/3UGFC2W0nUNTa0GjZ5s6FgRFRdF33lYFMdY02Mg1MbUpZ
        70HLGqdv0yQBvLQH6NIl7dJ+oqactYclqZEQrnE351C4wlNrkFiYrkIyc8LPwhIcjbdvd+FJlO/Ba
        AJfK8VTcDK8BlEzoJgJS8GQtD3NM8DY5A8NFRCmsQY0PHSQp4auax6djWGqNlkz4jydv28f5MLM93
        7qQTkE9w==;
Received: from [2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] (helo=celephais.dreamlands)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1pcaBg-009wuF-Ej; Wed, 15 Mar 2023 23:05:40 +0000
Date:   Wed, 15 Mar 2023 23:05:39 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH ulogd2 v2] pcap: prevent crashes when output `FILE *` is
 null
Message-ID: <20230315230539.GC4331@celephais.dreamlands>
References: <20230102121941.105586-1-jeremy@azazel.net>
 <20230112180204.761520-1-jeremy@azazel.net>
 <ZBI8T5tl2eXKIrHf@strlen.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="kQH1ZYIVktIhhZGv"
Content-Disposition: inline
In-Reply-To: <ZBI8T5tl2eXKIrHf@strlen.de>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--kQH1ZYIVktIhhZGv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2023-03-15, at 22:44:47 +0100, Florian Westphal wrote:
> Jeremy Sowden <jeremy@azazel.net> wrote:
> > If ulogd2 receives a signal it will attempt to re-open the pcap output
> > file.  If this fails (because the permissions or ownership have changed
> > for example), the FILE pointer will be null and when the next packet
> > comes in, the null pointer will be passed to fwrite and ulogd will
> > crash.
> >=20
> > Instead, check that the pointer is not null before using it.  If it is
> > null, then periodically attempt to open it again.  We only return an
> > error from interp_pcap on those occasions when we try and fail to open
> > the output file, in order to avoid spamming the ulogd log-file every
> > time a packet isn't written.
>=20
> I think its better to fix this at the source, i.e. in
> signal_handler_task().  It should probably *first* try to open the file,
> and only close the old one if that worked.
>=20
> Does that make sense to you?

Yeah, that would be simpler.  v3 to follow.

J.

--kQH1ZYIVktIhhZGv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmQST0MACgkQKYasCr3x
BA2blBAAvFrywR+Ruzz4RgLTUopLs32G9QiBcfSGLrMEXlnpixQXocONlHBNC9VS
Cb8yvrHjRQ81UGAsqj9t6n1L3JOE/DPMPsdrWZ7MU8ln7bObYlO7tOa6DJZiBYmI
XV0ngSiaR0Hg8iBsdLL+PHOGrBbjv7KPU1AhrkTCBXGTX3rxmIVkFoJJQAXHTFr+
tmlIPU+0ct9c5D6gtiJO7VSjMYQA+dwQ8PIIEVyz3tLZEvLkXMxMRggK4b/2G0La
ZzqxwVn8PvmQKZvOmun63BupEie29csJiWS+n7fwjnoED2R1KwMKF/Tln2apHUPS
HSZBZi/2MDCRDrleo7NR4H7ekUjyVFSpqbFXEomMgOtunfFJwWjzy+I2n/qeAAiK
O0OGJH8gtLwWEjklBSimXUN/tlNCA0PoxW4xTbTIIw96/F7mNirv8sX7REGXgcYp
JX8sFPxvXE6IJz2gxhY6ZhbFgwMgAfY4Bkz7cGC2W85EVJsRnaP7w4ia/VLP1FC+
kOvh3CtxPRhRDSnliPve7m+z9UGy/6pkHowgwzwNN1XnjLKmu1wxmyauMh87qWyU
h28opUV9fxby4tkikIrSSPoIh98Jvycc94eOo+T0MqkxqhT6gvgOireyZxpvpT1e
H31sWfJgTxMMoIvqjaSfkMBRLfPUcZslQLwgFKZRRuFfLfCwBOM=
=7+gr
-----END PGP SIGNATURE-----

--kQH1ZYIVktIhhZGv--
