From: tuXit <tuxit@netcourrier.com>
Subject: Re: New standalone nat helper module which help function is never
 called
Date: Tue, 18 Nov 2003 00:58:46 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031118005846.06befa0d.tuxit@netcourrier.com>
References: <20031117174829.711e2e82.tuxit@netcourrier.com>
	<20031117223129.GF5075@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20031117223129.GF5075@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 17 Nov 2003 23:31:30 +0100
Harald Welte <laforge@netfilter.org> wrote:

> On Mon, Nov 17, 2003 at 05:48:29PM +0100, tuXit wrote:
> 
> > In the end, I insmod my module (which is marked as unused), and the logs
> > show that it is properly registered. I said in iptables to accept the
> > packets from/toward the NNTP port (119), and I also said to masquerade
> > from one network to the other. When trying to contact the NNTP server on
> > the other network from a client machine in the first network and using the
> > machine on which I inserted the module as gate, the help function of my
> > module is never called. There must be something I forgot, or I wrongly
> > understood, but after having read several times the kernel hacking guide
> > and searched inside this mailing-list archive, I can't find any reason.
> > 
> > I somebody has an idea about it, I would be glad to know it :)
> 
> if you could send us the current code, it woulde be easier to figure out
> what's going on.

Of course...

----------8<----------8<----------8<----------

/* ASCII extension for TCP NAT alteration. */
#include <linux/module.h>
#include <linux/netfilter_ipv4.h>
#include <linux/ip.h>
#include <linux/tcp.h>
#include <net/tcp.h>
#include <linux/netfilter_ipv4/ip_nat.h>
#include <linux/netfilter_ipv4/ip_nat_helper.h>
#include <linux/netfilter_ipv4/ip_nat_rule.h>
/* #include <linux/netfilter_ipv4/ip_conntrack_ascii.h>*/

#if 1
#define DEBUGP printk
#else
#define DEBUGP(format, args...)
#endif

/* Modified by <tuxit@netcourrier.com> at Sun Nov 16 23:38:44 2003 */
/* Used to declare the port on which to listen  */
/* Later on, it will be an argument of the module */

#define ASCII_PORT 119
static int port;
DECLARE_LOCK(ip_ascii_lock);

static void mangle_ascii_packet(struct sk_buff **pskb,
				enum ip_conntrack_info ctinfo){
  
}

static unsigned int help(struct ip_conntrack *ct,
			 struct ip_conntrack_expect *exp,
			 struct ip_nat_info *info,
			 enum ip_conntrack_info ctinfo,
			 unsigned int hooknum,
			 struct sk_buff **pskb)
{
	struct iphdr *iph = (*pskb)->nh.iph;
	struct tcphdr *tcph = (void *)iph + iph->ihl*4;
	unsigned int datalen;
	int dir;

	DEBUGP("nat_ascii: ctinfo value is %i\n",
	       ctinfo);
	return NF_ACCEPT;
}

static struct ip_nat_helper ascii;

/* Not __exit: called from init() */
static void fini(void)
{
	DEBUGP("ip_nat_ascii: unregistering port %d\n", port);
	ip_nat_helper_unregister(&ascii);
}

static int __init init(void)
{
	int ret = 0;
	char *tmpname;
	char ascii_names[10];

	port = ASCII_PORT;

	ascii.list.next = 0;
	ascii.list.prev = 0;
	tmpname = &ascii_names[0];
	sprintf(tmpname, "ascii");
	ascii.name = tmpname;	
	ascii.flags = IP_NAT_HELPER_F_STANDALONE;
	ascii.me = THIS_MODULE;
	ascii.tuple.src.ip = 0;
	ascii.tuple.src.u.tcp.port = 0;
	ascii.tuple.dst.ip = 0;
	ascii.tuple.dst.u.tcp.port = __constant_htons(port);
	ascii.tuple.dst.protonum = IPPROTO_TCP;
	ascii.mask.src.ip = 0;
	ascii.mask.src.u.tcp.port = 0xFFFF;
	ascii.mask.dst.ip = 0;
	ascii.mask.dst.u.tcp.port = 0;
	ascii.mask.dst.protonum = 0xFFFF;
	ascii.help = help;
	ascii.expect = NULL;	
	
	DEBUGP("ip_nat_ascii: Trying to register for port %d\n",
	       port);
	ret = ip_nat_helper_register(&ascii);
	
	if (ret) {
	  printk("ip_nat_ascii: error registering "
		 "helper for port %d\n", port);
	  fini();
	  return ret;
	}
	return ret;
}

EXPORT_SYMBOL(ip_ascii_lock);

module_init(init);
module_exit(fini);
MODULE_LICENSE("GPL");

----------8<----------8<----------8<----------

I have put everything I could related to netfilter as a kernel module, in
order to avoid rebooting after each change.
The this is that my module is successfully registered, but whenever a natted
packet comes, my nat helper function is never called (for the moment, it does
nothing but printing a debug message...

After some debugging, I see that the function do_bindings from ip_nat_core.c
is called each time a natted packet comes, but the field info->helper is NULL
instead of owning the helper function address.

Thanks in advance.

-- 
Florian Pouradier
echo '|^H_!Xn|^H_' | less 
EpX Member - Debian GNU/Linux user
GPG FP: B0D7 1F53 94DA 0BCA C11E  F417 094B 49F3 D5DD F5EC 
