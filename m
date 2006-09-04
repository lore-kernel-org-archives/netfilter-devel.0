From: Dmitry Mishin <dim@openvz.org>
Subject: check_entry & module_refcount
Date: Mon, 4 Sep 2006 16:17:39 +0400
Message-ID: <200609041617.39950.dim@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
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

Hello, all!

Does anybody know why there is no module_put() on the error way after failed 
standard_check() call in the check_entry() function? Previous xt_find_target()
calls try_module_get() for all targets, without special checks for
standard_target.

If it is a bug, patch over net-2.6.19 is below.

Signed-off-by: Dmitry Mishin <dim@openvz.org>

--
 ip_tables.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- ./net/ipv4/netfilter/ip_tables.c.err	2006-08-30 13:12:13.000000000 +0400
+++ ./net/ipv4/netfilter/ip_tables.c	2006-09-04 16:01:11.000000000 +0400
@@ -573,7 +573,7 @@
 	if (t->u.kernel.target == &ipt_standard_target) {
 		if (!standard_check(t, size)) {
 			ret = -EINVAL;
-			goto cleanup_matches;
+			goto err;
 		}
 	} else if (t->u.kernel.target->checkentry
 		   && !t->u.kernel.target->checkentry(name, e, target, t->data,
