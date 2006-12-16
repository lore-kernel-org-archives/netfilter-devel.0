From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: [PATCH] xt_request_find_match
Date: Sat, 16 Dec 2006 18:55:20 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0612161851180.30896@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
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

Hi,



Reusing code is a good idea, and I would like to do so from my 
match modules. netfilter already provides a xt_request_find_target() but 
an xt_request_find_match() does not yet exist. This patch adds it.

Objections welcome :)

---

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

Index: linux-2.6.20-rc1/net/netfilter/x_tables.c
===================================================================
--- linux-2.6.20-rc1.orig/net/netfilter/x_tables.c
+++ linux-2.6.20-rc1/net/netfilter/x_tables.c
@@ -206,6 +206,19 @@ struct xt_match *xt_find_match(int af, c
 }
 EXPORT_SYMBOL(xt_find_match);
 
+struct xt_match *xt_request_find_match(int af, const char *name, u8 revision)
+{
+	struct xt_match *match;
+
+	match = try_then_request_module(xt_find_match(af, name, revision),
+	                                "%st_%s", xt_prefix[af], name);
+	if(IS_ERR(match) || match == NULL)
+		return NULL;
+
+	return match;
+}
+EXPORT_SYMBOL_GPL(xt_request_find_match);
+
 /* Find target, grabs ref.  Returns ERR_PTR() on error. */
 struct xt_target *xt_find_target(int af, const char *name, u8 revision)
 {
#<EOF>

	-`J'
-- 
