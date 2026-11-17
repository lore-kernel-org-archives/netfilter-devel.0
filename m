Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.99
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794959851;
	b=duoir6C0KNBLLBJEhgJim9Fjb8lnM9bmZa46RWStf1T2nn6635oqg/rFxYJC8h1qWp4n
	 q2pxYGHWKf+RkhgbCZo5XYI7YZwUK5j92xHqn6td0O7asvokdqOk6VRFaAbIwfnyQQ+vF
	 szTdKEyHzeZjE+XOdTBjmIaIPCrns5kXy+PVs2K3Zme/XBtQAKtlcQd4BptI4IVWnmh6s
	 PMwBTuXMG7CnlyNEy6eP3hCaUSlUyCUDhTEHiB1PADDeumd+UZadk9EvJjWAyw+i7CzK8
	 lYqe97tL6Piec+UojyihGwy+MBKZtAefIeuxldYMy8A3F8ULYXpqo+ki8xEwiRp0vqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794959851;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:X-Relaying-Domain:
	 X-CFilter-Loop:Received:DKIM-Signature:X-Forwarded-Encrypted:
	 X-Received:X-Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:Autocrypt:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-DetectorID-Processed;
	bh=oLrBNLG0hX6sgbYQVZZuBInuSRFzwVDllACR+Rvkm4I=;
	b=cIexTYj5sQM3vXWc8JqKGQ8t65l51qLzFr6eDaYAU23o3ZSnO0jZy4aBr1Hqfg0rd/1d
	 L7axA6Q2vvEA7ycO8JdRlnX3a0P6RplGRxvP4ukjfoXpEtyUG3fewzZizLDVB+6Sgn7Kf
	 3ZyEB5MKL2N0Qy6sWRiyGV+Adylp5A9CcCv2Tix10BiX60w6qGKuTCwflG7zoOTKXFGNb
	 KbSU7N48LxdQQaebMiFQzLNvDmtK7WRD6W+sxmJ7oLwtslHndpgK86YAp6jYSQ3dSdpzs
	 tjQU71GKmGNA4X/jGyiF99nkgcV7THBrZ9CcWP+JoVBhrGR1RASoZHQcwWvWtnOby8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b="VVoUo/O7";
	arc=none smtp.remote-ip=209.85.216.99
Received: from mail-pj1-f99.google.com (mail-pj1-f99.google.com [209.85.216.99])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29A9D606A884
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2026 23:57:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 29A9D606A884
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=VVoUo/O7
Received: by mail-pj1-f99.google.com with SMTP id 98e67ed59e1d1-3b179528d56so146779a91.3
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2026 15:57:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794959850; x=1795564650;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:dkim-signature:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=oLrBNLG0hX6sgbYQVZZuBInuSRFzwVDllACR+Rvkm4I=;
        b=1gbzbtBW/EdNvWn6L9uJ9QOdDOx1X8AxjwrICrLid67huCoEbqaQgF/igHwvW3Dn2O
         qT3wM2EK3VP8i1MTzTuuhLTrxf0m7NynqxJdLFnSXVBoN03O4V3oS7Zh6evtLXizaDp5
         sgkZg5a1LTnM+XgtrCMRWuF4ObO3oow0w0iNUBi0FYYNAlvmIGNDDJMQJBmeXL+IDMe1
         xW+FeNuMM36stxUdjzQYTp0iW1fP/2BvPk7hmaHyqvBlyoCfwwsRLc0/g9RndyJLW1ZC
         tGxejGcCgGKCwNHDzhrorZgUtXMR052HgrmE2tEH9jm9rl8lBQxC8h51BOiZ/298RBo9
         RyNg==
X-Forwarded-Encrypted: i=1; AL+hErF/KJDMNWJtbLHbfHaVJikLHooiZwV+7IDuGA9d+IpwTWJlqHolGkCRDEAURaWr6h+L+SyGUcHIFZrTEByQwoQ=@vger.kernel.org
X-Gm-Message-State: APuU4Z+FVRZW5NGwyp0LIcHYQWwGzCgRNsY4d6rFmU7tqT2/SOtL4sVF
	3yLx7TS7HqdrxxrEouYUymR0nHI63rQDQBhxmjECOfhxvB8H/2oA7IRchQIL8kPdoRagTLm5xSG
	R0rr9H48DLmVG72GeyJO6cdlvSIZW5dh7iXLyTKZIbcitZ0rIU8rnit02oFr4PWUqx06wpu2YVc
	18/aJKvzUtCAjdXlEnavmjkj1Wb44orgHHP3D47BISYsZeexSOY2J8/hnAqvsJj+5R6aaOqCg9n
	dsdCmgx1wAnV7vCm+JRiC+36YWh
X-Gm-Gg: AZFdTZc0CZWTrwrDGnwdAAONFkZw7LVD2yPoXxSbUpZ9y8jwitXUClSDmyJnN2qPQvd
	iLIMf7PgG7bmzisHu/17RZnNPO+XDoxxsj/VOWew7Y1CSGwnuTPUqPkNriQ29/sobnahQZZ5tHb
	HkPItsX8FyrHwfXQO80Wh9rND7aUIIOyJlQFNvvHT38iJZJA8LY+16ZZemYEi8MbBM5RKyQLeSn
	1pxtqJZGrFvGbQHMoGgC1ldmIs5E9nHLhFjZYToJ66cY9Y9fyS0hoKbm3Xumf1+YgaLaAC48UC5
	VjJteWrKK5iJPuMZxp37wusAzihF8gW7vl+s9a6zGCUUn6DyEJ/HNKNAmvqczKkfoUHfKQ3+u8N
	fNIeZZQFHgmlLENFtVRL9vVsmOPMKT/GTg0XNXV0B4Rlkl+iRkCRKK/dHX/IFlzh7XKCu/Wl8gS
	3azUzCONFrkFziC+O9I1TrEsI7WD8llWY5rIO/qaKm
X-Received: by 2002:a17:90b:1e48:b0:3a0:d265:3647 with SMTP id 98e67ed59e1d1-3b3d068a19dmr813978a91.8.1794959850416;
        Tue, 17 Nov 2026 15:57:30 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-28.dlp.protect.broadcom.com. [144.49.247.28])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b3d14c0525sm655768a91.8.2026.11.17.15.57.28
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Nov 2026 15:57:30 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dl1-f71.google.com with SMTP id a92af1059eb24-1b53bfc9534so207802c88.0
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2026 15:57:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1794959847; x=1795564647; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oLrBNLG0hX6sgbYQVZZuBInuSRFzwVDllACR+Rvkm4I=;
        b=VVoUo/O7GYJfuKE5PaO654WHyhlqGDHSy/vM7QiuMg7loMYBjyuC2ZErbmM0KV+kUW
         6v2tBmVTlI2S1V/IeYR/2Hac9dA13vINqs87+AePXTvYOg49Dh7V54SeoOyUXiWh0p8G
         7VeMwie2Ehm3BgrPKyPayA0BPZDc7YrqPdLTM=
X-Forwarded-Encrypted: i=1; AL+hErGcQsHhnhxSt4zbMQKgPbfItCSB0vtrV3SsdR2nWIBiKPYxgc5OKO5jHPOF31r+bVOz442My0IJYgd5ouMaZTI=@vger.kernel.org
X-Received: by 2002:a05:701b:458e:20b0:1ac:d029:70cb with SMTP id a92af1059eb24-1b543cfaf3emr911523c88.30.1794959847206;
        Tue, 17 Nov 2026 15:57:27 -0800 (PST)
X-Received: by 2002:a05:701b:458e:20b0:1ac:d029:70cb with SMTP id a92af1059eb24-1b543cfaf3emr911494c88.30.1794959846336;
        Tue, 17 Nov 2026 15:57:26 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5447dc596sm1434831c88.10.2026.11.17.15.57.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Nov 2026 15:57:25 -0800 (PST)
Message-ID: <85be0d5e-918c-48cc-999a-3193154ecfad@broadcom.com>
Date: Tue, 17 Nov 2026 15:57:23 -0800
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next 3/9] netfilter: flowtable: retain offload
 ownership until deletion completes
To: netdev-bot+sashiko@kernel.org
Cc: netdev@vger.kernel.org, rafal@milecki.pl,
 bcm-kernel-feedback-list@broadcom.com, andrew+netdev@lunn.ch,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org,
 pabeni@redhat.com, robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org,
 horms@kernel.org, corbet@lwn.net, jonas.gorski@gmail.com, olteanv@gmail.com,
 pablo@netfilter.org, fw@strlen.de, phil@nwl.cc, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org
References: <20261116222519.1416501-4-florian.fainelli@broadcom.com>
 <179495815956.3136.7417407587662864290@kernel.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <florian.fainelli@broadcom.com>
Autocrypt: addr=florian.fainelli@broadcom.com; keydata=
 xsBNBFPAG8ABCAC3EO02urEwipgbUNJ1r6oI2Vr/+uE389lSEShN2PmL3MVnzhViSAtrYxeT
 M0Txqn1tOWoIc4QUl6Ggqf5KP6FoRkCrgMMTnUAINsINYXK+3OLe7HjP10h2jDRX4Ajs4Ghs
 JrZOBru6rH0YrgAhr6O5gG7NE1jhly+EsOa2MpwOiXO4DE/YKZGuVe6Bh87WqmILs9KvnNrQ
 PcycQnYKTVpqE95d4M824M5cuRB6D1GrYovCsjA9uxo22kPdOoQRAu5gBBn3AdtALFyQj9DQ
 KQuc39/i/Kt6XLZ/RsBc6qLs+p+JnEuPJngTSfWvzGjpx0nkwCMi4yBb+xk7Hki4kEslABEB
 AAHNMEZsb3JpYW4gRmFpbmVsbGkgPGZsb3JpYW4uZmFpbmVsbGlAYnJvYWRjb20uY29tPsLB
 IQQQAQgAywUCZWl41AUJI+Jo+hcKAAG/SMv+fS3xUQWa0NryPuoRGjsA3SAUAAAAAAAWAAFr
 ZXktdXNhZ2UtbWFza0BwZ3AuY29tjDAUgAAAAAAgAAdwcmVmZXJyZWQtZW1haWwtZW5jb2Rp
 bmdAcGdwLmNvbXBncG1pbWUICwkIBwMCAQoFF4AAAAAZGGxkYXA6Ly9rZXlzLmJyb2FkY29t
 Lm5ldAUbAwAAAAMWAgEFHgEAAAAEFQgJChYhBNXZKpfnkVze1+R8aIExtcQpvGagAAoJEIEx
 tcQpvGagWPEH/2l0DNr9QkTwJUxOoP9wgHfmVhqc0ZlDsBFv91I3BbhGKI5UATbipKNqG13Z
 TsBrJHcrnCqnTRS+8n9/myOF0ng2A4YT0EJnayzHugXm+hrkO5O9UEPJ8a+0553VqyoFhHqA
 zjxj8fUu1px5cbb4R9G4UAySqyeLLeqnYLCKb4+GklGSBGsLMYvLmIDNYlkhMdnnzsSUAS61
 WJYW6jjnzMwuKJ0ZHv7xZvSHyhIsFRiYiEs44kiYjbUUMcXor/uLEuTIazGrE3MahuGdjpT2
 IOjoMiTsbMc0yfhHp6G/2E769oDXMVxCCbMVpA+LUtVIQEA+8Zr6mX0Yk4nDS7OiBlvOwE0E
 U8AbwQEIAKxr71oqe+0+MYCc7WafWEcpQHFUwvYLcdBoOnmJPxDwDRpvU5LhqSPvk/yJdh9k
 4xUDQu3rm1qIW2I9Puk5n/Jz/lZsqGw8T13DKyu8eMcvaA/irm9lX9El27DPHy/0qsxmxVmU
 pu9y9S+BmaMb2CM9IuyxMWEl9ruWFS2jAWh/R8CrdnL6+zLk60R7XGzmSJqF09vYNlJ6Bdbs
 MWDXkYWWP5Ub1ZJGNJQ4qT7g8IN0qXxzLQsmz6tbgLMEHYBGx80bBF8AkdThd6SLhreCN7Uh
 IR/5NXGqotAZao2xlDpJLuOMQtoH9WVNuuxQQZHVd8if+yp6yRJ5DAmIUt5CCPcAEQEAAcLB
 gQQYAQIBKwUCU8AbwgUbDAAAAMBdIAQZAQgABgUCU8AbwQAKCRCTYAaomC8PVQ0VCACWk3n+
 obFABEp5Rg6Qvspi9kWXcwCcfZV41OIYWhXMoc57ssjCand5noZi8bKg0bxw4qsg+9cNgZ3P
 N/DFWcNKcAT3Z2/4fTnJqdJS//YcEhlr8uGs+ZWFcqAPbteFCM4dGDRruo69IrHfyyQGx16s
 CcFlrN8vD066RKevFepb/ml7eYEdN5SRALyEdQMKeCSf3mectdoECEqdF/MWpfWIYQ1hEfdm
 C2Kztm+h3Nkt9ZQLqc3wsPJZmbD9T0c9Rphfypgw/SfTf2/CHoYVkKqwUIzI59itl5Lze+R5
 wDByhWHx2Ud2R7SudmT9XK1e0x7W7a5z11Q6vrzuED5nQvkhAAoJEIExtcQpvGagugcIAJd5
 EYe6KM6Y6RvI6TvHp+QgbU5dxvjqSiSvam0Ms3QrLidCtantcGT2Wz/2PlbZqkoJxMQc40rb
 fXa4xQSvJYj0GWpadrDJUvUu3LEsunDCxdWrmbmwGRKqZraV2oG7YEddmDqOe0Xm/NxeSobc
 MIlnaE6V0U8f5zNHB7Y46yJjjYT/Ds1TJo3pvwevDWPvv6rdBeV07D9s43frUS6xYd1uFxHC
 7dZYWJjZmyUf5evr1W1gCgwLXG0PEi9n3qmz1lelQ8lSocmvxBKtMbX/OKhAfuP/iIwnTsww
 95A2SaPiQZA51NywV8OFgsN0ITl2PlZ4Tp9hHERDe6nQCsNI/Us=
In-Reply-To: <179495815956.3136.7417407587662864290@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On 11/17/26 15:29, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 6 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 0 · Medium: 4 · Low: 2
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [Medium] Moving IPS_OFFLOAD_BIT out of flow_offload_teardown() means
>    the lockless check in nf_flow_table_extend_ct_timeout() can no longer…
> - [Medium] This patch reverses the central change of the commit in its
>    Fixes: tag but does not say so, and it does not mention the later…
> - [Medium] The patch's ownership argument ('For hardware flows, GC
>    reaches this point only after hardware deletion is complete ...…
> - [Medium] The patch now releases IPS_OFFLOAD (re-admission) in
>    flow_offload_del() once NF_FLOW_HW_DEAD is set, and the commit…
> - [Low] The new KUnit test nf_flow_test_hardware_retirement() and the
>    NF_FLOW_TABLE_KUNIT_TEST help text say they check that hash removal…
> - [Low] The new Documentation/networking/nf_flowtable.rst text (and the
>    commit message) list the visible side effects of keeping IPS_OFFLOAD…
> 
> --
> 
> netfilter: flowtable: retain offload ownership until deletion completes
> 
> This patch moves the clearing of IPS_OFFLOAD_BIT from
> flow_offload_teardown() to flow_offload_del(), after both hash entries have
> been removed. The goal is that a replacement flow can't be admitted on the
> same conntrack while the old owner's cleanup is still pending. It also
> documents the transient status and adds KUnit tests for the ownership
> lifetime.
> 
>> diff --git a/Documentation/networking/nf_flowtable.rst b/Documentation/networking/nf_flowtable.rst
>> index d757c21c10f2d..b9b4444357758 100644
>> --- a/Documentation/networking/nf_flowtable.rst
>> +++ b/Documentation/networking/nf_flowtable.rst
>> @@ -205,6 +205,19 @@ refers to the software offload mode, so there is a distinction between [OFFLOAD]
>>   which refers to the software flowtable fastpath and [HW_OFFLOAD] which refers
>>   to the hardware offload datapath being used by the flow.
>>   
>> +During teardown, software fastpath lookups immediately stop matching the
>> +flow. Packets reaching software follow the classic forwarding path, while
>> +hardware deletion may still be pending. The OFFLOAD status
>> +bit remains set until hash removal and asynchronous hardware deletion are
>> +complete, preventing a new owner from racing the old owner's cleanup. As a
>> +result, conntrack dumps can temporarily retain [OFFLOAD] or [HW_OFFLOAD]
>> +and omit the TCP state after a FIN or RST has returned to the slow path.
> 
> [Severity: Low]
> Is this list of side effects complete? Several in-tree users of
> IPS_OFFLOAD_BIT now see the bit set for the whole GC and async DESTROY
> window.
> 
> ctnetlink_dump_info() skips the timeout as well as the protoinfo:
> 
> net/netfilter/nf_conntrack_netlink.c:ctnetlink_dump_info() {
>      ...
> 	if (!test_bit(IPS_OFFLOAD_BIT, &ct->status) &&
> 	    (ctnetlink_dump_timeout(skb, ct, false) < 0 ||
> 	     ctnetlink_dump_protoinfo(skb, ct, false) < 0))
>      ...
> }
> 
> ct_seq_show() hides the expires field in the same way. As a result, the
> repaired timeout mentioned in the next paragraph can't be seen during this
> interval.
> 
> nf_nat_used_tuple_harder() also reads the bit as "entry is offloaded":
> 
> net/netfilter/nf_nat_core.c:nf_nat_used_tuple_harder() {
>      ...
> 	static const unsigned long flags_offload = IPS_OFFLOAD | IPS_HW_OFFLOAD;
>      ...
> 	if (nf_ct_kill(ct))
> 		taken = flags & flags_offload;
>      ...
> }
> 
> A torn-down TCP entry in CLOSE or TIME_WAIT that has gone back to the slow
> path would now be evicted but still reported as taken.
> 
> The UAPI comment for IPS_OFFLOAD_BIT in nf_conntrack_common.h still says
> "Conntrack has been offloaded to flow table", but this text redefines the
> bit as ownership pending cleanup.
> 
> Should these effects be documented here too?
> 
> [ ... ]
> 
>> diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
>> index 2aa2647ed9df0..4c82097cd50bc 100644
>> --- a/net/netfilter/nf_flow_table_core.c
>> +++ b/net/netfilter/nf_flow_table_core.c
>> @@ -393,12 +393,15 @@ static void flow_offload_del(struct nf_flowtable *flow_table,
>>   	rhashtable_remove_fast(&flow_table->rhashtable,
>>   			       &flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].node,
>>   			       nf_flow_offload_rhash_params);
>> +	/* Release admission only after both hashes and async hardware state
>> +	 * have gone. An older owner must not clear its replacement's status.
>> +	 */
>> +	clear_bit_unlock(IPS_OFFLOAD_BIT, &flow->ct->status);
> 
> [Severity: Medium]
> The commit message says "For hardware flows, GC reaches this point only
> after hardware deletion is complete" and "Holding the admission bit
> prevents overlapping owners".
> 
> Can a datapath reader still queue a FLOW_CLS_REPLACE for this flow after
> its DESTROY has completed?
> 
> flow_offload_lookup() checks NF_FLOW_TEARDOWN once. The later
> flow_offload_refresh() only looks at NF_FLOW_CLOSING and NF_FLOW_HW:
> 
> net/netfilter/nf_flow_table_core.c:flow_offload_refresh() {
>      ...
> 	if (likely(!nf_flowtable_hw_offload(flow_table)) ||
> 	    test_bit(NF_FLOW_CLOSING, &flow->flags))
> 		return;
> 
> 	if (test_bit(NF_FLOW_HW, &flow->flags))
> 		nf_flow_offload_refresh(flow_table, flow);
> }
> 
> nf_flow_offload_work_alloc() is gated only by NF_FLOW_PENDING.
> flow_offload_work_handler() clears that bit after flow_offload_work_del()
> has set NF_FLOW_HW_DEAD. One possible sequence:
> 
> reader                      gc / offload work
> flow_offload_lookup()
>    TEARDOWN not set
>                              flow_offload_teardown()
>                              nf_flow_offload_del()
>                              flow_offload_work_del()
>                                set_bit(NF_FLOW_HW_DEAD)
>                              NF_FLOW_PENDING cleared
> flow_offload_refresh()
>    nf_flow_offload_refresh()
>      REPLACE queued
>                              flow_offload_work_add()
>                                set_bit(IPS_HW_OFFLOAD_BIT)
>                              flow_offload_del()
>                                clear_bit_unlock(IPS_OFFLOAD_BIT)
>                                flow_offload_free()
> 
> After this, the re-installed hardware rule is keyed by a freed cookie, and
> IPS_HW_OFFLOAD stays set on the ct. nft_flow_offload_eval() or act_ct can
> then admit a replacement owner through test_and_set_bit(IPS_OFFLOAD_BIT).
> 
> With PREEMPT_RCU or PREEMPT_RT, the reader's RCU section could span
> flow_offload_del(). Could the queued REPLACE work then use the flow after
> flow_offload_free_rcu() has freed it?
> 
> The lookup/refresh window existed before this patch, but the new ownership
> argument depends on it being closed. Later patches in the series don't
> touch flow_offload_refresh() or nf_flow_offload_refresh().
> 
> [Severity: Medium]
> Does NF_FLOW_HW_DEAD really mean the device removed the rule?
> flow_offload_work_del() sets it unconditionally:
> 
> net/netfilter/nf_flow_table_offload.c:flow_offload_work_del() {
> 	clear_bit(IPS_HW_OFFLOAD_BIT, &offload->flow->ct->status);
> 	flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_ORIGINAL);
> 	if (test_bit(NF_FLOW_HW_BIDIRECTIONAL, &offload->flow->flags))
> 		flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_REPLY);
> 	set_bit(NF_FLOW_HW_DEAD, &offload->flow->flags);
> }
> 
> flow_offload_tuple_del() throws away the return value of
> nf_flow_offload_tuple(..., FLOW_CLS_DESTROY, ...), and
> nf_flow_offload_tuple() skips callbacks that return errors.
> 
> A driver's DESTROY can fail and leave the rule programmed, for example
> bnxt_tc_del_flow() after a firmware HWRM failure. In that case
> flow_offload_del() still releases IPS_OFFLOAD and frees the flow, and the
> flow's tuplehash[dir].tuple is the driver cookie.
> 
> Could a replacement owner then program a second rule for the same tuple
> while the stale rule, with the old route or NAT, stays in hardware with no
> way to delete it?
> 
> The ignored DESTROY result predates this patch. However, the ownership
> serialization described in the commit message depends on deletion having
> completed.
> 
>>   	flow_offload_free(flow);
>>   }
>>   
>>   void flow_offload_teardown(struct flow_offload *flow)
>>   {
>> -	clear_bit(IPS_OFFLOAD_BIT, &flow->ct->status);
>>   	if (!test_and_set_bit(NF_FLOW_TEARDOWN, &flow->flags))
>>   		flow_offload_fixup_ct(flow);
>>   }
> 
> [Severity: Medium]
> Without this clear_bit(), can the flowtable GC overwrite the timeout that
> flow_offload_fixup_ct() just repaired?
> 
> nf_flow_offload_gc_step() samples NF_FLOW_TEARDOWN once and doesn't check
> it again before calling nf_flow_table_extend_ct_timeout(). The only guard
> left in the extend helper is the IPS_OFFLOAD_BIT re-test:
> 
> net/netfilter/nf_flow_table_core.c:nf_flow_table_extend_ct_timeout() {
> 	u32 ct_timeout = READ_ONCE(ct->timeout);
>      ...
> 	if (!refcount_inc_not_zero(&ct->ct_general.use))
> 		return;
> 
> 	/* load ct->status after refcount increase */
> 	smp_acquire__after_ctrl_dep();
> 
> 	if (nf_ct_is_confirmed(ct) &&
> 	    test_bit(IPS_OFFLOAD_BIT, &ct->status)) {
>      ...
> 			cmpxchg(&ct->timeout, ct_timeout, new_timeout);
>      ...
> }
> 
> That re-test now always passes until flow_offload_del() runs. Consider:
> 
> CPU0                                CPU1
> nf_flow_offload_gc_step()
>    teardown = false
>                                      flow_offload_teardown()
>                                        set NF_FLOW_TEARDOWN
>                                        flow_offload_fixup_ct()
>                                          nf_ct_refresh()
> nf_flow_table_extend_ct_timeout()
>    READ_ONCE(ct->timeout)
>      /* repaired, below 5 min */
>    test_bit(IPS_OFFLOAD_BIT)
>      /* still set */
>    cmpxchg(&ct->timeout, ct_timeout,
>            now + NF_CT_DAY)
> 
> CPU1 can be the datapath after a failed dst check or a missing outdev, act_ct
> on FIN/RST, or nf_flow_table_cleanup() on netdev events.
> 
> The refcount, smp_acquire__after_ctrl_dep() and re-test sequence from
> commit 03428ca5cee9 depends on teardown clearing the bit before
> flow_offload_fixup_ct() repairs ct->timeout.
> 
> flow_offload_del() doesn't repair the timeout again. A UDP flow with no
> further packets would therefore keep its conntrack entry for NF_CT_DAY
> instead of seconds or minutes.
> 
> Doesn't this contradict "TCP state and timeout repair run at first
> teardown" in the commit message? Later patches in the series leave
> flow_offload_teardown(), nf_flow_offload_gc_step() and
> nf_flow_table_extend_ct_timeout() unchanged.
> 
> [Severity: Medium]
> This undoes the main change of the commit named in the Fixes: tag:
> 
>      Fixes: e5eaac2beb54 ("netfilter: flowtable: fix TCP flow teardown")
> 
> e5eaac2beb54 moved this clear_bit() from flow_offload_del() into
> flow_offload_teardown(). The reason was that conntrack gc could race to
> undo the packet path's timeout adjustment, leaving the entry with the
> one-day offload timeout.
> 
> Moving it back looks safe on mainline only because commit 03428ca5cee9
> ("netfilter: conntrack: rework offload nf_conn timeout extension logic")
> removed this block from gc_worker():
> 
> 	if (test_bit(IPS_OFFLOAD_BIT, &tmp->status)) {
> 		nf_ct_offload_timeout(tmp);
> 		...
> 		continue;
> 	}
> 
> 03428ca5cee9 has no Fixes: or stable tag. Suppose this patch is backported
> to a stable tree that has e5eaac2beb54 but not 03428ca5cee9.
> 
> Wouldn't gc_worker() then reset ct->timeout to now + NF_CT_DAY during the
> whole window from teardown to flow_offload_del()? flow_offload_del() would
> then clear the bit without another repair. For closed TCP and expired UDP
> entries, that brings back the bug e5eaac2beb54 fixed.
> 
> Could the commit message say that it reverts part of e5eaac2beb54 and
> depends on 03428ca5cee9?
> 
> [ ... ]
> 
>> diff --git a/net/netfilter/nf_flow_table_core_test.c b/net/netfilter/nf_flow_table_core_test.c
>> new file mode 100644
>> index 0000000000000..378a1c60b50b9
>> --- /dev/null
>> +++ b/net/netfilter/nf_flow_table_core_test.c
>> @@ -0,0 +1,86 @@
> 
> [ ... ]
> 
>> +	flow_offload_teardown(flow);
>> +	/* nft_flow_offload must not admit another owner during async DESTROY. */
>> +	KUNIT_EXPECT_TRUE(test, test_and_set_bit(IPS_OFFLOAD_BIT, &ct->status));
>> +	flow_offload_teardown(flow);
>> +	KUNIT_EXPECT_TRUE(test, test_bit(IPS_OFFLOAD_BIT, &ct->status));
>> +	/* Model completed hardware deletion before the GC removes the hashes. */
>> +	clear_bit(IPS_HW_OFFLOAD_BIT, &ct->status);
>> +	set_bit(NF_FLOW_HW_DEAD, &flow->flags);
>> +	rcu_read_lock();
>> +	flow_offload_del(&table, flow);
> 
> [Severity: Low]
> Does this test cover the ordering it describes? The Kconfig help says
> "Require hash and asynchronous hardware deletion before re-enrolment".
> However, the only code that makes deletion wait for hardware removal is in
> nf_flow_offload_gc_step():
> 
> 	if (test_bit(NF_FLOW_HW, &flow->flags)) {
> 		if (!test_bit(NF_FLOW_HW_DYING, &flow->flags))
> 			nf_flow_offload_del(flow_table, flow);
> 		else if (test_bit(NF_FLOW_HW_DEAD, &flow->flags))
> 			flow_offload_del(flow_table, flow);
> 
> This test sets NF_FLOW_HW_DEAD by hand and calls flow_offload_del()
> directly, and flow_offload_del() reads neither flag. If the
> HW_DYING/HW_DEAD gating were removed or broken, neither case would fail.
> 
> Both cases also use IPPROTO_ICMP, so flow_offload_fixup_ct() returns
> immediately. The TCP state and timeout repair at first teardown is never
> exercised. nf_flow_test_teardown_repeat() only checks that
> flow_offload_teardown() no longer touches IPS_OFFLOAD_BIT.
> 
> Later in the series the Kconfig help is reworded to "Test flowtable
> ownership during asynchronous hardware deletion", so the gap seems to
> remain in the final state.
> 

[Medium] extend_ct_timeout() racing with teardown

Agreed. With IPS_OFFLOAD kept until flow_offload_del(), the re-test of
the bit in nf_flow_table_extend_ct_timeout() no longer detects a 
teardown that already repaired ct->timeout. v2 passes the flow to the 
helper and checks NF_FLOW_TEARDOWN after sampling ct->timeout (teardown 
sets the flag before repairing the timeout), before the cmpxchg. A KUnit 
case covers it.

[Medium] Reverts part of e5eaac2beb54, depends on 03428ca5cee9

Agreed. The commit message now says this moves the clear_bit() back to 
flow_offload_del(), that this is only safe since 03428ca5cee9 removed 
the IPS_OFFLOAD handling from gc_worker(), and that the patch must not 
be backported to trees without it.

[Medium] "Hardware deletion is complete"

Agreed on the wording. GC reaches flow_offload_del() once the DESTROY
work has run (NF_FLOW_HW_DEAD), not once the device is known to have 
removed the rule, since the DESTROY result is not propagated. v2 words 
it that way. Making DESTROY failures visible is a separate, pre-existing 
limitation of the hardware offload code and not addressed here.

[Medium] Refresh queued after DESTROY

The lookup/refresh window in flow_offload_refresh() predates this patch
and is independent of when IPS_OFFLOAD is released, so I'd rather not
change it here. I will look at it separately.

[Low] Documentation and KUnit

v2 documents the other effects of the bit remaining set (ctnetlink and
/proc omit the timeout as well as the TCP state, NAT does not reuse the 
tuple), makes the retirement test go through nf_flow_offload_gc_step() 
so the HW_DYING/HW_DEAD gating is covered, and describes in Kconfig only 
what the tests check. The TCP/UDP timeout repair itself is still not
covered by them.

Pre-existing issues from the first review

The use-after-free in flow_offload_work_handler() and the missing GRE
timeout fixup in flow_offload_fixup_ct() are not introduced by this
patch. I will follow up on them separately.

pw-bot: cr
-- 
Florian
