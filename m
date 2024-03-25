Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB6AD1292C4
	for <netfilter-devel@vger.kernel.org>; Mon, 25 Mar 2024 12:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711370182; cv=none; b=UhW36G7/LAZWqy58ZCI/yGmUaUVQadg67ZH2501LIdXDmLibIbxsDwxl6vPbpeXyESoDv/l0ehuzg44A7DRhX8cT9DMMJRmgx5F9tn96ABnmbUoPrYaqWwzTvDM1KgJRVgfL0biSyIaB1B6Z0PliXBHLth22aNC5ekXchfa1dH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711370182; c=relaxed/simple;
	bh=R5w9KCXuhH5KeJeJfCx/edhboHpyO2qfDK9c//dD+gE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=J/M07XK0dgM9pQZkqHn2M+qiwzW4vts/NEEkVp9J33vQeFOCvWRHzVO1lDN40T7QlvK+PMf+Wf5Rexyhr0PGT2zwnZjGQZhsirzzE6v3ocamu8SLYYNN5HrQ3StS33mXwdAxRc5d+M964ad/KEnoVEBAq5o25OPYaTWIKNXRzzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PQMQV8dZ; arc=none smtp.client-ip=209.85.167.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PQMQV8dZ"
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-3bd4e6a7cb0so2131462b6e.3
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Mar 2024 05:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1711370180; x=1711974980; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=SkdLzBeu7VVzAVlAgGb12HcSRMM5GaMKFmfIkR2FgAA=;
        b=PQMQV8dZApdHp+nqVvdQBYSQG7uQY/OVdGreEkEflkVo2gkpH2aBzxrH9LKFBf5WZv
         4nHd/54qMheq3uuneFZWatMCpRILPpoexRWB98sSgy8sPsm1fU/z3lehxC8jINs0qcsj
         tDavpL5VBl7X1ltmfmZJ3DqAvQ7AdKUU5MOS6h90e8B6TSQtpEYgpGSpULxsyjppROP1
         Id6owRqDOe6uzpfp7+n5UkElXstT4f+9IBrHfWxHkmoS2CRrcUj2sJB1pMPpHzXhOG/Q
         f/GF9U7qGL4U4MwhRRVT7//z3bkW07tGSz/NHqrch16MijONtYhq8mIq10mChqMQEtsX
         3aLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711370180; x=1711974980;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SkdLzBeu7VVzAVlAgGb12HcSRMM5GaMKFmfIkR2FgAA=;
        b=n1QC62nmpd2gtqCunHKQEHS4k3okdeGAMIVK0xgZrn4pI5PDMXxThRCZ/w7WbaHdtM
         Mj62D/1skjeh7sabwPVr5AmjtAMTOVBRZZGFjwCADbxwf+ICPD9z45957q7WPrQQLUd3
         unXEvczg39tyN+j3Z0iC0yKWvq3utz7Ds3DBbqKooDBvCBNwmGebWMfCN1HQ3Mg/p05r
         5yHugf48jNacDjv6g4Yq7Z7C6B42fVbCkyE+j8voqpcOknpO1qc9NFKNDTDv0vmYnUR5
         qcFg79XIllCpRMj7uoCxqOZ9+I2BqInwBlOE7EQAEwzO95lfNDVm6gKCH/9rjw7VKymc
         kYag==
X-Gm-Message-State: AOJu0YzWeAwIaXmxKJGabzglS2SxLG8sNmEnLeIAi80Cd6GbR/rlF5f4
	bvt49XKbXpauJ9vv9XfwKovTrvZcUrqxoJ+krDcTQfKYIeEERpY50ONNJo+k
X-Google-Smtp-Source: AGHT+IEJrH/W0TCJy/UbMiUcqGEcI7gxapRftnrbXQzTBOQxKiiPIddDy7Z5DxLdKm56S+VQ2e6BHQ==
X-Received: by 2002:a05:6870:4601:b0:22a:5154:b58c with SMTP id z1-20020a056870460100b0022a5154b58cmr811143oao.26.1711370179823;
        Mon, 25 Mar 2024 05:36:19 -0700 (PDT)
Received: from KERNELXING-MB0.tencent.com ([43.132.141.24])
        by smtp.gmail.com with ESMTPSA id u8-20020a62ed08000000b006e6288ef4besm4003022pfh.54.2024.03.25.05.36.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Mar 2024 05:36:19 -0700 (PDT)
From: Jason Xing <kerneljasonxing@gmail.com>
To: pablo@netfilter.org,
	kadlec@netfilter.org
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	kerneljasonxing@gmail.com,
	Jason Xing <kernelxing@tencent.com>
Subject: [PATCH net-next v2] netfilter: use NF_DROP instead of -NF_DROP
Date: Mon, 25 Mar 2024 20:36:14 +0800
Message-Id: <20240325123614.10425-1-kerneljasonxing@gmail.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jason Xing <kernelxing@tencent.com>

At the beginning in 2009 one patch [1] introduced collecting drop
counter in nf_conntrack_in() by returning -NF_DROP. Later, another
patch [2] changed the return value of tcp_packet() which now is
renamed to nf_conntrack_tcp_packet() from -NF_DROP to NF_DROP. As
we can see, that -NF_DROP should be corrected.

Similarly, there are other two points where the -NF_DROP is used.

Well, as NF_DROP is equal to 0, inverting NF_DROP makes no sense
as patch [2] said many years ago.

[1]
commit 7d1e04598e5e ("netfilter: nf_conntrack: account packets drop by tcp_packet()")
[2]
commit ec8d540969da ("netfilter: conntrack: fix dropping packet after l4proto->packet()")

Signed-off-by: Jason Xing <kernelxing@tencent.com>
---
v2
Link: https://lore.kernel.org/all/20240325031945.15760-1-kerneljasonxing@gmail.com/
1. squash three patches into one
---
 net/ipv4/netfilter/iptable_filter.c  | 2 +-
 net/ipv6/netfilter/ip6table_filter.c | 2 +-
 net/netfilter/nf_conntrack_core.c    | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/netfilter/iptable_filter.c b/net/ipv4/netfilter/iptable_filter.c
index b9062f4552ac..3ab908b74795 100644
--- a/net/ipv4/netfilter/iptable_filter.c
+++ b/net/ipv4/netfilter/iptable_filter.c
@@ -44,7 +44,7 @@ static int iptable_filter_table_init(struct net *net)
 		return -ENOMEM;
 	/* Entry 1 is the FORWARD hook */
 	((struct ipt_standard *)repl->entries)[1].target.verdict =
-		forward ? -NF_ACCEPT - 1 : -NF_DROP - 1;
+		forward ? -NF_ACCEPT - 1 : NF_DROP - 1;
 
 	err = ipt_register_table(net, &packet_filter, repl, filter_ops);
 	kfree(repl);
diff --git a/net/ipv6/netfilter/ip6table_filter.c b/net/ipv6/netfilter/ip6table_filter.c
index df785ebda0ca..e8992693e14a 100644
--- a/net/ipv6/netfilter/ip6table_filter.c
+++ b/net/ipv6/netfilter/ip6table_filter.c
@@ -43,7 +43,7 @@ static int ip6table_filter_table_init(struct net *net)
 		return -ENOMEM;
 	/* Entry 1 is the FORWARD hook */
 	((struct ip6t_standard *)repl->entries)[1].target.verdict =
-		forward ? -NF_ACCEPT - 1 : -NF_DROP - 1;
+		forward ? -NF_ACCEPT - 1 : NF_DROP - 1;
 
 	err = ip6t_register_table(net, &packet_filter, repl, filter_ops);
 	kfree(repl);
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index c63868666bd9..6102dc09cdd3 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2024,7 +2024,7 @@ nf_conntrack_in(struct sk_buff *skb, const struct nf_hook_state *state)
 			goto repeat;
 
 		NF_CT_STAT_INC_ATOMIC(state->net, invalid);
-		if (ret == -NF_DROP)
+		if (ret == NF_DROP)
 			NF_CT_STAT_INC_ATOMIC(state->net, drop);
 
 		ret = -ret;
-- 
2.37.3

