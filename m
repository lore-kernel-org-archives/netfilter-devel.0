From: Pablo Neira <pablo@eurodev.net>
Subject: Re: sparc64 match module - bug id 94
Date: Thu, 06 May 2004 16:29:15 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <409A4BBB.9080401@eurodev.net>
References: <20040505065402.GA18440@hamachi.radom.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040502040209040200000704"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter@radom.org, Henrik Nordstrom <hno@marasystems.com>,
 KOVACS Krisztian <hidden@balabit.hu>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <20040505065402.GA18440@hamachi.radom.org>
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
--------------040502040209040200000704
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi everyone,

dan radom wrote:

>Hi,
>
>This bug has been open for quite some time, and bugzilla doesn't really
>shows much beyond the initial bug report.  Is this something that will
>ever work?  I would love to use this feature on sparc64.
>  
>

Please, if I'm missing something, kill me softly. Is there anything 
wrong in fixing up the problem with the following patch?

regards,
Pablo

--------------040502040209040200000704
Content-Type: text/plain;
 name="ipt_limit-fixup.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ipt_limit-fixup.patch"

diff -u -r1.1.1.1 ipt_limit.c
--- a/net/ipv4/netfilter/ipt_limit.c	5 May 2004 01:30:27 -0000	1.1.1.1
+++ b/net/ipv4/netfilter/ipt_limit.c	6 May 2004 14:16:57 -0000
@@ -31,6 +31,10 @@
 
 static spinlock_t limit_lock = SPIN_LOCK_UNLOCKED;
 
+/* For SMP machines: Since every processor has a copy of the structure
+ * ipt_rateinfo, we must only work with one of them. */
+static struct ipt_rateinfo *master;
+
 /* Rusty: This is my (non-mathematically-inclined) understanding of
    this algorithm.  The `average rate' in jiffies becomes your initial
    amount of credit `credit' and the most credit you can ever have
@@ -70,17 +74,16 @@
 		int offset,
 		int *hotdrop)
 {
-	struct ipt_rateinfo *r = ((struct ipt_rateinfo *)matchinfo)->master;
 	unsigned long now = jiffies;
 
 	spin_lock_bh(&limit_lock);
-	r->credit += (now - xchg(&r->prev, now)) * CREDITS_PER_JIFFY;
-	if (r->credit > r->credit_cap)
-		r->credit = r->credit_cap;
+	master->credit += (now - xchg(&master->prev, now)) * CREDITS_PER_JIFFY;
+	if (master->credit > master->credit_cap)
+		master->credit = master->credit_cap;
 
-	if (r->credit >= r->cost) {
+	if (master->credit >= master->cost) {
 		/* We're not limited. */
-		r->credit -= r->cost;
+		master->credit -= master->cost;
 		spin_unlock_bh(&limit_lock);
 		return 1;
 	}
@@ -129,7 +132,7 @@
 	r->cost = user2credits(r->avg);
 
 	/* For SMP, we only want to use one set of counters. */
-	r->master = r;
+	master = r;
 
 	return 1;
 }
diff -u -r1.1.1.1 ipt_limit.h
--- a/include/linux/netfilter_ipv4/ipt_limit.h	5 May 2004 01:33:05 -0000	1.1.1.1
+++ b/include/linux/netfilter_ipv4/ipt_limit.h	6 May 2004 14:17:22 -0000
@@ -14,8 +14,5 @@
 	unsigned long prev;
 	u_int32_t credit;
 	u_int32_t credit_cap, cost;
-
-	/* Ugly, ugly fucker. */
-	struct ipt_rateinfo *master;
 };
 #endif /*_IPT_RATE_H*/

--------------040502040209040200000704--
