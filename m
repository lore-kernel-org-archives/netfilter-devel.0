From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 02/**] make extra_opts const
Date: Tue, 24 Jul 2007 12:16:00 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0707241215060.18990@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: kaber@trash.net
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




Make xtables_target->extra_opts const (xtables_match->extra_opts already is)

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 include/xtables.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: iptables/include/xtables.h
===================================================================
--- iptables.orig/include/xtables.h
+++ iptables/include/xtables.h
@@ -158,7 +158,7 @@ struct xtables_target
 		     const struct xt_entry_target *target);
 
 	/* Pointer to list of extra command-line options */
-	struct option *extra_opts;
+	const struct option *extra_opts;
 
 	/* Ignore these men behind the curtain: */
 	unsigned int option_offset;
