Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D87223314AB;
	Mon,  5 Jan 2026 08:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767601615; cv=none; b=IuffSexxaVrCwbs6O2rg/45N8FK2p/nFMUMJrnPVnRieSsjZfspXbS6XphUtM8VQYO8FZyLcKrEWHB9yfLWGlwauH5xlFHBCagUwkxzdF9fOg+W5fZkFS2+bDosBHkDlR4bEiTFHwiibTD3nO0mQwJMTru+e7XfMGtjly6xTOFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767601615; c=relaxed/simple;
	bh=P4/2AsT9n14c0ef4aSD1ALtr5hfCRfM8S6Cf4YlCz0I=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=EJIEmBPye5o5pmeOGFHH298AmdACF+jilvoiuJNnmsyUOPY7KJEpPeFcAEC2Syv+9dkO4gaYOBXZanuDdjSc4tPm7CLDwKYU/4CycmDSEzc9CVvg+9ihpIf4QzL0CnUEKkSyYuYZSs4iBRbWzuN6LdYd1kYnw1fFrQIEwlR3Z64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=J/lGH1yV; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=ZIAXgaRp; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="J/lGH1yV";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="ZIAXgaRp"
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1767601612;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+IjD3h3khDbzYNe/aBGpfLpRCToA2hBBmeoprUDwalw=;
	b=J/lGH1yV0CqsK7lMoSSr3DnEmr8bbIbbLfPIueCg7YHnRgNMF0kHnp+jLT+YuxQmN4X92C
	d655+Bl2tCThO+1RX4n+dAyYrZQHObWtPmFrDvaQ2UtDwqRKM3u9E9ZUyusJBTZgc1xmQD
	wMiv0ZGwuN7c4TF4sayXKwaeMbLBFFFZfQKgDWBKGc78VYLipYGJ4h8uW8W47k4ypeInbb
	KkhLbA9e9KcQ+7iqc04hTMUHUzuu4V1FAczVIQxEedNlBkwdwbNloo5jQO0+jgu0isC6lz
	57m+79FWsRkY4RPAqU4O9UBTH6v61ppHn/BgYEQ8ay3o68xUhl3m11kC8paITA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1767601612;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+IjD3h3khDbzYNe/aBGpfLpRCToA2hBBmeoprUDwalw=;
	b=ZIAXgaRp8E+FxrBqV1a30iCVQsobmwftBdzvXn8owa0MmKkJuoy22J02rZ7b2wVJVrNAyq
	VIpmLZu3as47VJDw==
Date: Mon, 05 Jan 2026 09:26:49 +0100
Subject: [PATCH RFC net-next 3/3] netfilter: uapi: Use UAPI definition of
 INT_MAX and INT_MIN
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260105-uapi-limits-v1-3-023bc7a13037@linutronix.de>
References: <20260105-uapi-limits-v1-0-023bc7a13037@linutronix.de>
In-Reply-To: <20260105-uapi-limits-v1-0-023bc7a13037@linutronix.de>
To: "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
 Andrew Lunn <andrew@lunn.ch>, Pablo Neira Ayuso <pablo@netfilter.org>, 
 Jozsef Kadlecsik <kadlec@netfilter.org>, Florian Westphal <fw@strlen.de>, 
 Phil Sutter <phil@nwl.cc>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org, 
 netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, 
 coreteam@netfilter.org, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1767601610; l=3712;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=P4/2AsT9n14c0ef4aSD1ALtr5hfCRfM8S6Cf4YlCz0I=;
 b=3kbE7So0hiBtD8nxv9RU5JAhr0H365fotZ8m/pGC3lRQdLC1DaILXOwzSk+6+CbEQuZdVEFVc
 MlUAOh9yWfJCQEBW8rQlaaOgo19di8zwFbFKZvnr6CV9kqbEzLCW5ip
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=

Using <limits.h> to gain access to INT_MAX and INT_MIN introduces a
dependency on a libc, which UAPI headers should not do.

Use the equivalent UAPI constants.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
---
 include/uapi/linux/netfilter_bridge.h | 9 +++------
 include/uapi/linux/netfilter_ipv4.h   | 9 ++++-----
 include/uapi/linux/netfilter_ipv6.h   | 7 +++----
 3 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/include/uapi/linux/netfilter_bridge.h b/include/uapi/linux/netfilter_bridge.h
index 1610fdbab98d..6ace6c8b211b 100644
--- a/include/uapi/linux/netfilter_bridge.h
+++ b/include/uapi/linux/netfilter_bridge.h
@@ -6,15 +6,12 @@
  */
 
 #include <linux/in.h>
+#include <linux/limits.h>
 #include <linux/netfilter.h>
 #include <linux/if_ether.h>
 #include <linux/if_vlan.h>
 #include <linux/if_pppox.h>
 
-#ifndef __KERNEL__
-#include <limits.h> /* for INT_MIN, INT_MAX */
-#endif
-
 /* Bridge Hooks */
 /* After promisc drops, checksum checks. */
 #define NF_BR_PRE_ROUTING	0
@@ -31,14 +28,14 @@
 #define NF_BR_NUMHOOKS		6
 
 enum nf_br_hook_priorities {
-	NF_BR_PRI_FIRST = INT_MIN,
+	NF_BR_PRI_FIRST = __KERNEL_INT_MIN,
 	NF_BR_PRI_NAT_DST_BRIDGED = -300,
 	NF_BR_PRI_FILTER_BRIDGED = -200,
 	NF_BR_PRI_BRNF = 0,
 	NF_BR_PRI_NAT_DST_OTHER = 100,
 	NF_BR_PRI_FILTER_OTHER = 200,
 	NF_BR_PRI_NAT_SRC = 300,
-	NF_BR_PRI_LAST = INT_MAX,
+	NF_BR_PRI_LAST = __KERNEL_INT_MAX,
 };
 
 #endif /* _UAPI__LINUX_BRIDGE_NETFILTER_H */
diff --git a/include/uapi/linux/netfilter_ipv4.h b/include/uapi/linux/netfilter_ipv4.h
index 155e77d6a42d..e675534b2128 100644
--- a/include/uapi/linux/netfilter_ipv4.h
+++ b/include/uapi/linux/netfilter_ipv4.h
@@ -6,13 +6,12 @@
 #define _UAPI__LINUX_IP_NETFILTER_H
 
 
+#include <linux/limits.h>
 #include <linux/netfilter.h>
 
 /* only for userspace compatibility */
 #ifndef __KERNEL__
 
-#include <limits.h> /* for INT_MIN, INT_MAX */
-
 /* IP Hooks */
 /* After promisc drops, checksum checks. */
 #define NF_IP_PRE_ROUTING	0
@@ -28,7 +27,7 @@
 #endif /* ! __KERNEL__ */
 
 enum nf_ip_hook_priorities {
-	NF_IP_PRI_FIRST = INT_MIN,
+	NF_IP_PRI_FIRST = __KERNEL_INT_MIN,
 	NF_IP_PRI_RAW_BEFORE_DEFRAG = -450,
 	NF_IP_PRI_CONNTRACK_DEFRAG = -400,
 	NF_IP_PRI_RAW = -300,
@@ -41,8 +40,8 @@ enum nf_ip_hook_priorities {
 	NF_IP_PRI_NAT_SRC = 100,
 	NF_IP_PRI_SELINUX_LAST = 225,
 	NF_IP_PRI_CONNTRACK_HELPER = 300,
-	NF_IP_PRI_CONNTRACK_CONFIRM = INT_MAX,
-	NF_IP_PRI_LAST = INT_MAX,
+	NF_IP_PRI_CONNTRACK_CONFIRM = __KERNEL_INT_MAX,
+	NF_IP_PRI_LAST = __KERNEL_INT_MAX,
 };
 
 /* Arguments for setsockopt SOL_IP: */
diff --git a/include/uapi/linux/netfilter_ipv6.h b/include/uapi/linux/netfilter_ipv6.h
index 80aa9b0799af..6be21833f696 100644
--- a/include/uapi/linux/netfilter_ipv6.h
+++ b/include/uapi/linux/netfilter_ipv6.h
@@ -9,13 +9,12 @@
 #define _UAPI__LINUX_IP6_NETFILTER_H
 
 
+#include <linux/limits.h>
 #include <linux/netfilter.h>
 
 /* only for userspace compatibility */
 #ifndef __KERNEL__
 
-#include <limits.h> /* for INT_MIN, INT_MAX */
-
 /* IP6 Hooks */
 /* After promisc drops, checksum checks. */
 #define NF_IP6_PRE_ROUTING	0
@@ -32,7 +31,7 @@
 
 
 enum nf_ip6_hook_priorities {
-	NF_IP6_PRI_FIRST = INT_MIN,
+	NF_IP6_PRI_FIRST = __KERNEL_INT_MIN,
 	NF_IP6_PRI_RAW_BEFORE_DEFRAG = -450,
 	NF_IP6_PRI_CONNTRACK_DEFRAG = -400,
 	NF_IP6_PRI_RAW = -300,
@@ -45,7 +44,7 @@ enum nf_ip6_hook_priorities {
 	NF_IP6_PRI_NAT_SRC = 100,
 	NF_IP6_PRI_SELINUX_LAST = 225,
 	NF_IP6_PRI_CONNTRACK_HELPER = 300,
-	NF_IP6_PRI_LAST = INT_MAX,
+	NF_IP6_PRI_LAST = __KERNEL_INT_MAX,
 };
 
 

-- 
2.52.0

