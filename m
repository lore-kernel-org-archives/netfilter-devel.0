From: Samuel Jean <sj-netfilter@cookinglinux.org>
Subject: [PATCH 1/2] ipt_hashlimit.c: expire's type overflow when showing
 tuples at bad moment.
Date: Wed, 26 Jan 2005 22:51:43 -0500
Message-ID: <41F8654F.2020607@cookinglinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
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

Name: Expire's type overflow when showing tuples at bad moment.
Status: Tested under Linux 2.6.10
Signed-off-by: Samuel Jean <sjean@cookinglinux.org>

When garbage collector runs slow enough, we have a chance to print
expired tuples before they get freed. We see weird expiry time.

This patch just prints 0 if expiry is less than or equal to current
jiffie.

Please disregard my previous patch.

--- net/ipv4/netfilter/ipt_hashlimit.c.orig  2005-01-26 22:17:54.000000000 -0500
+++ net/ipv4/netfilter/ipt_hashlimit.c 2005-01-26 22:22:07.000000000 -0500
@@ -608,8 +608,8 @@ static inline int dl_seq_real_show(struc
    /* recalculate to show accurate numbers */
    rateinfo_recalc(ent, jiffies);

-  return seq_printf(s, "%ld %u.%u.%u.%u:%u->%u.%u.%u.%u:%u %u %u %u\n",
-        (ent->expires - jiffies)/HZ,
+  return seq_printf(s, "%lu %u.%u.%u.%u:%u->%u.%u.%u.%u:%u %u %u %u\n",
+        (ent->expires > jiffies) ? (ent->expires - jiffies)/HZ : 0,
          NIPQUAD(ent->dst.src_ip), ntohs(ent->dst.src_port),
          NIPQUAD(ent->dst.dst_ip), ntohs(ent->dst.dst_port),
          ent->rateinfo.credit, ent->rateinfo.credit_cap,
