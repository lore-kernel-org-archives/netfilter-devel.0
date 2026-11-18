Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.99
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025895;
	b=RxjXO/Hopi834ornQGiWPRwhFYuUlNkJjMB/RoAqZ7WPu/32HWlMYrLt7OZ65CTdSZ/9
	 kJXo80NqQcPfLYC2ww1N/O4K8dAdbJPOW8cGXlLO8ZJkjb5CDhNGhgkCTZMhC0BvTv7CN
	 JjR+un5er9kJL7Pa4f88zvjK0f9PFngFteP0pbPA6O6Df4IYwsfXoZSdmlmWdIYmjfEhJ
	 //Yz3n1toJ5V7tm8afRWzJhaZjxuEBWSs8FsFzfMEwQr9bUEoG/l3JFGOKfErrcQOqsqu
	 6ZXSkPp9tM45Q3MGUt0rPkYWNwvi48KRvdWjtdrVpViYWG7HCZIogaurkX51/sWD8ww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025895;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:X-Relaying-Domain:
	 X-CFilter-Loop:Received:DKIM-Signature:X-Forwarded-Encrypted:
	 X-Received:X-Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:Autocrypt:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-DetectorID-Processed;
	bh=D74oPcMZPYl0Nk/0aq1PThdBgIwifhprYS8bIjTk0hc=;
	b=NczRwPbH8jCc5vIvoQkIjbmedigMn6ohODYkEs3WSFguG2c8JZmP6haIBxRLf3TuleY0
	 OVy0kV2oIt1Hkw461tM57evf+NGkTbNadA6SNNp2jHHQyipXZkPre6ULAJh9aJwfK69ZU
	 zGWtImONNsjmpfiABqGyv23Sksf0MPmBjd/zkTM8wwo8yqIrACTrw0ASw0TQp556nDUoF
	 AeeodoRY9yYBZmGyVuJpltbKSpDGP461oGazZcij+r01HsL2Vfk1HLo6kGF2A4iAr6pox
	 M88Wkh6A8ZJyVH9QIXpYCgkBBxP1vcXToS3QEjbwlIBgoJJgKLxlWdjqEhqDb/2oSww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=FY9622Tp;
	arc=none smtp.remote-ip=209.85.216.99
Received: from mail-pj1-f99.google.com (mail-pj1-f99.google.com [209.85.216.99])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D1F606A332
	for <netfilter-devel@vger.kernel.org>; Wed, 18 Nov 2026 18:18:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A6D1F606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=FY9622Tp
Received: by mail-pj1-f99.google.com with SMTP id 98e67ed59e1d1-3ae2b7e1e17so878591a91.3
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Nov 2026 10:18:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795025894; x=1795630694;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:dkim-signature:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=D74oPcMZPYl0Nk/0aq1PThdBgIwifhprYS8bIjTk0hc=;
        b=BIrAUmkvH0sKnN6ShSiuzE8qHiAmyRXrBRFneVBdknIygfEbSUrtF6MQBGtb5ubZPZ
         sC7nhiiI7pL3KHneZ+s5wvah9HgJEya1LFc2EBcX2PZkCtWR2UjXTvpDr7rgGV2aIfCr
         taSwPmCQPMY97hIuf2wJtzVTY0Zu2kDSqp9JlcUzuMWJlXl6psSK5Y0lx2NHgLFmzYOc
         JnCy2/374XfZVh69eu97UliHhwCwLpkzww6EnW50u/8OSd1dSf+C7T2juGDu0rBj0rh9
         GDDrA36GQcaIHBW4zbSCTl2YLF6raWjWQ0htzVCFBprA3k+m1UfKb56IiJ2VoUeCT5n/
         UZSg==
X-Forwarded-Encrypted: i=1; AL+hErEgrmTjo7aCET8rssd8IoOX6I2v7RFnv29h7czlAFqdUUA4VO85Kg/nKJC3osi6J9tKKCx+h+czGsbIEfUxH3c=@vger.kernel.org
X-Gm-Message-State: APuU4Z87Gr/8zqxsGicey0y+RgD9b+J7vQCos4fmvt+jpiuejOJm2Jik
	uSNkUPGosPcoqrpbNyNgoTauJRahviniMr4ZvvnjAPfZFC796IlfPcFzF00YmIQVIYmZbSFL7Vl
	kUduU9yiaRbVIJJhrhnqM/pi6bbgFyidm0oOsPCPrq/3cZRG0een1svrRpH3I6KnlBykgyeFR98
	RSaDtUcL8ZJzviqPrTdGL7HgblYAO7ySWayyErso71Vxma15VexsmwoYK13G0m7P3F1aAg91VDu
	ZsJ8PZ48MS7QGbuUb/1WIDVSBVk
X-Gm-Gg: AZFdTZdJ6WoyZfrc5fbvEQmBQf8NwcX5pfFIN5UY3BWzsw5smjbKjYuK86EN8MXENzh
	e/PUeFr8TuZlm9x7HMDt09ZPH9FUDXIWRFXwgUQBACMTHVNshZP3fWS/LxlkPDdIrPf7S82pWtV
	ZfOSA50m3xjPPV/459ZUND1fouaaDKGe/pJnWaalDcsyon8tounlR9OUyn+yahcYWG7B8FR8u0p
	8ARAKCWgqPBj8r9ZtXD59dgZD8xxAZsQn383U2jaLf5xyd5XBgtbQDU0EckmgsAx9bdGIlYAyTc
	x26vzdMGrDf7R138oBbubf9Vgjni+nMQs18xry78knZMQXlAaDiBR4tsPTzXSGACoprHPdXjM2P
	AXyBatn59nnf1yc2V2gcOHUSiM1WEGjZE5E9u6k5qyVRZuWaCB39LFc3zm75c9Kazsyp2kNWKl2
	a6uUna4T0ec9MKUGp9fViu1DeldW63LQSQHjDYn4v/
X-Received: by 2002:a17:90b:57cb:b0:3ab:36c4:b502 with SMTP id 98e67ed59e1d1-3b3d0762904mr3129223a91.30.1795025893883;
        Wed, 18 Nov 2026 10:18:13 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-26.dlp.protect.broadcom.com. [144.49.247.26])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b3d4bf2056sm1054192a91.3.2026.11.18.10.18.13
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 10:18:13 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2efdd509c6bso16307865ad.0
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Nov 2026 10:18:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1795025892; x=1795630692; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=D74oPcMZPYl0Nk/0aq1PThdBgIwifhprYS8bIjTk0hc=;
        b=FY9622TpKQoCpBJf4Er8Kny1kqqL0lE5DwpI8SFF+wxpZtkMuby7vyz0XWtKbByc8l
         fAuvTsD0sElGtOZa5nsW/+pY4yTagiRK0o9tBnBW5qyoBZ3/o3IYawqTrEWw+Wo68a2N
         WcWOoRtOnytDDIs9lTehjb9dfVdZAFdyIseiQ=
X-Forwarded-Encrypted: i=1; AL+hErEPQc88eH5aZAwSVADMCKfXClMXbkiGcSKe+JQV3/1LFn0DBH4gTL5rxlSv4A774X7NRQK+doxDX5Nmc8+nnmA=@vger.kernel.org
X-Received: by 2002:a17:903:b46:b0:2ed:edf:4e7b with SMTP id d9443c01a7336-2eff74172d0mr32916735ad.38.1795025891531;
        Wed, 18 Nov 2026 10:18:11 -0800 (PST)
X-Received: by 2002:a17:903:b46:b0:2ed:edf:4e7b with SMTP id d9443c01a7336-2eff74172d0mr32916255ad.38.1795025890809;
        Wed, 18 Nov 2026 10:18:10 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eff62897d0sm17425725ad.64.2026.11.18.10.18.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2026 10:18:10 -0800 (PST)
Message-ID: <9a8fe846-732a-444a-9a41-485f35de5560@broadcom.com>
Date: Wed, 18 Nov 2026 10:18:08 -0800
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
Subject: Re: [PATCH net-next 7/9] net: bgmac: add Northstar IPv4 TCP/UDP NAT
 flowtable offload
To: netdev-bot+sashiko@kernel.org
Cc: netdev@vger.kernel.org, rafal@milecki.pl,
 bcm-kernel-feedback-list@broadcom.com, andrew+netdev@lunn.ch,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org,
 pabeni@redhat.com, robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org,
 horms@kernel.org, corbet@lwn.net, jonas.gorski@gmail.com, olteanv@gmail.com,
 pablo@netfilter.org, fw@strlen.de, phil@nwl.cc, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org
References: <20261116222519.1416501-8-florian.fainelli@broadcom.com>
 <179495816719.3136.15571221759163939828@kernel.org>
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
In-Reply-To: <179495816719.3136.15571221759163939828@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On 11/17/26 15:29, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 11 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 1 · Medium: 7 · Low: 3
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [High] net: bgmac: incomplete TCP flow retirement in fa_insert() and
>    fa_control_match()
> - [Medium] If the optional flow accelerator fails to initialise, the
>    GMAC2 Ethernet probe fails with it.
> - [Medium] Neighbour handling and MTU tracking disable or flush all
>    hardware offload on much broader triggers than the commit message…
> - [Medium] Admission in fa_parse() is limited to exactly two running
>    standalone user ports, because the FA lookup key built by fa_encode()…
> - [Medium] bcm_ns_fa_setup_tc() reads and modifies fa->block_list without
>    any driver-wide lock: the list_empty() single-flowtable -EBUSY check,…
> - [Medium] Both the GMAC2 miss path (bcm_ns_fa_rx) and the GMAC0
>    exception path (fa_control_receive) call fa_receive_tcp_control().
> - [Medium] Suspend does not take the FA out of service, and resume does
>    not restore it.
> - [Medium] net: bgmac: untracked neighbours in fa_route_check() and
>    eviction in fa_netevent()
> - [Low] The rule that only GMAC2 carries the accelerator is enforced only
>    in bgmac-bcma.c (bgmac_probe rejects brcm,flow-accelerator when…
> - [Low] The comment above fa_mtu_route_update() in bcm-ns-fa.c says 'All
>    accesses, including the registration retry reset, hold learn_lock.'…
> - [Low] The debugfs files 'fa' (fa_debug_show) and 'fa_table'
>    (fa_table_show) print entry->cookie with %#lx.
> 
> --
> 
> net: bgmac: add Northstar IPv4 TCP/UDP NAT flowtable offload
> 
> This adds a driver for the BCM4708/BCM5301X inline flow accelerator. It
> exposes the accelerator through TC_SETUP_FT on GMAC2 and installs exact
> IPv4 TCP/UDP SNAT/DNAT rules using hashes learned from miss metadata.
> Hardware owners are retired on FIB, neighbour and topology changes, GMAC2
> is quiesced around indirect table accesses, and debugfs status and fault
> injection are provided.
> 
>> diff --git a/drivers/net/ethernet/broadcom/bcm-ns-fa.c b/drivers/net/ethernet/broadcom/bcm-ns-fa.c
>> new file mode 100644
>> index 0000000000000..8665ba94cbab6
>> --- /dev/null
>> +++ b/drivers/net/ethernet/broadcom/bcm-ns-fa.c
>> @@ -0,0 +1,1897 @@
> 
> [ ... ]
> 
>> +static bool fa_receive_tcp_control(struct bcm_ns_fa *fa, const struct iphdr *ip,
>> +				   unsigned int total, unsigned int linear,
>> +				   unsigned int port)
>> +{
>> +	struct fa_tuple tuple;
>> +	const struct tcphdr *tcp;
>> +
>> +	tuple.src = get_unaligned(&ip->saddr);
>> +	tuple.dst = get_unaligned(&ip->daddr);
>> +	if (ip->ihl != 5 || (ip->frag_off & htons(IP_MF | IP_OFFSET))) {
>> +		fa_tcp_control(fa, &tuple, port, false);
>> +		return true;
>> +	}
> 
> [Severity: Medium]
> Can one spoofed packet tear down every offloaded TCP flow to a peer here?
> 
> Both bcm_ns_fa_rx() and fa_control_receive() pass IPv4 TCP packets to this
> function. Any such packet with IP options or fragmentation bits set
> reaches fa_tcp_control() with ports_valid == false. In that case
> fa_control_match() compares only the addresses:
> 
>      size_t len = ports_valid ? sizeof(*tuple) : offsetof(struct fa_tuple, sport);
> 
> As a result, every TCP entry between that address pair on that ingress
> port gets FA_FLOW_CLOSING. fa_tcp_control() also sets control_pending,
> gates lookups globally through fa_lookup_update(), and queues
> control_work. That work uninstalls the matched entries and their reverse
> entries, and pauses GMAC2 for each table access.
> 
> The sender needs only the IP pair and a valid IP header checksum, not the
> ports. The B53 CFP trap rules exclude fragments, but the default IPv4 rule
> passes router-MAC traffic inline, so a WAN sender can reach this path.
> 
> The software flowtable sends fragments to the slow path and does not tear
> the flow down. Is this port-wildcard teardown intended? The commit message
> only says "TCP control packets retire both NAT directions".
> 
> [ ... ]
> 
>> +/* FIB notifications identify the preferred alias for each table/prefix.
>> + * Retain only low-MTU prefixes, rather than dumping the FIB after changes.
>> + * All accesses, including the registration retry reset, hold learn_lock.
>> + */
>> +static void fa_mtu_route_update(struct bcm_ns_fa *fa, unsigned long event,
>> +				const struct fib_entry_notifier_info *info)
>> +{
> 
> [Severity: Low]
> Is this comment accurate? fa_replace() reads route_mtu_ok while holding
> only fa->lock:
> 
>      if (!cls->invalidate || !cls->validate || !fa->enabled ||
>          !READ_ONCE(fa->route_mtu_ok) ||
> 
> fa_debug_show() also reads route_mtu_ok, nr_mtu_routes and
> mtu_tracking_failed without learn_lock. The writers use plain stores under
> learn_lock rather than WRITE_ONCE(), so KCSAN will report these as data
> races.
> 
> Admission still looks correct, because fa_insert() rechecks the
> generation and control_pending under learn_lock. Could the comment be
> updated to describe the lockless reads, and the writers be annotated to
> match?
> 
> [ ... ]
> 
>> +static int fa_netevent(struct notifier_block *nb, unsigned long event, void *ptr)
>> +{
> 
> [ ... ]
> 
>> +	spin_lock_bh(&fa->learn_lock);
>> +	for (i = 0; i < ARRAY_SIZE(fa->neighbours); i++) {
>> +		struct fa_neighbour *candidate = &fa->neighbours[i];
>> +
>> +		if (candidate->valid && candidate->ifindex == neighbour->dev->ifindex &&
>> +		    candidate->address == address) {
>> +			cached = candidate;
>> +			invalidate = !(state & NUD_VALID) || memcmp(candidate->mac, mac, ETH_ALEN);
>> +			break;
>> +		}
>> +	}
>> +	if (!cached) {
>> +		cached = &fa->neighbours[fa->neighbour_next++ % FA_NEXTHOPS];
>> +		invalidate = cached->valid || !(state & NUD_VALID) || !list_empty(&fa->entries);
>> +	}
> 
> [Severity: High]
> Can the reply direction of a TCP flow stay installed in hardware after
> the connection has been closed?
> 
> fa_insert() publishes the new entry on fa->entries before it calls
> fa_write(). entry->reverse and other->reverse are linked only after
> fa_write() returns. fa_write() goes through fa_table_begin(), which
> pauses GMAC2 and sleeps in fsleep(). Meanwhile GMAC0 keeps delivering
> trapped TCP control packets to fa_control_receive().
> 
> flow_offload_rule_add() installs the original direction first and the
> reply direction second. Suppose a FIN or RST for the original direction
> arrives on GMAC0 while the reply entry is still inside fa_write().
> fa_tcp_control() matches only the original entry, because
> fa_control_match() compares entry->in_port and entry->tuple. It sets
> FA_FLOW_CLOSING on that entry and queues control_work, which then
> blocks on fa->lock.
> 
> When fa_write() returns, the reverse-linking loop skips the peer
> because FA_FLOW_CLOSING is already set. Neither side gets a reverse
> pointer. fa_control_work() then uninstalls only the original entry,
> clears control_pending and re-enables lookup in fa_lookup_update().
> The reply entry stays valid in the hardware table until the flowtable
> sends FLOW_CLS_DESTROY.
> 
> The same skip also lets a reply entry be installed when its peer has
> already been retired and is only waiting for FLOW_CLS_DESTROY.
> 
> A third case needs no race. flow_offload_rule_add() treats one
> successful direction as success. A TCP flow can therefore be installed
> with entry->reverse == NULL, for example when the reply hash was never
> learned or its bucket is full. A FIN or RST in the reply direction
> arrives on entry->out_port and carries entry->reply.
> fa_control_match() never compares either field, so nothing retires the
> installed direction.
> 
> This contradicts the commit message, which says "TCP control packets
> retire both NAT directions before tuple reuse". Until the entry is
> destroyed, later packets on a reused tuple could be translated and
> forwarded by stale hardware state without passing through conntrack.
> 
> Should fa_control_match() also match entry->reply on entry->out_port?
> And when fa_insert() finds its peer with FA_FLOW_CLOSING set, should it
> retire or abort the new entry instead of skipping the peer?
> 
> [Severity: Medium]
> Does this flush all hardware flows even for neighbours that are not the
> next hop of any installed flow?
> 
> For an IPv4 NETEVENT_NEIGH_UPDATE on an FA port, fa_invalidate() runs in
> three cases:
> 
> - the neighbour is not cached and any entry exists
> - a cached neighbour leaves NUD_VALID
> - the ring wraps over a valid slot
> 
> None of these checks whether the neighbour is the next hop of an
> installed flow. So the first ARP resolution of a new LAN host, or ARP
> failing for a non-existent LAN address, retires every entry. It also sets
> control_pending until control_work runs.
> 
> fa_mtu_route_update() has a similar global effect:
> 
>      fa->route_mtu_ok = !fa->nr_mtu_routes && !fa->mtu_tracking_failed;
> 
> A single low-MTU prefix in any table, for any destination, gates lookup
> in fa_lookup_update() and makes fa_replace() reject every rule.
> 
> mtu_tracking_failed is also cleared only in fa_fib_reset(). One GFP_ATOMIC
> failure, or more than FA_MTU_ROUTES_MAX prefixes, disables offload until
> reprobe, even after those routes are deleted.
> 
> The commit message describes retiring owners on changes "that withdraw
> their hardware paths" and tracking low-MTU prefixes. Are these wider
> triggers intended? If so, could they be narrowed or documented?
> 
> [ ... ]
> 
>> +	switch (block->command) {
>> +	case FLOW_BLOCK_BIND:
>> +		cb = flow_block_cb_lookup(block->block, fa_block_cb, fa);
>> +		if (cb) {
>> +			flow_block_cb_incref(cb);
>> +			return 0;
>> +		}
>> +		/* Different flowtables have independent cookies and policy. The
>> +		 * hardware cannot partition tables by ingress port or netns.
>> +		 */
>> +		if (!list_empty(&fa->block_list))
>> +			return -EBUSY;
>> +		cb = flow_block_cb_alloc(fa_block_cb, fa, fa, NULL);
>> +		if (IS_ERR(cb))
>> +			return PTR_ERR(cb);
>> +		flow_block_cb_incref(cb);
>> +		flow_block_cb_add(cb, block);
>> +		list_add_tail(&cb->driver_list, &fa->block_list);
>> +		return 0;
>> +	case FLOW_BLOCK_UNBIND:
>> +		cb = flow_block_cb_lookup(block->block, fa_block_cb, fa);
>> +		if (!cb)
>> +			return -ENOENT;
>> +		bcm_ns_fa_flush(fa);
>> +		if (!flow_block_cb_decref(cb)) {
>> +			flow_block_cb_remove(cb, block);
>> +			list_del(&cb->driver_list);
>> +		}
>> +		return 0;
> 
> [Severity: Medium]
> What serializes fa->block_list across different flowtables?
> 
> The struct comment says fa->lock protects flow blocks, but this path does
> not take it. Around ndo_setup_tc, nf_flow_table_offload_cmd() holds only
> that flowtable's own flow_block_lock:
> 
>      down_write(&flowtable->flow_block_lock);
>      err = dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_FT, bo);
>      up_write(&flowtable->flow_block_lock);
> 
> DSA user ports can be moved to another netns. dsa_user_setup_ft_block()
> sends every user port's bind to the same conduit, and so to the same
> struct bcm_ns_fa. Two flowtables in different namespaces could both see
> list_empty() as true and both call list_add_tail() on fa->block_list. A
> bind could also race with list_del() from an unbind in the other
> namespace.
> 
> Can this corrupt fa->block_list and bind two flowtables to one hardware
> table?
> 
> [ ... ]
> 
>> +static int fa_netdev_event(struct notifier_block *nb, unsigned long event, void *ptr)
>> +{
>> +	struct bcm_ns_fa *fa = container_of(nb, struct bcm_ns_fa, netdev_nb);
>> +	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
>> +
>> +	/* New active ports or upper devices change the lookup domain. Flush
>> +	 * synchronously before the new topology becomes usable.
>> +	 */
>> +	if (event != NETDEV_GOING_DOWN && event != NETDEV_DOWN &&
>> +	    event != NETDEV_PRE_CHANGEADDR &&
>> +	    event != NETDEV_CHANGEADDR &&
>> +	    event != NETDEV_CHANGE &&
>> +	    event != NETDEV_CHANGEMTU &&
>> +	    event != NETDEV_PRECHANGEUPPER && event != NETDEV_CHANGEUPPER &&
>> +	    event != NETDEV_UP && event != NETDEV_UNREGISTER)
>> +		return NOTIFY_DONE;
> 
> [Severity: Medium]
> Is the next-hop neighbour of an admitted flow guaranteed to be in
> fa->neighbours[]?
> 
> fa_route_check() looks up and validates the next-hop neighbour, but
> neither it nor fa_insert() records it. fa->neighbours[] is filled only
> by fa_netevent(), and only for NETEVENT_NEIGH_UPDATE events that arrive
> while fa_port() is true for the device. fa_neighbour_activity() probes
> only neighbours that are in this cache and whose MAC matches a
> referenced fa->nh[] entry.
> 
> The cache is a 128-slot ring. Every update for an address that is not
> already cached takes the next slot. That includes NUD_INCOMPLETE and
> NUD_FAILED transitions, which are stored with valid set. An ARP scan
> of the LAN, or more than 128 active hosts, can therefore evict the next
> hop of an installed flow.
> 
> After that, the neighbour is never passed to neigh_event_send(). It
> stays NUD_STALE while all its traffic is forwarded in hardware. If the
> peer's MAC changes without a gratuitous ARP, the hardware keeps sending
> to the old address. This defeats the commit message's "Drive neighbour
> probes from hardware counter activity".
> 
> There is also a race on the first flow. For an uncached neighbour,
> fa_netevent() invalidates only in three cases:
> 
> - the reused slot had valid set
> - the new state is not NUD_VALID
> - fa->entries is not empty
> 
> Suppose the first flow has passed fa_route_check() and
> fa_learn_lookup(), but fa_insert() is still sleeping in fa_mac_get()
> before list_add_rcu(). fa->entries is still empty at that point. A
> NUD_VALID update that changes the MAC then does not invalidate. It
> also leaves control_generation and invalidate_generation unchanged, so
> the generation check in fa_insert() passes. The old MAC from rule->eth
> is written to the next-hop table.
> 
> Could fa_insert() record the admitted neighbour in fa->neighbours[]?
> Alternatively, could fa_neighbour_activity() look up neighbours from
> the installed entries rather than the ring? Separately, should the
> uncached case in fa_netevent() invalidate whenever an insertion may be
> in flight?
> 
> [Severity: Medium]
> Is NETDEV_UP early enough to flush before a third port becomes usable?
> 
> fa_parse() admits rules only while exactly two user ports are running,
> because the lookup key built by fa_encode() has no ingress port or VLAN.
> When a third port is opened, __dev_open() calls ndo_open first:
> 
>      dsa_user_open()
>        dsa_port_enable_rt()
>          ds->ops->port_enable()
>          phylink_start()
> 
> NETDEV_UP is sent only after that. The B53 notifier installs the per-port
> router-MAC allow rule at NETDEV_REGISTER, so IPv4 frames from the new
> port can already reach the inline FA.
> 
> In that window, a frame could arrive on the new port with a pool router
> MAC as DA and a tuple matching an installed entry. Could it be NATed and
> forwarded in hardware, bypassing that port's ingress policy? Would
> handling NETDEV_PRE_UP here close the window?
> 
> [ ... ]
> 
>> +		seq_printf(s, "%u %#lx %s %s %u\n", i, entry->cookie,
>> +			   entry->in->name, entry->out->name, hits);
> 
> [Severity: Low]
> Does this print a raw kernel heap address? The cookie comes from
> nf_flow_offload_init():
> 
>      cls_flow->cookie = (unsigned long)tuple;
> 
> Printing it with %#lx bypasses %p hashing and kptr_restrict.
> fa_table_show() prints the cookie the same way. Could both use %p or drop
> the cookie?
> 
> [ ... ]
> 
>> diff --git a/drivers/net/ethernet/broadcom/bgmac-bcma.c b/drivers/net/ethernet/broadcom/bgmac-bcma.c
>> index 36f9bad28e6a9..87338e01a825b 100644
>> --- a/drivers/net/ethernet/broadcom/bgmac-bcma.c
>> +++ b/drivers/net/ethernet/broadcom/bgmac-bcma.c
> 
> [ ... ]
> 
>> @@ -130,6 +131,10 @@ static int bgmac_probe(struct bcma_device *core)
>>   	const u8 *mac;
>>   	int err;
>>   
>> +	if (of_property_present(core->dev.of_node, "brcm,flow-accelerator") &&
>> +	    core->core_unit != 2)
>> +		return -EINVAL;
>> +
>>   	bgmac = bgmac_alloc(&core->dev);
>>   	if (!bgmac)
>>   		return -ENOMEM;
> 
> [Severity: Low]
> The GMAC2-only rule is enforced only here. bcm_ns_fa_init() is called
> from the shared bgmac_enet_probe(), which bgmac-platform.c also uses, and
> bgmac-platform has no equivalent check. Is platform support intended?
> 
> The new bcm_ns_fa_flush() call in bgmac_enet_suspend() can only be
> reached through bgmac-platform's dev_pm_ops, because bgmac_bcma_driver has
> no PM callbacks. On the BCMA configurations the binding allows, that hook
> is dead code. bgmac_enet_resume() also never redoes the FA setup from
> bcm_ns_fa_init().
> 
> The Kconfig change also adds this to BGMAC_PLATFORM:
> 
>      depends on BCM_NS_FA || !BCM_NS_FA
> 
> If platform support is intended, should it get the GMAC2 check and a
> resume reinit? If not, should the suspend hook and the Kconfig coupling
> be dropped?
> 
>> diff --git a/drivers/net/ethernet/broadcom/bgmac.c b/drivers/net/ethernet/broadcom/bgmac.c
>> index 1c502bd64d7df..527f9842eb833 100644
>> --- a/drivers/net/ethernet/broadcom/bgmac.c
>> +++ b/drivers/net/ethernet/broadcom/bgmac.c
> 
> [ ... ]
> 
>> @@ -1560,6 +1579,17 @@ int bgmac_enet_probe(struct bgmac *bgmac)
>>   	net_dev->hw_features = net_dev->features;
>>   	net_dev->vlan_features = net_dev->features;
>>   
>> +	bgmac->fa = bcm_ns_fa_init(net_dev);
>> +	if (IS_ERR(bgmac->fa)) {
>> +		err = PTR_ERR(bgmac->fa);
>> +		bgmac->fa = NULL;
>> +		goto err_phy_disconnect;
>> +	}
>> +	if (bgmac->fa) {
>> +		net_dev->features |= NETIF_F_HW_TC;
>> +		net_dev->hw_features |= NETIF_F_HW_TC;
>> +	}
>> +
> 
> [Severity: Medium]
> Should a failure in the optional accelerator take down the whole GMAC2
> interface?
> 
> bcm_ns_fa_init() returns ERR_PTR in many cases:
> 
> - the compatible does not match
> - resource or ioremap errors
> - the FA_STATUS init-done poll times out
> - a pool-table fa_write() fails
> - a notifier fails to register (register_fib_notifier() can return
>    -EBUSY)
> - devm_add_action_or_reset() fails
> 
> Each of these skips register_netdev() here. With CONFIG_BCM_NS_FA=n the
> same DT probes fine, and runtime table failures fall back to software.
> 
> Could this warn and continue with bgmac->fa = NULL, at least for the
> hardware and transient errors? The commit message does not mention this
> new probe dependency.
> 
> [ ... ]
> 
>> @@ -1610,6 +1640,7 @@ int bgmac_enet_suspend(struct bgmac *bgmac)
>>   	netif_tx_unlock(bgmac->net_dev);
>>   
>>   	bgmac_chip_intrs_off(bgmac);
>> +	bcm_ns_fa_flush(bgmac->fa);
>>   	bgmac_chip_reset(bgmac);
>>   	bgmac_dma_cleanup(bgmac);
>>   
> 
> [Severity: Medium]
> This flushes the entries, but fa->enabled stays set, lookups are not
> gated, and netif_running() is still true. What happens when the table is
> accessed after bgmac_chip_reset()?
> 
> A later FLOW_CLS_REPLACE, or a read of the fa or fa_table debugfs files,
> goes through fa_table_begin(). That rewrites BGMAC_DEV_CTL and polls the
> MAC that has just been reset:
> 
>      err = read_poll_timeout(bgmac_read, val, val & BGMAC_DS_PO, 1, 1000,
>                              false, bgmac, BGMAC_DEV_STATUS);
> 
> If that poll times out, fa_fail() latches fa->failed until reprobe.
> 
> bgmac_enet_resume() also does not reprogram the setup done in
> bcm_ns_fa_init(): FA_CTL, FA_BRCM_HDR, FA_L2_SKIP, FA_L2_TAG, FA_IPV4,
> FA_NAPT and the pool clear. If those registers are lost across suspend,
> would the driver keep publishing entries to an FA whose configuration no
> longer matches its state? This path can only be reached through
> bgmac-platform's PM ops.
> 

[High] incomplete TCP flow retirement

Agreed. v2 matches control packets against both directions of an entry 
(each on its own ingress port), and when a direction is inserted while 
its peer is already being retired the new entry is retired too.

[Medium] wildcard teardown for IP options/fragments

Not intended. v2 uses the exact ports, found with ihl, and leaves
non-first fragments and unparseable headers to the slow path, as the 
software flowtable does.

[Medium] setup_tc locking, other netns

Agreed: block_list is now protected by fa->lock and only the initial 
namespace can bind.

[Medium] neighbours / first-flow race / NETDEV_UP

v2 probes the next hop of every installed entry instead of the cache of 
updates, checks the neighbour again once an entry is published, and 
flushes on NETDEV_PRE_UP.

[Medium] probe failure, broad invalidations, suspend

The accelerator is inline in the data path and the tag format depends on 
its configuration, hence the probe failure; this is now in the commit 
message together with the broad invalidation triggers. Suspend/resume is 
not supported (BCMA has no PM callbacks) and the unreachable flush is
removed.

[Low] list_del_rcu locking, comments, debugfs cookie, GMAC2 check

Fixed in v2, except for the check in the platform driver: bgmac-platform 
has no brcm,flow-accelerator property, so FA does not initialize there.

The fixed PHY leak is pre-existing and unrelated, I will send a separate 
patch.

pw-bot: cr
-- 
Florian
