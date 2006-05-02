From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 03/06]: SCTP conntrack: fix infinite loop
Date: Tue,  2 May 2006 22:48:07 +0200 (MEST)
Message-ID: <20060502204807.7610.29463.sendpatchset@localhost.localdomain>
References: <20060502204803.7610.72174.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060502204803.7610.72174.sendpatchset@localhost.localdomain>
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

[NETFILTER]: SCTP conntrack: fix infinite loop

fix infinite loop in the SCTP-netfilter code: check SCTP chunk size to
guarantee progress of for_each_sctp_chunk(). (all other uses of
for_each_sctp_chunk() are preceded by do_basic_checks(), so this fix
should be complete.)

Based on patch from Ingo Molnar <mingo@elte.hu>

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit fcf294628012638bc925b2c158c03efea2decb4c
tree 65284c4c81d889853453017627099a0908650c41
parent 6d7b293e330618cbfa6b4e4dd85dc0072ccd8c7c
author Patrick McHardy <kaber@trash.net> Tue, 02 May 2006 21:58:45 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 02 May 2006 21:58:45 +0200

 net/ipv4/netfilter/ip_conntrack_proto_sctp.c |   11 +++++++----
 net/netfilter/nf_conntrack_proto_sctp.c      |   11 +++++++----
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_proto_sctp.c b/net/ipv4/netfilter/ip_conntrack_proto_sctp.c
index 5259abd..0416073 100644
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
index 9cccc32..0c6da49 100644
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
