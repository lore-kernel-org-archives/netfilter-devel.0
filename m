Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.161.99
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025291;
	b=BA9493xCjohxzGBM8CiiibnKMd2OKlzN6e5X8TMxfiRkQ4u01zaCyatP0z89FLpRlATD
	 AQrUpMkQLjueAuoeDWvdD1noSw04td5CGNU3KusheAo3SecTR8rBhZdg/yDSjSdHYXrUV
	 21vSDHDgPj1gNfOGrKW2rHpNnRnkpuT41BIJHys640qpfSHIoOF9NtFHPXaZLMHz71Svj
	 jVgGUksuYctMgLl7NJnL7htXK2Svxc2vCdIJziSW5K4yhwuiw3K2cnEqDpnJEveXZOBId
	 /zZA2bsAsZSbPH0sYSrOj7tZUiN3w0fa+IJdM6K43+l2UQJXWFnysxyD1+DdtR3cuXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025291;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:X-Relaying-Domain:
	 X-CFilter-Loop:Received:DKIM-Signature:X-Forwarded-Encrypted:
	 X-Received:X-Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:Autocrypt:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-DetectorID-Processed;
	bh=dsobvnNoDG7lN5QypHHGC6puRklHA82pKzkACgQqM1Q=;
	b=cwYuvGD3PxG6bcOeX240AHqzkghQwexa1FChUZKZfqVN6cTbha8BQ9KZRcUnkCHzjChH
	 1/Bqu9iF7MzyhT0Gyf+jRyt4HIUnYMFlfE0GowX23UdmJNKQYQBgbBOeRb7uOkwuZf37R
	 TllQOt7IwuDp895KvqbeO7ytGC0w+2431j3JDjl3aMHnvmWkYuy7/aIX8UNzs+ikHu7iK
	 YeZEzCG5x1UfrMyi4digy/No9lrA5DsWPRy3V68rMGwPcnmxKYrjoxx/wptC+1R1yOTXM
	 TF8PBMHhZO469Z5N5iEKiMdI1FM4VvYgicXlv3fUbMHK/Z5OA64wQyd41+NKI1RwIKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=M7tM6rUj;
	arc=none smtp.remote-ip=209.85.161.99
Received: from mail-oo1-f99.google.com (mail-oo1-f99.google.com [209.85.161.99])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F4AA606A325
	for <netfilter-devel@vger.kernel.org>; Wed, 18 Nov 2026 18:08:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8F4AA606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=M7tM6rUj
Received: by mail-oo1-f99.google.com with SMTP id 006d021491bc7-6e560e00a86so833560eaf.1
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Nov 2026 10:08:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795025288; x=1795630088;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:dkim-signature:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=dsobvnNoDG7lN5QypHHGC6puRklHA82pKzkACgQqM1Q=;
        b=L3LwQobRc9WjLhN4l5lZ04Tw5Cj1+VOrgwBGvQ9Feh/+DkwHf0ilWTCRjivbDO5m8W
         Hn9JP+lZlF/AJFUjVBoAtPjXamNEoRLg/sBJm8IMGViXsodvhe4Qdv921I1M3ztps0J2
         CHcwmawef6mupzkH+gkeFePeMZsyDJ965g023Fd21W9EXGgfWbBl4cR1eDF8+MBVPfrX
         KK/kHrqSkW8I8/0OcIY6ubrGJlw+trd3497iSlV1g3VzrypD0eoMJr1Iv0Soed/Ln5q8
         IpDt2ZMrNT1hErIKOvND+lHQ6FC/19hrDYpqELi7TI7KvdMPodW7CdnpRn0Tpw7IYKOZ
         CCew==
X-Forwarded-Encrypted: i=1; AL+hErFgbAawfyd5D6Y51ap/sy/eyulSo1Ok6QH3UPAnbfO+sWomMOqKAf8Er+47TAQon04xIHcEr6bxtIRSCBV7UUE=@vger.kernel.org
X-Gm-Message-State: APuU4Z9CUVsvX/dUHCJKR/wbsFpuayg27Bh55zNeODUbZhaE4rzB0d5h
	splXlGPiEAbuljXNqdzWfcKAa+iiXj2lc3+9C6uwGs30e653EUrLvk9koj0RGCWbXVFxMhwLyls
	kzxee4z1CkQDsgUK00FqbiOQ2LkJdM+EocTYngORear6F1cT2iRggD4mXMgknFVs2FhQj86EZ53
	wo011n6AyR4Bff6uOFRuvZ6vMFwGc1NXVheFUKzV8cfnFEc9W9LHLFHQgzUrlBqpDHsfOkJpovN
	0LD3El3eIoyFzqKC/Jv+0R/zwLi
X-Gm-Gg: AYBFou1dXWRyH4lW6RruRZBsLUwEwwQId7nI1G+DZpFdiXX2QsMUz5Upsr8+JajXv4z
	UdkH8vcI1yMWOyIu9SLbVk98KUZK4MvpZPynKhxL1/jJ+QMrgwk25rwgb3pQRQtodYO43UBBXsJ
	+hTJMSG4koTytrklx0rnUmyk3Ggi96M08ueCXZiayzOGG7ZbvDeoSqEyBMLTxQJmMOBBmvnWC7u
	6eyZM0vGCk3PJMbQ7l+L1NLifZiuxzn0EDvmn+VnBEWoPOaN7RwrWron/spqv2Z5EZBz77pfz4G
	jZV9OADbRnzXO2Wca/16vxOsChAzY8Bybclq6S6cf0LI9WSl2KUGZA5Gg/gmQUa5DgPWFngw6Lw
	AOAO+0CMs3s7Qbnt02nzv+iEg1+8zcoL8PE7mP5ZFT7HVy8yYiYIvu/b5LGdJRs6+mXPmRa9oqL
	OSMWfZcYxujpFIBUYgiYyP2iVFPOcj+DYLP3alZBU3
X-Received: by 2002:a05:6820:3402:20b0:71a:cdb1:2f9 with SMTP id 006d021491bc7-71b185c11femr1756412eaf.67.1795025288145;
        Wed, 18 Nov 2026 10:08:08 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-28.dlp.protect.broadcom.com. [144.49.247.28])
        by smtp-relay.gmail.com with ESMTPS id 586e51a60fabf-4b745d03ff2sm32339fac.18.2026.11.18.10.08.06
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 10:08:08 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-920f9885cb1so18352166d6.1
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Nov 2026 10:08:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1795025286; x=1795630086; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dsobvnNoDG7lN5QypHHGC6puRklHA82pKzkACgQqM1Q=;
        b=M7tM6rUjngbFL4JBWlDzM6Z9+fabUALTl8USFtmsafxs3AAmWjs4kpRI9Lcifa0ncW
         I0GV9P4QrqByTbqahJ4N3sfHoEHPhaiENULfBjVY60qv7+mZL+XK86RxYqUct9Mk95LL
         x03P/kiI3uKKA2fXpV+r+UVt5+CMdndIynUF0=
X-Forwarded-Encrypted: i=1; AL+hErFdMHHJlP75l8/uERzWv4jTenPC3pqbqrcg/o78cL7J9XD0+F7DphBK1loeOVB9m+qP2TOdCkLsRQoF+IKkkqk=@vger.kernel.org
X-Received: by 2002:a05:6214:5706:b0:91e:c720:170b with SMTP id 6a1803df08f44-92114f1d3d5mr51994546d6.32.1795025285688;
        Wed, 18 Nov 2026 10:08:05 -0800 (PST)
X-Received: by 2002:a05:6214:5706:b0:91e:c720:170b with SMTP id 6a1803df08f44-92114f1d3d5mr51993456d6.32.1795025284787;
        Wed, 18 Nov 2026 10:08:04 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-92114dbef06sm27221816d6.45.2026.11.18.10.08.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2026 10:08:04 -0800 (PST)
Message-ID: <8d3562e8-028c-4229-b25f-463385cd0736@broadcom.com>
Date: Wed, 18 Nov 2026 10:08:00 -0800
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
Subject: Re: [PATCH net-next 5/9] net: dsa: add Broadcom FA metadata and IPv4
 exception paths
To: netdev-bot+sashiko@kernel.org
Cc: netdev@vger.kernel.org, rafal@milecki.pl,
 bcm-kernel-feedback-list@broadcom.com, andrew+netdev@lunn.ch,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org,
 pabeni@redhat.com, robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org,
 horms@kernel.org, corbet@lwn.net, jonas.gorski@gmail.com, olteanv@gmail.com,
 pablo@netfilter.org, fw@strlen.de, phil@nwl.cc, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org
References: <20261116222519.1416501-6-florian.fainelli@broadcom.com>
 <179495816343.3136.8938496694323714432@kernel.org>
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
In-Reply-To: <179495816343.3136.8938496694323714432@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On 11/17/26 15:29, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 13 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 1 · Medium: 7 · Low: 5
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [High] Bridged ports lose every FA exception guard while their CPU-
>    bound traffic still passes through the inline FA.
> - [Medium] When FA is enabled, b53_setup_port() and b53_br_leave() put
>    standalone user ports in EAP_MODE_BASIC instead of EAP_MODE_SIMPLIFIED.
> - [Medium] On NETDEV_PRE_CHANGEADDR, b53_fa_netdev_event() writes an all-
>    zero TCAM entry over the port's router-MAC allow rule…
> - [Medium] If b53_fa_port(dev, port, true) fails in b53_br_leave(), the
>    code logs an error and calls b53_disable_port(), which only sets the…
> - [Medium] The TCP SYN/FIN/RST trap rules 0-2 in b53_fa_setup() include
>    CFP_TCAM6_IP_FRAGMENT in the mask with data 0, so they match only…
> - [Medium] The commit says it 'keep[s] ordinary data flooding off the
>    auxiliary CPU'.
> - [Medium] net: dsa: b53: missing CPU port 5 in non-default VLANs in
>    b53_vlan_add()
> - [Medium] net: dsa: tag_brcm: brcm_tag_rcv_ll() reads prepended tag as
>    MAC DA
> - [Low] The B53 CFP action and meter RAM programming differs from the
>    reference programming of the same register block.
> - [Low] b53_uses_fa_tag() does not follow the DT binding's compatible
>    list.
> - [Low] The NET_DSA_TAG_BRCM_FA help text says 'Transmit uses the
>    ordinary prepended Broadcom tag' and 'Enable this for a B53 switch…
> - [Low] Plain bool FA state flags are read and written concurrently
>    without a common lock or READ_ONCE/WRITE_ONCE.
> - [Low] net: dsa: b53: duplicate CFP rule programming in b53_fa_setup()
> 
> --
> 
> net: dsa: add Broadcom FA metadata and IPv4 exception paths
> 
> This patch adds a brcm-fa DSA tagger for the Northstar flow accelerator
> miss descriptor. It also adds B53 CFP rules that send TCP SYN/FIN/RST,
> TTL 0/1, packets longer than 1500 bytes and non-router-MAC IPv4 traffic
> to port 5/GMAC0, outside the FA. A netdevice notifier and an RCU-protected
> backend registry in tag_brcm.c coordinate guard and conduit readiness.
> 
>> diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
>> index b7aff5e238e85..3e8c9679836d3 100644
>> --- a/drivers/net/dsa/b53/b53_common.c
>> +++ b/drivers/net/dsa/b53/b53_common.c
> 
> [ ... ]
> 
>> @@ -678,7 +685,8 @@ int b53_setup_port(struct dsa_switch *ds, int port)
>>   	 * dropping frames because it isn't allowed to forward there.
>>   	 */
>>   	if (dsa_is_user_port(ds, port))
>> -		b53_set_eap_mode(dev, port, EAP_MODE_SIMPLIFIED);
>> +		b53_set_eap_mode(dev, port, dev->fa_cfp_enabled ? EAP_MODE_BASIC :
>> +			 EAP_MODE_SIMPLIFIED);
> 
> [Severity: Medium]
> On FA boards, standalone user ports now get EAP_MODE_BASIC. Does that
> bring back the problem fixed by commit 4227ea91e2657f ("net: dsa: b53:
> prevent standalone from trying to forward to other ports")?
> 
> That commit uses EAP_MODE_SIMPLIFIED to send all standalone-port traffic
> to the CPU. In BASIC mode, a frame that no CFP trap redirects goes through
> normal ARL forwarding. That covers non-IPv4 traffic such as ARP and IPv6.
> It also covers IPv4 frames that hit the allow rules, which have no action.
> 
> Suppose the DA was learned on a VLAN-unaware bridged port with learning
> on (shared PVID 0). The ARL forwards the frame to that port, the PVLAN
> mask blocks it, and the frame is dropped instead of reaching Linux.
> 
> b53_br_leave() makes the same change, so ports leaving a bridge are hit
> too. Two comments no longer match the code: "Force all traffic to go to
> the CPU port" above this call, and "Enable redirection of unknown SA to
> the CPU port" in b53_br_leave(). The commit message does not mention this
> change either.
> 
> [ ... ]
> 
>> @@ -1326,6 +1336,315 @@ int b53_setup_devlink_resources(struct dsa_switch *ds)
> 
> [ ... ]
> 
>> +static int b53_fa_rule(struct b53_device *dev, unsigned int index,
>> +		       const u32 data[8], const u32 mask[8], bool trap)
>> +{
> 
> [Severity: Low]
> This isn't a bug, but the TCP flag loop open-codes what b53_fa_rule()
> does with trap set:
> 
>    - the eight DATA/MASK writes
>    - both action words and the action commit
>    - the meter writes and the meter commit
>    - the TCAM commit
> 
> Could this loop just build data and mask and then call
> b53_fa_rule(dev, rule, data, mask, true)? With two copies, any change
> to the action or meter programming has to be made twice, and one copy
> is easy to miss.
> 
> [ ... ]
> 
>> +	err = b53_write32(dev, B53_CFP_TCAM_PAGE, B53_CFP_ACTION(0),
>> +			  trap ? CFP_ACT0_FWD_MAP_REPLACE | CFP_ACT0_DST_PORT5 |
>> +				CFP_ACT0_REASON_TERMINATION : 0);
>> +	if (!err)
>> +		err = b53_write32(dev, B53_CFP_TCAM_PAGE, B53_CFP_ACTION(1),
>> +				  trap ? CFP_ACT1_CLASS_ID(1) | CFP_ACT1_FWD_MAP_REPLACE |
>> +				  CFP_ACT1_DST_PORT5 : 0);
>> +	if (!err)
>> +		err = b53_fa_cfp_write(dev, index, CFP_ACC_ACTION);
>> +	if (!err)
>> +		err = b53_write32(dev, B53_CFP_TCAM_PAGE, B53_CFP_METER, 0);
>> +	if (!err)
>> +		err = b53_write32(dev, B53_CFP_TCAM_PAGE, B53_CFP_METER + 4, 0);
>> +	if (!err)
>> +		err = b53_fa_cfp_write(dev, index, CFP_ACC_METER);
>> +	return err ?: b53_fa_cfp_write(dev, index, CFP_ACC_TCAM);
>> +}
> 
> [Severity: Medium]
> With vlan_filtering enabled, can these redirects to port 5 still reach
> GMAC0 for VLAN-tagged traffic?
> 
> The trap actions do not set VLAN bypass. The comment in b53_fa_setup()
> says VLAN filtering is preserved on purpose.
> 
> Port 5 is only a member of VID 0, which it gets from the
> b53_for_each_port() loop in b53_setup(). For any other VID,
> b53_vlan_add() is called for the user port and for its cpu_dp.
> b53_preferred_cpu_port() makes cpu_dp port 8 for every user port, so
> BIT(5) never ends up in dev->vlans[vid].members.
> 
> b53 sets ds->vlan_filtering_is_global. Enabling vlan_filtering on any
> bridge on the switch therefore also turns on VLAN table enforcement for
> the standalone ports, and those are the only ports with CFP
> classification enabled.
> 
> Take a standalone port with an 802.1Q upper. Its tagged SYN/FIN/RST,
> TTL 0/1 and oversized IPv4 frames are redirected to a port that is not
> a member of their VLAN. So is everything caught by
> B53_FA_DEFAULT_RULE. Wouldn't the switch drop these frames instead of
> delivering them to Linux?
> 
> Should port 5 be kept in step with port 8 in b53_vlan_add() and
> b53_vlan_del() when fa_cfp_enabled is set? Or should the trap action
> bypass the VLAN check for port 5 after all?
> 
> [Severity: Low]
> Is the policer meant to stay enabled here? The register layout matches
> bcm_sf2: ACT_POL_DATA0/1/2 sit at 0x50/0x54/0x58 and RATE_METER0/1 at
> 0x60/0x64. In that layout, writing 0 to RATE_METER0 selects
> POLICER_MODE_RFC2698. bcm_sf2 does this instead:
> 
> drivers/net/dsa/bcm_sf2_cfp.c:bcm_sf2_cfp_act_pol_set() {
>      ...
> 	core_writel(priv, 0, CORE_ACT_POL_DATA2);
>      ...
> 	/* Disable the policer */
> 	core_writel(priv, POLICER_MODE_DISABLE, CORE_RATE_METER0);
>      ...
> }
> 
> Here B53_CFP_ACTION(2) is never written before the action RAM commit,
> and RATE_METER2..6 are never written at all.
> 
> Would every rule, including the allow rules, then get a zero-rate trTCM?
> Would the third action word (MAC limit bypass, TC change, PCP/DEI remark)
> come from whatever the staging register happens to hold? The TCP flag
> loop in b53_fa_setup() open-codes the same sequence.
> 
> [ ... ]
> 
>> +static int b53_fa_setup(struct b53_device *dev)
>> +{
> 
> [ ... ]
> 
>> +	for (rule = 0; rule < 3; rule++) {
>> +		memset(data, 0, sizeof(data));
>> +		memset(mask, 0, sizeof(mask));
>> +		data[0] = CFP_TCAM0_VALID | CFP_TCAM0_SLICE1 | CFP_TCAM0_UDF0_FLAG(rule);
>> +		/* Slice 1; FIN, SYN or RST. */
>> +		mask[0] = CFP_TCAM0_VALID | CFP_TCAM0_SLICE_MASK | CFP_TCAM0_UDF0_FLAG(rule);
>> +		data[5] = CFP_TCAM5_UDF_VALID(0); /* UDF A0 valid. */
>> +		mask[5] = CFP_TCAM5_UDF_VALID(0);
>> +		data[6] = FIELD_PREP(CFP_TCAM6_IP_PROTOCOL, IPPROTO_TCP);
>> +		mask[6] = CFP_TCAM6_L3_FRAMING | CFP_TCAM6_IP_PROTOCOL | CFP_TCAM6_IP_FRAGMENT;
> 
> [Severity: Medium]
> CFP_TCAM6_IP_FRAGMENT is in the mask with data 0, so these SYN/FIN/RST
> traps match only unfragmented packets. b53_fa_guards() has no rule that
> sends IPv4 fragments to port 5 either.
> 
> Take a first fragment (MF set, offset 0) with SYN, FIN or RST, TTL above
> 1, at most 1500 bytes, addressed to the port's router MAC. It would match
> the allow rule and take the FA inline path instead of GMAC0.
> 
> If the original FA looks up first fragments, can TCP control segments
> for a live tuple skip the exception path and Linux conntrack?
> 
> Two later pieces of the series seem to assume fragments are trapped:
> 
>    - The documentation says "IP options and fragments retire pairs by
>      their L3 identity before Linux can process a reused tuple".
>    - fa_control_receive() in the backend handles fragments.
> 
> [ ... ]
> 
>> +	/* Ordinary flooding must reach only the data CPU, not both MACs. */
>> +	b53_port_set_ucast_flood(dev, 5, false);
>> +	b53_port_set_mcast_flood(dev, 5, false);
>> +	err = b53_write8(dev, B53_CTRL_PAGE, B53_PORT_CTRL(5), PORT_CTRL_RX_UCST_EN);
> 
> [Severity: Medium]
> Do the RX_*CST_EN bits do anything on port 5? b53_regs.h documents them
> as port 8 only:
> 
> #define   PORT_CTRL_RX_BCST_EN		BIT(2) /* Broadcast RX (P8 only) */
> 
> At the same time, b53_enable_port() and b53_br_leave() add BIT(5) to the
> PVLAN egress mask of every user port:
> 
> 	if (dev->fa_cfp_enabled && (dev->fa_cfp_ports & BIT(port)))
> 		pvlan |= BIT(5);
> 
> b53_br_join() keeps that bit through its read-modify-write. b53 has no
> broadcast flood mask, so broadcast frames would seem to egress both port
> 5 and port 8.
> 
> brcm_fa_tag_rcv() passes port 5 frames without BRCM_EG_RC_PROT_TERM up
> the stack. Would Linux then receive ARP, DHCP and other broadcasts twice
> on the user netdev, and forward them twice when the port is bridged?
> That would not match "keep ordinary data flooding off the auxiliary CPU"
> in the commit message.
> 
> [ ... ]
> 
>> +static int b53_fa_port(struct b53_device *dev, int port, bool standalone)
>> +{
>> +	struct dsa_port *control = dsa_to_port(dev->ds, 5);
>> +	bool ready;
>> +	u16 ports;
>> +	int err;
>> +
>> +	if (!dev->fa_cfp_enabled)
>> +		return 0;
>> +	ports = dev->fa_cfp_ports & ~BIT(port);
>> +	if (standalone)
>> +		ports |= BIT(port);
>> +	ready = b53_fa_ready(dev, dsa_port_conduit_is_operational(control));
>> +	err = b53_write16(dev, B53_CFP_PAGE, B53_CFP_CTRL,
>> +			  ready ? ports : 0);
>> +	if (!err)
>> +		dev->fa_cfp_ports = ports;
>> +	return err;
>> +}
> 
> [Severity: High]
> What protects a bridged port after b53_br_join() calls
> b53_fa_port(dev, port, false)?
> 
> Clearing the port's bit in B53_CFP_CTRL turns off all of its guard rules
> for as long as it stays bridged: SYN/FIN/RST, TTL 0/1, length, the
> router-MAC allow rule and the default IPv4 trap.
> 
> b53_fa_conduit_state_change() and b53_fa_netdev_event() both call
> brcm_fa_control_set_ready(data->conduit, false) before writing CFP_CTRL.
> This function does not. FA readiness therefore stays true, and live
> entries are not retired before this port's exception path goes away.
> 
> Port 8 is still the preferred CPU port. It still has unicast and
> multicast flooding on from b53_setup_port(), and it is still in every
> PVLAN mask.
> 
> A host on the bridged port could send a frame to a standalone port's
> router MAC, carrying the tuple of a flow offloaded for that port. The FA
> key has no input port, so would the frame be forwarded and NATed in
> hardware without Linux seeing it? TTL 0/1, FIN/RST and oversized packets
> on that tuple would get through the same way.
> 
> This looks like the "live tuple from bypassing Linux ingress policy on
> another switch port" case that the commit message says is prevented. It
> also breaks "Disable admission and retire entries before removing any
> exception path". The later patches in the series leave this code as is,
> and the documentation patch only says that CFP classification is disabled
> on bridge members.
> 
> [ ... ]
> 
>> +static int b53_fa_netdev_event(struct notifier_block *nb, unsigned long event, void *ptr)
>> +{
> 
> [ ... ]
> 
>> +	control = dsa_to_port(dev->ds, 5);
>> +	data_cpu = dsa_to_port(dev->ds, 8);
>> +	brcm_fa_control_set_ready(data_cpu->conduit, false);
>> +	if (event != NETDEV_PRE_CHANGEADDR) {
> 
> [ ... ]
> 
>> +	}
>> +	err = b53_fa_rule(dev, B53_FA_ALLOW_BASE + dp->index, data, mask, false);
> 
> [Severity: Medium]
> What brings back the allow rule and FA readiness if the address change
> fails after NETDEV_PRE_CHANGEADDR?
> 
> On that event, this code writes an all-zero entry over the port's allow
> rule and drops readiness for the whole data conduit. Only a later
> NETDEV_CHANGEADDR undoes this.
> 
> netif_set_mac_address() can return early without sending
> NETDEV_CHANGEADDR:
> 
> net/core/dev.c:netif_set_mac_address() {
>      ...
> 	err = netif_pre_changeaddr_notify(dev, ss->__data, extack);
> 	if (err)
> 		return err;
> 	if (memcmp(dev->dev_addr, ss->__data, dev->addr_len)) {
> 		err = ops->ndo_set_mac_address(dev, ss);
> 		if (err)
> 			return err;
>      ...
> }
> 
> dsa_user_set_mac_address() returns -EADDRNOTAVAIL for an invalid address,
> so "ip link set lanX address 01:00:00:00:00:00" is enough to trigger
> this. A later notifier vetoing PRE_CHANGEADDR has the same effect.
> 
> Would all hardware flows then stay retired until an unrelated NETDEV_UP
> or NETDEV_CHANGEADDR event, or a control conduit state change?
> 
> [ ... ]
> 
>> @@ -2439,6 +2775,10 @@ void b53_br_leave(struct dsa_switch *ds, int port, struct dsa_bridge bridge)
>>   		vl->members |= BIT(port);
>>   		b53_set_vlan_entry(dev, pvid, vl);
>>   	}
>> +	if (b53_fa_port(dev, port, true)) {
>> +		dev_err(ds->dev, "failed to restore FA classification on port %d\n", port);
>> +		b53_disable_port(ds, port);
>> +	}
>>   }
>>   EXPORT_SYMBOL(b53_br_leave);
> 
> [Severity: Medium]
> Is b53_disable_port() enough on this failure path? It only sets the RX/TX
> disable bits in PORT_CTRL. It does not set fa_guards_failed or drop FA
> readiness, and fa_cfp_ports still lacks this port's bit.
> 
> The next ndo_open runs b53_enable_port(), which clears those bits:
> 
> 	b53_write8(dev, B53_CTRL_PAGE, B53_PORT_CTRL(port), 0);
> 
> The port is then standalone with no CFP classification. Its traffic goes
> through port 8 and the FA while readiness is still true.
> 
> The notifier failure path sets fa_guards_failed for this kind of case.
> Should this path set it too?
> 
> [ ... ]
> 
>> @@ -2564,6 +2905,46 @@ static bool b53_can_enable_brcm_tags(struct dsa_switch *ds, int port,
> 
> [ ... ]
> 
>> +static bool b53_uses_fa_tag(struct dsa_switch *ds, int port)
>> +{
> 
> [ ... ]
> 
>> +		ethernet = of_parse_phandle(node, "ethernet", 0);
>> +		fa = of_parse_phandle(ethernet, "brcm,flow-accelerator", 0);
>> +		enabled = IS_ENABLED(CONFIG_BCM_NS_FA) && of_device_is_available(fa) &&
>> +			  (dev->chip_id == BCM53011_DEVICE_ID ||
>> +			   dev->chip_id == BCM53012_DEVICE_ID ||
>> +			   (is5301x(dev) && of_device_is_compatible(fa, "brcm,bcm4708-fa")));
> 
> [Severity: Low]
> Should this check use the compatibles listed in the binding?
> brcm,bcm4708-fa.yaml allows brcm,bcm4708-fa, brcm,bcm53011-fa and
> brcm,bcm53012-fa, and its example uses brcm,bcm53011-fa. bcm_ns_fa_init()
> later in the series accepts all three.
> 
> As written, BCM53011/BCM53012 accept any available node without looking
> at its compatible. BCM53010/53018/53019 accept only brcm,bcm4708-fa.
> 
> That leads to two mismatched setups:
> 
>    - A 5301x board whose DT uses brcm,bcm53011-fa or brcm,bcm53012-fa gets
>      the FA backend set up on GMAC2, while b53 uses the ordinary brcm tag
>      and installs no CFP guards.
>    - A 53011/53012 board with an unrelated compatible gets FA tagging, and
>      then bgmac probe fails.
> 
> [ ... ]
> 
>> @@ -3385,7 +3773,32 @@ int b53_switch_register(struct b53_device *dev)
>>   	dev_info(dev->dev, "found switch: %s, rev %i\n",
>>   		 dev->name, dev->core_rev);
>>   
>> -	return dsa_register_switch(dev->ds);
>> +	ret = dsa_register_switch(dev->ds);
>> +	if (ret || !dev->fa_cfp_enabled)
>> +		return ret;
> 
> [ ... ]
> 
>> +	ret = register_netdevice_notifier(&dev->fa_netdev_nb);
>> +	if (ret)
>> +		goto unregister_switch;
>> +	ret = devm_add_action_or_reset(dev->dev, b53_fa_unregister_notifier, dev);
>> +	if (ret)
>> +		goto unregister_switch;
>> +	dev->fa_guards_ready = true;
>> +	if (!dev->fa_guards_failed) {
> 
> [Severity: Low]
> These plain bool flags are accessed concurrently with no common lock and
> no READ_ONCE()/WRITE_ONCE():
> 
>    - Here, fa_guards_ready is written and fa_guards_failed is read outside
>      rtnl, after b53_fa_netdev_event() is already live.
>    - The notifier reads both flags under rtnl and may write
>      fa_guards_failed.
>    - b53_teardown() writes dev->fa_stopping without rtnl, while
>      b53_fa_netdev_event() reads it for every netdevice event in the
>      system.
> 
> The final readiness looks correct, because b53_fa_ready() is evaluated
> again under rtnl_lock() below. Won't KCSAN still report these accesses as
> data races?
> 
> [ ... ]
> 
>> diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
>> index 4f44bf3ede238..2dffff2f6c343 100644
>> --- a/net/dsa/Kconfig
>> +++ b/net/dsa/Kconfig
>> @@ -69,6 +69,15 @@ config NET_DSA_TAG_BRCM_PREPEND
>>   	  Broadcom switches which places the tag before the Ethernet header
>>   	  (prepended).
>>   
>> +config NET_DSA_TAG_BRCM_FA
>> +	tristate "Tag driver for the Broadcom Northstar flow accelerator"
>> +	select NET_DSA_TAG_BRCM_COMMON
>> +	help
>> +	  Support the prepended four-byte FA metadata tag on Northstar GMAC2.
>> +	  The receive format includes a hash, bucket, parser status, and input
>> +	  switch port. Transmit uses the ordinary prepended Broadcom tag.
>> +	  Enable this for a B53 switch explicitly connected to an accelerator.
> 
> [Severity: Low]
> This isn't a bug, but the help text does not match the code.
> brcm_fa_tag_xmit() puts the tag inside the frame for user ports behind
> CPU port 5:
> 
> 	return brcm_tag_xmit_ll(skb, dev, dp->cpu_dp->index == 5 ? 2 * ETH_ALEN : 0);
> 
> drivers/net/dsa/b53/Kconfig also selects NET_DSA_TAG_BRCM_FA
> unconditionally, so the user has nothing to enable. Could the help text
> be updated to match?
> 
> [ ... ]
> 
>> diff --git a/net/dsa/tag_brcm.c b/net/dsa/tag_brcm.c
>> --- a/net/dsa/tag_brcm.c
>> +++ b/net/dsa/tag_brcm.c
>> @@ -407,7 +416,100 @@ DSA_TAG_DRIVER(brcm_prepend_netdev_ops);
>>   MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_BRCM_PREPEND, BRCM_PREPEND_NAME);
>>   #endif
>>   
>> +#if IS_ENABLED(CONFIG_NET_DSA_TAG_BRCM_FA)
>> +static LIST_HEAD(brcm_fa_controls);
>> +static DEFINE_MUTEX(brcm_fa_control_lock);
>> +
>> +void brcm_fa_control_register(struct brcm_fa_control *control)
>> +{
>> +	mutex_lock(&brcm_fa_control_lock);
>> +	list_add_rcu(&control->list, &brcm_fa_controls);
>> +	mutex_unlock(&brcm_fa_control_lock);
>> +}
>> +EXPORT_SYMBOL_GPL(brcm_fa_control_register);
>> +
>> +void brcm_fa_control_unregister(struct brcm_fa_control *control)
>> +{
>> +	mutex_lock(&brcm_fa_control_lock);
>> +	list_del_rcu(&control->list);
>> +	mutex_unlock(&brcm_fa_control_lock);
>> +	synchronize_net();
>> +}
>> +EXPORT_SYMBOL_GPL(brcm_fa_control_unregister);
>> +
>> +void brcm_fa_control_set_ready(struct net_device *conduit, bool ready)
>> +{
>> +	struct brcm_fa_control *control;
>> +
>> +	/* State callbacks can sleep while retiring hardware entries. */
>> +	mutex_lock(&brcm_fa_control_lock);
>> +	list_for_each_entry(control, &brcm_fa_controls, list)
>> +		if (control->conduit == conduit && control->state_change)
>> +			control->state_change(control->priv, ready);
>> +	mutex_unlock(&brcm_fa_control_lock);
>> +}
>> +EXPORT_SYMBOL_GPL(brcm_fa_control_set_ready);
>> +
>> +static struct sk_buff *brcm_fa_tag_xmit(struct sk_buff *skb,
>> +					struct net_device *dev)
>> +{
>> +	struct dsa_port *dp = dsa_user_to_port(dev);
>> +
>> +	return brcm_tag_xmit_ll(skb, dev, dp->cpu_dp->index == 5 ? 2 * ETH_ALEN : 0);
>> +}
>> +
>> +static struct sk_buff *brcm_fa_tag_rcv(struct sk_buff *skb, struct net_device *dev)
>> +{
>> +	struct dsa_port *cpu = dev->dsa_ptr;
>> +	struct brcm_fa_control *control;
>> +	struct dsa_port *data_cpu;
>> +	unsigned int port;
>> +	u8 reason;
>> +
>> +	if (cpu->index != 5)
>> +		return brcm_tag_rcv_ll(skb, dev, ETH_HLEN, true);
>> +	if (!pskb_may_pull(skb, BRCM_TAG_LEN))
>> +		goto drop;
>> +	reason = skb->data[0]; /* Embedded tag byte 2 after eth_type_trans(). */
>> +	port = skb->data[1] & BRCM_EG_PID_MASK;
>> +	skb = brcm_tag_rcv_ll(skb, dev, 2, false);
>> +	if (!skb)
>> +		return NULL;
>> +	dsa_strip_etype_header(skb, BRCM_TAG_LEN);
>> +	skb_set_mac_header(skb, -ETH_HLEN);
>> +	if (!(reason & BRCM_EG_RC_PROT_TERM))
>> +		return skb;
>> +	data_cpu = dsa_to_port(cpu->ds, 8);
>> +	if (!data_cpu || !dsa_port_is_cpu(data_cpu))
>> +		return skb;
>> +	rcu_read_lock();
>> +	list_for_each_entry_rcu(control, &brcm_fa_controls, list)
>> +		if (control->conduit == data_cpu->conduit)
>> +			control->receive(control->priv, skb, port);
>> +	rcu_read_unlock();
>> +	return skb;
>> +drop:
>> +	kfree_skb(skb);
>> +	return NULL;
>> +}
>> +
>> +static const struct dsa_device_ops brcm_fa_netdev_ops = {
>> +	.name = BRCM_FA_NAME,
>> +	.proto = DSA_TAG_PROTO_BRCM_FA,
>> +	.xmit = brcm_fa_tag_xmit,
>> +	.rcv = brcm_fa_tag_rcv,
>> +	.needed_headroom = BRCM_TAG_LEN,
>> +	.promisc_on_conduit = true,
>> +};
>> +
>> +DSA_TAG_DRIVER(brcm_fa_netdev_ops);
>> +MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_BRCM_FA, BRCM_FA_NAME);
>> +#endif
>> +
>>   static struct dsa_tag_driver *dsa_tag_driver_array[] =	{
>> +#if IS_ENABLED(CONFIG_NET_DSA_TAG_BRCM_FA)
>> +	&DSA_TAG_DRIVER_NAME(brcm_fa_netdev_ops),
>> +#endif
>>   #if IS_ENABLED(CONFIG_NET_DSA_TAG_BRCM)
>>   	&DSA_TAG_DRIVER_NAME(brcm_netdev_ops),
>>   #endif
> 
> [Severity: Medium]
> Does the link-local check at the end of brcm_tag_rcv_ll() look at the
> right bytes for this call?
> 
> With offset == ETH_HLEN the tag is prepended. eth_type_trans() on the
> conduit therefore left skb->mac_header pointing at the four-byte tag,
> not at the destination MAC. skb_pull_rcsum() only moves skb->data.
> After the pull, eth_hdr(skb)->h_dest covers the tag plus the first two
> bytes of the real DA. is_link_local_ether_addr() then does not
> recognise 01:80:c2:00:00:xx frames.
> 
> Port 8 is the CPU port for all user ports on these boards. STP BPDUs,
> LLDP, LACP and EAPOL received on bridged ports would all get
> offload_fwd_mark set.
> 
> The switch only trapped these frames and did not forward them. With
> the mark set, the bridge also won't forward them in software to other
> ports on the same switch. That matters with STP disabled or with a
> group_fwd_mask configured.
> 
> The port 5 branch in brcm_fa_tag_rcv() fixes up the MAC header with
> skb_set_mac_header(), but this branch does not.
> 
> brcm_tag_rcv_prepend() seems to have the same problem already, so this
> may need its own fix in brcm_tag_rcv_ll(). After the pull, it could
> read the DA from skb->data - ETH_HLEN, or reset the MAC header first.
> Which would you prefer?
> 

[High] bridged ports lose their guards

Agreed: the FA key has no input port, so a bridged port without guards 
could hit a live tuple. v2 requires every user port to have its
exception rules for FA to be ready: while any port is a bridge member, 
entries are retired and new ones are not admitted. b53_fa_port() also 
retires entries before touching CFP_CTRL.

[Medium] PRE_CHANGEADDR / failed MAC change; guard write failure

Agreed. PRE_CHANGEADDR now only retires the entries and schedules a 
resynchronization of the allow rules and readiness once RTNL is 
released, which also covers a MAC change that fails. A failure to write 
a guard now disables the CFP and FA instead of leaving CFP_CTRL enabled.

[Medium] b53_br_leave() failure

Agreed: the port is now recorded before the CFP_CTRL write and a write 
failure marks the guards failed, so FA stays off.

[Medium] CPU port 5 in non-default VLANs

Agreed: b53_vlan_add()/del() keep port 5 a tagged member of the VLANs of 
port 8.

[Medium] notifier active during teardown/shutdown

Agreed: the notifier is now unregistered and its work cancelled in 
b53_switch_remove()/b53_switch_shutdown(), before the DSA teardown, and 
the CFP is disabled there. The flags use READ_ONCE/WRITE_ONCE and the 
final readiness update is done under RTNL.

[Medium] brcm_tag_rcv_ll() link-local check

Agreed, this is an existing problem with the prepended tag. v2 fixes it 
in a separate patch before this one.

[Medium] TCP flag rules and fragments

The FA parser does not support fragments (data sheet: "The parser does 
not support options and fragmentation"), so fragments are never 
accelerated and take the software path. No change.

[Medium] EAP basic mode on standalone ports

The CFP rules have to classify standalone traffic, which the simplified 
mode would redirect to the CPU first. I will clarify the comments and 
the commit message; the mode is unchanged.

[Medium] data flooding

The RX_xCST_EN bits are only valid for port 8, so that write was a no-op 
and is removed. Unicast and multicast flooding to port 5 stays disabled. 
I am checking broadcast on hardware; the commit message no longer claims 
that all flooding is off.

[Low] policer/meter, duplicated rule programming, compatibles, Kconfig help

The BCM5301x CFP has no ACT_POL_DATA2 or policer mode field, unlike 
bcm_sf2: RATE_METER0 is only the current quota, so no change. The other
three are fixed in v2.

pw-bot: cr
-- 
Florian
