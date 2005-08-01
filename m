From: Pawel Sikora <pluto@agmk.net>
Subject: [TRIVIAL PATCH] gcc4 / kill `extern inline` in nf_conntrack.h
Date: Mon, 1 Aug 2005 12:08:02 +0200
Message-ID: <200508011208.02830.pluto@agmk.net>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_CSf7Cr9Wxrds3LJ"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
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

--Boundary-00=_CSf7Cr9Wxrds3LJ
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline



--Boundary-00=_CSf7Cr9Wxrds3LJ
Content-Type: text/x-diff;
  charset="utf-8";
  name="nf_ct.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="nf_ct.diff"

Index: linux-2.6/include/linux/netfilter/nf_conntrack.h
===================================================================
--- linux-2.6/include/linux/netfilter/nf_conntrack.h	(revision 4208)
+++ linux-2.6/include/linux/netfilter/nf_conntrack.h	(working copy)
@@ -218,7 +218,7 @@
 }
 
 /* decrement reference count on a conntrack */
-extern inline void nf_ct_put(struct nf_conn *ct);
+extern void nf_ct_put(struct nf_conn *ct);
 
 /* call to create an explicit dependency on nf_conntrack. */
 extern void need_nf_conntrack(void);

--Boundary-00=_CSf7Cr9Wxrds3LJ--
