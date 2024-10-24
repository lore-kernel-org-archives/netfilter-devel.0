Received: from sonic307-8.consmr.mail.bf2.yahoo.com (sonic307-8.consmr.mail.bf2.yahoo.com [74.6.134.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F6B1EC01B
	for <netfilter-devel@vger.kernel.org>; Thu, 24 Oct 2024 17:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.6.134.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729792679; cv=none; b=hVOYjgfufDT1iL6aQkZaJMghdtxkHLLpVEjOLKuYzFM5DOgNcMUANDVvP2wJMREj+ggnvq/fzijIvxtAFs3a2Jxvd1DYil4Q2Igkbm53UJnzXfGAJ6cMiLbF00aJ5eMY0nF4YOlJcAU0wdS0uvqs9QnrBzYloXYmGLGHIKJwbOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729792679; c=relaxed/simple;
	bh=ok50NMY0aXVs5DusdYWDZiWPFfU42CX3tvhS4lCDWo0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S98g6Pj8VFq0LIhzeBStpbn7PJ314JA+xfqd+thzPrOA+1YetBxZ1jYKdTbGc5Si+uxHFICxX7GEKHYPx7jwygBScfv0GvKUQv4YL4N7OAW+OP1LFbaE0sdl8dU46EgckmVRnwZuiyPDbCOoxEAEVJCHrri/1Snp81c3trSxO/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com; spf=none smtp.mailfrom=schaufler-ca.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=EQuM0vxQ; arc=none smtp.client-ip=74.6.134.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="EQuM0vxQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1729792669; bh=pMfHkMgglQx3nh3YTV4JOae6naXEVyPNSmv9vS8Fpl4=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=EQuM0vxQhefxfG7ChLdlpBCgVuirXIu+LEEDf1Cfn/R12Hzl0KnSV//jkmedWaH1bbdj2wQZak59iIjhVzr7ZgI0CD6PJKai1xzoqThem7hhkh908b7hUq6NHDDM8XToAdvmCJfFazcA6V7YleK5RohdoTiSxGy16W3aHY6UQ6XYKSGori2mJFsh2EYZ0VM2nw1MbgGWVTAfavY/bGtn27YduNUrIHZ/RDS0umLscjxcEUxdWCzE77//HUHIAMfuzh7l5fuMHnYNRDn8YYdW3rxCILpovOIYgho2FFxZR42eW7Y9fYJWf+E0lnYoNYr/RAlQ6TzWyXoGwdldJnus2A==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1729792669; bh=1QkIXn+owGpl+30HRIbYPtM2h9j7h+7THZ12QG14cRx=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=aiUNprW3r9PNVYSpoAjx+u8oIR8SmtXbUhgtUuNDeJ0czo015T6Lbui47RuLYZkNyZ1l/+F49vBI0EIimWMT83hMvmD1ieUn+gHQgwmgkbtC4xF/iBkTAzxcb1uIQfW77BAV4XAWDcRXRhEtdgZtgZU943X6n9pnhHJ5BU7hvul/j1shkaSAgot2ryc0dwqZLXcsyHyTSDIxnMO4s5mpRA4gcesWotBJzgVlcYc0oSvgaHHSd3TpPzk9fvWVxkAOgsc0I6Z62wTnJLxw648GbRf5E5Kqb1Cf+s3qIyO6bfU8iZVarjemfWPpOgYSpctLA6ad9Z8UaleG8aBU+BdbpA==
X-YMail-OSG: .N9KrrgVM1mxM5NcPiRqgH4LIvlbRv.MRg1yZ_HM.ib195bx8L2Ag6h12ViR7fT
 CxI5BZVDRnlP9.w7Mr8zxl.pipQs5t9ys_ZOX.GWbCrE.LIZFRs5yQeCbBem16RLbA.VkaGsJymd
 W.Vj9u.s8ACImhafMrXPmn4CiZ1CSA3k1VMEOcSRBmLDTY4B11PF.f6z7jbVN8K2F6Keqj4mfipT
 LmqhmStPTTVaO6BxjjB6JfY1Z.yb5eyaStUC9h9ZrfbVv9vM9r0DPmcx1XDM1EZWytTpAG2aMKmM
 xKKhBKn0LnorkOf4TguFCUSz3hId0jhWq6Z5ssWSd10.06Mz_8iCUEQyHTV1.6w2lFCgPj.Z71ae
 4nXLnNI0k5RDgntj4yWwZGjmb84GLWs_f6fPlTYkq7zdjw_Gf6q0djSYZvKmeevvB78PilR_Yvu5
 w0R6A9RnPqr637clqioz46o4I8Ou3M.cM_oGSUyh5D2HmhgNKQcEQaK1BbtBBlL_JrraZY7RXhD6
 Q5RryeT34p0h8tLXqW9c_JjEThW3VQSFxhfTMkyjGAuwRgIVi72EMQlwyRRVyGnNtSY1jpKd_.zY
 lP9o_Ll8kKb2VpNnTBwbBJgnaaTdzoXgnJbMfsvAzgSZL6CVq32Ni_IlsktR977FYZEf3.eygXw8
 Lz.zzc7HeM92c.XS76YMpzKhFQpXNzQQsN1XccYDztPSnIU4H5guIjo1.tjLwXDF3x2xdOAnfrwA
 y8jrGOuzHCCuLN.sK9yM3vsogxUtOrSSBOYloBZ4NnbkWzuLGyg_nwpYtbngbsU27Zp_z5pP1fgN
 jR.RT.gJOt4ZiobjulM4rrdiitEYI68r1SLYlCQsL2OA138k4GStVYnxvf2Z.lm7drcmMQEaZmoI
 cQb9ZsAqMr5P2XCu5i9LNCTlRobaLPGeEj2NhbIeFbKndrFtP9ikRhhputCo5jx5ijsBXWg76rYf
 h8t1oXhe5eLC_UWWb7jmebx0bfuvNgd76Mm8_cI2WdxuAokKjPxjUQHy3hLkW4i3keB5qj_lLMx4
 9E.FNS.2q7C1bQqIrN46bLDRIAMgdbPT6.V6gy74JDGaZSb.Obl70zPUTkBiW_1.826jRJ5g2ZMP
 wWdCrgcft18ShNbCT.3QUsz0Z6K7N03fvk2DE7Yb7cCpesVrbVFE4gMJHRdJLz16K_jP6Edojkb2
 0FRlRZ8s5_7vt0EOtpDymt9Wgpdp5WUaEaCYtM_Qsc6A_Hr3y.hwdVPE3QYT_r2l2UKOtlcgkq9H
 CHpAbbvBWHVwDDowAHLil8R1JSSAUtDRIUE1d4K7eWQX0x6MAgUbaHlr3dhTFum2GSZHGNSziUqY
 iKiVyPEV5HfA.TbbLHF7JvqcnycywyWOTQJpKbg4.ki9NIYqw8ZiWg0jklUb4EqtFJ9EuK8L1FMT
 2EXC2.B3GanRW9XTUu2XrBVMaffC5fE19_HRLZlS_3xcZz2LipwrjCdYORuJIOSwRS94vF3mhNmE
 NyNqDWgKwQiludvs3dJuTijXCr6K.QvgnElzwx0u49_rHUQlFoN1sKtOYcj15.r9ck8Fng0mGRJu
 d3G1CFmXZWcjUoUufbw7Q2yfMigkCSC.xrLfGlLEUOhRPz8Lipb1iirY4sOWcSZsCsj4PujI9nOy
 t6LYmWlLt5k3pbjdBLf8bWz1qXWSe6KseN3IuYfM4uFGn6WTQRVflk7SwGr5E2DhdfGKg9luXTXt
 SA52fG94ICUMRTg31U9mJA7_a9UvA3sRN0_.fP0Ignfc7.jbLiWr2kXcoT_eSlj9E1VSylWHFC5L
 3eP8yQSZ.REPkFEYyQqbPywUHljljkmdwiVj2K4n8yJiLVSOFb1B997pdMJRb0KB1XwqOqq.nNbR
 7XXRPA7kBnuPZSag3SvxysZuvvHToPeXL0LHVgo5tFw9z6zhriSljx3gHFMlZLNmdlW8O1ApvrYM
 gIpASAcnOjbJ4cx.MxL2xWXxdThb9XiRFrbA9VFKWO739gtSsPW_p_fYq0q1c2NoT6rOSYf9ZA5r
 fUbLkXpaY0BDs.s6USJV5wYfWdBswmubxxOqVV0Q1FhRydMKcUrNNretaR7oDma.NOnrW6824fUn
 LiwaP.XqGehzvCrzvhcx7ajmBRYEsro.A0ptjyGvHfbwzyrDzvQjh8VsczvaYqFKrxp0t5uvluSJ
 QtlpE.XLtp8nrWduYD4rFQ7wBSAXDHo1y76OYNONIHfarf6Nkkmg9K9wPnP3ynwfth_Q9MRdeZy5
 HY_YlBX_NlHDE3uPmsBYeggddRHncWuKl15X3lOhyxlBLq.zJfekei1n.4fnpB3.pPNiKk6_s43v
 0tgFOGU8WhYqYCF2L8Cw-
X-Sonic-MF: <casey@schaufler-ca.com>
X-Sonic-ID: 5319af78-d978-419c-9abd-0afcd7a4684d
Received: from sonic.gate.mail.ne1.yahoo.com by sonic307.consmr.mail.bf2.yahoo.com with HTTP; Thu, 24 Oct 2024 17:57:49 +0000
Received: by hermes--production-gq1-5dd4b47f46-5kxd4 (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 34a0acd965b86539600f15366b5397a9;
          Thu, 24 Oct 2024 17:57:42 +0000 (UTC)
Message-ID: <0b4f0cd3-181f-4be6-890c-1d225ac1f161@schaufler-ca.com>
Date: Thu, 24 Oct 2024 10:57:41 -0700
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/5] LSM: Replace context+len with lsm_context
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: paul@paul-moore.com, linux-security-module@vger.kernel.org,
 jmorris@namei.org, serge@hallyn.com, keescook@chromium.org,
 john.johansen@canonical.com, penguin-kernel@i-love.sakura.ne.jp,
 stephen.smalley.work@gmail.com, linux-kernel@vger.kernel.org,
 selinux@vger.kernel.org, mic@digikod.net, netdev@vger.kernel.org,
 audit@vger.kernel.org, netfilter-devel@vger.kernel.org,
 Todd Kjos <tkjos@google.com>, Casey Schaufler <casey@schaufler-ca.com>
References: <20241023212158.18718-1-casey@schaufler-ca.com>
 <20241023212158.18718-3-casey@schaufler-ca.com> <ZxpxZuErvXSLApsf@calendula>
Content-Language: en-US
From: Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <ZxpxZuErvXSLApsf@calendula>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.22806 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo

On 10/24/2024 9:10 AM, Pablo Neira Ayuso wrote:
> Hi Casey,
>
> This is a review of the netfilter chunk.

Thank you.

> On Wed, Oct 23, 2024 at 02:21:55PM -0700, Casey Schaufler wrote:
>> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
>> index 86a57a3afdd6..dd74d4c67c69 100644
>> --- a/net/netfilter/nf_conntrack_netlink.c
>> +++ b/net/netfilter/nf_conntrack_netlink.c
>> @@ -360,8 +360,8 @@ static int ctnetlink_dump_secctx(struct sk_buff *skb, const struct nf_conn *ct)
>>  	struct lsm_context ctx;
>>  	int ret;
>>  
>> -	ret = security_secid_to_secctx(ct->secmark, &ctx.context, &ctx.len);
>> -	if (ret)
>> +	ret = security_secid_to_secctx(ct->secmark, &ctx);
>> +	if (ret < 0)
>>  		return 0;
>>  
>>  	ret = -1;
>> @@ -665,8 +665,8 @@ static inline int ctnetlink_secctx_size(const struct nf_conn *ct)
>>  #ifdef CONFIG_NF_CONNTRACK_SECMARK
>>  	int len, ret;
>>  
>> -	ret = security_secid_to_secctx(ct->secmark, NULL, &len);
>> -	if (ret)
>> +	ret = security_secid_to_secctx(ct->secmark, NULL);
> This breaks here.
>
> len is really used, this should be instead:
>
> 	ret = security_secid_to_secctx(ct->secmark, &ctx);
>
> [...]
>         return nla_total_size(0) /* CTA_SECCTX */
>                + nla_total_size(sizeof(char) * ctx.len); /* CTA_SECCTX_NAME */
> #else
>         return 0;
> #endif
> }

I'll fix that.

>> +	if (ret < 0)
>>  		return 0;
>>  
>>  	return nla_total_size(0) /* CTA_SECCTX */
>> diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
>> index 5f7fd23b7afe..502cf10aab41 100644
>> --- a/net/netfilter/nf_conntrack_standalone.c
>> +++ b/net/netfilter/nf_conntrack_standalone.c
>> @@ -175,8 +175,8 @@ static void ct_show_secctx(struct seq_file *s, const struct nf_conn *ct)
>>  	struct lsm_context ctx;
>>  	int ret;
>>  
>> -	ret = security_secid_to_secctx(ct->secmark, &ctx.context, &ctx.len);
>> -	if (ret)
>> +	ret = security_secid_to_secctx(ct->secmark, &ctx);
>> +	if (ret < 0)
>>  		return;
>>  
>>  	seq_printf(s, "secctx=%s ", ctx.context);
>> diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
>> index 37757cd77cf1..5110f29b2f40 100644
>> --- a/net/netfilter/nfnetlink_queue.c
>> +++ b/net/netfilter/nfnetlink_queue.c
>> @@ -470,18 +470,18 @@ static int nfqnl_put_sk_classid(struct sk_buff *skb, struct sock *sk)
>>  	return 0;
>>  }
>>  
>> -static u32 nfqnl_get_sk_secctx(struct sk_buff *skb, char **secdata)
>> +static u32 nfqnl_get_sk_secctx(struct sk_buff *skb, struct lsm_context *ctx)
>>  {
>>  	u32 seclen = 0;
>>  #if IS_ENABLED(CONFIG_NETWORK_SECMARK)
>> +
> remove unneeded line.

Will do.

>>  	if (!skb || !sk_fullsock(skb->sk))
>>  		return 0;
>>  
>>  	read_lock_bh(&skb->sk->sk_callback_lock);
>>  
>>  	if (skb->secmark)
>> -		security_secid_to_secctx(skb->secmark, secdata, &seclen);
>> -
>> +		seclen = security_secid_to_secctx(skb->secmark, ctx);
>>  	read_unlock_bh(&skb->sk->sk_callback_lock);
>>  #endif
>>  	return seclen;
>> @@ -567,8 +567,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
>>  	enum ip_conntrack_info ctinfo = 0;
>>  	const struct nfnl_ct_hook *nfnl_ct;
>>  	bool csum_verify;
>> -	struct lsm_context scaff; /* scaffolding */
>> -	char *secdata = NULL;
>> +	struct lsm_context ctx;
> Help us make this get closer to revert xmas tree:
>
>   	enum ip_conntrack_info ctinfo = 0;
>   	const struct nfnl_ct_hook *nfnl_ct;
> +	struct lsm_context ctx;
>   	bool csum_verify;
> -	struct lsm_context scaff; /* scaffolding */
> -	char *secdata = NULL;

Will do.

>>  	bool csum_verify;
>> -	struct lsm_context scaff; /* scaffolding */
>> -	char *secdata = NULL;
>>  	u32 seclen = 0;
>>  	ktime_t tstamp;
>>  
>> @@ -643,8 +642,8 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
>>  	}
>>  
>>  	if ((queue->flags & NFQA_CFG_F_SECCTX) && entskb->sk) {
>> -		seclen = nfqnl_get_sk_secctx(entskb, &secdata);
>> -		if (seclen)
>> +		seclen = nfqnl_get_sk_secctx(entskb, &ctx);
>> +		if (seclen >= 0)
>>  			size += nla_total_size(seclen);
>>  	}
>>  
>> @@ -783,7 +782,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
>>  	if (nfqnl_put_sk_classid(skb, entskb->sk) < 0)
>>  		goto nla_put_failure;
>>  
>> -	if (seclen && nla_put(skb, NFQA_SECCTX, seclen, secdata))
>> +	if (seclen && nla_put(skb, NFQA_SECCTX, ctx.len, ctx.context))
>>  		goto nla_put_failure;
>>  
>>  	if (ct && nfnl_ct->build(skb, ct, ctinfo, NFQA_CT, NFQA_CT_INFO) < 0)
>> @@ -811,10 +810,8 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
>>  	}
>>  
>>  	nlh->nlmsg_len = skb->len;
>> -	if (seclen) {
>> -		lsmcontext_init(&scaff, secdata, seclen, 0);
>> -		security_release_secctx(&scaff);
>> -	}
>> +	if (seclen >= 0)
>> +		security_release_secctx(&ctx);
>>  	return skb;
>>  
>>  nla_put_failure:
>> @@ -822,10 +819,8 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
>>  	kfree_skb(skb);
>>  	net_err_ratelimited("nf_queue: error creating packet message\n");
>>  nlmsg_failure:
>> -	if (seclen) {
>> -		lsmcontext_init(&scaff, secdata, seclen, 0);
>> -		security_release_secctx(&scaff);
>> -	}
>> +	if (seclen >= 0)
>> +		security_release_secctx(&ctx);
>>  	return NULL;
>>  }
>>  
