From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 1/2]: Ignore ACKs ACKs on half open connections in TCP
	conntrack
Date: Thu, 01 Dec 2005 12:06:17 +0100
Message-ID: <20051201110617.8700.16237.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
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

[NETFILTER]: Ignore ACKs ACKs on half open connections in TCP conntrack

Mounting NFS file systems after a (warm) reboot could take a long time if
firewalling and connection tracking was enabled.

The reason is that the NFS clients tends to use the same ports (800 and
counting down). Now on reboot, the server would still have a TCB for an
existing TCP connection client:800 -> server:2049. The client sends a
SYN from port 800 to server:2049, which elicits an ACK from the server.
The firewall on the client drops the ACK because (from its point of
view) the connection is still in half-open state, and it expects to see
a SYNACK.

The client will eventually time out after several minutes.

The following patch corrects this, by accepting ACKs on half open
connections as well.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 28fbc43b64e0982cdb775afb2055f4c02fd6c41a
tree 6013cdc2d54ae98d6b57b2b86457e496257780d3
parent 4168f7a31801bba6acc18662978d24ec850bbbd0
author Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> Tue, 29 Nov 2005 23:31:33 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 29 Nov 2005 23:31:33 +0100

 net/ipv4/netfilter/ip_conntrack_proto_tcp.c |   29 +++++++++++++++++++--------
 net/netfilter/nf_conntrack_proto_tcp.c      |   29 +++++++++++++++++++--------
 2 files changed, 40 insertions(+), 18 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_proto_tcp.c b/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
index ee3b7d6..9721578 100644
--- a/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
+++ b/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
@@ -272,9 +272,9 @@ static enum tcp_conntrack tcp_conntracks
  *	sCL -> sCL
  */
 /* 	     sNO, sSS, sSR, sES, sFW, sCW, sLA, sTW, sCL, sLI	*/
-/*ack*/	   { sIV, sIV, sSR, sES, sCW, sCW, sTW, sTW, sCL, sIV },
+/*ack*/	   { sIV, sIG, sSR, sES, sCW, sCW, sTW, sTW, sCL, sIV },
 /*
- *	sSS -> sIV	Might be a half-open connection.
+ *	sSS -> sIG	Might be a half-open connection.
  *	sSR -> sSR	Might answer late resent SYN.
  *	sES -> sES	:-)
  *	sFW -> sCW	Normal close request answered by ACK.
@@ -917,8 +917,12 @@ static int tcp_packet(struct ip_conntrac
 
 	switch (new_state) {
 	case TCP_CONNTRACK_IGNORE:
-		/* Either SYN in ORIGINAL
-		 * or SYN/ACK in REPLY. */
+		/* Ignored packets:
+		 * 
+		 * a) SYN in ORIGINAL
+		 * b) SYN/ACK in REPLY
+		 * c) ACK in reply direction after initial SYN in original.
+		 */
 		if (index == TCP_SYNACK_SET
 		    && conntrack->proto.tcp.last_index == TCP_SYN_SET
 		    && conntrack->proto.tcp.last_dir != dir
@@ -985,13 +989,20 @@ static int tcp_packet(struct ip_conntrac
 		}
 	case TCP_CONNTRACK_CLOSE:
 		if (index == TCP_RST_SET
-		    && test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status)
-		    && conntrack->proto.tcp.last_index == TCP_SYN_SET
+		    && ((test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status)
+		         && conntrack->proto.tcp.last_index == TCP_SYN_SET)
+		        || (!test_bit(IPS_ASSURED_BIT, &conntrack->status)
+		            && conntrack->proto.tcp.last_index == TCP_ACK_SET))
 		    && ntohl(th->ack_seq) == conntrack->proto.tcp.last_end) {
-			/* RST sent to invalid SYN we had let trough
-			 * SYN was in window then, tear down connection.
+			/* RST sent to invalid SYN or ACK we had let trough
+			 * at a) and c) above:
+			 *
+			 * a) SYN was in window then
+			 * c) we hold a half-open connection.
+			 *
+			 * Delete our connection entry.
 			 * We skip window checking, because packet might ACK
-			 * segments we ignored in the SYN. */
+			 * segments we ignored. */
 			goto in_window;
 		}
 		/* Just fall trough */
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 5a6fcf3..6035633 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -280,9 +280,9 @@ static enum tcp_conntrack tcp_conntracks
  *	sCL -> sCL
  */
 /* 	     sNO, sSS, sSR, sES, sFW, sCW, sLA, sTW, sCL, sLI	*/
-/*ack*/	   { sIV, sIV, sSR, sES, sCW, sCW, sTW, sTW, sCL, sIV },
+/*ack*/	   { sIV, sIG, sSR, sES, sCW, sCW, sTW, sTW, sCL, sIV },
 /*
- *	sSS -> sIV	Might be a half-open connection.
+ *	sSS -> sIG	Might be a half-open connection.
  *	sSR -> sSR	Might answer late resent SYN.
  *	sES -> sES	:-)
  *	sFW -> sCW	Normal close request answered by ACK.
@@ -912,8 +912,12 @@ static int tcp_packet(struct nf_conn *co
 
 	switch (new_state) {
 	case TCP_CONNTRACK_IGNORE:
-		/* Either SYN in ORIGINAL
-		 * or SYN/ACK in REPLY. */
+		/* Ignored packets:
+		 *
+		 * a) SYN in ORIGINAL
+		 * b) SYN/ACK in REPLY
+		 * c) ACK in reply direction after initial SYN in original. 
+		 */
 		if (index == TCP_SYNACK_SET
 		    && conntrack->proto.tcp.last_index == TCP_SYN_SET
 		    && conntrack->proto.tcp.last_dir != dir
@@ -979,13 +983,20 @@ static int tcp_packet(struct nf_conn *co
 		}
 	case TCP_CONNTRACK_CLOSE:
 		if (index == TCP_RST_SET
-		    && test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status)
-		    && conntrack->proto.tcp.last_index == TCP_SYN_SET
+		    && ((test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status)
+		         && conntrack->proto.tcp.last_index == TCP_SYN_SET)
+		        || (!test_bit(IPS_ASSURED_BIT, &conntrack->status)
+		            && conntrack->proto.tcp.last_index == TCP_ACK_SET))
 		    && ntohl(th->ack_seq) == conntrack->proto.tcp.last_end) {
-			/* RST sent to invalid SYN we had let trough
-			 * SYN was in window then, tear down connection.
+			/* RST sent to invalid SYN or ACK we had let trough
+			 * at a) and c) above:
+			 *
+			 * a) SYN was in window then
+			 * c) we hold a half-open connection.
+			 *
+			 * Delete our connection entry.
 			 * We skip window checking, because packet might ACK
-			 * segments we ignored in the SYN. */
+			 * segments we ignored. */
 			goto in_window;
 		}
 		/* Just fall trough */
