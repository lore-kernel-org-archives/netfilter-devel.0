From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH NF_CONNTRACK 8/9]: zero-clear union area in tuple for
 expectant
Date: Wed, 15 Jun 2005 13:05:31 +0900 (JST)
Message-ID: <200506150405.j5F45VgR021658@toshiba.co.jp>
References: <200505230623.j4N6NMVu004917@toshiba.co.jp>
	<42AB050C.40105@trash.net>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Wed_Jun_15_13:05:31_2005_590)--"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <42AB050C.40105@trash.net>
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

----Next_Part(Wed_Jun_15_13:05:31_2005_590)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


From: Patrick McHardy <kaber@trash.net>
Date: Sat, 11 Jun 2005 17:36:44 +0200

> Yasuyuki KOZAKAI wrote:
> > This patch clears union area in tuple for expectant.
> 
> Why is this necessary? The helpers should initialize tuple and mask.

OK, please apply this patch instead of it.

Regards,

-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>


----Next_Part(Wed_Jun_15_13:05:31_2005_590)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="exp-tuple-init.patch"

Index: net/netfilter/nf_conntrack_ftp.c
===================================================================
--- 9f4386a4dd0fa00c434d7acc6b8bc3de43e60a3b/net/netfilter/nf_conntrack_ftp.c  (mode:100644)
+++ uncommitted/net/netfilter/nf_conntrack_ftp.c  (mode:100644)
@@ -565,28 +565,29 @@
 		       sizeof(exp->tuple.dst.u3));
 	}
 
+	exp->tuple.src.u3 = ct->tuplehash[!dir].tuple.src.u3;
+	exp->tuple.src.l3num = cmd.l3num;
+	exp->tuple.src.u.tcp.port = 0;
+	exp->tuple.dst.u.tcp.port = cmd.u.tcp.port;
+	exp->tuple.dst.protonum = IPPROTO_TCP;
+
+	exp->mask = (struct nf_conntrack_tuple)
+		    { .src = { .l3num = 0xFFFF,
+			       .u = { .tcp = { 0 }},
+			     },
+		      .dst = { .protonum = 0xFF,
+			       .u = { .tcp = { 0xFFFF }},
+			     },
+		    };
 	if (cmd.l3num == PF_INET) {
-		exp->tuple.src.u3.ip = ct->tuplehash[!dir].tuple.src.u3.ip;
 		exp->mask.src.u3.ip = 0xFFFFFFFF;
 		exp->mask.dst.u3.ip = 0xFFFFFFFF;
 	} else {
-		memcpy(exp->tuple.src.u3.ip6,
-		       ct->tuplehash[!dir].tuple.src.u3.ip6,
-		       sizeof(exp->tuple.src.u3.ip6));
 		memset(exp->mask.src.u3.ip6, 0xFF,
 		       sizeof(exp->mask.src.u3.ip6));
 		memset(exp->mask.dst.u3.ip6, 0xFF,
 		       sizeof(exp->mask.src.u3.ip6));
 	}
-	exp->tuple.src.l3num = cmd.l3num;
-	exp->tuple.src.u.tcp.port = 0;
-	exp->tuple.dst.u.tcp.port = cmd.u.tcp.port;
-	exp->tuple.dst.protonum = IPPROTO_TCP;
-
-	exp->mask.src.l3num = 0xFFFF;
-	exp->mask.src.u.tcp.port = 0;
-	exp->mask.dst.u.tcp.port = 0xFFFF;
-	exp->mask.dst.protonum = 0xFF;
 
 	exp->expectfn = NULL;
 	exp->master = ct;

----Next_Part(Wed_Jun_15_13:05:31_2005_590)----
