From: Samuel Jean <sj-netfilter@cookinglinux.org>
Subject: [PATCH] ipt_hashlimit.c: expire's type overflow when showing tuples
 at bad moment.
Date: Sat, 22 Jan 2005 20:32:02 -0500
Message-ID: <41F2FE92.6020603@cookinglinux.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070206050101000109070100"
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

This is a multi-part message in MIME format.
--------------070206050101000109070100
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Name: Expire's type overflow when showing tuples at bad moment.
Status: Tested under Linux 2.6.6 uml patched.
Signed-off-by: Samuel Jean <sjean@cookinglinux.org>

When garbage collector runs slow enough, we have a chance to print
expired tuples before they get freed. We see weird expiry time.

Not sure if I needed 'now' reference so I didn't took chance.

Index: linux-2.6.6/net/ipv4/netfilter/ipt_hashlimit.c
===================================================================


--------------070206050101000109070100
Content-Type: text/x-patch;
 name="ipt_hashlimit.c-proc_show.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ipt_hashlimit.c-proc_show.patch"

--- net/ipv4/netfilter/ipt_hashlimit.c.orig	2005-01-22 19:48:05.000000000 -0500
+++ net/ipv4/netfilter/ipt_hashlimit.c	2005-01-22 19:50:44.000000000 -0500
@@ -605,11 +605,12 @@ static void dl_seq_stop(struct seq_file 
 
 static inline int dl_seq_real_show(struct dsthash_ent *ent, struct seq_file *s)
 {
+	unsigned int now = jiffies;
 	/* recalculate to show accurate numbers */
-	rateinfo_recalc(ent, jiffies);
+	rateinfo_recalc(ent, now);
 
-	return seq_printf(s, "%ld %u.%u.%u.%u:%u->%u.%u.%u.%u:%u %u %u %u\n",
-			(ent->expires - jiffies)/HZ,
+	return seq_printf(s, "%lu %u.%u.%u.%u:%u->%u.%u.%u.%u:%u %u %u %u\n",
+			(ent->expires > now) ? (ent->expires - now)/HZ : 0,
 			NIPQUAD(ent->dst.src_ip), ntohs(ent->dst.src_port),
 			NIPQUAD(ent->dst.dst_ip), ntohs(ent->dst.dst_port),
 			ent->rateinfo.credit, ent->rateinfo.credit_cap,

--------------070206050101000109070100--
