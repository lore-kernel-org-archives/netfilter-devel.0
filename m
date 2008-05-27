From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/3] set SEEN_REPLY before destroying conntrack on TCP
 RST
Date: Tue, 27 May 2008 16:48:52 +0200
Message-ID: <483C1F54.6040505@trash.net>
References: <1211447601.6878.38.camel@pumper.lan.luxnet.ch> <1211826305.19222.8.camel@pumper.lan.luxnet.ch> <483B93C2.1000905@trash.net> <483C1B9D.5060705@gmx.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Fabian Hugelshofer <hugelshofer2006@gmx.ch>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55777 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755932AbYE0Osy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 May 2008 10:48:54 -0400
In-Reply-To: <483C1B9D.5060705@gmx.ch>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46abian Hugelshofer wrote:
> Patrick McHardy wrote:
>> Fabian Hugelshofer wrote:
>>> On Thu, 2008-05-22 at 10:13 +0100, Fabian Hugelshofer wrote:
>>>> =EF=BB=BFIf a connection fails with a TCP reset, the conntrack is =
destroyed=20
>>>> immediately. This patch sets the SEEN_REPLY bit before destroying=20
>>>> the conntrack.
>>>
>>> This updated version also increments the accounting counters.
>>
>> Thanks, but this needs to be changed slightly.
> [...]
>> I think a better way is to encapsulate the del_timer/timeout.functio=
n
>> calls in a nf_ct_kill() function and perform accounting there.
>> Since all manual invocations of timeout.function are/should be
>> performed only while handling packets (that are usually not
>> accounted), this seems like the right way.
>=20
> Ok, I see. But for accounting ctinfo and skbuf are required. I'll=20
> include them in the argument list of nf_ct_kill() and update the=20
> function invocations, ok? Or should I introduce an nf_ct_kill_acct()?

All callers in my patch want the accounting, so a seperate function
would make this one useless. So I'd go with adding a struct sk_buff *
argument, even though its not particulary pretty :)

> I just did another test where my SEEN_REPLY patch was not applied.=20
> Surprisingly the SEEN_REPLY bit was set in the destroy events. I am=20
> afraid, but I have to assume, that I did not evaluate the bahavior=20
> carefully enough. Probably I confused the accounting, no status and n=
o=20
> related packets issues.
>=20
> Unless a race condition might be thinkable, we should leave the=20
> SEEN_REPLY patch. If it is possible, that the timeout function=20
> immediately triggers the destroy event to be exported over netlink, t=
hen=20
> the patch is still necessary. I don't see things detailed enough to=20
> judge this. If it is necessary, should it be included in nf_ct_kill()=
?

Right, I missed this as well. The connection killing only removes
the timer, but the packet will still be handled as a valid packet.
So nf_conntrack_core sets the SEEN_REPLY bit, before destroying it
when the final refcount (from the packet) is released. Thanks for
noticing this :)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
