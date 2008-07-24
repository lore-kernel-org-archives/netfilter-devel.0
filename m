From: Patrick McHardy <kaber@trash.net>
Subject: Re: POM Xtables???
Date: Thu, 24 Jul 2008 11:43:47 +0200
Message-ID: <48884ED3.8080901@trash.net>
References: <935fab200806271054oa7c340evbf465b7a9984498b@mail.gmail.com>	 <alpine.LNX.1.10.0806272003170.12725@fbirervta.pbzchgretzou.qr>	 <4866F152.7030109@riverviewtech.net>	 <935fab200806300904rc7dc7b2kf58ab7893c3ef20a@mail.gmail.com>	 <486907EA.60105@trash.net>	 <alpine.LNX.1.10.0806302218500.30639@fbirervta.pbzchgretzou.qr>	 <48694787.3080906@trash.net>	 <alpine.LNX.1.10.0807010907040.26892@fbirervta.pbzchgretzou.qr>	 <4887BCE0.2050902@trash.net> <38bcb3ec0807240131n1f5d4051k9e89731aa2fcb6c9@mail.gmail.com> <488849A5.6050401@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: James King <t.james.king@gmail.com>,
	Jan Engelhardt <jengelh@medozas.de>,
	Dave <finalglide@gmail.com>, netfilter@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62316 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbYGXJnw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Jul 2008 05:43:52 -0400
In-Reply-To: <488849A5.6050401@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> James King wrote:
>> On Wed, Jul 23, 2008 at 4:21 PM, Patrick McHardy wrote:
>>
>>> Just send it to netfilter-devel. If its the thing with lots
>>> of hard-coded binary matches full of magic values I'm not
>>> interested :) I'd be more interested in a discussion what
>>> would be necessary to represent all those matches through
>>> the FSM textsearch match or something similar.
 >>
>> ipp2p is the one with hard coded magic values.
>>
>> What are your feelings on the kernel version of l7filter (regex
>> patterns loaded from the filesystem)?  Currently it requires a patch
>> to add a structure to nf_conn, but I've been meaning to rewrite it to
>> use ct_extend so that it could at least be included into xtables-addon
>> and used with a stock kernel, although if there's interest in having
>> it merged into mainline I'd be willing to focus on that.

That is definitely a much better way than to hardcode the
matches. I think there is some interest in having this in
the kernel, yes.

>> One thing
>> I'm not sure of is whether the license used by the Henry Spencer regex
>> library it depends on is acceptable by kernel standards (or whether
>> it's permissive enough to relicense under GPL, as IANAL).

I know of the regexp.old.zip library, which IIRC used a GPL
compatible license (and a non-POSIX conform interface).

> If we want to do this in-kernel I think that it's better if it must use
> the textsearch infrastructure. Probably it would require some patches to
> extend the existing infrastructure.

I'd also prefer that over adding a regex library to the kernel.
I think one of the bigger problems is that there are dependencies
in the match that can't be easily expressed, like "byte 4 has
skb->len - 10". At least ipp2p does something like that. But
maybe thats not necessary, since l7filter already uses regexes
there's apparently a different method for doing this.

It would be useful if someone could post an excerpt from the
l7filter expressions or simply the entire patch.

> The other choise is userspace by means NFQUEUE. If we use some
> heuristics, we may try to classify the traffic by means of the initial
> data packets and then mark the connection. Thus, the number of packets
> that go to userspace would be small and the classification logic is
> implemented in userspace using whatever regex
> engine/aho-corasick/bit-wise/boyer-moore/bayes whatsoever...

Yes, thats another possibilty (and a lot of people are doing
that), but it would still be nice to have a mechanism for
doing this in the kernel.

