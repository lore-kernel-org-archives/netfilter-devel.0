From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] ipt_dstlimit spinlock fixup
Date: Mon, 23 Aug 2004 20:47:06 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <412A3BAA.6000708@trash.net>
References: <20040822153348.GA20301@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20040822153348.GA20301@linuxace.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Phil Oester wrote:

>Since ipt_dstlimit makes use of MUST_BE_LOCKED macro, compiling
>without CONFIG_NETFILTER_DEBUG causes errors.  Fix below.
>
>Similar patch posted by Samir Bellabes a few days ago, but this one
>removes an unneeded #ifdef pair
>
>This fixes bugzilla #225
>  
>

Jozsefs conntrack_locking patch has the same problem, I wonder if we
should introduce a spinlock_debug_t (if that is not taken yet) or
better yet, kill lockhelp.h.

Regards
Patrick

>Phil
>
>
>diff -ru pom-orig/dstlimit/linux-2.6/net/ipv4/netfilter/ipt_dstlimit.c pom-new/dstlimit/linux-2.6/net/ipv4/netfilter/ipt_dstlimit.c
>--- pom-orig/dstlimit/linux-2.6/net/ipv4/netfilter/ipt_dstlimit.c       2004-02-22 19:15:45.000000000 -0500
>+++ pom-new/dstlimit/linux-2.6/net/ipv4/netfilter/ipt_dstlimit.c        2004-08-22 11:30:10.156485400 -0400
>@@ -83,7 +83,11 @@
>        struct dstlimit_cfg cfg;        /* config */
> 
>        /* used internally */
>+#ifdef CONFIG_NETFILTER_DEBUG
>+       struct spinlock_debug lock;     /* lock for list_head */
>+#else
>        spinlock_t lock;                /* lock for list_head */
>+#endif
>        u_int32_t rnd;                  /* random seed for hash */
>        struct timer_list timer;        /* timer for gc */
>        atomic_t count;                 /* number entries in table */
>@@ -212,7 +216,11 @@
>        atomic_set(&hinfo->count, 0);
>        atomic_set(&hinfo->use, 1);
>        hinfo->rnd = 0;
>+#ifdef CONFIG_NETFILTER_DEBUG
>+       hinfo->lock.l = SPIN_LOCK_UNLOCKED;
>+#else
>        hinfo->lock = SPIN_LOCK_UNLOCKED;
>+#endif
>        hinfo->pde = create_proc_entry(minfo->name, 0, dstlimit_procdir);
>        if (!hinfo->pde) {
>                vfree(hinfo);
>
>  
>
