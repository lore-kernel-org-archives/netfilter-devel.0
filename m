From: Marek Mrva <mrva@eset.sk>
Subject: [ipset] hash:net,iface bug?
Date: Mon, 23 May 2016 11:25:59 +0000
Message-ID: <bc61b1ffc5fd4402bab9a533a1b2a384@BTS-XEXCH01-B.eset.corp>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from a.mx.eset.com ([91.228.165.113]:43960 "EHLO a.mx.eset.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752529AbcEWLbY convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 May 2016 07:31:24 -0400
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi guys,

I have been playing with hash:net,iface table for a couple of days now, but for the love of me, I can't make it accept physdev: devices.

The man says:
When the  interface  is  flagged  with physdev:, the interface is interpreted as the incoming/outgoing bridge port.

It all boils down to this code (for IPv4):

--- kernel/net/netfilter/ipset/ip_set_hash_netiface.c@154, ipset repository ---

static int
hash_netiface4_kadt(struct ip_set *set, const struct sk_buff *skb,
                    const struct xt_action_param *par,
                    enum ipset_adt adt, struct ip_set_adt_opt *opt)
{
--- snip ---
        if (opt->cmdflags & IPSET_FLAG_PHYSDEV) {
#if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
                const char *eiface = SRCDIR ? get_physindev_name(skb) :
                                              get_physoutdev_name(skb);

                if (!eiface)
                        return -EINVAL;
                STRLCPY(e.iface, eiface);
                e.physdev = 1;
#endif
        } else {
                STRLCPY(e.iface, SRCDIR ? IFACE(in) : IFACE(out));
        }
--- snip ---
}

The IPSET_FLAG_PHYSDEV (value 2) is never set, nor could I find any useful references to it (I tried really hard). I believe this code never obtains the "physical" (bridge) port.
opt->cmdflags (probably?) contains flags passed to ipset code by iptables. I've seen these values used:

1	-j SET --exists
8	-m set ! --update-counters
16	-m set ! --update-subcounters
32	-m set --bytes-lt (or any other combination of bytes/packets)
128	-m set --return-nomatch

The table resembling it most closely is this one:

--- include/libipset/linux_ip_set.h@159, ipset repository ---

/* Flags at command level or match/target flags, lower half of cmdattrs*/
enum ipset_cmd_flags {
        IPSET_FLAG_BIT_EXIST    = 0,
        IPSET_FLAG_EXIST        = (1 << IPSET_FLAG_BIT_EXIST),
        IPSET_FLAG_BIT_LIST_SETNAME = 1,
        IPSET_FLAG_LIST_SETNAME = (1 << IPSET_FLAG_BIT_LIST_SETNAME),
        IPSET_FLAG_BIT_LIST_HEADER = 2,
        IPSET_FLAG_LIST_HEADER  = (1 << IPSET_FLAG_BIT_LIST_HEADER),
        IPSET_FLAG_BIT_SKIP_COUNTER_UPDATE = 3,
        IPSET_FLAG_SKIP_COUNTER_UPDATE =
                (1 << IPSET_FLAG_BIT_SKIP_COUNTER_UPDATE),
        IPSET_FLAG_BIT_SKIP_SUBCOUNTER_UPDATE = 4,
        IPSET_FLAG_SKIP_SUBCOUNTER_UPDATE =
                (1 << IPSET_FLAG_BIT_SKIP_SUBCOUNTER_UPDATE),
        IPSET_FLAG_BIT_MATCH_COUNTERS = 5,
        IPSET_FLAG_MATCH_COUNTERS = (1 << IPSET_FLAG_BIT_MATCH_COUNTERS),
        IPSET_FLAG_BIT_RETURN_NOMATCH = 7,
        IPSET_FLAG_RETURN_NOMATCH = (1 << IPSET_FLAG_BIT_RETURN_NOMATCH),
        IPSET_FLAG_BIT_MAP_SKBMARK = 8,
        IPSET_FLAG_MAP_SKBMARK = (1 << IPSET_FLAG_BIT_MAP_SKBMARK),
        IPSET_FLAG_BIT_MAP_SKBPRIO = 9,
        IPSET_FLAG_MAP_SKBPRIO = (1 << IPSET_FLAG_BIT_MAP_SKBPRIO),
        IPSET_FLAG_BIT_MAP_SKBQUEUE = 10,
        IPSET_FLAG_MAP_SKBQUEUE = (1 << IPSET_FLAG_BIT_MAP_SKBQUEUE),
        IPSET_FLAG_CMD_MAX = 15,
};

If that is correct, the IPSET_FLAG_LIST_SETNAME should be responsible for using PHYSDEV. I tried searching for this flag, but was unable to find a place where it is set.

Any ideas on this are very welcome :)


M.

