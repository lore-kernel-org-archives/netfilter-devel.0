From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [NEW TARGET] target for modifying conntrack timeout value
Date: Wed, 08 Dec 2004 21:09:56 +0100
Message-ID: <41B75F94.9020906@eurodev.net>
References: <EINSTEINUmE8mGbGxMY00006d26@einstein.systemmetrics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Richard <richard@o-matrix.org>
In-Reply-To: <EINSTEINUmE8mGbGxMY00006d26@einstein.systemmetrics.com>
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

Richard wrote:

>I sent this out a few days ago and got no reply. Thought that I should put a
>more obvious subject.
>

yes, now it's that obvious :)

> I wonder if someone can include this into svn.
>  
>

OK, please next time post the patch clear text instead of a gzip, it's 
easier to review.

In the meantime this is pushed to the SVN, we have to fix some problems. 
I just had a look at ipt_CTEXPIRE.c. Some comments:


Index: CTEXPIRE/linux/net/ipv4/netfilter/ipt_CTEXPIRE.c
===================================================================
--- CTEXPIRE/linux/net/ipv4/netfilter/ipt_CTEXPIRE.c    (revision 0)
+++ CTEXPIRE/linux/net/ipv4/netfilter/ipt_CTEXPIRE.c    (revision 0)
@@ -0,0 +1,176 @@
+/* CTEXPIRE modification target for IP tables
+ * (C) 2004 by Richard Zheng <richard@o-matrix.org>
+ *
+ * Version: 1.0
+ *
+ * This software is distributed under the terms of GNU GPL
+ */
+
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/ip.h>
+#include <net/checksum.h>
+
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ipt_CTEXPIRE.h>
+#include <linux/netfilter_ipv4/ip_conntrack.h>
+
+MODULE_AUTHOR("Richard Zheng <richard@o-matrix.org>");
+MODULE_DESCRIPTION("IP tables CTEXPIRE modification module");
+MODULE_LICENSE("GPL");
+
+#undef DEBUG
+
+DECLARE_RWLOCK(ip_conntrack_lock);

^^^
ouch, you can't do that.

+static unsigned int
+ipt_ctexpire_target(struct sk_buff **pskb,
+    unsigned int hooknum,
+    const struct net_device *in,
+    const struct net_device *out,
+    const void *targinfo,
+    void *userinfo)
+
+{
+    const struct ipt_CTEXPIRE_info *info = targinfo;
+#ifdef KERNEL_64_USERSPACE_32
+    unsigned long long new_expires;
+#else
+    unsigned long new_expires;
+#endif

   ^^^^^
that ifdef just makes sense in user space, remove it and leave it as "long".


+    enum ip_conntrack_info ctinfo;
+    struct ip_conntrack *ct = ip_conntrack_get((*pskb), &ctinfo);
+
+
+    IP_NF_ASSERT(ct->timeout.data == (unsigned long)ct);

check if ct == NULL. In that case return 0.

Invalid packets don't have a conntrack associated.

+    new_expires = info->expires*HZ;
+
+    if (new_expires < info->expires) {
+        /* if user specified value is too big, *HZ can overflow the counter
+         * since it is big enough, just use the new value without *HZ
+         */
+        new_expires = info->expires;

          ^^^
       check this in user space

+    }
+
+    WRITE_LOCK(&ip_conntrack_lock);
+
+#ifdef DEBUG
+    printk(KERN_WARNING "CTEXPIRE: fired = %s, mode %d, value %ld\n",
+           !is_confirmed(ct) ? "no" : "yes", info->mode, info->expires);
+    unsigned long enter = ct->timeout.expires;
+#endif
+
+    /* If not in hash table, timer will not be active yet */
+    if (!is_confirmed(ct)) {
+        switch (info->mode) {
+            case IPT_CTEXPIRE_SET:
+                ct->timeout.expires = new_expires;
                  ^^^

Hm I thought that I told you to use ip_ct_refresh... you should. Your 
target will look smarter and you can forget about proper locking... 
which is now completely broken...

See your next email.

--
Pablo
