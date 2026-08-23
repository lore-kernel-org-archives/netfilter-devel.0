Received: from mail-yx1-f48.google.com (mail-yx1-f48.google.com [74.125.224.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B40379EFF
	for <netfilter-devel@vger.kernel.org>; Sun, 23 Aug 2026 17:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787504762; cv=none; b=mZ/P7ag5xoKZrBGga68Qr9rW1eptKqOrvXOsCvWKH/q9fQkUx1oggKSVZm2W+DLNHbHADRZ9Va01k/4tZBe54hUzo03iImo1PrBSOwR4uQXy1FBKA8u1HdlLF11uQIrdaeBxvtMocUnwcGdwSumj3Ji/AVXuQ+bCMH/ibNlk2BQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787504762; c=relaxed/simple;
	bh=MOSoskfPWCJYTRcElhbU7017zaNB/Jrp/HctCMM0yCU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kq721No4uHcvEZjvBs0u2WYUWis2V/5W4i1t/yQ9umb8JWC1F/Cl73JWzTnCRGr9PAWghCoeu+3BcISsXJVw9YEcnJRQyrauJptmvlxIJKxQYVqKOsu0a4ZPIZLtQG88dCgwsh7Kt/ljIcGqt5bBZ6jt/BFympbdeyMjpupBphs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jfE6OZiZ; arc=none smtp.client-ip=74.125.224.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jfE6OZiZ"
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-66787b93a0aso302113d50.3
        for <netfilter-devel@vger.kernel.org>; Sun, 23 Aug 2026 10:05:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787504754; x=1788109554; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=esjqTaDB5DT6wtV4Y9AzgjqpTCrwMQJOjGYCKVsLIlo=;
        b=jfE6OZiZqfBaNW0nhyP/lZjc7Vog5R1/gxYLbRc13QdcVBI7eds/P9Pb5JpKM0zngZ
         /3frcuK4JN0d1jA+BOqHB7fcUqsGngxxSre8z5e6OjZyydlAWnE4E2ygbVYSnAnYUKOn
         S8Ft960HzFsHi64gLVrXkpGWcN6osyWlz2g5E3WmgvVwVeEilwBaXJtSCDpTIm2wp1H0
         J8z7KF90hfu7q9M3M/v5zu4UzYivx8f/CMp8sB7jUGDCSxabchvfkpTyUZOOLUbRaQ69
         FRs7kOiAyZWpmY40cE2ybtpDJ8oJLma6BKZucmO/wozU2lEQoQXQw4ZajemHcbuNHUEL
         5wig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787504754; x=1788109554;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=esjqTaDB5DT6wtV4Y9AzgjqpTCrwMQJOjGYCKVsLIlo=;
        b=Y1UEDToo+eol5l3miomeQpIQvLcNpEvDLPyDmEZRCguUSnTPk4HkhUyLcYAbP9yGR/
         vRdZV70vjtt9D/El4GFbj6/QxWWR9jUPP0YlVKkYxSs4z2y+r2khVBhlyw4Vcj1RPD8+
         mvCSZZ+YqFnTqrkqITW/NW9qlAP5Jhkft4v7s+j2WRhxTO5M5C1dSnu5oQYkxAcfuiwG
         MWGKoE13qoGSiT7EVLcB2XtTw6qEZpxxv4U7AiLkfNJIM8p/xgq4wMd2hYagRR4pQ6Ll
         w28Wx461XwZH61v5JdO15gzpUjbEpfAIkqtb/qj+tp0IVlmNwkEvgRAwsMr8Ht1HHTvz
         vhPQ==
X-Forwarded-Encrypted: i=1; AHgh+RrDFmAg+P9RMUM+sa51HnqWkUePogvwJL9Bx2yb4L+e6agITsNfIp+rim9B4yqKeCXCIn51LQzb1DXJVMdtE7g=@vger.kernel.org
X-Gm-Message-State: AFuF++msZ0Zqe84NFWVMNImHCo0rfuVmNwod8sfsWhpVfMULXPsMl5kB
	sigZfFRuMo5X/dxN/u0NmL1RqcQk5U5Vti+g5/JGE6sNF/sa+npbyLNyQyAqBVdXTmw=
X-Gm-Gg: AR+sD10uW0Hxs1+ZAokk9SvA6JaMXHb5khr+ODcIOg0CxWoDTpmjy/niYvtEca048lv
	pHHVFqreFfFQUijwZ+JcA5wC6FoHn1kVhjajWP4AvmRii0AwrCtpl6LrmG4/IFG/wEYi9hp9aVC
	M2IUeSVyd+Y75E6JQs8uenJSbrvygNdfPTISRFdM4SeHqX0Zexgoqs5wcXO9K00GneTzxpfy5Qa
	+gNomS8J9qiOvvLFgdW0LfkbtfhXL7XPqXaGgGb9wo3Jmc2y88b5WK/JFKXNeOnsvIQ3GjkwquY
	ZAodkyRPW+t9iM3QtV/SP1k3ZhiCv/8eKn6dnJU6u8dx68F5bxPrjayHPuuQZ74/pC1llrfNROt
	hdP5eB1GoXRk+IZx5DyAZ9W0qBf3uqrY2FdSei/jrk5j6oEa9sVo18+jM4tX0PsWb3AL4rrj6+o
	M5Q5UZGZ/M/SmqASfo9UCGmK1G03s0v0D4inPmBq4hCZbLy+v0Qwxf0/lWzrWUk6mWZoM90L1NX
	VZZqF32v2oNtylpMXxntYtiGaBNrK6t7IMlKiIWQrRhHlwzLYdE/H0=
X-Received: by 2002:a05:690e:4849:b0:668:99ce:a033 with SMTP id 956f58d0204a3-66ce4a9b51fmr4978933d50.2.1787504753689;
        Sun, 23 Aug 2026 10:05:53 -0700 (PDT)
Received: from localhost.localdomain (45.78.65.84.16clouds.com. [45.78.65.84])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-66cf4a2c3c2sm2333298d50.17.2026.08.23.10.05.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Aug 2026 10:05:52 -0700 (PDT)
From: Chengfeng Ye <nicoyip.dev@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Gao feng <gaofeng@cn.fujitsu.com>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH net v2] netfilter: nf_log: unregister loggers before per-net teardown
Date: Mon, 24 Aug 2026 01:05:38 +0800
Message-ID: <20260823170538.3856770-1-nicoyip.dev@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nf_log_syslog and nfnetlink_log unregister their per-network namespace
operations before unregistering their global logger backends. This
leaves a window where a sysctl or netlink writer can rebind the still-
registered logger after the per-net pre-exit callback cleared the old
selection.

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

Later, a sysctl read or packet logging operation can dereference the
stale per-net logger pointer.

Fix this by unregistering the global logger backends before tearing down
per-net state. Once the global registrations are gone, later writers can
no longer rebind the logger. unregister_pernet_subsys() already waits
for an RCU grace period after the pre-exit callback clears the per-net
selection, while nf_log_unregister() continues to cover readers of the
global logger table.

Apply this ordering fix to both nf_log backends that combine per-net
teardown with global logger registration.

Fixes: 5b023fc8d8e0 ("netfilter: enable per netns support for nf_loggers")
Cc: stable@vger.kernel.org
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
---
Changes in v2:
- Rework the fix around backend teardown ordering instead of clearing
  per-net bindings from nf_log_unregister().
- Apply the ordering fix to both nf_log_syslog and nfnetlink_log.
- Drop the redundant trailing synchronize_rcu().

Link: https://lore.kernel.org/netdev/20260822184658.3787672-1-nicoyip.dev@gmail.com/ [v1]
---
 net/netfilter/nf_log_syslog.c | 2 +-
 net/netfilter/nfnetlink_log.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_log_syslog.c b/net/netfilter/nf_log_syslog.c
--- a/net/netfilter/nf_log_syslog.c
+++ b/net/netfilter/nf_log_syslog.c
@@ -1073,12 +1073,12 @@
 
 static void __exit nf_log_syslog_exit(void)
 {
-	unregister_pernet_subsys(&nf_log_syslog_net_ops);
 	nf_log_unregister(&nf_ip_logger);
 	nf_log_unregister(&nf_arp_logger);
 	nf_log_unregister(&nf_ip6_logger);
 	nf_log_unregister(&nf_netdev_logger);
 	nf_log_unregister(&nf_bridge_logger);
+	unregister_pernet_subsys(&nf_log_syslog_net_ops);
 }
 
 module_init(nf_log_syslog_init);
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -1233,8 +1233,8 @@
 {
 	nfnetlink_subsys_unregister(&nfulnl_subsys);
 	netlink_unregister_notifier(&nfulnl_rtnl_notifier);
-	unregister_pernet_subsys(&nfnl_log_net_ops);
 	nf_log_unregister(&nfulnl_logger);
+	unregister_pernet_subsys(&nfnl_log_net_ops);
 }
 
 MODULE_DESCRIPTION("netfilter userspace logging");
-- 
2.43.0
