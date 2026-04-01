Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3FBF235C01
	for <netfilter-devel@vger.kernel.org>; Wed,  1 Apr 2026 04:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775017124; cv=none; b=f0T7yLe/YBdV9cvoqACanME/dHAhyQjdlp1VJbSuMKziCz/hLegeeefwii60TN6mYBwqjLvV+dr4bSA8onxqfQOBqCieylgmkvOWRsxJ32yuy0y17hRp+o10SMB6g9CVxMV5RvY44loOiCQ6+2Yudgqd6icP2Ye+h2FQcmeHw0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775017124; c=relaxed/simple;
	bh=acXAuzX23qeLxDhUDfzHQME8Xoq1UVBejWspbllF3Oc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RPh0V1pC7lNpJKK6Ym8t8YlpijciAYagJ/EAs5tMnJahci1MpIYLTSzDPZc4ZfFiM0qk6jDDgoqXhs3eBolvWx8oCcC5ObmcaPCTOrYMOk2lOYHMGR9bZHChZgc3WbZJiKWrcQd814ECMDWBgzjTS3J0nXC9T20O5I2RnIIwVD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hixdK2/n; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hixdK2/n"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-82a7539851fso2917771b3a.1
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Mar 2026 21:18:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775017121; x=1775621921; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=apmMiJDnFUeVM6e3K+nerLgWWso8fmcaDEUHElGftZI=;
        b=hixdK2/nobQUTw+Wr6OKplotNucQOYExJGWXtJUWW+KEfxTt6kkdBKVK7JeqEtSvQ3
         3t/GfYu6lL6pKD9F9fClYD5HPnSFuH+YvsazPXhoOznkLWGBq+bweUWhTYoJQE9LbcVs
         /9YJ6+F0SQfTSnWBlBgPpir14+UcSYTBcq/m0pPYzIUXCFpLPtcBkuXVrDwMqVXCHyWd
         s6xPAYAIPwkECgRdo3f7IRWP4e/P01kpO2FO5quzHuaOZ80AojQfg6M9WK7KTM02BKo4
         nkUhse10MQKENxyr8JmwIU97p+FfN/bVgzyeTBcJ6PNJYHQQ2QsC6i7fqHdcfskmQyr8
         sjCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775017121; x=1775621921;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=apmMiJDnFUeVM6e3K+nerLgWWso8fmcaDEUHElGftZI=;
        b=CIExnuKJVllH0L7vnIhLMvt5pNGCrYx/f7KWv1OLpK0bBqd1JsCWRdK+zYd1sL9bCU
         vzsFH7BstjxDL4Muszq0j2/JWszO2pyDlUfTXsypAN1+XD6w/sGZH2Ww8PXv+gaN0z/e
         9vdzm8BwxD7ZHYJs+2PaK9IipO/s/mgGEUfAfxqKjkHjrCpdURslvRvsFpHfMplo031M
         MnFrBa816S9dXOIa/eTN5+PnHfL2lvhTmICoapgVtWEv+SWJbKvrHN1Dz5XcusBS1YCh
         ky9ion8Gts89UPIlwnnD7X2SwDT5ewQyhC6jw9WUoEDiXA9RAfZvHp5drCuaT4ORgu3D
         vHVQ==
X-Forwarded-Encrypted: i=1; AJvYcCWjvrXW7cnM+F7qHiieNbbATBomgZAL2Ey4xkzVhIddg0ODAPNE4EcHbVF0xfe5/+BcJaRp1uz+CAaWkylTVWc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx36STd/aoEEqKmEz6tcf93cBu7AoFkw4aW5zwdopGrlJmmS0Gd
	YrIXAYbE75s1I973iRyDizTTbO32hzLEnd9BH1n7RDdTjSPZh5u//OC9
X-Gm-Gg: ATEYQzx1gjNnq82D3SXej/3AuVDEJDqxgekF2+vx5+FSiHgQPx8Em8tLb5c/uEtGsw6
	6mZOPcyknKk9Puk5GZLSGFkWj/9JO2FDZr4fEUrJRn4QR/Rmn7q8sXxnmoCGDJaYnUUNHxgI5+o
	SXukMU0Af7KWnTsj45JpO34zUj55ZODyicAbpotPR7rR/MPhxm6K6rJMilKQlgqiqfGruWVV/PP
	5+uHoNT3Bn9pSPIT5mNuPZI1J71Fp4IHsD9Kap4YF/mbhJ9wDgDb5w/GZiK01uMSvOcOW77v99k
	hlAA5vlGsDH1/K+qWtSigPYZQBS9w/i21TcIf4y7lqyVHuoDJt9Vh62fdY3LV+ZXOqYNU92P+n0
	JgMsHbUuQ4LkGlSwbLCFHto6OYu7NdhSZQO09Leo8+NB9iHOAZGjanlZpdT4VNCDcsPMd8h/Z/N
	b3YdQ6OZqTmVC2X8an5GqCHpINLkJKSL/H0mvwDbG5M92S2nwZPYEAwcdFYKrWn2tMqYQfJRtVP
	Cd8VlY2xFHM
X-Received: by 2002:a05:6a00:3697:b0:82c:215d:5e9d with SMTP id d2e1a72fcca58-82ce8b09852mr2056850b3a.32.1775017121195;
        Tue, 31 Mar 2026 21:18:41 -0700 (PDT)
Received: from SLSGDTSWING002.tail0ac356.ts.net ([129.126.109.177])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82caa8be173sm10963672b3a.55.2026.03.31.21.18.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 21:18:40 -0700 (PDT)
From: Weiming Shi <bestswngs@gmail.com>
To: Simon Horman <horms@verge.net.au>,
	Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Phil Sutter <phil@nwl.cc>,
	netdev@vger.kernel.org,
	lvs-devel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>
Subject: [PATCH net] ipvs: fix NULL deref in ip_vs_add_service error path
Date: Wed,  1 Apr 2026 12:16:12 +0800
Message-ID: <20260401041611.3302189-2-bestswngs@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When ip_vs_bind_scheduler() succeeds in ip_vs_add_service(), the local
variable sched is set to NULL.  If ip_vs_start_estimator() subsequently
fails, the out_err cleanup calls ip_vs_unbind_scheduler(svc, sched)
with sched == NULL.  ip_vs_unbind_scheduler() passes the cur_sched NULL
check (because svc->scheduler was set by the successful bind) but then
dereferences the NULL sched parameter at sched->done_service, causing a
kernel panic at offset 0x30 from NULL.

 Oops: general protection fault, probably for non-canonical address 0xdffffc0000000006: 0000 [#1] PREEMPT SMP KASAN NOPTI
 KASAN: null-ptr-deref in range [0x0000000000000030-0x0000000000000037]
 RIP: 0010:ip_vs_unbind_scheduler (net/netfilter/ipvs/ip_vs_sched.c:69)
 Call Trace:
  <TASK>
  ip_vs_add_service.isra.0 (net/netfilter/ipvs/ip_vs_ctl.c:1500)
  do_ip_vs_set_ctl (net/netfilter/ipvs/ip_vs_ctl.c:2809)
  nf_setsockopt (net/netfilter/nf_sockopt.c:102)
  ip_setsockopt (net/ipv4/ip_sockglue.c:1427)
  raw_setsockopt (net/ipv4/raw.c:850)
  do_sock_setsockopt (net/socket.c:2322)
  __sys_setsockopt (net/socket.c:2339)
  __x64_sys_setsockopt (net/socket.c:2350)
  do_syscall_64 (arch/x86/entry/syscall_64.c:94)
  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)
  </TASK>

Fix by recovering the scheduler pointer from svc->scheduler before
cleanup when the local sched variable has been cleared.  This also
prevents a latent module refcount leak: without the recovery,
ip_vs_scheduler_put(sched) receives NULL and skips the module_put(),
so the scheduler module could never be unloaded if the kernel survived
past the dereference.

Fixes: 05f00505a89a ("ipvs: fix crash if scheduler is changed")
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
---
 net/netfilter/ipvs/ip_vs_ctl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 35642de2a0fee..e0c978def9749 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -1497,6 +1497,8 @@ ip_vs_add_service(struct netns_ipvs *ipvs, struct ip_vs_service_user_kern *u,
 	if (ret_hooks >= 0)
 		ip_vs_unregister_hooks(ipvs, u->af);
 	if (svc != NULL) {
+		if (!sched)
+			sched = rcu_dereference_protected(svc->scheduler, 1);
 		ip_vs_unbind_scheduler(svc, sched);
 		ip_vs_service_free(svc);
 	}
-- 
2.43.0

