Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7866D3E8342
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Jun 2026 08:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780562788; cv=none; b=EZ8WUMHlLDi+paqjP5u+uGHHpTrv1wjyco8Ys0YKKxOR9pOj5EvfR//zbHJwSHMnDHD3X1qcquGU75mWwbFIlaHxPl/xEMRdx1jXVkLJS/zbSFPvJB2M+/h3aSeGhxxXXHCp0QIn86QGpEF2Y9+xq3tR/JLx6uln53nBfQ8fAnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780562788; c=relaxed/simple;
	bh=TzGkKn8TD3NZ/cb7c3NDgkoUymg3dMeC56+V0+NIcKo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oCSQfGiu9GD79NRcDiGN+6uMmPw/hVAxy5tXB7Gp+pZdUE2Nb7rAVL+9I2GwXCz0g/gmMNzFuxOn+dAxYkLcgcBgiF7fAWmurMxbaa18q5ZU48kJ6DQuAr+WmqPpROlR1WFPE+qgiBL4ziCrdwUnEAtg9RLf6wIXkMErsmYtI30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PppnYbhY; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=jHNeCW/I; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PppnYbhY";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="jHNeCW/I"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780562786;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9QOMNMy5WtR0fKQJlZyg9RUw7wF3IZTQobfw9Y4B4IE=;
	b=PppnYbhYL2H+TKgShIyD1FyqZHCNn1S5ftqYKdqdzluN6DfNNTukifXBohqZakBu6F1kvX
	jI7OIcuiQQZYJUPNzVOq5bNcqyok8UzhFdFr/j+c99aMKrH4kLUGTp9uemfP/Zl0c+XcWx
	fJfviLtDPq+H0UhuF08+TDjYF24q98k=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-303-Dm7oKMyeMS2ikYxahYm2Qw-1; Thu, 04 Jun 2026 04:46:25 -0400
X-MC-Unique: Dm7oKMyeMS2ikYxahYm2Qw-1
X-Mimecast-MFC-AGG-ID: Dm7oKMyeMS2ikYxahYm2Qw_1780562784
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-490b37e1f48so4102285e9.0
        for <netfilter-devel@vger.kernel.org>; Thu, 04 Jun 2026 01:46:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1780562784; x=1781167584; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9QOMNMy5WtR0fKQJlZyg9RUw7wF3IZTQobfw9Y4B4IE=;
        b=jHNeCW/I4KAtYLcanIsmx6xX2op1rQNYq6MPDFUyv+6POYxuOdkG2er+Y1rCdFsuC8
         OCp1PI3JLcdAEAoHL4jYjPCMhtNMfWaqy1eo6Eqw2z/tneuuiQNsT+vJclUIhAwqJkmp
         5NRYEl6xadf+FuSAqt5vxss4JL3GOIqbm+EP2Atd0GMMn7ORMh/ssnpw0IZjmE7aLvsC
         wewcv/hSdr/Lixkutw2PC5MpI5GYlk2klyHN8YN1aTi2Fj7fmBo0gXo7DBPEv3lpJLYA
         hSEP0cD/2bEf7qDPmYAYtUKcvAANaF5qjcMaTLgZhY0x+/e2n3LPlhjSdMaWT5TlyiuQ
         x52g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780562784; x=1781167584;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9QOMNMy5WtR0fKQJlZyg9RUw7wF3IZTQobfw9Y4B4IE=;
        b=LVtfq0do2CJ25S9PDboalGzfkxacrxG0KAMNEUSEcgo0bvrOlxGK0ocMw6Q0pkicmk
         VB4rbw5qu7sFwgS5gSfUtHs+XugrOlaYcBAlJIO2YZ7wbOZxKHEUwfMKueJIAu+pV7fj
         CqBDqofIdCWFhLTizCc4t/FrLF7t5wDDUk2eU5hu17aqDNCyPFsJJno7UdGTtJP/shUZ
         xHxx/nX6sZTItPLWy6K9sHDtUT90EKe+bd5pu90PNqvIdMTK6Gp21TlLJcqi1O56XiMC
         z14AwU3iqoQOquNoTqboEE6FfHLHuxd/dt1FkmXYtxtR2lwtIJXP9SkHBS+ID7s6luAQ
         5UFQ==
X-Forwarded-Encrypted: i=1; AFNElJ9VLc51V0Pu9fv5B5Ux/JjAZUXT/U8SGXgbsvE8SyOA+BYTOrJvY1Fg4G8nvCG90MVWmD7RWsH2lO+RIupGLIk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwfcEefn2h/l9AcSSHzBPPLlK9gVX7eBZV6+3xKJGFGsctB/SgN
	ZOmkN0BVu/uMBBxEwL74Le/wNuISuiEdut03zPUFumaJdJNjRBgfxDQcozDN/v05oSwRZR2uxiw
	C6FHWJGfDd5omb0bD9VDRmpgUgb7KjdWIVT/OzrVVUfsOzNNcGQDw9G1KsDXCJ5QlD9v4lg==
X-Gm-Gg: Acq92OGe6aRBbTRma7kHbzXrKSZst0WrwM7VoCumDwxx3nVTFhbOAN95Lw2qyeNYEdh
	f+tSi1DBdd3Oh+YZHnH9lDca+Vy3JFzhbacadRd5zeQybPFGYDEvB5YYT9LXgfRPVhh2mdaVjIN
	OX9QnGb06v8pmCIAzZeXbCM5eHem92LUOzSZqS+gec5lfYqanbVTcXBU+R/NGWaUp1zqYs9zKy0
	8o9JUfRB2A2xJqiGdjuBiRJSdmKFtggJ0m/yMRPjKFrlj5N/moSfXlbxwzWGSZphWhuTJXFaUjz
	JEdiFk9UUOdguu69vNsRvnllpm/dNQbNkxvUpD0ZpCQKkikfSPcHZb17AKhRyTZk0XVo83+wvPZ
	d33V2pRBamOZx36YuDpL3Mk9hQW4DERgnwMCJu8Qb9+J7+97B02yayWBOf6MmOMWmVOY=
X-Received: by 2002:a05:600c:8b30:b0:48f:e26a:1744 with SMTP id 5b1f17b1804b1-490b5eb4aeemr108691295e9.9.1780562783991;
        Thu, 04 Jun 2026 01:46:23 -0700 (PDT)
X-Received: by 2002:a05:600c:8b30:b0:48f:e26a:1744 with SMTP id 5b1f17b1804b1-490b5eb4aeemr108690905e9.9.1780562783650;
        Thu, 04 Jun 2026 01:46:23 -0700 (PDT)
Received: from [192.168.88.32] ([212.105.155.59])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc3c183asm56479775e9.6.2026.06.04.01.46.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jun 2026 01:46:23 -0700 (PDT)
Message-ID: <fc531060-6ff9-467c-b04d-1a913f6c718e@redhat.com>
Date: Thu, 4 Jun 2026 10:46:21 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net] ipv4: validate ip_forward_options() option fields
 against skb tail
To: Ido Schimmel <idosch@nvidia.com>, Qi Tang <tpluszz77@gmail.com>
Cc: fw@strlen.de, jiayuan.chen@linux.dev, pablo@netfilter.org,
 netfilter-devel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
 edumazet@google.com, netdev@vger.kernel.org, dsahern@kernel.org,
 horms@kernel.org, lyutoon@gmail.com, stable@vger.kernel.org
References: <ahlfI38aDciPfG2S@strlen.de>
 <20260529104356.911666-1-tpluszz77@gmail.com>
 <20260531121711.GA189496@shredder>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20260531121711.GA189496@shredder>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

31/26 2:17 PM, Ido Schimmel wrote:
> On Fri, May 29, 2026 at 06:43:56PM +0800, Qi Tang wrote:
>> Florian Westphal <fw@strlen.de> wrote:
>>> I'm not sure netfilter is the only facility that can munge data this
>>> way nowadays.  The plan is to disable arbitrary network header rewrites:
>>>
>>> https://lore.kernel.org/netfilter-devel/20260527121147.22076-1-fw@strlen.de/
>>
>> Agreed, the source side is the better place for this on mainline.
>>
>> I went looking for other ways into the window between option compile
>> (ip_rcv_options() in ip_rcv_finish_core, after PREROUTING) and
>> ip_forward_options(), and only found nft_payload and nfqueue at the
>> FORWARD hook. tc/cls-act run before compile (ingress) or after
>> ip_forward_options (egress), BPF at the netfilter hook can't write the
>> packet (base helpers only, no bpf_skb_store_bytes), and the LWT_IN BPF
>> path is blocked by the verifier. So your two-part restriction closes the
>> only in-tree triggers I could find.
>>
>> This is just one consumer of the pattern; __ip_options_echo(),
>> ipmr_cache_report() and the CIPSO/CALIPSO netlbl_skbuff_getattr() path
>> are the same, posted as a series here:
>>
>>   https://lore.kernel.org/netdev/20260524041442.2432071-1-tpluszz77@gmail.com/
>>
>> so if the source-side restriction is the way to go it probably makes
>> more sense to drop these consumer-side checks than to fix each site.
>> Your call.
> 
> FWIW, I agree that it would be better to go with Florian's patches
> rather than always assuming that we can't trust the data that was parsed
> from the IP options.


FTR, I agree with the above plan.

/P

