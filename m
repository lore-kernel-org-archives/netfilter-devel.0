Received: from sonic308-15.consmr.mail.ne1.yahoo.com (sonic308-15.consmr.mail.ne1.yahoo.com [66.163.187.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01EF778F2E
	for <netfilter-devel@vger.kernel.org>; Fri, 14 Mar 2025 17:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.163.187.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741973202; cv=none; b=OJ15i/U9UvUyRSagl8EI80FYKNtQOgUNCplSQRKJFWwZU7IlV2r7Lk8xyeWYuYL5YYOkOjWVYZnttWK1jq6Qn2B82EXT4+MEXIXEImGJCmjIKznutlH8GYqRAjvGkJi1C7EK224IFV3N+OqIUqIFWsLljiQjRYHO6Fz5Os2ca3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741973202; c=relaxed/simple;
	bh=qlcHt9ccEX6EUZm5kQqQFq5nis8rKlirP81I0xyK2pY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NtKAwNAijNkSMgCaAYDPOsIzbAlSe2XbrdC1XHpMWOc0XHb6Pza0ewlUGFR6bHkmEu4gXN0iYCbQeCZkJ4SRuoruF1HQSvH4HVs4FeXse9KTZjyfn5DqkpdRaBYNthyo07zT9K0XoXcdYZvzvakIAspixyrVMTsBDvBGSAp5qMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com; spf=none smtp.mailfrom=schaufler-ca.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=s7n+eUb7; arc=none smtp.client-ip=66.163.187.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="s7n+eUb7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1741973200; bh=CxM5t3Z2CzIRZvhTF8IpgcECByr9NPqDa7yqoSHEXII=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=s7n+eUb75LMn9V74l8EMn+I7rt6KZCaDozwiCPuUWtCSKt22SUEaxkXNNXTqbKHnDe82G+GQbJ7BbNcMFycrrtPyl3UFZpofKjO8Epxu1FpQiHSTcKEI+yrQJQC2R5F7ptYqn4ad300cpr+nr0AtQlU0TApCeNQBpZXn9ZaV1ug/5jwdk3X5baZlOiCaH2dHDHoSRo0c5jSr2YaLEJTDvuIlM0ezk2oBkW+w39u9qaWp2lOxObxDSZ52zB7WCljd4lBVdcYkqv7aDGON15Wa4FyrAPhCUAlyEJuB/Hpjz2KjiFtPjTKufeZHaqY1C+9sP7KCW2kySuq6QR4Oo5jqOw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1741973200; bh=LqJ/4V3CaRHZfvwAfFYUH/SXzMHaj5FGSwBN/98tvQs=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=qpVsLPEbBLCjTKOCDFnC9DA5EYun9ViH/SKy5By0MinySM/hXwSSs0zeh7fMTbv0eN01nHXEiJ+sQk+twZLswHKa+bO+0/OWuzjsND6xc/mp2rTd17W68C5529fC6VNBVedgIUqw73bN7mTiYm8GEPbQ8DAO+18LXzfNeoAiEixAc2CqD6tw3wF5IHGv+tl8VwBAIUNHI3UxFoRnoq11N/+tZkddto/BCyfm4vu/Pr4zD4LrEDiuaRVHD+9Czone0GZMJ+FgJr1d5Yt1jTTpg0uHexQuyGkolGE5NO/dc3jeBu+k3mynW/VYoVWv36cBujv9gxTHITmn6beSadoS6Q==
X-YMail-OSG: yj8zhOgVM1kOvmoxK2O2_D6uuYJfUJjzOWUsf_NpX_QiwVCutd7FQLCL6UBIsZn
 qs4BicKzukOYo67.TKQzJ8cZAoIbkMNe_ONE2XPuMlPTSaDUW2h1SktOdqrMe3yIrSvgDZPTuLHT
 KAANvDk6jatWEyKwP7bEXA.ePCvivvgnh5U8RL_Ktz63pXJ6ugvGHwI3qzES5kn4QVHiDh3x1X8E
 G_g9bm4nBYa8yq0nU9PA91x_soG2LbLI8ZUDjXAu.zz27ybc13FLk9u5teJG01_pb0y8IKHviye9
 MAkiZH2._PkaOZpgk0HGROvjh2kzLOir84956GYllxiCF2Gj7Ph.7kXy9ax8gLx.t09YEnhAO8nn
 XTCTBVLGmJr1zZUkUOU.dROkwDe_Wuidos2wm1cRL6wmQ3jjwK4egyASdhxgwoyYR8NdbLY1zmM7
 ulqII3VsbX8zLx929p0dNpM8xxGEQmEeSlDtW5QMErs0fmAOnicruFDzGCLoxgB20xaezvM.AREG
 F3Bm5Kfu_b0J9Vdmj8QuAMxdm7XLbL_p8h3W3BifK44km9aAVGAZr5ebxDIuLVW_0OLy.iUNKELE
 kdSAIUmgaSNVgU4sRGMMpewvPXNxlrP_YWLAd4i0KZyqea7KEX9Je5LT_HTKSlaGR_gdOwGZBQiJ
 3XEDiSFyjcNcT_mc8PdwUaSui78fufvVR8C97N.iU5ojeariTFmx1a4kFpfklmj3GgkxTpvRnIJy
 Ms.RSei0ldkOq2O8dkv5u.OKaq3iBFrdHOr.jgSMKW6LBVC49WzbKroYoR2BM4CnlL646bw94cC7
 0zoEVGt0UPQSQ_1NkmuEVvfIo0y2ob9WK9yxyE4n2NlqKh_Uwe8QFaeUXzBbWgp9.yY3bQ1Z8YAy
 Ae8Jac4c7NcIW9xP0yMylTwJ8y780z5MltXZOvnf6v6_9MH5iMsFmsYIyyMgIafdBfXkD8_LNRTw
 8vqrs5GbzMChxLGZsNBmnoKy27KMudYKrKerzDfTv6BI42F77YF3p6P49ngdBYPpWt7PambK55eA
 vSizhH8kvNFL8FCad94xD.jDRxHDYGz.YR0Q_S5KuND49COYfds0UbmmHvIURoRjBkp6H__X9KDZ
 9h1KQ_GqsHtnSJ.8oI2UTAYjWTs5.QFuqK5a_2GbdSSVZMYYLLbcxZioeeWQoRaTZvX7CIt_2rty
 MnwaIFVy.Hf231fcQlyTRr.E206AOLYYOAWCqx4lmmTnl85_jtSZC.JwmzRcAHe2X9xwt0Io6gxx
 7VPzrk98HxjhlVseorFa7wOt6b77p9T2b.K9a7J3L.SqyFKJehVHwJUOmfAZB8cI4yvh2KE2L_BN
 XtyN8BC_H8a2JJQsK_68as.iJDHj22HdA6XetfdeiTVokWqiomAJs8tJtnyxtUuI94UFKP3EZ9hu
 Vtf3C2AeQ0JvI87VHmG4nyJFPY8J0nSnvHgZjwjHg4YFbHCP68ZOMEotbtkB2WdUxFDp387Mi_y8
 .m.a8hbIJq4KYW0KwBUVHraTAahC1OB_13myev0mUnsCuFgcOxGcOyzkO0fvO5awmWvpaXaYaslq
 y8O12h4mIxO_gFbXFMpwKr7ESGCX6.AEBXjWTymB6NRCHHy8emdfrVXbCdys1CgUTplw2G4IT2GL
 vdNEADhLCUWHMrn4Tou0ru6Elsn5Vaygqi5n0G3xObSlSOXGD2G4EcnvB47dUEdhuYPp2uSIPgAb
 k.svFJmbIfaVE1_Y1W67vOPtLPemCK0mpPof583DsUVO2eBUNmGwV5d0oO.aPpBszm0BB6_lfJrB
 ALAyjugKqsSM.6uBSYgb4Xu2LPXwQULGLm_mFo.yypPKePUkZ48Jp480ch7XUKe9js5xVvSzYqAn
 m.MDdlDzqaLRTL_137VwMs8Ad8Y6SAVSatW2MZ_c8bYm9ScU3U36LiMnd_Mqi_0FJ2dIMzEx4cEj
 xTOmLNzhaoXMj5nx9MkwXbaxd6O0rYUAb582tr2rl053ChHkugTagiunmjOp3Zw8OwaGPz4ZlPho
 8Xi9TfWp81EJPCXyUTDzPow0B5Q05.0XmM6B4QSJX4NIfy8PPB7HY15PIPp8I9Jz0hVnEvbCdotY
 odvd6GuQ42mqHJwmnPFw_A0JSeXacwgqRPT6Lqy0mI8pEBV8rDquoMZ00eFMK7YxTQC1RC6CEv2b
 BJt7nxCrntiYkfvT5UKfvTTUN7bCSix_OrLppDanevoFGbLrYl3k2ZUZsArLTDX0s6Fr69jsyYLL
 H.hZSetk5xpPO_2WDe9rzopk6RwyzCMtrViKdrW5PTfkcRCwPJey7TX5lpn8DaHcCd9Liovr5hvb
 0qdO6zGjp8fY-
X-Sonic-MF: <casey@schaufler-ca.com>
X-Sonic-ID: d560284d-a513-437e-bc8d-88cbba6cec32
Received: from sonic.gate.mail.ne1.yahoo.com by sonic308.consmr.mail.ne1.yahoo.com with HTTP; Fri, 14 Mar 2025 17:26:40 +0000
Received: by hermes--production-gq1-7d5f4447dd-ffpct (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 85f935b17729ab72ea53b7b1fade8a98;
          Fri, 14 Mar 2025 17:26:36 +0000 (UTC)
Message-ID: <d2019823-4500-499a-8368-76c50a582f47@schaufler-ca.com>
Date: Fri, 14 Mar 2025 10:26:34 -0700
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] net: Initialize ctx to avoid memory allocation error
To: Florian Westphal <fw@strlen.de>
Cc: Chenyuan Yang <chenyuan0y@gmail.com>, netfilter-devel@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 Casey Schaufler <casey@schaufler-ca.com>
References: <20250313195441.515267-1-chenyuan0y@gmail.com>
 <20250313201007.GA26103@breakpoint.cc>
 <42e5bb33-1826-43df-940d-ec80774fc65b@schaufler-ca.com>
 <20250314164708.GA1542@breakpoint.cc>
Content-Language: en-US
From: Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <20250314164708.GA1542@breakpoint.cc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.23435 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo


On 3/14/2025 9:47 AM, Florian Westphal wrote:
> Casey Schaufler <casey@schaufler-ca.com> wrote:
>> If seclen is 0 it implies that there is no security context and that
>> the secctx is NULL. How that is handled in the release function is up
>> to the LSM. SELinux allocates secctx data, while Smack points to an
>> entry in a persistent table.
>>
>>> seclen needs to be > 0 or no secinfo is passed to userland,
>>> yet the secctx release function is called anyway.
>> That is correct. The security module is responsible for handling
>> the release of secctx correctly.
>>
>>> Should seclen be initialised to -1?  Or we need the change below too?
>> No. The security modules handle secctx their own way.
> Well, as-is security_release_secctx() can be called with garbage ctx;
> seclen is inited to 0, but ctx is not initialized unconditionally.

Which isn't an issue for any existing security module.

