From: Florian Westphal <fw@strlen.de>
Subject: [PATCH] netfilter: fix missing dependencies for NETFILTER_XT_MATCH_CONNLABEL
Date: Sun,  3 Feb 2013 12:24:07 +0100
Message-ID: <1359890647-25846-1-git-send-email-fw@strlen.de>
References: <510DC976.7000008@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <510DC976.7000008@infradead.org>
Sender: linux-next-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

It was possible to set
NF_CONNTRACK=n
NF_CONNTRACK_LABELS=y

via NETFILTER_XT_MATCH_CONNLABEL=y:

warning: (NETFILTER_XT_MATCH_CONNLABEL) selects NF_CONNTRACK_LABELS which has
unmet direct dependencies (NET && INET && NETFILTER && NF_CONNTRACK)

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index eb2c8eb..d4dd702 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -860,6 +860,7 @@ config NETFILTER_XT_MATCH_CONNBYTES
 config NETFILTER_XT_MATCH_CONNLABEL
 	tristate '"connlabel" match support'
 	select NF_CONNTRACK_LABELS
+	depends on NF_CONNTRACK
 	depends on NETFILTER_ADVANCED
 	---help---
 	  This match allows you to test and assign userspace-defined labels names
-- 
1.7.8.6
