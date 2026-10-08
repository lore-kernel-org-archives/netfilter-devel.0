Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71DCB493D34
	for <netfilter-devel@vger.kernel.org>; Thu,  8 Oct 2026 10:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791455635; cv=none; b=NKYFqcRYHlSr1k2oFiB8fEJvI1N6gkCtaQl58fSuFbHWdtpj8zeXS33U+aTCniOx1Fl5h3fsuyptxL4yzHGOvA63JYzS3fVaxdFjtDVn3oB5Mx9CqNsgIL1ldPF0LU/ZHr0f/uOr6FD21pEBmgLwDZ64ZI2Kkp0C+c3kg/sINiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791455635; c=relaxed/simple;
	bh=f9EU9lpUu+/Hd28ONBx8yVQoYudni+L/QY0cWBEO2X0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=orH/cw11uKVyt5ZxjbAF2TXT0C5OlLbWbCFjrgUxQGZj/bFnwAUbs92jQLSyzNURV5hk5ZjU9JqukkXiFLKFK9N0uurNqwBj408g1KfBMqfj7aFtIYTKpirNt78hNb2fqQJ2su3JHZQKfaNTYwEptAEP9sAG77b4Yuc0/U5b/r0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=VVymuIYF; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="VVymuIYF"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-88b8f0a1bcdso2135775b3a.3
        for <netfilter-devel@vger.kernel.org>; Thu, 08 Oct 2026 03:33:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1791455634; x=1792060434; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ITBAg9o68VKufDfyF8aLlT91gDf6Whfp01bKJ7g5XYY=;
        b=VVymuIYFlkk8FfJGNwlyds3xUTgj05KhuP5oM3xOTgeAainuZtKsGLwsFM/J7m7Bgk
         GINALdwfSVmMvwKlPyqJLOtx0wyhNs/kBgQRsdnPnPDwMqfFC1p/ybhAJtzJapFDWsxG
         u8V8RYPNgcZOeHmD4mMqvkTO6lz+HIqjfwSl4FXTVpACd65SnR1E/yIbGpthhknBolP2
         t3o+irpX5kEW13NcFrTq5Gyz5WJ31tZYkFtBxuK9HAH8QDsdR5bUMqbLxfh74VnRufEu
         e+mrUFpKxF37vK7SRs9FPSyaX6pVXp4VrdoqnJJUtoAOy7jrxLhyCiB4t0pNdiheg7x8
         Y5IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791455634; x=1792060434;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ITBAg9o68VKufDfyF8aLlT91gDf6Whfp01bKJ7g5XYY=;
        b=hd7iHk6DR+rtUHJDg0/jvmQpHYwNzUXfoPMqhp6KS1359YyGuc9XudfBel3tYo99Fv
         r4dAxuQOzpcwvDopCDnJQazwd3od8I/z4oMGmEGNn0mPhq2i3xjCY+mkOHjIWUgRIi+4
         upNlyMZjaQaZAXqllds8bCpeY7O0Y5g8AhH3RBc4VwLUW4VPss4vDintqUPA48kapzxI
         4hKoteDtnvJFJqNJKkQT/+8JiWIE+fS06Q2QCg2f0XZOHvwaIlZW7iZEgqmT1Jcj4GXQ
         CNcw7bx8zJP/D4TLUZfLGEUOANMvHPudNnfP37gpjEBiNrvPP+xHHT1m2XCa/S2P4lZv
         Kvyg==
X-Gm-Message-State: AFuF++mf52d2JGwHGY6CJy8q1kpOccbMmBD21UB7skmWpDH6YWNhdHmV
	nqeYyOHWKaOeqYFSge3gz9mINdOjTxZI5ctNhwjEUEvrkqs3OHsAHOJa+e8WeVIoFq30VT49eMd
	bEdwoFNKj
X-Gm-Gg: AYBFou2m4Rm1WAZ3GvUeO5vQ1PhWY/YmRdaq+qeWM0E+1LP+vXeoFj2HR3kYSLq+vZc
	cQVi0hSuOIaYiIKV2CSOy8yAr96m9qLDEPoWfgS0SHcB7P6/5oMBZUx/C/s0aC5ea8vkqwgerU5
	Lvt3nVYeactRJrkmzkMHII33k/7CCRovWTlWP6l2Ub13pywnbqCZhL+Qbj0H3/T//zB34FOAAd6
	1EZfmQW1IOt055nZezhANaQuSj2+MJxw974HFkt/fvQZ4vMd7SUVpeHXQyOabnjhv6/xXGUuySU
	mnRt3WExLAzH5xADRwmbmuv/OKQtqdc4/ubxVPdBb3lDnTZBLgXYbuXxYMDWCxLLwB1ELubx19h
	KoNKl/SkaYaJXGoh7Yu4xQqdhrViiiB/XZK8Q3f0wmB/Mwa0WwSg4KT3tWIPbpOKbRp3ho3rW99
	0YMXtwMDsbSZSIc6YderoRaVI2vWgVvF8G8scRGs72zBoDSem3/TBUmeztBewcP2y5BD2EtkkAe
	yg5OpBapDvJPbJqkl6990QBj8Hj/Q==
X-Received: by 2002:a05:6a21:e103:b0:3e1:a3f:c151 with SMTP id adf61e73a8af0-3e13410b2d6mr4037689637.41.1791455633627;
        Thu, 08 Oct 2026 03:33:53 -0700 (PDT)
Received: from 954df21a5119.. ([122.51.212.64])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd0a8bfd740sm2780663a12.5.2026.10.08.03.33.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 03:33:52 -0700 (PDT)
From: Zihan Xi <zihanx@nebusec.ai>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	vega@nebusec.ai,
	root@tr0jan.top,
	zihanx@nebusec.ai,
	enjou1224z@gmail.com
Subject: [PATCH nf v5 0/1] netfilter: x_tables: avoid holding mutex over faultable user copies
Date: Thu,  8 Oct 2026 10:33:46 +0000
Message-ID: <cover.1791422956.git.zihanx@nebusec.ai>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Linux kernel maintainers,

This resend keeps faultable user-page accesses outside the per-family
xtables mutexes in the legacy GET_INFO/GET_ENTRIES paths implemented by
net/ipv4/netfilter/arp_tables.c, net/ipv4/netfilter/ip_tables.c, and
net/ipv6/netfilter/ip6_tables.c.  The ebtables ebt_mutex path remains
outside this series.

The source change is unchanged from v4 and is rebased onto the current
nf.git main at ab699d296e06 ("Merge branch
'net-always-dissect-gso-packets-in-__virtio_net_hdr_to_skb'").

v4 Link: https://lore.kernel.org/all/cover.1790439054.git.zihanx@nebusec.ai/

Zihan Xi (1):
  netfilter: x_tables: avoid holding mutex over faultable user copies

 net/ipv4/netfilter/arp_tables.c | 49 ++++++++++++++++---
 net/ipv4/netfilter/ip_tables.c  | 87 +++++++++++++++++++++++++++++----
 net/ipv6/netfilter/ip6_tables.c | 87 +++++++++++++++++++++++++++++----
 3 files changed, 197 insertions(+), 26 deletions(-)

-- 
2.25.1

