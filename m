Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.227
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026164;
	b=MMOUDOndW4ZNNcVV/b9bWUwzgzQEiQgkzPJY79QGPyFmZc5qLR8kR5gjz7q89wHmIEHJ
	 m6w5uGBGcdGjuoukN5tFGNo3IZqnHLPUo08vgeGHi9Z7tORXq38FW5TjA7B5PxrCWwqZh
	 3Xf29ZGecpCNdAlun6tAPPJpo101lDVl9VQw0YohLyvzmBwTY879fpreYGXDFqQnP8UmT
	 zNSPi7hpiY6fdT9OA5Xj/SNDpQ5NuHQR0UIIRwu6cX8uqx7Zwuhi6RtdaAAqxZIro5atj
	 JQ7I7QFFNEYfFnJRuniAdfIeHVqaGi0AuvEik8M03UNvHgZWU5z6RKvgF2LINFrb7/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026164;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:X-Relaying-Domain:
	 X-CFilter-Loop:Received:DKIM-Signature:X-Forwarded-Encrypted:
	 X-Received:X-Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:Autocrypt:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-DetectorID-Processed;
	bh=bnUtfuLqcXc6hvJeKnEgqslam6AebsSq4f86rbz9d/c=;
	b=cxHDLeIJjDOw2BBBEseulsYc/YQXub3mLloXfa3XdUn3wLvY0QKPyH2m6V6AjRCHtzXo
	 W3w3eLoYAJf5sn+29DIOG18aJ8p8c70//d6pdB74aHfcJLhQyXYXOyczFg0ltgawI+fyL
	 Q4B9nWkzcHQZiJf0dGpOP8NPIWU0oQKu/Ae4epC3mNf+Fu4gkmFMXGhN4KmAa7vXydyEM
	 FpGguepkHyNoCfliNXv1u4nJHjV+vEPtu8Wk1ov2hvVQ/sVw35ajqS2PaCmJbuC1yKGqH
	 DxIesR3P33bdKkZIgmdgqbJy5XVRUhNSlOkx5fDT336tTkkrAXJAmxdeUnBs94DlbtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=FyCt61lc;
	arc=none smtp.remote-ip=74.125.82.227
Received: from mail-dy1-f227.google.com (mail-dy1-f227.google.com [74.125.82.227])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18DAA60A260A
	for <netfilter-devel@vger.kernel.org>; Wed, 18 Nov 2026 18:22:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 18DAA60A260A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=FyCt61lc
Received: by mail-dy1-f227.google.com with SMTP id 5a478bee46e88-380b40312e2so3669845eec.1
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Nov 2026 10:22:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795026163; x=1795630963;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:dkim-signature:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=bnUtfuLqcXc6hvJeKnEgqslam6AebsSq4f86rbz9d/c=;
        b=T1HaxHXLIkhDuYZAuP3Tx5ysOq83sGAd+6XMvsSh8U3W/pb5+hxyTj8M9TLNzjggNL
         5RLANa+U3etbJzxW6Nn24axbX6cq7FlKXM2v7aHv3UnkHfgSQ5EOBxSM6sgtYApKKtWg
         toYH/h9jo4lohkCfNk+XqODF/fj4T6PV0z5//zB4cuqlNLDwvJo6r5FJJgBtfXXch/7s
         Hy1pDxLLDuR8x1/WiyYEML8uHazMUA1apQbbKweg2tYUfH2xRxGLhZiJCqpuAimjwxe1
         G5eLG+SflMYvYclY2ylS3Dyom4KNrFEUyGM1AotYxopLxM/0ybkBv7FoSjTrOmnyXLzW
         64SQ==
X-Forwarded-Encrypted: i=1; AL+hErFnVngg6fZL/AS41gAs4vvo+xgqZlurKaGaL/BXq/OO5PVZ+GtyW7yIMLnK0U5vuxmAWifGXDA099FpnrLFGoI=@vger.kernel.org
X-Gm-Message-State: APuU4Z+iOGKhVKLm+bKW1UUSV0nhjp4M/g52GBNdtdJ2nRZ20WGvCpVC
	pUI6XTJAwwI5vyGXgp+K+rsG0o1cemsXwQthvVG5TuGWdSM52MSaPaUgfEHrrMCznkWGKD7AMvn
	xPovsfpP7Octezls95Au0beA8Wa/MZsIqfRspBs/I4EmSQvbLWUwdFMgwpIo9RNXRbjuRqMOrBX
	UCCauw6HXBXcz9uerDw7Ajz3VWrfm5uHY2t9tSoMsP8qBP8sJuH4H3JgetR+eJxmh63+cKh4AMv
	sf2aqrjNHeRF5V/Ej/55VmZlwH4
X-Gm-Gg: AZFdTZeV/phtBgyGPuSCfu6mZMt1P16vuke5JRYrKbmQjLT/CN9Ub7yverhH/VDoti2
	Xq0BtpvVNTPU/p0D+HxsllSLJ8t+WmPce48Oynx4gR78d52uj7p1mnqDbTooKYaVjEN7QKeafVX
	2U7qtLokfUnSv9ENw47JPsCtFPhJy0ZQYNesGYQefLccfESx1TOYUZesSW9xQq9ZTV+/yYvs4/3
	5BguuQlbayfG2ighsSdfeeQAVWvW80P1kQ3Je2ZyjoqMgHdZVjnOc78OcXSVUZDw744+gAwXU77
	UvdLVs9e6MKjoZtN558uG8AF3u0P2XW0WjADgia/+LENrNzSn2Z3K/RGbY7Pfs8thrrNnDsOf3P
	sa1ZJMQqYhdBKwB8a6/KWKhLYGseZ3DcLP9+Pgnd7M+ZX+RPLt7GJbaBBrGz10h1yY0d5k6k7nx
	IT/cxnb5TgkzpjW4MJ/rcb2DSu170G8xQJFOEJVQFyocc=
X-Received: by 2002:a05:693c:26c7:b0:372:601a:6278 with SMTP id 5a478bee46e88-3828151f640mr3009135eec.33.1795026162577;
        Wed, 18 Nov 2026 10:22:42 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-123.dlp.protect.broadcom.com. [144.49.247.123])
        by smtp-relay.gmail.com with ESMTPS id 5a478bee46e88-382a80be5e6sm128304eec.28.2026.11.18.10.22.41
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 10:22:42 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-8bb1a7b0e52so895858b3a.1
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Nov 2026 10:22:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1795026161; x=1795630961; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bnUtfuLqcXc6hvJeKnEgqslam6AebsSq4f86rbz9d/c=;
        b=FyCt61lc2AoKF1u64xV290xH2mDnINZUn4WkLv1rS2gs7O/ZYcSnl1nmlAEh4a7759
         I02YuCRU3qN86DZ72JzF3dLXyBfAh+UHkH5Gf0gs4xC8U2m6g955gIIuJv4H65xSvuDd
         vdRr/mWAqaonFBNhzxZqRb8g2t33SCh9wx4dU=
X-Forwarded-Encrypted: i=1; AL+hErGcnMyM+vMjJBJ3ZuMnyN/8V260jh0Jj5oL/tMycIICWgJ96337PaKIAjur+28+1DdLNOpw/Odof+CLpGRoDT8=@vger.kernel.org
X-Received: by 2002:aa7:888a:0:b0:89f:600b:610d with SMTP id d2e1a72fcca58-8c5d49d36b4mr2982281b3a.31.1795026160556;
        Wed, 18 Nov 2026 10:22:40 -0800 (PST)
X-Received: by 2002:aa7:888a:0:b0:89f:600b:610d with SMTP id d2e1a72fcca58-8c5d49d36b4mr2982253b3a.31.1795026160014;
        Wed, 18 Nov 2026 10:22:40 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c5c7e9e93fsm1703971b3a.2.2026.11.18.10.22.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2026 10:22:39 -0800 (PST)
Message-ID: <c858b468-4862-4bd1-a214-d974e9a0de8a@broadcom.com>
Date: Wed, 18 Nov 2026 10:22:35 -0800
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
Subject: Re: [PATCH net-next 8/9] net: add KUnit coverage for FA and flowtable
 path validation
To: netdev-bot+sashiko@kernel.org
Cc: netdev@vger.kernel.org, rafal@milecki.pl,
 bcm-kernel-feedback-list@broadcom.com, andrew+netdev@lunn.ch,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org,
 pabeni@redhat.com, robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org,
 horms@kernel.org, corbet@lwn.net, jonas.gorski@gmail.com, olteanv@gmail.com,
 pablo@netfilter.org, fw@strlen.de, phil@nwl.cc, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org
References: <20261116222519.1416501-9-florian.fainelli@broadcom.com>
 <179495816919.3136.9689954625386670626@kernel.org>
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
In-Reply-To: <179495816919.3136.9689954625386670626@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On 11/17/26 15:29, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 5 potential
> issue(s) to consider.
> 
> Critical: 0 · High: 0 · Medium: 2 · Low: 3
> 
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwork
> know by including "pw-bot: cr" as a separate line at the end of your reply
> (one such reply per series is enough).
> 
> - [Medium] Three bcm-ns-fa KUnit cases use plain slab memory as if it
>    were an MMIO register window: fa_test_tcp_control_readiness,…
> - [Medium] nf_flow_test_gc_routes() sets NF_FLOW_HW and NF_FLOW_HW_DYING
>    on every flow, under the comment "Avoid queuing real DELETE/STATS work…
> - [Low] In fa_test_rx_learning() (drivers/net/ethernet/broadcom/bcm-ns-
>    fa-test.c), the TCP sub-case sets `ip->protocol = IPPROTO_TCP;` (line…
> - [Low] fa_test_nat_actions() has three negative assertions that do not
>    test what their comments say.
> - [Low] fa_test_upper_device_rcu() registers two real Ethernet devices in
>    init_net with alloc_etherdev() and register_netdev().
> 
> --
> 
> net: add KUnit coverage for FA and flowtable path validation
> 
> This commit adds KUnit suites for the Northstar flow accelerator, the B53
> FA exception guards and the Broadcom FA tagger. It also adds flowtable
> tests for cached-route owner validation, plus a GC test that covers seven
> route and xmit scenarios. The tests are compiled into their parent
> translation units, and a combined .kunitconfig sits beside the FA backend.
> 
>> diff --git a/drivers/net/ethernet/broadcom/bcm-ns-fa-test.c b/drivers/net/ethernet/broadcom/bcm-ns-fa-test.c
>> new file mode 100644
>> index 0000000000000..59406f84809e7
>> --- /dev/null
>> +++ b/drivers/net/ethernet/broadcom/bcm-ns-fa-test.c
>> @@ -0,0 +1,661 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/* Included in bcm-ns-fa.c to exercise private table formats and validation. */
>> +#include <kunit/test.h>
>> +#include <net/lwtunnel.h>
>> +#include <net/nexthop.h>
>> +#include <linux/rtnetlink.h>
>> +
>> +static const struct net_device_ops fa_test_netdev_ops;
> 
> [ ... ]
> 
>> +	lower->netdev_ops = &fa_test_netdev_ops;
>> +	upper->netdev_ops = &fa_test_netdev_ops;
>> +	eth_hw_addr_random(lower);
>> +	eth_hw_addr_random(upper);
>> +	KUNIT_ASSERT_EQ(test, register_netdev(lower), 0);
>> +	KUNIT_ASSERT_EQ(test, register_netdev(upper), 0);
> 
> [Severity: Low]
> This isn't a bug, but could these test devices get a minimal
> ndo_start_xmit that just drops the skb?
> 
> fa_test_netdev_ops is an empty static struct, so its ndo_start_xmit is
> NULL. In fa_test_upper_device_rcu(), both devices are registered in
> init_net and show up as eth%d with carrier on while the test runs.
> 
> If something outside the test brings one of them up and transmits on it,
> dev_hard_start_xmit() would call the NULL ndo_start_xmit. That could be a
> network manager reacting to RTM_NEWLINK, or an AF_PACKET sender.
> 
> The window is short, and re-running the suite after boot needs root
> through the KUnit debugfs run file. net/core/dev_addr_lists_test.c
> already uses the same pattern, so this is only a hardening suggestion.
> 
> [ ... ]
> 
>> +static void fa_test_nat_actions(struct kunit *test)
>> +{
>> +	struct fa_rule rule = { .direction = FA_DIR_UNSET, .l4proto = IPPROTO_UDP };
> 
> [ ... ]
> 
>> +	KUNIT_ASSERT_EQ(test, fa_mangle(&rule, &act), 0);
>> +	KUNIT_EXPECT_EQ(test, rule.remap_port, (u16)0xabcd);
>> +	KUNIT_EXPECT_EQ(test, rule.action, (u8)3);
>> +	/* Opposite-side rewrites cannot share a hardware entry. */
>> +	act.mangle.mask = (__force u32)cpu_to_be32(0xffff0000);
>> +	KUNIT_EXPECT_EQ(test, fa_mangle(&rule, &act), -EOPNOTSUPP);
>> +	/* Partial IPv4 masks and arbitrary offsets must not be accepted. */
>> +	act.mangle.htype = FLOW_ACT_MANGLE_HDR_TYPE_IP4;
>> +	act.mangle.offset = offsetof(struct iphdr, daddr);
>> +	act.mangle.mask = 1;
>> +	KUNIT_EXPECT_EQ(test, fa_mangle(&rule, &act), -EOPNOTSUPP);
>> +	act.mangle.mask = 0;
>> +	act.mangle.offset = offsetof(struct iphdr, ttl);
>> +	KUNIT_EXPECT_EQ(test, fa_mangle(&rule, &act), -EOPNOTSUPP);
>> +}
> 
> [Severity: Low]
> Do these three negative checks test what their comments describe?
> 
> By this point rule.action already has FA_ACT_REMAP_IP | FA_ACT_REMAP_PORT
> set and the direction is SNAT. fa_mangle() rejects with:
> 
>      if (fa_direction(rule, dir) || (rule->action & FA_ACT_REMAP_IP))
>          return -EOPNOTSUPP;
>      ...
>      if (fa_direction(rule, dir) || (rule->action & FA_ACT_REMAP_PORT))
>          return -EOPNOTSUPP;
> 
> The REMAP_PORT bit alone rejects the opposite-side UDP rewrite, so the
> fa_direction() conflict check is never exercised. If the mask and offset
> checks were removed from fa_mangle(), the REMAP_IP bit would still reject
> both the partial-mask daddr case and the ttl offset case, and this test
> would still pass.
> 
> Would running each negative case against a fresh rule exercise each of
> those checks in fa_mangle() on its own?
> 
> [ ... ]
> 
>> +	tag[2] = 1;
>> +	bcm_ns_fa_rx(fa, skb);
>> +	KUNIT_EXPECT_EQ(test, fa->learn_next, 1U);
>> +	tag[2] = 0;
>> +	ip->protocol = IPPROTO_TCP;
>> +	bcm_ns_fa_rx(fa, skb);
>> +	KUNIT_EXPECT_EQ(test, fa->learn_next, 1U);
> 
> [Severity: Low]
> Should ip->check be recomputed here?
> 
> The other sub-cases in fa_test_rx_learning() refresh the checksum with
> ip_fast_csum() after editing the header. The IPv4 header checksum covers
> the protocol byte, so bcm_ns_fa_rx() drops this frame on the checksum
> before it reaches the TCP branch:
> 
>      total < ihl || total > skb->len - offset || skb_headlen(skb) < offset + ihl ||
>      ip_compute_csum(ip, ihl))
>          return;
>      if (ip->protocol == IPPROTO_TCP &&
>          fa_receive_tcp_control(fa, ip, total, skb_headlen(skb) - offset, tag[3] & 0x1f))
> 
> The learn_next == 1 expectation therefore passes because of the checksum
> guard. fa_receive_tcp_control() and the TCP learning path never run in
> this sub-case.
> 
> [ ... ]
> 
>> +static void fa_test_tcp_control_readiness(struct kunit *test)
>> +{
>> +	struct bcm_ns_fa *fa = kunit_kzalloc(test, sizeof(*fa), GFP_KERNEL);
>> +
>> +	KUNIT_ASSERT_NOT_NULL(test, fa);
>> +	fa->regs = (void __iomem *)kunit_kzalloc(test, 0xc0, GFP_KERNEL);
> 
> [Severity: Medium]
> Can these fake register windows work on the default KUnit architecture?
> 
> fa_test_tcp_control_readiness(), fa_test_lookup_gate_preserves_tags() and
> fa_test_invalidation() all point fa->regs at kunit_kzalloc() memory. They
> then call writel()/readl() on it, either directly or through
> fa_lookup_update():
> 
>      writel(enabled ? ETH_P_IP | ETH_P_IPV6 << 16 : 0, fa->regs + FA_L2_ETHERTYPE);
>      readl(fa->regs + FA_L2_ETHERTYPE);
> 
> kunit.py defaults to ARCH=um and merges arch_uml.config, which sets
> CONFIG_KUNIT_UML_PCI=y. That selects UML_PCI, then UML_IOMEM_EMULATION,
> then INDIRECT_IOMEM, and INDIRECT_IOMEM_FALLBACK stays off. The raw
> accessors then go through lib/logic_iomem.c, where get_area() does:
> 
>      if (WARN_ON((a & IOREMAP_MASK) != IOREMAP_BIAS))
>          return NULL;
> 
> The fallback read then WARNs again and returns ~0. Writes WARN and are
> dropped.
> 
> On UML, this would have these effects:
> 
> - fa_test_lookup_gate_preserves_tags() reads 0xffffffff for
>    FA_L2_ETHERTYPE, FA_CTL and FA_BRCM_HDR, so its expectations fail.
> - In fa_test_invalidation(), lookup_stopped = !readl(...) evaluates to
>    false, so that check fails.
> - fa_test_tcp_control_readiness() emits WARN splats that taint the
>    kernel.
> 
> The new drivers/net/ethernet/broadcom/.kunitconfig enables COMPILE_TEST
> and does not restrict the architecture. So running kunit.py with
> --kunitconfig drivers/net/ethernet/broadcom seems to build exactly this
> configuration.
> 
> Should the MMIO-dependent cases be limited to architectures with direct
> MMIO, or should the lookup gate be observed some other way? Also, the
> BCM_NS_FA_KUNIT_TEST help text says the tests "do not simulate table
> I/O", which doesn't quite match these cases.
> 
> [ ... ]
> 
>> diff --git a/net/netfilter/nf_flow_table_core_test.c b/net/netfilter/nf_flow_table_core_test.c
>> index 378a1c60b50b9..5c7645239d2e4 100644
>> --- a/net/netfilter/nf_flow_table_core_test.c
>> +++ b/net/netfilter/nf_flow_table_core_test.c
>> @@ -72,9 +72,94 @@ static void nf_flow_test_hardware_retirement(struct kunit *test)
> 
> [ ... ]
> 
>> +	for (i = 0; i < ARRAY_SIZE(cases); i++) {
>> +		struct nf_flowtable table = { .type = &type };
> 
> [ ... ]
> 
>> +		flow->ct = ct;
>> +		flow->timeout = nf_flowtable_time_stamp + NF_FLOW_TIMEOUT;
>> +		/* Avoid queuing real DELETE/STATS work from this private GC test. */
>> +		set_bit(NF_FLOW_HW, &flow->flags);
>> +		set_bit(NF_FLOW_HW_DYING, &flow->flags);
>> +		set_bit(IPS_OFFLOAD_BIT, &ct->status);
> 
> [ ... ]
> 
>> +		nf_flow_offload_gc_step(&table, flow, NULL);
>> +		KUNIT_EXPECT_EQ_MSG(test, test_bit(NF_FLOW_TEARDOWN, &flow->flags),
>> +				    cases[i].check, "GC path: %s", cases[i].name);
>> +		flow_offload_route_release(flow);
> 
> [Severity: Medium]
> Do these flags actually prevent STATS work from being queued?
> 
> In the "software direct" and "validation only" cases (check == false),
> nf_flow_offload_gc_step() skips the teardown block and reaches:
> 
>      } else if (test_bit(NF_FLOW_HW, &flow->flags)) {
>          nf_flow_offload_stats(flow_table, flow);
>      }
> 
> That branch does not look at NF_FLOW_HW_DYING. Inside
> nf_flow_offload_stats(), only this timing check stops a work item from
> being queued:
> 
>      delta = nf_flow_timeout_delta(flow->timeout);
>      if ((delta >= (9 * flow_offload_get_timeout(flow)) / 10))
>          return;
> 
> For this ICMP ct the timeout is NF_FLOW_TIMEOUT (30 * HZ). If the test
> thread stalls for more than about 3 seconds between setting flow->timeout
> and the GC call, nf_flow_offload_work_alloc() will record:
> 
> - offload->flowtable = &table, which is the stack variable above
> - offload->flow = flow, which is kunit-managed memory
> 
> This could happen on a loaded QEMU or UML host, or with KASAN enabled.
> flow_offload_queue_work() then reads table.net, which is NULL here, and
> queues the work on nf_flow_offload_stats_wq.
> 
> Nothing flushes or cancels that work. Could flow_offload_work_handler()
> later run against a dead stack frame and freed kunit memory?
> 
> Any of these would avoid it:
> 
> - pre-set NF_FLOW_PENDING so nf_flow_offload_work_alloc() bails out
> - leave NF_FLOW_HW clear for the non-hardware cases
> - flush nf_flow_offload_stats_wq before the objects go out of scope
> 
> Separately, NF_FLOW_HW is set for every scenario, so the GC step handles
> the "software direct" case as a hardware flow. Does this still cover the
> "ordinary direct software forwarding" scenario that the commit message
> describes?
> 


[Medium] fake register windows

Agreed: UML rejects plain memory for readl()/writel(). v2 skips those 
three cases where MMIO is emulated (CONFIG_INDIRECT_IOMEM); they still 
run elsewhere, and the Kconfig help is corrected.

[Medium] GC test queueing STATS work

Agreed. v2 only marks the flows that GC tears down as hardware flows 
with their DESTROY queued, and leaves the others as software flows, for 
which GC does nothing.

[Low] NAT negatives, TCP learning sub-case, test netdevs

Fixed in v2: negative cases use fresh rules, the checksum is recomputed 
for the TCP case, and the test netdevs have an ndo_start_xmit.

pw-bot: cr
-- 
Florian
