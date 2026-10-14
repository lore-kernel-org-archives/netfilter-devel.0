Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 469B3480DD5
	for <netfilter-devel@vger.kernel.org>; Wed, 14 Oct 2026 23:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792022194; cv=none; b=Jb1TxuY7fXOzI/uw1W7D38q5R8YlVKZ3i8zwUs4WHIBy+JuAML7p4qfGfmLuhdqp/wVDF/KghVEdeHlDrTviJ+IIzLwpguPbZn5gFilcI+eB9l7FvKD/laFrp1UbNRfNz8Ofm1YWLw+Q9w1RpC2INDOfoUcSioFnTbFDGhOrPv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792022194; c=relaxed/simple;
	bh=nLu9+jS/Cn6oFT3DAy2pgKLYerUk78AHPFMk+9gkrY0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=a2HqA0GZbcPgN1GQOYUR8MloJSswPKKCUuo+q9Qfpj0skB8CzCnrtLEbjwmR68Y4qr5NT0NUNPOaJIiseXb6pugFREHkXYWIhLo91yHGzj3QBlXQ90mSH4af4rh4kVE9NO7fQ1TZrD03udzreJvhKxjXW7qEsSiZbAtOIRlUKn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=bJCCdWS3; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="bJCCdWS3"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c315729ad50so770668066b.0
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Oct 2026 16:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1792022191; x=1792626991; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ujWOXhajkBZtlCmsZmCoVumMM+X/QUn/djLaiVsONPE=;
        b=bJCCdWS3SAPVptxJycLn5yScFOncCfpXu+inchndA6M1vZCtSnwKPoxvEnuEhrLLHr
         F86HqEXS5wP1bKUC+C+MffUT9VA7+fLrXZDZibZz5Tf61HlVHt1Jh10Mx8WjykwBvVHx
         PWXTNj4DHwTNfgz+9nx+32yGY4Q/BCQGmsC4zK0EWkIocoTkU+QppCGu41JHJqoEKDFo
         ctpDdkJ8TO0L22nPejk4mF94+ND9ukR8xzhM9Qt6FTYQ2A+oNHIWmhwOUYx956uW3oS5
         wmLPx36n6syhNVOIFA+khBnb0lRUS9tKMbfr9/33VgB4P8oopaeBmMyrSaNE6iMN1r/a
         /FpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792022191; x=1792626991;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ujWOXhajkBZtlCmsZmCoVumMM+X/QUn/djLaiVsONPE=;
        b=l4h5hsbb7UbeaGpNZGwFXEGcs2TnuFoWEFjlJ6ggO6oXGIyQtI3biXyc1VUjetLCBv
         DClU6NNdaL1KyWAhFI4YCRw/5hU/jBqhOPJfDOfRpvhjSYbXodwtfo2vF/N9cragLd3r
         j1CiGkgToRKsp9DiKtvUI/X4pn+yI5AsUhR+PacGyUQotc+EaBHqQYgwNoWl0dTOnTCR
         DITDYMveJC5sR7+c6u40Oi4YnLCDWgT+jynGuBjxYmRTWYjJarOJXqhMK5+UvMYxTpRb
         +5z1PFrmYcw0Hzc53ddk4tE4BiX/5JDRUbepRt6LdJ8NC8g+dcrN+kOZ1PGZBcEffuAQ
         8bwQ==
X-Gm-Message-State: AFq9FYJqyY2QFcVvCKnUsy6+teXv5ZLwD7S/XBlIRBpzXR/5Ced48VHj
	F2LzvfCWevgxQRrHvtSragV5x4nF8b74tLYBXTQRPGwiCPxKZLxqNG3ZMEByL/w65nwss2H4XMt
	rAmvgDfKzWPA=
X-Gm-Gg: AYBFou2vrGnWPAtHL4wEwm+PpaL57ppIAKDCuK4hV+dU/LdRmgWhi0aHNYQkEqlV2uu
	2hDWediyCv57EQP9RM6Wr/+5cLSnxU4/LUfhg/mD3Ov4SfLzl6DRICvaLhk2kOB4zPj5FNt4C6X
	KHuuIXDK56vJ+MNs2MUJEIpl0+wI4FvO7x29AwA4LGh7KXlR+6GulzXKoXSbBsOHslLgZKabgPu
	bM384q+UXhY7bkBRHVTnTizBP/E8zCHcmfaZqCJl8K8RltDA5aEcCNKRDjmaa/Xtqba6HZAjDOJ
	R4nQWkpQmQfzBs0r713qhjOPnXaFiNTdyrbi7FWbRp8D9d1Za9mwIeu9QK48u3NK4o5mujfyIn8
	mnRkupQJsuzELj4ofnb60Tq8+4X6OGowTh+PLGsFrMJ1cD+UHiOQoyRUYv6jKK3iXhcDbwmulVB
	aZEaAxCxoBx0oXHT5u9Y29aWHCyYE0VZc3OElY5O/muMlV1cwhmQAqXtuC3KPg9fr6aUgWOwWxa
	x519unD7HoCmqOfSoGYZMeqGyw1WjvbjzyRY/Np7hpYe8puGOZL5ahlcQAe4KbSRHLlY5tNxikL
	yhF9wFPTRdY10GcVr6yUIj+iTYSNnC/+9VHuoHKLpbrchfZ1NR6si+ggsoR2EjGaCE+uy9CiGmJ
	+m0F7g5/zHVODfU6QmK1wB7WcsDFzYVbH4hvAWtsGHrT/9RBOUo24/kTbecZgID3iu3iN0EsQuP
	rxAkOLh2ZtbdkXbt1GOK+ivjI=
X-Received: by 2002:a17:907:3d52:b0:c26:1648:a076 with SMTP id a640c23a62f3a-c31aa0e93bdmr1626520966b.49.1792022191008;
        Wed, 14 Oct 2026 16:56:31 -0700 (PDT)
Received: from Desktop (p54affd5a.dip0.t-ipconnect.de. [84.175.253.90])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c3edab12007sm46101666b.82.2026.10.14.16.56.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 16:56:30 -0700 (PDT)
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
	idosch@nvidia.com,
	ericwouds@gmail.com,
	dqfext@gmail.com,
	netdev@vger.kernel.org,
	coreteam@netfilter.org,
	linux-kselftest@vger.kernel.org,
	bridge@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH nf-next v7 0/2] netfilter: flowtable: tear down bridged flows on layer 2 roaming
Date: Thu, 15 Oct 2026 01:56:25 +0200
Message-ID: <20261014235628.197976-1-julius@bairaktaris.de>
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
Wi-Fi station roaming between access points.

Patch 1 makes the gc tear such a flow down, using the bridge fdb lookup
from Pablo's patch. Patch 2 adds selftest cases.

Tested on nf-next a5e7d8e446af in an x86 guest: nft_flowtable.sh passes,
including all seven roaming cases, and ftrace shows no
flow_offload_teardown during 10 s of steady traffic in any of them.
flow_offload grows by 16 bytes (296 to 312 on x86_64).

Changes in v7:
- look up the fdb entry through a bridge hook instead of walking the
  forward path again (from Pablo's patch)
- save the vid of the fdb lookup; the encap stack does not have it for
  untagged ports of a vlan_filtering bridge
- build br_nf_utils.o only with CONFIG_NF_FLOW_TABLE
- selftest: vlan_filtering case

v6: https://lore.kernel.org/netfilter-devel/20261004171605.3544792-1-julius@bairaktaris.de/
Pablo's patch: https://lore.kernel.org/netfilter-devel/20261014210256.1573072-1-pablo@netfilter.org/

Julius Bairaktaris (2):
  netfilter: flowtable: tear down direct xmit flows when the fdb entry
    moves
  selftests: netfilter: nft_flowtable.sh: roam a host between two bridge
    ports

 include/linux/netfilter.h                     |   8 +
 include/net/netfilter/nf_flow_table.h         |   4 +
 net/bridge/Makefile                           |   2 +
 net/bridge/br.c                               |   2 +
 net/bridge/br_nf_utils.c                      |  40 ++++
 net/bridge/br_private.h                       |  13 ++
 net/netfilter/core.c                          |   3 +
 net/netfilter/nf_flow_table_core.c            |  27 +++
 net/netfilter/nf_flow_table_path.c            |   9 +
 .../selftests/net/netfilter/nft_flowtable.sh  | 204 ++++++++++++++++++
 10 files changed, 312 insertions(+)
 create mode 100644 net/bridge/br_nf_utils.c


base-commit: a5e7d8e446af9803e37a3b6a4d416fb41178348f
-- 
2.53.0

