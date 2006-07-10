From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] iptables: handle cidr notation more sanely
Date: Mon, 10 Jul 2006 09:24:39 +0200
Message-ID: <44B200B7.8020908@trash.net>
References: <20060709222818.GA23200@linuxace.com> <44B1D6FE.6080208@trash.net>
	<20060710055902.GA832@oknodo.bof.de> <44B1F726.1070001@trash.net>
	<20060710065244.GB832@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Phil Oester <kernel@linuxace.com>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
In-Reply-To: <20060710065244.GB832@oknodo.bof.de>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Patrick Schaaf wrote:
>>>Better hope the past lazy typers' boot time iptables scripts will not break
>>>in any critical way by such a radical interpretation change.
>>>
>>>Of course, it's all their own fault when that happens, lazy bastards.
>>
>>Please don't put words in my mouth.
> 
> 
> Those were my words, not yours. I did in no way intend to put them
> into your mouth. And I stand by them. I'm a cynic. That's one of the
> reasons I forbid myself becoming maintainer... (lazyness being the
> most important reason, of course :)


Applogogies for the misunderstanding then.

>>If they rely on undocumented, clearly illogical (10.10/16 == 10/16)
>>behaviour, then yes, they are at fault, but its not because of beeing
>>lazy typers.
> 
> 
> On one hand, it is just that, in my opinion.
> 
> On the other hand, it is always a bit the fault of software permitting
> such abbreviation with arbitrary, undocumented semantics, in the first place.


I absolutely agree, my guess is that my feelings about that are
even stronger than yours :) This is one reason why I think it is
good to get rid of the old behaviour.

>>>Methinks that it would be better to make non-3-dots IP addresses
>>>a syntax error, period.
>>
>>I can understand your position about breaking compatibility, but
>>this seems unreasonable to me. You're saying we should do something
>>that has even more problems (breaking compatibility for shortcuts
>>without masks as well),
> 
> 
> I did not think about the case without masks (/32) at all. Good point.
> 
> So methinks non-3-dots should be syntax errors whenever used with masks != /32.


I actually think its nice that we now support 172.16/16 in a way
I think a user would expect it to work. The important thing is that
is has well defined and commonly understood semantics (and maybe
that it gets documented). The old behaviour, which is now only used
for non-masked expressions was unknown to me (10.10 == 10.0.0.10),
but it matches what IPv6 does and according to Henrik (whom I
fully trust) it is also commonly used for IPv4. So I think what
we have with this patch fully meets user expectations.

> And you do what you think is best. As always. And I thank you for that!

Unfortunately I also don't always know what's best, so your opinion
is appreciated, forcing me to think for a second time can only be a
good thing :)
