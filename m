Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B72A8635D
	for <netfilter-devel@vger.kernel.org>; Sun, 11 Jan 2026 16:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768149605; cv=none; b=fA4tJpiHyKPPQN5xDXz99ebQoy/NpX6icZloglWge9yid+iojHD0+tSt28pqo4NqWGs+DtikBjbleoBMYjQaop8tq9RMB+CFRAobG0kHKttVqKbc2Ba+e5R/PoOeQuuvLVHzasVaJxeiqEuXU1/sECCEo2TLljwGghZW7967wg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768149605; c=relaxed/simple;
	bh=MxMcYVIgRbYfh0rFiiCqsHIOVDVN/kZZi3RDEjnrfCc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=oTYqVMqKNbYrSAlL5HG2NeZnH+ewGQ/H5sXTp4kEdtueM5nV0xQZHPmhWVLAMJJDSSqwyRMotoOexwr+OPlbJ4+p/EKExzVOFLNQcMADtUoCZJq38shJl/2282iHNZKuYyYIYahsO4yjRoi6WsdIz5JLAXmj66VwVPj0YuVyvok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com; spf=none smtp.mailfrom=mojatatu.com; dkim=pass (2048-bit key) header.d=mojatatu-com.20230601.gappssmtp.com header.i=@mojatatu-com.20230601.gappssmtp.com header.b=oofFwwLI; arc=none smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mojatatu-com.20230601.gappssmtp.com header.i=@mojatatu-com.20230601.gappssmtp.com header.b="oofFwwLI"
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-8b21fc25ae1so627966785a.1
        for <netfilter-devel@vger.kernel.org>; Sun, 11 Jan 2026 08:40:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20230601.gappssmtp.com; s=20230601; t=1768149603; x=1768754403; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WL9Ug8xkqjklDfwBwNk5OOPAvnm8qtO0OGOkv7e+h50=;
        b=oofFwwLIRXuscYKwKeDofAoUNIHGwly8OFgAFwf6xupuz/c+39bApmUUHpYlYi6U54
         TkJibHsT0tF/Srrum2RrAUQJOo/fNBWEjRRfGuAMHJzCw14I8Kj5OXnFzpoBF2n8SdOt
         l89R14Asjo4ApV+fNke5CmrjLFE4eEp1p3KmY2Jmyw6vp9UT0tas+0UUTWg5e2ypne2t
         0xQLKrCHYFjV9dZEYqOe1PAIk79ywjLwvhifFUGEV0loGvt5sTvXOo+JAMhFgrPRXLXK
         Igiml+vjLXJv0UOK/m3DMCBoH/2zT70DHsen3/zMZWfc6+DF5FzbxlLfDyhg9pw5Zi85
         dNyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768149603; x=1768754403;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WL9Ug8xkqjklDfwBwNk5OOPAvnm8qtO0OGOkv7e+h50=;
        b=WCBeOdFPn+acrJ/0/2UMzv5dqCYKLp3pWOu7/Ywm5aq+k/XkgwuJkcvtQTC8fhuZSC
         s1eaFQoMx1Y1Js4DT4BLZU6hKZjpHADEN7RtMJcFimhRAajcFuol7t6pKrOEyaIuVspJ
         JXq8zD+72Fk3CGKvKx51W/VI88L0Nuv1wOOp6+IIAgE6wAFLoXRSNUtUVlE2jqPPFm5i
         9GFPE7FAEDP2s2/ZOlEm7gcroeC+Sm8t/D4e66QeAdxD2Y97jLIDWb4K83uCb68Z+T0l
         jrQbnI/44O/8i6Yi6cJlt6LuBqRfIC5J3TKnzxPWgR+vsdJrzDbmZHH7BwGu+cmgQYen
         SRFg==
X-Forwarded-Encrypted: i=1; AJvYcCXBBemtbqWeuwJdrvt16KqROvy2Yk79JPCzDZeMINKhj+RF861porVPazsOiU4kpl24nVFEVZTaVOdBwzlutuY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxiGYfa1iZnfmc0/OPUv9s6TpSSo0DF6jSTh5XX5z3RQh/vRaK8
	e6IauvM7ezqtqtUFefDOY/2YqJiN5+jsO5C9ir1y2jQRvSp9xuKPqszOISIT0Qircw==
X-Gm-Gg: AY/fxX5vt5QMz1JKJhNoaGQIs9bnpBqVuDxaVBq+8ZThmEUjFBRSueAxkQwrf1sIC2x
	N4OFumn4OgLQcQDI+cnZrVokk0HYcVkegidDDx8m+GKvpZBy6o61wYDCrn295eEyJaft8OLGOKp
	JkO6m2XfvqRwVjho58u5c9+MwgtnnZIJBxVNEYZrFqnSA93h/NxQo4VawsYJfXwLIDASWqau49v
	OQlwqJeFvDhFUOgrui7o/+xL2bCj8D67ZNcI7mYtk2+7BVpElmPm3HeG0SxmCtYxiG7TS0ZhjZk
	mYgUlCyZLeuyhEdNWmfU+7Zu/MItSzxCBXI2mBnx04vrBg8hx5nwzT2CW1DeZWXgVWLrKe74vLU
	rKEruecpaQJo9LHaFm9tjUMpwtI25fnwnS26M8bTXGgPmkXvSB5vLy9GZMirb59UEZgnqyLanYS
	tcoKwO/wu+ADk=
X-Google-Smtp-Source: AGHT+IEFX7JXVycdqr/9Yzb7U5IV6nPV70NkmG/kT8Fqxgk9zK0kXga7VUtD2GdRsaC2cWSh2fnhZg==
X-Received: by 2002:a05:620a:4887:b0:8aa:f08:bed0 with SMTP id af79cd13be357-8c38940cd29mr1929733085a.79.1768149603185;
        Sun, 11 Jan 2026 08:40:03 -0800 (PST)
Received: from majuu.waya ([70.50.89.69])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c37f4a8956sm1276589085a.10.2026.01.11.08.40.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jan 2026 08:40:02 -0800 (PST)
From: Jamal Hadi Salim <jhs@mojatatu.com>
To: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	andrew+netdev@lunn.ch
Cc: netdev@vger.kernel.org,
	xiyou.wangcong@gmail.com,
	jiri@resnulli.us,
	victor@mojatatu.com,
	dcaratti@redhat.com,
	lariel@nvidia.com,
	daniel@iogearbox.net,
	pablo@netfilter.org,
	kadlec@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	zyc199902@zohomail.cn,
	lrGerlinde@mailfence.com,
	jschung2@proton.me,
	Jamal Hadi Salim <jhs@mojatatu.com>
Subject: [PATCH net 0/6] net/sched: Fix packet loops in mirred and netem
Date: Sun, 11 Jan 2026 11:39:41 -0500
Message-Id: <20260111163947.811248-1-jhs@mojatatu.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit


We introduce a 2-bit global skb->ttl counter.Patch #1 describes how we puti
together those bits. Patches #2 and patch #5 use these bits.
I added Fixes tags to patch #1 in case it is useful for backporting.
Patch #3 and #4 revert William's earlier netem commits. Patch #6 introduces
tdc test cases.

Jamal Hadi Salim (5):
  net: Introduce skb ttl field to track packet loops
  net/sched: Fix ethx:ingress -> ethy:egress -> ethx:ingress mirred loop
  Revert "net/sched: Restrict conditions for adding duplicating netems
    to qdisc tree"
  Revert "selftests/tc-testing: Add tests for restrictions on netem
    duplication"
  net/sched: fix packet loop on netem when duplicate is on

Victor Nogueira (1):
  selftests/tc-testing: Add netem/mirred test cases exercising loops

 drivers/net/ifb.c                             |   2 +-
 include/linux/skbuff.h                        |  24 +-
 include/net/sch_generic.h                     |  22 +
 net/netfilter/nft_fwd_netdev.c                |   1 +
 net/sched/act_mirred.c                        |  45 +-
 net/sched/sch_netem.c                         |  47 +-
 .../tc-testing/tc-tests/actions/mirred.json   | 616 +++++++++++++++++-
 .../tc-testing/tc-tests/infra/qdiscs.json     |   5 +-
 .../tc-testing/tc-tests/qdiscs/netem.json     |  96 +--
 9 files changed, 698 insertions(+), 160 deletions(-)

-- 
2.34.1

