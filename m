From: Ola Nordstrom <ola@triblock.com>
Subject: icmp hdr incorrect in skbuff
Date: Mon, 11 Nov 2002 02:41:48 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021111074147.GA29344@fork.triblock.com>
Reply-To: ola@triblock.com
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="/9DWx/yDrRhgMJTb"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I've been trying to write a module to manipulate icmp packets using
the netfilter hooks but the skbuff headers seem to be improperly set
in the skbuff that I am getting via the nf_hook.

often (*skb)->h.icmph->type points to some other place inside the
skbuff, so checking weather (*skb)->h.icmph->type == ICMP_ECHO doesn't
work. However manually offsetting directly to where type field is
inside the icmp portion of the buffer always yeilds the correct value
(this offcourse is also verified since the ping cames back)

I've attached a snipplet which will illustrate the problem, loading
the module on a workstation and simply doing a ping -c 3 othermachine
gives:

Nov 11 02:32:38 [kernel] icmp_error: pr:  ICMP_ECHOREPLY manual icmp
type offset gives: 8
Nov 11 02:33:45 [kernel] icmp_error: pr: manual icmp type offset
gives: 8 
Nov 11 02:33:48 [kernel] icmp_error: pr: manual icmp type offset
gives: 8

The first log is obviously wrong since the echo reply will never pass
thru the post routing hook. The 2nd too just show that the icmp hdr is
wrong since "ICMP_ECHO" is not printed when infact the icmp type is 8.

Why is the icmphdr not properly set inside the skbuff ? If anyone
could veryify this behavior (bug?) please let me know. Or is my
knowledge of how skbuffs should work flawed ?

I am running 2.4.19.

Thanks,
Ola

--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="icmp_error.c"

/*
 * icmp_error.c
 *
 * cc -D__KERNEL__ -DMODULE -DCONFIG_NETFILTER * -I/usr/src/linux/include -O -Wall -g -D__SMP__ -DSMP -c * icmp_error.c -o icmp_error.o
 */

#include <linux/config.h>
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/errno.h>
#include <asm/uaccess.h> /* copy_from_user() */
#include <net/checksum.h> 
#include <asm/checksum.h>  /* ip_compute_csum() */
#include <linux/net.h>
#include <linux/ip.h>
#include <linux/in.h>
#include <linux/netfilter.h>
#include <linux/netfilter_ipv4.h>
#include <linux/skbuff.h>
#include <linux/types.h>
#include <linux/string.h>
#include <linux/locks.h>
#include <linux/icmp.h>

#define	MODULE_NAME "icmp_error"
#define	MODULE_VERSION "0.1"

/* print line of info */
#define linfo(fmt, args...)	printk(KERN_INFO MODULE_NAME ": " fmt "\n", ## args)
/* print info msgs */
#define binfo(fmt, args...)	printk(KERN_INFO MODULE_NAME ": " fmt, ## args)
/* print info msg */
#define info(fmt, args...)	printk(fmt, ## args)

/*
 * this function is called when packets enter the postrouting 
 * (packets about to hit wire)
 */
static unsigned int hook_post_routing(unsigned int hook,
           			struct sk_buff **skb,
           			const struct net_device *indev,
           			const struct net_device *outdev,
           			int (*okfn)(struct sk_buff *))
{
	struct iphdr *iph = (*skb)->nh.iph;
	unsigned char *type;

	MOD_INC_USE_COUNT;

	/*
	 * check for ICMP packets, ignore all others
	 */
	if (iph->protocol != IPPROTO_ICMP) 
		goto out;


        binfo("pr: ");

        if ((*skb)->h.icmph->type == ICMP_ECHO) {
		info("ICMP_ECHO ");	
	} else if ((*skb)->h.icmph->type == ICMP_ECHOREPLY) {
		info("ICMP_ECHOREPLY ");	
	} else {
                /* goto out; */
		;
	}

	type = (*skb)->nh.raw;
	type += 20; /* assume iphdr is 20 bytes, no options */

	info("manual icmp type offset gives: %u ", *type);

out:
	info("\n");
	MOD_DEC_USE_COUNT;

	return NF_ACCEPT;
}

/*
 * the hook operations structure
 * fed to netfilter during initialization
 */
static struct nf_hook_ops icmp_mon_post_routing_ops
= { { NULL, NULL }, hook_post_routing, PF_INET, NF_IP_POST_ROUTING, 0 };
/* = { { NULL, NULL }, hook_post_routing, PF_INET, NF_IP_LOCAL_OUT, 0 }; */
/* = { { NULL, NULL }, hook_post_routing, PF_INET, NF_IP_LOCAL_IN, 0 }; */

static int __init init(void)
{
	/*
	 * create and register the post routing hook
	 */
	if (nf_register_hook(&icmp_mon_post_routing_ops) != 0) {
		linfo("unable to register post routing hooks");
		return -ENOMEM;
	}
	
	linfo("%s version %s loaded", MODULE_NAME, MODULE_VERSION);
	return 0;
}

static void __exit fini(void)
{
	/*
	 * remove the netfilter hooks
	 */
	nf_unregister_hook(&icmp_mon_post_routing_ops);
	linfo("%s version %s unloaded", MODULE_NAME, MODULE_VERSION);
}

module_init(init);
module_exit(fini);

MODULE_AUTHOR("Ola Nordstrom <ola@triblock.com>");
MODULE_DESCRIPTION("FOO");
MODULE_LICENSE("GPL");

EXPORT_NO_SYMBOLS;

--/9DWx/yDrRhgMJTb--
