Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B300E4FD7B8
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Sep 2026 09:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790675722; cv=none; b=YiJGEDzduvfwnw/N2HdVHW2KsgcLYm/uH6rZYffBNIfY0Q7dDExwtLBuqqtonvhgld90NtXfkTXzsBbGrHhtHKkW8GN5MAmXqTomIDetgKmmnVbJGV6Ryxy9tla+hzluoO5nHWdm5bLEFsFgxHXWs+HMZ3tuROlpmK14+76TqkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790675722; c=relaxed/simple;
	bh=2cSis9vTtWC8H3BljFkbrjp0DLrAfv/3hWWwKfKIWbg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OQtOhCKK9RcJh2C8i95rbM67N8uPT+v+tqku8Y60TzDzNgZD1P5SuU6Q81z6Igd65ayqVzCXhnIAcu8mPmf3v+J6faqcp/Qw9RH7IUP7OayuA1zdbSl/5ZUalOyZoCB7Qbqp07pRTQkcLRsCEApkB3u4WWY7VEGp3N8yjfVNk70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O6Wfsd8P; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=D1o9yLCI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O6Wfsd8P";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="D1o9yLCI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790675719;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K2Ajk6aUW96zcMqeh8tYw0dpGpc8JB8IH24LTPrD26Q=;
	b=O6Wfsd8PQhtTR6w64AtII78Nwq0FYgyMSzPJbzE9CNr7NnNnc07YUfcMpXqjLkuL9mzrUy
	/bx6yJ+Drv9GIB/kDJ8NpjenjXoYcFgvCcgAPcQToqoNJsQgu8P04ARiUN8mw1HZZraLpd
	nBK64TPBa1IpZRy814SAc/AwieZIKoA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-649-pcvtikfRODCeU5oES32prA-1; Tue, 29 Sep 2026 05:55:15 -0400
X-MC-Unique: pcvtikfRODCeU5oES32prA-1
X-Mimecast-MFC-AGG-ID: pcvtikfRODCeU5oES32prA_1790675714
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-486f3c0d896so2079865f8f.3
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Sep 2026 02:55:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790675714; x=1791280514; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=K2Ajk6aUW96zcMqeh8tYw0dpGpc8JB8IH24LTPrD26Q=;
        b=D1o9yLCIsTSGyOQ1dBoAgsS4N6cZLPej2BnzuP1VcFJBw6kyafNIrH4GEbdfyprTxE
         D+BxPv07nxYclCm1Su/ptJTkGLG0BTL5u/LR2Y7QXFiFBVPxt6G/PWjpvAG+6xzcsoJ5
         /cCAk5BNs46nRRb2bIunKBfmROG/7AExUbj4pZ/K+QKMVEw8GUUItzdwt9nHoO+qf3lu
         fBBWsleKGRty+yHeZ6ASqT1W1nPsiWHXO6mV4/c8XKgW4cxB/LQIM5t/CiOZIQfqQeq/
         ebXxbrVve9iFrjjKOawruPFTe7YyiqTSx2Kh+Pyd6VqEfZ8I5QJt8CTQAnxXVlu9L0Af
         Ji2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790675714; x=1791280514;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=K2Ajk6aUW96zcMqeh8tYw0dpGpc8JB8IH24LTPrD26Q=;
        b=RLsmgCpAv+b5juMpMUgE9WMVdGArd/8QocTR1kfSy3rayFHvmo1dVwKU6XhE2jMDg1
         rTDGaS0dLmK0VMC8t79oosCIjpg+wS6cEIa+Rntby6odj+ZxAeLVQ2NN/Pw2VbR1Qet+
         AkY/FZkOM4sqnplGrOJejysEEpS0H+XZNhmqKvPLYDVTtwT4XCx4yOwwZIYerQfvy1/Q
         kaUVpEmuJz/4on00VAsecqAelEsnE/hSeD693DkzF5AWaPrKoi/LCDU0JVXsfjo454CF
         omSLge9332+sx6092lMqm92qgZgUaEBc6s0ePz1JxBJPyOESJd5/uw+1evH8vxtZ59xV
         +Csw==
X-Forwarded-Encrypted: i=1; AKwUvByFx08WcWDzJHP/7j4Mz7wrT6F8Zkl4TdaATWLDbq+1NL0nl05a9zFgBE1bmDqaKYeAPU1zXTY3iZ4DGh4eLeI=@vger.kernel.org
X-Gm-Message-State: AFq9FYIIjpQPj7u6x7HQgO7WC7/y+gWSb0UwBAhYpwyWvBxRFAWcTCDH
	AKsS371iREv4QOjP6sPqJz6UWiItYVgjIybEEH08DMkaF7WKN92pwUxS/Sr36fjVG//uERmNCFY
	JqgzyvEiczmOlpnjqj580WsQ4rMx8FgpCNyILOW07v9rxCBCrZJbE/gUQPO4BXLwkKrlXBg==
X-Gm-Gg: AYBFou2Ey3g0w7mwg1nG9P1n/MmuX0E5D+Gnmoa0xTw52/XLnnN40D5s0DzxkbfC9st
	DH/XU6BKoBbUgRv3dpaIlaacqX6cG8X10wVtSj22rKQT43oXQbm/n9oFBee6jryqliN3rpfreu+
	FPwUHbOkKGRgk+m/S3R0dJxZ/eNm1q+74Vls4IuQRM5kc9XvblVVlTPPXj5jrub5HU5jcwZ1uiA
	r5O/NvzcUMz0/HEWkHVpvxZJKQLcuU9Cps8gGQDCBKUdOjZSnNvATIq0qf4+4yZ4Bz74ut8I4u/
	Ih/rS8DOGlw6QoZOQeE4mcAojY8xLFjRzR2KWsxq5uxDSTEq4cteTY4pjTa4O5gsMA5KRskgAJ1
	50kp9RYKIsFRfkgJHM3OYoRl516l1PmADm/lXM7QzLoCuX0QP9Vtp/lFC8WmW6941dFZWePRaMw
	==
X-Received: by 2002:a05:6000:41f9:b0:487:13f:f612 with SMTP id ffacd0b85a97d-4887db39634mr21276251f8f.37.1790675713909;
        Tue, 29 Sep 2026 02:55:13 -0700 (PDT)
X-Received: by 2002:a05:6000:41f9:b0:487:13f:f612 with SMTP id ffacd0b85a97d-4887db39634mr21276205f8f.37.1790675713417;
        Tue, 29 Sep 2026 02:55:13 -0700 (PDT)
Received: from [192.168.188.234] (ip232-47-231-195.pool-bba.aruba.it. [195.231.47.232])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48af50a3c49sm2783708f8f.34.2026.09.29.02.55.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Sep 2026 02:55:12 -0700 (PDT)
Message-ID: <f5766ebd-7436-4c82-a835-49d09b68ce0f@redhat.com>
Date: Tue, 29 Sep 2026 11:55:11 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net 02/11] ipvs: fix buffer overflow when sending sync
 messages
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Julian Anastasov <ja@ssi.bg>, netdev-bot+sashiko@kernel.org,
 netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, edumazet@google.com,
 horms@kernel.org, fw@strlen.de
References: <20260927220816.268206-3-pablo@netfilter.org>
 <179063970014.3145.11099245705422825051@kernel.org>
 <2aa8af69-3843-3ffd-cfa4-2daf3c949127@ssi.bg>
 <634b26a1-cf1f-46c0-8026-c9c08f398169@redhat.com>
 <aruIKBhVhp3KKvJp@chamomile>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <aruIKBhVhp3KKvJp@chamomile>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/29/26 11:43, Pablo Neira Ayuso wrote:
> Hi Paolo,
> 
> On Tue, Sep 29, 2026 at 10:19:55AM +0200, Paolo Abeni wrote:
>> On 9/29/26 06:06, Julian Anastasov wrote:
>>>>> @@ -744,7 +749,7 @@ void ip_vs_sync_conn(struct netns_ipvs *ipvs, struct ip_vs_conn *cp, int pkts)
>>>>>    		s->v4.vaddr = cp->vaddr.ip;
>>>>>    		s->v4.daddr = cp->daddr.ip;
>>>>>    	}
>>>>> -	if (cp->flags & IP_VS_CONN_F_SEQ_MASK) {
>>>>> +	if (seq_mask) {
>>>>>    		*(p++) = IPVS_OPT_SEQ_DATA;
>>>>>    		*(p++) = sizeof(struct ip_vs_sync_conn_options);
>>>>>    		hton_seq(&cp->in_seq, (struct ip_vs_seq *)p);
>>>>
>>>> [Severity: Medium]
>>>> This is a pre-existing issue, not one introduced by this patch. The flags
>>>> are now a consistent snapshot, but the sequence data is still read
>>>> without cp->lock. Nothing orders that read against READ_ONCE(cp->flags).
>>>> Can the master send stale or half-updated ip_vs_seq values here?
>>>>
>>>> ip_vs_sync_conn() here only holds ipvs->sync_buff_lock. The same applies
>>>> to the memcpy() of cp->sync_conn_opt in ip_vs_sync_conn_v0().
>>>>
>>>> On the backup side, ip_vs_proc_conn() sets the SEQ bits in cp->flags under
>>>> cp->lock and drops the lock. Only after that does it copy the sequence
>>>> data, with no lock held:
>>>>
>>>> net/netfilter/ipvs/ip_vs_sync.c:ip_vs_proc_conn() {
>>>>       ...
>>>> 		cp->flags = flags;
>>>> 		spin_unlock_bh(&cp->lock);
>>>>       ...
>>>> 	if (opt) {
>>>> 		cp->in_seq = opt->in_seq;
>>>> 		cp->out_seq = opt->out_seq;
>>>> 	}
>>>>       ...
>>>> }
>>>>
>>>> On a node running both the master and backup daemons, ip_vs_sync_conn()
>>>> could see seq_mask set and then send old or torn init_seq, delta and
>>>> previous_delta values. A peer with an app bound to that connection would
>>>> then apply the wrong TCP seq/ack adjustment after failover.
>>>
>>> 	Agreed, this can be improved to take a snapshot of
>>> flags and seqs together under lock. I'll request to drop
>>> this version, it is not urgent to apply it.
>>
>> It looks like a respin of the PR is needed, I'll drop the revision from PW.
> 
> Just wrote to Jakub with a summary on the LLM report.
> 
> I would take this PR as is if it is still possible.
> 
> If you feel strong about to need to respin this PR, that's also fine
> with me, just let confirm where to go.
Uhm... I must admit that given the pressure we received from Linus on
shrinking/prevent from increasing the net PR size I think we are better
off dropping patch 2/11 entirely.

I'm sorry for the extra work, but the messaging from Linus was pretty
strong:

https://lore.kernel.org/netdev/CAHk-=wiSnTE9vBZ=5_v+3EEkdazCCbBM5YABRzRHUAeRdyd4Xw@mail.gmail.com/

Thanks,

Paolo

