From: "David S. Miller" <davem@redhat.com>
Subject: Re: iptables+2.6-test8-bk4 : Still problems
Date: Tue, 28 Oct 2003 23:13:17 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031028231317.7840e47f.davem@redhat.com>
References: <3F9B8A5D.9010803@triaton-webhosting.com>
	<200310261052.25944.rezso@rdsor.ro>
	<20031026223438.1cf757ce.davem@redhat.com>
	<3F9ED206.4040806@triaton-webhosting.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: rezso@rdsor.ro, sparclinux@vger.kernel.org,
        netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Georg Chini <georg.chini@triaton-webhosting.com>
In-Reply-To: <3F9ED206.4040806@triaton-webhosting.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Ok, here is the patch I'm using to fix this, please test.

Thanks again for figuring out the problem Georg.

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.1380  -> 1.1381 
#	        net/compat.c	1.11    -> 1.12   
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 03/10/28	davem@nuts.ninka.net	1.1381
# [NET/COMPAT]: Fix copying of ipt_entry objects in do_netfilter_replace().
# 
# As noted by Georg Chini, ipt_entry object are of variable size
# so just copying individual struct ipt_entry slots around does
# not work.
# --------------------------------------------
#
diff -Nru a/net/compat.c b/net/compat.c
--- a/net/compat.c	Tue Oct 28 23:16:40 2003
+++ b/net/compat.c	Tue Oct 28 23:16:40 2003
@@ -322,7 +322,7 @@
 	u32 origsize, tmp32, num_counters;
 	unsigned int repl_nat_size;
 	int ret;
-	int i, num_ents;
+	int i;
 	compat_uptr_t ucntrs;
 
 	if (get_user(origsize, &urepl->size))
@@ -366,15 +366,10 @@
 	    __put_user(compat_ptr(ucntrs), &repl_nat->counters))
 		goto out;
 
-	num_ents = origsize / sizeof(struct ipt_entry);
-
-	for (i = 0; i < num_ents; i++) {
-		struct ipt_entry ent;
-
-		if (__copy_from_user(&ent, &urepl->entries[i], sizeof(ent)) ||
-		    __copy_to_user(&repl_nat->entries[i], &ent, sizeof(ent)))
-			goto out;
-	}
+	if (__copy_in_user(&repl_nat->entries[0],
+			   &urepl->entries[0],
+			   origsize))
+		goto out;
 
 	for (i = 0; i < NF_IP_NUMHOOKS; i++) {
 		if (__get_user(tmp32, &urepl->hook_entry[i]) ||
