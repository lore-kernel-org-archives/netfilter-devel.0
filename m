From: Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH] Add tcindex to conntrack and add netfilter target/matches
Date: Mon, 14 Dec 2015 10:50:31 +0100
Message-ID: <566E90E7.4060104@iogearbox.net>
References: <1449179951-26327-1-git-send-email-luuk.paulussen@alliedtelesis.co.nz> <1449179951-26327-2-git-send-email-luuk.paulussen@alliedtelesis.co.nz> <5664B698.8040904@alliedtelesis.co.nz> <20151206224522.GA27161@breakpoint.cc> <5664ECCC.1030104@alliedtelesis.co.nz> <5667EF49.8060707@iogearbox.net> <566DF87E.40608@alliedtelesis.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Luuk Paulussen <Luuk.Paulussen@alliedtelesis.co.nz>,
	Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:47800 "EHLO
	www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660AbbLNJuh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Dec 2015 04:50:37 -0500
In-Reply-To: <566DF87E.40608@alliedtelesis.co.nz>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 12/14/2015 12:00 AM, Luuk Paulussen wrote:
> On 12/09/2015 10:07 PM, Daniel Borkmann wrote:
>> On 12/07/2015 03:19 AM, Luuk Paulussen wrote:
>>> On 12/07/2015 11:45 AM, Florian Westphal wrote:
>>>> Luuk Paulussen <Luuk.Paulussen@alliedtelesis.co.nz> wrote:
>>>>> Hi All,
>>>>>
>>>>> I'm still hoping for some feedback on this.  I have some userspace
>>>>> patches around this as well, (to set/show the tc_index in the
>>>>> connection, and to add the marking/matching rules in iptables), but
>>>>> I am
>>>>> holding off on sending them until I know what people think of this
>>>>> idea/implementation first.
>>>> I can't say for sure since I don't know enough about tc.
>>>>
>>>> However, AFAICS tc_index seems to be something that should be internal
>>>> to tc and not exposed/changeable via iptables.
>>> tc_index is a mark that can be set by certain configurable ingress
>>> schedulers (dsmark, GRED, ingress) for later classification via the
>>> tcindex classifer.  This just adds an alternative mechanism for setting
>>> this mark if those schedulers aren't being used.
>>
>> Fwiw, tc_index can be read/written by cls_bpf (and you can also apply
>> masks
>> on that field if needed).
> I've just been looking into this and it does seem like it might cover a
> small part of what we are trying to do, although misses the key part,
> which is to use connection tracking information to limit full processing
> to the first packet of a flow in each direction. I'm guessing that there
> isn't any bpf support for connection information?

Depends on your requirements, but you could probably implement a minimal
tracker in cls_bpf through eBPF itself. Or alternatively, add a helper
function to retrieve the cttuple? Florian mentioned cls_flow already, so
you could orientate yourself there wrt developing an eBPF helper.

> One thing that isn't quite clear to me. Is it possible to use xt_bfp.c
> to set the tc_index field from netfilter?  If this is the case, then it
> does set a precedent
> for being able to set this value outside of tc code (but sill misses the
> save/restore possibility).

xt_bpf covers only classic BPF, so it's unfortunately not possible to
match or set tc_index from there.

> Given that tc_index is simple metadata I'm guessing that filter
> performance over the tcindex classifier wouldn't be significantly better?

I think it depends on how you encode your information, f.e. if you can get
away w/o an index to classid mapping through a hash table, etc. Maybe best
to give it a try on benchmarking.

Cheers,
Daniel
