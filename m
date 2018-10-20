From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 09/10] netfilter: nfnetlink_log: remove empty nfnetlink_log.h header file
Date: Sat, 20 Oct 2018 11:43:16 +0200
Message-ID: <20181020094317.16011-10-pablo@netfilter.org>
References: <20181020094317.16011-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181020094317.16011-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

/include/net/netfilter/nfnetlink_log.h file is empty.
so that it can be removed.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nfnetlink_log.h | 1 -
 1 file changed, 1 deletion(-)
 delete mode 100644 include/net/netfilter/nfnetlink_log.h

diff --git a/include/net/netfilter/nfnetlink_log.h b/include/net/netfilter/nfnetlink_log.h
deleted file mode 100644
index ea32a7d3cf1b..000000000000
--- a/include/net/netfilter/nfnetlink_log.h
+++ /dev/null
@@ -1 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-- 
2.11.0
