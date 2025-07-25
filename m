Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E942EF9A2;
	Fri, 25 Jul 2025 17:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753463036; cv=none; b=dN8sQOUF93P1Z1iC5LV1PBeMY3Y8W9XCrIXW+QGPivwUnnRbYgevK+KDMYjmRgK56RTFyR22VRYSg22KrMEGhmsGR/6br5uRRN91hXTOVh4ALY8ktYt6HuTUcAAc6yhyv9GLldZWquSzrV7ezKgq1+Y0lygVqaBwGy3k6cWCXNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753463036; c=relaxed/simple;
	bh=Ms1RC8rHM1QXjTyFECBwd9yL+I6Y/lkZjPtzkPVjj6k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=i08l9oX9HZ/ptYHJmflCBXRAA4X62txtufxUeac7VU/3ODqc9D2UOPwPQDhOYvxUS/sOxk8wpa0A8yUJsI+DpKZKRV++CrAsv9bt4nQXidgNUuY5LIOODeEjr+MbmyzuieX1Uq8Uzw3X924WhTgMXHi/yKCm+5JieKkys8zQKHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=CwrVNQOD; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=OT5wgzGu; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="CwrVNQOD";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="OT5wgzGu"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 9E3E96027E; Fri, 25 Jul 2025 19:03:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753463033;
	bh=5zJ892qt1l0+0uxWQTmVO8QzsG5iP93tYVgZ528UBZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CwrVNQODNStqJ5xCkMkBKmS0/sXt6uyYQuahNHUjPu1yO7HhZgb62leGx88XolpWq
	 m5laPN3jwdB64oeAkG2vZKj1Mc48BVFHV7EYfXLQBEoD0YQh6qeyG6T30scCUmbUz5
	 yBAutwW5noohm1h0CERpwSSOez2+Y2hdQ8M76iDEp+8AiiYmh+N7PZUralJ8sFbAmf
	 pYB2XYkWZdr43lOnBgAW1m1kf/GquwU9+Qkxu+tSHDmvY1AiistwhGaR07Mo7aO7zj
	 exjwbcoSpnZuHwNrS8K9j11hIYFS2Xvol+YPqq77lK7XG6ZT87fM6ROBgwpI6ySc91
	 Oz9i01sqUfwEQ==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 5201560279;
	Fri, 25 Jul 2025 19:03:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753463031;
	bh=5zJ892qt1l0+0uxWQTmVO8QzsG5iP93tYVgZ528UBZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OT5wgzGuOoJd0lQ4kuQuK9fu38iascjDfOMfrFzTW9PV9wuhRFhwJ1RnH9jb/m7uC
	 +SSSkUGKLKvbGbKIQYa/RjrY2cjxEsaHfTMIqdWoq3KgAh2JZ1uTJ0zdZLMTv6xU0P
	 Lf6JOCf4UjpsOgmJXJVu0c90tv1aFNRd6ngUWDCjnyyea4F/I19UjrHc4yjfvELzks
	 sLJWXxKRlS6tqR0d1996biNOG34XKvq/0AiOIgAC841/Izhk2vmyHeVXfl7xVN/LiN
	 +M+y8XKyR0mgB9bobYDpSlciC1cCafU+1MMoelAHv7LdCpAnKXR9/4XVsWouTursQg
	 EnYAJQ5H5SSzg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 02/19] netfilter: load nf_log_syslog on enabling nf_conntrack_log_invalid
Date: Fri, 25 Jul 2025 19:03:23 +0200
Message-Id: <20250725170340.21327-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250725170340.21327-1-pablo@netfilter.org>
References: <20250725170340.21327-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Lance Yang <lance.yang@linux.dev>

When no logger is registered, nf_conntrack_log_invalid fails to log invalid
packets, leaving users unaware of actual invalid traffic. Improve this by
loading nf_log_syslog, similar to how 'iptables -I FORWARD 1 -m conntrack
--ctstate INVALID -j LOG' triggers it.

Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Zi Li <zi.li@linux.dev>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_log.h          |  3 +++
 net/netfilter/nf_conntrack_standalone.c | 26 ++++++++++++++++++++++++-
 net/netfilter/nf_log.c                  | 26 +++++++++++++++++++++++++
 3 files changed, 54 insertions(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_log.h b/include/net/netfilter/nf_log.h
index e55eedc84ed7..00506792a06d 100644
--- a/include/net/netfilter/nf_log.h
+++ b/include/net/netfilter/nf_log.h
@@ -59,6 +59,9 @@ extern int sysctl_nf_log_all_netns;
 int nf_log_register(u_int8_t pf, struct nf_logger *logger);
 void nf_log_unregister(struct nf_logger *logger);
 
+/* Check if any logger is registered for a given protocol family. */
+bool nf_log_is_registered(u_int8_t pf);
+
 int nf_log_set(struct net *net, u_int8_t pf, const struct nf_logger *logger);
 void nf_log_unset(struct net *net, const struct nf_logger *logger);
 
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 829f60496008..9b8b10a85233 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -14,6 +14,7 @@
 #include <linux/sysctl.h>
 #endif
 
+#include <net/netfilter/nf_log.h>
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_conntrack_l4proto.h>
@@ -555,6 +556,29 @@ nf_conntrack_hash_sysctl(const struct ctl_table *table, int write,
 	return ret;
 }
 
+static int
+nf_conntrack_log_invalid_sysctl(const struct ctl_table *table, int write,
+				void *buffer, size_t *lenp, loff_t *ppos)
+{
+	int ret, i;
+
+	ret = proc_dou8vec_minmax(table, write, buffer, lenp, ppos);
+	if (ret < 0 || !write)
+		return ret;
+
+	if (*(u8 *)table->data == 0)
+		return ret;
+
+	/* Load nf_log_syslog only if no logger is currently registered */
+	for (i = 0; i < NFPROTO_NUMPROTO; i++) {
+		if (nf_log_is_registered(i))
+			return ret;
+	}
+	request_module("%s", "nf_log_syslog");
+
+	return ret;
+}
+
 static struct ctl_table_header *nf_ct_netfilter_header;
 
 enum nf_ct_sysctl_index {
@@ -651,7 +675,7 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.data		= &init_net.ct.sysctl_log_invalid,
 		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dou8vec_minmax,
+		.proc_handler	= nf_conntrack_log_invalid_sysctl,
 	},
 	[NF_SYSCTL_CT_EXPECT_MAX] = {
 		.procname	= "nf_conntrack_expect_max",
diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index 6dd0de33eebd..74cef8bf554c 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -125,6 +125,32 @@ void nf_log_unregister(struct nf_logger *logger)
 }
 EXPORT_SYMBOL(nf_log_unregister);
 
+/**
+ * nf_log_is_registered - Check if any logger is registered for a given
+ * protocol family.
+ *
+ * @pf: Protocol family
+ *
+ * Returns: true if at least one logger is active for @pf, false otherwise.
+ */
+bool nf_log_is_registered(u_int8_t pf)
+{
+	int i;
+
+	if (pf >= NFPROTO_NUMPROTO) {
+		WARN_ON_ONCE(1);
+		return false;
+	}
+
+	for (i = 0; i < NF_LOG_TYPE_MAX; i++) {
+		if (rcu_access_pointer(loggers[pf][i]))
+			return true;
+	}
+
+	return false;
+}
+EXPORT_SYMBOL(nf_log_is_registered);
+
 int nf_log_bind_pf(struct net *net, u_int8_t pf,
 		   const struct nf_logger *logger)
 {
-- 
2.30.2

