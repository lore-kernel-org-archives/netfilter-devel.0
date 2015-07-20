From: Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH nf-next v2 3/3] netfilter: nf_conntrack: add efficient
 mark to zone mapping
Date: Mon, 20 Jul 2015 18:18:55 +0200
Message-ID: <55AD1F6F.1090607@iogearbox.net>
References: <cover.1436574843.git.daniel@iogearbox.net> <8b1e8907e8dd9a51f2e40b39cd5f5c2b0eae94fd.1436574843.git.daniel@iogearbox.net> <20150715175056.GA7436@salvia> <55A6BCD8.2010905@iogearbox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: tgraf@suug.ch, challa@noironetworks.com,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:36991 "EHLO
	www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbbGTQTA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Jul 2015 12:19:00 -0400
In-Reply-To: <55A6BCD8.2010905@iogearbox.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 07/15/2015 10:04 PM, Daniel Borkmann wrote:
> On 07/15/2015 07:50 PM, Pablo Neira Ayuso wrote:
>> On Sat, Jul 11, 2015 at 03:14:07AM +0200, Daniel Borkmann wrote:
>>> This work adds the possibility of deriving the zone id from the skb->mark
>>> field in a scalable manner. This allows for having only a single template
>>> serving 100s .. 1000s of different zones, for example, instead of needing
>>> to have one match for each zone as an extra CT jump target. Note that we'd
>>> need to have this information attached to the template as at the time when
>>> we're trying to lookup a possible ct object, we already need to know zone
>>> information for a possible match when going into __nf_conntrack_find_get().
>>> This work provides a minimal implementation for a possible mapping.
>>
>> I think connmark is a better place for this feature, given that the
>> zone is a ct extension. Moreover, I guess it will not take long until
>> someone sends us a patch to perform some bitwise operation to only
>> fetch some of the skb->mark bits into the zone.
>
> Hm, we do need the zoning information *before* we do the actual lookup for
> a ct object (non-template I mean), otherwise we don't know in which zone to
> find it. When I looked into this, the connmark target is applied afterwards
> on the actual ct object.
>
> So you mean to add this to the raw table, so that someone could for each skb
> assign ct->mark := skb->mark on the template and then have zone := ct->mark,
> so we can use it for looking up? I would also need more than a single template
> for that, right, as otherwise if I'd have arbitrary ct->mark := skb->mark
> assignments in parallel, then we'd race. The current seems rather simple.

Sorry to bug you again on this patchset. I've been thinking a bit more
about your suggestion, my previous thoughts/reply on this, and how to move
forward. Lets presume for a moment, we would indeed place this into the
connmark target.

That would mean, we want to store the mark from the skb first into ct->mark
and then into the zone of the ct. We would need to do this on the template
itself, so that when the packet comes in, we know in which zone we're going
to do the actual lookup of a ct entry. When using a single, global template,
this seems racy, you would at least need to make sure that during the lookup
it's not being overwritten by other incoming skbs. If you say, the ct->mark
assignment should be skipped and the skb->mark should directly be assigned
to the zone, then why putting this into connmark as it has nothing to do with
the connection mark anymore (it would also avoid further unnecessary dependency
of NF_CONNTRACK_ZONES on NF_CONNTRACK_MARK and NETFILTER_XT_CONNMARK). But
also here, we'd have the same race issues as mentioned with ct->mark when
overwriting zone ids. The only thing I could imagine would be for the template
to hold a possible mask in the ct->mark itself, which could be user configured,
and then does in pseudocode, tmpl_zone->id := skb->mark & tmpl->mark. If
someone would really have such a use case (?), fair enough, this could be
followed-up.

The current approach implemented here that I found so far most appealing
and having the least complexity, was to just have a /single/ template and to
overwrite the zone->id with skb->mark on the ptr we have sitting on the stack.
It avoids all the issues mentioned. But perhaps you mean something entirely
different and I just seem to misinterpret your answer, hmm.

Thanks again, Pablo.
