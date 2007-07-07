From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 30/50]: nf_conntrack_ftp: use nf_ct_expect_init
Date: Sat,  7 Jul 2007 14:23:43 +0200 (MEST)
Message-ID: <20070707122259.1589.73229.sendpatchset@localhost.localdomain>
References: <20070707122215.1589.12100.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070707122215.1589.12100.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack_ftp: use nf_ct_expect_init

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit ee8da2d318e2ce53c462e2962280815360169580
tree 9dfc0611ab79d487a04ba91e1a83534738736c9d
parent 502f125e1f69e2e84abf846a0c5a8cc128aa096f
author Patrick McHardy <kaber@trash.net> Sat, 07 Jul 2007 12:15:46 +0200
committer Patrick McHardy <kaber@trash.net> Sat, 07 Jul 2007 12:15:46 +0200

 net/netfilter/nf_conntrack_ftp.c |   36 ++++++------------------------------
 1 files changed, 6 insertions(+), 30 deletions(-)

diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index 5efe65d..9ad1519 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -364,6 +364,7 @@ static int help(struct sk_buff **pskb,
 	unsigned int matchlen, matchoff;
 	struct nf_ct_ftp_master *ct_ftp_info = &nfct_help(ct)->help.ct_ftp_info;
 	struct nf_conntrack_expect *exp;
+	union nf_conntrack_address *daddr;
 	struct nf_conntrack_man cmd = {};
 	unsigned int i;
 	int found = 0, ends_in_nl;
@@ -454,7 +455,7 @@ static int help(struct sk_buff **pskb,
 	/* We refer to the reverse direction ("!dir") tuples here,
 	 * because we're expecting something in the other direction.
 	 * Doesn't matter unless NAT is happening.  */
-	exp->tuple.dst.u3 = ct->tuplehash[!dir].tuple.dst.u3;
+	daddr = &ct->tuplehash[!dir].tuple.dst.u3;
 
 	/* Update the ftp info */
 	if ((cmd.l3num == ct->tuplehash[dir].tuple.src.l3num) &&
@@ -483,37 +484,12 @@ static int help(struct sk_buff **pskb,
 			ret = NF_ACCEPT;
 			goto out_put_expect;
 		}
-		memcpy(&exp->tuple.dst.u3, &cmd.u3.all,
-		       sizeof(exp->tuple.dst.u3));
+		daddr = &cmd.u3;
 	}
 
-	exp->tuple.src.u3 = ct->tuplehash[!dir].tuple.src.u3;
-	exp->tuple.src.l3num = cmd.l3num;
-	exp->tuple.src.u.tcp.port = 0;
-	exp->tuple.dst.u.tcp.port = cmd.u.tcp.port;
-	exp->tuple.dst.protonum = IPPROTO_TCP;
-
-	exp->mask = (struct nf_conntrack_tuple)
-		    { .src = { .l3num = 0xFFFF,
-			       .u = { .tcp = { 0 }},
-			     },
-		      .dst = { .protonum = 0xFF,
-			       .u = { .tcp = { __constant_htons(0xFFFF) }},
-			     },
-		    };
-	if (cmd.l3num == PF_INET) {
-		exp->mask.src.u3.ip = htonl(0xFFFFFFFF);
-		exp->mask.dst.u3.ip = htonl(0xFFFFFFFF);
-	} else {
-		memset(exp->mask.src.u3.ip6, 0xFF,
-		       sizeof(exp->mask.src.u3.ip6));
-		memset(exp->mask.dst.u3.ip6, 0xFF,
-		       sizeof(exp->mask.src.u3.ip6));
-	}
-
-	exp->expectfn = NULL;
-	exp->helper = NULL;
-	exp->flags = 0;
+	nf_ct_expect_init(exp, cmd.l3num,
+			  &ct->tuplehash[!dir].tuple.src.u3, daddr,
+			  IPPROTO_TCP, NULL, &cmd.u.tcp.port);
 
 	/* Now, NAT might want to mangle the packet, and register the
 	 * (possibly changed) expectation itself. */
