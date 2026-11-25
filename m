Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795643749;
	b=gZlhV9VkLzJC1KY+gFE7paPlS5UZ0qRpk1G9On7hB4WNHRKvuFvjZTXAyz/4cmi8GMKn
	 Ot9boKLYPHDrXU0nMr8MyF8bHgBufT7/Jcx5PZ2K3NXfQYuX8rc3wU/KsPnF2mFhqMI1q
	 6bnSzwWHF2//T3FAxMuuGUK/Eqimjp5dyVKeKb5Z1g11Wu8SLcBlhisavlKfhkoBfLtds
	 MndGjl6j/fQJKVyiTwNRYIqaSeRe9BjaAsbP4Zbbuid4ObDdLntLVDhzaY5O11XB52YT5
	 lc1uI0BQ1s938ay7E9oFXfhgYqrrUjGO5SvnQ8ZbMGh+cprOpZlwMKRu1OqkfHgG+nQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795643749;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 Content-Transfer-Encoding:MIME-Version:Content-Type;
	bh=r/GY1L0M/Jj/tnpXLztwrdoGc8kg+51R6Plf4ICZ1dQ=;
	b=CU09WBvtm8zBCMrj5aEl88oLUeXmwPCFIdbE7imYC/u5EDYtUuRcPfac8+ZZI/kUsdrX
	 tGN2TwAZHt9OR4Okc11VwJBp8BCt63KZKOzkZvyBVPgg9v5GX0ShLrYP4zzSZ7lQsqphw
	 EzsbeLEka/nlhs1Z4abzYa68hz3bO7z/pKaAhl9sP225bSTwQR75DKtoVOLSDiw2Az0MO
	 Zcr59lHM1gSQZoNls1XZ5oHpJILwsoH5C/rS6DdVBpj/b3CyEfSQJrGFE/kHyeBgiMteJ
	 wIlQKlPChuQYXpdU3jg/FZsv/WmOb6lVsRKawtxzu4QmJZsHfE9XIaimi1KxztkPm1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="R9/rbOd1";
	arc=none smtp.remote-ip=209.85.221.53
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F73E606A31E
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Nov 2026 21:55:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8F73E606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=R9/rbOd1
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-4a7b8abe209so4887098f8f.0
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Nov 2026 13:55:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795643748; x=1796248548; darn=vger.kernel.org;
        h=content-type:mime-version:content-transfer-encoding:message-id:date
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=r/GY1L0M/Jj/tnpXLztwrdoGc8kg+51R6Plf4ICZ1dQ=;
        b=R9/rbOd1mzzJwriho6oqu3CgC7K1wSlhXe9zeuBxmFvrEDJLsbJoEnk8sCgoc6cYsC
         5EALMtdGI5m13pWRUFyc9uNG9bQEXiDQGldI/blAVQj5EuXkESLqrcf7obe0PPkPb6lc
         jrR7ca1lWajN38Yu8/44Puy170gP+ANH29Qvz49gu8S/jVkfvocflfkB4V/Jd5CVvaBI
         rfK4//0M452A+GFovixi5kSLnULRU1gFXDdt2Zm0ATaGwbNuf26MuQ4VIg+AfgJ3b8H8
         YlhboLSrWvXvSrSKb1xIUjsVCol3049mQf32029TwiC9KjNK9iegXnvepXPp6kEHvk42
         HPPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795643748; x=1796248548;
        h=content-type:mime-version:content-transfer-encoding:message-id:date
         :references:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=r/GY1L0M/Jj/tnpXLztwrdoGc8kg+51R6Plf4ICZ1dQ=;
        b=NIw4qKJVJ2UC2BH5FD7fDxjOwueglAojd2cAkR+BXHnn+S3NUmoA8TgL8tOOPGaeaA
         EwMWSc7SXeZQc//UYPXsxFISRM/8bOxvgU2OiZoe4hj3VeGnz+3WJz9bpYcje0w/c4DA
         gIHvLWpPnoGn5r0K/xQonP/3nT58y3/r5zPpZuqXl2ix2Dat6+aBQHbYN4gnUjDw4jAg
         F3yX9yIW8CsxNM2qDzO7zUTfVBcU1PlTBAUJqpPlkrdgiTHDuAhYitTPTzPzMXx4rJPE
         4tAHTCJSi1nPraOf0+mX3KHoL9ayqARu1OOgeRVnmpvw8ohO0ac1erA5qwPH560TuD4P
         tcDw==
X-Forwarded-Encrypted: i=1; AL+hErG2J5VEDVjTsJnKm6L4fOC5NSz0juSCVgttYIskWmomcyKQ5eCXaZ2X/tH9sZHeeIaw88DMd9He3p1RyngbXTE=@vger.kernel.org
X-Gm-Message-State: APuU4Z/tV7+L8O91g7K5IIonT3mO6VeUSfOz+49am0wapLLIN2cOkY4X
	hnFkripEt2XeK9yZ5jJF/VgLABrmjow68+zVkJMiL5uhNotl9B2wdL93
X-Gm-Gg: AZFdTZc6BiPQqINFBttC0Kaw+pvyMUFepNANWlP9JMHmuW13Gq0WQaFC8Z7vaLQbeL+
	P6Hm7FtlnjNQPnQ2j1oWJYndMeADzGDaID/Px+WCv9Jij1WDIEro3G0mCNHHku0oPuPU5ayorBF
	L/v5T9CBfXhRTSstsdan7d3NY6IzL6M7JEWnKp3NpZ/Xu/M96raudznmzoWykCL/bNJ2I3CfZN8
	aeK33Ne6wL8Y9zLXGnIsXQuNDQgqlN3oXF6FEvJ44DhLf4D6mFNs+JMnFERE4akuuQGI48kYXZP
	1HdExK13q+rjHVRis9izUqeBLjDwvi0FYo2D/x+pF1ZcO6TPNimbpV7Msyg5mHJG9xV4dUbPBA/
	fPu/Ugm9mauuEpb3qDqbaGVtgHrsrzWWRqrgZKpvbo0XRv0ZbmAkiiJKFS+QBBftqFtVa0Qutyb
	BCxtDQFJ4UwmIN1P8IF1EHXc4oIjDn0X8vL2D8rlb9j10T4ziq60if/neGICsAMoVbvYYvQfYO8
	mzIUcPRjdCbCE+41dQllNgPW3+eXnC/C6miuuh0eCtur4ErOECfAIdbOL3W48hZrh+KudZEjSSc
	aKebTTD7SP6eqfDd01Y0osGcABWR+ZM5A2c9lqMvtqq8SECA9a1h2UQ=
X-Received: by 2002:a05:600c:8b11:b0:4a1:dda8:eb73 with SMTP id 5b1f17b1804b1-4bb8881c630mr403408355e9.27.1795643747772;
        Wed, 25 Nov 2026 13:55:47 -0800 (PST)
Received: from [127.0.1.1] (ip-024-180.users.dtel.ru. [91.210.24.180])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb884865a2sm566394855e9.3.2026.11.25.13.55.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 13:55:46 -0800 (PST)
From: Fil Dunsky <filipp.dunsky@gmail.com>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Vladimir Oltean <olteanv@gmail.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
 Conor Dooley <conor+dt@kernel.org>, Florian Fainelli <f.fainelli@gmail.com>,
 Simon Horman <horms@kernel.org>, Pablo Neira Ayuso <pablo@netfilter.org>,
 Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
 Hans Ulli Kroll <ulli.kroll@googlemail.com>,
 Linus Walleij <linusw@kernel.org>, Russell King <linux@armlinux.org.uk>,
 Christian Marangi <ansuelsmth@gmail.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>,
 netdev@vger.kernel.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, linux-arm-kernel@lists.infradead.org,
 linux-doc@vger.kernel.org
Subject: Re: [PATCH RFC net-next 0/7] net: cortina: CS7542 wired IPv4 hardware
 flowtable offload
In-Reply-To: <7252b836-e375-4550-90c9-b0e3ab7fbb6d@lunn.ch>
References: <20261125-almondplus-offload-rfc-v1-0-703175c6340c@gmail.com>
 <7252b836-e375-4550-90c9-b0e3ab7fbb6d@lunn.ch>
Date: Thu, 26 Nov 2026 00:55:27 +0300
Message-ID: <179564372798.5.10006827612276789857@gmail.com>
Content-Transfer-Encoding: 8bit
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="fixed"

Hi Andrew,

This is the first standalone offload RFC, v1. The prerequisite CPU-only
Ethernet series is v2; this RFC does not replace that series. I should
have made the relationship and architecture much clearer. The next
revision will carry an explicit v2 and a changelog.

There are two separate chips on Almond+:

  LAN1..4, WAN
       |
  QCA8337 external switch (existing qca8k DSA driver)
       | CPU port 0                 | CPU port 6
       | RGMII                     | RGMII
       v                           v
  CS7542 GMAC1 (eth1)          CS7542 GMAC0 (eth0)
       \                           /
        CS7542 network/forwarding engine and shared DMA
                         |
                        CPU

The proposed CS7542 Ethernet driver exposes two full Ethernet netdevs,
eth1 and eth0, despite sharing the DMA engine. Those are the conduits
for the external QCA8337. I am not modelling the CS7542 forwarding
engine itself as another DSA switch.

The CPU receive path is QCA8337 -> RGMII -> CS7542 DMA -> eth1/eth0 ->
DSA tagger -> lanN/wan. Transmit follows the reverse path. Ordinary L2
switching remains the existing QCA8337 driver's responsibility.

The accelerated routed IPv4 path in this RFC is QCA8337 -> GMAC1 ->
CS7542 FE lookup/NAT rewrite -> GMAC1 -> QCA8337 destination port. It
bypasses the CPU DMA path. The frontend accepts standard nftables
hardware flowtable requests through TC_SETUP_FT; it is not a new L2
switchdev implementation.

This explains the QCA changes in patch 5: its optional four-byte CPU
header adds an identifier before the normal QCA metadata. With the
identifier set to 0x8100, the CS7542 FE parser can locate the inner IPv4
header. It cannot do that with the ordinary two-byte QCA header. The
new tagger therefore describes the external switch's wire format, not
a DSA interface inside CS7542. Header length is global to QCA8337, so
both CPU ports must agree, although the present accelerated path uses
only CPU port 0/GMAC1. Management uses MDIO in this mode.

Your patch-2 comment is also correct: the unrelated blank-line changes
in include/net/dsa.h were my mistake. I have removed them locally;
only the two protocol-ID additions remain. No replacement series is
being sent while this discussion is ongoing.

Thanks,
Fil

