Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C5433559D6
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Mar 2026 20:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774384887; cv=none; b=S19hkIzvS++YCMntAB/xrxEW47P8zfeOXxowIjCgwQE/rqASkWUVOg34QvDJJ6gu2OJJoGqmtPk/ChzML9aCEIoA1ytGxcvLLakaIpXXkNk7gjQtbQOqbkxvUryqlTC0NOQrCgTrOzPTkgSvTD0O+kfrN4S7FsD3iS9yCB87E1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774384887; c=relaxed/simple;
	bh=7rS4b1sOJwSZSDEH5NqgxYEH3TYqIFxgaRgu7FRsEtc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BwwlhCNDMcQp4WVxuZhGSmNQLMGSrkOcYevfhGUz+mWTq8hrp/BtwTWJ45V/gX1h//ac+Ugouomisik6JGy22Bf9i5XXmuhNVkffSXxvs1rknr0bjsh9ay4a2pX+zFbHn/kZf+g1FjNdzj12jEB4KSg75vrFsyf5AB1hHLIESDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TEW6a62u; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TEW6a62u"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4852b81c73aso39431615e9.3
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Mar 2026 13:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774384885; x=1774989685; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Bh2npv0O/elfFN32ItPoLhgPFIFAS6miRnp44yqFPqQ=;
        b=TEW6a62uRH3IhrFBWRmU7nER66jz2wluAMRAPR9daT4BGbIHgv2IWJ52qhuPAmPFc2
         EiRPW/LNPT6d+DES81SuPmhPT5KQXoVQnC3RF7TCtsH0hOLD/X6hI7gQSqInBG+XeYuW
         LWck936tSa2u63GTZbkV8uHpL+Mf+WenKI2C2wETz893ULyo0KMF/FUDsts4JFoxQr55
         YYoQzJQJw7rEJjfm7oTaG0Bw43sEUNjCARfsMgjuFEKUS/Usf4dzU3Ebd5nfagzRAKwW
         G1F8fPQOBMihL5bZ2YG04lyUGFf2bCB3IboTeGIsY3jF/6REKZyVyiqGwalZ94UIkARX
         0ztQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774384885; x=1774989685;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bh2npv0O/elfFN32ItPoLhgPFIFAS6miRnp44yqFPqQ=;
        b=sW06U1HAtOgIrVT6qyuDrqCi39gzUkmeOO3RQ3vrGFT7Vx4WNADi0fCLjaYFWQb4lh
         IyjExzFLR8qsAk+p0lsr0XWV+H/wuCDr5bEcReRIMwdCPfgduQgADAwU8sA7qW9j3kvM
         z3CTe70Aiiobnc8zAgVQNFCjsAiSRmHDj6aWb2/iOf153FFCnxmbagymklpIFWOpKzfY
         J6qv4oOSVEyHnv4kmXr48nyU36WznTRp6uuN33JRh5eB0bEcVxBazhfkHEKWWwcxh6Dn
         g28IvLfBocgqWd0IWzFRrWJ+T/HgvI2F+Q0nZaOGVgrIjRYuhZPza3DuNpE5FTNmkGLf
         36Zg==
X-Gm-Message-State: AOJu0Yz79HpKhWbqsvmyatNO42S1fcJBav3icbrM4AwgQqWPSO511PE7
	ahG19g5ebyFfykoJ+FPz1i/YHlS0yiFhoAgKCbD4/OOym+y2mYM7N7l4rekcSvaUUuKurQ==
X-Gm-Gg: ATEYQzwdclEcMwKFnue6Yvd53JaIbdV7h3PZXv/ek+c0/JxIHEZqEpoFsfBEkqeWjsc
	Yq+pYS0Bgl8ZWVqMEQgrBqo6y8z9NKasU/M9TYz2vte5MXKZNc/JsjdT0l4sywhF09PzVL5G63O
	G8dbjssc5hQfpxDQ147if17U2xG0/Lk+QcgVNMDvmlMv5C+zd3OXF2UTA7CwnKdd/pRiDx96Tv9
	zzF7li4Qs18h4VBDJWAth3dshux3Gdrd7/w3DwvqDp2VmCg8s5lrbCeUuUzbRjaVo5piA7Qe82Q
	NiI3y0+KS9dBKxHs2SVooDfhvAsAWZ4qQpuG+uaznzZHJghDb9UkX5jBVFR1zv1idapEo37QAiS
	+/YpU2YJ6TKvR/U5McP/wYH6wZecPr2XXaxIoTv35lKqgB3tFr3Z4hvZ7ST83YVjMI99EIrMqBY
	6rWKxA+61aUiZhHoJqGMwL
X-Received: by 2002:a05:600c:64c6:b0:485:34a2:919e with SMTP id 5b1f17b1804b1-487160a681bmr14938245e9.33.1774384884561;
        Tue, 24 Mar 2026 13:41:24 -0700 (PDT)
Received: from azaki-desk1.. ([41.234.201.118])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48716658352sm3686825e9.13.2026.03.24.13.41.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2026 13:41:23 -0700 (PDT)
From: Ahmed Zaki <anzaki@gmail.com>
To: netfilter-devel@vger.kernel.org,
	andrew@lunn.ch,
	olteanv@gmail.com,
	pablo@netfilter.org,
	fw@strlen.de,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com
Cc: coreteam@netfilter.org,
	netdev@vger.kernel.org
Subject: [PATCH nf-next v2 0/2] Update (DSA) netdev stats with offloaded flows
Date: Tue, 24 Mar 2026 14:40:14 -0600
Message-ID: <20260324204016.2089193-1-anzaki@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Some devices (notably DSA) delegate the nft flowtable HW offloaded flows
to a parent drivers. The delegating drivers cannot collect or report
the offloaded flows stats since they have no access to the underlying
hardware. This breaks SNMP-based network monitoring systems that rely on
netdev stats to report the network traffic.

Fix by moving the offloaded flow stat reporting to the nft flowtable
subsystem. The first patch adds a new stats field "fstats" to net_device
that is allocated and updated by the nft subsystem only if the new
flag "flow_offload_via_parent" is set by the driver. It also report these
stats back to the user in dev_get_stats().

Patch 2 sets the new flag "flow_offload_via_parent" for the DSA driver.
---
v2: - added the new "net_device->fstats" field since the existing
      tstats cannot be used since it would double-count on devices that
      already use tstats for hardware MIBs (P1).
    - fixed the outdev ifindex logic based. See new func
      "flow_offload_egress_ifidx()" in P1.

Ahmed Zaki (2):
  netfilter: flowtable: update netdev stats with HW_OFFLOAD flows
  net: dsa: update net_device stats with HW offloaded flows stats

 include/linux/netdevice.h             | 45 ++++++++++++
 net/core/dev.c                        |  8 +++
 net/dsa/user.c                        |  1 +
 net/netfilter/nf_flow_table_offload.c | 98 +++++++++++++++++++++++++--
 4 files changed, 146 insertions(+), 6 deletions(-)

-- 
2.43.0

