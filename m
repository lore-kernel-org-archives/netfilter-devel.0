Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC11042A97;
	Tue,  8 Apr 2025 14:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744122544; cv=none; b=HF+ipDtqPnAiSi0TjnMLqO4YEak02ETikU4X8ne2aqjjYRCNhrSibkg8sWdyLFf3YVa8RAWWk4EqAQspQ9TboqYZ9u5ngZqA8azFHcfWvqeibjtDyfqnRIFKNsaWkoHE3Qh/RBQehdb+flnWwiV61ujoCW2+085mQ+/5ByCD900=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744122544; c=relaxed/simple;
	bh=SgMVvomUnXBZGGUXGP1weiyHidOglQPI5b8NPxX8UE0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bU4dm2xPOB5IOQkKr8jeTrxAM0uDX//+0xWrLY2rft5Z/VaDLrg7k4OvK8wJinocvBjEUC3RRtpNMWoIrq/8spdq9xnW2fK+p9gTiWRMEQydomVSqwS2DNSoNJA+3JHqxKKILUuyUu7DzTSYV/klwTiSrriE3tIs7jgVgQS/plE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fPsgBJP5; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fPsgBJP5"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-aaf0f1adef8so903050866b.3;
        Tue, 08 Apr 2025 07:29:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744122541; x=1744727341; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BtWZI6z2rzxrqOzMM0c3WGmTx0NP8FQ1Z72SAFSkxdA=;
        b=fPsgBJP5k7hy7zvoUf/xXsArANXXy/gyIMB/m+yHwMsV3L70HgPkyRVhg2XuGc4R6H
         IMNEl07QxrEn9kNfHQ+4gnXSLgFu1OEAddTK3PGUhArmL5/5ya6iH2Lb4KClCPAbbJVi
         tmqfFMotDh6otLnCGkP2twmPO/1CPx20ucs3Tyvtz1CRtVb+rZ4ZGtaEQ2VIH0CYsqWn
         3XylwQN98oJ4rXKH/O9m3i8negcUqgbLznb55wyWH7K0I3bXB6EEkzYPS3HCMQC/NKcj
         k4N1Unx6VTrY3E9RrY45vVwo8zplW+v+l/ixGZOZv8zlkyGH0qFnyru1V0aUXYHnHyKf
         rjQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744122541; x=1744727341;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BtWZI6z2rzxrqOzMM0c3WGmTx0NP8FQ1Z72SAFSkxdA=;
        b=oFkEQDAdjwXEZV5SnVs20/YJ2rkXtddwy73iUcvGLT1xpSeX+qIHFUsVfuM8YBrjs2
         pVcfxaeHbEp2eUTachocT1f82aXMmP3v/h/SggSb4dTUGRACKADoXmtTDCC/d21jTy+H
         o2N40L1mzf7fvyZIR0edZufNheJJxWzCfJj3BBKnYZcOf9S4czROB4g0BLDODom/u6EJ
         NajK2XHFvMX1lmPytK3sXnnumcKYxIvDg7mqiP08qOrVvIxK+pQn1j1gHphFE6Nm9jyz
         jYg0+mY944YWpua5IJhgw4RA9O7OI1A0f+1QgDaKLAIh2SHVSi+XTDwiGmCEAmzRF4Ha
         kgjg==
X-Forwarded-Encrypted: i=1; AJvYcCWuC0YtXZ/ee3OY6Br26wsGAsHO0cJ2LPsFmRXPD8s187IPOb5C55fc+jNpeb1dI7zKWRiaKHM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwVfEju/G4DP3b6SuctjwRwNot92lxpPm5ypsY0H/D6L7lHRi0d
	fShlsDHUQWi5tkCI3+wpZ046rh9NJtgRgPLVtsUgXvGepwYoMjw4
X-Gm-Gg: ASbGncsu+brBjP9rk6B8UuVIUf7g9hB4/UlGYLBhpbcSFNtArLGrJB9knPRYR/HGrz0
	ikLCBKClHG7o6X4WLRB99hClxibclCcoO9Zejr+pa9CuGKd72j4DMoDQozJLJj07a9rs2C8LINa
	bY9Z0lZxN2zcMKrDC9g/6op24uhzJ0r0S6b0bOYSvricmwgZYgVgZU+0kAo3T0VavqYj+rTznvu
	ch3J6NZ9LhbSCipGjmsxuzZX/oySbgpjHwRCJrnjOCDabOGUwM3hTqkE6N50ELcDHuPDMBVhin+
	KGDPwLlhzPQ94asZqYAjgA2+XK/P7md6xMkSSWa07KnrIbObhISzzWYysarEJ+VFck4sr4peaja
	ZhUO96PhmhDk3EmGKgMoNfVczGKA1LGdCeVEbXQ4yrA6Bu6MyYTccgHMHgC6UHW4=
X-Google-Smtp-Source: AGHT+IHIJ5q40MIavcNYIWsyq6djzjl+XfDSrI4qMMnPo9qX+djafLA1AnDIrZTyyfQg9EIzOtFnDQ==
X-Received: by 2002:a17:907:d91:b0:ac1:e2be:bab8 with SMTP id a640c23a62f3a-ac7d6d52781mr1145831166b.26.1744122541028;
        Tue, 08 Apr 2025 07:29:01 -0700 (PDT)
Received: from localhost.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac7c01c2c13sm910586466b.182.2025.04.08.07.29.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Apr 2025 07:29:00 -0700 (PDT)
From: Eric Woudstra <ericwouds@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>
Cc: netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v2 nf-next 0/3] flow offload teardown when layer 2 roaming
Date: Tue,  8 Apr 2025 16:28:45 +0200
Message-ID: <20250408142848.96281-1-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In case of a bridge in the forward-fastpath or bridge-fastpath the fdb is
used to create the tuple. In case of roaming at layer 2 level, for example
802.11r, the destination device is changed in the fdb. The destination
device of a direct transmitting tuple is no longer valid and traffic is
send to the wrong destination. Also the hardware offloaded fastpath is not
valid anymore.

This flowentry needs to be torn down asap. Also make sure that the flow
entry is not being used, when marked for teardown.

Changes in v2:
- Unchanged, only tags RFC net-next to PATCH nf-next.

Eric Woudstra (3):
  netfilter: flow: Add bridge_vid member
  netfilter: nf_flow_table_core: teardown direct xmit when destination
    changed
  netfilter: nf_flow_table_ip: don't follow fastpath when marked
    teardown

 include/net/netfilter/nf_flow_table.h |  2 +
 net/netfilter/nf_flow_table_core.c    | 66 +++++++++++++++++++++++++++
 net/netfilter/nf_flow_table_ip.c      |  6 +++
 net/netfilter/nft_flow_offload.c      |  3 ++
 4 files changed, 77 insertions(+)

-- 
2.47.1

