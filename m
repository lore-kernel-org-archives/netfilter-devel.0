From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 03/15] ipvs: don't show negative times in ip_vs_conn
Date: Fri, 17 Aug 2018 21:38:38 +0200
Message-ID: <20180817193850.2796-4-pablo@netfilter.org>
References: <20180817193850.2796-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180817193850.2796-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Matteo Croce <mcroce@redhat.com>

Since commit 500462a9de65 ("timers: Switch to a non-cascading wheel"),
timers duration can last even 12.5% more than the scheduled interval.

IPVS has two handlers, /proc/net/ip_vs_conn and /proc/net/ip_vs_conn_sync,
which shows the remaining time before that a connection expires.
The default expire time for a connection is 60 seconds, and the
expiration timer can fire even 4 seconds later than the scheduled time.
The expiration time is calculated subtracting jiffies to the scheduled
expiration time, and it's shown as a huge number when the timer fires late,
since both values are unsigned.

This can confuse script and tools which relies on it, like ipvsadm:

    root@mcroce-redhat:~# while ipvsadm -lc |grep SYN_RECV; do sleep 1 ; done
    TCP 00:05  SYN_RECV    [fc00:1::1]:55732  [fc00:1::2]:8000   [fc00:2000::1]:8000
    TCP 00:04  SYN_RECV    [fc00:1::1]:55732  [fc00:1::2]:8000   [fc00:2000::1]:8000
    TCP 00:03  SYN_RECV    [fc00:1::1]:55732  [fc00:1::2]:8000   [fc00:2000::1]:8000
    TCP 00:02  SYN_RECV    [fc00:1::1]:55732  [fc00:1::2]:8000   [fc00:2000::1]:8000
    TCP 00:01  SYN_RECV    [fc00:1::1]:55732  [fc00:1::2]:8000   [fc00:2000::1]:8000
    TCP 00:00  SYN_RECV    [fc00:1::1]:55732  [fc00:1::2]:8000   [fc00:2000::1]:8000
    TCP 68719476:44 SYN_RECV    [fc00:1::1]:55732  [fc00:1::2]:8000   [fc00:2000::1]:8000
    TCP 68719476:43 SYN_RECV    [fc00:1::1]:55732  [fc00:1::2]:8000   [fc00:2000::1]:8000
    TCP 68719476:42 SYN_RECV    [fc00:1::1]:55732  [fc00:1::2]:8000   [fc00:2000::1]:8000
    TCP 68719476:41 SYN_RECV    [fc00:1::1]:55732  [fc00:1::2]:8000   [fc00:2000::1]:8000
    TCP 68719476:40 SYN_RECV    [fc00:1::1]:55732  [fc00:1::2]:8000   [fc00:2000::1]:8000
    TCP 68719476:39 SYN_RECV    [fc00:1::1]:55732  [fc00:1::2]:8000   [fc00:2000::1]:8000

Signed-off-by: Matteo Croce <mcroce@redhat.com>
Acked-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_conn.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index 0edc62910ebf..5b2b17867cb1 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -1117,24 +1117,28 @@ static int ip_vs_conn_seq_show(struct seq_file *seq, void *v)
 #ifdef CONFIG_IP_VS_IPV6
 		if (cp->af == AF_INET6)
 			seq_printf(seq, "%-3s %pI6 %04X %pI6 %04X "
-				"%s %04X %-11s %7lu%s\n",
+				"%s %04X %-11s %7u%s\n",
 				ip_vs_proto_name(cp->protocol),
 				&cp->caddr.in6, ntohs(cp->cport),
 				&cp->vaddr.in6, ntohs(cp->vport),
 				dbuf, ntohs(cp->dport),
 				ip_vs_state_name(cp),
-				(cp->timer.expires-jiffies)/HZ, pe_data);
+				jiffies_delta_to_msecs(cp->timer.expires -
+						       jiffies) / 1000,
+				pe_data);
 		else
 #endif
 			seq_printf(seq,
 				"%-3s %08X %04X %08X %04X"
-				" %s %04X %-11s %7lu%s\n",
+				" %s %04X %-11s %7u%s\n",
 				ip_vs_proto_name(cp->protocol),
 				ntohl(cp->caddr.ip), ntohs(cp->cport),
 				ntohl(cp->vaddr.ip), ntohs(cp->vport),
 				dbuf, ntohs(cp->dport),
 				ip_vs_state_name(cp),
-				(cp->timer.expires-jiffies)/HZ, pe_data);
+				jiffies_delta_to_msecs(cp->timer.expires -
+						       jiffies) / 1000,
+				pe_data);
 	}
 	return 0;
 }
@@ -1179,26 +1183,28 @@ static int ip_vs_conn_sync_seq_show(struct seq_file *seq, void *v)
 #ifdef CONFIG_IP_VS_IPV6
 		if (cp->af == AF_INET6)
 			seq_printf(seq, "%-3s %pI6 %04X %pI6 %04X "
-				"%s %04X %-11s %-6s %7lu\n",
+				"%s %04X %-11s %-6s %7u\n",
 				ip_vs_proto_name(cp->protocol),
 				&cp->caddr.in6, ntohs(cp->cport),
 				&cp->vaddr.in6, ntohs(cp->vport),
 				dbuf, ntohs(cp->dport),
 				ip_vs_state_name(cp),
 				ip_vs_origin_name(cp->flags),
-				(cp->timer.expires-jiffies)/HZ);
+				jiffies_delta_to_msecs(cp->timer.expires -
+						       jiffies) / 1000);
 		else
 #endif
 			seq_printf(seq,
 				"%-3s %08X %04X %08X %04X "
-				"%s %04X %-11s %-6s %7lu\n",
+				"%s %04X %-11s %-6s %7u\n",
 				ip_vs_proto_name(cp->protocol),
 				ntohl(cp->caddr.ip), ntohs(cp->cport),
 				ntohl(cp->vaddr.ip), ntohs(cp->vport),
 				dbuf, ntohs(cp->dport),
 				ip_vs_state_name(cp),
 				ip_vs_origin_name(cp->flags),
-				(cp->timer.expires-jiffies)/HZ);
+				jiffies_delta_to_msecs(cp->timer.expires -
+						       jiffies) / 1000);
 	}
 	return 0;
 }
-- 
2.11.0
