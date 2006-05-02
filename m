From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER]: SCTP conntrack: fix infinite loop
Date: Tue, 02 May 2006 23:23:07 +0200
Message-ID: <4457CDBB.9010605@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040501090807060501010308"
Cc: security@kernel.org,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: stable@kernel.org
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

This is a multi-part message in MIME format.
--------------040501090807060501010308
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Ingo Molnar discovered that a SCTP packet with a chunk header length
of zero leads to an infinite loop in the SCTP connection tracking
helper. Please add to -stable.


--------------040501090807060501010308
Content-Type: text/plain;
 name="sctp-stable.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sctp-stable.diff"

[NETFILTER]: SCTP conntrack: fix infinite loop

fix infinite loop in the SCTP-netfilter code: check SCTP chunk size to
guarantee progress of for_each_sctp_chunk(). (all other uses of
for_each_sctp_chunk() are preceded by do_basic_checks(), so this fix
should be complete.)

Based on patch from Ingo Molnar <mingo@elte.hu>

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 97ca02fbb25efc9d5410439d9835e4aa7f61a12f
tree d0abdcb0dbc76c4b99662fd093afb75288ea6974
parent 42a46c74c4520174b82a60ac44c15b5525cdf238
author Patrick McHardy <kaber@trash.net> Tue, 02 May 2006 19:45:49 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 02 May 2006 19:45:49 +0200

 net/ipv4/netfilter/ip_conntrack_proto_sctp.c |   11 +++++++----
 net/netfilter/nf_conntrack_proto_sctp.c      |   11 +++++++----
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_proto_sctp.c b/net/ipv4/netfilter/ip_conntrack_proto_sctp.c
index be602e8..ea5cc51 100644
--- a/net/ipv4/netfilter/ip_conntrack_proto_sctp.c
+++ b/net/ipv4/netfilter/ip_conntrack_proto_sctp.c
@@ -235,12 +235,15 @@ static int do_basic_checks(struct ip_con
 			flag = 1;
 		}
 
-		/* Cookie Ack/Echo chunks not the first OR 
-		   Init / Init Ack / Shutdown compl chunks not the only chunks */
-		if ((sch->type == SCTP_CID_COOKIE_ACK 
+		/*
+		 * Cookie Ack/Echo chunks not the first OR
+		 * Init / Init Ack / Shutdown compl chunks not the only chunks
+		 * OR zero-length.
+		 */
+		if (((sch->type == SCTP_CID_COOKIE_ACK
 			|| sch->type == SCTP_CID_COOKIE_ECHO
 			|| flag)
-		     && count !=0 ) {
+		      && count !=0) || !sch->length) {
 			DEBUGP("Basic checks failed\n");
 			return 1;
 		}
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index cf798e6..6c3881b 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -240,12 +240,15 @@ static int do_basic_checks(struct nf_con
 			flag = 1;
 		}
 
-		/* Cookie Ack/Echo chunks not the first OR 
-		   Init / Init Ack / Shutdown compl chunks not the only chunks */
-		if ((sch->type == SCTP_CID_COOKIE_ACK 
+		/*
+		 * Cookie Ack/Echo chunks not the first OR
+		 * Init / Init Ack / Shutdown compl chunks not the only chunks
+		 * OR zero-length.
+		 */
+		if (((sch->type == SCTP_CID_COOKIE_ACK
 			|| sch->type == SCTP_CID_COOKIE_ECHO
 			|| flag)
-		     && count !=0 ) {
+		      && count !=0) || !sch->length) {
 			DEBUGP("Basic checks failed\n");
 			return 1;
 		}

--------------040501090807060501010308--
