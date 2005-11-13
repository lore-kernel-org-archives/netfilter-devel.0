From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] ctproto printing in conntrack match (bug 398)
Date: Sun, 13 Nov 2005 07:18:58 -0800
Message-ID: <20051113151858.GA25799@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="+QahgC5+KEYLbs62"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The conntrack match does not print any info for --ctproto, thus
breaking iptables-restore of any rules using this option.  Below
patch adds output and closes bug #398.

Phil



--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-ctproto

diff -ru ipt-orig/extensions/libipt_conntrack.c ipt-new/extensions/libipt_conntrack.c
--- ipt-orig/extensions/libipt_conntrack.c	2005-10-31 11:03:50.000000000 -0800
+++ ipt-new/extensions/libipt_conntrack.c	2005-11-13 07:12:20.000000000 -0800
@@ -442,6 +442,13 @@
 		print_state(sinfo->statemask);
 	}
 
+	if(sinfo->flags & IPT_CONNTRACK_PROTO) {
+		printf("%sctproto ", optpfx);
+        	if (sinfo->invflags & IPT_CONNTRACK_PROTO)
+                	printf("! ");
+		printf("%u ", sinfo->tuple[IP_CT_DIR_ORIGINAL].dst.protonum);
+	}
+
 	if(sinfo->flags & IPT_CONNTRACK_ORIGSRC) {
 		printf("%sctorigsrc ", optpfx);
 

--+QahgC5+KEYLbs62--
