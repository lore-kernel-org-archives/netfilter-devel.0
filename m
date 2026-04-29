Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C4C575809
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Apr 2026 09:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777456798; cv=none; b=ojNv8lta1a7ypyRde/HyeZIQxjPy1YXGkJ7egGTnOy9Z06ih4tq1PL54LnjxwNZlV/E+/X2YW2C2Pgpakx1WbUeD4SVoIDZmn6RpBl7suBDzBs3yQTwPrJ4RTQAXqYCa3pCJkxacdrdYD8RTpPkztPDqvAnyE0vswBUOLbc6aPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777456798; c=relaxed/simple;
	bh=rhuy/sYm+M0zYQwug0X402cIA2TyRVKh+edLoRpK3Hg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CPOBlAfwXJFYHU71ReLH5BVSw8qnX/XPQovdGX3zkbtC6cLsi+0RlIifu3Ay3BKe4Jg9OoHQ59yQXQpn+rGtHNBYOVRrZVjFFh1u9WEqQ7DNQ85FRb0I71o2oVNUbwTvHjks8ptACBEEZL7+CIdkbs58+jtRc1HjHoOlvO/pEMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 062B960331; Wed, 29 Apr 2026 11:59:53 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: x_tables: disable 32bit compat interface in user namespaces
Date: Wed, 29 Apr 2026 11:59:46 +0200
Message-ID: <20260429095949.20910-1-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This feature is required to use 32bit arp/ip/ip6/ebtables binaries on
64bit kernels.  I don't think there are many users left.

Support has been a compile-time option since 2021 and defaults to off
since 2023.

The XTABLES_COMPAT config option is already off in many distributions
including Debian and Fedora.

Give a few more months before complete removal but disable support in
user namespaces already.

Assisted-by: Claude Code:claude-sonnet-4-6
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Alternatively this could be ripped out instantly, if thats
 preferred.  This provides a mix, it would still allow such
 a system to work in init userns.

 include/linux/netfilter/x_tables.h | 17 +++++++++++++++++
 net/bridge/netfilter/ebtables.c    |  4 ++++
 net/ipv4/netfilter/arp_tables.c    |  4 ++++
 net/ipv4/netfilter/ip_tables.c     |  4 ++++
 net/ipv6/netfilter/ip6_tables.c    |  4 ++++
 5 files changed, 33 insertions(+)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 77c778d84d4c..4c5b3eba5a6e 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -524,4 +524,21 @@ int xt_compat_check_entry_offsets(const void *base, const char *elems,
 				  unsigned int next_offset);
 
 #endif /* CONFIG_NETFILTER_XTABLES_COMPAT */
+
+static inline bool xt_compat_check(void)
+{
+#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
+	if (!in_compat_syscall())
+		return true;
+
+	pr_warn_once("%s %s\n",
+		     "xtables 32bit compat interface no longer supported",
+		     "in namespaces and will be removed soon.");
+
+	if (!capable(CAP_NET_ADMIN))
+		return false;
+#endif
+	return true;
+}
+
 #endif /* _X_TABLES_H */
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index aea3e19875c6..92461c7e1e18 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -2449,6 +2449,8 @@ static int do_ebt_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
 	struct ebt_table *t;
 	int ret;
 
+	if (!xt_compat_check())
+		return -EPERM;
 	if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
 		return -EPERM;
 
@@ -2514,6 +2516,8 @@ static int do_ebt_set_ctl(struct sock *sk, int cmd, sockptr_t arg,
 	struct net *net = sock_net(sk);
 	int ret;
 
+	if (!xt_compat_check())
+		return -EPERM;
 	if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
 		return -EPERM;
 
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 1cdd9c28ab2d..acb346731d89 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -1416,6 +1416,8 @@ static int do_arpt_set_ctl(struct sock *sk, int cmd, sockptr_t arg,
 {
 	int ret;
 
+	if (!xt_compat_check())
+		return -EPERM;
 	if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN))
 		return -EPERM;
 
@@ -1444,6 +1446,8 @@ static int do_arpt_get_ctl(struct sock *sk, int cmd, void __user *user, int *len
 {
 	int ret;
 
+	if (!xt_compat_check())
+		return -EPERM;
 	if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN))
 		return -EPERM;
 
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 23c8deff8095..e34647da90e9 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1622,6 +1622,8 @@ do_ipt_set_ctl(struct sock *sk, int cmd, sockptr_t arg, unsigned int len)
 {
 	int ret;
 
+	if (!xt_compat_check())
+		return -EPERM;
 	if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN))
 		return -EPERM;
 
@@ -1651,6 +1653,8 @@ do_ipt_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
 {
 	int ret;
 
+	if (!xt_compat_check())
+		return -EPERM;
 	if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN))
 		return -EPERM;
 
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index d585ac3c1113..0c037f025210 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1631,6 +1631,8 @@ do_ip6t_set_ctl(struct sock *sk, int cmd, sockptr_t arg, unsigned int len)
 {
 	int ret;
 
+	if (!xt_compat_check())
+		return -EPERM;
 	if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN))
 		return -EPERM;
 
@@ -1660,6 +1662,8 @@ do_ip6t_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
 {
 	int ret;
 
+	if (!xt_compat_check())
+		return -EPERM;
 	if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN))
 		return -EPERM;
 
-- 
2.53.0

