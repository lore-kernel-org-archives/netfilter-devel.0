From: Dmitry Mishin <dim@openvz.org>
Subject: small check_entry & module_refcount cleanup
Date: Thu, 7 Sep 2006 14:08:28 +0400
Message-ID: <200609071408.28380.dim@openvz.org>
References: <200609041617.39950.dim@openvz.org>
	<200609060124.k861OBle010614@toshiba.co.jp>
	<44FF1209.2000302@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <44FF1209.2000302@trash.net>
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

While standard_target has target->me == NULL, module_put() should be
called for it as for others, because there were try_module_get() before.

Signed-off-by: Dmitry Mishin <dim@openvz.org>
-- 

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 4f10b06..0e899f0 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -487,7 +487,7 @@ static inline int check_entry(struct arp
 	if (t->u.kernel.target == &arpt_standard_target) {
 		if (!standard_check(t, size)) {
 			ret = -EINVAL;
-			goto out;
+			goto err;
 		}
 	} else if (t->u.kernel.target->checkentry
 		   && !t->u.kernel.target->checkentry(name, e, target, t->data,
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index a0f3680..38e1e4f 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -573,7 +573,7 @@ check_entry(struct ipt_entry *e, const c
 	if (t->u.kernel.target == &ipt_standard_target) {
 		if (!standard_check(t, size)) {
 			ret = -EINVAL;
-			goto cleanup_matches;
+			goto err;
 		}
 	} else if (t->u.kernel.target->checkentry
 		   && !t->u.kernel.target->checkentry(name, e, target, t->data,
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index d1c3153..3becbb5 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -613,7 +613,7 @@ check_entry(struct ip6t_entry *e, const 
 	if (t->u.kernel.target == &ip6t_standard_target) {
 		if (!standard_check(t, size)) {
 			ret = -EINVAL;
-			goto cleanup_matches;
+			goto err;
 		}
 	} else if (t->u.kernel.target->checkentry
 		   && !t->u.kernel.target->checkentry(name, e, target, t->data,
