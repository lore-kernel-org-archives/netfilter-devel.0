From: Dennis Koslowski <dkoslowski@astaro.com>
Subject: [PATCH] ipt_dstlimit.c - locking & macros
Date: Tue, 27 Jul 2004 10:15:01 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <41060F05.6070700@astaro.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020107050009060105000100"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------020107050009060105000100
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

The dstlimit code will be not compiled with 2.4.26 because of outdated 
locking variable. Here is a quick fix, I hope it will be usefull for 
someone else.

Regards
-- 
Dennis Koslowski <dkoslowski@astaro.com> | Product Development
Astaro AG | http://www.astaro.com | +49-721-490069-0 | Fax -55



--------------020107050009060105000100
Content-Type: text/x-patch;
 name="ipt_dstlimit.c.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ipt_dstlimit.c.diff"

--- linux-2.4.26/net/ipv4/netfilter/ipt_dstlimit.c.orig	2004-07-26 16:36:30.000000000 +0200
+++ linux-2.4.26/net/ipv4/netfilter/ipt_dstlimit.c	2004-07-27 09:56:18.000000000 +0200
@@ -83,7 +83,7 @@ struct ipt_dstlimit_htable {
 	struct dstlimit_cfg cfg;	/* config */
 
 	/* used internally */
-	spinlock_t lock;		/* lock for list_head */
+	struct spinlock_debug lock;	/* lock for list_head */
 	u_int32_t rnd;			/* random seed for hash */
 	struct timer_list timer;	/* timer for gc */
 	atomic_t count;			/* number entries in table */
@@ -179,7 +179,8 @@ static int htable_create(struct ipt_dstl
 	int i;
 	unsigned int size;
 	struct ipt_dstlimit_htable *hinfo;
-
+	DECLARE_LOCK(lock_aux);
+	
 	if (minfo->cfg.size)
 		size = minfo->cfg.size;
 	else {
@@ -213,7 +214,8 @@ static int htable_create(struct ipt_dstl
 	atomic_set(&hinfo->count, 0);
 	atomic_set(&hinfo->use, 1);
 	hinfo->rnd = 0;
-	hinfo->lock = SPIN_LOCK_UNLOCKED;
+/* 	hinfo->lock = SPIN_LOCK_UNLOCKED; */
+	hinfo->lock = lock_aux;
 	hinfo->pde = create_proc_entry(minfo->name, 0, dstlimit_procdir);
 	if (!hinfo->pde) {
 		vfree(hinfo);

--------------020107050009060105000100--
