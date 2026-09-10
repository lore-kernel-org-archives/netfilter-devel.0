Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89C8A3515D6
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Sep 2026 09:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789030861; cv=none; b=Bne9JN2RBqFUuaHT5cFJ7Un5MHMjorveP58eHUHS5/2i5t5y15i0GUV9/z5/eyLeDcxfgF9FStSk2X6F7+loFtPKtqIws2PBLWuw0T/p9Pk6xUO/4jIwHZF5ioccGpQIS8Jk41j7crR0eVQqxVnJ6a2PjMtNGMROjOpGzvscxaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789030861; c=relaxed/simple;
	bh=dIbn/KArTYPw3HGBcspbqNsB7qAbz+1bLc3X+IlHTbw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cqNsdM4OtHm3WqQ/dtZ6fd4HRIROQPuQr+TPFBMdtM85tXZ1pY9WYVWqOfX2XyH43/ch3ZleBmOkOvSvszWwfG/YyY67LcQ+jY7smyQVjhXlzjeUgz5A8R5PQSPVD6jvAM5BdTUMo64Zf3dvJPdkYznJxhhJQ6tUn3mW0ooogIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=G8wCGkBF; arc=none smtp.client-ip=74.125.228.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="G8wCGkBF"
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c2940ff2313so79955966b.1
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Sep 2026 02:00:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1789030853; x=1789635653; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=5B7LaAqbmIcqcPKni65pEo4KDgrq44npDo9WAUJP4Ho=;
        b=G8wCGkBFkbquf38nuNXAX6zeHzR9RPiPUAIc/brjv/k5HHAAdrZphl/5NZnlz15Mpm
         1IyCXhwImCpEp6GDPcu1B7VQBM5jxDGRw+BAdMPHP8WgVRkRo6GHjKkcrmLM/GKCXiEK
         lQH1P1qJjjzAayw0xZHp2StbPnR8Vw1PGjfsAngO5ttTLIy2anm6qAF2BOy3AuYZolNV
         s3Res4TbGcfqfhTATebz5F16U4q/q3naSfmi8G7OJRqh8pI8PLLbs6bX1B4YZlcg+13/
         8y1rdsWf9UzJNHi94vsDIun7We9BOA0GqP5EXtf5EePRl0EsZUMQu/TF4wkCQQtFwcuM
         KlEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789030853; x=1789635653;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5B7LaAqbmIcqcPKni65pEo4KDgrq44npDo9WAUJP4Ho=;
        b=tD03upaKMM+Tln125y1Xgjh6/vZnfFKyuuzsVyo9lzJeh6dDqjCZpFBEAe//IA2gGv
         h8U/u5UH2syd7Y829ZAUE/SgUDef8NkXfG/FsHy9U1UliUaTaTwa0MOAugLyrn2kUO9+
         5bnVMpFL5QwkxGJTQSvqtzYoXpBYilay1H1rB715IF6K07s6f6T74RluAAWJXD+nTOgo
         bRZ10yeF5XB+OMdZlfFJyaLg13vutB2KZEUVwTwwQV3KdQ/ERLRqL4LvUt/76Ac08+xG
         1gTdhbVpXYnwhtAKk4R59JHCl8saSi24Lnd2WVlISCqpYj7zistmF2kpR+w6gAhErvoD
         o1Vg==
X-Forwarded-Encrypted: i=1; AKwUvByPsItms7xujNT6/o2ZgivW3eLYqWPMt3CSqw0f/iI2cM4CH6df9IaknFpGT7te9ceYHU1MNLDXvfGjriXeN70=@vger.kernel.org
X-Gm-Message-State: AFuF++kT7OV/5OqtaDsF9xeMlj1avWmE+S0aq63LzCdpPfIPEXGswhnc
	w8uYlgHioNARTnazN9noZFLaMllUCM3EDwYd4u9LYUaCOj9+KT955FDH4HUdh2G8WA==
X-Gm-Gg: AYBFou0fGKTaz4Y4ipRNBPA+Huv0xt9r1y2Tfk543zIhWOPa004iC5A3xNMVKVvEqY4
	nk6LSHJCPC1zeJ4QIafEOWoo/1iMpIhS6R96MnhtlVfc+6oOBACTD/fe3yN1FaIYSxjEZAvGtbN
	ODEv5a/WWqZw9C9trrjtrtqL5gvsOQ0jbkV9jIRW6H+zf6m0BTwQFtNTbLeEpol0MU1ls3D9lWo
	Cmg2YHRr+m6OADog/Ifzv4ccxk+kPGFtru3wfKlnPju2JNb0KM55DI1nmVajZB0fIpRVwBk6Ijy
	3Y+Y4nGaXEAXeLRNUXoX1vDg652FIONBAzuAeZUVJ88Oe/Y9QSZJ2Sxc0b0hya88mmRrbfyL4oA
	4AgErgKlXmDFNGgAAd+8fe7Hy7wPRoPQytYaJpBtS1raswe5IldI+XWRfq6xT/vAuq0jrsOjyM9
	5rPsZQMQ37c0ecpRWaMFbekYG0rYTpWmvk7BzME9R0j2VpfOF9c6A3W1Qc293HzRpydha5xNh7B
	j//ZEk13lQtqUxgN3M+eTFX9Ikdzc3c7u2mdfVAOox06LURObB9GFLbufwEBz1lTLmWbSGppPw1
	xDVI7Ldt8LidBnLhB/wT89h8/LT8NU+uOT0HZv8hKAP6TX4KHyCCzZuDRlsxo4o0RYhI9DdQNDp
	O6mf27NcOhSCS28pY0TNyqeMl1JKVDK+60Qq7AW4+QolkqbTeXxoAa4Wzm/SvuCx7rLcjcm6q1R
	xcnam6uCBDVxVbgl92
X-Received: by 2002:a17:906:8f8a:b0:c25:f7db:4bed with SMTP id a640c23a62f3a-c2945efbe7emr186476666b.19.1789030852391;
        Thu, 10 Sep 2026 02:00:52 -0700 (PDT)
Received: from Desktop.fritz.box ([217.26.235.87])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c293eaf1ae8sm156106766b.40.2026.09.10.02.00.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 02:00:51 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: pablo@netfilter.org,
	netfilter-devel@vger.kernel.org
Cc: kadlec@netfilter.org,
	fw@strlen.de,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	geldot@protonmail.com
Subject: [PATCH nf-next 0/4] netfilter: offload a TCP flow whose reply is never seen
Date: Thu, 10 Sep 2026 11:00:48 +0200
Message-ID: <20260910090052.2034970-1-julius@bairaktaris.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A host that forwards one direction of a TCP connection only sees the
client's SYN and then an ACK continuing from it; the answer took another
path. That ACK has no entry in the transition table, so it and every
packet after it are invalid, the conntrack entry stays in SYN_SENT
[UNREPLIED] with a single packet, and the connection reaches neither the
stateful part of a ruleset nor a flowtable.

Patch 1 takes such a connection over as the mid-stream pickup it is.
Patch 2 withholds the reply direction of a flow offloaded in one
direction until conntrack has seen a reply, and offloads it once
conntrack has. Patch 3 offers a connection whose reply was never seen to
the flowtable in the original direction. Patch 4 adds a selftest arm for
the path; without patches 1 to 3 it fails, with the router forwarding the
SYN of the connection and nothing else.

Verified on an IPQ8074 router with hardware flow offload, iperf3 -P2
between two hosts on different subnets of one bridge with the reply
direction bypassing the router:

                                  CPU port    switch port   throughput
  asymmetric, without the series   81k pps       81k pps    944-947 Mbit/s
  asymmetric, with the series      2-11 pps      81k pps    948-949 Mbit/s
  symmetric, with the series      11-38 pps      81k pps    926-948 Mbit/s

I wrote this series with the help of an AI coding assistant, as the
Assisted-by tags record. I have reviewed and tested it myself.

Gary Dotzler (2):
  netfilter: conntrack: pick up a TCP flow whose SYN was never answered
  netfilter: nft_flow_offload: offload a TCP flow that has no reply

Julius Bairaktaris (2):
  netfilter: flowtable: promote a flow offloaded in one direction only
  selftests: netfilter: cover a TCP flow whose reply is never seen

 include/net/netfilter/nf_conntrack_l4proto.h  |  7 ++
 net/netfilter/nf_conntrack_proto_tcp.c        | 19 +++++
 net/netfilter/nf_flow_table_ip.c              | 26 +++++++
 net/netfilter/nft_flow_offload.c              |  6 +-
 .../selftests/net/netfilter/nft_flowtable.sh  | 73 +++++++++++++++++++
 5 files changed, 129 insertions(+), 2 deletions(-)

-- 
2.53.0

