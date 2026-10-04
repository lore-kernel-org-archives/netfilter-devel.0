Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ED693BB9FE
	for <netfilter-devel@vger.kernel.org>; Sun,  4 Oct 2026 17:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791134170; cv=none; b=dXgfFvJm8cudh1XZSK5YSPSwewWdYMw9bdsUftA848dF4y7TR+8MAX8VyGon/e6d97w6kTKCVn9zwokKEroCitMAShq8LXMvaTuGU23ZKqTxmL/Aod3ilel1jZp3O3BAltErAxMyUK1WWoT6t1Whhao4Lu2L2gPfELX8GBkkS10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791134170; c=relaxed/simple;
	bh=rBHJvSFHLogmhqc8qfoepEplPJGPX9ErzSBr3vdnmXw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pSlpHxgUhXjrntPQmZwUt09fhZIsCV06my4ASxXCFIeIJ3hIx2xsPZEbrc5nc/fdbvWwQ92Ft6WVXzqgYwHqGynF46Gif9ALGdUpmybQEDnDzdX3cyoutJbRGlk373o31MfTkaIBrLQZaFpzVpe/zjMrAgmk96h9gSwANj/DPBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=c5LQ0Ngn; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="c5LQ0Ngn"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c2a25dfbf5fso179021466b.1
        for <netfilter-devel@vger.kernel.org>; Sun, 04 Oct 2026 10:16:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1791134167; x=1791738967; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=pYMVFKoytfLOZjDdNYvHmJsPemFRuNKvWdr0rA6Xpv0=;
        b=c5LQ0NgnxmgzgAX9APuwJeLA2LhejR+NZRo8avB1iEDHndr0IP9ah87SWkXn3UEIc4
         EZFpsIJhByekL7Ry4oalElnDHW2Bn8KXRbsEe6d4E/AGd/MLCGZcjac977RyLymzAp0C
         K+S5L+0LUvwiJVVFz5KjVU4GOyKWQiijuvkvmulkv1cnny1OWZGPKMNUb5Z2jtR/gn4r
         jv7N0Xshq316EC4o6u8UMvvGkBLN0ytqd9dw0j0WjO4n7K4M3GE+RGAPZKW+hnVUoqNf
         OEb5kmTZBWmdHUWDagr37MxGFQ0ZPQx9KbCkXp56dKNkZenLr2HRJRFaDe+Cy7ZpYV/D
         HeYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791134167; x=1791738967;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pYMVFKoytfLOZjDdNYvHmJsPemFRuNKvWdr0rA6Xpv0=;
        b=dF0roObVF++D/mMQhxKlq1nnaeRu7awMwWvZFQ+RCZmtvdkqADvQvqGbzPgIl0ytvV
         vohJZ/SmttSpOOwSouPibabZ9nbfgpoGWKMumq9GE/etyjpWTYLvAdMuxEr9qV0HyNIO
         Qow7cMGv8LkJ+OppN/7VG/x8YgFKFj5cJE7X2jyprV+o0O3AkZWh4F81FSfcL2620BIS
         M3oqq8qcnMoSZIb6uIY4ga50laJ5Jly6MIcA4r/H1nOF2TT7RBORjEardYUS4W0Z6XXV
         aNBZcTh3DmiQ9XcQvyiEnz68r4AHIKQSbnVbluVeFQ43lNBAXbgXQah9kZRfCGs/cV22
         MyRQ==
X-Gm-Message-State: AFuF++mH4o9gGJcZsR7K3tIJFz8Q+E7X5q5OgvZfe/gfcmDF3K4FNTqg
	I9kwB6weqqoPJzShcOZNh0lb8vtLDYmU9jjcDaGppUhbGOgPy4iLylrVcvl5qocNSylT2FTfGLi
	bSZLDPQ==
X-Gm-Gg: AYBFou25H+iKQuk0xWc6pEp/1d8XqguSSK2hqPffcaDGjQIU4Alj7vwz1Kob0WtJ+3U
	1MS9o0tE8PJmOD2wrpe5dkpT2xdoEbhJrlk1AKJN3amVoIgkSPNKYan1OAe/KGOy/EOtMWlzYAx
	AmAT99uSQQe+wH6QQRhY4s1yXqa/djRjfQI1aiZKZef2WPmHHw8u0MNlHSf4nfZcF4KmbnRQK8T
	eZ0ejxcKGsyi83zclwCOSD4lp9IweMVRwZ+v6fNCA/hqb7XMNRzZG7s0J4zAX/3nxxYga2SCxBl
	0R4VvzhC7cV4Sa/MSdhXwbjpmnZOu6BoI4qOrrDB2H+qYD7CmVc6SdXnR6xmI9xqrN+ontZudOT
	h24Zf7EktBWxy4NpYd2BgMCOvojBEB0ndgA8S+pnIcsm2gKSLer7cEjZbL6GNJVSmsNPNbE5vtD
	BvCV9Tw9Q5349MfWLfE0LlT73ql8Bk08rxtJVAkaR6hasRYujoThr5gbVrK8uklQlWCCxciwnuW
	fUOYAEUqwrKC59a+JwddmX6NGEHobJLcEsvzYF003SyGdKjq8UsS7Tk2XYWLMOkE6CpEzu0Ns+v
	aVRFOif8qeEw03cF3EPbsKeZj3FJB+QTVOG3P3sbqxtc3/t/ZTHx+d+eIyngUotzWvDK8Wp3fhH
	ImnzbJMfOFCIq0XxbtpqwWE7Tg9rNsIUQVIZXTFFEHENlPgpk5fOlxB9TjxKueIVaTLpf5U2EYc
	lNNffnKNeu5Se2PrTXqAcmSft8s0YFSLdj0w==
X-Received: by 2002:a17:907:a648:b0:c26:19de:9138 with SMTP id a640c23a62f3a-c2e6ee5ffa4mr444266466b.43.1791134167223;
        Sun, 04 Oct 2026 10:16:07 -0700 (PDT)
Received: from Desktop (pd9513667.dip0.t-ipconnect.de. [217.81.54.103])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2e878b0e05sm82284366b.5.2026.10.04.10.16.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2026 10:16:06 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	kadlec@netfilter.org,
	phil@nwl.cc,
	horms@kernel.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	shuah@kernel.org,
	razor@blackwall.org,
	ericwouds@gmail.com,
	dqfext@gmail.com,
	netdev@vger.kernel.org,
	coreteam@netfilter.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH nf-next v6 0/2] netfilter: flowtable: tear down bridged flows on layer 2 roaming
Date: Sun,  4 Oct 2026 19:16:03 +0200
Message-ID: <20261004171605.3544792-1-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A flowtable flow that transmits straight to a bridge port keeps sending
to the old port when the host moves to another port, for example a
Wi-Fi station roaming between access points. Patch 1 makes the flowtable
gc tear such a flow down. Patch 2 adds selftest cases.

v5 tore flows down on the switchdev fdb delete notification, which the
bridge does not send for every move and not at all without
CONFIG_NET_SWITCHDEV. v6 checks the path in the gc, as for a stale dst,
after Florian's review of v4. Eric Woudstra wrote v1 to v4.

Tested on an ipq807x router (OpenWrt, 6.18 backport, out-of-tree PPE
driver), three runs: without patch 1 a roaming station's download did
not resume within the 29 s observed; with it the longest gap was 1.1 s.
Without patch 1 the four selftest cases where the host moves fail; all
six pass with it, also with CONFIG_NET_SWITCHDEV=n.

Changes in v6:
- check the path in the gc instead of using switchdev notifications
- leave the flow alone when its fdb entry ages out
- drop the v5 patch that stored the bridge vid; nothing reads it
- selftest: more cases, including fdb ageing and IPv6

v5: https://lore.kernel.org/netfilter-devel/20260914072541.897040-1-julius@bairaktaris.de/
v4: https://lore.kernel.org/netfilter-devel/20250925182623.114045-1-ericwouds@gmail.com/

Julius Bairaktaris (2):
  netfilter: flowtable: tear down direct xmit flows when the fdb entry
    moves
  selftests: netfilter: nft_flowtable.sh: roam a host between two bridge
    ports

 include/net/netfilter/nf_flow_table.h         |   4 +
 net/netfilter/nf_flow_table_core.c            |  44 ++++
 net/netfilter/nf_flow_table_path.c            |   7 +
 .../selftests/net/netfilter/nft_flowtable.sh  | 201 ++++++++++++++++++
 4 files changed, 256 insertions(+)


base-commit: 87b80c2f6b05cad9f0ff9136709c62a0f59923e3
-- 
2.53.0

