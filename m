From: "Ferry Huberts" <ferry@Hupie.com>
Subject: [PATCH] Change masquerade code to use first IP address of
Date: Wed, 20 Oct 2004 08:06:03 +0200 (CEST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <53512.217.169.232.210.1098252363.squirrel@217.169.232.210>
References: <4175FCF2.E494D.3F15@iris2.directnic.com>
Reply-To: ferry@Hupie.com
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4175FCF2.E494D.3F15@iris2.directnic.com>
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

In netfilter-devel Digest, Vol 3, Issue 20

In response to Rusty's message
Subject: [PATCH] Change masquerade code to use first IP address of
        interface.

I scream :-)

I have an application that has multiple DHCP assigned addresses on an
interface and I would like to tell netfilter to which interface
address/name (eth0:0 or eth0 or eth0:1) it should MASQ.

Is it possible to implement this as an option to the MASQ module?

--
Ferry Huberts

--
Name: Change MASQUERADE to Use Device Address Directly
Status: Untested
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au> (created)

Instead of doing a dubious route lookup, just use the first IP address
of the (dynamic) interface.  Also, reset assured bit so after a device
goes down, masq connections can be cleaned up if memory pressure.

As discussed previously, let's try this in 2.6.10, and see who screams.

Cheers,
Rusty.
---



> Send netfilter-devel mailing list submissions to
> 	netfilter-devel@lists.netfilter.org
>
> To subscribe or unsubscribe via the World Wide Web, visit
> 	https://lists.netfilter.org/mailman/listinfo/netfilter-devel
> or, via email, send a message with subject or body 'help' to
> 	netfilter-devel-request@lists.netfilter.org
>
> You can reach the person managing the list at
> 	netfilter-devel-owner@lists.netfilter.org
>
> When replying, please edit your Subject line so it is more specific
> than "Re: Contents of netfilter-devel digest..."
>
>
> Today's Topics:
>
>    1. Re: Building on case-insensitive filesystems (Dan Kegel)
>    2. Re: [netfilter-core] Possible bug in MASQ under 2.6?
>       (Patrick McHardy)
>    3. [PATCH] netbios broadcast connection tracking module
>       (Alexander Larsson)
>    4. Re: [PATCH] netbios broadcast connection tracking module
>       (Alexander Larsson)
>    5. Re: [PATCH] netbios broadcast connection tracking module
>       (Martin Josefsson)
>    6. [PATCH] Change masquerade code to use first IP address of
>       interface. (Rusty Russell)
>    7. ip_conntrack_proto_gre problems? (Oleg A. Arkhanglelsky)
>
>
> ----------------------------------------------------------------------
>
> Message: 1
> Date: Mon, 18 Oct 2004 08:28:36 -0700
> From: Dan Kegel <dank@kegel.com>
> Subject: Re: Building on case-insensitive filesystems
> To: Harald Welte <laforge@netfilter.org>
> Cc: netfilter-devel@lists.netfilter.org
> Message-ID: <4173E124.5040805@kegel.com>
> Content-Type: text/plain; charset=us-ascii; format=flowed
>
> Harald Welte wrote:
>>>Seems like ipt_mark_target.h might be a better name for
>>>that latter file.  That would let developers who have
>>>MacOSX or Windows laptops successfully unpack the
>>>Linux source tree on their computers' case-insensitive filesystems.
>>
>>
>> This has been discussed on the list before, the general result was IIRC
>> that we don't really care, sorry.
>
> Ah, well, crossdevelopers are used to encountering
> indifference now and then from mainstream developers, so that's
> not terribly surprising.
>
>> Next time somebody comes along and says well, your more-than-8.3chars
>> long filenames won't work on my DOS system.
>
> Let's see if we can distinguish between the two problems.  I know,
> how 'bout this: it's reasonable to be expected to support
> developer workstation filesystems which have a greater than 20% market
> share.
> By that measure, it's reasonable to expect support for developing on
> case-insensitive filesystems, but not on 8.3 char filesystems.
> Hey, I did it!  (cue confetti)
>
>> iptables fundamentally relies on the destinction:
>>
>> lowercase == match module
>> uppercase == target module
>>
>> You can't just fix this by renaming kernel source files.
>>
>> If I read your patch correctly, the resulting modules will have
>> different names.  This will break auto-loading of match and target
>> extensions, and it will break userspace compatibility with the userspace
>> iptables program.
>>
>> Also, the userspace iptables program has the same assumption, so without
>> changing the whole chain
>> 	- kernel file names
>> 	- module autoloading
>> 	- userspace filenames
>> 	- userspace plugin autoloading
>> it will not work.
>>
>> Also, imagine what happens if someone tries to run an old userspace
>> program and a new kernel or vice versa.  If we ever adopt a renaming
>> scheme, it would have to work both forward and backwards compatible, we
>> can't just change this within a stable kernel series.
>
> Thanks for the summary of the technical issues.
> I'm sure somebody sufficiently motivated could solve them
> in a reasonable way.  I'll leave this for later -- I'm only
> verifying gcc/glibc builds, so I don't need it -- but maybe
> somebody else will come up with the right fix.
>
>>>This is part of a larger effort to make life easier for
>>>embedded Linux developers who are stuck developing on Windows
>>>or Mac systems; see discussion at
>>
>> You should actually start an opposite effort:  Make it harder for them,
>> so it is enough pain to switch to a linux development system.  Please
>> note, this is my personal opinion - not to be conflicted with the
>> technical reasons given above.
>
> Your helpful attitude is greatly appreciated.
> - Dan
>
> --
> Trying to get a job as a c++ developer?  See
> http://kegel.com/academy/getting-hired.html
>
>
>
>
> ------------------------------
>
> Message: 2
> Date: Tue, 19 Oct 2004 01:37:42 +0200
> From: Patrick McHardy <kaber@trash.net>
> Subject: Re: [netfilter-core] Possible bug in MASQ under 2.6?
> To: Travis Morgan <travis@bigfiber.net>
> Cc: coreteam@netfilter.org,	Netfilter Development Mailinglist
> 	<netfilter-devel@lists.netfilter.org>
> Message-ID: <417453C6.9030903@trash.net>
> Content-Type: text/plain; charset=us-ascii; format=flowed
>
> Travis Morgan wrote:
>
>>I think I've found what might be called a bug with MASQ under 2.6 but I
>>want a second opinion. We have a Linux router box here and two home
>>internet connections. We were using multipath to balance between the two
>>connecions under 2.4 (2.4.26-gentoo-r2, has grsec and bunch of other
>>stuff)
>>
> The proper place for bugs is netfilter-devel.
>
>>
>>default  proto static
>>      nexthop via 142.179.128.1  dev eth0 weight 2
>>      nexthop via 68.148.196.1  dev eth1 weight 1
>>
>>For iptables POSTROUTING we had two MASQ rules, one with -o eth0 and one
>>with -o eth1.
>>
>>Under 2.4 that worked beautifully. We decided to upgrade to 2.6 and had
>>a slew of problems. I finally tracked it down to this dmesg:
>>
>>printk: 12 messages suppressed.
>>MASQUERADE: Route sent us somewhere else.
>>printk: 17 messages suppressed.
>>MASQUERADE: Route sent us somewhere else.
>>
>
> You currently can't use MASQUERADE with multipath routes. The
> MASQUERADE routing lookup to get the source adress must return
> the same output device the packet is already heading for. With
> multipath routes pointing to two different devices this oviously
> isn't guaranteed.
>
> Look for Rusty's patch "[PATCH] Fix MASQUERADE" in the netfilter-devel
> archives, it should fix your problem.
>
> Regards
> Patrick
>
>
>
> ------------------------------
>
> Message: 3
> Date: Tue, 19 Oct 2004 10:49:45 +0200
> From: Alexander Larsson <alexl@redhat.com>
> Subject: [PATCH] netbios broadcast connection tracking module
> To: netfilter-devel@lists.netfilter.org
> Message-ID: <1098175785.6562.60.camel@greebo.homeip.net>
> Content-Type: text/plain
>
> I'm re-sending this, in the hope that someone will be interested enough
> to at least comment on the code/approach this time.
>
> I'd like to make the default Fedora firewall allow packets related to
> SMB browsing to be accepted, so that clients such as Nautilus and
> konqueror (and smbclient) can enumerate the availble SMB shares.
>
> What happens here is that the smb browser client sends a local udp
> broadcast to port 137, and then local servers reply to this from port
> 137 to the port the broadcast was sent to. However, since these replies
> come from another address than the broadcast was sent to, the udp
> conntrack module doesn't help here.
>
> So, I've written a small conntrack helper that makes replies to such a
> broadcast package be reported as a RELATED connection. This means the
> default firewall will allow them through.
>
> The module code is below. This is my first ever look at the netfilter
> code,
> so please look for stupid mistakes. Also, is there any other possible
> solution to this problem that I've missed? I tried using the "recent"
> module, but that doesn't save/match against the port, so i couldn't use
> that.
>
> Maybe the module should also verify that the replies are from the local
> subnet? I'm not sure how to get the mask of the subnet the package will
> be sent to though, because skbuff->dev is NULL when my helper gets
> called.
>
> ----------- ip_conntrack_netbios_ns.c ---------------
>
> #include <linux/module.h>
> #include <linux/ip.h>
> #include <linux/udp.h>
>
> #include <linux/netfilter.h>
> #include <linux/netfilter_ipv4/ip_tables.h>
> #include <linux/netfilter_ipv4/ip_conntrack_helper.h>
>
> MODULE_AUTHOR("Alexander Larsson <alexl@redhat.com>");
> MODULE_DESCRIPTION("netbios ns conntrack helper");
> MODULE_LICENSE("GPL");
>
> #define NETBIOS_NS_PORT 137
> #define NETBIOS_NS_REPLY_TIMEOUT 20
>
> #if 0
> #define DEBUGP(format, args...) printk(KERN_ERR "%s:" format, \
>                                        __FUNCTION__ , ## args)
> #else
> #define DEBUGP(format, args...)
> #endif
>
> static int netbios_ns_help(struct sk_buff *skb,
> 			   struct ip_conntrack *ct,
> 			   enum ip_conntrack_info ctinfo)
> {
> 	struct ip_conntrack_expect *exp;
>
> 	exp = ip_conntrack_expect_alloc();
> 	if (exp == NULL)
> 		return NF_ACCEPT;
>
> 	exp->tuple = ct->tuplehash[IP_CT_DIR_REPLY].tuple;
> 	exp->mask.src.ip = 0;
> 	exp->mask.dst.ip = 0xffffffff;
> 	exp->mask.dst.u.udp.port = 0xffff;
> 	exp->mask.dst.protonum = 0xffff;
> 	exp->expectfn = NULL;
>
> 	ip_conntrack_expect_related(exp, ct);
>
> 	return NF_ACCEPT;
> }
>
> static struct ip_conntrack_helper netbios_ns;
>
> static int __init init(void)
> {
> 	memset(&netbios_ns, 0, sizeof(struct ip_conntrack_helper));
>
> 	netbios_ns.name = "netbios-ns";
> 	netbios_ns.max_expected = 0; /* No maximum */
> 	netbios_ns.timeout = NETBIOS_NS_REPLY_TIMEOUT;
> 	netbios_ns.flags = IP_CT_HELPER_F_REUSE_EXPECT;
> 	netbios_ns.me = THIS_MODULE;
> 	netbios_ns.help = netbios_ns_help;
>
> 	netbios_ns.tuple.dst.protonum = IPPROTO_UDP;
> 	netbios_ns.mask.dst.protonum = 0xFFFF;
> 	netbios_ns.tuple.src.u.udp.port = htons(NETBIOS_NS_PORT);
> 	netbios_ns.mask.src.u.udp.port = 0xFFFF;
>
> 	return ip_conntrack_helper_register(&netbios_ns);
> }
>
> static void fini(void)
> {
> 	ip_conntrack_helper_unregister(&netbios_ns);
> }
>
> PROVIDES_CONNTRACK(netbios_ns);
>
> module_init(init);
> module_exit(fini);
>
>
> =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
>  Alexander Larsson                                            Red Hat, Inc
>                    alexl@redhat.com    alla@lysator.liu.se
> He's a gun-slinging ninja sorceror from the 'hood. She's a provocative
> wisecracking politician who hides her beauty behind a pair of thick-framed
> spectacles. They fight crime!
>
>
>
>
> ------------------------------
>
> Message: 4
> Date: Tue, 19 Oct 2004 21:34:42 +0200
> From: Alexander Larsson <alexl@redhat.com>
> Subject: Re: [PATCH] netbios broadcast connection tracking module
> To: Martin Josefsson <gandalf@wlug.westbo.se>
> Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
> Message-ID: <1098214482.6562.125.camel@greebo.homeip.net>
> Content-Type: text/plain
>
> On Tue, 2004-10-19 at 19:23 +0200, Martin Josefsson wrote:
>> On Tue, 2004-10-19 at 10:49, Alexander Larsson wrote:
>>
>> Hi Alexander
>>
>> > What happens here is that the smb browser client sends a local udp
>> > broadcast to port 137, and then local servers reply to this from port
>> > 137 to the port the broadcast was sent to. However, since these
>> replies
>> > come from another address than the broadcast was sent to, the udp
>> > conntrack module doesn't help here.
>>
>> So both source and destination port is 137 in the replies?
>> And by looking at your code, it's the same in the broadcast as well.
>> (since the source port of the broadcast is what is used as
>> destinationport in the reply)
>
> No. Let me make an example. The client at 192.168.0.1 sends the
> broadcast from a high port (lets say he gets port 55000):
>
> 192.168.0.1:55000 -> 192.168.0.255:137
>
> The smb server at 192.168.0.2 answers:
> 192.168.0.2:137 -> 192.168.0.1:55000
>
> And then the server at 192.168.0.3:
> 192.168.0.3:137 -> 192.168.0.1:55000
>
>> > So, I've written a small conntrack helper that makes replies to such a
>> > broadcast package be reported as a RELATED connection. This means the
>> > default firewall will allow them through.
>>
>> s/replies/the first reply/
>>
>> The expectation will get removed from the expectation-list when a packet
>> matches the expectation.
>>
>> And it's not possible to register multiple identical expectations since
>> when only thing that happens then is that the timeout of the first
>> expectation is updated.
>
> Hmm. I though by setting max_expected to 0 would allow me to get
> multiple expected replies, but i could easily have misread the code. Is
> there no way to expect multiple packets in reply to a single udp
> package?
>
>> > The module code is below. This is my first ever look at the netfilter
>> code,
>> > so please look for stupid mistakes. Also, is there any other possible
>> > solution to this problem that I've missed? I tried using the "recent"
>> > module, but that doesn't save/match against the port, so i couldn't
>> use
>> > that.
>>
>> I think it should be possible to use recent, maybe something like this?
>>
>> iptables -A OUTPUT -p udp -d $broadcast --sport 137 --dport 137 -m
>> recent --set --rsource --name netbios_ns -j ACCEPT
>> iptables -A INPUT -p udp --sport 137 --dport 137 -m pkttype --pkt-type
>> unicast -m recent --rcheck --rdest --seconds 20 --name netbios_ns -j
>> ACCEPT
>>
>> That should add the sourceaddress of the outgoing broadcast to the
>> recent list called "netbios_ns". Unfortunately we can't use the pkttype
>> match for outgoing packets, that would have been neat for only adding
>> broadcast packets automatically without having to specify the broadcast
>> address.
>>
>> And then destination ip of incoming udp packets from port 137 to port
>> 137 that are unicast packets are checked against the same recent list
>> and if the ipaddresses match we accept the packet.
>> (the pkttype match isn't really needed)
>>
>> Would that work?
>
> No. That doesn't work, because the INPUT rule needs to match the port of
> the packet that was matched in the OUTPUT rule. We can't do this,
> because recent only allows saving the source or destination ip, not the
> port.
>
>> > static int __init init(void)
>> > {
>> > 	memset(&netbios_ns, 0, sizeof(struct ip_conntrack_helper));
>> >
>> > 	netbios_ns.name = "netbios-ns";
>> > 	netbios_ns.max_expected = 0; /* No maximum */
>> > 	netbios_ns.timeout = NETBIOS_NS_REPLY_TIMEOUT;
>> > 	netbios_ns.flags = IP_CT_HELPER_F_REUSE_EXPECT;
>>
>> IP_CT_HELPER_F_REUSE_EXPECT is only used if you have set max_expected to
>> a nonzero value, there's nothing to reuse when there's no maximum.
>
> Ah.
>
> =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
>  Alexander Larsson                                            Red Hat, Inc
>                    alexl@redhat.com    alla@lysator.liu.se
> He's a suicidal amnesiac filmmaker haunted by memories of 'Nam. She's a
> sharp-shooting insomniac cab driver from a different time and place. They
> fight crime!
>
>
>
>
> ------------------------------
>
> Message: 5
> Date: Tue, 19 Oct 2004 19:23:41 +0200
> From: Martin Josefsson <gandalf@wlug.westbo.se>
> Subject: Re: [PATCH] netbios broadcast connection tracking module
> To: Alexander Larsson <alexl@redhat.com>
> Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
> Message-ID: <1098206621.1108.105.camel@tux.rsn.bth.se>
> Content-Type: text/plain; charset="us-ascii"
>
> On Tue, 2004-10-19 at 10:49, Alexander Larsson wrote:
>
> Hi Alexander
>
>> What happens here is that the smb browser client sends a local udp
>> broadcast to port 137, and then local servers reply to this from port
>> 137 to the port the broadcast was sent to. However, since these replies
>> come from another address than the broadcast was sent to, the udp
>> conntrack module doesn't help here.
>
> So both source and destination port is 137 in the replies?
> And by looking at your code, it's the same in the broadcast as well.
> (since the source port of the broadcast is what is used as
> destinationport in the reply)
>
>> So, I've written a small conntrack helper that makes replies to such a
>> broadcast package be reported as a RELATED connection. This means the
>> default firewall will allow them through.
>
> s/replies/the first reply/
>
> The expectation will get removed from the expectation-list when a packet
> matches the expectation.
>
> And it's not possible to register multiple identical expectations since
> when only thing that happens then is that the timeout of the first
> expectation is updated.
>
>> The module code is below. This is my first ever look at the netfilter
>> code,
>> so please look for stupid mistakes. Also, is there any other possible
>> solution to this problem that I've missed? I tried using the "recent"
>> module, but that doesn't save/match against the port, so i couldn't use
>> that.
>
> I think it should be possible to use recent, maybe something like this?
>
> iptables -A OUTPUT -p udp -d $broadcast --sport 137 --dport 137 -m recent
> --set --rsource --name netbios_ns -j ACCEPT
> iptables -A INPUT -p udp --sport 137 --dport 137 -m pkttype --pkt-type
> unicast -m recent --rcheck --rdest --seconds 20 --name netbios_ns -j
> ACCEPT
>
> That should add the sourceaddress of the outgoing broadcast to the
> recent list called "netbios_ns". Unfortunately we can't use the pkttype
> match for outgoing packets, that would have been neat for only adding
> broadcast packets automatically without having to specify the broadcast
> address.
>
> And then destination ip of incoming udp packets from port 137 to port
> 137 that are unicast packets are checked against the same recent list
> and if the ipaddresses match we accept the packet.
> (the pkttype match isn't really needed)
>
> Would that work?
>
> [snip]
>
>> static int __init init(void)
>> {
>> 	memset(&netbios_ns, 0, sizeof(struct ip_conntrack_helper));
>>
>> 	netbios_ns.name = "netbios-ns";
>> 	netbios_ns.max_expected = 0; /* No maximum */
>> 	netbios_ns.timeout = NETBIOS_NS_REPLY_TIMEOUT;
>> 	netbios_ns.flags = IP_CT_HELPER_F_REUSE_EXPECT;
>
> IP_CT_HELPER_F_REUSE_EXPECT is only used if you have set max_expected to
> a nonzero value, there's nothing to reuse when there's no maximum.
>
> --
> /Martin
> -------------- next part --------------
> A non-text attachment was scrubbed...
> Name: not available
> Type: application/pgp-signature
> Size: 189 bytes
> Desc: This is a digitally signed message part
> Url :
> /pipermail/netfilter-devel/attachments/20041019/3d809481/attachment-0001.bin
>
> ------------------------------
>
> Message: 6
> Date: Wed, 20 Oct 2004 12:58:56 +1000
> From: Rusty Russell <rusty@rustcorp.com.au>
> Subject: [PATCH] Change masquerade code to use first IP address of
> 	interface.
> To: "David S. Miller" <davem@davemloft.net>, netdev@oss.sgi.com
> Cc: Netfilter development mailing list
> 	<netfilter-devel@lists.netfilter.org>
> Message-ID: <1098241135.10571.19.camel@localhost.localdomain>
> Content-Type: text/plain
>
> As discussed previously, let's try this in 2.6.10, and see who screams.
>
> Cheers,
> Rusty.
>
> Name: Change MASQUERADE to Use Device Address Directly
> Status: Untested
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au> (created)
>
> Instead of doing a dubious route lookup, just use the first IP address
> of the (dynamic) interface.  Also, reset assured bit so after a device
> goes down, masq connections can be cleaned up if memory pressure.
>
> diff -urpN --exclude TAGS -X
> /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal
> .2156-linux-2.6.9-rc1-bk12/net/ipv4/netfilter/ipt_MASQUERADE.c
> .2156-linux-2.6.9-rc1-bk12.updated/net/ipv4/netfilter/ipt_MASQUERADE.c
> ---
> .2156-linux-2.6.9-rc1-bk12/net/ipv4/netfilter/ipt_MASQUERADE.c	2004-08-25
> 09:54:25.000000000 +1000
> +++
> .2156-linux-2.6.9-rc1-bk12.updated/net/ipv4/netfilter/ipt_MASQUERADE.c	2004-09-08
> 00:15:05.000000000 +1000
> @@ -82,7 +82,6 @@ masquerade_target(struct sk_buff **pskb,
>  	const struct ip_nat_multi_range *mr;
>  	struct ip_nat_multi_range newrange;
>  	u_int32_t newsrc;
> -	struct rtable *rt;
>
>  	IP_NF_ASSERT(hooknum == NF_IP_POST_ROUTING);
>
> @@ -96,36 +95,12 @@ masquerade_target(struct sk_buff **pskb,
>  	                    || ctinfo == IP_CT_RELATED + IP_CT_IS_REPLY));
>
>  	mr = targinfo;
> -
> -	{
> -		struct flowi fl = { .nl_u = { .ip4_u =
> -					      { .daddr = (*pskb)->nh.iph->daddr,
> -						.tos = (RT_TOS((*pskb)->nh.iph->tos) |
> -							RTO_CONN),
> -#ifdef CONFIG_IP_ROUTE_FWMARK
> -						.fwmark = (*pskb)->nfmark
> -#endif
> -					      } } };
> -		if (ip_route_output_key(&rt, &fl) != 0) {
> -			/* Funky routing can do this. */
> -			if (net_ratelimit())
> -				printk("MASQUERADE:"
> -				       " No route: Rusty's brain broke!\n");
> -			return NF_DROP;
> -		}
> -		if (rt->u.dst.dev != out) {
> -			if (net_ratelimit())
> -				printk("MASQUERADE:"
> -				       " Route sent us somewhere else.\n");
> -			ip_rt_put(rt);
> -			return NF_DROP;
> -		}
> +	newsrc = inet_select_addr(out, 0, RT_SCOPE_UNIVERSE);
> +	if (!newsrc) {
> +		printk("MASQUERADE: %s ate my IP address\n", out->name);
> +		return NF_DROP;
>  	}
>
> -	newsrc = rt->rt_src;
> -	DEBUGP("newsrc = %u.%u.%u.%u\n", NIPQUAD(newsrc));
> -	ip_rt_put(rt);
> -
>  	WRITE_LOCK(&masq_lock);
>  	ct->nat.masq_index = out->ifindex;
>  	WRITE_UNLOCK(&masq_lock);
> @@ -157,6 +132,18 @@ device_cmp(const struct ip_conntrack *i,
>  	return ret;
>  }
>
> +static inline int
> +connect_unassure(const struct ip_conntrack *i, void *_ina)
> +{
> +	struct in_ifaddr *ina = _ina;
> +
> +	/* We reset the ASSURED bit on all connections, so they will
> +	 * get reaped under memory pressure. */
> +	if (i->nat.masq_index == ina->ifa_dev->dev->ifindex)
> +		clear_bit(IPS_ASSURED_BIT, (unsigned long *)&i->status);
> +	return 0;
> +}
> +
>  static int masq_inet_event(struct notifier_block *this,
>  			   unsigned long event,
>  			   void *ptr)
> @@ -166,6 +153,8 @@ static int masq_inet_event(struct notifi
>  	 * entries. */
>  	if (event == NETDEV_UP)
>  		ip_ct_selective_cleanup(device_cmp, ptr);
> +	else if (event == NETDEV_DOWN)
> +		ip_ct_selective_cleanup(connect_unassure, ptr);
>
>  	return NOTIFY_DONE;
>  }
>
> --
> Anyone who quotes me in their signature is an idiot -- Rusty Russell
>
>
>
>
> ------------------------------
>
> Message: 7
> Date: Wed, 20 Oct 2004 09:50:10 +0400 (MSD)
> From: "Oleg A. Arkhanglelsky" <sysoleg@yandex.ru>
> Subject: ip_conntrack_proto_gre problems?
> To: netfilter-devel@lists.netfilter.org
> Message-ID: <4175FC92.000017.05763@camay.yandex.ru>
> Content-Type: text/plain;  charset="US-ASCII"
>
> Hello all,
>
> I'm still wondering is it ip_conntrack_proto_gre related problem?
> This PC is used as PPTP-server (up to 80-100 concurrent connections) and
> as NAT-server. There is of course some natted GRE-connections also.
> All connections is from (and to) untrusted users.
>
> Here is a output of ksymoops:
> ksymoops 2.4.9 on i686 2.4.27.  Options used
>      -V (default)
>      -k /proc/ksyms (default)
>      -l /proc/modules (default)
>      -o /lib/modules/2.4.27/ (default)
>      -m /usr/src/linux/System.map (default)
>
> Warning: You did not tell me where to find symbol information.  I will
> assume that the log matches the kernel and modules that are running
> right now and I'll use the default options above for symbol resolution.
> If the current kernel and/or modules do not match the log, you can get
> more accurate output by telling me the kernel version and where to find
> map, modules, ksyms etc.  ksymoops -h explains the options.
>
> Warning (compare_maps): ksyms_base symbol
> IO_APIC_get_PCI_irq_vector_R__ver_IO_APIC_get_PCI_irq_vector not found in
> System.map.  Ignoring ksyms_base entry
> *pde = 00000000
> Oops: 0002
> CPU:    0
> EIP:    0010:[<e0a232b8>]  Not tained
> Using defaults from ksymoops -t elf32-i386 -a i386
> EFLAGS: 10282
> eax: d4a47bf8   ebx: d99f1180     ecx: cefd1480       edx: 00000000
> esi: d526e080   edi: 00000000     ebp: 00000046       esp: c02a7f04
> ds: 0018        es: 0018       ss: 0018
> Process swapper (pid: 0, stackpage=c02a7000)
> Stack:  e09f3939 d526e080 e09f3e16 d99f1180 e09f3d04 d526e080 e09f3920
> fffffffe
>         e09f3e79 d526e080 d526e080 c012048b d526e080 dffeb200 c02a7f3c
> c02a7f3c
>         00000000 c02c7a80 fffffffe 00000046 c011cc42 c011cb56 00000000
> 00000001
> Call Trace:     [<e09f3939>] [<e09f3e16>] [<e09f3d04>] [<e09f3e20>]
> [<e0ef3e79>]
>     [<c012048b>] [<c011cc42>] [<c011cb56>] [<c011c995>] [<c01089da>]
> [<c01052c0>]
>     [<c010ade8>] [<c01052c0>] [<c01052e3>] [<c0105372>] [<c0105000>]
> Code: 89 02 c7 41 04 00 00 00 00 c7 01 00 00 00 00 8b 83 80 00 00
>
>
>>>EIP; e0a232b8 <[ip_conntrack_proto_gre]ip_ct_gre_keymap_destroy+88/c0>
> <=====
>
>>>eax; d4a47bf8 <_end+14742374/206247dc>
>>>ebx; d99f1180 <_end+196eb8fc/206247dc>
>>>ecx; cefd1480 <_end+eccbbfc/206247dc>
>>>esi; d526e080 <_end+14f687fc/206247dc>
>>>esp; c02a7f04 <init_task_union+1f04/2000>
>
> Trace; e09f3939 <[ip_conntrack]ip_ct_find_proto+19/40>
> Trace; e09f3e16 <[ip_conntrack]destroy_conntrack+106/110>
> Trace; e09f3d04 <[ip_conntrack]clean_from_lists+54/60>
> Trace; e09f3e20 <[ip_conntrack]death_by_timeout+0/60>
> Trace; e0ef3e79 <END_OF_CODE+2e35d6/????>
> Trace; c012048b <timer_bh+17b/3a0>
> Trace; c011cc42 <bh_action+22/40>
> Trace; c011cb56 <tasklet_hi_action+46/70>
> Trace; c011c995 <do_softirq+95/a0>
> Trace; c01089da <do_IRQ+9a/a0>
> Trace; c01052c0 <default_idle+0/40>
> Trace; c010ade8 <call_do_IRQ+5/d>
> Trace; c01052c0 <default_idle+0/40>
> Trace; c01052e3 <default_idle+23/40>
> Trace; c0105372 <cpu_idle+52/70>
> Trace; c0105000 <_stext+0/0>
>
> Code;  e0a232b8 <[ip_conntrack_proto_gre]ip_ct_gre_keymap_destroy+88/c0>
> 00000000 <_EIP>:
> Code;  e0a232b8 <[ip_conntrack_proto_gre]ip_ct_gre_keymap_destroy+88/c0>
> <=====
>    0:   89 02                     mov    %eax,(%edx)   <=====
> Code;  e0a232ba <[ip_conntrack_proto_gre]ip_ct_gre_keymap_destroy+8a/c0>
>    2:   c7 41 04 00 00 00 00      movl   $0x0,0x4(%ecx)
> Code;  e0a232c1 <[ip_conntrack_proto_gre]ip_ct_gre_keymap_destroy+91/c0>
>    9:   c7 01 00 00 00 00         movl   $0x0,(%ecx)
> Code;  e0a232c7 <[ip_conntrack_proto_gre]ip_ct_gre_keymap_destroy+97/c0>
>    f:   8b 83 80 00 00 00         mov    0x80(%ebx),%eax
>
>
> 2 warnings issued.  Results may not be reliable.
> --
>
> Loaded modules:
> bsd_comp                4216   0  (autoclean)
> ppp_deflate             3320  11  (autoclean)
> zlib_inflate           18596   0  (autoclean) [ppp_deflate]
> zlib_deflate           18936   0  (autoclean) [ppp_deflate]
> ppp_async               6624  91  (autoclean)
> ppp_generic            16964 273  (autoclean) [bsd_comp ppp_deflate
> ppp_async]
> slhc                    4768  14  (autoclean) [ppp_generic]
> ipt_MASQUERADE          1336   2  (autoclean)
> ipt_limit                920   1  (autoclean)
> ipt_string              1724   1  (autoclean)
> ipt_ULOG                4612   2  (autoclean)
> ipt_LOG                 3936   3  (autoclean)
> iptable_filter          1772   1  (autoclean)
> ipt_MARK                 792   1  (autoclean)
> iptable_mangle          2200   1  (autoclean)
> ip_nat_proto_gre        2180   0  (unused)
> ip_conntrack_pptp       7281   1  (autoclean)
> ip_nat_pptp             4620   0  (unused)
> ip_conntrack_proto_gre    3829   0  [ip_conntrack_pptp ip_nat_pptp]
> ip_conntrack_ftp        4112   1  (autoclean)
> ip_nat_ftp              3024   0  (unused)
> iptable_nat            17646   4  [ipt_MASQUERADE ip_nat_proto_gre
> ip_nat_pptp ip_nat_ftp]
> ip_tables              12416  11  [ipt_MASQUERADE ipt_limit ipt_string
> ipt_ULOG ipt_LOG iptable_filter ipt_MARK iptable_mangle iptable_nat]
> ip_conntrack           20484   3  [ipt_MASQUERADE ip_conntrack_pptp
> ip_nat_pptp ip_conntrack_proto_gre ip_conntrack_ftp ip_nat_ftp
> iptable_nat]
> dummy                    984   0  (unused)
> e1000                  74992   3
> e100                   32556   1
>
> Any help would be greatly appreciated.
>
> --
> wbr, Oleg.
>
>
>
> ------------------------------
>
> _______________________________________________
> netfilter-devel mailing list
> netfilter-devel@lists.netfilter.org
> https://lists.netfilter.org/mailman/listinfo/netfilter-devel
>
>
> End of netfilter-devel Digest, Vol 3, Issue 20
> **********************************************
>
