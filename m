From: Abhishek Singh <abhishek@abhishekonline.info>
Subject: Re: ROUTE patch
Date: Wed, 25 Feb 2009 08:44:05 +0530
Message-ID: <c122d6890902241914m118d7061o50a5d04997202ac3@mail.gmail.com>
References: <c122d6890902240059j540fc8dcl529129d7bc5006fe@mail.gmail.com>
	 <alpine.LSU.2.00.0902241031500.30346@fbirervta.pbzchgretzou.qr>
	 <49A3F922.4050508@trash.net>
	 <alpine.LSU.2.00.0902241629550.23542@fbirervta.pbzchgretzou.qr>
	 <49A4133E.4070703@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0016363b948edd00230463b5a09b
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.179]:61443 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457AbZBYDOH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Feb 2009 22:14:07 -0500
Received: by wa-out-1112.google.com with SMTP id v33so1546789wah.21
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Feb 2009 19:14:06 -0800 (PST)
In-Reply-To: <49A4133E.4070703@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--0016363b948edd00230463b5a09b
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

The current code for the patch is like this:

#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/module.h>
#include <linux/skbuff.h>
#include <linux/netdevice.h>
#include <linux/route.h>
#include <linux/version.h>
#include <linux/if_arp.h>
#include <linux/ip.h>
#include <linux/netfilter_ipv4/ip_tables.h>
#include <linux/netfilter_ipv4.h>
#include <linux/netfilter/nf_conntrack_common.h>
//#include <linux/netfilter_ipv4/ipt_ROUTE.h>
#include <net/netfilter/nf_conntrack.h>
#include <net/ip.h>
#include <net/route.h>
#include <net/icmp.h>
#include <net/checksum.h>
#include "ipt_ROUTE.h"
#if 0
#define DEBUGP printk
#else
#define DEBUGP(format, args...)
#endif

;

/* Try to route the packet according to the routing keys specified in
 * route_info. Keys are :
 *  - ifindex :
 *      0 if no oif preferred,
 *      otherwise set to the index of the desired oif
 *  - route_info->gw :
 *      0 if no gateway specified,
 *      otherwise set to the next host to which the pkt must be routed
 * If success, skb->dev is the output device to which the packet must
 * be sent and skb->dst is not NULL
 *
 * RETURN: -1 if an error occured
 *          1 if the packet was succesfully routed to the
 *            destination desired
 *          0 if the kernel routing table could not route the packet
 *            according to the keys specified
 */
static int route(struct sk_buff *skb,
		 unsigned int ifindex,
		 const struct ipt_route_target_info *route_info)
{
	int err;
	struct rtable *rt;
	struct iphdr *iph = ip_hdr(skb);
	struct flowi fl = {
		.oif = ifindex,
		.nl_u = {
			.ip4_u = {
				.daddr = iph->daddr,
				.saddr = 0,
				.tos = RT_TOS(iph->tos),
				.scope = RT_SCOPE_UNIVERSE,
			}
		}
	};
	
	/* The destination address may be overloaded by the target */
	if (route_info->gw)
		fl.fl4_dst = route_info->gw;
	
	/* Trying to route the packet using the standard routing table. */
	if ((err = ip_route_output_key(&init_net, &rt, &fl))) {
		if (net_ratelimit())
			DEBUGP("ipt_ROUTE: couldn't route pkt (err: %i)",err);
		return -1;
	}
	
	/* Drop old route. */
	dst_release(skb->dst);
	skb->dst = NULL;

	/* Success if no oif specified or if the oif correspond to the
	 * one desired */
	if (!ifindex || rt->u.dst.dev->ifindex == ifindex) {
		skb->dst = &rt->u.dst;
		skb->dev = skb->dst->dev;
		skb->protocol = htons(ETH_P_IP);
		return 1;
	}
	
	/* The interface selected by the routing table is not the one
	 * specified by the user. This may happen because the dst address
	 * is one of our own addresses.
	 */
	if (net_ratelimit())
		DEBUGP("ipt_ROUTE: failed to route as desired gw=%u.%u.%u.%u oif=%i
(got oif=%i)\n",
		       NIPQUAD(route_info->gw), ifindex, rt->u.dst.dev->ifindex);
	
	return 0;
}


/* Stolen from ip_finish_output2
 * PRE : skb->dev is set to the device we are leaving by
 *       skb->dst is not NULL
 * POST: the packet is sent with the link layer header pushed
 *       the packet is destroyed
 */
static void ip_direct_send(struct sk_buff *skb)
{
	struct dst_entry *dst = skb->dst;
	struct rtable *rt = (struct rtable *)dst;
	struct net_device *dev = dst->dev;
	unsigned int hh_len = LL_RESERVED_SPACE(dev);

	if (rt->rt_type == RTN_MULTICAST)
		IP_INC_STATS(IPSTATS_MIB_OUTMCASTPKTS);
        else if (rt->rt_type == RTN_BROADCAST)
                IP_INC_STATS(IPSTATS_MIB_OUTBCASTPKTS);

        /* Be paranoid, rather than too clever. */
       if (unlikely(skb_headroom(skb) < hh_len && dev->header_ops)) {
                struct sk_buff *skb2;

                skb2 = skb_realloc_headroom(skb, LL_RESERVED_SPACE(dev));
                if (skb2 == NULL) {
                        kfree_skb(skb);
                        return;
                }
                if (skb->sk)
                        skb_set_owner_w(skb2, skb->sk);
                kfree_skb(skb);
                skb = skb2;
        }

        if (dst->hh){
                neigh_hh_output(dst->hh, skb);
		return;
	}
        else if (dst->neighbour){
                dst->neighbour->output(skb);
		return;
	}

        if (net_ratelimit())
                printk(KERN_DEBUG "ip_finish_output2: No header cache
and no neighbour!\n");
        kfree_skb(skb);
        return;
}


/* PRE : skb->dev is set to the device we are leaving by
 * POST: - the packet is directly sent to the skb->dev device, without
 *         pushing the link layer header.
 *       - the packet is destroyed
 */
static inline int dev_direct_send(struct sk_buff *skb)
{
	return dev_queue_xmit(skb);
}


static unsigned int route_oif(const struct ipt_route_target_info *route_info,
			      struct sk_buff *skb)
{
	unsigned int ifindex = 0;
	struct net_device *dev_out = NULL;

	/* The user set the interface name to use.
	 * Getting the current interface index.
	 */
	if ((dev_out = dev_get_by_name(&init_net, route_info->oif))) {
		ifindex = dev_out->ifindex;
	} else {
		/* Unknown interface name : packet dropped */
		if (net_ratelimit())
			DEBUGP("ipt_ROUTE: oif interface %s not found\n", route_info->oif);
		return NF_DROP;
	}

	/* Trying the standard way of routing packets */
	switch (route(skb, ifindex, route_info)) {
	case 1:
		dev_put(dev_out);
		if (route_info->flags & IPT_ROUTE_CONTINUE)
			return IPT_CONTINUE;

		ip_direct_send(skb);
		return NF_STOLEN;

	case 0:
		/* Failed to send to oif. Trying the hard way */
		if (route_info->flags & IPT_ROUTE_CONTINUE)
			return NF_DROP;

		if (net_ratelimit())
			DEBUGP("ipt_ROUTE: forcing the use of %i\n",
			       ifindex);

		/* We have to force the use of an interface.
		 * This interface must be a tunnel interface since
		 * otherwise we can't guess the hw address for
		 * the packet. For a tunnel interface, no hw address
		 * is needed.
		 */
		if ((dev_out->type != ARPHRD_TUNNEL)
		    && (dev_out->type != ARPHRD_IPGRE)) {
			if (net_ratelimit())
				DEBUGP("ipt_ROUTE: can't guess the hw addr !\n");
			dev_put(dev_out);
			return NF_DROP;
		}
	
		/* Send the packet. This will also free skb
		 * Do not go through the POST_ROUTING hook because
		 * skb->dst is not set and because it will probably
		 * get confused by the destination IP address.
		 */
		skb->dev = dev_out;
		dev_direct_send(skb);
		dev_put(dev_out);
		return NF_STOLEN;
		
	default:
		/* Unexpected error */
		dev_put(dev_out);
		return NF_DROP;
	}
}


static unsigned int route_iif(const struct ipt_route_target_info *route_info,
			      struct sk_buff *skb)
{
	struct net_device *dev_in = NULL;

	/* Getting the current interface index. */
	if (!(dev_in = dev_get_by_name(&init_net, route_info->iif))) {
		if (net_ratelimit())
			DEBUGP("ipt_ROUTE: iif interface %s not found\n", route_info->iif);
		return NF_DROP;
	}

	skb->dev = dev_in;
	dst_release(skb->dst);
	skb->dst = NULL;

	netif_rx(skb);
	dev_put(dev_in);
	return NF_STOLEN;
}


static unsigned int route_gw(const struct ipt_route_target_info *route_info,
			     struct sk_buff *skb)
{
	if (route(skb, 0, route_info)!=1)
		return NF_DROP;

	if (route_info->flags & IPT_ROUTE_CONTINUE)
		return IPT_CONTINUE;

	ip_direct_send(skb);
	return NF_STOLEN;
}


/* To detect and deter routed packet loopback when using the --tee option,
 * we take a page out of the raw.patch book: on the copied skb, we set up
 * a fake ->nfct entry, pointing to the local &route_tee_track. We skip
 * routing packets when we see they already have that ->nfct.
 */

static struct nf_conn route_tee_track;

static unsigned int route_tg(struct sk_buff *pskb,
				     const struct net_device *in,
				     const struct net_device *out,
				     unsigned int hooknum,
				     const struct xt_target *target,
				     const void *targinfo)
{
	const struct ipt_route_target_info *route_info = targinfo;
	struct sk_buff *skb;
	unsigned int res;
        skb = pskb;

	if (skb->nfct == &route_tee_track.ct_general) {
		/* Loopback - a packet we already routed, is to be
		 * routed another time. Avoid that, now.
		 */
		if (net_ratelimit())
			DEBUGP(KERN_DEBUG "ipt_ROUTE: loopback - DROP!\n");
		return NF_DROP;
	}

	/* If we are at PREROUTING or INPUT hook
	 * the TTL isn't decreased by the IP stack
	 */
	if (hooknum == NF_INET_PRE_ROUTING ||
	    hooknum == NF_INET_LOCAL_IN) {

		struct iphdr *iph = ip_hdr(skb);

		if (iph->ttl <= 1) {
			struct rtable *rt;
			struct flowi fl = {
				.oif = 0,
				.nl_u = {
					.ip4_u = {
						.daddr = iph->daddr,
						.saddr = iph->saddr,
						.tos = RT_TOS(iph->tos),
						.scope = ((iph->tos & RTO_ONLINK) ?
							  RT_SCOPE_LINK :
							  RT_SCOPE_UNIVERSE)
					}
				}
			};

			if (ip_route_output_key(&init_net, &rt, &fl)) {
				return NF_DROP;
			}

			if (skb->dev == rt->u.dst.dev) {
				/* Drop old route. */
				dst_release(skb->dst);
				skb->dst = &rt->u.dst;

				/* this will traverse normal stack, and
				 * thus call conntrack on the icmp packet */
				icmp_send(skb, ICMP_TIME_EXCEEDED,
					  ICMP_EXC_TTL, 0);
			}

			return NF_DROP;
		}

		/*
		 * If we are at INPUT the checksum must be recalculated since
		 * the length could change as the result of a defragmentation.
		 */
		if(hooknum == NF_INET_LOCAL_IN) {
			iph->ttl = iph->ttl - 1;
			iph->check = 0;
			iph->check = ip_fast_csum((unsigned char *)iph, iph->ihl);
		} else {
			ip_decrease_ttl(iph);
		}
	}

	if ((route_info->flags & IPT_ROUTE_TEE)) {
		/*
		 * Copy the *pskb, and route the copy. Will later return
		 * IPT_CONTINUE for the original skb, which should continue
		 * on its way as if nothing happened. The copy should be
		 * independantly delivered to the ROUTE --gw.
		 */
		skb = skb_copy(pskb, GFP_ATOMIC);
		if (!skb) {
			if (net_ratelimit())
				DEBUGP(KERN_DEBUG "ipt_ROUTE: copy failed!\n");
			return IPT_CONTINUE;
		}
	}

	/* Tell conntrack to forget this packet since it may get confused
	 * when a packet is leaving with dst address == our address.
	 * Good idea ? Dunno. Need advice.
	 *
	 * NEW: mark the skb with our &route_tee_track, so we avoid looping
	 * on any already routed packet.
	 */
	if (!(route_info->flags & IPT_ROUTE_CONTINUE)) {
		nf_conntrack_put(skb->nfct);
		skb->nfct = &route_tee_track.ct_general;
		skb->nfctinfo = IP_CT_NEW;
		nf_conntrack_get(skb->nfct);
	}

	if (route_info->oif[0] != '\0') {
		res = route_oif(route_info, skb);
	} else if (route_info->iif[0] != '\0') {
		res = route_iif(route_info, skb);
	} else if (route_info->gw) {
		res = route_gw(route_info, skb);
	} else {
		if (net_ratelimit())
			DEBUGP(KERN_DEBUG "ipt_ROUTE: no parameter !\n");
		res = IPT_CONTINUE;
	}

	if ((route_info->flags & IPT_ROUTE_TEE))
		res = IPT_CONTINUE;

	return res;
}


static bool
route_tg_checkentry(const char *tablename, const void *e_void,
		    const struct xt_target *target, void *targinfo,
		    unsigned int hook_mask)
{
	if (strcmp(tablename, "mangle") != 0) {
		printk("ipt_ROUTE: bad table `%s', use the `mangle' table.\n",
		       tablename);
		return false;
	}

/* No need of comparing the hook, they don't exist in kernel space anymore.
 * Only exist in userspace. The check above for mangle table is also redundant
 */

	if (hook_mask & ~(  (1 << NF_INET_PRE_ROUTING)
			    | (1 << NF_INET_LOCAL_IN)
			    | (1 << NF_INET_FORWARD)
			    | (1 << NF_INET_LOCAL_OUT)
			    | (1 << NF_INET_POST_ROUTING))) {
		printk("ipt_ROUTE: bad hook\n");
		return false;
	}

	return true;
}


static struct xt_target route_tg_reg  __read_mostly = {
	.name = "ROUTE",
	.family = AF_INET,
	.target = route_tg,
	.targetsize = sizeof(struct ipt_route_target_info),
	.table = "mangle",
	.checkentry = route_tg_checkentry,
	.me = THIS_MODULE,
};

static int __init init(void)
{
	/* Set up fake conntrack (stolen from raw.patch):
	    - to never be deleted, not in any hashes */
	atomic_set(&route_tee_track.ct_general.use, 1);
	/*  - and look it like as a confirmed connection */
	set_bit(IPS_CONFIRMED_BIT, &route_tee_track.status);
	/* Initialize fake conntrack so that NAT will skip it */
	route_tee_track.status |= IPS_NAT_DONE_MASK;

	return xt_register_target(&route_tg_reg);
}


static void __exit fini(void)
{
	xt_unregister_target(&route_tg_reg);
}

module_init(init);
module_exit(fini);


Regards
Abhishek



On Tue, Feb 24, 2009 at 9:03 PM, Patrick McHardy <kaber@trash.net> wrote:
> Jan Engelhardt wrote:
>>
>> On Tuesday 2009-02-24 14:41, Patrick McHardy wrote:
>>>
>>> Jan Engelhardt wrote:
>>>>
>>>> On Tuesday 2009-02-24 09:59, Abhishek Singh wrote:
>>>>>
>>>>> What I would like to know is that if someone would like to add it to
>>>>> the main iptables tree and the patchomatic repository. I am not sure
>>>>> how to go about it. If someone is interested, please let me know. I
>>>>> shall contribute the code and if would be happy to incorporate review
>>>>> comments by other developers.
>>>>
>>>> [omg timeline!]
>>>>
>>>> Short answer, no. There is iproute2 and xt_TEE which replace it,
>>>> and even patchomatic is gone.
>>>>
>>>> [/me takes a leap forward]
>>>
>>> Perhaps we can finally get this merged. IIRC the only reason against
>>> it is the IP layer duplication instead of simply using dst_output().
>>>
>> It cannot use dst_output because that would cause reentrancy into
>> iptablse.
>> Want a patch, though?
>
> I would like to have a look at the current patch, yes. Don't
> bother fixing anything though, I mainly want to have a look
> at the routing part.
>

--0016363b948edd00230463b5a09b
Content-Type: application/octet-stream; name="ipt_ROUTE.c"
Content-Disposition: attachment; filename="ipt_ROUTE.c"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_frlfllys0

LyoKICogVGhpcyBpbXBsZW1lbnRzIHRoZSBST1VURSB0YXJnZXQsIHdoaWNoIGVuYWJsZXMgeW91
IHRvIHNldHVwIHVudXN1YWwKICogcm91dGVzIG5vdCBzdXBwb3J0ZWQgYnkgdGhlIHN0YW5kYXJk
IGtlcm5lbCByb3V0aW5nIHRhYmxlLgogKgogKiBDb3B5cmlnaHQgKEMpIDIwMDggQWJoaXNoZWsg
S3VtYXIgU2luZ2ggPGFiaGlzaGVrMS5zaW5naEBoc2MuY29tPgogKgogKiB2IDEuMTEgMjAwOC8x
Mi8xMgogKgogKiBUaGlzIHNvZnR3YXJlIGlzIGRpc3RyaWJ1dGVkIHVuZGVyIEdOVSBHUEwgdjIs
IDE5OTEKICovCgojaW5jbHVkZSA8bGludXgva2VybmVsLmg+CiNpbmNsdWRlIDxsaW51eC9pbml0
Lmg+CiNpbmNsdWRlIDxsaW51eC9tb2R1bGUuaD4KI2luY2x1ZGUgPGxpbnV4L3NrYnVmZi5oPgoj
aW5jbHVkZSA8bGludXgvbmV0ZGV2aWNlLmg+CiNpbmNsdWRlIDxsaW51eC9yb3V0ZS5oPgojaW5j
bHVkZSA8bGludXgvdmVyc2lvbi5oPgojaW5jbHVkZSA8bGludXgvaWZfYXJwLmg+CiNpbmNsdWRl
IDxsaW51eC9pcC5oPgojaW5jbHVkZSA8bGludXgvbmV0ZmlsdGVyX2lwdjQvaXBfdGFibGVzLmg+
CiNpbmNsdWRlIDxsaW51eC9uZXRmaWx0ZXJfaXB2NC5oPgojaW5jbHVkZSA8bGludXgvbmV0Zmls
dGVyL25mX2Nvbm50cmFja19jb21tb24uaD4KLy8jaW5jbHVkZSA8bGludXgvbmV0ZmlsdGVyX2lw
djQvaXB0X1JPVVRFLmg+CiNpbmNsdWRlIDxuZXQvbmV0ZmlsdGVyL25mX2Nvbm50cmFjay5oPgoj
aW5jbHVkZSA8bmV0L2lwLmg+CiNpbmNsdWRlIDxuZXQvcm91dGUuaD4KI2luY2x1ZGUgPG5ldC9p
Y21wLmg+CiNpbmNsdWRlIDxuZXQvY2hlY2tzdW0uaD4KI2luY2x1ZGUgImlwdF9ST1VURS5oIgoj
aWYgMAojZGVmaW5lIERFQlVHUCBwcmludGsKI2Vsc2UKI2RlZmluZSBERUJVR1AoZm9ybWF0LCBh
cmdzLi4uKQojZW5kaWYKCk1PRFVMRV9MSUNFTlNFKCJHUEwiKTsKTU9EVUxFX0FVVEhPUigiQWJo
aXNoZWsgS3VtYXIgU2luZ2ggPGFiaGlzaGVrMS5zaW5naEBoc2MuY29tPiIpOwpNT0RVTEVfREVT
Q1JJUFRJT04oImlwdGFibGVzIFJPVVRFIHRhcmdldCBtb2R1bGUiKTsKCi8qIFRyeSB0byByb3V0
ZSB0aGUgcGFja2V0IGFjY29yZGluZyB0byB0aGUgcm91dGluZyBrZXlzIHNwZWNpZmllZCBpbgog
KiByb3V0ZV9pbmZvLiBLZXlzIGFyZSA6CiAqICAtIGlmaW5kZXggOiAKICogICAgICAwIGlmIG5v
IG9pZiBwcmVmZXJyZWQsIAogKiAgICAgIG90aGVyd2lzZSBzZXQgdG8gdGhlIGluZGV4IG9mIHRo
ZSBkZXNpcmVkIG9pZgogKiAgLSByb3V0ZV9pbmZvLT5ndyA6CiAqICAgICAgMCBpZiBubyBnYXRl
d2F5IHNwZWNpZmllZCwKICogICAgICBvdGhlcndpc2Ugc2V0IHRvIHRoZSBuZXh0IGhvc3QgdG8g
d2hpY2ggdGhlIHBrdCBtdXN0IGJlIHJvdXRlZAogKiBJZiBzdWNjZXNzLCBza2ItPmRldiBpcyB0
aGUgb3V0cHV0IGRldmljZSB0byB3aGljaCB0aGUgcGFja2V0IG11c3QgCiAqIGJlIHNlbnQgYW5k
IHNrYi0+ZHN0IGlzIG5vdCBOVUxMCiAqCiAqIFJFVFVSTjogLTEgaWYgYW4gZXJyb3Igb2NjdXJl
ZAogKiAgICAgICAgICAxIGlmIHRoZSBwYWNrZXQgd2FzIHN1Y2Nlc2Z1bGx5IHJvdXRlZCB0byB0
aGUgCiAqICAgICAgICAgICAgZGVzdGluYXRpb24gZGVzaXJlZAogKiAgICAgICAgICAwIGlmIHRo
ZSBrZXJuZWwgcm91dGluZyB0YWJsZSBjb3VsZCBub3Qgcm91dGUgdGhlIHBhY2tldAogKiAgICAg
ICAgICAgIGFjY29yZGluZyB0byB0aGUga2V5cyBzcGVjaWZpZWQKICovCnN0YXRpYyBpbnQgcm91
dGUoc3RydWN0IHNrX2J1ZmYgKnNrYiwKCQkgdW5zaWduZWQgaW50IGlmaW5kZXgsCgkJIGNvbnN0
IHN0cnVjdCBpcHRfcm91dGVfdGFyZ2V0X2luZm8gKnJvdXRlX2luZm8pCnsKCWludCBlcnI7Cglz
dHJ1Y3QgcnRhYmxlICpydDsKCXN0cnVjdCBpcGhkciAqaXBoID0gaXBfaGRyKHNrYik7CglzdHJ1
Y3QgZmxvd2kgZmwgPSB7CgkJLm9pZiA9IGlmaW5kZXgsCgkJLm5sX3UgPSB7CgkJCS5pcDRfdSA9
IHsKCQkJCS5kYWRkciA9IGlwaC0+ZGFkZHIsCgkJCQkuc2FkZHIgPSAwLAoJCQkJLnRvcyA9IFJU
X1RPUyhpcGgtPnRvcyksCgkJCQkuc2NvcGUgPSBSVF9TQ09QRV9VTklWRVJTRSwKCQkJfQoJCX0g
Cgl9OwoJCgkvKiBUaGUgZGVzdGluYXRpb24gYWRkcmVzcyBtYXkgYmUgb3ZlcmxvYWRlZCBieSB0
aGUgdGFyZ2V0ICovCglpZiAocm91dGVfaW5mby0+Z3cpCgkJZmwuZmw0X2RzdCA9IHJvdXRlX2lu
Zm8tPmd3OwoJCgkvKiBUcnlpbmcgdG8gcm91dGUgdGhlIHBhY2tldCB1c2luZyB0aGUgc3RhbmRh
cmQgcm91dGluZyB0YWJsZS4gKi8KCWlmICgoZXJyID0gaXBfcm91dGVfb3V0cHV0X2tleSgmaW5p
dF9uZXQsICZydCwgJmZsKSkpIHsKCQlpZiAobmV0X3JhdGVsaW1pdCgpKSAKCQkJREVCVUdQKCJp
cHRfUk9VVEU6IGNvdWxkbid0IHJvdXRlIHBrdCAoZXJyOiAlaSkiLGVycik7CgkJcmV0dXJuIC0x
OwoJfQoJCgkvKiBEcm9wIG9sZCByb3V0ZS4gKi8KCWRzdF9yZWxlYXNlKHNrYi0+ZHN0KTsKCXNr
Yi0+ZHN0ID0gTlVMTDsKCgkvKiBTdWNjZXNzIGlmIG5vIG9pZiBzcGVjaWZpZWQgb3IgaWYgdGhl
IG9pZiBjb3JyZXNwb25kIHRvIHRoZSAKCSAqIG9uZSBkZXNpcmVkICovCglpZiAoIWlmaW5kZXgg
fHwgcnQtPnUuZHN0LmRldi0+aWZpbmRleCA9PSBpZmluZGV4KSB7CgkJc2tiLT5kc3QgPSAmcnQt
PnUuZHN0OwoJCXNrYi0+ZGV2ID0gc2tiLT5kc3QtPmRldjsKCQlza2ItPnByb3RvY29sID0gaHRv
bnMoRVRIX1BfSVApOwoJCXJldHVybiAxOwoJfQoJCgkvKiBUaGUgaW50ZXJmYWNlIHNlbGVjdGVk
IGJ5IHRoZSByb3V0aW5nIHRhYmxlIGlzIG5vdCB0aGUgb25lCgkgKiBzcGVjaWZpZWQgYnkgdGhl
IHVzZXIuIFRoaXMgbWF5IGhhcHBlbiBiZWNhdXNlIHRoZSBkc3QgYWRkcmVzcwoJICogaXMgb25l
IG9mIG91ciBvd24gYWRkcmVzc2VzLgoJICovCglpZiAobmV0X3JhdGVsaW1pdCgpKSAKCQlERUJV
R1AoImlwdF9ST1VURTogZmFpbGVkIHRvIHJvdXRlIGFzIGRlc2lyZWQgZ3c9JXUuJXUuJXUuJXUg
b2lmPSVpIChnb3Qgb2lmPSVpKVxuIiwgCgkJICAgICAgIE5JUFFVQUQocm91dGVfaW5mby0+Z3cp
LCBpZmluZGV4LCBydC0+dS5kc3QuZGV2LT5pZmluZGV4KTsKCQoJcmV0dXJuIDA7Cn0KCgovKiBT
dG9sZW4gZnJvbSBpcF9maW5pc2hfb3V0cHV0MgogKiBQUkUgOiBza2ItPmRldiBpcyBzZXQgdG8g
dGhlIGRldmljZSB3ZSBhcmUgbGVhdmluZyBieQogKiAgICAgICBza2ItPmRzdCBpcyBub3QgTlVM
TAogKiBQT1NUOiB0aGUgcGFja2V0IGlzIHNlbnQgd2l0aCB0aGUgbGluayBsYXllciBoZWFkZXIg
cHVzaGVkCiAqICAgICAgIHRoZSBwYWNrZXQgaXMgZGVzdHJveWVkCiAqLwpzdGF0aWMgdm9pZCBp
cF9kaXJlY3Rfc2VuZChzdHJ1Y3Qgc2tfYnVmZiAqc2tiKQp7CglzdHJ1Y3QgZHN0X2VudHJ5ICpk
c3QgPSBza2ItPmRzdDsKCXN0cnVjdCBydGFibGUgKnJ0ID0gKHN0cnVjdCBydGFibGUgKilkc3Q7
CglzdHJ1Y3QgbmV0X2RldmljZSAqZGV2ID0gZHN0LT5kZXY7Cgl1bnNpZ25lZCBpbnQgaGhfbGVu
ID0gTExfUkVTRVJWRURfU1BBQ0UoZGV2KTsKCglpZiAocnQtPnJ0X3R5cGUgPT0gUlROX01VTFRJ
Q0FTVCkKCQlJUF9JTkNfU1RBVFMoSVBTVEFUU19NSUJfT1VUTUNBU1RQS1RTKTsKICAgICAgICBl
bHNlIGlmIChydC0+cnRfdHlwZSA9PSBSVE5fQlJPQURDQVNUKQogICAgICAgICAgICAgICAgSVBf
SU5DX1NUQVRTKElQU1RBVFNfTUlCX09VVEJDQVNUUEtUUyk7CgogICAgICAgIC8qIEJlIHBhcmFu
b2lkLCByYXRoZXIgdGhhbiB0b28gY2xldmVyLiAqLwogICAgICAgaWYgKHVubGlrZWx5KHNrYl9o
ZWFkcm9vbShza2IpIDwgaGhfbGVuICYmIGRldi0+aGVhZGVyX29wcykpIHsKICAgICAgICAgICAg
ICAgIHN0cnVjdCBza19idWZmICpza2IyOwoKICAgICAgICAgICAgICAgIHNrYjIgPSBza2JfcmVh
bGxvY19oZWFkcm9vbShza2IsIExMX1JFU0VSVkVEX1NQQUNFKGRldikpOwogICAgICAgICAgICAg
ICAgaWYgKHNrYjIgPT0gTlVMTCkgewogICAgICAgICAgICAgICAgICAgICAgICBrZnJlZV9za2Io
c2tiKTsKICAgICAgICAgICAgICAgICAgICAgICAgcmV0dXJuOwogICAgICAgICAgICAgICAgfQog
ICAgICAgICAgICAgICAgaWYgKHNrYi0+c2spCiAgICAgICAgICAgICAgICAgICAgICAgIHNrYl9z
ZXRfb3duZXJfdyhza2IyLCBza2ItPnNrKTsKICAgICAgICAgICAgICAgIGtmcmVlX3NrYihza2Ip
OwogICAgICAgICAgICAgICAgc2tiID0gc2tiMjsKICAgICAgICB9CgogICAgICAgIGlmIChkc3Qt
PmhoKXsKICAgICAgICAgICAgICAgIG5laWdoX2hoX291dHB1dChkc3QtPmhoLCBza2IpOwoJCXJl
dHVybjsKCX0KICAgICAgICBlbHNlIGlmIChkc3QtPm5laWdoYm91cil7CiAgICAgICAgICAgICAg
ICBkc3QtPm5laWdoYm91ci0+b3V0cHV0KHNrYik7CgkJcmV0dXJuOwoJfQoKICAgICAgICBpZiAo
bmV0X3JhdGVsaW1pdCgpKQogICAgICAgICAgICAgICAgcHJpbnRrKEtFUk5fREVCVUcgImlwX2Zp
bmlzaF9vdXRwdXQyOiBObyBoZWFkZXIgY2FjaGUgYW5kIG5vIG5laWdoYm91ciFcbiIpOwogICAg
ICAgIGtmcmVlX3NrYihza2IpOwogICAgICAgIHJldHVybjsKfQoKCi8qIFBSRSA6IHNrYi0+ZGV2
IGlzIHNldCB0byB0aGUgZGV2aWNlIHdlIGFyZSBsZWF2aW5nIGJ5CiAqIFBPU1Q6IC0gdGhlIHBh
Y2tldCBpcyBkaXJlY3RseSBzZW50IHRvIHRoZSBza2ItPmRldiBkZXZpY2UsIHdpdGhvdXQgCiAq
ICAgICAgICAgcHVzaGluZyB0aGUgbGluayBsYXllciBoZWFkZXIuCiAqICAgICAgIC0gdGhlIHBh
Y2tldCBpcyBkZXN0cm95ZWQKICovCnN0YXRpYyBpbmxpbmUgaW50IGRldl9kaXJlY3Rfc2VuZChz
dHJ1Y3Qgc2tfYnVmZiAqc2tiKQp7CglyZXR1cm4gZGV2X3F1ZXVlX3htaXQoc2tiKTsKfQoKCnN0
YXRpYyB1bnNpZ25lZCBpbnQgcm91dGVfb2lmKGNvbnN0IHN0cnVjdCBpcHRfcm91dGVfdGFyZ2V0
X2luZm8gKnJvdXRlX2luZm8sCgkJCSAgICAgIHN0cnVjdCBza19idWZmICpza2IpIAp7Cgl1bnNp
Z25lZCBpbnQgaWZpbmRleCA9IDA7CglzdHJ1Y3QgbmV0X2RldmljZSAqZGV2X291dCA9IE5VTEw7
CgoJLyogVGhlIHVzZXIgc2V0IHRoZSBpbnRlcmZhY2UgbmFtZSB0byB1c2UuCgkgKiBHZXR0aW5n
IHRoZSBjdXJyZW50IGludGVyZmFjZSBpbmRleC4KCSAqLwoJaWYgKChkZXZfb3V0ID0gZGV2X2dl
dF9ieV9uYW1lKCZpbml0X25ldCwgcm91dGVfaW5mby0+b2lmKSkpIHsKCQlpZmluZGV4ID0gZGV2
X291dC0+aWZpbmRleDsKCX0gZWxzZSB7CgkJLyogVW5rbm93biBpbnRlcmZhY2UgbmFtZSA6IHBh
Y2tldCBkcm9wcGVkICovCgkJaWYgKG5ldF9yYXRlbGltaXQoKSkgCgkJCURFQlVHUCgiaXB0X1JP
VVRFOiBvaWYgaW50ZXJmYWNlICVzIG5vdCBmb3VuZFxuIiwgcm91dGVfaW5mby0+b2lmKTsKCQly
ZXR1cm4gTkZfRFJPUDsKCX0KCgkvKiBUcnlpbmcgdGhlIHN0YW5kYXJkIHdheSBvZiByb3V0aW5n
IHBhY2tldHMgKi8KCXN3aXRjaCAocm91dGUoc2tiLCBpZmluZGV4LCByb3V0ZV9pbmZvKSkgewoJ
Y2FzZSAxOgoJCWRldl9wdXQoZGV2X291dCk7CgkJaWYgKHJvdXRlX2luZm8tPmZsYWdzICYgSVBU
X1JPVVRFX0NPTlRJTlVFKQoJCQlyZXR1cm4gSVBUX0NPTlRJTlVFOwoKCQlpcF9kaXJlY3Rfc2Vu
ZChza2IpOwoJCXJldHVybiBORl9TVE9MRU47CgoJY2FzZSAwOgoJCS8qIEZhaWxlZCB0byBzZW5k
IHRvIG9pZi4gVHJ5aW5nIHRoZSBoYXJkIHdheSAqLwoJCWlmIChyb3V0ZV9pbmZvLT5mbGFncyAm
IElQVF9ST1VURV9DT05USU5VRSkKCQkJcmV0dXJuIE5GX0RST1A7CgoJCWlmIChuZXRfcmF0ZWxp
bWl0KCkpIAoJCQlERUJVR1AoImlwdF9ST1VURTogZm9yY2luZyB0aGUgdXNlIG9mICVpXG4iLAoJ
CQkgICAgICAgaWZpbmRleCk7CgoJCS8qIFdlIGhhdmUgdG8gZm9yY2UgdGhlIHVzZSBvZiBhbiBp
bnRlcmZhY2UuCgkJICogVGhpcyBpbnRlcmZhY2UgbXVzdCBiZSBhIHR1bm5lbCBpbnRlcmZhY2Ug
c2luY2UKCQkgKiBvdGhlcndpc2Ugd2UgY2FuJ3QgZ3Vlc3MgdGhlIGh3IGFkZHJlc3MgZm9yCgkJ
ICogdGhlIHBhY2tldC4gRm9yIGEgdHVubmVsIGludGVyZmFjZSwgbm8gaHcgYWRkcmVzcwoJCSAq
IGlzIG5lZWRlZC4KCQkgKi8KCQlpZiAoKGRldl9vdXQtPnR5cGUgIT0gQVJQSFJEX1RVTk5FTCkK
CQkgICAgJiYgKGRldl9vdXQtPnR5cGUgIT0gQVJQSFJEX0lQR1JFKSkgewoJCQlpZiAobmV0X3Jh
dGVsaW1pdCgpKSAKCQkJCURFQlVHUCgiaXB0X1JPVVRFOiBjYW4ndCBndWVzcyB0aGUgaHcgYWRk
ciAhXG4iKTsKCQkJZGV2X3B1dChkZXZfb3V0KTsKCQkJcmV0dXJuIE5GX0RST1A7CgkJfQoJCgkJ
LyogU2VuZCB0aGUgcGFja2V0LiBUaGlzIHdpbGwgYWxzbyBmcmVlIHNrYgoJCSAqIERvIG5vdCBn
byB0aHJvdWdoIHRoZSBQT1NUX1JPVVRJTkcgaG9vayBiZWNhdXNlIAoJCSAqIHNrYi0+ZHN0IGlz
IG5vdCBzZXQgYW5kIGJlY2F1c2UgaXQgd2lsbCBwcm9iYWJseQoJCSAqIGdldCBjb25mdXNlZCBi
eSB0aGUgZGVzdGluYXRpb24gSVAgYWRkcmVzcy4KCQkgKi8KCQlza2ItPmRldiA9IGRldl9vdXQ7
CgkJZGV2X2RpcmVjdF9zZW5kKHNrYik7CgkJZGV2X3B1dChkZXZfb3V0KTsKCQlyZXR1cm4gTkZf
U1RPTEVOOwoJCQoJZGVmYXVsdDoKCQkvKiBVbmV4cGVjdGVkIGVycm9yICovCgkJZGV2X3B1dChk
ZXZfb3V0KTsKCQlyZXR1cm4gTkZfRFJPUDsKCX0KfQoKCnN0YXRpYyB1bnNpZ25lZCBpbnQgcm91
dGVfaWlmKGNvbnN0IHN0cnVjdCBpcHRfcm91dGVfdGFyZ2V0X2luZm8gKnJvdXRlX2luZm8sCgkJ
CSAgICAgIHN0cnVjdCBza19idWZmICpza2IpIAp7CglzdHJ1Y3QgbmV0X2RldmljZSAqZGV2X2lu
ID0gTlVMTDsKCgkvKiBHZXR0aW5nIHRoZSBjdXJyZW50IGludGVyZmFjZSBpbmRleC4gKi8KCWlm
ICghKGRldl9pbiA9IGRldl9nZXRfYnlfbmFtZSgmaW5pdF9uZXQsIHJvdXRlX2luZm8tPmlpZikp
KSB7CgkJaWYgKG5ldF9yYXRlbGltaXQoKSkgCgkJCURFQlVHUCgiaXB0X1JPVVRFOiBpaWYgaW50
ZXJmYWNlICVzIG5vdCBmb3VuZFxuIiwgcm91dGVfaW5mby0+aWlmKTsKCQlyZXR1cm4gTkZfRFJP
UDsKCX0KCglza2ItPmRldiA9IGRldl9pbjsKCWRzdF9yZWxlYXNlKHNrYi0+ZHN0KTsKCXNrYi0+
ZHN0ID0gTlVMTDsKCgluZXRpZl9yeChza2IpOwoJZGV2X3B1dChkZXZfaW4pOwoJcmV0dXJuIE5G
X1NUT0xFTjsKfQoKCnN0YXRpYyB1bnNpZ25lZCBpbnQgcm91dGVfZ3coY29uc3Qgc3RydWN0IGlw
dF9yb3V0ZV90YXJnZXRfaW5mbyAqcm91dGVfaW5mbywKCQkJICAgICBzdHJ1Y3Qgc2tfYnVmZiAq
c2tiKSAKewoJaWYgKHJvdXRlKHNrYiwgMCwgcm91dGVfaW5mbykhPTEpCgkJcmV0dXJuIE5GX0RS
T1A7CgoJaWYgKHJvdXRlX2luZm8tPmZsYWdzICYgSVBUX1JPVVRFX0NPTlRJTlVFKQoJCXJldHVy
biBJUFRfQ09OVElOVUU7CgoJaXBfZGlyZWN0X3NlbmQoc2tiKTsKCXJldHVybiBORl9TVE9MRU47
Cn0KCgovKiBUbyBkZXRlY3QgYW5kIGRldGVyIHJvdXRlZCBwYWNrZXQgbG9vcGJhY2sgd2hlbiB1
c2luZyB0aGUgLS10ZWUgb3B0aW9uLAogKiB3ZSB0YWtlIGEgcGFnZSBvdXQgb2YgdGhlIHJhdy5w
YXRjaCBib29rOiBvbiB0aGUgY29waWVkIHNrYiwgd2Ugc2V0IHVwCiAqIGEgZmFrZSAtPm5mY3Qg
ZW50cnksIHBvaW50aW5nIHRvIHRoZSBsb2NhbCAmcm91dGVfdGVlX3RyYWNrLiBXZSBza2lwCiAq
IHJvdXRpbmcgcGFja2V0cyB3aGVuIHdlIHNlZSB0aGV5IGFscmVhZHkgaGF2ZSB0aGF0IC0+bmZj
dC4KICovCgpzdGF0aWMgc3RydWN0IG5mX2Nvbm4gcm91dGVfdGVlX3RyYWNrOwoKc3RhdGljIHVu
c2lnbmVkIGludCByb3V0ZV90ZyhzdHJ1Y3Qgc2tfYnVmZiAqcHNrYiwKCQkJCSAgICAgY29uc3Qg
c3RydWN0IG5ldF9kZXZpY2UgKmluLAoJCQkJICAgICBjb25zdCBzdHJ1Y3QgbmV0X2RldmljZSAq
b3V0LAoJCQkJICAgICB1bnNpZ25lZCBpbnQgaG9va251bSwKCQkJCSAgICAgY29uc3Qgc3RydWN0
IHh0X3RhcmdldCAqdGFyZ2V0LAoJCQkJICAgICBjb25zdCB2b2lkICp0YXJnaW5mbykKewoJY29u
c3Qgc3RydWN0IGlwdF9yb3V0ZV90YXJnZXRfaW5mbyAqcm91dGVfaW5mbyA9IHRhcmdpbmZvOwoJ
c3RydWN0IHNrX2J1ZmYgKnNrYjsKCXVuc2lnbmVkIGludCByZXM7CiAgICAgICAgc2tiID0gcHNr
YjsKCglpZiAoc2tiLT5uZmN0ID09ICZyb3V0ZV90ZWVfdHJhY2suY3RfZ2VuZXJhbCkgewoJCS8q
IExvb3BiYWNrIC0gYSBwYWNrZXQgd2UgYWxyZWFkeSByb3V0ZWQsIGlzIHRvIGJlCgkJICogcm91
dGVkIGFub3RoZXIgdGltZS4gQXZvaWQgdGhhdCwgbm93LgoJCSAqLwoJCWlmIChuZXRfcmF0ZWxp
bWl0KCkpIAoJCQlERUJVR1AoS0VSTl9ERUJVRyAiaXB0X1JPVVRFOiBsb29wYmFjayAtIERST1Ah
XG4iKTsKCQlyZXR1cm4gTkZfRFJPUDsKCX0KCgkvKiBJZiB3ZSBhcmUgYXQgUFJFUk9VVElORyBv
ciBJTlBVVCBob29rCgkgKiB0aGUgVFRMIGlzbid0IGRlY3JlYXNlZCBieSB0aGUgSVAgc3RhY2sK
CSAqLwoJaWYgKGhvb2tudW0gPT0gTkZfSU5FVF9QUkVfUk9VVElORyB8fAoJICAgIGhvb2tudW0g
PT0gTkZfSU5FVF9MT0NBTF9JTikgewoKCQlzdHJ1Y3QgaXBoZHIgKmlwaCA9IGlwX2hkcihza2Ip
OwoKCQlpZiAoaXBoLT50dGwgPD0gMSkgewoJCQlzdHJ1Y3QgcnRhYmxlICpydDsKCQkJc3RydWN0
IGZsb3dpIGZsID0gewoJCQkJLm9pZiA9IDAsCgkJCQkubmxfdSA9IHsKCQkJCQkuaXA0X3UgPSB7
CgkJCQkJCS5kYWRkciA9IGlwaC0+ZGFkZHIsCgkJCQkJCS5zYWRkciA9IGlwaC0+c2FkZHIsCgkJ
CQkJCS50b3MgPSBSVF9UT1MoaXBoLT50b3MpLAoJCQkJCQkuc2NvcGUgPSAoKGlwaC0+dG9zICYg
UlRPX09OTElOSykgPwoJCQkJCQkJICBSVF9TQ09QRV9MSU5LIDoKCQkJCQkJCSAgUlRfU0NPUEVf
VU5JVkVSU0UpCgkJCQkJfQoJCQkJfSAKCQkJfTsKCgkJCWlmIChpcF9yb3V0ZV9vdXRwdXRfa2V5
KCZpbml0X25ldCwgJnJ0LCAmZmwpKSB7CgkJCQlyZXR1cm4gTkZfRFJPUDsKCQkJfQoKCQkJaWYg
KHNrYi0+ZGV2ID09IHJ0LT51LmRzdC5kZXYpIHsKCQkJCS8qIERyb3Agb2xkIHJvdXRlLiAqLwoJ
CQkJZHN0X3JlbGVhc2Uoc2tiLT5kc3QpOwoJCQkJc2tiLT5kc3QgPSAmcnQtPnUuZHN0OwoKCQkJ
CS8qIHRoaXMgd2lsbCB0cmF2ZXJzZSBub3JtYWwgc3RhY2ssIGFuZCAKCQkJCSAqIHRodXMgY2Fs
bCBjb25udHJhY2sgb24gdGhlIGljbXAgcGFja2V0ICovCgkJCQlpY21wX3NlbmQoc2tiLCBJQ01Q
X1RJTUVfRVhDRUVERUQsIAoJCQkJCSAgSUNNUF9FWENfVFRMLCAwKTsKCQkJfQoKCQkJcmV0dXJu
IE5GX0RST1A7CgkJfQoKCQkvKgoJCSAqIElmIHdlIGFyZSBhdCBJTlBVVCB0aGUgY2hlY2tzdW0g
bXVzdCBiZSByZWNhbGN1bGF0ZWQgc2luY2UKCQkgKiB0aGUgbGVuZ3RoIGNvdWxkIGNoYW5nZSBh
cyB0aGUgcmVzdWx0IG9mIGEgZGVmcmFnbWVudGF0aW9uLgoJCSAqLwoJCWlmKGhvb2tudW0gPT0g
TkZfSU5FVF9MT0NBTF9JTikgewoJCQlpcGgtPnR0bCA9IGlwaC0+dHRsIC0gMTsKCQkJaXBoLT5j
aGVjayA9IDA7CgkJCWlwaC0+Y2hlY2sgPSBpcF9mYXN0X2NzdW0oKHVuc2lnbmVkIGNoYXIgKilp
cGgsIGlwaC0+aWhsKTsKCQl9IGVsc2UgewoJCQlpcF9kZWNyZWFzZV90dGwoaXBoKTsKCQl9Cgl9
CgoJaWYgKChyb3V0ZV9pbmZvLT5mbGFncyAmIElQVF9ST1VURV9URUUpKSB7CgkJLyoKCQkgKiBD
b3B5IHRoZSAqcHNrYiwgYW5kIHJvdXRlIHRoZSBjb3B5LiBXaWxsIGxhdGVyIHJldHVybgoJCSAq
IElQVF9DT05USU5VRSBmb3IgdGhlIG9yaWdpbmFsIHNrYiwgd2hpY2ggc2hvdWxkIGNvbnRpbnVl
CgkJICogb24gaXRzIHdheSBhcyBpZiBub3RoaW5nIGhhcHBlbmVkLiBUaGUgY29weSBzaG91bGQg
YmUKCQkgKiBpbmRlcGVuZGFudGx5IGRlbGl2ZXJlZCB0byB0aGUgUk9VVEUgLS1ndy4KCQkgKi8K
CQlza2IgPSBza2JfY29weShwc2tiLCBHRlBfQVRPTUlDKTsKCQlpZiAoIXNrYikgewoJCQlpZiAo
bmV0X3JhdGVsaW1pdCgpKSAKCQkJCURFQlVHUChLRVJOX0RFQlVHICJpcHRfUk9VVEU6IGNvcHkg
ZmFpbGVkIVxuIik7CgkJCXJldHVybiBJUFRfQ09OVElOVUU7CgkJfQoJfQoKCS8qIFRlbGwgY29u
bnRyYWNrIHRvIGZvcmdldCB0aGlzIHBhY2tldCBzaW5jZSBpdCBtYXkgZ2V0IGNvbmZ1c2VkIAoJ
ICogd2hlbiBhIHBhY2tldCBpcyBsZWF2aW5nIHdpdGggZHN0IGFkZHJlc3MgPT0gb3VyIGFkZHJl
c3MuCgkgKiBHb29kIGlkZWEgPyBEdW5uby4gTmVlZCBhZHZpY2UuCgkgKgoJICogTkVXOiBtYXJr
IHRoZSBza2Igd2l0aCBvdXIgJnJvdXRlX3RlZV90cmFjaywgc28gd2UgYXZvaWQgbG9vcGluZwoJ
ICogb24gYW55IGFscmVhZHkgcm91dGVkIHBhY2tldC4KCSAqLwoJaWYgKCEocm91dGVfaW5mby0+
ZmxhZ3MgJiBJUFRfUk9VVEVfQ09OVElOVUUpKSB7CgkJbmZfY29ubnRyYWNrX3B1dChza2ItPm5m
Y3QpOwoJCXNrYi0+bmZjdCA9ICZyb3V0ZV90ZWVfdHJhY2suY3RfZ2VuZXJhbDsKCQlza2ItPm5m
Y3RpbmZvID0gSVBfQ1RfTkVXOwoJCW5mX2Nvbm50cmFja19nZXQoc2tiLT5uZmN0KTsKCX0KCglp
ZiAocm91dGVfaW5mby0+b2lmWzBdICE9ICdcMCcpIHsKCQlyZXMgPSByb3V0ZV9vaWYocm91dGVf
aW5mbywgc2tiKTsKCX0gZWxzZSBpZiAocm91dGVfaW5mby0+aWlmWzBdICE9ICdcMCcpIHsKCQly
ZXMgPSByb3V0ZV9paWYocm91dGVfaW5mbywgc2tiKTsKCX0gZWxzZSBpZiAocm91dGVfaW5mby0+
Z3cpIHsKCQlyZXMgPSByb3V0ZV9ndyhyb3V0ZV9pbmZvLCBza2IpOwoJfSBlbHNlIHsKCQlpZiAo
bmV0X3JhdGVsaW1pdCgpKSAKCQkJREVCVUdQKEtFUk5fREVCVUcgImlwdF9ST1VURTogbm8gcGFy
YW1ldGVyICFcbiIpOwoJCXJlcyA9IElQVF9DT05USU5VRTsKCX0KCglpZiAoKHJvdXRlX2luZm8t
PmZsYWdzICYgSVBUX1JPVVRFX1RFRSkpCgkJcmVzID0gSVBUX0NPTlRJTlVFOwoKCXJldHVybiBy
ZXM7Cn0KCgovKgogKiBXZSBhcmUgdXNpbmcgdGhlIG1hbmdsZSB0YWJsZSBidXQgd2UgYXJlIGFj
dHVhbGx5IG5vdCBtb2RpZnlpbmcgdGhlIHBhY2tldCwKICogYnV0IG1vZGlmeWluZyBpdHMgb3V0
cHV0IGRldmljZS4gSGVuY2Ugd2UgZG9uJ3QgcmVhbGx5IG5lZWQgdG8gY2hlY2sgCiAqIGFueXRo
aW5nLiBGb3IgdXMsIGFsbCBwYWNrZXRzIGFyZSB3ZWxjb21lLgogKi8KCnN0YXRpYyBib29sIApy
b3V0ZV90Z19jaGVja2VudHJ5KGNvbnN0IGNoYXIgKnRhYmxlbmFtZSwgY29uc3Qgdm9pZCAqZV92
b2lkLAoJCSAgICBjb25zdCBzdHJ1Y3QgeHRfdGFyZ2V0ICp0YXJnZXQsIHZvaWQgKnRhcmdpbmZv
LAoJCSAgICB1bnNpZ25lZCBpbnQgaG9va19tYXNrKQp7CglpZiAoc3RyY21wKHRhYmxlbmFtZSwg
Im1hbmdsZSIpICE9IDApIHsKCQlwcmludGsoImlwdF9ST1VURTogYmFkIHRhYmxlIGAlcycsIHVz
ZSB0aGUgYG1hbmdsZScgdGFibGUuXG4iLAoJCSAgICAgICB0YWJsZW5hbWUpOwoJCXJldHVybiBm
YWxzZTsKCX0KCi8qIE5vIG5lZWQgb2YgY29tcGFyaW5nIHRoZSBob29rLCB0aGV5IGRvbid0IGV4
aXN0IGluIGtlcm5lbCBzcGFjZSBhbnltb3JlLiAKICogT25seSBleGlzdCBpbiB1c2Vyc3BhY2Uu
IFRoZSBjaGVjayBhYm92ZSBmb3IgbWFuZ2xlIHRhYmxlIGlzIGFsc28gcmVkdW5kYW50IAogKi8K
CglpZiAoaG9va19tYXNrICYgfiggICgxIDw8IE5GX0lORVRfUFJFX1JPVVRJTkcpCgkJCSAgICB8
ICgxIDw8IE5GX0lORVRfTE9DQUxfSU4pCgkJCSAgICB8ICgxIDw8IE5GX0lORVRfRk9SV0FSRCkK
CQkJICAgIHwgKDEgPDwgTkZfSU5FVF9MT0NBTF9PVVQpCgkJCSAgICB8ICgxIDw8IE5GX0lORVRf
UE9TVF9ST1VUSU5HKSkpIHsKCQlwcmludGsoImlwdF9ST1VURTogYmFkIGhvb2tcbiIpOwoJCXJl
dHVybiBmYWxzZTsKCX0KCglyZXR1cm4gdHJ1ZTsKfQoKCnN0YXRpYyBzdHJ1Y3QgeHRfdGFyZ2V0
IHJvdXRlX3RnX3JlZyAgX19yZWFkX21vc3RseSA9IHsgCgkubmFtZSA9ICJST1VURSIsCgkuZmFt
aWx5ID0gQUZfSU5FVCwKCS50YXJnZXQgPSByb3V0ZV90ZywKCS50YXJnZXRzaXplID0gc2l6ZW9m
KHN0cnVjdCBpcHRfcm91dGVfdGFyZ2V0X2luZm8pLAoJLnRhYmxlID0gIm1hbmdsZSIsCgkuY2hl
Y2tlbnRyeSA9IHJvdXRlX3RnX2NoZWNrZW50cnksCgkubWUgPSBUSElTX01PRFVMRSwKfTsKCnN0
YXRpYyBpbnQgX19pbml0IGluaXQodm9pZCkKewoJLyogU2V0IHVwIGZha2UgY29ubnRyYWNrIChz
dG9sZW4gZnJvbSByYXcucGF0Y2gpOgoJICAgIC0gdG8gbmV2ZXIgYmUgZGVsZXRlZCwgbm90IGlu
IGFueSBoYXNoZXMgKi8KCWF0b21pY19zZXQoJnJvdXRlX3RlZV90cmFjay5jdF9nZW5lcmFsLnVz
ZSwgMSk7CgkvKiAgLSBhbmQgbG9vayBpdCBsaWtlIGFzIGEgY29uZmlybWVkIGNvbm5lY3Rpb24g
Ki8KCXNldF9iaXQoSVBTX0NPTkZJUk1FRF9CSVQsICZyb3V0ZV90ZWVfdHJhY2suc3RhdHVzKTsK
CS8qIEluaXRpYWxpemUgZmFrZSBjb25udHJhY2sgc28gdGhhdCBOQVQgd2lsbCBza2lwIGl0ICov
Cglyb3V0ZV90ZWVfdHJhY2suc3RhdHVzIHw9IElQU19OQVRfRE9ORV9NQVNLOwoKCXJldHVybiB4
dF9yZWdpc3Rlcl90YXJnZXQoJnJvdXRlX3RnX3JlZyk7Cn0KCgpzdGF0aWMgdm9pZCBfX2V4aXQg
ZmluaSh2b2lkKQp7Cgl4dF91bnJlZ2lzdGVyX3RhcmdldCgmcm91dGVfdGdfcmVnKTsKfQoKbW9k
dWxlX2luaXQoaW5pdCk7Cm1vZHVsZV9leGl0KGZpbmkpOwo=
--0016363b948edd00230463b5a09b--
