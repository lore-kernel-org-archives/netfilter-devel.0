From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER]: nf_conntrack_ftp: use nf_conntrack_expect_init
Date: Tue, 26 Jun 2007 15:59:41 +0200
Message-ID: <46811BCD.4010703@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------020005090907040903080805"
To: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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
--------------020005090907040903080805
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit



--------------020005090907040903080805
Content-Type: text/x-diff;
 name="02.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="02.diff"

[NETFILTER]: nf_conntrack_ftp: use nf_conntrack_expect_init

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 9b4fedd621050b1ab63dda01526b2902cd238871
tree 40f2e257a97f84607caa376b88a7c8dbc7cd83db
parent 1b54b00d69fd371821949bf429642dfc98153bcb
author Patrick McHardy <kaber@trash.net> Tue, 26 Jun 2007 15:42:50 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 26 Jun 2007 15:42:50 +0200

 net/netfilter/nf_conntrack_ftp.c |   36 ++++++------------------------------
 1 files changed, 6 insertions(+), 30 deletions(-)

diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index 82db2aa..868e37a 100644
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
+	nf_conntrack_expect_init(exp, cmd.l3num,
+				 &ct->tuplehash[!dir].tuple.src.u3, daddr,
+				 IPPROTO_TCP, NULL, &cmd.u.tcp.port);
 
 	/* Now, NAT might want to mangle the packet, and register the
 	 * (possibly changed) expectation itself. */

--------------020005090907040903080805--
