From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER]: Kill ebt_ulog
Date: Sat, 23 Jul 2005 04:40:51 +0200
Message-ID: <42E1AE33.4000400@trash.net>
References: <42E1ADB2.1080109@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030803030109090104030604"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	bdschuym@pandora.be
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
In-Reply-To: <42E1ADB2.1080109@trash.net>
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
--------------030803030109090104030604
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Patrick McHardy wrote:

> [NETFILTER]: Kill ebt_ulog

Oops, sorry, I forgot to remove the Makefile entry.


--------------030803030109090104030604
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NETFILTER]: Kill ebt_ulog

It uses NETLINK_NFLOG, which is also used by ipt_ULOG, so it causes
conflicts in netlink_kernel_create. As no userspace daemon exists,
and a generic replacement by Harald will follow in the next couple
of days, kill it.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit e2200c9015e33a7619f856349dc883dbadae2ea6
tree 1e91d9b3453addf227b9daf7f4f6496f8a5dd764
parent 3aa13776ac25163f546d52cc990d194bbbb9120c
author Patrick McHardy <kaber@trash.net> Sat, 23 Jul 2005 04:39:57 +0200
committer Patrick McHardy <kaber@trash.net> Sat, 23 Jul 2005 04:39:57 +0200

 net/bridge/netfilter/Kconfig    |   13 --
 net/bridge/netfilter/Makefile   |    1 
 net/bridge/netfilter/ebt_ulog.c |  295 ---------------------------------------
 3 files changed, 0 insertions(+), 309 deletions(-)

diff --git a/net/bridge/netfilter/Kconfig b/net/bridge/netfilter/Kconfig
--- a/net/bridge/netfilter/Kconfig
+++ b/net/bridge/netfilter/Kconfig
@@ -195,17 +195,4 @@ config BRIDGE_EBT_LOG
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
-config BRIDGE_EBT_ULOG
-	tristate "ebt: ulog support"
-	depends on BRIDGE_NF_EBTABLES
-	help
-	  This option adds the ulog watcher, that you can use in any rule
-	  in any ebtables table. The packet is passed to a userspace
-	  logging daemon using netlink multicast sockets. This differs
-	  from the log watcher in the sense that the complete packet is
-	  sent to userspace instead of a descriptive text and that
-	  netlink multicast sockets are used instead of the syslog.
-
-	  To compile it as a module, choose M here.  If unsure, say N.
-
 endmenu
diff --git a/net/bridge/netfilter/Makefile b/net/bridge/netfilter/Makefile
--- a/net/bridge/netfilter/Makefile
+++ b/net/bridge/netfilter/Makefile
@@ -29,4 +29,3 @@ obj-$(CONFIG_BRIDGE_EBT_SNAT) += ebt_sna
 
 # watchers
 obj-$(CONFIG_BRIDGE_EBT_LOG) += ebt_log.o
-obj-$(CONFIG_BRIDGE_EBT_LOG) += ebt_ulog.o
diff --git a/net/bridge/netfilter/ebt_ulog.c b/net/bridge/netfilter/ebt_ulog.c
deleted file mode 100644
--- a/net/bridge/netfilter/ebt_ulog.c
+++ /dev/null
@@ -1,295 +0,0 @@
-/*
- * netfilter module for userspace bridged Ethernet frames logging daemons
- *
- *	Authors:
- *	Bart De Schuymer <bdschuym@pandora.be>
- *
- *  November, 2004
- *
- * Based on ipt_ULOG.c, which is
- * (C) 2000-2002 by Harald Welte <laforge@netfilter.org>
- *
- * This module accepts two parameters: 
- * 
- * nlbufsiz:
- *   The parameter specifies how big the buffer for each netlink multicast
- * group is. e.g. If you say nlbufsiz=8192, up to eight kb of packets will
- * get accumulated in the kernel until they are sent to userspace. It is
- * NOT possible to allocate more than 128kB, and it is strongly discouraged,
- * because atomically allocating 128kB inside the network rx softirq is not
- * reliable. Please also keep in mind that this buffer size is allocated for
- * each nlgroup you are using, so the total kernel memory usage increases
- * by that factor.
- *
- * flushtimeout:
- *   Specify, after how many hundredths of a second the queue should be
- *   flushed even if it is not full yet.
- *
- */
-
-#include <linux/module.h>
-#include <linux/config.h>
-#include <linux/spinlock.h>
-#include <linux/socket.h>
-#include <linux/skbuff.h>
-#include <linux/kernel.h>
-#include <linux/timer.h>
-#include <linux/netlink.h>
-#include <linux/netdevice.h>
-#include <linux/module.h>
-#include <linux/netfilter_bridge/ebtables.h>
-#include <linux/netfilter_bridge/ebt_ulog.h>
-#include <net/sock.h>
-#include "../br_private.h"
-
-#define PRINTR(format, args...) do { if (net_ratelimit()) \
-                                printk(format , ## args); } while (0)
-
-static unsigned int nlbufsiz = 4096;
-module_param(nlbufsiz, uint, 0600);
-MODULE_PARM_DESC(nlbufsiz, "netlink buffer size (number of bytes) "
-                           "(defaults to 4096)");
-
-static unsigned int flushtimeout = 10;
-module_param(flushtimeout, uint, 0600);
-MODULE_PARM_DESC(flushtimeout, "buffer flush timeout (hundredths ofa second) "
-                               "(defaults to 10)");
-
-typedef struct {
-	unsigned int qlen;		/* number of nlmsgs' in the skb */
-	struct nlmsghdr *lastnlh;	/* netlink header of last msg in skb */
-	struct sk_buff *skb;		/* the pre-allocated skb */
-	struct timer_list timer;	/* the timer function */
-	spinlock_t lock;		/* the per-queue lock */
-} ebt_ulog_buff_t;
-
-static ebt_ulog_buff_t ulog_buffers[EBT_ULOG_MAXNLGROUPS];
-static struct sock *ebtulognl;
-
-/* send one ulog_buff_t to userspace */
-static void ulog_send(unsigned int nlgroup)
-{
-	ebt_ulog_buff_t *ub = &ulog_buffers[nlgroup];
-
-	if (timer_pending(&ub->timer))
-		del_timer(&ub->timer);
-
-	/* last nlmsg needs NLMSG_DONE */
-	if (ub->qlen > 1)
-		ub->lastnlh->nlmsg_type = NLMSG_DONE;
-
-	NETLINK_CB(ub->skb).dst_groups = 1 << nlgroup;
-	netlink_broadcast(ebtulognl, ub->skb, 0, 1 << nlgroup, GFP_ATOMIC);
-
-	ub->qlen = 0;
-	ub->skb = NULL;
-}
-
-/* timer function to flush queue in flushtimeout time */
-static void ulog_timer(unsigned long data)
-{
-	spin_lock_bh(&ulog_buffers[data].lock);
-	if (ulog_buffers[data].skb)
-		ulog_send(data);
-	spin_unlock_bh(&ulog_buffers[data].lock);
-}
-
-static struct sk_buff *ulog_alloc_skb(unsigned int size)
-{
-	struct sk_buff *skb;
-
-	skb = alloc_skb(nlbufsiz, GFP_ATOMIC);
-	if (!skb) {
-		PRINTR(KERN_ERR "ebt_ulog: can't alloc whole buffer "
-		       "of size %ub!\n", nlbufsiz);
-		if (size < nlbufsiz) {
-			/* try to allocate only as much as we need for
-			 * current packet */
-			skb = alloc_skb(size, GFP_ATOMIC);
-			if (!skb)
-				PRINTR(KERN_ERR "ebt_ulog: can't even allocate "
-				       "buffer of size %ub\n", size);
-		}
-	}
-
-	return skb;
-}
-
-static void ebt_ulog(const struct sk_buff *skb, unsigned int hooknr,
-   const struct net_device *in, const struct net_device *out,
-   const void *data, unsigned int datalen)
-{
-	ebt_ulog_packet_msg_t *pm;
-	size_t size, copy_len;
-	struct nlmsghdr *nlh;
-	struct ebt_ulog_info *uloginfo = (struct ebt_ulog_info *)data;
-	unsigned int group = uloginfo->nlgroup;
-	ebt_ulog_buff_t *ub = &ulog_buffers[group];
-	spinlock_t *lock = &ub->lock;
-
-	if ((uloginfo->cprange == 0) ||
-	    (uloginfo->cprange > skb->len + ETH_HLEN))
-		copy_len = skb->len + ETH_HLEN;
-	else
-		copy_len = uloginfo->cprange;
-
-	size = NLMSG_SPACE(sizeof(*pm) + copy_len);
-	if (size > nlbufsiz) {
-		PRINTR("ebt_ulog: Size %Zd needed, but nlbufsiz=%d\n",
-		       size, nlbufsiz);
-		return;
-	}
-
-	spin_lock_bh(lock);
-
-	if (!ub->skb) {
-		if (!(ub->skb = ulog_alloc_skb(size)))
-			goto alloc_failure;
-	} else if (size > skb_tailroom(ub->skb)) {
-		ulog_send(group);
-
-		if (!(ub->skb = ulog_alloc_skb(size)))
-			goto alloc_failure;
-	}
-
-	nlh = NLMSG_PUT(ub->skb, 0, ub->qlen, 0,
-	                size - NLMSG_ALIGN(sizeof(*nlh)));
-	ub->qlen++;
-
-	pm = NLMSG_DATA(nlh);
-
-	/* Fill in the ulog data */
-	pm->version = EBT_ULOG_VERSION;
-	do_gettimeofday(&pm->stamp);
-	if (ub->qlen == 1)
-		ub->skb->stamp = pm->stamp;
-	pm->data_len = copy_len;
-	pm->mark = skb->nfmark;
-	pm->hook = hooknr;
-	if (uloginfo->prefix != NULL)
-		strcpy(pm->prefix, uloginfo->prefix);
-	else
-		*(pm->prefix) = '\0';
-
-	if (in) {
-		strcpy(pm->physindev, in->name);
-		/* If in isn't a bridge, then physindev==indev */
-		if (in->br_port)
-			strcpy(pm->indev, in->br_port->br->dev->name);
-		else
-			strcpy(pm->indev, in->name);
-	} else
-		pm->indev[0] = pm->physindev[0] = '\0';
-
-	if (out) {
-		/* If out exists, then out is a bridge port */
-		strcpy(pm->physoutdev, out->name);
-		strcpy(pm->outdev, out->br_port->br->dev->name);
-	} else
-		pm->outdev[0] = pm->physoutdev[0] = '\0';
-
-	if (skb_copy_bits(skb, -ETH_HLEN, pm->data, copy_len) < 0)
-		BUG();
-
-	if (ub->qlen > 1)
-		ub->lastnlh->nlmsg_flags |= NLM_F_MULTI;
-
-	ub->lastnlh = nlh;
-
-	if (ub->qlen >= uloginfo->qthreshold)
-		ulog_send(group);
-	else if (!timer_pending(&ub->timer)) {
-		ub->timer.expires = jiffies + flushtimeout * HZ / 100;
-		add_timer(&ub->timer);
-	}
-
-unlock:
-	spin_unlock_bh(lock);
-
-	return;
-
-nlmsg_failure:
-	printk(KERN_CRIT "ebt_ulog: error during NLMSG_PUT. This should "
-	       "not happen, please report to author.\n");
-	goto unlock;
-alloc_failure:
-	goto unlock;
-}
-
-static int ebt_ulog_check(const char *tablename, unsigned int hookmask,
-   const struct ebt_entry *e, void *data, unsigned int datalen)
-{
-	struct ebt_ulog_info *uloginfo = (struct ebt_ulog_info *)data;
-
-	if (datalen != EBT_ALIGN(sizeof(struct ebt_ulog_info)) ||
-	    uloginfo->nlgroup > 31)
-		return -EINVAL;
-
-	uloginfo->prefix[EBT_ULOG_PREFIX_LEN - 1] = '\0';
-
-	if (uloginfo->qthreshold > EBT_ULOG_MAX_QLEN)
-		uloginfo->qthreshold = EBT_ULOG_MAX_QLEN;
-
-	return 0;
-}
-
-static struct ebt_watcher ulog = {
-	.name		= EBT_ULOG_WATCHER,
-	.watcher	= ebt_ulog,
-	.check		= ebt_ulog_check,
-	.me		= THIS_MODULE,
-};
-
-static int __init init(void)
-{
-	int i, ret = 0;
-
-	if (nlbufsiz >= 128*1024) {
-		printk(KERN_NOTICE "ebt_ulog: Netlink buffer has to be <= 128kB,"
-		       " please try a smaller nlbufsiz parameter.\n");
-		return -EINVAL;
-	}
-
-	/* initialize ulog_buffers */
-	for (i = 0; i < EBT_ULOG_MAXNLGROUPS; i++) {
-		init_timer(&ulog_buffers[i].timer);
-		ulog_buffers[i].timer.function = ulog_timer;
-		ulog_buffers[i].timer.data = i;
-		spin_lock_init(&ulog_buffers[i].lock);
-	}
-
-	ebtulognl = netlink_kernel_create(NETLINK_NFLOG, NULL);
-	if (!ebtulognl)
-		ret = -ENOMEM;
-	else if ((ret = ebt_register_watcher(&ulog)))
-		sock_release(ebtulognl->sk_socket);
-
-	return ret;
-}
-
-static void __exit fini(void)
-{
-	ebt_ulog_buff_t *ub;
-	int i;
-
-	ebt_unregister_watcher(&ulog);
-	for (i = 0; i < EBT_ULOG_MAXNLGROUPS; i++) {
-		ub = &ulog_buffers[i];
-		if (timer_pending(&ub->timer))
-			del_timer(&ub->timer);
-		spin_lock_bh(&ub->lock);
-		if (ub->skb) {
-			kfree_skb(ub->skb);
-			ub->skb = NULL;
-		}
-		spin_unlock_bh(&ub->lock);
-	}
-	sock_release(ebtulognl->sk_socket);
-}
-
-module_init(init);
-module_exit(fini);
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Bart De Schuymer <bdschuym@pandora.be>");
-MODULE_DESCRIPTION("ebtables userspace logging module for bridged Ethernet"
-                   " frames");

--------------030803030109090104030604--
