Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE9023AE87
	for <netfilter-devel@vger.kernel.org>; Sat, 22 Aug 2026 18:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787424439; cv=none; b=N3X/bC7Q6BDVY6T0DXD0DDwxpc4+9Yw6dyZ3RvTmQ/7G8sCfQjHW+cuqG3Fcgvjnobnq5BKiWPHp/mktEpfj4k/M4t41R/Wx098NES1kjplCKDRW2itFBPCVanM2mkPSpNMF2KpMedLWKajqPlxUXwaikLX22IWCJ9m3wNTOkoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787424439; c=relaxed/simple;
	bh=5G43uPiVL/j+Dzwm9QTc44uc3K3VaXP56vy3ld8EoOE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=igyXz07yluaCuoDTfXptBrJ3Ruj/UHwtENCrxlqVdvponNW5iQldkLgwbMwKX1W9ZMo/h2DwMFwfZ4qNfjXgyF3vR9GmR1KZydHnZDH/PnBMRP6Qa0vM9e3A0y7vmXtBzKPHZm4Xtt93TOssy1P9uzoM5kVwdplyCdnKysEgpDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OfMgf1F+; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OfMgf1F+"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-8484a24ccf8so108449b3a.1
        for <netfilter-devel@vger.kernel.org>; Sat, 22 Aug 2026 11:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787424437; x=1788029237; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=r6krEZZrAdPiGjprMWBKZfrQRUv9wjYiRrwTo40Vuek=;
        b=OfMgf1F+Vxyq+yV3XHsyCTTLvHGVdO9N2BEk2bI0Cg/SdKLPaG1cxRuI2tqTWTvXCV
         Y3SQRzlLUu12A0F8mGV2EFw0H+ibPj2q4JPDAS2u14w7PXHzRl2QXka2LO9uNYoq2fU0
         nOEb8EJr7lC6PnsAdjhuE/7u/t03Da/tvvJlZD39+Ru/MGF9Znl9zGLVkL3jxyzCCc04
         DkYV2YtMu6q2hlM9Nf4mKfnE9LN25anbFu2cAa4utOJ1Q66ou8LLvdWrilANCDtX2nKk
         OajxTqC6tuo3QMfiPKKfvyhi7kiMxybM+FqZaTSzVZBA96ZmnXCrolRKh0KKLWjvrgQQ
         C4wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787424437; x=1788029237;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=r6krEZZrAdPiGjprMWBKZfrQRUv9wjYiRrwTo40Vuek=;
        b=O25Mz9M333kt46bAzSpH9So8fp2uSm6j2OkOF5RQUirzhbHduClfmQkN9Hto/kHfII
         Rl81Fanb1fTYp2jSIhal8FjNksEgbc1PPHC8l5lAMIP+WewMZFBvIFFd+agxfRVLZPXq
         SILn4o5EQN+Ysm2sD28V5ypDHoJjPAGrTFkwlfPtOedeVJuYDpFZGMoN3I5TOosAWcT0
         1iuLUgYg9+piJS51lHd786U/R1kJethu/VDyZtZhKMNHosaDugQqCYR4lZAy5bd7pDws
         EWWtI5t5a9sml4PUQIOce8y9Q79aliINGXfb+1AwXsN62kwyUJbl4oKPz/WYu9PznnqV
         UDwQ==
X-Gm-Message-State: AFuF++kjbRysNPIrOprlq3GYZSHa5kYTy1DyGMkO8j/CQZ1IchqgoulW
	7bmfD9p8dOCM/Jr5VPKmer6WzQTpK+h09FY98qwS3IGCgzYqvObPg5Vi
X-Gm-Gg: AR+sD10+rg/Vu9k5Xw5Qtn9+NwWCLjmt1tLtV4iebVvDbueNkwflfOgzDonRHdxh+4p
	e0uG8/X9ItgEl7v7fs++P3KYQ3asGZHrDHuI8WwwPMtsq16CHfLBYRJNkSpWicteANiEG2/NRWU
	9ZHDC+bpy9c/pLO/zs6Lgq06UAVEiAKgbVy0Z+985HHWwNfkoJHUiwV98MoUjAwd7jfyORvCNES
	gUYV/+35g+uaUSO+Qw/kdSG09h8eAoxV/JL8cpkV1iaVOn00anteYrFAsy3QsyrVTTobQY/YGvo
	YRUcC/pYy5JLpX1rWR4BxE15RbLXhXeSjEuJrb8WAkf84HiPmkGgGsMI45wGt+3fSUbWBk9qPR9
	Tz/OCuUdYVpmdQ4KAcRunZUsGTjWPFRr6y4Xb4Pxa8OarmNDrDsy+SWp0TKZeMWc9FW9L5aYya0
	AS9wZSu49lvVGQHL3Z58UKK+Gig2zbQ/lhWcqOW5oCADxn+Ph745adtSchOjnub+oqhDtMmxv8f
	Wdfj3idFIJZ26e+N7HBnzUun6T8mx03/1fubkTiLKQ77Hfmf7P8u/w=
X-Received: by 2002:a17:902:fc4e:b0:2d3:aecd:51f7 with SMTP id d9443c01a7336-2d64ae3a7c7mr135100305ad.1.1787424437214;
        Sat, 22 Aug 2026 11:47:17 -0700 (PDT)
Received: from localhost.localdomain (45.78.65.84.16clouds.com. [45.78.65.84])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-327f9209fafsm16623681eec.23.2026.08.22.11.47.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Aug 2026 11:47:16 -0700 (PDT)
From: Chengfeng Ye <nicoyip.dev@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Gao feng <gaofeng@cn.fujitsu.com>
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] netfilter: nf_log: clear per-net loggers on unregister
Date: Sun, 23 Aug 2026 02:46:58 +0800
Message-ID: <20260822184658.3787672-1-nicoyip.dev@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Logger backends unregister their per-network namespace operations before
unregistering their global logger. This leaves a window where a sysctl or
netlink writer can rebind a per-net logger after the old per-net
selection was cleared, but before the global logger registration is
removed.

The race looks like this:

  CPU 0                                 CPU 1
  ----                                  ----
  unregister_pernet_subsys()
    nf_log_unset(net, logger)
      net->nf.nf_loggers[pf] = NULL

                                        lock nf_log_mutex
                                        find logger in loggers[][]
                                        net->nf.nf_loggers[pf] = logger
                                        unlock nf_log_mutex

  nf_log_unregister(logger)
    lock nf_log_mutex
    loggers[pf][type] = NULL
    unlock nf_log_mutex
    synchronize_rcu()
  module exit returns
  module core frees backend memory

Later, a sysctl read or nf_log_packet() reads net->nf.nf_loggers[pf]
and dereferences the stale logger.

nf_log_unregister() only removes the backend from the global logger
table. It does not clear matching net->nf.nf_loggers[] entries that were
rebound by CPU 1 after per-net teardown. Once module unload completes,
those per-net pointers can still reference static data from the unloaded
logger backend, and later readers can dereference freed module memory.

The kernel reported:

  BUG: unable to handle page fault for address: fffffbfff806d2f4
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  Oops: Oops: 0000 [#1] SMP KASAN NOPTI
  RIP: 0010:nf_log_proc_dostring+0x2aa/0x4d0
  Call Trace:
   proc_sys_call_handler+0x325/0x540
   vfs_read+0x6e1/0xa20
   ksys_read+0xf7/0x1c0
   do_syscall_64+0xf9/0x520
  Modules linked in: [last unloaded: nf_log_syslog]

Fix this by clearing matching per-net logger selections in every live
network namespace while holding nf_log_mutex after removing the global
registrations. Writers that run before this pass are covered by the
per-net clears, and writes that run later can no longer find the logger
in loggers[][]. The existing synchronize_rcu() then covers readers of
both the global and per-net pointers before module memory is released.

Fixes: 5b023fc8d8e0 ("netfilter: enable per netns support for nf_loggers")
Cc: stable@vger.kernel.org
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
---
 net/netfilter/nf_log.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index f4d80654dfe6..442c69f544a1 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -42,6 +42,18 @@ static struct nf_logger *__find_logger(int pf, const char *str_logger)
 	return NULL;
 }
 
+static void __nf_log_unset(struct net *net, const struct nf_logger *logger)
+{
+	const struct nf_logger *log;
+	int i;
+
+	for (i = 0; i < NFPROTO_NUMPROTO; i++) {
+		log = nft_log_dereference(net->nf.nf_loggers[i]);
+		if (log == logger)
+			RCU_INIT_POINTER(net->nf.nf_loggers[i], NULL);
+	}
+}
+
 int nf_log_set(struct net *net, u_int8_t pf, const struct nf_logger *logger)
 {
 	const struct nf_logger *log;
@@ -62,15 +74,8 @@ EXPORT_SYMBOL(nf_log_set);
 
 void nf_log_unset(struct net *net, const struct nf_logger *logger)
 {
-	int i;
-	const struct nf_logger *log;
-
 	mutex_lock(&nf_log_mutex);
-	for (i = 0; i < NFPROTO_NUMPROTO; i++) {
-		log = nft_log_dereference(net->nf.nf_loggers[i]);
-		if (log == logger)
-			RCU_INIT_POINTER(net->nf.nf_loggers[i], NULL);
-	}
+	__nf_log_unset(net, logger);
 	mutex_unlock(&nf_log_mutex);
 }
 EXPORT_SYMBOL(nf_log_unset);
@@ -112,6 +117,7 @@ EXPORT_SYMBOL(nf_log_register);
 void nf_log_unregister(struct nf_logger *logger)
 {
 	const struct nf_logger *log;
+	struct net *net;
 	int i;
 
 	mutex_lock(&nf_log_mutex);
@@ -120,6 +126,10 @@ void nf_log_unregister(struct nf_logger *logger)
 		if (log == logger)
 			RCU_INIT_POINTER(loggers[i][logger->type], NULL);
 	}
+	rcu_read_lock();
+	for_each_net_rcu(net)
+		__nf_log_unset(net, logger);
+	rcu_read_unlock();
 	mutex_unlock(&nf_log_mutex);
 	synchronize_rcu();
 }
-- 
2.43.0
