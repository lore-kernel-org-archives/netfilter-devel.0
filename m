From: KOVACS Krisztian <hidden@sch.bme.hu>
Subject: [PATCH] conntrack: fix ICMP protocol extension parse callback
Date: Sun, 19 Mar 2006 23:06:03 +0100
Message-ID: <200603192306.05364@krak>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_NXdHEi4Uaj2y9lC"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@eurodev.net>
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

--Boundary-00=_NXdHEi4Uaj2y9lC
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


  Hi,

  It seems to me that there's a line missing in the ICMP protocol 
extension module of the conntrack tool, the attached patch fixes the 
problem.

-- 
 KOVACS Krisztian

--Boundary-00=_NXdHEi4Uaj2y9lC
Content-Type: text/x-diff; charset="us-ascii";
	name="conntrack_icmp_extension_argument_fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="conntrack_icmp_extension_argument_fix.patch"

Index: conntrack/extensions/libct_proto_icmp.c
===================================================================
--- conntrack/extensions/libct_proto_icmp.c	(revision 6554)
+++ conntrack/extensions/libct_proto_icmp.c	(working copy)
@@ -45,6 +45,7 @@
 static int parse(char c, char *argv[], 
 		 struct nfct_tuple *orig,
 		 struct nfct_tuple *reply,
+		 struct nfct_tuple *exptuple,
 		 struct nfct_tuple *mask,
 		 union nfct_protoinfo *proto,
 		 unsigned int *flags)

--Boundary-00=_NXdHEi4Uaj2y9lC--
