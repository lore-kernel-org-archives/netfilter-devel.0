From: "Srinivas G." <srinivasg@esntechnologies.co.in>
Subject: How can I get these packets in the user space application?
Date: Wed, 8 Dec 2004 19:31:18 +0530
Message-ID: <4EE0CBA31942E547B99B3D4BFAB348112588BA@mail.esn.co.in>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: "Mukund JB." <mukundjb@esntechnologies.co.in>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
To: <netfilter-devel@lists.netfilter.org>
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

Dear all,

I have developed a very simple/small net filter driver to capture the
network packets from my network path. It was working fine. Whenever a
packet goes through my network path it was simply prints a message. It
was printing the messages fine.

The kernel version is 2.4.18-3 with Red Hat 7.3

My question is: How can I get these packets in the user space
application?
What APIs can I use? Is there any specific APIs are available? If
possible give some links or sample code which explains about it.

Please see the code attached below.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

#include <linux/module.h>		/* for module parameters */
#include <linux/kernel.h>		/* for printk function */
#include <linux/init.h>			/* for module explicit
definitions */
#include <linux/netfilter.h>		/* for netfilter structure */
#include <linux/netfilter_ipv4.h>	/* for IPv4 specific defines */
#include <linux/vmalloc.h>		/* for vmalloc function */

#ifdef NETFILTER_DBG
#define PRINTK(fmt,arg...) printk("NET_DBG <%s> | "
fmt,__FUNCTION__,##arg); #else #define PRINTK(fmt,arg...) while(0)
#endif

/* define the maximum packet buffer */
#define MAX_PACK_BUFF   2048

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Srinivas G at ESN Technologies");

/* define netfilter structure here */
static struct nf_hook_ops netfilter_hook;

/* pointer to a buffer */
unsigned char *ptr_packet_buff;

/* function prototype which is called when a packet arrives */ unsigned
int netfilter_drv_hook(unsigned int hooknum,=20
				struct sk_buff **skb,
		      		const struct net_device *in,=20
				const struct net_device *out,
		      		int (*okfn)(struct sk_buff *))
{
	PRINTK("One Packet arrvied!\n");

	/* alocate the packet buffer */
	ptr_packet_buff =3D (unsigned char *)vmalloc(MAX_PACK_BUFF);
=09
	/* the received packet was dropped here itself */
	return NF_DROP;
}
=09
=09

/* netfilter_init: initialization function */
static int
__init init_netfilter(void)
{
	PRINTK("invoked!\n");
=09
	/* assign the function pointer */
	netfilter_hook.hook =3D netfilter_drv_hook;

	/* assign the protocol family i.e. IPv4 */
	netfilter_hook.pf =3D PF_INET;

	/* assign the hook number like NF_IP_LOCAL_IN etc. */
	netfilter_hook.hooknum =3D NF_IP_PRE_ROUTING;

	/* assign the hook priority */
	netfilter_hook.priority =3D NF_IP_PRI_FIRST;

	/* register the netfilter driver with pointer to structure */
	nf_register_hook(&netfilter_hook);

	return 0;
}

/* netfilter_exit: cleanup function */
static void
__exit netfilter_exit(void)
{
	PRINTK("invoked!\n");

	/* unregister the driver */
	nf_unregister_hook(&netfilter_hook);
=09
}

/* explicit module definitions */
module_init(init_netfilter);
module_exit(netfilter_exit);

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=3D=3D=3D=3D

Any help greatly appreciated.

Thanks and regards,
Srinivas G
