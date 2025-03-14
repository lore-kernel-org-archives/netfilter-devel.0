Received: from sonic308-15.consmr.mail.ne1.yahoo.com (sonic308-15.consmr.mail.ne1.yahoo.com [66.163.187.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2B3C156C79
	for <netfilter-devel@vger.kernel.org>; Fri, 14 Mar 2025 16:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.163.187.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741970499; cv=none; b=RmKAWMV4q6BlSBpC079Zd9P+sQLYaPaIAhSq3Qpbu6x0tIK9U+xrL4/IoNQ7O2p72Rdwgu4YnqM4KTJ6qBv3v+9g45Bw5jTa806wsyshmLOpIJepJfA9aYkRyiMxo8Wm6+++usfTdDkIxKpuFpPJGn+/EMoZiMBNHTDkGtj1bbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741970499; c=relaxed/simple;
	bh=O82n78ss5+Ih+r33ZKwLEO2agcUD4VZ0XGXk5KLTdfM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TxAC4xpTvu9EeEcS6HCOVCKdjk//QpTBYDam8lQcrKwwbw03rZ3BTIoiUc/Uqw+klN6F0FLF7J77S/Rq4idCh4DzLLGl0nzeR2PlkBKanb9IToLlHsb+91IQ9xOGrDhPJdstLj0dCeqBzlPAG+4GKZkFc1BpbYCGQUg0yuUGYac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com; spf=none smtp.mailfrom=schaufler-ca.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=LNso99M4; arc=none smtp.client-ip=66.163.187.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="LNso99M4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1741970490; bh=LSPWeeDc4kfnTy6XAQkhnXeL0TiR4naRLFabBLo1bMs=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=LNso99M4BYH1kVbCXtvSjy5XJIwAFVQ/tOmiZhx5zPKt0+f6KcGXN2Cun8EPk4/CSNawsj3/da69jGs2owL8o5u1W29X6m/5Km+hgAL+GnqBxaWYpZQaoMymufF52JJ2feSQYASWHqXle6k/heamH8KB40UXrbCDFpws/0GWATPXgoDwxSbBCDJfuc8Dhv9IvLMdea0dSC1NP8skohfKzZ8GS+3zazFvJRvZv274K49Uzj3QlT5x1EKlBgrczGmE7m8YbJKW+YlMP3eo2nHCFpaXXMFsfdOx0KbB/mr14VagTNB/Myelt9lyB4s53SLsiVfEES7+KOsefXcZ6L7yrQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1741970490; bh=6jjAwDm2pxXtJK8wOstbrf3Oxp5hYC01T9bBVHhzKM7=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=M+vtayvJBDLYYN2Z/ub+Afh22JFWT8VarfPE9GaQ9//eKxa31XVEDhgDvOiSt2/AiJRG4yg45X0Lo+m28zv4Z+XFe1WI4r4Dr3hjJqz7Dr2Caox8iEbisnzTMAMRrgfXsPGPWw1eNEQ8jR39l2A1WqsuORU4GAvktLoVIVoqg1RJGX04CdleYawapmYVkVNI3I8vVAYbPVLpBM8pnSg/eOqfaxqH239knjYIgyMIufl8YeTnrVBRdhiU1j8pIQ/vb81AwN2rJK7QlcUz11re5e1cFgGoe2dgPKMDBLdxLWpPTd+ypB9/njGVw8WaaPWMAcrJkz9878VZkCWQRUF2jw==
X-YMail-OSG: YOJJeNAVM1nD2IKlVSMjlgST4etRQIf0.CmdGrSFZNQCmezWvojqo0m5PJLr4Zs
 IP0SAiA.xSSjs8eUYg1dqqwVb.WAJ6w2Rjetu15aL6eM71maI7mFtMRJEM2yyYOZJwqVHo7P8b20
 jIpRkkcOtYjTQpL79bPk5mX6L7Xp4s9B5IGIdB83n2N5BEoUH8b7FSHvfFBlf7yhTuW7rdEvpI6H
 F4L110vX6vzAojYCSA50OmSlIDPkJrbAwnBtHDsLEAZlx13QlgFVS1Yaf6qz60LvTUtSrG3KqyF3
 m41DtMbjiMFvUcibFHFaHByUzWDBWg5lqO7pYjMW34AopOigaqyaJFje6PdvXiq6OhuzOiCfMbLE
 Ioqjt2wfkpzznAJVK8Sn8fF5m5KkBfT3qTGClIMbQ7Q6jNUbO1a8mTpPFn_batbgFlX7vGPC_IBK
 rTTntHM8yAVJVz64E5SsJ5VRw7fyH_jhjaFcta_4p9KzULSqPXWQDNJby9RooRt3W0w2sfHunyC5
 o1wayG0pxT7FXXYaiUH0byCYr5ZWnpWhooAsfJnIIqApPkbdyXPoloOSOi0QopMJLO9U2ybbva_7
 rVm5FDorQzn32DpN1X1XC0Hj_2b2XpX21CK7rlQ17sL2zu5BeSqj2kDgHmbP9w6wYFP9kBad_x3a
 Nolh5Xq1BXBgLUQ60X07kO.Dfci_FMZVhp7u7G1CEffc_L5FkTPmhOSICeUHDOBwYQCUU7itN_QU
 PXUn3caV3sPl6uguVANFkHkj4iVBMAJLzEALzGebML1rcEroeXjF7txslCk6D_ftyQlvEc7sKMqM
 m0RwbX0Wca1V8WoZQS0FmLpicZmRkrV.nRZJa7orBGpENQF24S.ppiunW8u00TP_I2BSERzOg_H.
 exdknPjAGSWUtbhXhgLbhu5JTSLeuHLJ9abiKctv0yZNRn0Aypynan0wjn_Rz7.rybHYFYFJPEwI
 LiJ_apxgDSqPVk_zEKlJ0lzeNmuwelg0heJ_5o1lNVxPWRaI6sSMQ_kRtdZeMraz.rEWrPhG9D8L
 aSUQgPb3V0WI5dqmNbD.z8VN1Y66bzgKlRBHbNGf3Z4Ad3WaMhtMd2qBiry9ae5dXKYiF7UXnD7u
 w7svDtEfOXmpu2LgZx0EAdGbGcc8NsM361e8LlQQQDlJu9zE.xxxy5SMqCMnzwHeGIDlOABnqy09
 javx98fTTyF5K81iJSiyEuGos9A6gstr9F0yhv6R1Jr83xL7NBYYTSxHULK4kt6h0clT2XwbIdLv
 e64Rhd9Ovs7FZIVYxLI3xI6oNCv0yn3_1B2qwXir8ssLa6WKUI9MCSx2SOuQ47unytNz6jEacgO.
 87ofhYx4wdhzfUvUXGKmsTRh_cbZTH7PaQ84pBQXGntspanC0278Sc7v1ERvz.s0aLJr44HiIrRn
 Lq.Pb5FfTu6vefHd2NgXJaF9ePh5Og9tSevAzAjHVlM.i3LBvJWQpptxLf2B9txIu3Yhz_tUTLnb
 L0xCRtTFK6uWhRwoHtxr0u3RVoTZlWwaAz4oEKbwrb17dNWhTukEgVeOOw1EiOhX_hO5fqNK7kYI
 a6uWOYPZ.hcBRd_ZCHpEUVjzQNVFz.8aRMOmZJdqCO5C2wUGfC_8nf1h5dUEmeVLmLcRtKuSuYBd
 4LFX2BAg0l5QOdjpZ2e3TECOzY1dlJz6We7ZchXorDX0g9vdERwea.Rw2WDVKh_9wfx6IiHE7HHf
 dJT_foepbv08LUzJ0BgFRlpcRo._OAzQEHSmEB8R5WG_X7qlzzOS2euvsOQwn3Za0N6PlzL5Mami
 6s2GVZzEQgZ6hhum0.kM1JestrnsoXCxH6lFWlxOBgoAZeT1ysmGy.FyFLHcyn9tnAdqfByUtBYY
 z92LO.MOmCSX0_yGCUUIZTts1GbCUMuErn1cNqB63tBhkjFFvxoXCgXwaNzvMuVivM71Kpegh3pp
 9lxGxt34zzLbb4TIMJJm4PXeol5oKa3vWN47D8TTNx9jWdpfu2ChtwBvyR7xnMUNs.Ptup0FoLks
 stsTtDMxbl042_GVZTaRBXTdDWxqZTk_H_fGPwOC5POXFRP19wv4r3YVerHxPF4m4ZF3wfhBniuX
 kkiQEcd64yN_yj1aJpQc1e02GaM6lv2cXYhGCP7F28lSDAt2J0V_SzMKRrEaClATYUNwP3ILRpEd
 FLyjK6XM5osASD9uK1C0rpq1lknhgxgvE5eO0.61eLp5oYYXSDQOIJfO8Vs2IkHZaSjulCp1_lZX
 CtZa.0vLTZvXjOKsVuIAF4n2W3I4pHevyln3pItBvEphyw78JXGjFHgoNQv4htgsvJwsnt9lCp7e
 3BUSAL1DU_cfwcjjTxuMc
X-Sonic-MF: <casey@schaufler-ca.com>
X-Sonic-ID: 853f45af-6bfd-42c6-8a39-b9fab4ed7dfe
Received: from sonic.gate.mail.ne1.yahoo.com by sonic308.consmr.mail.ne1.yahoo.com with HTTP; Fri, 14 Mar 2025 16:41:30 +0000
Received: by hermes--production-gq1-7d5f4447dd-9qjv2 (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 6c9efc90c0421e9334029701ef688062;
          Fri, 14 Mar 2025 16:41:27 +0000 (UTC)
Message-ID: <42e5bb33-1826-43df-940d-ec80774fc65b@schaufler-ca.com>
Date: Fri, 14 Mar 2025 09:41:24 -0700
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] net: Initialize ctx to avoid memory allocation error
To: Florian Westphal <fw@strlen.de>, Chenyuan Yang <chenyuan0y@gmail.com>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, Casey Schaufler <casey@schaufler-ca.com>
References: <20250313195441.515267-1-chenyuan0y@gmail.com>
 <20250313201007.GA26103@breakpoint.cc>
Content-Language: en-US
From: Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <20250313201007.GA26103@breakpoint.cc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.23435 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo

On 3/13/2025 1:10 PM, Florian Westphal wrote:
> [ trim CCs, CC Casey ]
>
> Chenyuan Yang <chenyuan0y@gmail.com> wrote:
>> It is possible that ctx in nfqnl_build_packet_message() could be used
>> before it is properly initialize, which is only initialized
>> by nfqnl_get_sk_secctx().
>>
>> This patch corrects this problem by initializing the lsmctx to a safe
>> value when it is declared.
>>
>> This is similar to the commit 35fcac7a7c25
>> ("audit: Initialize lsmctx to avoid memory allocation error").
> Fixes: 2d470c778120 ("lsm: replace context+len with lsm_context")
>
>> Signed-off-by: Chenyuan Yang <chenyuan0y@gmail.com>
>> ---
>>  net/netfilter/nfnetlink_queue.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
>> index 5c913987901a..8b7b39d8a109 100644
>> --- a/net/netfilter/nfnetlink_queue.c
>> +++ b/net/netfilter/nfnetlink_queue.c
>> @@ -567,7 +567,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
>>  	enum ip_conntrack_info ctinfo = 0;
>>  	const struct nfnl_ct_hook *nfnl_ct;
>>  	bool csum_verify;
>> -	struct lsm_context ctx;
>> +	struct lsm_context ctx = { NULL, 0, 0 };
>>  	int seclen = 0;
>>  	ktime_t tstamp;
> Someone that understands LSM should clarify what seclen == 0 means.

If seclen is 0 it implies that there is no security context and that
the secctx is NULL. How that is handled in the release function is up
to the LSM. SELinux allocates secctx data, while Smack points to an
entry in a persistent table.

> seclen needs to be > 0 or no secinfo is passed to userland,
> yet the secctx release function is called anyway.

That is correct. The security module is responsible for handling
the release of secctx correctly.

> Should seclen be initialised to -1?  Or we need the change below too?

No. The security modules handle secctx their own way.

>
> diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
> --- a/net/netfilter/nfnetlink_queue.c
> +++ b/net/netfilter/nfnetlink_queue.c
> @@ -812,7 +812,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
>         }
>
>         nlh->nlmsg_len = skb->len;
> -       if (seclen >= 0)
> +       if (seclen > 0)
>                 security_release_secctx(&ctx);
>         return skb;
>
> @@ -821,7 +821,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
>         kfree_skb(skb);
>         net_err_ratelimited("nf_queue: error creating packet message\n");
>  nlmsg_failure:
> -       if (seclen >= 0)
> +       if (seclen > 0)
>                 security_release_secctx(&ctx);
>         return NULL;
>  }
