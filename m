Received: from sonic309-27.consmr.mail.ne1.yahoo.com (sonic309-27.consmr.mail.ne1.yahoo.com [66.163.184.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD9AC1F462A
	for <netfilter-devel@vger.kernel.org>; Sat, 15 Mar 2025 18:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.163.184.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742063656; cv=none; b=TAV9E/DMIycohZosMSNkNAOcu7Y5cdDA/ZO2GNAy91Yi1Jo70exit3RatWTXKzsLprR2O5MRbNj+0eza8nwTRW7hl3fpofd5vpRFUueC3+3L7DBW73pwi6Sus0rYH5rZ62Q1nYRmVOQdqHBGNjMal75sZ0xx5sDIFY51KWdDgNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742063656; c=relaxed/simple;
	bh=4YycN95OJkamhCuKvuQErsHI/SBw9V/Fcva1DYpLOZ4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GsfVOjMNzPCDEzr7RHT/DNS4uorVM4JdYt0rZ38ed2YlccdpjBcBjjOGMJOXUBocc4q9ExUSbKQXPjzYB3bRSnuJY6Xpi3KoOxBmm7pXJcxeg93X9tfg+ACSvdQUmQu1mz2vDckFREyKHUId/VDsVKu2oV0ZjmRYuer1lfGZfX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com; spf=none smtp.mailfrom=schaufler-ca.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=TJ9rU9HO; arc=none smtp.client-ip=66.163.184.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="TJ9rU9HO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1742063648; bh=ycScJLAHyCubQSnNZRe/MVran4EmIZ66AunH3Rg7OEM=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=TJ9rU9HODEEr1B5+S3e3543mprI4vcXtWIrS1Fn6CRjAu3njIRmaHicK9sKXX6V/56ckvzwiC4VauE3rLnM/EtNDmZA0aXt6G8RmH6ug3Bl/6qR/PfADqkc2l5tPXBSw0dkH9ymESX/ceSJPq/93bH8qeP+Ppoq3/f6wdPb92ED8scigqiOVEBLk8zyT2zejSGw4qaR2iFLnmEvtSnTcnT5Jx3kGu0y0vBNOaVwYl1YCvhqJ4ORO1VsbHchJlQiR6io58f0WjMR+J/3H1Cmb/Y8S2U1bYv+U8Xow4F4ikGYo7ZK4C9kcr6NOFou84OKQOOozxs6JH1httOlKBWZ+sA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1742063648; bh=/LwL3AVbhgAZsYm4RUmbPPEHkRkyDi293XMpBDV4Iw9=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=I67UjaZXCwe9kplt1XnG2QUnVLj652Z023KIMod5YAarMcprkwcXYwmHlZOgmIhx0a8H3yR06WDwHDoHU/hiuo1uqx+aKuhRlTSASRFPzAM7B/rKoMb/P5oPcw2Z98oN5/hW1LO4URj9unwU5K4gUO8O2larw9VxeNxCnydlwdK9pzzTaibmSTjC8yncMnWdEaAecWrjn+Kiwv080IIYbdYSYbe+zqpTMZVMnu1hYzkn9T6iTUB6NZWn699Zl2lpDml8S4IwV17YHYGvWgEv4tnNjQEgmpCbMp8sRVFbt2fpBSZihTG1ukKP3Cj+eG5d889zvrsNCP6E9zc3OVYCBg==
X-YMail-OSG: Gq8EvboVM1kViBJomir3BQXJajZ9sZply8q729wVqw6z1bpuFK4_58BGC_KONGv
 NlBR03SB6RTdV1H1uVAnlyg7ppBCcSRC_Ztn0V0ojXbqEOT3jiVBW2LqHSLlqZfiTJzJBuy_bZUo
 bSYvi3FztXr1guou0sQqQkZhDSLIOVxjmFNsQcAP8N_J7.823ax7UFLMFes0FZUOAcQVxrHeio_4
 Io06OZWLiRauC7B.iZPIpKV1Wppw1sZ6400B95JOO.GyXaOb0c5G4Hq2IkMniNTqRnEtP7G5CMS7
 UaqWm4B0OpmxUVNDg6NHeGycAl6lxirFq8CfcYPnwz5idLYpt538g2MmIi0n1aBc5a3so4xwdM5M
 kFuQrz52KqDnwGJuzMz4nTpfpp.w3LwA7z7ZB0igEe6DuH8kicv2JCfob_Lc2OO1xG0WnT5FoevN
 vOXaozz4BjEn4tGDjbozFE.2EC.GovmIsvp6.SFhJe1JoZaC7AedyfdFFH46hvIql4Xiyv_4FbFZ
 n5.0c2uM9T5yfpFpvpCj3i19zhvzJsVVY9tTw8gy8d0qEPsW58Bh04dZZc_KZsBwZ7w6KV.zfh2x
 ePYskf3hFMVslEF6_YL31xWELUhrpmZHC3DMU8iqLuIdJcTNBgBJprRt8bHUh0GlJctp9JJGdK0x
 ZcWMWXrNJlbRqe_fY.ufk4ret3lfDDkRxYWNdJ4VsuiIbRn8pvTLDeafKT99P893Gui7cGGka3JN
 EmK4_6C_lzdKJh7cfnOgQboQFlXFXlMs3FiYYqQfOG.McxMx9UCkPs0X4DSdvHKzKBw0GRc9yW8U
 N6d8ERow1mficWCZ2tTXZ_fzgylkTKKDppO3CbMglWhKzK01sqIvqBIA2hFmpW6ydmh3jK655TGF
 e2SjpXSPoaMvZTpCGQ0DKimp8.7ZTIj00WDW12BVyHnWOM5ZzPQ.lrkPm9.MEelbvwn5arlrT88p
 X3rQhQOWzRG4BW2.CclwzEUUx.7RJNbuMSftCYJHKUjFC4jIx.vKMRK.x.VALbZW_A58pi5bAIlv
 Xo3XkYKmmovMnvAFlQdtd1TTKZhBPdLk0e3hanwpKfdQGuMZSxrbp4yOZqJmRFdHlBbq7.4.WlVW
 0KG4XZqtZIKYigU7G1OQgOpx75OIwYffa8Fqcg_noby4aBJs.Azur.rSduWacxB8xWk_WhrpY4Uz
 kWZCLn2r6MlnKInJW5SncsFN0D10C9L0IOEdsq4YnZOkhUktNUFCIDDYuD8synhZwc6G5gEDPev4
 BSdkyMaNVVIMtzV93Q9IavoXn2ny9rUXdw2ZCrfqteDNDzNOujCo_gZ2RF9PaEhtRnHm2sBu6crP
 4pO8YlwiI5JQ1vNqo1kQrWOBdjH5L6LPQjf84M7Tsik6vg9Cwquaz9TBZGtMyz00hN5XVoEmnA0B
 tXTk5zFXvoZu567t7Er5vnrt30NkW5ljbP6_wlVVsVz0DhWawNscExLIXyCZ4i_WimGIWV0Qv8RZ
 I8FozmWA4nHFZwkW90Awqy1tm7OJJkTUdtEZWtMMPNadREFB3DmnmzoaQA0idfHUSkfF0xDpX8rZ
 IoRpAFhqUomCsTNV8c6BTPy0qoatfAkXPlt4mCMehIp4YHjDrAG.4fBfKYk98w4c66KTlVCmGrbe
 evLmz_RPqhPyG_RW856uVc9Cs0qt5q1TJMDO0dnSseOUzjn8A6b9LGR7p6vs2FPclmpoa3yLY7vX
 FKlTXzaz7npknEit9JzGq72IuyPZx_Qv3t7ifGegYHvOWp7x17jo0qAjz7Rmu7LgWvd9VCyIoT0p
 PZTfWI_vIJPTVCYjfQO2wkb5l_2gyL06f2O0xJghBMDPyzE.XBr5.7ZR_lthjZzfwAlCdRN1UiIu
 9fFLoCQqht.PG.1.4chYbwIcsMd0diXX3BNc64vZm2Ks26Ak_bXF.DMbQDjMmhL92IeVgZ3uLbzI
 vxd85wUQJF0nHldHurSCuts2KPdxOPcA3S645hrJJ33NhTG82BtQ6J8j8xjuLJi6n1_LsfLiz2su
 MCUNtaXeKsdkwPqdEltmndUEjul2RcNYF.MCyIM1XqJJTosV0lS081K0qJhNQu7ypwt4Ao.aNNsK
 Mw6dZBZ4t7g9wm3lyBGxPuRYiNL3h..YIf0lG.zvY24FH8KtREiVtyPcPHzeTJjL.nK97omXq8uw
 z7QPLdHSyFqD6ywdRi1u0Jwz0wECf8o1hUCSVHm6WpowrCMqCpYb.q3.fzPyXJQyefPLEQwtnUEz
 YNRfB8dNJvRl36UaXrUEciQDauwOkKpvn5SV34V.nB6m0k6GEndCiLhYHN8Niriu0vaUHS8UKiIT
 9tVuqy3QF
X-Sonic-MF: <casey@schaufler-ca.com>
X-Sonic-ID: 4814970b-22ef-40e1-a254-33f9b8f2534c
Received: from sonic.gate.mail.ne1.yahoo.com by sonic309.consmr.mail.ne1.yahoo.com with HTTP; Sat, 15 Mar 2025 18:34:08 +0000
Received: by hermes--production-gq1-7d5f4447dd-ffpct (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 257f5b639ab999d25609c2475f769a3b;
          Sat, 15 Mar 2025 18:34:02 +0000 (UTC)
Message-ID: <4fd9d7c1-a66c-4281-9e7b-0c3f5fc748f4@schaufler-ca.com>
Date: Sat, 15 Mar 2025 11:34:01 -0700
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
 <d2019823-4500-499a-8368-76c50a582f47@schaufler-ca.com>
 <20250314203044.GA9537@breakpoint.cc>
Content-Language: en-US
From: Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <20250314203044.GA9537@breakpoint.cc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.23435 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo

On 3/14/2025 1:30 PM, Florian Westphal wrote:
> Casey Schaufler <casey@schaufler-ca.com> wrote:
>>>>> seclen needs to be > 0 or no secinfo is passed to userland,
>>>>> yet the secctx release function is called anyway.
>>>> That is correct. The security module is responsible for handling
>>>> the release of secctx correctly.
>>>>
>>>>> Should seclen be initialised to -1?  Or we need the change below too?
>>>> No. The security modules handle secctx their own way.
>>> Well, as-is security_release_secctx() can be called with garbage ctx;
>>> seclen is inited to 0, but ctx is not initialized unconditionally.
>> Which isn't an issue for any existing security module.
> The splat quoted in
> 35fcac7a7c25 ("audit: Initialize lsmctx to avoid memory allocation error")
>
> seems to disagree.  I see no difference to what nfnetlink_queue is
> doing.

Point. I see no harm in initializing the lsmctx = { } or seclen = 0;

