From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH NF_CONNTRACK 2/2] update event cache for SCTP/TCP status
Date: Fri, 07 Oct 2005 03:13:01 +0900 (JST)
Message-ID: <200510061813.j96ID1JL003855@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Fri_Oct__7_03_13_01_2005_234)--"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: laforge@netfilter.org
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

----Next_Part(Fri_Oct__7_03_13_01_2005_234)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hi, Harald,

This patch follows the recent fix that updates event cache when SCTP/TCP status
are changed.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

----Next_Part(Fri_Oct__7_03_13_01_2005_234)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="02-update-ecache.patch"

[NETFILTER] missing updating event cache for SCTP/TCP status in nf_conntrack

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit 67829f23567a0493ee18e7e8827890142be6a848
tree 23aed1ac703d163be32f3f5c917518bef4288593
parent d90304323a89c317ad5b7bd2d30b159cd4212406
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Thu, 06 Oct 2005 18:47:22 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Thu, 06 Oct 2005 18:47:22 +0900

 net/netfilter/nf_conntrack_proto_sctp.c |    1 +
 net/netfilter/nf_conntrack_proto_tcp.c  |    3 ++-
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -424,6 +424,7 @@ static int sctp_packet(struct nf_conn *c
 		&& newconntrack == SCTP_CONNTRACK_ESTABLISHED) {
 		DEBUGP("Setting assured bit\n");
 		set_bit(IPS_ASSURED_BIT, &conntrack->status);
+		nf_conntrack_event_cache(IPCT_STATUS, skb);
 	}
 
 	return NF_ACCEPT;
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1036,7 +1036,8 @@ static int tcp_packet(struct nf_conn *co
 		/* Set ASSURED if we see see valid ack in ESTABLISHED 
 		   after SYN_RECV or a valid answer for a picked up 
 		   connection. */
-			set_bit(IPS_ASSURED_BIT, &conntrack->status);
+		set_bit(IPS_ASSURED_BIT, &conntrack->status);
+		nf_conntrack_event_cache(IPCT_STATUS, skb);
 	}
 	nf_ct_refresh_acct(conntrack, ctinfo, skb, timeout);
 

----Next_Part(Fri_Oct__7_03_13_01_2005_234)----
