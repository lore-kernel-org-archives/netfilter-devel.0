Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795538055;
	b=Y+qH8hXm90lmRybo/zd4JxqSFtcwUnqFDKDlwJ/QoYpT3gHKZD4ZgOKkRD8X8lC9f7W7
	 F36TWAdNNvaXGLDQsHJ8cted9IOH6rNTT4FpXhvtJor5SX7pEg+s3Wd0tiq6J9NduWq6t
	 tDvkTcVvC+1CF2moR4bJdCRaEAtEfMCfEI8IxXXzLn1fJp13cadLvRhqoOvb1E9LV3Ax6
	 o8r7lm4Gx5Vp+wj3y+F+rdTyWRQCUd7yT0xBybmoAOpJUAyqMV8K9zcvbAdK2O/64zpti
	 e74p59fA/eS0MW7himiHfsQ69iu9vxiLzl1X+0SmJO7uY0rhlsEv4d2y7XyDPGHaBzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795538055;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=GoOWhhjKU5jVvvb8PvpAssAoe/TXzv/lHdPf2JDtI9Y=;
	b=LANqRYipLFxBqfCjv2eoClWubDuF4pFMbA9f7KVhCSayr1qsbMppjnz5h5cnSjNk1U4M
	 St8hfSWcxTspi/qLoa/WE17w7vUZaQUoyi8rtnxC6bM7Bpdq7bCi90OfE/qES3b1HVtw0
	 s/9GeTxvQx0j+88U6jqGzv8E1JwnkntAmwFrix7IVlkCb5mXwqXFMGnzQf8cY2ESt2cPf
	 t33/BXyCXajgJ857fK0VW2dhUJIfEtiwrwPAUR7q1TzeEBHNz/nGkBfYgcrpFDYfoq4lO
	 qBZ7GFY59X0KYOKvHhzEY+bMdm8e1krBWuqbordzD1SWRQBGkJYyqW3d71uUq4PKrxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=X9gP+Bjw;
	arc=none smtp.remote-ip=209.85.218.46
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F4AB606A332
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Nov 2026 16:34:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2F4AB606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=X9gP+Bjw
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c5126505cb3so612032566b.0
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Nov 2026 08:34:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795538052; x=1796142852; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=GoOWhhjKU5jVvvb8PvpAssAoe/TXzv/lHdPf2JDtI9Y=;
        b=X9gP+BjwFvdjp4nbrN+RJe1zYuYsPTY+injwk6vhdwJHQEdWgjvqONAhiaJTzkJSgp
         crXw765euWzGINDrXLCuP+JvDxCqTHBEapC8UZ+b5ibfZ1EBiVhdMSbkQ/Gc0L0ii3E8
         bKcGFd63aHakPXEKko+UFdnU9eq56HPPIei87a+kpPFoO7Yoargi1FK4me6mrUZeOmX5
         K2thSLMtjc4G7VY/+G1xaB3YZkzz3a4XKJobKZoEVmIfugGMZjfMy4fH1hF08Mbha1Q7
         y/BuZwm1JyEbnz1s7z7gLwgOGPktcYG3Wu0o8z0+qYhiQ7p9eNcepWt6NvtMXt7vV9R9
         +zHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795538052; x=1796142852;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GoOWhhjKU5jVvvb8PvpAssAoe/TXzv/lHdPf2JDtI9Y=;
        b=PVPJAlPOdlGTqz39c7h5BGMzEHjpDNCbpHSTstEn11CS6geuDDvjFCAvpFfssCMHKY
         oNRZcRCFlJvLgAM11e7efj7VrNwJkEb1QVwKnZC9tb4oTJaM5v5BOA6wd3B4AYwyBLU2
         JyEwyTJMGG6wHvy60fuqMoAJ9cBXt+L6UCd2Q7ngKkDfF7+hMs8Q8YEu0V+ArsTzaGQW
         RJUjLqVfifqvILPzW2zZNaZxFxdIemppEdZ9CVhYJwKqRdY03Blb6sQm5zE7TNczDfKq
         /wzactNWhsVnA7/bsqgijusMVS4VUzrr+idCSep7bGmkeP5ONId7U2XpzMuKGjRdv1mo
         gq7g==
X-Forwarded-Encrypted: i=1; AL+hErFSrHqQtxFUvsAwJgM81Od6z4Rb3Oc+ztF+JjdMj31JIDk2mhChqV67to8Lve/GdQDZV+GfZfNtvb06VLc+8hA=@vger.kernel.org
X-Gm-Message-State: APuU4Z9wc72kthpck6AViLJt2q9ol0G5pX0xYpDpBXmTJnYk2oljiIp6
	a0SJhrIHQJmXy9TygarDT6nxILUnT6JIaWoX2Qu7HDXHvYW9dHdWNKA2QYdJ89VKRFWmS0VX
X-Gm-Gg: AZFdTZdLYi8ttmUEGnhsswCAg/LNqfMBfso/0fxeLuG5Yk3U8uqOBJh26HW9piYrVnd
	fxbKab+sll+CLJ7xK0vObBXZ8q4JcWJWwHbrlaKgW4m60Io0Aqb5iFE6ZjLtylmuwnLuZRGQM83
	WBTk90z7E3pdt/9NDK0ABJ4qKrlfyqqYP5iPo7508eWFJZAoBTckt/UtLdvRQ7S9gPLsux6GkhH
	CUvQW+GnwI5p7CJ9O2xB6PcEHJ+bt1myi1XZRF/lR+8ZtK/iEVHhvDOVKY3XMssBDYWK5nRlutj
	2h58h46j4a2KTBWmTqMHyLPitLn/4OiryRoM6HXFs+x4vbY3pjNOI2amm8wRq7ugqfSrk/3jjtI
	xQlOJvCcE1qHTYoHbDEGln9VSEZf7hiSwWscgYe+6tKnvDP1CzrgOdXOoex4JlbKrHWHeYe5TLX
	UciOqeLPLA3A0mNGrq8lOM2yczelvNrwCISoFgAoy88TWs1TBr08d3JfOIbVyNBqpyw0BK4Pe8t
	cjPFYPH9eAH8d4RsaObn+xW98bkHB1KSy1du8D9KZgLfeT0m0k0FmG992Jv7rygJ/0b8U/j1VYr
	wLn72/seFU+Xt8Nw9XfNScE4TB9q+30JSEG4Q4X6H0GsvSV6EpDEgIYXt99D0Tg+oJId6Wgy9R5
	0
X-Received: by 2002:a17:907:608c:b0:c2e:6a4f:a88b with SMTP id a640c23a62f3a-c513a1f5c8cmr1281794066b.0.1795538052292;
        Tue, 24 Nov 2026 08:34:12 -0800 (PST)
Received: from theodors-laptop.dotcomltd.ru ([5.255.118.7])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c513afeca8dsm542032866b.75.2026.11.24.08.34.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 08:34:12 -0800 (PST)
From: Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>
To: "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>
Subject: [PATCH net v3 0/2] net: do not point a pskb copy's mac header into uninitialised headroom
Date: Tue, 24 Nov 2026 19:33:56 +0300
Message-Id: <20261124163358.755345-1-theodorlarionov@gmail.com>
X-Mailer: git-send-email 2.34.1
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

pskb_copy() keeps the mac_header offset but not the headroom, so the mac
header of a copy of a received packet points at uninitialised memory,
which nft dup can hand to userspace. Patch 2 unsets the mac header in
that case, as Florian suggested on v1.

Patch 1 makes nf_dup skip skbs with bridge netfilter info, as Florian
suggested on v2. It fixes a second leak, where a tcp reset reject of
such a copy builds the RST's Ethernet header from the same bytes, and
it has to go in before patch 2, which would otherwise turn that reject
into an out-of-bounds read.

Patch 1 also stops dup for packets that come in on a bridge port and
are then delivered locally or routed, because br_netfilter keeps
SKB_EXT_BRIDGE_NF on the skb until the bridge transmits it. Is that
acceptable, or should nf_dup keep duplicating them and call
skb_ext_del(skb, SKB_EXT_BRIDGE_NF) on the copy?

Found with a custom syzkaller-based fuzzer.

v3: add patch 1; without it, patch 2 turns the tcp reset reject of a
bridged dup copy into an out-of-bounds read in nf_send_reset() and
nf_send_reset6(). Drop the nfnetlink_queue patch, since nothing
produces a bridged copy without a mac header anymore.
v2: fix in __pskb_copy_fclone() instead of nf_dup; add the
nfnetlink_queue patch.
Link to v2: https://lore.kernel.org/netdev/20261117175835.745796-1-theodorlarionov@gmail.com/
v1: https://lore.kernel.org/netfilter-devel/20261116105113.128791-1-theodorlarionov@gmail.com/

Theodor Arsenij Larionov Trichkine (2):
  netfilter: nf_dup: do not duplicate packets from br_netfilter
  net: unset the mac header of a pskb copy that points into headroom

 net/core/skbuff.c                | 2 ++
 net/ipv4/netfilter/nf_dup_ipv4.c | 6 ++++++
 net/ipv6/netfilter/nf_dup_ipv6.c | 6 ++++++
 3 files changed, 14 insertions(+)

-- 
2.34.1

