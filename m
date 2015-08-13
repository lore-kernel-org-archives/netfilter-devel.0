From: Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH v4 2/3] netfilter: nf_conntrack: add direction support
 for zones
Date: Thu, 13 Aug 2015 12:26:00 +0200
Message-ID: <55CC70B8.1050808@iogearbox.net>
References: <cover.1439059434.git.daniel@iogearbox.net> <b251daed7eaaaf751e0bf0104389e57876d5a1ba.1439059435.git.daniel@iogearbox.net> <20150812174805.GA31037@salvia> <55CBA6F7.1040102@iogearbox.net> <20150813094633.GA4025@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: tgraf@suug.ch, challa@noironetworks.com,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:53959 "EHLO
	www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbbHMK0F (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Aug 2015 06:26:05 -0400
In-Reply-To: <20150813094633.GA4025@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 08/13/2015 11:50 AM, Pablo Neira Ayuso wrote:
> On Wed, Aug 12, 2015 at 10:05:11PM +0200, Daniel Borkmann wrote:
> [...]
>> But you are basically saying to add the nested CTA_TUPLE_ZONE container here,
>> that is part of a nested CTA_TUPLE_ORIG and/or CTA_TUPLE_REPLY attribute ...
>>
>> enum ctattr_tuple {
>> 	CTA_TUPLE_UNSPEC,
>> 	CTA_TUPLE_IP,
>> 	CTA_TUPLE_PROTO,
>> 	CTA_TUPLE_ZONE,  <---
>> 	__CTA_TUPLE_MAX
>> };
>
> Right.
>
>> ... where CTA_TUPLE_ZONE would be a container for further attributes, say
>> CTA_TUPLE_ZONE_ID, which is then the actual NLA_U16 zone id, right?
>
> Question is if we really need a nested attribute or not here, we've
> been discussing this before but future requirements are not clear. I
> think it would be good to keep those in mind to enhance this the right
> way.
>
> So, going back to this, I think the idea is to add new commands to
> ctnetlink to create zone objects with specific settings at some point,
> so we get three new enum cntl_msg_types.
>
>          IPCTNL_MSG_CT_NEW_ZONE
>          IPCTNL_MSG_CT_GET_ZONE
>          IPCTNL_MSG_CT_DEL_ZONE
>
> These new messages allow us to create/delete/retrieve custom zones
> with specific settings, each zone can be represented by:
>
> enum ctattr_zone {
>          CTA_ZONE_UNSPEC,
>          CTA_ZONE_ID,
>          CTA_ZONE_CONFIG,
>          __CTA_ZONE_MAX
> };
>
> The CTA_ZONE_CONFIG is a nested attribute with specific configuration
> for this zone, eg. the maximum number of connections.
>
> The custom zone can be used from the CT target, so we not only set a
> zone ID to the conntrack but we also can attach configurations.
>
> There's a problem though: By the time -j CT --zone X is loaded, the
> zone ID may not exists, so we need a new --zone-template X to
> explicitly refer to zones that are created via ctnetlink.

Yes, right. So the above makes sense to me. You would create zones with a
specific configuration attached over a separate interface.

And then, you could use the CTA_ZONE or CTA_TUPLE_ZONE (both NLA_U16 attrs
that represent the zone id) to look up a specific zone to be used. As a result,
that would mean, it might be best to have CTA_TUPLE_ZONE as NLA_U16. Seems a
clean way forward to me.

>> So, we'd have a zone id spread in 3 possible places, and additional (future)
>> meta data spread around in 2 possible places, hmm ... Okay, lets say, we'd
>> add future attribute X and Y to zones. Now, if I want a zone only in ORIG
>> dir or only in REPLY dir, that works fine from ctnetlink perspective, even
>> with your idea that there could be two different non-default zones entirely.
>
> If we ever get connection limiting per zone as Thomas suggested during
> NFWS, I think we may well have two different non-default zones, what
> it comes to my mind is a simple scenario with two uplinks, each uplink
> becomes a zone with different connection limits.
>
>> But, lets say I just want to use a traditional zones config (as in: nowadays)
>> and have my tuple for /one/ particular zone id that is the same in /both/
>> directions. That would mean I have to duplicate my parameters X and Y across
>> CTA_TUPLE_ORIG and CTA_TUPLE_REPLY, right? Or, we'd add a third attribute
>> set (as in: CTA_ZONE_INFO) only for the single zone in both directions?
>
> CTA_ZONE can still be used to set a zone for both directions, we can
> get rid of that. The new CTA_TUPLE_ZONE allows you to set the zone at
> per-tuple level. We only have to be careful on how to interpret if the
> user sends us two of them that have overlapping semantics.

Right, we'd need to reject conflicting configurations, of course.

>> So far I find the current approach a bit cleaner to be honest (I can, of
>> course, still change the CTA_TUPLE_ZONE back into CTA_ZONE_INFO name) ...
>> but when the time comes where someone really should need two /non-default/
>> zones for a single tuple, don't we need a global setting as in this patch
>> here anyway (due to reasons above)? (I'm fine either way, I'm just asking on
>> how we want to handle this in an ideal/clean way.)
>>
>> ...
>>> I'd suggest the output shows the zone on the corresponding tuple, eg.
>>> in case it only applies to the original tuple:
>>>
>>> udp      17 29 src=192.168.2.195 dst=192.168.2.1 sport=40446 dport=53 zone=1 \
>>>                 src=192.168.2.1 dst=192.168.2.195 sport=53 dport=40446 [ASSURED] mark=0 use=1
>>>
>>> We have a more compact output IMO.
>>
>> Okay, that's fine by me. It would mean we'd see zone=1 twice in case a
>> direction was not specified (thus, both directions apply), but I think
>> that should be totally okay for the stand-alone interface (and in future
>> conntrack -L).
>
> I think we can leave it the same way it looks now when the zone
> applies to two directions, but looking at this output now this may
> look ambiguous when the zone is in the reply tuple, so I think we have
> to add different tags, ie.
>
> 1) When the zone is used from the original tuple:
>
> udp      17 29 src=192.168.2.195 dst=192.168.2.1 sport=40446 dport=53 zone-orig=1 \
>                 src=192.168.2.1 dst=192.168.2.195 sport=53 dport=40446 [ASSURED] mark=0 use=1
>
> 2) When used from the reply tuple:
>
> udp      17 29 src=192.168.2.195 dst=192.168.2.1 sport=40446 dport=53 \
>                 src=192.168.2.1 dst=192.168.2.195 sport=53 dport=40446 zone-reply=X [ASSURED] mark=0 use=1
>
> 3) When used in both (existing output):
>
> udp      17 29 src=192.168.2.195 dst=192.168.2.1 sport=40446 dport=53 \
>                 src=192.168.2.1 dst=192.168.2.195 sport=53 dport=40446 [ASSURED] mark=0 zone=1 use=1

Agreed, sounds good. Will change it into this representation.

Thanks Pablo!

Best,
Daniel
