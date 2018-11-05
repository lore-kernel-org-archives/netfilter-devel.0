From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 03/14] netfilter: bridge: define INT_MIN & INT_MAX in userspace
Date: Tue,  6 Nov 2018 00:28:21 +0100
Message-ID: <20181105232832.21896-4-pablo@netfilter.org>
References: <20181105232832.21896-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181105232832.21896-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>

With 4.19, programs like ebtables fail to build when they include
"linux/netfilter_bridge.h". It is caused by commit 94276fa8a2a4 which
added a use of INT_MIN and INT_MAX to the header:
: In file included from /usr/include/linux/netfilter_bridge/ebtables.h:18,
:                  from include/ebtables_u.h:28,
:                  from communication.c:23:
: /usr/include/linux/netfilter_bridge.h:30:20: error: 'INT_MIN' undeclared here (not in a function)
:   NF_BR_PRI_FIRST = INT_MIN,
:                     ^~~~~~~

Define these constants by including "limits.h" when !__KERNEL__ (the
same way as for other netfilter_* headers).

Fixes: 94276fa8a2a4 ("netfilter: bridge: Expose nf_tables bridge hook priorities through uapi")
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Acked-by: Máté Eckl <ecklm94@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter_bridge.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/uapi/linux/netfilter_bridge.h b/include/uapi/linux/netfilter_bridge.h
index 156ccd089df1..1610fdbab98d 100644
--- a/include/uapi/linux/netfilter_bridge.h
+++ b/include/uapi/linux/netfilter_bridge.h
@@ -11,6 +11,10 @@
 #include <linux/if_vlan.h>
 #include <linux/if_pppox.h>
 
+#ifndef __KERNEL__
+#include <limits.h> /* for INT_MIN, INT_MAX */
+#endif
+
 /* Bridge Hooks */
 /* After promisc drops, checksum checks. */
 #define NF_BR_PRE_ROUTING	0
-- 
2.11.0
