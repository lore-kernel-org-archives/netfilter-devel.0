From: Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH nf-next v3 1/3] netfilter: nf_conntrack: push zone object
 into functions
Date: Wed, 05 Aug 2015 16:00:29 +0200
Message-ID: <55C216FD.7080900@iogearbox.net>
References: <cover.1437561897.git.daniel@iogearbox.net> <2f95183cf2520b93d8443be935372fbef3499b96.1437561897.git.daniel@iogearbox.net> <20150730160744.GA15008@salvia> <55BA5228.6050908@iogearbox.net> <20150803155909.GA17212@salvia> <55BF9023.3050505@iogearbox.net> <20150805105126.GA3996@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: tgraf@suug.ch, challa@noironetworks.com,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:51938 "EHLO
	www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbbHEOAf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Aug 2015 10:00:35 -0400
In-Reply-To: <20150805105126.GA3996@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 08/05/2015 12:51 PM, Pablo Neira Ayuso wrote:
> On Mon, Aug 03, 2015 at 06:00:35PM +0200, Daniel Borkmann wrote:
>> On 08/03/2015 05:59 PM, Pablo Neira Ayuso wrote:
>>> On Thu, Jul 30, 2015 at 06:34:48PM +0200, Daniel Borkmann wrote:
>>>> CTA_ZONE_DIR seems better, sure. I don't have any other extensions at
>>>> the moment, but it seems it makes sense to make this nested at this
>>>> point in time, so we have CTA_ZONE and CTA_ZONE_INFO as a container
>>>> for CTA_ZONE_DIR and whatever future might bring. I will look into it.
>>>
>>> thinking it well, this is part of the tuple, so I'd suggest you add
>>> CTA_TUPLE_ZONE to enum ctattr_tuple. We will probably need later to
>>> place each tuple in different zones.
>>
>> That's fine with me, will do after your tree rebase.
>
> Just pushed out a fresh copy with net-next into nf-next.

Cool, thanks, will move on with my rework/base of the set then!

> Daniel, a minor change that I came up with. With your patchset, the
> configurations that we accept look like:
>
>          zone original=Value     reply=0
>          zone original=0         reply=Value

Yes, the full picture is ...

   zone   original=Value     reply=Default
   zone   original=Default   reply=Value
   zone   original=Value     reply=Value
   zone   original=Default   reply=Default

... where Default (== 0) is to be understood "zone unspecified".

> But thinking on Thomas' requirements to limit the number of conntracks
> per zone, I think another valid configuration (and more generic) can
> be:
>
>          zone original=ValueX    reply=ValueY
>
> So we don't assume that the original or reply zone is always zero.
>
> The zone extension are that look like this:
>
> struct nf_conntrack_zone {
>          u16     id[IP_CT_DIR_MAX];
> };
>
> And we don't need to store the direction. To keep backward
> compatibility we can set the id in both directions to the same value.
>
> Can you see any problem with this approach? I think it should require
> just a little adjustment to you patchset. Thanks.

Don't yet see the bigger picture how this would relate to limiting the
number of conntrack entries per zone, but I also haven't thought deeply
on an implementation of that issue. A zone ValueX and ValueY where
ValueX != ValueY in different directions would imply fully overlapping
tuples in both directions, or only partially shared/common pools for
tuple allocations in the opposite directions.

Anyway, this would mean that instead of a simple direction flag as we
currently have, we'd need new revisions to add either two more zone ids
to uapi structs or a flag and a 2nd zone id field, if we want to reuse
the first zone field, and similarly also for the netlink interfaces.

On the mark to zone mapping, we would then need to fill the whole
id[IP_CT_DIR_MAX] on the template, which seems a little more problematic
to me.

This would probably mean we have to split the mark's bit space into
two 16 bit parts  (f.e. mark := (ValueX << 16) | ValueY)) to fill both
directions depending from which side we arrive.

The entity setting the mark would need to shift its own id encoding
into the correct direction in the mark and would leave the other one as
default zone (== 0) if unaware of it? Then, the problem is that the
/first/ one creating the conntrack entry does need to know ValueX /and/
ValueY, if later on we want to retrieve the entry again via zone ValueY.

This mark bit shifting seems rather inconvenient to use, imho. If ValueY
can be dymanic, perhaps then the one triggering the initial packet might
not even know which one to arrive in yet?

One could still add a direction parameter in the zone struct to know
where to apply the mark, if we don't want to encode both ids, and to
have the other one 0 to not expose this burden to the user. But that
means ValueY is static to 0 in this case, which seems undesired here.

So it looks actually a bit of a more complex change (/configuration),
doesn't seem to integrate as 'straight-forward' as the current approach,
but also targets a bit of a different use case (?) than this current set
does. Note that the current set doesn't ban us either from modifications
later on. Please let me know if I'm wrong somewhere, but given the above
issues, I would be happy to stick with the current approach instead,
with your feedback integrated from your other mails, of course.

Thanks,
Daniel
