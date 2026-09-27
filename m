Received: from mail-dy2-f43.google.com (mail-dy2-f43.google.com [74.125.229.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FDE73B71B2
	for <netfilter-devel@vger.kernel.org>; Sun, 27 Sep 2026 06:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790490294; cv=none; b=Y2srJv6voENgLoAWTfTC/T6uDB/L8vwFedUtx/QMn+rSFRdNlQw0yFXT9x3GS9idzJ3/zaBnK+Dbujbu+Ki77z8SdE1mpDyoWNFnlRJMX/7h0dNvrGTtxmw79oWtJ6zqo0X/QpEedzBuc222miO7mW0+ZqlmhKbVyCIM8itonWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790490294; c=relaxed/simple;
	bh=eT/fj5vZ0Sj0xWvtck5u0p9IG2kOT0o4JMJn6zf0/qU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=O7yj7GrkmnGDUmdUFiULezCb5mS3k+LEqZSTFu6LrLqahgR0si23r+ckZ/kCUw4J3JJgwf2v8YLCRU+VvW6DLiuRaFL+iaHiUjU6E7LzkO6aDyDA7p5JHwT3H1SZpO588ugubgax7b1gMPOclHdTuSfM+FWxjvNjvESRPd/DbAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FBqWKevv; arc=none smtp.client-ip=74.125.229.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FBqWKevv"
Received: by mail-dy2-f43.google.com with SMTP id 5a478bee46e88-33e79c06622so185468eec.3
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Sep 2026 23:24:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790490291; x=1791095091; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=9lvIFmMP4hhC0qEm4iuvni2Axxi7Wmdx8mVA3p2P2mI=;
        b=FBqWKevvtUd2QdrC97qdrqzsBIb61h0S1+7pNq9x7edXsNUKxvnvhoOusCjDhLUPmz
         AAW8nV4hay+UuN/6Pcw0fABgsGacFzX44OoeXxvPHRnEbJRcVu8UyphbwqBjhhgJ9/R7
         mqeQ2CfV4tB9DWQwuN1DSmwnNVx25CBDwhU39r4qUP4BzGC1jjT/bkfIK4qJ3pN0eCXL
         CoLFnO2wxnuPtfiqPgEkcl0R4KFvEOKFcTxEnVUsHUwUdndlSVNTInYuWptdN+kwE/hN
         ZjrAFr4vFrHywWVWVht1vs6M3Lj/xE9wZkVPq3g6xAIGMLZ9JM6m6FHpMn10X53Ba2SZ
         C05Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790490291; x=1791095091;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9lvIFmMP4hhC0qEm4iuvni2Axxi7Wmdx8mVA3p2P2mI=;
        b=cFmhUtWVccZtdhn6AHBxCdk8coYMq0mrYjMnkYcIo5QcdkrF0xDTRb2IvayTdiPFK1
         xQ7W/BgReu4kklo5PqoS5hRhkBtgHu1QGctPr4SSve90Sit+g5jjlGCqOcsZuGK/IGB8
         M7A+ejpnvDhADofQSYGtzKQUCsK5MlBc0jWYQzJN5eZOkAQSoXi6X9VN6kBcWZQOmSkf
         tcxKNiOnCiPqQSgfUPEe9FJILEKbtMPsSY5WLPzlnlqWBcgfctPbnCTutsHrPajyYklw
         LFTQk/YkkJztYWvFUSeQQot67SCMDr1ZJRcWDu11E+/malkt2V+JcSaUQlfsNzY3J26o
         p55w==
X-Forwarded-Encrypted: i=1; AKwUvBzY+y52Hld2yGKwW6Mq3xMXxqAwrtNeKANd5vWPFAJejGd70qMHyWBytye4kVMLTFpMjlmfTNvPaWXOIKbL0DU=@vger.kernel.org
X-Gm-Message-State: AFq9FYIFOv7oYgyZVMzVlZ+dOhhXi8K6lB5J2SwFkrd8qHzs+6Y6aQ2y
	GxGzmZUmiKHcmyziTOuXCS9yiWOAAc2FrvpsFryNk/NnelrKnr1nBe89
X-Gm-Gg: AYBFou25gpZP95FmG2IOW5nCjOqdZWFX5lNtHkWPRtWHz0Uh7I2GF4j3GaOiLvzv0Tu
	+gfZZ70uIlACq/AwkIN6o0Ipt8+kUOrUmFqFMS6TPw6ov52jK2SySgd9/Sf/VtphdHDheijIqp4
	CHWqJrrVRRZhyzSw+nEd28CWIfm6mca/RfGvjcBtzyI2sblUa1YOS5hnCVhwyxNZ1R1XwWEFfAD
	YdIm7Ql2hANkKtYVCrsakE4yg72RCZKVrPOHNzzZvJkvRmkPyDgi9CBtkqTOFDH36ECMBLRs2VF
	eJwENYCZ5hUlpi64Uip9xbdDguA05QFzb2DsJp+ubD88IfjaYXycbGYOlL7qVcLLeIaJ8ghMiRS
	Ynbx5XC/yKA5M5Jf2h64siXqZCZ34FoLbEX9NDFciSAK5cMCESYSuM6jSjn4pvoBVObh22DQDH7
	tTcMs8aw4q9TypOMl6rWPzXEBe/5Ek2PgE6PL8CGXdtSgSoSIni39kAfBIOiVvK7Nx5cBS3j6ZE
	Q8tV9DgLaroqcVwD9Mwi/AKH4k3qDDfXhA86fM0fYXsW+y3OhmEPG6DaUzywcCFJpEKW137hIAg
	Gcdz
X-Received: by 2002:a05:7300:f64b:b0:33e:4e49:d08d with SMTP id 5a478bee46e88-34272b4bc81mr8484339eec.1.1790490291342;
        Sat, 26 Sep 2026 23:24:51 -0700 (PDT)
Received: from localhost.localdomain (95.169.12.199.16clouds.com. [95.169.12.199])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3413fc2413dsm19056291eec.0.2026.09.26.23.24.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2026 23:24:50 -0700 (PDT)
From: Chengfeng Ye <nicoyip.dev@gmail.com>
To: Simon Horman <horms@verge.net.au>,
	Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Hans Schillstrom <hans.schillstrom@ericsson.com>
Cc: netdev@vger.kernel.org,
	lvs-devel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-kernel@vger.kernel.org,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH net] ipvs: fix protocol data lifetime during namespace teardown
Date: Sun, 27 Sep 2026 14:24:35 +0800
Message-ID: <20260927062435.3690129-1-nicoyip.dev@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

IPVS frees its per-net protocol data before control cleanup cancels
defense work and unregisters the sysctl table. A defense worker can load
a protocol data pointer, then namespace cleanup can unlink and free that
object before the worker dereferences pd->pp or pd->next. The worker's
securetcp_lock does not serialize with protocol cleanup. A concurrent
defense-mode sysctl write can reach the same timeout update path.

KASAN reported:

  BUG: KASAN: slab-use-after-free in ip_vs_protocol_timeout_change
  Workqueue: events_long defense_work_handler
  Call Trace:
   ip_vs_protocol_timeout_change+0x1b4/0x1e0
   update_defense_level+0x63e/0xd80
   defense_work_handler+0x1e/0xc0
  Allocated by task 125:
   ip_vs_protocol_net_init+0xda/0x2f0
   __ip_vs_init+0x16b/0x240
   setup_net+0xfc/0x310
  Freed by task 12:
   ip_vs_protocol_net_cleanup+0x1d6/0x2e0
   __ip_vs_cleanup_batch+0x7d/0x100
   cleanup_net+0x38c/0x770

Run control cleanup before protocol cleanup so that defense work and
active sysctl handlers have finished before their protocol data is freed.
Initialize protocols before exposing the control interface, and unwind
in reverse order, to enforce the same lifetime on initialization failure.
Protocol initialization and exit do not depend on control state.

Fixes: 9330419d9aa4 ("IPVS: netns, use ip_vs_proto_data as param.")
Cc: stable@vger.kernel.org
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
---
 net/netfilter/ipvs/ip_vs_core.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index fd503f0efb57..8a3c880fdb26 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -2502,12 +2502,12 @@ static int __net_init __ip_vs_init(struct net *net)
 	if (ip_vs_estimator_net_init(ipvs) < 0)
 		goto estimator_fail;
 
-	if (ip_vs_control_net_init(ipvs) < 0)
-		goto control_fail;
-
 	if (ip_vs_protocol_net_init(ipvs) < 0)
 		goto protocol_fail;
 
+	if (ip_vs_control_net_init(ipvs) < 0)
+		goto control_fail;
+
 	if (ip_vs_app_net_init(ipvs) < 0)
 		goto app_fail;
 
@@ -2527,10 +2527,10 @@ static int __net_init __ip_vs_init(struct net *net)
 conn_fail:
 	ip_vs_app_net_cleanup(ipvs);
 app_fail:
-	ip_vs_protocol_net_cleanup(ipvs);
-protocol_fail:
 	ip_vs_control_net_cleanup(ipvs);
 control_fail:
+	ip_vs_protocol_net_cleanup(ipvs);
+protocol_fail:
 	ip_vs_estimator_net_cleanup(ipvs);
 estimator_fail:
 	net->ipvs = NULL;
@@ -2547,8 +2547,8 @@ static void __net_exit __ip_vs_cleanup_batch(struct list_head *net_list)
 		ipvs = net_ipvs(net);
 		ip_vs_conn_net_cleanup(ipvs);
 		ip_vs_app_net_cleanup(ipvs);
-		ip_vs_protocol_net_cleanup(ipvs);
 		ip_vs_control_net_cleanup(ipvs);
+		ip_vs_protocol_net_cleanup(ipvs);
 		ip_vs_estimator_net_cleanup(ipvs);
 		IP_VS_DBG(2, "ipvs netns %d released\n", ipvs->gen);
 		net->ipvs = NULL;
-- 
2.43.0

