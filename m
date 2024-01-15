Received: from mx1.dfw.automattic.com (mx1.dfw.automattic.com [192.0.84.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D914B17551
	for <netfilter-devel@vger.kernel.org>; Mon, 15 Jan 2024 13:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=automattic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=automattic.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=automattic.com header.i=@automattic.com header.b="fmV7WqHb";
	dkim=pass (2048-bit key) header.d=automattic.com header.i=@automattic.com header.b="QsDnuJ6Q";
	dkim=pass (2048-bit key) header.d=automattic.com header.i=@automattic.com header.b="mLvhFTIY";
	dkim=neutral (0-bit key) header.d=automattic.com header.i=@automattic.com header.b="mD2UvSy8"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mx1.dfw.automattic.com (Postfix) with ESMTP id 276A01DBEDA
	for <netfilter-devel@vger.kernel.org>; Mon, 15 Jan 2024 13:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=automattic.com;
	 h=x-mailer:references:message-id:content-transfer-encoding:date
	:date:in-reply-to:subject:subject:mime-version:content-type
	:content-type:from:from:received:received:received:received
	:received:received; s=automattic1; t=1705325381; bh=oQro7HLcf72h
	4Wd8Zl/xcn3Bi2GJZnL4eMf36nHFiQQ=; b=fmV7WqHbqW8y9x9W6964OOQoj2Gw
	eU7JPBDacv2bzbDqM/HJX5831Nl3It8qIyP4tnW/poXZI5Axj8gdDb/EatRwtynX
	CjTqsqPl+lfxQIXo95FfwIPfmw+MWW4ewpJiIPy3io9smu8/b/hM3eap741bj7MH
	dF9NQW6UXX+J+5LwoXDHIa3tLSR2U8OtgiYDfIWwDjkNcKBiOiO88qPFfUAWAnNH
	G9dKmuGcSivNU/apO+wln7Gx+qPQPI4XE5C5vEZINq8RpAypcsomclZHQXlPsq1O
	jzGHlGs2DoxHtRyzYzHrYmp7GPzdcpJ++rYETzNbSSdHstBccsp3YymNFA==
X-Virus-Scanned: Debian amavisd-new at wordpress.com
Received: from mx1.dfw.automattic.com ([127.0.0.1])
	by localhost (mx1.dfw.automattic.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UdKQLe0DYYhi for <netfilter-devel@vger.kernel.org>;
	Mon, 15 Jan 2024 13:29:41 +0000 (UTC)
Received: from smtp-gw2.dfw.automattic.com (smtp-gw2.dfw.automattic.com [192.0.95.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx1.dfw.automattic.com (Postfix) with ESMTPS id 414D81DBF61
	for <netfilter-devel@vger.kernel.org>; Mon, 15 Jan 2024 13:29:41 +0000 (UTC)
Authentication-Results: mail.automattic.com;
	dkim=pass (2048-bit key; unprotected) header.d=automattic.com header.i=@automattic.com header.b="QsDnuJ6Q";
	dkim=pass (2048-bit key; unprotected) header.d=automattic.com header.i=@automattic.com header.b="mLvhFTIY";
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=automattic.com header.i=@automattic.com header.b="mD2UvSy8";
	dkim-atps=neutral
Received: from smtp-gw2.dfw.automattic.com (localhost.localdomain [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-gw2.dfw.automattic.com (Postfix) with ESMTPS id 322E6A03C4
	for <netfilter-devel@vger.kernel.org>; Mon, 15 Jan 2024 13:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=automattic.com;
	s=automattic2; t=1705325381;
	bh=oQro7HLcf72h4Wd8Zl/xcn3Bi2GJZnL4eMf36nHFiQQ=;
	h=From:Subject:In-Reply-To:Date:Cc:References:To:From;
	b=QsDnuJ6QQw/4EwRO0AtaU+ElO4P66TTBWTjkXfi6wF7AoarKMQ4gvG4CFiLeG6Wdy
	 8aaEI8XtTquUvi/TilrafN8P1QtAvCyzP3eVDEYt+4z/ZlWUrvLY/bjF+x9Ba7HY30
	 UMhXKbY8gxxwJJ/zL79w7NCv2MS7uVsMM2KKqaxHOzO/m1TEFxWez3zJ9SfUHn0NyC
	 g4bcyRBMtP143s3rbt775i9j22SRU45yqT5F/ghZyNzFcNHlhvhKA/lzO9WgF3hgA1
	 q0obvXJ56fuaLIYm7PvluSSddAkqw6D3KA8kbkF2LHY3QBPO04PDNYc2TRRhehj0Yy
	 BwJwp7B2kdzfQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=automattic.com;
	s=automattic1; t=1705325381;
	bh=oQro7HLcf72h4Wd8Zl/xcn3Bi2GJZnL4eMf36nHFiQQ=;
	h=From:Subject:In-Reply-To:Date:Cc:References:To:From;
	b=mLvhFTIYfEOcpVmMqyFj+cvXYew4thoAT8IyYwXOnKh3KveHGJFJtWHFk28xbC3k0
	 RBVsxDyC/uS6gUmNLpyv/XMc3hPuUe4eCde6zXyAD/W62+JC2b/QNLfuvdHqhOqe4g
	 i/OZT68CGshDWNDvbwbeRHo4VLK8Nyd3bs2hOaexlX0SRzaAOcHttaWbpC7QzOugHJ
	 rzcmCPfWa1CtLTTCdovOJjiQE9ewFDNAZZHdSBcSJTJgkcuRWKbR/4lnxVrO/joeWj
	 M/7GOb6yUQDWxJCBoFUpvlXVZQCpbV49wgE/YGPVUb+ka8IWMLAHmYHmFwORiRM8jp
	 YkYElzX3n1TSg==
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-gw2.dfw.automattic.com (Postfix) with ESMTPS id 234B8A0350
	for <netfilter-devel@vger.kernel.org>; Mon, 15 Jan 2024 13:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=automattic.com;
	s=automattic2; t=1705325381;
	bh=oQro7HLcf72h4Wd8Zl/xcn3Bi2GJZnL4eMf36nHFiQQ=;
	h=From:Subject:In-Reply-To:Date:Cc:References:To:From;
	b=mD2UvSy8c8UZXQpRIuaHdnCItVcKx78NbXTFp3OTbhGDoubUuHsZi6JFxtLbkPrpv
	 QW67RXtCHFIl+h0o+swmXwm1+/8TovYSTn+4uSSNXfkpPR0nhCcoSAu/JN5KZBg/4B
	 i7e8hbbkY0Uw+PaVpz8nDmUVBP2rQ5Kq1XgbfJB3aRFgCnNcgURx1SKh3LJxf2Vmyh
	 mZC7Gue17HlBPIp3x+1nBZ1Z6v0rbhLZxoZY842bS/fzlfmTsBcbYzN0ABAyFk7esR
	 bio1rD2comdzCR++a3cxLXtewh6k32uESrIpSDo0H/UiocLmOLwnfv+2RZENbp/pIg
	 ZaRM8bQx046WA==
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-40e5b156692so29540125e9.2
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Jan 2024 05:29:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705325379; x=1705930179;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:subject:mime-version:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oQro7HLcf72h4Wd8Zl/xcn3Bi2GJZnL4eMf36nHFiQQ=;
        b=oKJKimpR+rAcP96iCJ0c4/yUE4uJ+zIZiVu4HP8uCqXjTPZtvlvTrd8MRsHf9gKaWQ
         GdF+rdULaQrBKjszbISThME5thFNPtd9j7jgdYmkP0Nl0J+QJrzZpElHXHq0vwV+k7pK
         E39iTq7iCe7n8I5nwnckVHkniolzUg5HtI0OnE9qiD9JajnEC3vV09Wy67EiZCIMlhau
         pvuHqh5FYLqOWBpKPh7oFQojr0YHtANeiuH/FbYKVAGhdhmSf/E0l+4EtCR+EJuSLRw7
         y6FRGq5X8pXWClX3q3/Isou/+Exy9KV6TBM09N9bEur2Iay/Q4UxIEmR9ZRVfQ2lhRdZ
         wJrw==
X-Gm-Message-State: AOJu0YzaIWyGPZ4p19qZXj+pTVdq7qlks+/S1dOp8HZCEY8fxeYFespm
	F4bvabn6FzRtAC9I/EJgccOIDZtoCe9BNdCzA001TtMmA3aCf77PAuT9Wk5boNTtfHCIdGByaAw
	DYM1Su5Elh1eT2x6RvKo+ywQehdSiuS7HFDEccJHOeJyaKaA=
X-Received: by 2002:a05:600c:2312:b0:40e:4ac1:865e with SMTP id 18-20020a05600c231200b0040e4ac1865emr3320735wmo.52.1705325379159;
        Mon, 15 Jan 2024 05:29:39 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHJUhm7zn1lpSGmwHspUb9RZPBTtpl9oZj6TRNdYCuAIt4pH+vqJ2FTS0neeOHxdg7wo/bCcA==
X-Received: by 2002:a05:600c:2312:b0:40e:4ac1:865e with SMTP id 18-20020a05600c231200b0040e4ac1865emr3320727wmo.52.1705325378798;
        Mon, 15 Jan 2024 05:29:38 -0800 (PST)
Received: from smtpclient.apple (2-234-153-233.ip223.fastwebnet.it. [2.234.153.233])
        by smtp.gmail.com with ESMTPSA id q8-20020a7bce88000000b0040c11fbe581sm15658393wmj.27.2024.01.15.05.29.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Jan 2024 05:29:38 -0800 (PST)
From: Ale Crismani <ale.crismani@automattic.com>
X-Google-Original-From: Ale Crismani <ale.crismani@automattic.com>
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.700.6\))
Subject: Re: Performance regression in ip_set_swap on 6.7.0
X-Priority: 3
In-Reply-To: <D2070167-F299-455C-AE4B-5D047ABD5B28@automattic.com>
Date: Mon, 15 Jan 2024 14:29:27 +0100
Cc: Kadlecsik Jozsef <kadlec@blackhole.kfki.hu>,
 linux-kernel@vger.kernel.org,
 netfilter-devel@vger.kernel.org,
 Ayuso Pablo Neira <pablo@netfilter.org>,
 xiaolinkui@kylinos.cn
Content-Transfer-Encoding: quoted-printable
Message-Id: <7214C087-ED54-4D3B-A17C-DA811951BF67@automattic.com>
References: <b333bc85-83ea-8869-ccf7-374c9456d93c@blackhole.kfki.hu>
 <20240111145330.18474-1-00107082@163.com>
 <d5c24887-b2d4-bcc-f5a4-bd3d2670d16@blackhole.kfki.hu>
 <41662e12.d59.18d0673507e.Coremail.00107082@163.com>
 <D2070167-F299-455C-AE4B-5D047ABD5B28@automattic.com>
To: Wang David <00107082@163.com>
X-Mailer: Apple Mail (2.3731.700.6)



> Il giorno 14 gen 2024, alle ore 21:38, Ale Crismani =
<ale.crismani@automattic.com> ha scritto:
>=20
>=20
>=20
>> Il giorno 14 gen 2024, alle ore 06:30, David Wang <00107082@163.com> =
ha scritto:
>>=20
>>=20
>> At 2024-01-14 02:24:07, "Jozsef Kadlecsik" <kadlec@blackhole.kfki.hu> =
wrote:
>>> On Thu, 11 Jan 2024, David Wang wrote:
>>>=20
>>>> I tested the patch with code stressing swap->destroy->create->add =
10000=20
>>>> times, the performance regression still happens, and now it is=20
>>>> ip_set_destroy. (I pasted the test code at the end of this mail)
>>=20
>>>>=20
>>>> They all call wait_for_completion, which may sleep on something on=20=

>>>> purpose, I guess...
>>>=20
>>> That's OK because ip_set_destroy() calls rcu_barrier() which is =
needed to=20
>>> handle flush in list type of sets.
>>>=20
>>> However, rcu_barrier() with call_rcu() together makes multiple =
destroys=20
>>> one after another slow. But rcu_barrier() is needed for list type of =
sets=20
>>> only and that can be handled separately. So could you test the patch=20=

>>> below? According to my tests it is even a little bit faster than the=20=

>>> original code before synchronize_rcu() was added to swap.
>>=20
>> Confirmed~! This patch does fix the performance regression in my =
case.
>>=20
>> Hope it can fix ale.crismani@automattic.com's original issue.
>>=20
>>=20
>>=20
>> Thanks~
>> David
>=20
>=20
> Thanks for all the help on this, I'll try the patch tomorrow hopefully =
and will report back!
>=20
> best wishes,
> Ale


I applied the patch on 6.1.y on top of 875ee3a and I can confirm it =
fixes the performance issues in our case too.

Thanks once more for having looked at this!
Ale=
