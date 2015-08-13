From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v4 2/3] netfilter: nf_conntrack: add direction support
 for zones
Date: Thu, 13 Aug 2015 11:50:25 +0200
Message-ID: <20150813094633.GA4025@salvia>
References: <cover.1439059434.git.daniel@iogearbox.net>
 <b251daed7eaaaf751e0bf0104389e57876d5a1ba.1439059435.git.daniel@iogearbox.net>
 <20150812174805.GA31037@salvia>
 <55CBA6F7.1040102@iogearbox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tgraf@suug.ch, challa@noironetworks.com,
	netfilter-devel@vger.kernel.org
To: Daniel Borkmann <daniel@iogearbox.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38496 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752395AbbHMJoP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Aug 2015 05:44:15 -0400
Content-Disposition: inline
In-Reply-To: <55CBA6F7.1040102@iogearbox.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 12, 2015 at 10:05:11PM +0200, Daniel Borkmann wrote:
[...]
> But you are basically saying to add the nested CTA_TUPLE_ZONE container here,
> that is part of a nested CTA_TUPLE_ORIG and/or CTA_TUPLE_REPLY attribute ...
> 
> enum ctattr_tuple {
> 	CTA_TUPLE_UNSPEC,
> 	CTA_TUPLE_IP,
> 	CTA_TUPLE_PROTO,
> 	CTA_TUPLE_ZONE,  <---
> 	__CTA_TUPLE_MAX
> };

Right.

> ... where CTA_TUPLE_ZONE would be a container for further attributes, say
> CTA_TUPLE_ZONE_ID, which is then the actual NLA_U16 zone id, right?

Question is if we really need a nested attribute or not here, we've
been discussing this before but future requirements are not clear. I
think it would be good to keep those in mind to enhance this the right
way.

So, going back to this, I think the idea is to add new commands to
ctnetlink to create zone objects with specific settings at some point,
so we get three new enum cntl_msg_types.

        IPCTNL_MSG_CT_NEW_ZONE
        IPCTNL_MSG_CT_GET_ZONE
        IPCTNL_MSG_CT_DEL_ZONE

These new messages allow us to create/delete/retrieve custom zones
with specific settings, each zone can be represented by:

enum ctattr_zone {
        CTA_ZONE_UNSPEC,
        CTA_ZONE_ID,
        CTA_ZONE_CONFIG,
        __CTA_ZONE_MAX
};

The CTA_ZONE_CONFIG is a nested attribute with specific configuration
for this zone, eg. the maximum number of connections.

The custom zone can be used from the CT target, so we not only set a
zone ID to the conntrack but we also can attach configurations.

There's a problem though: By the time -j CT --zone X is loaded, the
zone ID may not exists, so we need a new --zone-template X to
explicitly refer to zones that are created via ctnetlink.

> So, we'd have a zone id spread in 3 possible places, and additional (future)
> meta data spread around in 2 possible places, hmm ... Okay, lets say, we'd
> add future attribute X and Y to zones. Now, if I want a zone only in ORIG
> dir or only in REPLY dir, that works fine from ctnetlink perspective, even
> with your idea that there could be two different non-default zones entirely.

If we ever get connection limiting per zone as Thomas suggested during
NFWS, I think we may well have two different non-default zones, what
it comes to my mind is a simple scenario with two uplinks, each uplink
becomes a zone with different connection limits.

> But, lets say I just want to use a traditional zones config (as in: nowadays)
> and have my tuple for /one/ particular zone id that is the same in /both/
> directions. That would mean I have to duplicate my parameters X and Y across
> CTA_TUPLE_ORIG and CTA_TUPLE_REPLY, right? Or, we'd add a third attribute
> set (as in: CTA_ZONE_INFO) only for the single zone in both directions?

CTA_ZONE can still be used to set a zone for both directions, we can
get rid of that. The new CTA_TUPLE_ZONE allows you to set the zone at
per-tuple level. We only have to be careful on how to interpret if the
user sends us two of them that have overlapping semantics.

> So far I find the current approach a bit cleaner to be honest (I can, of
> course, still change the CTA_TUPLE_ZONE back into CTA_ZONE_INFO name) ...
> but when the time comes where someone really should need two /non-default/
> zones for a single tuple, don't we need a global setting as in this patch
> here anyway (due to reasons above)? (I'm fine either way, I'm just asking on
> how we want to handle this in an ideal/clean way.)
> 
> ...
> >I'd suggest the output shows the zone on the corresponding tuple, eg.
> >in case it only applies to the original tuple:
> >
> >udp      17 29 src=192.168.2.195 dst=192.168.2.1 sport=40446 dport=53 zone=1 \
> >                src=192.168.2.1 dst=192.168.2.195 sport=53 dport=40446 [ASSURED] mark=0 use=1
> >
> >We have a more compact output IMO.
> 
> Okay, that's fine by me. It would mean we'd see zone=1 twice in case a
> direction was not specified (thus, both directions apply), but I think
> that should be totally okay for the stand-alone interface (and in future
> conntrack -L).

I think we can leave it the same way it looks now when the zone
applies to two directions, but looking at this output now this may
look ambiguous when the zone is in the reply tuple, so I think we have
to add different tags, ie.

1) When the zone is used from the original tuple:

udp      17 29 src=192.168.2.195 dst=192.168.2.1 sport=40446 dport=53 zone-orig=1 \
               src=192.168.2.1 dst=192.168.2.195 sport=53 dport=40446 [ASSURED] mark=0 use=1

2) When used from the reply tuple:

udp      17 29 src=192.168.2.195 dst=192.168.2.1 sport=40446 dport=53 \
               src=192.168.2.1 dst=192.168.2.195 sport=53 dport=40446 zone-reply=X [ASSURED] mark=0 use=1

3) When used in both (existing output):

udp      17 29 src=192.168.2.195 dst=192.168.2.1 sport=40446 dport=53 \
               src=192.168.2.1 dst=192.168.2.195 sport=53 dport=40446 [ASSURED] mark=0 zone=1 use=1

> >Please, don't forget that you also have to update
> >libnetfilter_conntrack and conntrack to get this feature available
> >from there. I'll take this patchset to the kernel so you have the time
> >to update the userspace side later on without blocking this further.
> 
> Thanks, yes, after Plumbers I'll add proper support for both.
> 
> For testing that the netlink interface works, I had a local hack, but
> will get properly ready after the kernel and iptables patches. Was planning
> to do this anyway.

Thanks, the userspace chunks are also good to have, many people rely
on the ctnetlink interface already and the userspace utilities to
interact with it.
