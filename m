Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F70266F00;
	Tue,  8 Apr 2025 10:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744107433; cv=none; b=DcHaM9Swp/ABEzMNsD08N3+Y8tHgsbuNJQZ0crFAwl52YKv9D1NStyyV+pLc0OiwtCdPz0LbIIVc1gue49ZwsCpH1DiFS/HGNPZdw+NvN4CW8ukWNZG3CmZYr2JFXaAFe8keswxaSLsueZFZpSH5Xmav9N3ZzugX+h/9xgghzCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744107433; c=relaxed/simple;
	bh=736G2apeomeQzQLQNn70+8WDF7tENExMlzpiF54YdL8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RnXUx8CYYdxKfcbFmlyQ/0A3oYDjtJorEg67Tj3aYXG1Ldl0tyv+DsOU1QZ1yTDGRDmSLvKG6poNTRfnJFzYt9j+K+WcgnYCT32EkgC0mzXYQ+pHfhvyzKBlli/Xw8WOv0JLR9khLzDswFJBcaW0RHvS4X/PEr3IcoT5jUN2zRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IJgkg2Nn; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IJgkg2Nn"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-223f4c06e9fso48542605ad.1;
        Tue, 08 Apr 2025 03:17:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744107431; x=1744712231; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DpeW4Qd2oNnnvdkMpsqQ394QeaU9SqFINbmUybLaaDk=;
        b=IJgkg2NnS8oHuaZ4jg8LvZgdVXpPbmYM9bn00UXzCR2YYnG1R4zUrcwHs2GJx+L0yp
         zw9b//aC/HZrsl9Oe/VVckYuUI5FfxHJD5qBJb3NEKSpwhPbyaCS146NUcBsc/I36S/z
         yo45MqmULVf7KXF/EZMV+3p4gzXO1dfKlMu2Muf8zquP++kUzuHPw4gX++eOcZ0GopC3
         i1R9qFizwG4w+itcyuhahIHX7+6TpUj7I61zTWxRNF5FKVYkNaRIhWW5gqzl+feLDj4M
         FE9i4rPydZ2NLT+zF/ueCIPvdaCWbcKH6LGi2t7eMQ2hMUPgww1UDU2KA3Iv4og+ffDg
         oXEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744107431; x=1744712231;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DpeW4Qd2oNnnvdkMpsqQ394QeaU9SqFINbmUybLaaDk=;
        b=OmFpUzzph55j47CHGGAIfmWB2yPOvI4U69aZr1/xbVzU5yva8O2pv0RQRs473PScjD
         dB8N98s22FgFguSJXQuPaaadmg638TwuJcNK7PQVFdspEXGkw4mJrVuodm0cb3hQ0Zh0
         HDDBCUQB6j2pdbd86hSrIWdL8JqkhLXEPIQndBqFpRkSEWud6etSC0H1AxA7hvSv9Ngh
         nCU34vc9p8rgFTYvMguR83OdivT2NYC4EG1TGGecm4WO6SmlBH/uMXOeuYhsenkqvhce
         0j3lFcM1Dpn+GObkgp1bvkvpt/OW1NYg0KF4AOA9rrlQdLFA/L30/EIXzt/9XA7OZQbb
         HqWQ==
X-Forwarded-Encrypted: i=1; AJvYcCUsO1tULjFiYg50CGMN9OMRMX8h6yFP2YGg40V2wCx3YowWe5RDzx1DHiqaYf6/h68UiGZbIet4+d5L3PSd5rqA@vger.kernel.org, AJvYcCW9Tx4qNgt9OmPo/2fosh7dfjbxXQY2XQDRwoNu3usTZMg4/tZvQVXhmKNnT9RMW9x1S2AkJ2KyGi9a9KFC@vger.kernel.org, AJvYcCXcx7hTT2+kV5pud2jfRyTQSlIsOQvICY1N1qRfW8HpXrfhRzyUAqoD0kdL6VTuvybHJUVvflz4@vger.kernel.org, AJvYcCXtGB2AbB+WdF3fh5hM/697mxv+bSwWL68Nw0EcP9DaIgiEO1W7kkV5kLUXQMHQQwscZ+PD0GcrPQQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzeVwY+8MUzHk8um5pmueVspscRllSecSOfB82GWQ3PH/ulCyPb
	5UydAskilq8YxoonxAfDRM6Aga4Bd/hLOHrDfUQKuBMF1vuPzzP5
X-Gm-Gg: ASbGncuVU22D8a4npRGenHKZPXTPgvQicHZ2PcF15CgVUbo5wJzjgEXJ+mjyqh+sevp
	aGD79DhKC7ES2xdnvkqlBcvZa6WaV2Swsl8K6hclwWYGUWrZ8j3rOgEwgdYYhvX365pjrulJI2P
	PjwCv9Wr8UKxMPOZoN1yJ3u9rjnfczXVtkTxjTl2NC4NZjamtryWi/6AIozJSi9dygsAwuVedgb
	C1qwt1AEwL10gtxgz+xA/L5lbf+DB2QbEyINpsCq7bJcrqGQHsycb5HPrZrHw+/DS4D3jLMywCs
	Yg42v0HBs9TBH7Pxc7amJRwH8F1xjTfh8k7n3EwP1YS1V1z/Wdkm4bA=
X-Google-Smtp-Source: AGHT+IHYr0vMuLeca2YL+JoInuTlpm4R7J936UMmsPjcwCBCHJPXwStALyV/sFgYpKLNULCP5SqL3w==
X-Received: by 2002:a17:903:1a08:b0:215:9eac:1857 with SMTP id d9443c01a7336-22ab5df17cbmr45447315ad.5.1744107430801;
        Tue, 08 Apr 2025 03:17:10 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-739d97ee2ccsm10136037b3a.47.2025.04.08.03.17.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Apr 2025 03:17:09 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 694FC40EC3D2; Tue, 08 Apr 2025 17:17:06 +0700 (WIB)
Date: Tue, 8 Apr 2025 17:17:06 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Chen Linxuan <chenlinxuan@uniontech.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Jonathan Corbet <corbet@lwn.net>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 nf-next] docs: tproxy: fix formatting for nft code
 block
Message-ID: <Z_T3onGJiXbbd8ST@archie.me>
References: <E25F951CDC9F22B2+20250408073550.3319892-2-chenlinxuan@uniontech.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="lOutzB7gY2CfihoH"
Content-Disposition: inline
In-Reply-To: <E25F951CDC9F22B2+20250408073550.3319892-2-chenlinxuan@uniontech.com>


--lOutzB7gY2CfihoH
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 08, 2025 at 03:35:50PM +0800, Chen Linxuan wrote:
> The nft command snippet for redirecting traffic isn't formatted
> in a literal code block like the rest of snippets.
> Fix the formatting inconsistency.
>=20
> Signed-off-by: Chen Linxuan <chenlinxuan@uniontech.com>
> ---
> v2:
>   - Update commit message according to suggestion from Bagas
> v1: https://lore.kernel.org/all/CFD0AAF9D7040B1E+20250407031727.1615941-1=
-chenlinxuan@uniontech.com/
> ---
>  Documentation/networking/tproxy.rst | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/Documentation/networking/tproxy.rst b/Documentation/networki=
ng/tproxy.rst
> index 7f7c1ff6f159..75e4990cc3db 100644
> --- a/Documentation/networking/tproxy.rst
> +++ b/Documentation/networking/tproxy.rst
> @@ -69,9 +69,9 @@ add rules like this to the iptables ruleset above::
>      # iptables -t mangle -A PREROUTING -p tcp --dport 80 -j TPROXY \
>        --tproxy-mark 0x1/0x1 --on-port 50080
> =20
> -Or the following rule to nft:
> +Or the following rule to nft::
> =20
> -# nft add rule filter divert tcp dport 80 tproxy to :50080 meta mark set=
 1 accept
> +    # nft add rule filter divert tcp dport 80 tproxy to :50080 meta mark=
 set 1 accept
> =20
>  Note that for this to work you'll have to modify the proxy to enable (SO=
L_IP,
>  IP_TRANSPARENT) for the listening socket.

Looks good, thanks!

Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--lOutzB7gY2CfihoH
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZ/T3mwAKCRD2uYlJVVFO
o2H1AQCqpWATDJP7o7k4rSxXkk4aLXLdFT7RnohNUSXo7sXASwD+Pbdyev1h+ajV
8tnrlhbJxam4wN8ihSaGW957+UCg1gc=
=DNf3
-----END PGP SIGNATURE-----

--lOutzB7gY2CfihoH--
