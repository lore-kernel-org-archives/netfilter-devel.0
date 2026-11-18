Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.97
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022533;
	b=Qc69n9Fb894qUI9YfrhCxucML1RVWb7fzMiTiI9rADTOLZTzx8d+tDYlMVwFVaElYHKq
	 SPKMqOhoHW+NFiQquF7hBEKB7VYEdkPtV0CoRiLE6p3q4wI6E11HDxWo1tNXHznwvf8iW
	 0L22ycT1Y65F5qZQGWEVfRBj3VLftMLaz4TgyFHWnffzSeH4T5Y7Lu4W/YvJuUqVMbuGj
	 gzRUHGa0zq14ZO4RSccIhWeH7Z4qLAKk6plAsawB6neIa0SzYRBDVSYl7FcACUXUbU488
	 1HRw3ZGYm2I2XE5AWXEkiD/T70VDQHy9sNrrcBeaZ8kTXcfTmxV6ND0lrim5xMIHnHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022533;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:X-Relaying-Domain:
	 X-CFilter-Loop:Received:DKIM-Signature:X-Forwarded-Encrypted:
	 X-Received:X-Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:Autocrypt:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-DetectorID-Processed;
	bh=mY/FNLYTzlT6/9iFOU+8LtK9dRUupasMtXWg1lgUwjY=;
	b=mEeV7wj0TNdgjmSvzxzbY7Pb/MGmUQQBj5asO4XsabP1fiyhLoXvj+pizDISoJuvbGJC
	 SUECZ04cpt3VFoFsX+TRKRiI3ENHhoL5uTvxQ9W9LgQuU32LaXPxMzvDE89pzfIE7pSh/
	 RuRIxDXwOn/7sem3fqbMw7y77NGpvpAnleUVaqg63P4cgaBCY9FDtFmx5Vwaf6NlowZmj
	 dQKm+5ctK1Yo2OmAdRu2cIOXbrTt2UCtliW7FJmIoLy57XgcmQ4aCp+D0sVlBgAJK+ygX
	 6yTVeI6r1jlN0nvnvhmdWKWax5GYutmcr1xDDgz9HrcxxW122E19SI3gDeb32+yrZ4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=QCmbXsw9;
	arc=none smtp.remote-ip=209.85.216.97
Received: from mail-pj1-f97.google.com (mail-pj1-f97.google.com [209.85.216.97])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0B42606A320
	for <netfilter-devel@vger.kernel.org>; Wed, 18 Nov 2026 17:22:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F0B42606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=QCmbXsw9
Received: by mail-pj1-f97.google.com with SMTP id 98e67ed59e1d1-3ac9f49b984so31157a91.1
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Nov 2026 09:22:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795022532; x=1795627332;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:dkim-signature:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=mY/FNLYTzlT6/9iFOU+8LtK9dRUupasMtXWg1lgUwjY=;
        b=shLEJN/aJhH4u2V5LdqG2wD+NssFE80r1szFYZrUrG5vNClPZPgQ6S3jmpDkYOafpd
         MuUrmZa8eFvRfDN6Yn9jjXc57rriObkZDBlNSnUc+IyEsv2w+3JkjZO5k/bJb/9j/RzJ
         rmrrq5ZZCAlQhRVw5z7fT53p5hnvMzIR9e3nq38dOP2cgUUcpSlniFtivL3sBVMTDadk
         1qjdJNqL3Pd0EKsGu3lHiqwEimwkyuUliS0KVKhHqLMNXAvVeHEb/aEs8Td6MkHlPeOP
         lZc0H3JDbk7kXcv5VrMqCQH5sYB0wjEYrumzkiQTtrbDEZHgxo1XjVohzmSAqin9PShJ
         Jl6w==
X-Forwarded-Encrypted: i=1; AL+hErEbADcfCPlDrXNOObtgzxlKogUQ+qctg99GACa/yCJ1WhKWqiNblMBWxFo46GnTMptohM3Tq/fogO6EPFI8ouE=@vger.kernel.org
X-Gm-Message-State: APuU4Z/qW0mjaBsI9sEfAgYVC21tW1zMzEEV6NsW3QzXe1Q52bEiESqU
	gFJaZLyg2/3NaQYDtXgVe8U372lNMBq6ESrf2mhwsB/8Pl4+U80QNzyROTHsufdSSfqVNi3iI5n
	AdsnKgwneCn4JWtRIetheHEc5ZFYZsnjnldYOsLskeg0JtPTneZNdqXxCaqUIPql1R54xa6iFvP
	dcRRaqnKtxZdd0wWHMpFSDkpHW+rsUTHVelgvQiM8umyrdIzDINrTAIyyjitEvYNl8q9n3hPnJ1
	ZrheHShMIkfZSZoplHrW8vQsIBU
X-Gm-Gg: AZFdTZfP/wCfN4wyH9gZHQzuDOTDhiQat8an1GzcXK1MeDi8+gzOgRhow7ww5Pz2Src
	7BWmqv852Viry9sKA0ZkCAft+UfhrzenSusly+xBdjwEKAzM7uYgg1cK1OUkgJz9AD/jFz5HXCZ
	Bs5UVpZT2cuDynbkjJKwvK9YPBbYLCuu0j2hz+lJ/IOb5LOAu08zDVFAjIMET12nOA1M1mzQ3I+
	YWNqGBSELVNX7U4Zqkb9kONyoronaN4VvBQLIFW1Cp5OPYHzkwy7e3iH67KHWCEmLgf0swyiVnm
	clqyVrgbNqt6HWEkuywHPoN1bdSGEM76hNT2aY0hsigdi/MK+ihQMmJQKd7m/gu36sKHkvzaGai
	HBBzAR8qXz9/5XraZIpoLbKYir6ZWW/Uoe/QzVGiBHmlMo/D9hgRjyX6j4rnCXYkNoSj7QAvAPE
	HZRSvkpbd+Cw/xns4IiWl3XaAdUVBU4Q8DeIqaM6yM13w=
X-Received: by 2002:a17:90b:5864:b0:3b1:d40:2c4e with SMTP id 98e67ed59e1d1-3b3f4ba8eadmr158254a91.0.1795022532054;
        Wed, 18 Nov 2026 09:22:12 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-123.dlp.protect.broadcom.com. [144.49.247.123])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b3f6e04110sm64218a91.4.2026.11.18.09.22.11
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 09:22:12 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cdd97f89731so17124a12.1
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Nov 2026 09:22:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1795022530; x=1795627330; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mY/FNLYTzlT6/9iFOU+8LtK9dRUupasMtXWg1lgUwjY=;
        b=QCmbXsw9Q7pbMssiRJAA+fDmlvxstuKAuNkfpYE570k5fb06Uh/ls5PbiHErevwLaK
         AsntTPCiEwGG8Lq2VJ7UDGXF+bLPcTfvIdd8ccKdMmaz+sFvHJy8hCMPYEFieADslYZu
         JJ3GvdAJWpPG68HtpInXd+6sv4Y2hXAv808Jo=
X-Forwarded-Encrypted: i=1; AL+hErFeSHOyHExvGkyulxwsIodPksXBkqNS4uBKXUMH/BEEz7UbL/+ZOPjkBQDATa5kuAWsJ/x1kHZGRwl7a4ccsmU=@vger.kernel.org
X-Received: by 2002:a05:6a20:1611:b0:3e2:28f0:b360 with SMTP id adf61e73a8af0-3fff0101ffemr132520637.0.1795022530105;
        Wed, 18 Nov 2026 09:22:10 -0800 (PST)
X-Received: by 2002:a05:6a20:1611:b0:3e2:28f0:b360 with SMTP id adf61e73a8af0-3fff0101ffemr132501637.0.1795022529163;
        Wed, 18 Nov 2026 09:22:09 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde53506b98sm312451a12.30.2026.11.18.09.22.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2026 09:22:08 -0800 (PST)
Message-ID: <e8714dba-f51a-40a2-9bda-be49fb3b16ff@broadcom.com>
Date: Wed, 18 Nov 2026 09:22:05 -0800
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
Subject: Re: [PATCH net-next 4/9] dt-bindings: net: describe the Northstar
 flow accelerator
To: netdev-bot+sashiko@kernel.org
Cc: netdev@vger.kernel.org, rafal@milecki.pl,
 bcm-kernel-feedback-list@broadcom.com, andrew+netdev@lunn.ch,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org,
 pabeni@redhat.com, robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org,
 horms@kernel.org, corbet@lwn.net, jonas.gorski@gmail.com, olteanv@gmail.com,
 pablo@netfilter.org, fw@strlen.de, phil@nwl.cc, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org
References: <20261116222519.1416501-5-florian.fainelli@broadcom.com>
 <179495816151.3136.14110323389854628043@kernel.org>
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
In-Reply-To: <179495816151.3136.14110323389854628043@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On 11/17/26 15:29, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 3 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 0 · Medium: 1 · Low: 2
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [Medium] The flow-accelerator register resource in brcm,bcm4708-fa.yaml
>    is modelled as a standalone MMIO block with only `compatible` and…
> - [Low] The new brcm,bcm5301x-gmac.yaml schema is selected only when the
>    `brcm,flow-accelerator` property is present (`select: required:…
> - [Low] The FA binding description calls switch port 5 'IMP5' ('Switch
>    port 5 (IMP5), connected to GMAC0, ...').
> 
> --
> 
> dt-bindings: net: describe the Northstar flow accelerator
> 
> This commit adds a binding for the register block of the
> BCM4708/BCM53011/BCM53012 flow accelerator. It also adds a schema for the
> brcm,flow-accelerator phandle on the GMAC2 BCMA Ethernet node. The
> description covers the second CPU path, port 5 to GMAC0, for exceptions
> that bypass the accelerator.
> 
>> diff --git a/Documentation/devicetree/bindings/net/brcm,bcm4708-fa.yaml b/Documentation/devicetree/bindings/net/brcm,bcm4708-fa.yaml
>> new file mode 100644
>> index 0000000000000..f744b23433c46
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/net/brcm,bcm4708-fa.yaml
>> @@ -0,0 +1,45 @@
> 
> [ ... ]
> 
>> +description: |
>> +  The flow accelerator is inline between GMAC2 and switch port 8 (IMP0).
>> +  GMAC0 and GMAC1 bypass it. The GMAC2 BCMA Ethernet node references this
>> +  register block through a brcm,flow-accelerator phandle. Miss packets carry
>> +  a prepended accelerator descriptor in place of the embedded switch tag.
>> +
>> +  Switch port 5 (IMP5), connected to GMAC0, provides a second CPU path for
> 
> [Severity: Low]
> Should this say IMP1 instead of IMP5? The b53 SRAB code calls the two IMP
> ports IMP0 (port 8) and IMP1 (port 5):
> 
> drivers/net/dsa/b53/b53_srab.c:
> #define  B53_SRAB_IMP1_SLEEP_TIMER	BIT(10)
> #define  B53_SRAB_P7_SLEEP_TIMER	BIT(11)
> #define  B53_SRAB_IMP0_SLEEP_TIMER	BIT(12)
> 
> This description already uses IMP0 for port 8.
> 
>> +  exceptions that must bypass the accelerator, including TCP control,
>> +  low-TTL and oversized packets. Describe that CPU port with an ethernet
>> +  phandle to GMAC0 and an internal, 1 Gbps full-duplex fixed link in the
>> +  switch's ports node. Port 8 remains the data connection to GMAC2.
> 
> [ ... ]
> 
>> +  reg:
>> +    maxItems: 1
>> +
>> +required:
>> +  - compatible
>> +  - reg
>> +
>> +additionalProperties: false
>> +
>> +examples:
>> +  - |
>> +    flow-accelerator@18027c00 {
>> +        compatible = "brcm,bcm53011-fa";
>> +        reg = <0x18027c00 0xc0>;
>> +    };
> 
> [Severity: Medium]
> Can the flow accelerator be treated as a standalone MMIO block? The example
> address 0x18027c00 falls inside the 4 KiB BCMA window of GMAC core unit 3.
> bcm-ns.dtsi already describes that core under the 0x18000000 axi bus:
> 
> arch/arm/boot/dts/broadcom/bcm-ns.dtsi:
> 		gmac3: ethernet@27000 {
> 			reg = <0x27000 0x800>;
> 		};
> 
> The binding allows only compatible and reg. It has no clocks or resets
> and no link to the GMAC3 core. It also does not say that the hosting core
> must be out of reset and clocked.
> 
> Later in the series, bcm_ns_fa_init() in
> drivers/net/ethernet/broadcom/bcm-ns-fa.c maps this node and writes to it
> straight away:
> 
> 	np = of_parse_phandle(parent->of_node, "brcm,flow-accelerator", 0);
> 	...
> 	fa->regs = devm_ioremap_resource(parent, &res);
> 	...
> 	writel(0, fa->regs + FA_STATUS_MASK);
> 
> Nothing in bgmac or bcm-ns-fa calls bcma_core_enable() on core unit 3.
> bgmac_probe() also rejects core_unit 3 when that core has no MAC address,
> so it never gets enabled there.
> 
> Suppose the bootloader leaves the GMAC3 wrapper in reset or clock-gated.
> Could bgmac_probe() for GMAC2 -> bcm_ns_fa_init() -> writel() then take
> an imprecise external abort or hang the bus? And if something later resets
> the GMAC3 wrapper, would that wipe the programmed FA state?
> 
> This is inferred from how AI wrappers usually behave. I have not checked
> it against the Northstar register map, so I can't confirm that GMAC3
> hosts the FA. On BCM53012 boards where CFE leaves core 3 enabled, it may
> work as is.
> 
> Should the binding describe how the FA relates to its hosting core, or
> the clocks and resets it depends on?
> 
>> diff --git a/Documentation/devicetree/bindings/net/brcm,bcm5301x-gmac.yaml b/Documentation/devicetree/bindings/net/brcm,bcm5301x-gmac.yaml
>> new file mode 100644
>> index 0000000000000..76fbe2abf5152
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/net/brcm,bcm5301x-gmac.yaml
>> @@ -0,0 +1,27 @@
>> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
>> +%YAML 1.2
>> +---
>> +$id: http://devicetree.org/schemas/net/brcm,bcm5301x-gmac.yaml#
> 
> [ ... ]
> 
>> +select:
>> +  required:
>> +    - brcm,flow-accelerator
>> +
>> +properties:
>> +  brcm,flow-accelerator:
>> +    $ref: /schemas/types.yaml#/definitions/phandle
>> +    description: |
>> +      Phandle to the BCM4708, BCM53011 or BCM53012 inline flow accelerator.
>> +      Only GMAC2 (BCMA Ethernet core unit 2) has this connection.
>> +
>> +additionalProperties: true
> 
> [Severity: Low]
> The "Only GMAC2" restriction exists only in the description text. The
> schema is selected purely by the presence of the property, and it sets
> additionalProperties: true. Wouldn't a DT that puts brcm,flow-accelerator
> on gmac0 (ethernet@24000), gmac1 or gmac3 still pass dt_binding_check and
> dtbs_check?
> 
> Nothing checks that the phandle points to a brcm,*-fa node either.
> 
> Later in the series, bgmac_probe() in bgmac-bcma.c enforces the rule at
> runtime:
> 
> 	if (of_property_present(core->dev.of_node, "brcm,flow-accelerator") &&
> 	    core->core_unit != 2)
> 		return -EINVAL;
> 
> So a misplaced phandle makes that GMAC fail to probe, and dtbs_check gives
> no warning beforehand.
> 
> Separately, the file name and $id suggest a brcm,bcm5301x-gmac compatible,
> but the BCMA GMAC nodes have no compatible. Is that naming intended?
> 

[Medium] FA modeled as a standalone MMIO block

The register block does not overlap the GMAC3 node: 0x18027c00 is in the
GMAC3 BCMA window but outside the 0x800 bytes described by 
ethernet@27000. Per the data sheets, the FA is part of the AXI MAC + FA 
block together with the four GMAC cores (GMAC3 being the block's 
loopback port), not a separate peripheral. It has no clock or reset 
input of its own in the DT, and BCMA wrappers are not modeled as DT 
clocks/resets.

I cannot tell from the documentation how the GMAC3 BCMA wrapper state
affects access to these registers, so I am checking this on hardware and 
will add the core enable to bcm_ns_fa_init() if it turns out to be 
needed. v2 documents where the registers live in the binding description.

[Low] IMP5 vs IMP1

Agreed, port 5 is IMP1. Fixed in v2.

[Low] GMAC2-only restriction / naming

v2 restricts the consumer schema to ethernet@26000 with a $nodename
pattern. BCMA GMAC nodes have no compatible, which is why the schema is
selected by the property; the description now says so. dt-schema cannot
check what the phandle points to, the driver validates the compatible.

pw-bot: cr
-- 
Florian
