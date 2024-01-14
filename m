Received: from mx1.dfw.automattic.com (mx1.dfw.automattic.com [192.0.84.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46D9410796
	for <netfilter-devel@vger.kernel.org>; Sun, 14 Jan 2024 20:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=automattic.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=automattic.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=automattic.com header.i=@automattic.com header.b="d4fUS4dk";
	dkim=pass (2048-bit key) header.d=automattic.com header.i=@automattic.com header.b="iRFH/Vq4";
	dkim=pass (2048-bit key) header.d=automattic.com header.i=@automattic.com header.b="Bm3XxcLK";
	dkim=neutral (0-bit key) header.d=automattic.com header.i=@automattic.com header.b="lsCbvzNq"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mx1.dfw.automattic.com (Postfix) with ESMTP id 742221DBF3A
	for <netfilter-devel@vger.kernel.org>; Sun, 14 Jan 2024 20:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=automattic.com;
	 h=x-mailer:references:message-id:content-transfer-encoding:date
	:date:in-reply-to:subject:subject:mime-version:content-type
	:content-type:from:from:received:received:received:received
	:received:received; s=automattic1; t=1705264699; bh=JK7HNffr/C9T
	rH1PWI9+u9zScMQVF+0GyVoL3PqcCQM=; b=d4fUS4dkwYVDEf9mR/zYfBvnelQ8
	/pI8sWmubSp1Y4lLpsI2DltSTYBWehZ0hkwUi9HLxajyohM8NArBj5iXPL9VDoSg
	Yal0+jnayQplyHYdxVKrhkrTE8UB2kCII+9fdn7nRjBBW0jSElN+3mLPYT73p+/q
	3pkYR6+YsPIJ7N2E7wyo0+93y/Aj65Q3eJnIJks6yDcGua4rlbDgT4IVXCMlf6g0
	ZbEvKNn98yXqLgjGyKVXOKuoowwZSOJs90QfCMtY/ItTMx55sF3jyWfZHkvxUYIy
	OyFu9c03+21iM5Zc03V9MuZlDIWsYMBmkptSmKWc3pae6ROMQU5qfKWthw==
X-Virus-Scanned: Debian amavisd-new at wordpress.com
Received: from mx1.dfw.automattic.com ([127.0.0.1])
	by localhost (mx1.dfw.automattic.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VfLqrLzMGsIQ for <netfilter-devel@vger.kernel.org>;
	Sun, 14 Jan 2024 20:38:19 +0000 (UTC)
Received: from smtp-gw2.dfw.automattic.com (smtp-gw2.dfw.automattic.com [192.0.95.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx1.dfw.automattic.com (Postfix) with ESMTPS id 125201DBEDC
	for <netfilter-devel@vger.kernel.org>; Sun, 14 Jan 2024 20:38:19 +0000 (UTC)
Authentication-Results: mail.automattic.com;
	dkim=pass (2048-bit key; unprotected) header.d=automattic.com header.i=@automattic.com header.b="iRFH/Vq4";
	dkim=pass (2048-bit key; unprotected) header.d=automattic.com header.i=@automattic.com header.b="Bm3XxcLK";
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=automattic.com header.i=@automattic.com header.b="lsCbvzNq";
	dkim-atps=neutral
Received: from smtp-gw2.dfw.automattic.com (localhost.localdomain [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-gw2.dfw.automattic.com (Postfix) with ESMTPS id 0261EA0A07
	for <netfilter-devel@vger.kernel.org>; Sun, 14 Jan 2024 20:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=automattic.com;
	s=automattic2; t=1705264699;
	bh=JK7HNffr/C9TrH1PWI9+u9zScMQVF+0GyVoL3PqcCQM=;
	h=From:Subject:In-Reply-To:Date:Cc:References:To:From;
	b=iRFH/Vq4YGIiy/g7ubDCEISR3gtog7KL6qcDiqvo9F9/5cFvsjSS6rHSrDddfnGg0
	 E8ZsCcmjCtW18OvJAWs5qJalgxen6zp7ILLRzgtO7MqRaMEzC2nGVKMvfcLCO0Yaz3
	 YfcGDVX3ImSk2iX2DY19Ya7tBzp9sdYKvw2y+/JKxDYOA98ctwSH40/nOIFOytmAw8
	 G2/CPSrX9OWvSYHVjxQkxg36QukRxgKPGgliXZ2jJmwKGrSWSFGbhVqbIgJ8SLXyCS
	 c+UbFIEy3P+aQwHt5V+MvFTW59ZUxk7PrpCIaOJlaW5crqdKka4na6WbIOeUuqbFMX
	 8VLfe5i/WdE0g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=automattic.com;
	s=automattic1; t=1705264699;
	bh=JK7HNffr/C9TrH1PWI9+u9zScMQVF+0GyVoL3PqcCQM=;
	h=From:Subject:In-Reply-To:Date:Cc:References:To:From;
	b=Bm3XxcLKpRKqCb7P6nkA9Z524OnHluaoyJAYo+0Ovih8hlwrNKd2RvwTAWynUuwa+
	 Jmg65be42zKximoS48z5f421RFtGiGpYfe69EzIiGpuQUVv3Ctpj7TtqpgLpHtu3As
	 242lpLzFH8UBjjopEon23j5J0ocNJ5u5zckvyud3e13Mi+5NKznEJwRQaKuAm4a+gf
	 Y+NTbEVLLKRp80Y/vctZYyrQm12v8LUcyQIOeWgKMiSidqkbD7NAtgHI14LMkKIn7F
	 1Ww/VEwWrFE92qtJg+GnZKsZsLksTXq0J5RZCUFjYaXlc/h25D/7RcdnUnDYwENs2/
	 XPHeYNcs/NokA==
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-gw2.dfw.automattic.com (Postfix) with ESMTPS id E7F1DA0394
	for <netfilter-devel@vger.kernel.org>; Sun, 14 Jan 2024 20:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=automattic.com;
	s=automattic2; t=1705264698;
	bh=JK7HNffr/C9TrH1PWI9+u9zScMQVF+0GyVoL3PqcCQM=;
	h=From:Subject:In-Reply-To:Date:Cc:References:To:From;
	b=lsCbvzNqO64yKljNAOkvjrBNvWz5jD7CilTQhedoP7i1ns+fhKCMzAdkb2uE0XAWf
	 HVWz+1pvC7nRCA9UXoHdQMIcqhqVkUD1m/FZn0JtgrAYNw/EM8fT9PsVipAJHofkQN
	 VI+Af0m78URMzlt+SK9I40oaOYRXLUChzUP0sPbh5tBEHqXF2YnbRqZVcB85r1GZOr
	 9MxdEN1LybZNhcR0bwrkXHEDUFfinOCUi9MrDbEBRpKrqcrdvZ17AEPESjZKpZzN7e
	 RfaJzeULstTjWaoST+KqsmyTeosxctkGfIY+TLzV640UCK3OyanzuDNCmQ6YqhJVa0
	 6zir0W5WIDsng==
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-33768a5f55cso5614771f8f.1
        for <netfilter-devel@vger.kernel.org>; Sun, 14 Jan 2024 12:38:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705264697; x=1705869497;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:subject:mime-version:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JK7HNffr/C9TrH1PWI9+u9zScMQVF+0GyVoL3PqcCQM=;
        b=jEsFobGUgrrEJKguZpGBTJWGB1bcCvPmVaL6ApXeMVTXWz7ZstyRzf26NJtBAzvW2T
         b2COt7nnrQhwXwXipypn195aHWMHji01ChD7Iy8cmAZWDUps8N8w/E3aCB+LaimZMlph
         0aE2OF711AA/g3SxO74sKTRat0Fw3funga2+in0x9CQzD1gNvlemvB8cOI29S6az/bl2
         ryVuhduV210dP++9BCqTx3ofN5ovLoXOsr7N0ozQ4Ik5Xh3NfN3XrEu0z3A24Qk/EoR6
         JKhx+2edboPdfVNV95WMV2x6THnSfu9FeBvzzJE24cXioQ+dn/EcY2urmi1rj64xVY+8
         kSvg==
X-Gm-Message-State: AOJu0YyW1SR42YgB6Zo4nhU8vxdu7kaVe9pGxy1Gl0bjK2sRKXIyBon1
	GGHzd05a+0K//OD00/cnTpv+X7Ka/or4y/Oh/IBDelAv/itNxnxSIzyUOj5US/278LMr7qePSd4
	fbFV5qoSVlO/H1TV6Jty/8NuHA3P9gxaslBth
X-Received: by 2002:a5d:6743:0:b0:337:989c:15c with SMTP id l3-20020a5d6743000000b00337989c015cmr2462784wrw.90.1705264697778;
        Sun, 14 Jan 2024 12:38:17 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHI49B2lNvsFdpJLZUO65pJcLhGGni6QMQBRlh0oMxGwKa8sj9CemFXPIqh/9AI0Gb1S285jg==
X-Received: by 2002:a5d:6743:0:b0:337:989c:15c with SMTP id l3-20020a5d6743000000b00337989c015cmr2462782wrw.90.1705264697493;
        Sun, 14 Jan 2024 12:38:17 -0800 (PST)
Received: from smtpclient.apple (2-234-153-233.ip223.fastwebnet.it. [2.234.153.233])
        by smtp.gmail.com with ESMTPSA id z11-20020a5d44cb000000b00336898daceasm9906403wrr.96.2024.01.14.12.38.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 14 Jan 2024 12:38:17 -0800 (PST)
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
In-Reply-To: <41662e12.d59.18d0673507e.Coremail.00107082@163.com>
Date: Sun, 14 Jan 2024 21:38:05 +0100
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
 linux-kernel@vger.kernel.org,
 netfilter-devel@vger.kernel.org,
 Pablo Neira Ayuso <pablo@netfilter.org>,
 xiaolinkui@kylinos.cn
Content-Transfer-Encoding: quoted-printable
Message-Id: <D2070167-F299-455C-AE4B-5D047ABD5B28@automattic.com>
References: <b333bc85-83ea-8869-ccf7-374c9456d93c@blackhole.kfki.hu>
 <20240111145330.18474-1-00107082@163.com>
 <d5c24887-b2d4-bcc-f5a4-bd3d2670d16@blackhole.kfki.hu>
 <41662e12.d59.18d0673507e.Coremail.00107082@163.com>
To: David Wang <00107082@163.com>
X-Mailer: Apple Mail (2.3731.700.6)



> Il giorno 14 gen 2024, alle ore 06:30, David Wang <00107082@163.com> =
ha scritto:
>=20
>=20
> At 2024-01-14 02:24:07, "Jozsef Kadlecsik" <kadlec@blackhole.kfki.hu> =
wrote:
>> On Thu, 11 Jan 2024, David Wang wrote:
>>=20
>>> I tested the patch with code stressing swap->destroy->create->add =
10000=20
>>> times, the performance regression still happens, and now it is=20
>>> ip_set_destroy. (I pasted the test code at the end of this mail)
>=20
>>>=20
>>> They all call wait_for_completion, which may sleep on something on=20=

>>> purpose, I guess...
>>=20
>> That's OK because ip_set_destroy() calls rcu_barrier() which is =
needed to=20
>> handle flush in list type of sets.
>>=20
>> However, rcu_barrier() with call_rcu() together makes multiple =
destroys=20
>> one after another slow. But rcu_barrier() is needed for list type of =
sets=20
>> only and that can be handled separately. So could you test the patch=20=

>> below? According to my tests it is even a little bit faster than the=20=

>> original code before synchronize_rcu() was added to swap.
>=20
> Confirmed~! This patch does fix the performance regression in my case.
>=20
> Hope it can fix ale.crismani@automattic.com's original issue.
>=20
>=20
>=20
> Thanks~
> David


Thanks for all the help on this, I'll try the patch tomorrow hopefully =
and will report back!

best wishes,
Ale=
