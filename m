Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.225
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794959044;
	b=ViGu5VJRMkYtLBIx2lnpCEVU0zHs7mQMuYHfj9rRrtIbLjaN5Vn65AgMy1VFvCJF3o/A
	 yBcJEbuDCA0iT9dEsdR96z/xcxeVGkLDqRHcb9fAhiUFrqUQRuJlMr63vBZiv+5nTzBdg
	 1sarUb3lVXkUt8kwhWgrNsKC4vaCZL9Y5Cysv4A4cETJitU7sKMfZbM9k2vom1v37g9qO
	 PYGbTD6NZ30wo/AhzOzRTxJcjnqjR0yvhZkZIJZnS0HLG5A4ly0sB/RA2lV5OENEx7e0K
	 Wae8xnwLozl3XMelcq54g/T3+JQ73ZsmKZV06n4N24Ond8pntGjuAAq6krWUlGTXLUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794959044;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:X-Relaying-Domain:
	 X-CFilter-Loop:Received:DKIM-Signature:X-Forwarded-Encrypted:
	 X-Received:X-Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:Autocrypt:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-DetectorID-Processed;
	bh=chWuGj4JSfuHqV8d6iYVixzJTNnCSogSzx0lpANcwLI=;
	b=oXBiClqbo7a8QCtb3D8iftznnCDvqEdeI7mRwuhvtEJrUsSXKzCIkKEw+CRmo5yXo4cf
	 bRzUMOCOkXBU8z+i+jVnkHOZMp4z4uHJWGF5yqwZZyiQx3EKIqGJ470FRnm3hLEyxuvp/
	 yySE/2Fkl2I+Gpq/KMli6uUTLFAiTdGOgq9H7g6ThYJm0+7KYEkVDNbRatC+cnaBKwoiA
	 Kc0uzxxCNXpEemD4ZFUkNlw3N9/472IGaUFYBZ4GZJD3v44Xu9xb1dJV5ainBhBZpnWJM
	 ebWL9EnLT7cIZ8GwKfPZsTr1IBIZsEo8qknbeKBtxgSIrfPI/njZEAYt9bloUKIoIjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=fx5C73B5;
	arc=none smtp.remote-ip=209.85.215.225
Received: from mail-pg1-f225.google.com (mail-pg1-f225.google.com [209.85.215.225])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 398FD606A32C
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2026 23:44:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 398FD606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=fx5C73B5
Received: by mail-pg1-f225.google.com with SMTP id 41be03b00d2f7-cd61cef87f1so306384a12.0
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2026 15:44:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794959043; x=1795563843;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:dkim-signature:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=chWuGj4JSfuHqV8d6iYVixzJTNnCSogSzx0lpANcwLI=;
        b=fJIH2Sca4eifdukE1Va5Asj8LVDKY8NZHxP7e7Ecv6wRrYYo1aT4RKmktZ4HDBhB9f
         hhfAZdtyidDQtUEOPXs9UsYn72v+4kt72Zv27rcByezuwWpQ7SMbQhvBBzWIwSCx+VvA
         S1534zdprI+lbdrQuRyZb55B7FTZLSGQ+2VPqFH0ZaFyg0Vkao/s+Cb8h6AeRSp+iZic
         mdQEOE3yVvHx2KiO6QYrlPvRXZGs2VxD4X0+awkwwqEy1pbcEiAhiCS/SZMpOm/tIDfg
         lrHzL/hNynGtfZgHiQxzbQI97jX1q4IQwILL0/3w0MJxlrQyRwvgEHu2JJVvHp9a88SI
         Y07w==
X-Forwarded-Encrypted: i=1; AL+hErFceH53CaOUqevVXK0TBDRYOJfu6JgBK/0BjWY2iyARqI5hLU9N0DY98nEM+Xtl7qo3gIcTBcHmynub09DGPj4=@vger.kernel.org
X-Gm-Message-State: APuU4Z80RBfF4igqJonyWepmkV9x97XwfqhyjIjdLbZ+o50FLn2Ivjkd
	QyuuZA/yKIpkMEAhCDavoAW4RRA45Td7eFd6oFjVmLFu/+j/8PTaJhRl9XFcrisAYDy00ALcVn2
	4h4IPnkbLyiqd9tUDOhDZ2VHmrr7o/jx/P95cKjPxqurx8x3tpkZK+/PXUyky9XryB7pHed9YiE
	p4l8pFO6ZI8qgIbHdE3BP3L9HQyeHJsULPlf8TnsgHvsclckOaudH2+j3SyrtKJgTqpDQX/bb7l
	FZkJEvkbVP2zHG3YGVBFYpWCNmc
X-Gm-Gg: AZFdTZcPfwqv6hqivG8K0ml5xYwZZTWQtd2u7kQjtB5iB7nLhH+ryRcQN0vwQU/VN7n
	I3Axnll95kbkdsM2rVpAJ1xpSEPtHnNaeF1RNFQjd9YV8MdXQ5oskjtdvTZZZYTnjIvZVXJ5jB4
	yEhH/jTr4Mly4I+KWlZ4Q6aJkgYerLtjQgPGL4HItvUPsvE+V2GnrKLyGOlmzpsBZcoFSfaLtQk
	JbhOyPA3Iou8UEmx2kNztwKgsDc6giwFUjQeB88lg/IcHto/jyN4VRhrXT0boVIty2BNfUGy/13
	SiW89TMT827233WniGwOYGQ4sz03RYI4zakrh7ecH0JMcrk0A9MtJDXoo1Bj1PWwd0cFlFpAxeX
	IX3Gb1HyxBZygnkL7Z4AeAenyCWTKKHcmDv00EIZuv5y82IbIy8y7afRDn47V0SkvuOzqsrMe1n
	dofVryZ27j345WRYw33Jqa30O2GhQu1R4jHa4uuRGJ0ZA=
X-Received: by 2002:a17:90b:4cc1:b0:3ac:aa8d:19eb with SMTP id 98e67ed59e1d1-3b3d0689b5cmr819340a91.3.1794959042483;
        Tue, 17 Nov 2026 15:44:02 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-123.dlp.protect.broadcom.com. [144.49.247.123])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b3d418b418sm180175a91.2.2026.11.17.15.44.01
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Nov 2026 15:44:02 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-920f9885cb1so4300426d6.1
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2026 15:44:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1794959041; x=1795563841; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=chWuGj4JSfuHqV8d6iYVixzJTNnCSogSzx0lpANcwLI=;
        b=fx5C73B50D5pL98mnf/EuUK1aU3XaQQEwC/yr/QKs3NcOr5bllWST48sJUQJd5690z
         3FiAl4iBOYGHkbFpY9pJly+GpsphIndhMkWphfVzVM459bAK+LlV4+KxmIV7q7cZaAuA
         iUZF3BvUrWZfPuwk0tUzGcwrxNm99GPtei+wc=
X-Forwarded-Encrypted: i=1; AL+hErF8xtrnGJtZ0hyHLs+g5GNv/TuTqs4m0bKVFPdMNsPZLbCOiAiaCkI6WUfty54xArqbxIAvPKULEUe+M+UNx5U=@vger.kernel.org
X-Received: by 2002:a05:620a:3710:b0:93f:633b:ee13 with SMTP id af79cd13be357-94999572c59mr220411985a.28.1794959040853;
        Tue, 17 Nov 2026 15:44:00 -0800 (PST)
X-Received: by 2002:a05:620a:3710:b0:93f:633b:ee13 with SMTP id af79cd13be357-94999572c59mr220408585a.28.1794959040114;
        Tue, 17 Nov 2026 15:44:00 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9499b7ccf2fsm43121785a.36.2026.11.17.15.43.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Nov 2026 15:43:59 -0800 (PST)
Message-ID: <5cc0d365-3821-4dab-8015-22cbc94be1e0@broadcom.com>
Date: Tue, 17 Nov 2026 15:43:55 -0800
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
Subject: Re: [PATCH net-next 1/9] net: ethernet: bgmac: validate RX length
 against the DMA packet capacity
To: netdev-bot+sashiko@kernel.org
Cc: netdev@vger.kernel.org, rafal@milecki.pl,
 bcm-kernel-feedback-list@broadcom.com, andrew+netdev@lunn.ch,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org,
 pabeni@redhat.com, robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org,
 horms@kernel.org, corbet@lwn.net, jonas.gorski@gmail.com, olteanv@gmail.com,
 pablo@netfilter.org, fw@strlen.de, phil@nwl.cc, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org
References: <20261116222519.1416501-2-florian.fainelli@broadcom.com>
 <179495815587.3136.10288920701294421777@kernel.org>
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
In-Reply-To: <179495815587.3136.10288920701294421777@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On 11/17/26 15:29, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 0 (1) · Medium: 1 · Low: 1
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [Medium] In bgmac_dma_rx_read()
>    (drivers/net/ethernet/broadcom/bgmac.c:463), the patch now treats…
> - [Low] The commit message is accurate but leaves out the user-visible
>    impact of the bugs this patch fixes in bgmac_dma_rx_read().
> 
> Pre-existing issues:
> - [High] This problem wasn't introduced by this patch, but it is High
>    severity, and the new check does not close it.
> 
> --
> 
> net: ethernet: bgmac: validate RX length against the DMA packet capacity
> 
> This patch changes the upper bound of the RX length check in
> bgmac_dma_rx_read() from BGMAC_RX_ALLOC_SIZE to BGMAC_RX_MAX_FRAME_SIZE.
> It also rejects lengths shorter than ETH_FCS_LEN. Invalid lengths are
> reported through a rate-limited netdev_err() and counted in rx_length_errors
> and rx_errors.
> 
>> BGMAC_RX_ALLOC_SIZE includes skb_shared_info and alignment space beyond
>> the DMA receive buffer. An invalid completion length can pass that check
>> and reach skb_put() with more data than the skb tailroom permits.
>>
>> Limit received frames to BGMAC_RX_MAX_FRAME_SIZE and reject lengths too
>> short for the FCS subtraction.
> 
> [Severity: Low]
> This isn't a bug, but could the commit message state the user-visible
> impact of what is being fixed?
> 
> For len < ETH_FCS_LEN, the u16 subtraction "len -= ETH_FCS_LEN" wraps to
> 65532..65535. The skb_put() that follows then ends in skb_over_panic() and
> BUG().
> 
> Lengths between the skb tailroom limit (about 1602 bytes with
> NET_SKB_PAD=64) and BGMAC_RX_ALLOC_SIZE also reach skb_over_panic().
> 
> Lengths from 1537 up to that tailroom limit got through skb_put(). They
> delivered bytes past the 1536-byte DMA-mapped frame area. Those bytes come
> from the non-zeroed netdev_alloc_frag() buffer, and the device never wrote
> them.
> 
> The message names the tailroom and FCS cases. It does not say that they
> end in a kernel BUG(), and it does not mention the stale data delivery.
> 
>> diff --git a/drivers/net/ethernet/broadcom/bgmac.c b/drivers/net/ethernet/broadcom/bgmac.c
>> index 9ef239bc487d7..1c502bd64d7df 100644
>> --- a/drivers/net/ethernet/broadcom/bgmac.c
>> +++ b/drivers/net/ethernet/broadcom/bgmac.c
>> @@ -457,10 +457,14 @@ static int bgmac_dma_rx_read(struct bgmac *bgmac, struct bgmac_dma_ring *ring,
>>   				break;
>>   			}
>>   
>> -			if (len > BGMAC_RX_ALLOC_SIZE) {
>> +			/* The allocation also contains headroom and skb_shared_info;
>> +			 * only the mapped packet area may be supplied by the DMA.
>> +			 */
>> +			if (unlikely(len > BGMAC_RX_MAX_FRAME_SIZE || len < ETH_FCS_LEN)) {
>>   				if (net_ratelimit())
>> -					netdev_err(bgmac->net_dev, "Found oversized packet at slot %d, DMA issue!\n",
>> -						   ring->start);
>> +					netdev_err(bgmac->net_dev,
>> +						   "Invalid RX length %u at slot %d (flags %#x)\n",
>> +						   len, ring->start, flags);
> 
> [Severity: Medium]
> Does this new bound drop frames that the driver itself tells the MAC to
> accept, and whose MTU it advertises?
> 
> bgmac_chip_init() sets the MAC max frame length to 1550:
> 
> 	bgmac_umac_write(bgmac, UMAC_MAX_FRAME_LEN, 32 + ETHER_MAX_LEN);
> 
> bgmac_change_mtu() sets it to 32 + mtu, which can be as large as 1564:
> 
> 	bgmac_umac_write(bgmac, UMAC_MAX_FRAME_LEN, 32 + mtu);
> 
> bgmac_enet_probe() sets max_mtu without subtracting ETH_HLEN or VLAN_HLEN:
> 
> 	net_dev->max_mtu = BGMAC_RX_MAX_FRAME_SIZE - ETH_FCS_LEN;
> 
> The driver accepts any MTU from 1519 to 1532. At those MTUs a full-sized
> frame can be up to 14 + 1532 + 4 = 1550 bytes. Such a frame is now always
> dropped, logged as an invalid RX length, and counted in rx_length_errors.
> 
> Before this patch these frames were delivered with stale tail bytes, so
> dropping them is safer. However, the new comment and the commit message
> assume that len > BGMAC_RX_MAX_FRAME_SIZE can only come from a DMA error.
> 
> Should max_mtu and/or UMAC_MAX_FRAME_LEN also be clamped to the
> per-descriptor capacity? One option for max_mtu is
> BGMAC_RX_MAX_FRAME_SIZE - ETH_HLEN - ETH_FCS_LEN, possibly minus VLAN_HLEN.
> Could the commit message also mention that these frames are now dropped?
> 
> [Severity: High]
> This is a pre-existing issue, and the new check does not appear to close
> it. Can a remote sender get stale buffer contents delivered as a received
> frame through an overflow-continue slot?
> 
> bgmac_dma_rx_ring_enable() turns on overflow-continue:
> 
> 	ctl |= BGMAC_DMA_RX_OVERFLOW_CONT;
> 
> Each descriptor holds only BGMAC_RX_BUF_SIZE, which is 30 + 1536 bytes.
> The MAC accepts frames up to 1550 bytes by default, and up to 1564 bytes
> after an MTU change.
> 
> With overflow-continue, the DMA64 engine writes the rest of an oversized
> frame as raw data at offset 0 of the next descriptor's buffer. That buffer
> has no RX status header. brcmsmac's dma_rx() drives the same engine with
> the same 0x400 bit, and it handles these continuation buffers explicitly:
> 
> 	resid = len - (di->rxbufsize - di->rxoffset);
> 	...
> 	while ((resid > 0) && (p = _dma_getnextrxp(di, false))) {
> 		pkt_len = min_t(uint, resid, di->rxbufsize);
> 
> bgmac_dma_rx_read() treats every slot as an independent frame. The new
> check drops the first slot when len > 1536. The next slot is then parsed
> as a fresh frame:
> 
> 	len = le16_to_cpu(rx->len);
> 	flags = le16_to_cpu(rx->flags);
> 
> In that slot, rx->len and rx->flags are frame bytes 1536..1539, which the
> sender controls. A value in [4, 1536] passes both the poison check and the
> new bound. build_skb() and skb_put() then deliver up to about 1532 bytes
> starting at buffer offset 30.
> 
> DMA wrote only the first (frame_len - 1536) bytes of that buffer in this
> round, which is at most 28 bytes. The rest is stale netdev_alloc_frag()
> memory, because bgmac_dma_rx_skb_for_slot() only writes the poison header.
> The resulting skb goes to eth_type_trans() and napi_gro_receive(). From
> there it can be processed locally, bridged, or forwarded.
> 
> The old BGMAC_RX_ALLOC_SIZE check let through an even wider range of
> lengths. This patch narrows that range but does not remove it.
> 
> Could multi-descriptor frames be tracked so the continuation slots are
> dropped too? Alternatively, could UMAC_MAX_FRAME_LEN and max_mtu be capped
> at the single-buffer capacity?
> 
>>   				put_page(virt_to_head_page(buf));
>>   				bgmac->net_dev->stats.rx_length_errors++;
>>   				bgmac->net_dev->stats.rx_errors++;
> 

[Medium] RX bound vs. MAC max frame length / max_mtu

Valid. The driver programmed UMAC_MAX_FRAME_LEN to 32 + ETHER_MAX_LEN 
(or 32 + mtu), and max_mtu ignored ETH_HLEN, so the MAC could accept 
frames larger than one RX descriptor can hold, which the new check then
drops. In v2, UMAC_MAX_FRAME_LEN is clamped to BGMAC_RX_MAX_FRAME_SIZE 
and max_mtu becomes BGMAC_RX_MAX_FRAME_SIZE - ETH_HLEN - VLAN_HLEN -
ETH_FCS_LEN (1514). MTUs 1515..1532 are no longer accepted; frames of
that size were already delivered with stale tail bytes. The commit
message now says so.

[High, pre-existing] overflow-continue continuation slots

The analysis is right: with BGMAC_DMA_RX_OVERFLOW_CONT, the tail of an
oversized frame lands at offset 0 of the next descriptor, which has no 
RX header, and was previously parsed as a new frame. Rather than 
tracking multi-descriptor frames, v2 caps the MAC maximum frame length 
at the single-buffer capacity (the clamp above), so oversized frames are 
dropped by the MAC and never spill into a following descriptor.

[Low] commit message

Fixed in v2: it now describes the skb_over_panic()/BUG() cases (len <
ETH_FCS_LEN and len above the tailroom) and the delivery of
uninitialized netdev_alloc_frag() bytes.

pw-bot: cr
-- 
Florian
