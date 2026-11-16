Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.227
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794869140;
	b=EXqlSbunjoXxwkPRPI9MMuguGuHss0iMlSQl7NxD1PkkYUo7v3evx7ATEzWuUHCOfjv+
	 KXc/lmYcEVAiK5BlXVCAbNFQvVwCQFDRMMQENgTyZ4E0RNYvNVVsoBBDBvcZ3cyovgHxz
	 5XGrLJoAKIEYyj+slZzx/b0fYrW4tOIwknaZM9HZp+B7w+CIVZMbDyTWEzLHuzQorZqUs
	 ZY0H0NozfklMVnpA5xuh+jnbrnmePJll1rwpWRmO7/D7NRnem/tOZapYo1mCUjcMcjma8
	 fZJ+sA2QfEo7w1u4fXcowVacVkwqj3U524XXHKmjGWcZm34BPq22JmidR33Isde4mQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794869140;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:X-Relaying-Domain:
	 X-CFilter-Loop:Received:DKIM-Signature:X-Forwarded-Encrypted:
	 X-Received:X-Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:Autocrypt:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-DetectorID-Processed;
	bh=QkhYB0iJVWl+8Xh7NXbusdKqsVeXAsPGYMcozCVflSw=;
	b=yPVsZZfQLE/qTIOAZQhgH2S7urWQjS4QVkFBoEJrlUKYnlQBinyrLjjefha8OP4KZh9n
	 zy2dDSs5zIfF3bteHqqO4mzJdBWfOrCeJ9rRHCp5m6Gc3MezZmt1kMYZiTuAdDCnLfqGo
	 xUVhr0TTgMnffEGsKhythdLHazJ822uCS/1t8VUphT3fQLVbojhDpY2vjK1ockgng8TOa
	 v/9bytLiy/MRLJkQ/k/3SEzT8KvDFUWWAFeNNOatKmx30jIUt+Ur6HKCIGQLqUnn4wViU
	 aRHsv33FlK8BnJDV+RR8OynplcGrdYeWax0kJaj8SKidvh/EpGW9Jr+hu2l3xSP8XEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=f7Ou4wZv;
	arc=none smtp.remote-ip=209.85.222.227
Received: from mail-qk1-f227.google.com (mail-qk1-f227.google.com [209.85.222.227])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81E6D606A337
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 22:45:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 81E6D606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=f7Ou4wZv
Received: by mail-qk1-f227.google.com with SMTP id af79cd13be357-93f20c3aaa5so539287985a.2
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 14:45:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794869139; x=1795473939;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:dkim-signature:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=QkhYB0iJVWl+8Xh7NXbusdKqsVeXAsPGYMcozCVflSw=;
        b=gn8L7Io7xKqiQNZE7KusxKlEfE8YjmsSJ7Svgr6x0wMF3CckX88x8T0t3txdYCtUhB
         gmJEXt3If74u8tuqAj/IcE/YNMgUe+VQnw5Htz/tM+uUfuIFIpH3yhR6iw6zHUNvtPk7
         aP+LaaO+b3yJeYSVUtyRc2Hic6Co1BSl/SKGamQNuJQow1qZJgd09gutn4nC0pX37xqV
         +eDZOdoY/DYARenRqmMZ43FhF0MO7oW1mii2SAYb4hn5eT3FovRHBqtlEdRafIwOf3ZL
         WAk1ZQzGTNjKwKIfkSutjHSdPT79eRBJ9y14uj8CqFGo5g0kfGMuLnBwd5r74XA0mK14
         Y5BA==
X-Forwarded-Encrypted: i=1; AL+hErGZVZI6iu3MSoEd7aM7d1Pic4AMDzSCP6NDPQV/IsVORkt2Ld7RRjB+ojekOfvuzCjeGFgs4mZvkgpOfjICIqs=@vger.kernel.org
X-Gm-Message-State: APuU4Z+oDymWKqz9jCrbeiSDnM16R2iwYx0eYhscbqZpvMY8yAAojHX4
	gZNr4uXjqWNDf+0QSyJteuElxwWr4tXdX4LnUhtQyI+fqCQQmWJmwM2eDwU90aotszqg/kS0sFT
	UYvtdaoheg+TpRFWDKrlKmf8tsk2DsiJnlm3R1f13f4bKXNzURsWfjAsWz3untk+QqSoaSWxdgm
	ykAtPt7NU38s9qwJ/334k24IA9DfiYaVvPwu0/uyKDneAGwQa9b5JDJzYHlOCVzwYrrQoHY28Xu
	bFVHd95Zm/OcuofXbTWDZ3DKJ/e
X-Gm-Gg: AYBFou26rniMooSglWRQg+BqRevgHlwHY0Dy6ZUGsFQY9fwUPvYG22/CqIPSXvBs1rg
	/br/ytP/Pr9zWVOpVEYVV7JGzlmTtIM05lPK6ioazHwc3jizNcs/UNPOn3GPGFy37doqpjj5vtx
	dHkStHn4NREt114eI+y+us2268edUglNRpktu5hMO2kDsz2xa7sLxGXmeiKo5oAMn1BPixdrEse
	PpvdbEPK/PBh7OkgyIiME7SwFFTFz0ZPHDzPLwKh2Z+yCntYgCyJifEYj7uyRhvw9Zoo+N48hnl
	R2OeMHbLSFJe9VyF6k8Z/zUDMVW7vmmBZJ4UhSUJY515/2lyi/D2bJ45T/iGWsje0oV7nx1sjNO
	zkP6B74QfutpdiE4InoRvKJHXBemvfXyPEwN6q4By+4qex92deEbGeF3q5rlAEYZJkAJOYxBuzu
	fJKZk0/AM+KGgzqjQTNehet91msf7sc2d2uTs6GUlhUcM=
X-Received: by 2002:a05:620a:4495:b0:93e:c12c:f148 with SMTP id af79cd13be357-9494bc38c43mr1885511685a.82.1794869139499;
        Mon, 16 Nov 2026 14:45:39 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-123.dlp.protect.broadcom.com. [144.49.247.123])
        by smtp-relay.gmail.com with ESMTPS id af79cd13be357-9494c543ec6sm131043685a.1.2026.11.16.14.45.38
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Nov 2026 14:45:39 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-946038e22f5so490971785a.0
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 14:45:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1794869137; x=1795473937; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QkhYB0iJVWl+8Xh7NXbusdKqsVeXAsPGYMcozCVflSw=;
        b=f7Ou4wZvsEOcFP4BJj/uMg5NIU7jIvbiu4OfVKImVjIez4yfcnj8vJOQcO0GYduEV3
         46n3df3NeXjFWh5BE02/6mFQq0dpYGghCYDXG3DxrAlm2uSODmbmkJ1QlTBhTXu1pF2m
         A1lPL5MQXdMOnnwWQunjlnIDWMMJjmt2WJXYg=
X-Forwarded-Encrypted: i=1; AL+hErFqqQutdKk495T3hGBMkMA63yfkk21bueJEa3wgAxRtCXcIb3BxWxtLJL1YfbbuD8q64P7bDT9XxoeAg62hQpI=@vger.kernel.org
X-Received: by 2002:a05:620a:4054:b0:93c:664e:e212 with SMTP id af79cd13be357-9494bb561damr1910645285a.32.1794869137421;
        Mon, 16 Nov 2026 14:45:37 -0800 (PST)
X-Received: by 2002:a05:620a:4054:b0:93c:664e:e212 with SMTP id af79cd13be357-9494bb561damr1910639285a.32.1794869136833;
        Mon, 16 Nov 2026 14:45:36 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9494c836f62sm951612385a.23.2026.11.16.14.45.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2026 14:45:36 -0800 (PST)
Message-ID: <31b2a5e7-d419-4e44-a634-7ef139950023@broadcom.com>
Date: Mon, 16 Nov 2026 14:45:32 -0800
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
Subject: Re: [PATCH net-next 0/9] net: bgmac: add Northstar IPv4 TCP/UDP NAT
 flowtable offload
To: netdev-bot+sinfo@kernel.org
Cc: netdev@vger.kernel.org, =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?=
 <rafal@milecki.pl>,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, Andrew Lunn
 <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, Simon Horman <horms@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, Jonas Gorski <jonas.gorski@gmail.com>,
 Vladimir Oltean <olteanv@gmail.com>, Pablo Neira Ayuso
 <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
 Phil Sutter <phil@nwl.cc>, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org
References: <20261116222519.1416501-1-florian.fainelli@broadcom.com>
 <179486871961.3291.17535527526102286596@kernel.org>
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
In-Reply-To: <179486871961.3291.17535527526102286596@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On 11/16/26 14:38, netdev-bot+sinfo@kernel.org wrote:
> Hi!
> 
> This is an automated message. This series looks like a fix, but its
> commit messages seem to be missing some information:
> 
>   - How the issue was discovered, e.g. hit in production, hit during
>     development, syzbot report, manual code inspection, LLM or static
>     analysis tool scan.

The commits with a Fixes: tag were developed in response to a test 
failure developing the flow accelerator hardware on BCM5301X SoCs.
-- 
Florian
