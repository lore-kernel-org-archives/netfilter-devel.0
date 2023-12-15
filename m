Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FE5B3FB2E
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Dec 2023 18:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="e4eJjSsm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ntxcR2atTp1E1OP5h+w/sKYqwAp2Ea41cAKv5f/WZzA=; b=e4eJjSsm9/ZhT1/THn+Su8qLnM
	ptU4Bwwif2O+dx9HGLaMEmcA7qkfhqVZ+2OqBE6kTYmCCzj6vKJdGf3I7TaVnhS82R+yCte4vC8fR
	qYt81GkT0+HjOlsNMNLbJl/F/hllk+68ZsD8gtSH9pZGJ7YM9aaCQxedqtwNIiYNz8iTd/uHAlxwt
	bn0aT7TgLyvyYXnQY14f0nrgBSaRG/dz4KragiWXlxNZlTy2OrlUg3nZK2MKOFJ0RL/lmoTqicCKp
	YKwWOw1WC7I2Z3Acn8Nt+m+PCz6XoAyqa2NCyo45mzYyFGIUX72pYDcaLzYg26wlg28tI8TMVlpFO
	E0UWG2mQ==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] helo=celephais.dreamlands)
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1rECV3-004BTk-1e;
	Fri, 15 Dec 2023 18:01:25 +0000
Date: Fri, 15 Dec 2023 18:01:24 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: =?utf-8?Q?G=C3=A9rald?= Colangelo <gerald.colangelo@weblib.eu>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: ulogd / JSON output / enhancement proposal
Message-ID: <20231215180124.GO1120209@celephais.dreamlands>
References: <CAEqktHujVnjWhdvttjmQWMSHb8mXwhV=Fz2en-6amijbHHR0pw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="fZ1/yzJp7ki/8+0n"
Content-Disposition: inline
In-Reply-To: <CAEqktHujVnjWhdvttjmQWMSHb8mXwhV=Fz2en-6amijbHHR0pw@mail.gmail.com>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false


--fZ1/yzJp7ki/8+0n
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2023-12-14, at 18:52:10 +0100, G=C3=A9rald Colangelo wrote:
> To complete my previous message, here is a patch for
> ulogd_output_JSON.c (latest version) that implements a "softfail"
> configuration option.  If set to 1, error while connecting to unix
> socket are ignored during startup and plugin will attempt to connect
> next time it will be triggered.  This may be helpful when the software
> that must listen on unix socket takes too long to launch.

The JSON plug-in already has support for reopening the socket on receipt
of a signal or in the event of a write failure, so I think it probably
makes sense to build on that.  I'll send a patch.

J.

--fZ1/yzJp7ki/8+0n
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmV8lGwACgkQKYasCr3x
BA3MaQ/+MT3q+3dxv55XqlQIDGlCJjR8Fxomym3DUUDB1g/QJ//1Sdq52zqNWSqB
zQzVJsD20sl2fzVGjiW0/89VzzWweg9Cb5vd216V7HPHwUBH6fjbG7mo1qFMZMbt
Pn4F6XoN8byL5YMTC/r/gB5uCDYjGX3pMw8h/zpSPL3zMQAl0IMG0j8vrQhFhkP9
yMxvxJW22jWbC6bGNO5YPyX2bHBFu9AYcndcjJnk3ufqMsyyZ/XgeT1uRbfwgdrd
ae3Am6SG5Dm4w+rLZYCTmRXBMYRyeTqWtMTRxwit+ht8htFAPb7FI6erfz9osmUG
5KA3H9FM3IErY1GN9xopw33ozK8CXRvzp7dbWTOUm1GONF/owBBlHZpFH95qyGRj
Hcly/2JLixNZsnj09tQ80sXImHiEYSIVRh27LSpnIlfPh2QZlQNTKz8G849/BBcL
ZrIoAh5vv8Xwi7xU3gjW9/A+WzInu34pjnVoV20FfZ6GNM/NWu7T7L6IPIYssVAn
/od7+gOIXD0C9sBwyo423rdEKzU5+AQcaFxMFZWW1ecLV4y6XG8ruUNPmDOGsFKT
Qf9ZgaWFHbIH2KoiuI50fndLhBjTc2i55YMfjbbRRrXIqgSu1JHJ2zMPnIt3uXE+
77y2I62NV5A/QQ2wfLQcK/pJzzNX2hMFeI5ynXKfeuis0VRHlTk=
=y7Uu
-----END PGP SIGNATURE-----

--fZ1/yzJp7ki/8+0n--
