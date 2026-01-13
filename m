Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC64336923C;
	Tue, 13 Jan 2026 07:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768290273; cv=none; b=GdfPlxpnJnMqkM7fiTINh5/fFlPvD3TdJ7mac4/hfTgrR97mDsIJEwvDo32MAvvw0QAkga3d2sigE5RBmGH/2cQnU0JQIIiP5T+y/SbQppBC64997MXyMTcQ4tqo/COA8ldfs7rfWDt7Viz3KEo1JYrGz7q8BDb0ufyPdPY+SoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768290273; c=relaxed/simple;
	bh=PiXWlRzlJeK5UccL9Dj6vkQrMeQL9oQzSnOYnGFCi+M=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=hB8gtoKQkpC4cbC45nbjT7+HjIkhZ+/ycds701AnscLBuGP0pWcyT0iGDA/4xadKQGTdz25TceDDWi6z8FFqrnWx9hLHIjbnAFrwc2Nh+7wIWeRG7MDrJhjUWwCOIsLNItZ78oYw82ocRomsJMOF9KEUtBhjm8HZcXWP3cQsLn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=Zj0PrUHF; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=qxJrYsmu; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="Zj0PrUHF";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="qxJrYsmu"
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1768290264;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CATNf43k7lDUdxCdh5W4SCAQ+bvuoNSzySPQEKtH3DY=;
	b=Zj0PrUHFVqT/7X+glJOtyK+wgxs2/VBfBe/THvh5C91s+4tEF17mNPGxtw1If4MRU9i0V5
	Q/sZef5Pqw4oHz1ZMnMZI7EHIhYtusI/TFaVqV9GE+ZSBmUOBnh+aslYpfJc5sWa347yh7
	fw3zBhYN3thr8/gn/MHBANzuszS1nYmNja5WeOZ+C62hjzMlh6wvqLYXtsYUtgM/B6XlmJ
	LMoklcpaQJj9cAShTye0HvzdLjNg7dTUlJaWcXUZicQybdYN+ORnElE/e6VLzUe1EvKhO3
	xrYugi+FoV8jg171ALRg0L9zTDILYfGmEG+OrB3+FxwwiX5fQkjCHHUVs05DAQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1768290264;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CATNf43k7lDUdxCdh5W4SCAQ+bvuoNSzySPQEKtH3DY=;
	b=qxJrYsmujF+GKslLxHWBgDP3rig/D8KYlYF7+2I2fFXLZSB+5KejWNPqVmS6vFsPr/wQ3F
	GZZltNNO5Idz6uDg==
Date: Tue, 13 Jan 2026 08:44:19 +0100
Subject: [PATCH v2 3/3] netfilter: uapi: Use UAPI definition of INT_MAX and
 INT_MIN
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260113-uapi-limits-v2-3-93c20f4b2c1a@linutronix.de>
References: <20260113-uapi-limits-v2-0-93c20f4b2c1a@linutronix.de>
In-Reply-To: <20260113-uapi-limits-v2-0-93c20f4b2c1a@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1768290260; l=3556;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=PiXWlRzlJeK5UccL9Dj6vkQrMeQL9oQzSnOYnGFCi+M=;
 b=O5/YIHmfA+tkMPardK86a3f09MW7umL83vyt0VTLhkFR4KMGrfMUP7oVHxsM0dfO5gK37RJFN
 BFp/1To6A0jCVuIkXAJ3vLvQ0WcFesksUGYNkwfoJz2hrASy54Gpojw
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
index 1610fdbab98d..f6e8d1e05c97 100644
--- a/include/uapi/linux/netfilter_bridge.h
+++ b/include/uapi/linux/netfilter_bridge.h
@@ -10,10 +10,7 @@
 #include <linux/if_ether.h>
 #include <linux/if_vlan.h>
 #include <linux/if_pppox.h>
-
-#ifndef __KERNEL__
-#include <limits.h> /* for INT_MIN, INT_MAX */
-#endif
+#include <linux/typelimits.h>
 
 /* Bridge Hooks */
 /* After promisc drops, checksum checks. */
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
index 155e77d6a42d..439d3c59862b 100644
--- a/include/uapi/linux/netfilter_ipv4.h
+++ b/include/uapi/linux/netfilter_ipv4.h
@@ -7,12 +7,11 @@
 
 
 #include <linux/netfilter.h>
+#include <linux/typelimits.h>
 
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
index 80aa9b0799af..0e40d00b37fa 100644
--- a/include/uapi/linux/netfilter_ipv6.h
+++ b/include/uapi/linux/netfilter_ipv6.h
@@ -10,12 +10,11 @@
 
 
 #include <linux/netfilter.h>
+#include <linux/typelimits.h>
 
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

