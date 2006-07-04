From: Patrick McHardy <kaber@trash.net>
Subject: RFC: Disable defered bridge hooks by default
Date: Tue, 04 Jul 2006 11:26:30 +0200
Message-ID: <44AA3446.6050609@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080202070104080302020909"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Bart De Schuymer <bdschuym@pandora.be>
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
--------------080202070104080302020909
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Finally got to taking care of the first part of getting
rid of the defered bridge hooks. Bart, does this look
correct to you? This stuff confuses me badly :) Thanks.



--------------080202070104080302020909
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NETFILTER]: SCTP conntrack: fix crash triggered by packet without chunks

When a packet without any chunks is received, the newconntrack variable
in sctp_packet contains an out of bounds value that is used to look up an
pointer from the array of timeouts, which is then dereferenced, resulting
in a crash. Make sure at least a single chunk is present.

Problem noticed by George A. Theall <theall@tenablesecurity.com>

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 4044a218db83433791d45cd453a6311d7dcbd17d
tree 37ea0a16426151bd3606264ea8c462bbf6f3decd
parent a39727f212426b9d5f9267b3318a2afaf9922d3b
author Patrick McHardy <kaber@trash.net> Fri, 30 Jun 2006 05:27:26 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 30 Jun 2006 05:27:26 +0200

 net/ipv4/netfilter/ip_conntrack_proto_sctp.c |    2 +-
 net/netfilter/nf_conntrack_proto_sctp.c      |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_proto_sctp.c b/net/ipv4/netfilter/ip_conntrack_proto_sctp.c
index 0416073..2d3612c 100644
--- a/net/ipv4/netfilter/ip_conntrack_proto_sctp.c
+++ b/net/ipv4/netfilter/ip_conntrack_proto_sctp.c
@@ -254,7 +254,7 @@ static int do_basic_checks(struct ip_con
 	}
 
 	DEBUGP("Basic checks passed\n");
-	return 0;
+	return count == 0;
 }
 
 static int new_state(enum ip_conntrack_dir dir,
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 0c6da49..9dab81d 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -259,7 +259,7 @@ static int do_basic_checks(struct nf_con
 	}
 
 	DEBUGP("Basic checks passed\n");
-	return 0;
+	return count == 0;
 }
 
 static int new_state(enum ip_conntrack_dir dir,

--------------080202070104080302020909--
