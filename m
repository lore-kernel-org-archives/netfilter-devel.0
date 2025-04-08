Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D976C3597F;
	Tue,  8 Apr 2025 00:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744073274; cv=none; b=LVyauuDw62AIkYUXywOoGJocFStQarK3F7FcGMhZt4g+zrjTKKQyDy16oze+xrIiwKVHf6tB6nSu4lH4vdvYc/8L69txCT7TsBAE2ze2VQuQmnm/eeF8LXMukCyLkNBU0Gm0+2yB9oXwzctWkrlNl6dLYUg5kCg8CS7FhrBrR/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744073274; c=relaxed/simple;
	bh=oZzd4JgvsauRQ1gJUEoqzUUmgG/jRx6mRX7gvyNJilI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u50nPfjG2wFXIEePlvpJ5noG0aPsmTY7isGbCyWFrE4U9wyItopA39SZNOeetrkOvZZLr7La+QhrUE3evgUTWGBrHmFbC3Syc+NSUDlmhHRDLk6ESMjQ5KRtQtY/N8suY1P3P5CkrwCrRDyYVnw+rd3gmdoCNmzXmO7VuqTjSHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TpLlI9eY; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TpLlI9eY"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-736dd9c4b40so4093764b3a.0;
        Mon, 07 Apr 2025 17:47:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744073272; x=1744678072; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oZzd4JgvsauRQ1gJUEoqzUUmgG/jRx6mRX7gvyNJilI=;
        b=TpLlI9eYPJXRIushWwOMdPPLSDfzr1BQHZOzjyzBzTcZCsFeGQ+CLLKPT+qVMZeemT
         pUiG+kA6y5QObYR1cTGkj4FsKScPZDwneo/qz/srsXKXTuogLCK5h00/PanrqapYIavE
         zp7cHrV05VTZP1REMf70cUbjuedfX8lVtltOeW6S/ZaKFNlEMMweTAGP32O3WMcrVAoe
         txQARvXZv/h1MlS+rDN7BX39DJErfkI7Y077jE26pXRZE8Gw0gZdHFtbOhfEzraFiZgd
         AX59Rpb9nMCOKpmzQywegXmGzqHo5tVgz1mRru2dNaI0wOSE1NzhV8mBEJ1WJ+2NsFlW
         V5Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744073272; x=1744678072;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oZzd4JgvsauRQ1gJUEoqzUUmgG/jRx6mRX7gvyNJilI=;
        b=KicaBaGsow22PZhu5lpeUTbPV8RnS2TM3386Jm/W1yle4PvXteWAwdR515AdF+dxt1
         otonC5ni0avcriav3pjU0C28alLqo9hbZ3cR/AGcZw20KUhZhRetjg6sVl6nW9nFncU3
         oDcX3tIo9uEjVlAWRbd89YfFE+eHUZcqWKgcHBXVIZeKLLyw/sKDQ9uZjQlLy8GNjE6B
         2/f+9Dy54SE7IgZnvJ3Gg0rhugZva7as9/GRLRfu5Eu5xAGqi/LzTvwZIJC1CwOS+6V0
         M2QP7ruPEKFE/cE72sqWIvv55vVGIj2l88CUCMWGumAJIWST5AoEjhcFZnjN0WJ7gAg1
         1IRw==
X-Forwarded-Encrypted: i=1; AJvYcCVNK/zz0jwr3uKNUsgIgLpmSijHmnkBTLZemBiQOS+qPTBLgiyjBVQI3A0xfizi0Lw3SSf0adnC0nA=@vger.kernel.org, AJvYcCXelh7hBpqBDPCht6tKlJrI74EGHslzLR/XxWH39pLzkijUP6/OeEu6rDSu8q96yNm3luv5sDcIlkIkNYPi@vger.kernel.org, AJvYcCXx19QRDZs41iVdnV5DM9CYXPJ+aPVbXAyingnxTOXOA9gqkDZ0Bott67OcwvLg6TYRvgLZznWlaU9ziZG1byiN@vger.kernel.org
X-Gm-Message-State: AOJu0YwKQ73XM/+VfcL/lIRZ3+vAIHODLaDtRQ8l5ppDjMMuja6FGuYN
	wzSBTrS8EsfOolsHbpFKBoO4GQAno7Mzrx8mEK81VrPqTpoePqp9
X-Gm-Gg: ASbGnctmPLmwMmq21R08He5LDimvd/tSMIQ+b2JqKp0whcCrtcT1DCG+t4KRUgK0RBz
	q1wip7zdce4ZqvGEStis/irLEjgxaJXiTNHTjiUy6i2wjzLCiD7x5XejU+rXlBGEwX7L/y92lw5
	OHPqWYe0npAp7M7PLJa/9OZ8NqOB+wiWBBB1fcGtom9GXX3SqJnz8TIUBBAc3TVQiYbVQdE3LzW
	pHAs2bMgxblRJz1fTnQsPVbn14BehQcboTeMtxjzuT/pXnIu7cdIqxLIwbj5DtUPpSDetXmrp2B
	h3kLs6/LjQCcbB/+SuIs8Z34tSEd8s3Fy6CnoYDjv8zhA2USfn4YGzQ=
X-Google-Smtp-Source: AGHT+IHbzD3pDAoVViW4x6OsfXpc/ZunvE+qr3/jIMkXXUfJThHznNKHobr3vIEqBOPjCMe5srcHOQ==
X-Received: by 2002:a05:6a20:d49a:b0:1f3:383e:7739 with SMTP id adf61e73a8af0-2014392c946mr1980131637.7.1744073271885;
        Mon, 07 Apr 2025 17:47:51 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af9bc318707sm7942832a12.17.2025.04.07.17.47.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Apr 2025 17:47:51 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id A3B17420A696; Tue, 08 Apr 2025 07:47:48 +0700 (WIB)
Date: Tue, 8 Apr 2025 07:47:48 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Chen Linxuan <chenlinxuan@uniontech.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Jonathan Corbet <corbet@lwn.net>
Cc: netdev@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH] docs: tproxy: fix formatting for nft code block
Message-ID: <Z_RyNA-iRn7C1h7Y@archie.me>
References: <CFD0AAF9D7040B1E+20250407031727.1615941-1-chenlinxuan@uniontech.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="XrdiRZkpEXQfktZX"
Content-Disposition: inline
In-Reply-To: <CFD0AAF9D7040B1E+20250407031727.1615941-1-chenlinxuan@uniontech.com>


--XrdiRZkpEXQfktZX
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[Cc'ing netfilter folks]

On Mon, Apr 07, 2025 at 11:17:27AM +0800, Chen Linxuan wrote:
> Signed-off-by: Chen Linxuan <chenlinxuan@uniontech.com>

Hi Chen,

Missing patch description. From what the patch does, the description should=
've
been written like:

"nft command snippet for redirecting traffic isn't formatted in literal code
block like the rest of snippet does. Fix the formatting inconsistency."

Thanks.

--=20
An old man doll... just what I always wanted! - Clara

--XrdiRZkpEXQfktZX
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZ/RyNAAKCRD2uYlJVVFO
oxV9AP4yfBfelSDqPIYOI6vzlAeU1b61jxRFuEeSMr6ZbSMsygD/VKoz0dVl99vC
ULu6QZJ2Vy38lRMOTGbPB2HD0NGaQQw=
=U0pP
-----END PGP SIGNATURE-----

--XrdiRZkpEXQfktZX--
