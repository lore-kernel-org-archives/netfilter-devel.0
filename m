Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE07A18B477
	for <netfilter-devel@vger.kernel.org>; Thu,  6 Feb 2025 12:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738843372; cv=none; b=H8E50ARWt6wGaRPzxaxHW5t9ZAG2ZOkXBb2+RpS2xkDEpbIfsVknRC0zCHwuDQKrVaBAcXNvHBxwKFtG3NK+6VoLl3qUyMKGNb4vDf4/NkyuKJFCrHE6muvipQM53DjhjR0YvDTNpsK6X1UqqCVVxlzQyXj/qzrlBiC9DEoI83s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738843372; c=relaxed/simple;
	bh=vWTC+nlqlVbeeyYDH5W7ranj/auVVsmaJdOmLpc0i04=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=pM3prilLui/Cr7gzFb3S7PkIx7cqngzecjJDtzDFNxtvKZUVSW97dkK6/XqpFpHjN6yK5XrOKjpU60RqX5lJLM+v/DapXdE0lsa4YwEOl3Ea34pZM8h7FyC9vtsHcrcfbCa/nasW7s/91Y2LC+cEnDvY23cMH+vAdB+DhLtcR9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hDVeVWEb; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hDVeVWEb"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5439e331cceso1044701e87.1
        for <netfilter-devel@vger.kernel.org>; Thu, 06 Feb 2025 04:02:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738843369; x=1739448169; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vWTC+nlqlVbeeyYDH5W7ranj/auVVsmaJdOmLpc0i04=;
        b=hDVeVWEbOPM79t0qjeuDusOh3hcYbZAQwwbjjxOpHOxghiouACdAzQ6IzSHaRg0wLK
         Cb4A9lfJnTIgy+xT3vbgdT0X38/Ak8tSVJboaWKRloJFVrK/xj4ZaKEfzgZDU1sdMnu7
         bkXDh9K3bUJ7yg4gfCihmnzdr+0GzUchbmXeLUe4UfVmSIYNX1zSpGRt4xnqiYMt3ADw
         Jy9PhqKQG2X/0xfXbOUA3TeTntYkXVKl0pReR0FR6eW2wRSLtaTq8lzGQktqyYA7ddr4
         GNFETz9rzM8+oJw8e9+aGNesllFyRw8oPS7pu2jpMHFoA2MouDXaUo5Nxrulv3E0tsVl
         nEAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738843369; x=1739448169;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vWTC+nlqlVbeeyYDH5W7ranj/auVVsmaJdOmLpc0i04=;
        b=boMXk086Fg6lcFr9S11xFtUCIGitscMk7mR1zqucjUID86N+SD4BwhyF/2oWcbIGTU
         0rDz5wFgsbTKGyWHpetWtLNj1lYjiL90ButK7Q0eFc65cGDz6H46xibWYcon5T1p6osQ
         wUV5mnZeeFncdgZdqdBU2DcgLWj+HbenmuwlLpLjNTsCeqxZvtJDVI7Yw7tBxo4SXnFm
         ceij+zadIFhDG2uXsgSYshpt4eybpIWodltyposZ01xjctv9/95nuYOZScrJySATOohE
         KyBrv+G2/8HyTuONslOkYzuOHeY8W8Kwkee4I9e7axVLGYoB2sXF5rqxjCtpUvlBSJSK
         pFjw==
X-Gm-Message-State: AOJu0Yx5Thg/XVYbnvrfp/l0emCXwMeU2gqZa+RelwQ5pbknVlGBeU5c
	jDW5h0Rzi8jg+P41vEfA7y0JTZqnxkO7AWgRZt6Lt3QInYRGWVnyDLL/Js9m
X-Gm-Gg: ASbGncusGqacdVJj8VcP5edHeYszs++86iZhqouOU7kbUPFeVEgSw9C31sNoI9QaLvq
	gIeUvF346TbE5tlGo0Rb6u13AcKAeCRBO4AOLwKqP7KO+Fkhey8maXA0pmLG4gGDZ8/rQXKRRS7
	sIcaISt6s/4RUFUhq6dPLfV/bHrhqVxWDqtCczbNDi+Uc2V6x9hhJJcfyjEuf91fEemidY3m1V6
	PBr25/8HyOxv5kn9s8uyRb3RyPagqYJje8Iy+FJPXBLtkONE7P9S82cO7EZlK7kDvsDQiu3oecM
	bhli16UGJJPqrpMnDSMPrriQFf8E6MSAcTsO
X-Google-Smtp-Source: AGHT+IFZ3J6FEug8FIBRIwRFfdSq5i6IPUaGHRCOl+tsmLmd/e5n6pYC+nuipuOkrrXfk0jjR3HpQQ==
X-Received: by 2002:a05:6512:3a95:b0:543:e406:6367 with SMTP id 2adb3069b0e04-544059f9c87mr2288748e87.4.1738843368703;
        Thu, 06 Feb 2025 04:02:48 -0800 (PST)
Received: from smtpclient.apple ([195.16.41.104])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-544105bf6e4sm114590e87.155.2025.02.06.04.02.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Feb 2025 04:02:48 -0800 (PST)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3776.700.51\))
Subject: Re: [PATCH nft 2/2] parser_bison: turn redudant ip option type field
 match into boolean
From: Alexey Kashavkin <akashavkin@gmail.com>
In-Reply-To: <Z6SjIEKagIkqvo57@calendula>
Date: Thu, 6 Feb 2025 15:02:38 +0300
Cc: netfilter-devel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <5A90BD87-D18D-44FE-B504-FCDB279BB252@gmail.com>
References: <20250131104716.492246-1-pablo@netfilter.org>
 <20250131104716.492246-2-pablo@netfilter.org>
 <D068290E-A9A3-4CD3-9C75-413626D540D6@gmail.com> <Z6SjIEKagIkqvo57@calendula>
To: Pablo Neira Ayuso <pablo@netfilter.org>
X-Mailer: Apple Mail (2.3776.700.51)

Hi Pablo,

Yes, I agree. If a template field like IPOPT_FIELD_ADDR_N with the =
required offset will be added.

> On 6 Feb 2025, at 14:55, Pablo Neira Ayuso <pablo@netfilter.org> =
wrote:
>=20
> It should be not too complicated to extend this to match on any
> address.


