Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5ABB2C032E;
	Thu,  3 Sep 2026 00:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788396127; cv=none; b=bMLWu+QuDGACSXzxGB6qYba92HwQ/Hp/B5imQ9MtyVXNGeLdnMIpsnxN7HSC7cx2IgZKZMLekilnnTFiqcxz3G9cH71OPHGszU4fuwg7IIE3SLuNwcF7AStfwdqt8DyJb8tLXPYhp/1CYOlaNi536wKkjxcguN2U3EtU9IWKBHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788396127; c=relaxed/simple;
	bh=j//+aCoHo69GvaL29DTIKGJcsWJ3gzsqCSwwbIsUKZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JSMZTR3HMczYUgnYJSfh15ovvTxIZDUTYpJfxPhFqq5YUSP+Y5g0jlvNnUg+atvmV9fY1lCSR4o3Gv85mUfIYCAWnNK3zWr8DqLpzk4M3v3A4afv5GsB/Q/UOEdfANfg+opkVPrBGRSPaBZx4wMOorpmcSiTIcJ/pJ5tIHwkZbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=S4iLxEdC; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="S4iLxEdC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1788396121;
	bh=75zm4Zv/VJQ0PNPQaL6qVc2OOOCrx9vK8HC4FqbFJUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S4iLxEdCWdchVJMDXnMgzm8xLecgWrKuw8n7wrvtL6pYSwVxA28s0Pv0NAWXbvztl
	 nZctVuAkFcNSc7Zm6TbuzHEe4jMmbfvMWuCcB2I0S02hbwXE1UdYnAN35fNd7V9Y6h
	 lmvDZ6Cq/3XBf4tE/6zlcrC2p2LQxtI92UPuTgbJwZJASQh7Z8CwU53RyQx5MGv9Dt
	 iClQbjDJevq2NT3KsWJgzErjW7jt+d4SK06HR/FJ56adLdiTqsOeTWn2FY6ypfXddC
	 PdKIK3w+zF34NHikqaI29VVmL4GUPBvbIrPItswKlIEk43pXTgWucVZP7QeV6O0TPr
	 vBMTO0vfUVUBg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 318B3607AB;
	Thu,  3 Sep 2026 02:42:01 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 05/12] netfilter: nf_log: unregister loggers before per-net teardown
Date: Thu,  3 Sep 2026 02:41:42 +0200
Message-ID: <20260903004149.1037028-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260903004149.1037028-1-pablo@netfilter.org>
References: <20260903004149.1037028-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Chengfeng Ye <nicoyip.dev@gmail.com>

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
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_log_syslog.c | 2 +-
 net/netfilter/nfnetlink_log.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_log_syslog.c b/net/netfilter/nf_log_syslog.c
index f24288088c0d..c3fd398ffcd7 100644
--- a/net/netfilter/nf_log_syslog.c
+++ b/net/netfilter/nf_log_syslog.c
@@ -1073,12 +1073,12 @@ static int __init nf_log_syslog_init(void)
 
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
index 6c7fa2ed34f5..9d7fec570abe 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -1233,8 +1233,8 @@ static void __exit nfnetlink_log_fini(void)
 {
 	nfnetlink_subsys_unregister(&nfulnl_subsys);
 	netlink_unregister_notifier(&nfulnl_rtnl_notifier);
-	unregister_pernet_subsys(&nfnl_log_net_ops);
 	nf_log_unregister(&nfulnl_logger);
+	unregister_pernet_subsys(&nfnl_log_net_ops);
 }
 
 MODULE_DESCRIPTION("netfilter userspace logging");
-- 
2.47.3

