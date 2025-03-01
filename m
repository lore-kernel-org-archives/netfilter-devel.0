Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 365E135971;
	Sat,  1 Mar 2025 15:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740844060; cv=none; b=pdlOrfA2YgY1TTqTR9Z27VVw6yB5ghWk/VTX5wjZXTeMZj9jqWHfN2/x77wKWBQxPuXo8HRGzUkNPUA86CVGdbe3oztYvDYBPib9jZKpPVEzruQ40+D8OCyqFfFWBtGSItY3xuNe/dRWhkB7lnGk5UIqyIKtUCH57W5OK3Dl2aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740844060; c=relaxed/simple;
	bh=qaYwzM0tPLZWBNtMZwEjySSIGmwDhWL+JeN07b9+R70=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c1lkKMLyUCSBYmSKXItlTf0wwA+xdHmvK11XrUo9vuMGguPF2SW376l3alieSJCJVSUyPxwdl/NsMfrv/ndGlTephXITWQmnL7Nhtz73KfNJoD4Onwb/i61rQlu6Xilbpp5Lv5lVNnJ1WzSS31/brc8MxXqqUftOGghoBQNNN1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PihMv54q; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PihMv54q"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-ab7430e27b2so529128666b.3;
        Sat, 01 Mar 2025 07:47:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740844057; x=1741448857; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pvcp/Ow9PKUt0GAoY+iQqvy3UdZ1k/popr5tmmzvjdw=;
        b=PihMv54qMAT6tRv6Iyp0TGc1+p9MzOjOc/vVPs4jTYlvy+fFL6ARWQjnQbJoB9NHTV
         MZRwo+y9gn5TIMErHDSzX4eDUgFVqwMwXm3zUUT9TF7RPVpxLUyqdQentt79D4EjgUoN
         t1Nepo7h2Ek3F3AMfZVnv48v+DjCBT6xnJGinEkzE5NEUwC3KG4hHNJ/MADG1Dw/MneV
         4UWz1/iPtMdrCsUdHFuUDPpNIC+qE1v/X2VSHi3VAXXhj4OFqhWR73EKgo/oTzudw3Cn
         cobAYjxK3cQBVogUhM11NtNsatL3GhtXU1NzAy8Gu6Y+Om0fzjMiKspVURCu2Fr9ki5d
         PfvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740844057; x=1741448857;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pvcp/Ow9PKUt0GAoY+iQqvy3UdZ1k/popr5tmmzvjdw=;
        b=qUwk3BbXbDJD3JcwCqJrXyzAfAgQVGPmY3uNXuWz1HkSceBP8CkMftXE/b4L1dG+mb
         UiFcaGfvz0On6kOeBeWmwrANGM6qr5gNp96EDcna5YvNOsklrBjdcgnn15h+P6lGV6y9
         1kF3//XvSkMp4K6AED2vevcBTFKbTdzegvdlkkBp5Upg5Vpu+Ii/OxAlHZNHvH7hoAGg
         G6TuJ8TnA9dV/V6tE7+DCcOwvnDrlMSq4FnGYeY5TWURlkipssxMyw7bWqX1xDV4W8MI
         innGHhmJY+wgRZMIB+MwXlzsTSD+Q5I1xrASc8quZlqcCi1w/+jBhuboobjHKyDqhXBW
         4P4g==
X-Forwarded-Encrypted: i=1; AJvYcCV48j9TLc8ThyXTUKB50idw5FXFp403XVFuWpFZqcunVor2yp97qLPFqkTAfCw4CGZRfPc7/dd+8w4ZSPs4XUz1@vger.kernel.org, AJvYcCX9cb08MTLRg6X92+Zi0O3T7CDKZuQQ9ekNRcBnyA290B8hgfN2Jsd8BCFeD22LPMu/jls/3jfCJ7xRliMc@vger.kernel.org, AJvYcCXtlRk6/MXcq0C2rUCdBIJfqwlk8OM4yfSAiU0scvYrmBaTCkGRQQPHcFI80xaoaNjUKYBKxU6aZu19u+6SWX8=@vger.kernel.org
X-Gm-Message-State: AOJu0YztyTqUs35ERtd51dgcx1XxBx8wIcKR7EA3rw/XcXF4+jgRDWj+
	8yFZwctPeaJcOVdpsIUyDXb0dbax4Zqvq1tVnK7aE3yp69jaXplf
X-Gm-Gg: ASbGncvWQ2/Lw9cDag0GSAh05ZTw5cBwy17nnG1E/RTwpjsHxikXIXmYMqi+Ugz5fyL
	aplN+TYN49DGJTTu9stR/MjN6WHpDdcIvYX/6Cy6wM9cSlay07cN5hsMgtPFoQ7CeaV4bc/EyU8
	NLiIYctNVPn1qTkKOOrpIXK98BH381rcg6X/ctQNuHj0oD3mqKeQ0YAU1C9AGUI/L1L53BLHTSO
	dE3NfaEAjkjH0Jy6NY9NtKccnICkbe5e8uzyxw5z95whK+s0E5vretK9QpUgELs2YJ2nuUGJgMe
	UiUMTQhDpcHmrXvmBTcoaDtTgGZrkQi6lCzEQXZjK7D7JW7/0n7uVyfy0LBR56QhQXPB3KoNqRQ
	qKqTi717Ijc/epfg0py4Axwvi4PJ/t6y2cGc7AHxrcM+Hujvzu60ckirVMe8/naCe6I0UNDXnIU
	ZQpZLXv3enfx18FWic06Y=
X-Google-Smtp-Source: AGHT+IG+eqrFeyO3A7KDD2S5BrzG0fkxCUE3rRFtAlmdPlWrBAor9q1vffWfk9dSAf3TW6qzlDGFvA==
X-Received: by 2002:a17:907:2d8c:b0:abf:4c5f:7546 with SMTP id a640c23a62f3a-abf4c5f7590mr317216866b.38.1740844057241;
        Sat, 01 Mar 2025 07:47:37 -0800 (PST)
Received: from ?IPV6:2001:1c00:20d:1300:1b1c:4449:176a:89ea? (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5e4c3b6d252sm4287355a12.26.2025.03.01.07.47.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Mar 2025 07:47:36 -0800 (PST)
Message-ID: <fc5129dd-35a8-4bcc-8e54-b8facda2cbc4@gmail.com>
Date: Sat, 1 Mar 2025 16:47:32 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 net-next 01/15] net: pppoe: avoid zero-length arrays in
 struct pppoe_hdr
To: Michal Ostrowski <mostrows@earthlink.net>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, Pablo Neira Ayuso <pablo@netfilter.org>,
 Jozsef Kadlecsik <kadlec@netfilter.org>, Jiri Pirko <jiri@resnulli.us>,
 Ivan Vecera <ivecera@redhat.com>, Roopa Prabhu <roopa@nvidia.com>,
 Nikolay Aleksandrov <razor@blackwall.org>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Kuniyuki Iwashima <kuniyu@amazon.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Ahmed Zaki <ahmed.zaki@intel.com>,
 Alexander Lobakin <aleksander.lobakin@intel.com>,
 Vladimir Oltean <olteanv@gmail.com>,
 Frank Wunderlich <frank-w@public-files.de>,
 Daniel Golle <daniel@makrotopia.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 bridge@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org, linux-hardening@vger.kernel.org,
 Kees Cook <kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>
References: <20250228201533.23836-1-ericwouds@gmail.com>
 <20250228201533.23836-2-ericwouds@gmail.com>
From: Eric Woudstra <ericwouds@gmail.com>
Content-Language: en-US
In-Reply-To: <20250228201533.23836-2-ericwouds@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2/28/25 9:15 PM, Eric Woudstra wrote:
>  drivers/net/ppp/pppoe.c       | 2 +-
>  include/uapi/linux/if_pppox.h | 4 ++++
>  2 files changed, 5 insertions(+), 1 deletion(-)

The maintainers email: Michal Ostrowski <mostrows@earthlink.net>
Returns 403: 550 5.5.1 Recipient rejected. This mailbox does not exist here.
