From: Alexander Larsson <alexl@redhat.com>
Subject: Re: [PATCH] netbios broadcast connection tracking module
Date: Tue, 26 Oct 2004 11:25:57 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <1098782757.6562.310.camel@greebo.homeip.net>
References: <1098175785.6562.60.camel@greebo.homeip.net>
	<1098206621.1108.105.camel@tux.rsn.bth.se>
	<1098214482.6562.125.camel@greebo.homeip.net>
	<20041022105504.GC3551@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Martin Josefsson <gandalf@wlug.westbo.se>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20041022105504.GC3551@sunbeam.de.gnumonks.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, 2004-10-22 at 12:55 +0200, Harald Welte wrote:
> Hi!
> 
> First of all, let me say that I am much in favour of a conntrack helper
> than an ipt_recent-based solution.
> 
> > Hmm. I though by setting max_expected to 0 would allow me to get
> > multiple expected replies, but i could easily have misread the code. Is
> > there no way to expect multiple packets in reply to a single udp
> > package?
> 
> you just need to re-issue the expectation as soon as it is confirmed by
> the first packet (from the expectfn).  If I'm not mistaken, there are
> already helpers doing that, although I forgot which ones.

I've been experimenting a bit here. And it seems that it *does* accept
several packages after calling ip_conntrack_expect_related(), before the
timeout is passed (although expectfn is only called once). At least if
the packages are from the same ip.

I took a look at ip_conntrack_ftp.c, and it only calls
ip_conntrack_expect_related() from "help". Does this mean it only
accepts one related packet on the side-channel?. Actually, none of the
in-tree conntrack helpers use expectfn.

Anyway, while testing I digged a bit deeper into the netbios traffic
going on here, and it seems like we really only expect one reply anyway.
The broadcast request is basically "who has the name <foo>" or "who is
the local master browser".

Thus, something like this should work fine:

------------------------------------------------------

#include <linux/module.h>
#include <linux/ip.h>
#include <linux/udp.h>
#include <linux/delay.h>

#include <linux/netfilter.h>
#include <linux/netfilter_ipv4/ip_tables.h>
#include <linux/netfilter_ipv4/ip_conntrack_helper.h>

MODULE_AUTHOR("Alexander Larsson <alexl@redhat.com>");
MODULE_DESCRIPTION("netbios ns conntrack helper");
MODULE_LICENSE("GPL");

#define NETBIOS_NS_PORT 137
#define NETBIOS_NS_REPLY_TIMEOUT 10

#if 0
#define DEBUGP(format, args...) printk(KERN_DEBUG "%s:" format, \
                                       __FUNCTION__ , ## args)
#else
#define DEBUGP(format, args...)
#endif

static int netbios_ns_help(struct sk_buff *skb,
			   struct ip_conntrack *ct,
			   enum ip_conntrack_info ctinfo)
{
	struct ip_conntrack_expect *exp;
	
	exp = ip_conntrack_expect_alloc();
	if (exp == NULL)
		return NF_ACCEPT;

	exp->tuple = ct->tuplehash[IP_CT_DIR_REPLY].tuple;
	exp->mask.src.ip = 0;
	exp->mask.dst.ip = 0xffffffff;
	exp->mask.dst.u.udp.port = 0xffff;
	exp->mask.dst.protonum = 0xffff;
	exp->expectfn = NULL;
	
	ip_conntrack_expect_related(exp, ct);
	
	return NF_ACCEPT;
}

static struct ip_conntrack_helper netbios_ns;

static int __init init(void)
{
	memset(&netbios_ns, 0, sizeof(struct ip_conntrack_helper));

	netbios_ns.name = "netbios-ns";
	netbios_ns.max_expected = 0; /* No maximum */
	netbios_ns.timeout = NETBIOS_NS_REPLY_TIMEOUT;
	netbios_ns.flags = 0;
	netbios_ns.me = THIS_MODULE;
	netbios_ns.help = netbios_ns_help;
	
	netbios_ns.tuple.dst.protonum = IPPROTO_UDP;
	netbios_ns.mask.dst.protonum = 0xFFFF;
	netbios_ns.tuple.src.u.udp.port = htons(NETBIOS_NS_PORT);
	netbios_ns.mask.src.u.udp.port = 0xFFFF;
	
	return ip_conntrack_helper_register(&netbios_ns);
}

static void fini(void)
{
	ip_conntrack_helper_unregister(&netbios_ns);
}

PROVIDES_CONNTRACK(netbios_ns);

module_init(init);
module_exit(fini);


=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
 Alexander Larsson                                            Red Hat, Inc 
                   alexl@redhat.com    alla@lysator.liu.se 
He's a scarfaced pirate farmboy from the Mississippi delta. She's a 
cosmopolitan renegade former first lady from aristocratic European stock. They 
fight crime! 
