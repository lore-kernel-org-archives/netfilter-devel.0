From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 15/39]: TCP conntrack: improve dead connection detection
Date: Wed, 20 Sep 2006 10:24:10 +0200 (MEST)
Message-ID: <20060920082502.14636.23502.sendpatchset@localhost.localdomain>
References: <20060920082442.14636.6806.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060920082442.14636.6806.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: TCP conntrack: improve dead connection detection

Don't count window updates as retransmissions.

Signed-off-by: George Hansper
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 21df1122e9ade53430f3c3a7e188ec194baedb93
tree d56625d297a4cc820ed085b15d32558bafa87c39
parent 4a96b874e237df6f156bd186bf7671da3875ee6a
author George Hansper <georgeh@anstat.com.au> Wed, 20 Sep 2006 09:29:05 +0200
committer Patrick McHardy <kaber@trash.net> Wed, 20 Sep 2006 09:29:05 +0200

 include/linux/netfilter/nf_conntrack_tcp.h  |    1 +
 net/ipv4/netfilter/ip_conntrack_proto_tcp.c |    4 +++-
 net/netfilter/nf_conntrack_proto_tcp.c      |    4 +++-
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_tcp.h b/include/linux/netfilter/nf_conntrack_tcp.h
index b2feeff..6b01ba2 100644
--- a/include/linux/netfilter/nf_conntrack_tcp.h
+++ b/include/linux/netfilter/nf_conntrack_tcp.h
@@ -49,6 +49,7 @@ struct ip_ct_tcp
 	u_int32_t	last_seq;	/* Last sequence number seen in dir */
 	u_int32_t	last_ack;	/* Last sequence number seen in opposite dir */
 	u_int32_t	last_end;	/* Last seq + len */
+	u_int16_t	last_win;	/* Last window advertisement seen in dir */
 };
 
 #endif /* __KERNEL__ */
diff --git a/net/ipv4/netfilter/ip_conntrack_proto_tcp.c b/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
index 75a7237..03ae9a0 100644
--- a/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
+++ b/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
@@ -731,13 +731,15 @@ static int tcp_in_window(struct ip_ct_tc
 			if (state->last_dir == dir
 			    && state->last_seq == seq
 			    && state->last_ack == ack
-			    && state->last_end == end)
+			    && state->last_end == end
+			    && state->last_win == win)
 				state->retrans++;
 			else {
 				state->last_dir = dir;
 				state->last_seq = seq;
 				state->last_ack = ack;
 				state->last_end = end;
+				state->last_win = win;
 				state->retrans = 0;
 			}
 		}
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 9fc0ee6..238bbb5 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -688,13 +688,15 @@ static int tcp_in_window(struct ip_ct_tc
 			if (state->last_dir == dir
 			    && state->last_seq == seq
 			    && state->last_ack == ack
-			    && state->last_end == end)
+			    && state->last_end == end
+			    && state->last_win == win)
 				state->retrans++;
 			else {
 				state->last_dir = dir;
 				state->last_seq = seq;
 				state->last_ack = ack;
 				state->last_end = end;
+				state->last_win = win;
 				state->retrans = 0;
 			}
 		}
