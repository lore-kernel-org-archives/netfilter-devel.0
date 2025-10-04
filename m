Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56480218AD1
	for <netfilter-devel@vger.kernel.org>; Sat,  4 Oct 2025 11:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759575722; cv=none; b=ePmVUAVFK6mI6jlZ/CtCy7AeGbzO0cl6JuCN6nHuKfZr3im6U8yYwa/eyTv3gzcboJOQtiowjfxaTi9bdP8Fq30NiUwlrnEPsK2yVukqS1JUlhZTbX0+2K8wHuCplQRiLLNCJha0DhxE5HiTJuySrse9D30wvdgxOsvqtWcCttM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759575722; c=relaxed/simple;
	bh=LYoZFBgZzefaOIuKaaDC31/zxDNS2XhFvOLcaFmZ55c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qmn+wdb2o9X33duQGB/rdYZQvkrgeGROIz87d3vt0xfEWa77t+d7BQmPqPEjzI2z0ApuEgFbM3FQrzQxd3E/R2IF/PAHtcKUEsrAq4PcTSlUX5G7HZLWSzt70ZXawFmDzCsi2y+3+Ptoqbr9Lw2HzoRlnthhEAqAP2/wDtRRjRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CGzeRGkT; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CGzeRGkT"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b3da3b34950so273921166b.3
        for <netfilter-devel@vger.kernel.org>; Sat, 04 Oct 2025 04:02:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759575719; x=1760180519; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4JEPtWfH/pmqT0IiioQlJm8QQAb8IOQ6u1KYhuGkN+0=;
        b=CGzeRGkT32xUV8C6ggsuYBeUMuZ7NDK1IWuHSpKQa9b+JK48aChjOxY2TDZr/O4Iml
         PPIN7axexXoqvcNLgiSoZOpoHhQeyaBNyxJhGmgC7SSeurqN5bh34SO1LOWyVVmTRf6E
         ZHZxrU9xN1EWYpYeKMz5mGzKliFUHmnT6wTt/GuHuxS0G6navxM3aALLWIU1FTT/30Sf
         tKxWTJqApE/sTihmu5UNFuvOOU4O/biGtvAe1olVoI67KZVGmpjLAgxlAWvnlzrIFWBJ
         +tLEBTlmd9zGtuEHMmfjI5h2W7eH0ks1Aph4Awn3L95O4sjPbC1gx6oh2MoTuDJ17dVM
         8JkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759575719; x=1760180519;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4JEPtWfH/pmqT0IiioQlJm8QQAb8IOQ6u1KYhuGkN+0=;
        b=inkVbLp5TfuPKr/xBVxgvoOT/+V659lH5usueuy6u7aE2I1HVjY6AvaQsOVmuMdfyH
         a6V4A7xxAwuNAmE7g1BHZpPX2yCed0qSFMngOUdHys8fE/mThEVhXLs+Nf+8WJmp7daF
         2i9RGvlcBOdZ9irNKrbq2mLzhgDroTBMiuU2CWZ2DoNyjyuzfdD3Ux1lW03sBjie+o8a
         MsCC5ZSm66I6/cU90AlUZcGGwOLq43FL+g9NQxWAunJxAqqba1M2lhlQyVciCyKdlP9/
         iE4iWgFLy/n299KRvWvLUm02ZMCzwJr7doaIo6TcEx03b/L3tBavMx8CayaCc4RWPSf6
         62VA==
X-Forwarded-Encrypted: i=1; AJvYcCUsVWP636RVY3QxCKZ1KiZqZTyQvjTFtX2eMyn74cVPqBeLEfIzhaAn+mOmpbUpZG7mX5BOxt+tOJsdOVYzEqo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwwkAaW5/Hbtvk4g7xF9CCG8jVLRWEiKbHlEG0sikdGsU662MDS
	KcsV2KhKaKh5xHEfR6gSyPROQGwZZgB4JG+/2KF5zNDNSYGhpzIX+8Pc
X-Gm-Gg: ASbGncvJCwgmuQXW1NXENMLkec+AWnIX7dalEUqJmaZurMhK/GJT5XAoy9qRUz5/WBF
	8F76xPOdDQIEKrQpAMeVBUUM8P3DYjhiRsJBrS9Ff0z6dXZAeAR/QyEt1SE0wlb4dw5hX7UxKPF
	Rq57OM/8+HBfcPo6ZKPJhLfPf0k2KxQKUAKHOqcU4Yigq4k+S9UylwIh2IYLqBNWJFEYQMybwXE
	sCunAeaxS4Vv7Wo9FuWaLwEkw1LtVztZmckjdbN8PrIeSsr/avvc2GQN4urQhMWFTpC8+AyJegd
	9FvEranJvIc5XWWfbSfzKf5tGlsoRDFxYJMAHi9yuiTKe2vc5xvcqD6xMb1Y9wLc3drG1NF5lDg
	Rf5XxLJSLih3neIicF27UhI/2PAP29dV56BbBsqKNxsz463TNFOg/rYlpEgybxdhm8L03wSOfRs
	npWZEENofK9tgWpTTgGr8kFvY7fZr5hvm307esXgoLixbAlvM2X5P8QwQxuH9rg6tDG4j399qHz
	JcPMMnlbl586bJTBUMSe5XYhSdJOrZx24Y=
X-Google-Smtp-Source: AGHT+IG+nqJ0/vTFLgg0Wbdw2FCh/o7R7pBu3UjE7P4IHI5UG5xywNMKwlwYe8p93L5hubwR/YKojA==
X-Received: by 2002:a17:907:3f21:b0:afe:b311:a274 with SMTP id a640c23a62f3a-b49c2c5e006mr742545466b.46.1759575718273;
        Sat, 04 Oct 2025 04:01:58 -0700 (PDT)
Received: from ?IPV6:2001:1c00:20d:1300:1b1c:4449:176a:89ea? (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b486970b30asm678443766b.59.2025.10.04.04.01.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Oct 2025 04:01:57 -0700 (PDT)
Message-ID: <be179c64-8c14-4f38-bab2-4597afc63341@gmail.com>
Date: Sat, 4 Oct 2025 13:01:56 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 nf-next] selftests: netfilter: Add
 bridge_fastpath.sh
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
 Jozsef Kadlecsik <kadlec@netfilter.org>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, Shuah Khan <shuah@kernel.org>,
 Nikolay Aleksandrov <razor@blackwall.org>,
 Vladimir Oltean <olteanv@gmail.com>, netfilter-devel@vger.kernel.org,
 netdev@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20250925183341.115008-1-ericwouds@gmail.com>
 <aNwtMiC22yOAO4Y6@strlen.de>
From: Eric Woudstra <ericwouds@gmail.com>
Content-Language: en-US
In-Reply-To: <aNwtMiC22yOAO4Y6@strlen.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/30/25 9:19 PM, Florian Westphal wrote:
> Eric Woudstra <ericwouds@gmail.com> wrote:
>> Add a script to test various scenarios where a bridge is involved
>> in the fastpath. It runs tests in the forward path, and also in
>> a bridged path.
> 
> Why is this still an RFC, what is missing to appy this?

Changes in the patchset "conntrack: bridge: add double vlan, pppoe and
pppoe-in-q" has lead to changes in this script. I'm waiting for that
patch-set is to be accepted. Then I will send this script without the
rfc tag.
> Also:
> 
> PASS:  forward,        without vlan-device, without vlan encap, client1, without fastpath
> 
> net/bridge/br_private.h:1627 suspicious rcu_dereference_protected() usage!
> 
> other info that might help us debug this:
> 
> rcu_scheduler_active = 2, debug_locks = 1
> 7 locks held by socat/410:
>  #0: ffff88800d7a9c90 (sk_lock-AF_INET){+.+.}-{0:0}, at: inet_stream_connect+0x43/0xa0
>  #1: ffffffff9a779900 (rcu_read_lock){....}-{1:3}, at: __ip_queue_xmit+0x62/0x1830
>  #2: ffffffff9a779900 (rcu_read_lock){....}-{1:3}, at: ip_output+0x57/0x3c0
>  #3: ffffffff9a779900 (rcu_read_lock){....}-{1:3}, at: ip_finish_output2+0x263/0x17d0
>  #4: ffffffff9a779900 (rcu_read_lock){....}-{1:3}, at: process_backlog+0x38a/0x14b0
>  #5: ffffffff9a779900 (rcu_read_lock){....}-{1:3}, at: netif_receive_skb_internal+0x83/0x330
>  #6: ffffffff9a779900 (rcu_read_lock){....}-{1:3}, at: nf_hook.constprop.0+0x8a/0x440
> 
> stack backtrace:
> CPU: 0 UID: 0 PID: 410 Comm: socat Not tainted 6.17.0-rc7-virtme #1 PREEMPT(full)
> Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> Call Trace:
>  <IRQ>
>  dump_stack_lvl+0x6f/0xb0
>  lockdep_rcu_suspicious.cold+0x4f/0xb1
>  br_vlan_fill_forward_path_pvid+0x32c/0x410 [bridge]
>  br_fill_forward_path+0x7a/0x4d0 [bridge]
>  ...
> 
> I did not see a mention of this, nor a bug fix.
> 
> Its a pre-existing bug, br_vlan_fill_forward_path_pvid uses
> br_vlan_group() instead of _rcu version.
> 
> Will you send a patch for this?
I had this as part of an upcoming patch-set, but I will remove it from
there and send it as a separate patch. I assume this can go to nf
instead of nf-next, as it is a bugfix?

