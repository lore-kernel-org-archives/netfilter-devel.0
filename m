From: Alexander Larsson <alexl@redhat.com>
Subject: netbios broadcast connection tracking module
Date: Wed, 29 Sep 2004 15:39:46 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <1096465186.18592.378.camel@greebo.homeip.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-Wy3XIVTFr7efQj6XRyQn"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--=-Wy3XIVTFr7efQj6XRyQn
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

[Sorry if this posting appears twice, for some reason the mailing list
didn't accept me as a subscriber the first time, so i had to subscribe
again.]

I'd like to make the default Fedora firewall allow SMB browsing, per bug
reports like:
http://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=113918
http://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=133478

What happens here is that the smb browser client sends a local udp
broadcast to port 137, and then local servers reply to this from port
137 to the port the broadcast was sent to. However, since these replies
come from another address than the broadcast was sent to, the udp
conntrack module doesn't help here.

So, I've written a small conntrack helper that makes replies to such a
broadcast package be reported as a RELATED connection. This means the
default firewall will allow them through.

The code is attached. This is my first ever look at the netfilter code,
so please look for stupid mistakes. Also, is there any other possible
solution to this problem that I've missed? I tried using the "recent"
module, but that doesn't save/match against the port, so i couldn't use
that.

Maybe the module should also verify that the replies are from the local
subnet? I'm not sure how to get the mask of the subnet the package will
be sent to though, because skbuff->dev is NULL when my helper gets
called.
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
 Alexander Larsson                                            Red Hat, Inc 
                   alexl@redhat.com    alla@lysator.liu.se 
He's an underprivileged vegetarian farmboy looking for a cure to the poison 
coursing through his veins. She's a radical hip-hop soap star who hides her 
beauty behind a pair of thick-framed spectacles. They fight crime! 

--=-Wy3XIVTFr7efQj6XRyQn
Content-Disposition: attachment; filename=ip_conntrack_netbios_ns.c
Content-Type: text/x-csrc; name=ip_conntrack_netbios_ns.c; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

#include <linux/module.h>
#include <linux/ip.h>
#include <linux/udp.h>

#include <linux/netfilter.h>
#include <linux/netfilter_ipv4/ip_tables.h>
#include <linux/netfilter_ipv4/ip_conntrack_helper.h>

MODULE_AUTHOR("Alexander Larsson <alexl@redhat.com>");
MODULE_DESCRIPTION("netbios ns conntrack helper");
MODULE_LICENSE("GPL");

#define NETBIOS_NS_PORT 137
#define NETBIOS_NS_REPLY_TIMEOUT 20

#if 0
#define DEBUGP(format, args...) printk(KERN_ERR "%s:" format, \
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
	netbios_ns.flags = IP_CT_HELPER_F_REUSE_EXPECT;
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

--=-Wy3XIVTFr7efQj6XRyQn--
