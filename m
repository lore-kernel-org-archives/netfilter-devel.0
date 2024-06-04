Received: from mail-wm1-f100.google.com (mail-wm1-f100.google.com [209.85.128.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1959DC2D6
	for <netfilter-devel@vger.kernel.org>; Tue,  4 Jun 2024 13:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717509318; cv=none; b=jtu2fStjCiNuRCZ3qxqh5icKtaRxLHopO4R2ymVzfDA3ICE8BzskxQAQRT6SeiUWe/9tJU364gHcYoRKXCunylk3eOie0huW+WyuiYnFwZc7InBrcK58YEBtQh7XdSwgdmgqvDePfnbSU2ZAGdWMlXRZpKcTmyKNwIXR9wwWYHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717509318; c=relaxed/simple;
	bh=sAa/ah+q9kv4YCy0OEzRUmiSV5CcvlO31jUJbv1UE1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=seVtPSMowmjydEkFx8tSImWEvyquSNL2RHGO/t4oVDG4NDMnag1jrCRahBO3vFf16xsPFn1/2ox5uuAPwM8vgehBkHAorcH/PHSjzBJWMkHUVyW33cfyCzD1SxxogwKHYYH/YazUx1/2cUpLXS0Vpa0mGWjX4lGQNRLlFKosmTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=6wind.com; spf=pass smtp.mailfrom=6wind.com; dkim=pass (2048-bit key) header.d=6wind.com header.i=@6wind.com header.b=IuQ1sKB9; arc=none smtp.client-ip=209.85.128.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=6wind.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=6wind.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=6wind.com header.i=@6wind.com header.b="IuQ1sKB9"
Received: by mail-wm1-f100.google.com with SMTP id 5b1f17b1804b1-421392b8156so10682355e9.3
        for <netfilter-devel@vger.kernel.org>; Tue, 04 Jun 2024 06:55:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google; t=1717509315; x=1718114115; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lD37MB5E3bI35OFv85LJReokwMRhrH26k764mcname4=;
        b=IuQ1sKB9g0Tfezd2suagZMbSIuJQAjB52q72OB1Cq/k3wLB9kzT+pvvYmOdfk2sfC/
         LKW52HLoQ+ih9u8pHrOjq4I63uSQ6ZOyMb4bI+LUsaHY+WC6zEjx+m5h/ovmm6iTlhYN
         /N5itHn/Jp6yv4Xawo2h7GAJUHkiXTaVX8q9oiLYFAbagguNYadP+laikEvoWwcmmY0D
         sAZQUeTyRIXP7LGoS7kB4O0FfwZ8LPZb6JCquRzIf5eJHNM6rG+F73C+2eJoJ+aqZP29
         jaGkxY5k75zrvEDK3WpFxZk67c+plMtYtf1z05C3MbBKJ5UwW9Ti+K519yg24p3N7bsz
         WkXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717509315; x=1718114115;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lD37MB5E3bI35OFv85LJReokwMRhrH26k764mcname4=;
        b=nKoEvNyJVtnrlFwAnJzI7B36cM+P31s2MWwP2zaHFyw4Ba0FCVArR8cWuPMIDFvtQ0
         5wrp6dqd0vlrU/i7iOsFxM2RLK1snVfWSQjy7U5O6tUcXcbxbonX+Y+R4K8qIQ+SRQCV
         895S5SrQm/z1pummnyjenV73dVhCLKf4+nb1dYT7LUdW/MmWgF4snEvl2dDaL0UFHIxL
         7iDfEIXLs/vjxD4DYgf9DV9zRqtRR9CnPS2wGsOHpaNnOqmvgfWl4/0/xHbXCN9++c8w
         1j6Po9fKkcUy1CBA+ReOSjt2LJ/9Vl+H+zJrpYSpUUQxjKhAdQpzlJf8aBOUgGpMj+Gw
         IzIQ==
X-Forwarded-Encrypted: i=1; AJvYcCWvmYdfIDgn39l2easAVZ5CIvLYQViitRugGY7xcfCMJBX5PdyvauiXQ4Ae9/2nnRaGdfILmsthA1puIYGdJsflWMlh3pAD7Vw49u4k/p5D
X-Gm-Message-State: AOJu0YxWFfBnx1U+HXxYvMrWP5zLBn54yUqaszIT7V9sdLTUpU7SanWY
	LoZzVRvxOPEnRgpUgnC/cKWJL9FKL1U9WexSqgCxaVJ7HpL26VgUox6HOp6tClUtC9htloej5fy
	q7eUJInKNm2T1Zts69ORYUcTB9BQrwGFi
X-Google-Smtp-Source: AGHT+IHqE4IhljPE6P4ZIoi8g64yvlzeLgaKvqnJE/JgQARKzxd74jD1hdzKcvUbvFmn1ZoVww6Rucxscpku
X-Received: by 2002:a05:600c:1550:b0:420:e4b:d9df with SMTP id 5b1f17b1804b1-4212e049f7bmr117882855e9.13.1717509315322;
        Tue, 04 Jun 2024 06:55:15 -0700 (PDT)
Received: from smtpservice.6wind.com ([185.13.181.2])
        by smtp-relay.gmail.com with ESMTP id ffacd0b85a97d-35dd052d64asm510177f8f.90.2024.06.04.06.55.15;
        Tue, 04 Jun 2024 06:55:15 -0700 (PDT)
X-Relaying-Domain: 6wind.com
Received: from bretzel (bretzel.dev.6wind.com [10.17.1.57])
	by smtpservice.6wind.com (Postfix) with ESMTPS id 0BB68602B0;
	Tue,  4 Jun 2024 15:55:15 +0200 (CEST)
Received: from dichtel by bretzel with local (Exim 4.94.2)
	(envelope-from <nicolas.dichtel@6wind.com>)
	id 1sEUd8-00AxpK-No; Tue, 04 Jun 2024 15:55:14 +0200
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
To: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>,
	stable@vger.kernel.org
Subject: [PATCH nf] netfilter: restore default behavior for nf_conntrack_events
Date: Tue,  4 Jun 2024 15:54:38 +0200
Message-ID: <20240604135438.2613064-1-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.43.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since the below commit, there are regressions for legacy setups:
1/ conntracks are created while there are no listener
2/ a listener starts and dumps all conntracks to get the current state
3/ conntracks deleted before the listener has started are not advertised

This is problematic in containers, where conntracks could be created early.
This sysctl is part of unsafe sysctl and could not be changed easily in
some environments.

Let's switch back to the legacy behavior.

CC: stable@vger.kernel.org
Fixes: 90d1daa45849 ("netfilter: conntrack: add nf_conntrack_events autodetect mode")
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 Documentation/networking/nf_conntrack-sysctl.rst | 10 ++++++----
 net/netfilter/nf_conntrack_ecache.c              |  2 +-
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/Documentation/networking/nf_conntrack-sysctl.rst b/Documentation/networking/nf_conntrack-sysctl.rst
index c383a394c665..edc04f99e1aa 100644
--- a/Documentation/networking/nf_conntrack-sysctl.rst
+++ b/Documentation/networking/nf_conntrack-sysctl.rst
@@ -34,13 +34,15 @@ nf_conntrack_count - INTEGER (read-only)
 
 nf_conntrack_events - BOOLEAN
 	- 0 - disabled
-	- 1 - enabled
-	- 2 - auto (default)
+	- 1 - enabled (default)
+	- 2 - auto
 
 	If this option is enabled, the connection tracking code will
 	provide userspace with connection tracking events via ctnetlink.
-	The default allocates the extension if a userspace program is
-	listening to ctnetlink events.
+	The 'auto' allocates the extension if a userspace program is
+	listening to ctnetlink events. Note that conntracks created
+	before the first listener has started won't trigger any netlink
+	event.
 
 nf_conntrack_expect_max - INTEGER
 	Maximum size of expectation table.  Default value is
diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index 69948e1d6974..4c8559529e18 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -334,7 +334,7 @@ bool nf_ct_ecache_ext_add(struct nf_conn *ct, u16 ctmask, u16 expmask, gfp_t gfp
 }
 EXPORT_SYMBOL_GPL(nf_ct_ecache_ext_add);
 
-#define NF_CT_EVENTS_DEFAULT 2
+#define NF_CT_EVENTS_DEFAULT 1
 static int nf_ct_events __read_mostly = NF_CT_EVENTS_DEFAULT;
 
 void nf_conntrack_ecache_pernet_init(struct net *net)
-- 
2.43.1

