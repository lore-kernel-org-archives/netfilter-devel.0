From: Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH nf-next v2 3/3] netfilter: nf_conntrack: add efficient
 mark to zone mapping
Date: Wed, 15 Jul 2015 22:04:40 +0200
Message-ID: <55A6BCD8.2010905@iogearbox.net>
References: <cover.1436574843.git.daniel@iogearbox.net> <8b1e8907e8dd9a51f2e40b39cd5f5c2b0eae94fd.1436574843.git.daniel@iogearbox.net> <20150715175056.GA7436@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: tgraf@suug.ch, challa@noironetworks.com,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:53896 "EHLO
	www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285AbbGOUEn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jul 2015 16:04:43 -0400
In-Reply-To: <20150715175056.GA7436@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 07/15/2015 07:50 PM, Pablo Neira Ayuso wrote:
> On Sat, Jul 11, 2015 at 03:14:07AM +0200, Daniel Borkmann wrote:
>> This work adds the possibility of deriving the zone id from the skb->mark
>> field in a scalable manner. This allows for having only a single template
>> serving 100s .. 1000s of different zones, for example, instead of needing
>> to have one match for each zone as an extra CT jump target. Note that we'd
>> need to have this information attached to the template as at the time when
>> we're trying to lookup a possible ct object, we already need to know zone
>> information for a possible match when going into __nf_conntrack_find_get().
>> This work provides a minimal implementation for a possible mapping.
>
> I think connmark is a better place for this feature, given that the
> zone is a ct extension. Moreover, I guess it will not take long until
> someone sends us a patch to perform some bitwise operation to only
> fetch some of the skb->mark bits into the zone.

Hm, we do need the zoning information *before* we do the actual lookup for
a ct object (non-template I mean), otherwise we don't know in which zone to
find it. When I looked into this, the connmark target is applied afterwards
on the actual ct object.

So you mean to add this to the raw table, so that someone could for each skb
assign ct->mark := skb->mark on the template and then have zone := ct->mark,
so we can use it for looking up? I would also need more than a single template
for that, right, as otherwise if I'd have arbitrary ct->mark := skb->mark
assignments in parallel, then we'd race. The current seems rather simple.

Thanks,
Daniel
