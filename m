From: Samuel Jean <sj-netfilter@cookinglinux.org>
Subject: [PATCH] ipt_hashlimit.c, inline patches broken.
Date: Wed, 26 Jan 2005 23:13:39 -0500
Message-ID: <41F86A73.1010909@cookinglinux.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000405080108000101030107"
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
--------------000405080108000101030107
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Harald,

Sorry, looks like my mailer puts trailing spaces.
Here's both patch attached.

Regards,

Samuel

--------------000405080108000101030107
Content-Type: text/x-patch;
 name="ipt_hashlimit.c-cantsleep.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ipt_hashlimit.c-cantsleep.patch"

--- net/ipv4/netfilter/ipt_hashlimit.c.orig	2005-01-26 22:35:43.000000000 -0500
+++ net/ipv4/netfilter/ipt_hashlimit.c	2005-01-26 22:36:14.000000000 -0500
@@ -570,7 +570,7 @@ static void *dl_seq_start(struct seq_fil
 	if (*pos >= htable->cfg.size)
 		return NULL;
 
-	bucket = kmalloc(sizeof(unsigned int), GFP_KERNEL);
+	bucket = kmalloc(sizeof(unsigned int), GFP_ATOMIC);
 	if (!bucket)
 		return ERR_PTR(-ENOMEM);
 

--------------000405080108000101030107
Content-Type: text/x-patch;
 name="ipt_hashlimit.c-proc_show.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ipt_hashlimit.c-proc_show.patch"

--- net/ipv4/netfilter/ipt_hashlimit.c.orig	2005-01-26 22:17:54.000000000 -0500
+++ net/ipv4/netfilter/ipt_hashlimit.c	2005-01-26 22:22:07.000000000 -0500
@@ -608,8 +608,8 @@ static inline int dl_seq_real_show(struc
 	/* recalculate to show accurate numbers */
 	rateinfo_recalc(ent, jiffies);
 
-	return seq_printf(s, "%ld %u.%u.%u.%u:%u->%u.%u.%u.%u:%u %u %u %u\n",
-			(ent->expires - jiffies)/HZ,
+	return seq_printf(s, "%lu %u.%u.%u.%u:%u->%u.%u.%u.%u:%u %u %u %u\n",
+			(ent->expires > jiffies) ? (ent->expires - jiffies)/HZ : 0,
 			NIPQUAD(ent->dst.src_ip), ntohs(ent->dst.src_port),
 			NIPQUAD(ent->dst.dst_ip), ntohs(ent->dst.dst_port),
 			ent->rateinfo.credit, ent->rateinfo.credit_cap,

--------------000405080108000101030107--
