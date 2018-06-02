From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 01/20] netfilter: add includes to nf_socket.h
Date: Sat,  2 Jun 2018 02:22:40 +0200
Message-ID: <20180602002259.4024-2-pablo@netfilter.org>
References: <20180602002259.4024-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180602002259.4024-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Máté Eckl <ecklm94@gmail.com>

These have to be included always when nf_socket.h is included.

Signed-off-by: Máté Eckl <ecklm94@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_socket.h | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_socket.h b/include/net/netfilter/nf_socket.h
index 8230fefff9f5..29b6313f0557 100644
--- a/include/net/netfilter/nf_socket.h
+++ b/include/net/netfilter/nf_socket.h
@@ -2,10 +2,8 @@
 #ifndef _NF_SOCK_H_
 #define _NF_SOCK_H_
 
-struct net_device;
-struct sk_buff;
-struct sock;
-struct net;
+#include <net/sock.h>
+#include <net/inet_timewait_sock.h>
 
 static inline bool nf_sk_is_transparent(struct sock *sk)
 {
-- 
2.11.0
