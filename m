From: KOVACS Krisztian <hidden@sch.bme.hu>
Subject: [PATCH 07/13] Export UDP socket lookup function
Date: Sun, 30 Sep 2007 22:52:54 +0200
Message-ID: <20070930205254.10969.60517.stgit@nessa.odu>
References: <20070930205141.10969.27205.stgit@nessa.odu>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Balazs Scheidler <bazsi@balabit.hu>,
	Toth Laszlo Attila <panther@balabit.hu>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from centaur.sch.bme.hu ([152.66.208.5]:40435 "EHLO
	centaur.sch.bme.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbXI3VL4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Sep 2007 17:11:56 -0400
In-Reply-To: <20070930205141.10969.27205.stgit@nessa.odu>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

The iptables tproxy code has to be able to do UDP socket hash lookups,
so we have to provide an exported lookup function for this purpose.

Signed-off-by: KOVACS Krisztian <hidden@sch.bme.hu>
---

 include/net/udp.h |    4 ++++
 net/ipv4/udp.c    |    8 ++++++++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/include/net/udp.h b/include/net/udp.h
index 98755eb..3efae7d 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -138,6 +138,10 @@ extern int 	udp_lib_setsockopt(struct sock *sk, int level, int optname,
 				   char __user *optval, int optlen,
 				   int (*push_pending_frames)(struct sock *));
 
+extern struct sock *udp4_lib_lookup(__be32 saddr, __be16 sport,
+				    __be32 daddr, __be16 dport,
+				    int dif);
+
 DECLARE_SNMP_STAT(struct udp_mib, udp_statistics);
 /*
  * 	SNMP statistics for UDP and UDP-Lite
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 69d4bd1..2fb3b7c 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -287,6 +287,14 @@ static struct sock *__udp4_lib_lookup(__be32 saddr, __be16 sport,
 	return result;
 }
 
+struct sock *udp4_lib_lookup(__be32 saddr, __be16 sport,
+			       __be32 daddr, __be16 dport,
+			       int dif)
+{
+	return __udp4_lib_lookup(saddr, sport, daddr, dport, dif, udp_hash);
+}
+EXPORT_SYMBOL_GPL(udp4_lib_lookup);
+
 static inline struct sock *udp_v4_mcast_next(struct sock *sk,
 					     __be16 loc_port, __be32 loc_addr,
 					     __be16 rmt_port, __be32 rmt_addr,

