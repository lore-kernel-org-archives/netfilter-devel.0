Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D2553B2D06
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Sep 2026 08:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790670003; cv=none; b=SZLGZ8z87v3SMsQ52oD8UDS8UniLEOm8U7piSVyqkHnahwIUSqWBQpt/zYXv+0+knW8k9XyRSOcMM7S2jExGs/5NXlfGTVVAEA93yg4vJlUp23gGre5pW1rhJs3cNpEd5M9u+981KLOU+N2zgdc80isbkkI2kPlhaFEUT4Z2UpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790670003; c=relaxed/simple;
	bh=UJXmFnB7jJfUQAk7s64O6CCXBBnCeICxx/9fhtjzSzg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YdoLWYnYXR6q9TnIji0ektWRsXlJrfjguILtUuZOxVJ66azZSb19w1zbfi6Mo+FTj7kHQx5OyFLsvoCLzFDbMM9rjQ02OwJv1K7R/gImh/Ocjgz6weKdDvBoYeLrB9THLoOLjRQUdS0BVXBkQPY6rlSX2/Dv5MTVu+5yDM6Sl4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ha2ZeDJZ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=QL89iegy; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ha2ZeDJZ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="QL89iegy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790670000;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HStg1Uqa/VIEw6O4CRdtR8jZc6QqebiwsLAM0OcHJqw=;
	b=ha2ZeDJZAc/oDsIBFR0MSwjO3td68WAetG82mS/5BCh7ZMon3AWk4E48zGoFZ4VIDj6aBo
	NHuf9wTxTQ7O++qdfNlQAXV+VL5JSYplD1W5bn6WMcMcpK5u/Ph390y76jZ2wJ2lmKRAwH
	ELhiK4dNIFn+G9UouFlpU7OKGXFIM2U=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-251-m5BPd6vbOOKX7mjtg6zZIA-1; Tue, 29 Sep 2026 04:19:58 -0400
X-MC-Unique: m5BPd6vbOOKX7mjtg6zZIA-1
X-Mimecast-MFC-AGG-ID: m5BPd6vbOOKX7mjtg6zZIA_1790669997
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4994d67d0e3so28446665e9.2
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Sep 2026 01:19:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790669997; x=1791274797; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HStg1Uqa/VIEw6O4CRdtR8jZc6QqebiwsLAM0OcHJqw=;
        b=QL89iegyCg1eJp4b+G8SdweovSBifLLvq0X9Z/MxZPIZtHiw03Y27fiICYDxh/U42+
         4uoVmgTCU3e8FvgwcKSJb36HCP3M8yqMhlRv/U7I8nnIt/UBA5dESbWYyROdR/nO1R5R
         +ew6kYNRU3ri+54ccjk1+0O06T7XJv4po7E7n8k5pSUlr44pTX97O63fObEaPQ+0HpYH
         XPq9WEtysStwItoW5ssCFsmQxva6UQR1M2uEJAIGV91bSqiOrCk7w3A2wVriBQt+2BLf
         zYOBqQ1tvelbibV/3n0xa27d7mK+AmH+SLY1YU3dm37aYCbROQasePaaw07F0XO66ROw
         mQuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790669997; x=1791274797;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HStg1Uqa/VIEw6O4CRdtR8jZc6QqebiwsLAM0OcHJqw=;
        b=kncOSXOoEOWERtVDGIt8mnA9K3pYkAsWuW2BugLjPdXmRtNDum+xPJamDq3hTHBSCH
         fSt3OiPWHfawWTHnEvKkIBbAWmBb1vOQSjghKZpJHrHzyuxiLRWsyJv3v5r1hX5PAFUB
         woV60ylzA5sqXois22UeBnhIt41HHQ3uqe6+NFw1PK7PkmlHI/dpUx87RqdxAGuA681/
         Xs/Gsv9rK52fD4ZcWOC+mhhVhT9ndjRgfnk7M26XQFqezimO/8etLOCkZizYBA4Q5yri
         R+ALSHp/a2IO5XyXN0mX3C/zEs5IZP4Vqm6IAtxETyqvY0A/mTllI6gbr7LezLtoHLAS
         ZzCA==
X-Forwarded-Encrypted: i=1; AKwUvBycChGnTTInojWWUEbTGVLx5PE6AYcMGUkijMjXio8B8+LPw2jhLuorsswh8UEQVfXWoBa4JF3mQyTDCy6wXas=@vger.kernel.org
X-Gm-Message-State: AFuF++lp/B7qJUrqLiW6WufAZx3Bo9+tP99x4z0DiSeD1gkJ4x13tPAb
	sKTZ9yy4EQr0qB747CLGnwIBBGCg/DmWQdHLOvp27H93+gQY/Rn8f0JrUxmUKJQMinzmdmWnCYQ
	UJn/45oTqU5WrlEQMo0kc3ImUyE1NQVTsNdMkiQk5TzHtuWF8AiZOyJW7Wy0cuICAjMiSfg==
X-Gm-Gg: AYBFou3OV+2NgHe77JvBqTScWNowRMEqsDBnDpAGF+H3H7b0Txpr9EOoGFxOl/DoP4z
	gf9XCqjRpBD0/Xnb28lzDQXY6JzZg5lIOVQtUwb9kSSBErz3zHNDFtIxJG05y8oyA4Oy3RuWIVM
	vthuYYSRtOG4o5j8H78M+d2nuupqF/jsmwjPWSqqu5eXWoz6v1L78F0EZUIDKNbrPNLQJZJaEp3
	4EUqkm6DhJicJtDR2mmvqJdQ4/IhhTM0xtnZcc9I1KDYAMddCXtqYTqq376gItoQPBqPnRfR+7W
	aDnc5JrOgKaDdSaoiEwwr5yoUKW49gsVzfIrtM0ptWHOGeAt5hib2zhj3e0I+ClqQyq6KmGyXjn
	pMhnorlCbbjXSoUw8fY0sDBFqUkau0Xj/gCrrPr3giJwSz5m39WWIlW82sQbrxTBm9yRcHLEJ9e
	SqqnUMzHsv
X-Received: by 2002:a05:600c:198b:b0:49c:edd8:ba35 with SMTP id 5b1f17b1804b1-49fe66ca13dmr281087645e9.6.1790669997253;
        Tue, 29 Sep 2026 01:19:57 -0700 (PDT)
X-Received: by 2002:a05:600c:198b:b0:49c:edd8:ba35 with SMTP id 5b1f17b1804b1-49fe66ca13dmr281087315e9.6.1790669996828;
        Tue, 29 Sep 2026 01:19:56 -0700 (PDT)
Received: from [192.168.188.234] (ip232-47-231-195.pool-bba.aruba.it. [195.231.47.232])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48af5056a16sm2041732f8f.18.2026.09.29.01.19.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Sep 2026 01:19:56 -0700 (PDT)
Message-ID: <634b26a1-cf1f-46c0-8026-c9c08f398169@redhat.com>
Date: Tue, 29 Sep 2026 10:19:55 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net 02/11] ipvs: fix buffer overflow when sending sync
 messages
To: Julian Anastasov <ja@ssi.bg>, netdev-bot+sashiko@kernel.org
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
 davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
 edumazet@google.com, horms@kernel.org, fw@strlen.de
References: <20260927220816.268206-3-pablo@netfilter.org>
 <179063970014.3145.11099245705422825051@kernel.org>
 <2aa8af69-3843-3ffd-cfa4-2daf3c949127@ssi.bg>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <2aa8af69-3843-3ffd-cfa4-2daf3c949127@ssi.bg>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/29/26 06:06, Julian Anastasov wrote:
>>> @@ -744,7 +749,7 @@ void ip_vs_sync_conn(struct netns_ipvs *ipvs, struct ip_vs_conn *cp, int pkts)
>>>   		s->v4.vaddr = cp->vaddr.ip;
>>>   		s->v4.daddr = cp->daddr.ip;
>>>   	}
>>> -	if (cp->flags & IP_VS_CONN_F_SEQ_MASK) {
>>> +	if (seq_mask) {
>>>   		*(p++) = IPVS_OPT_SEQ_DATA;
>>>   		*(p++) = sizeof(struct ip_vs_sync_conn_options);
>>>   		hton_seq(&cp->in_seq, (struct ip_vs_seq *)p);
>>
>> [Severity: Medium]
>> This is a pre-existing issue, not one introduced by this patch. The flags
>> are now a consistent snapshot, but the sequence data is still read
>> without cp->lock. Nothing orders that read against READ_ONCE(cp->flags).
>> Can the master send stale or half-updated ip_vs_seq values here?
>>
>> ip_vs_sync_conn() here only holds ipvs->sync_buff_lock. The same applies
>> to the memcpy() of cp->sync_conn_opt in ip_vs_sync_conn_v0().
>>
>> On the backup side, ip_vs_proc_conn() sets the SEQ bits in cp->flags under
>> cp->lock and drops the lock. Only after that does it copy the sequence
>> data, with no lock held:
>>
>> net/netfilter/ipvs/ip_vs_sync.c:ip_vs_proc_conn() {
>>      ...
>> 		cp->flags = flags;
>> 		spin_unlock_bh(&cp->lock);
>>      ...
>> 	if (opt) {
>> 		cp->in_seq = opt->in_seq;
>> 		cp->out_seq = opt->out_seq;
>> 	}
>>      ...
>> }
>>
>> On a node running both the master and backup daemons, ip_vs_sync_conn()
>> could see seq_mask set and then send old or torn init_seq, delta and
>> previous_delta values. A peer with an app bound to that connection would
>> then apply the wrong TCP seq/ack adjustment after failover.
> 
> 	Agreed, this can be improved to take a snapshot of
> flags and seqs together under lock. I'll request to drop
> this version, it is not urgent to apply it.
It looks like a respin of the PR is needed, I'll drop the revision from PW.

/P

