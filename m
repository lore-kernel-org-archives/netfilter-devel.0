From: Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH v4 2/3] netfilter: nf_conntrack: add direction support
 for zones
Date: Wed, 12 Aug 2015 22:05:11 +0200
Message-ID: <55CBA6F7.1040102@iogearbox.net>
References: <cover.1439059434.git.daniel@iogearbox.net> <b251daed7eaaaf751e0bf0104389e57876d5a1ba.1439059435.git.daniel@iogearbox.net> <20150812174805.GA31037@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: tgraf@suug.ch, challa@noironetworks.com,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:39780 "EHLO
	www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbbHLUFT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Aug 2015 16:05:19 -0400
In-Reply-To: <20150812174805.GA31037@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

thanks a lot for applying patch 1/3!

On 08/12/2015 07:48 PM, Pablo Neira Ayuso wrote:
...
> On Sat, Aug 08, 2015 at 09:40:02PM +0200, Daniel Borkmann wrote:
>> diff --git a/include/uapi/linux/netfilter/nfnetlink_conntrack.h b/include/uapi/linux/netfilter/nfnetlink_conntrack.h
>> index acad6c5..3bf4cb0 100644
>> --- a/include/uapi/linux/netfilter/nfnetlink_conntrack.h
>> +++ b/include/uapi/linux/netfilter/nfnetlink_conntrack.h
>> @@ -53,6 +53,7 @@ enum ctattr_type {
>>   	CTA_MARK_MASK,
>>   	CTA_LABELS,
>>   	CTA_LABELS_MASK,
>> +	CTA_TUPLE_ZONE,
>
> I remember to have suggested to place this in ctattr_tuple:
>
> http://www.spinics.net/lists/netfilter-devel/msg37593.html
>
> The zone is part of the tuple in an optional fashion, so it should
> appear there. The direction is already implicit based on
> CTA_TUPLE_ORIG or CTA_TUPLE_REPLY.

Sorry, seems like I totally misunderstood your email. :/

I thought to place a CTA_ZONE_DIR attribute into a new nested CTA_TUPLE_ZONE
container, where also possible future meta data can be placed there.

Thus, we'd have CTA_ZONE as the id itself and CTA_TUPLE_ZONE with additional
optional data related to the zone, but it seems this was your /initial/
suggestion (modulo the attribute name). I actually find this approach quite
reasonable, probably that's why my mind stuck to it too much. ;)

But you are basically saying to add the nested CTA_TUPLE_ZONE container here,
that is part of a nested CTA_TUPLE_ORIG and/or CTA_TUPLE_REPLY attribute ...

enum ctattr_tuple {
	CTA_TUPLE_UNSPEC,
	CTA_TUPLE_IP,
	CTA_TUPLE_PROTO,
	CTA_TUPLE_ZONE,  <---
	__CTA_TUPLE_MAX
};

... where CTA_TUPLE_ZONE would be a container for further attributes, say
CTA_TUPLE_ZONE_ID, which is then the actual NLA_U16 zone id, right?

So, we'd have a zone id spread in 3 possible places, and additional (future)
meta data spread around in 2 possible places, hmm ... Okay, lets say, we'd
add future attribute X and Y to zones. Now, if I want a zone only in ORIG
dir or only in REPLY dir, that works fine from ctnetlink perspective, even
with your idea that there could be two different non-default zones entirely.

But, lets say I just want to use a traditional zones config (as in: nowadays)
and have my tuple for /one/ particular zone id that is the same in /both/
directions. That would mean I have to duplicate my parameters X and Y across
CTA_TUPLE_ORIG and CTA_TUPLE_REPLY, right? Or, we'd add a third attribute
set (as in: CTA_ZONE_INFO) only for the single zone in both directions?

So far I find the current approach a bit cleaner to be honest (I can, of
course, still change the CTA_TUPLE_ZONE back into CTA_ZONE_INFO name) ...
but when the time comes where someone really should need two /non-default/
zones for a single tuple, don't we need a global setting as in this patch
here anyway (due to reasons above)? (I'm fine either way, I'm just asking on
how we want to handle this in an ideal/clean way.)

...
> I'd suggest the output shows the zone on the corresponding tuple, eg.
> in case it only applies to the original tuple:
>
> udp      17 29 src=192.168.2.195 dst=192.168.2.1 sport=40446 dport=53 zone=1 \
>                 src=192.168.2.1 dst=192.168.2.195 sport=53 dport=40446 [ASSURED] mark=0 use=1
>
> We have a more compact output IMO.

Okay, that's fine by me. It would mean we'd see zone=1 twice in case a
direction was not specified (thus, both directions apply), but I think
that should be totally okay for the stand-alone interface (and in future
conntrack -L).

> Please, don't forget that you also have to update
> libnetfilter_conntrack and conntrack to get this feature available
> from there. I'll take this patchset to the kernel so you have the time
> to update the userspace side later on without blocking this further.

Thanks, yes, after Plumbers I'll add proper support for both.

For testing that the netlink interface works, I had a local hack, but
will get properly ready after the kernel and iptables patches. Was planning
to do this anyway.

Thanks again,
Daniel
