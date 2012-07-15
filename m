From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [PATCH v2 3/3] ipset: change 'iface' part in hash:net,iface set
Date: Sun, 15 Jul 2012 17:32:47 +0100
Message-ID: <5002F0AF.4000502@googlemail.com>
References: <cover.1341871199.git.mr.dash.four@googlemail.com> <1341872622-5015-2-git-send-email-mr.dash.four@googlemail.com> <alpine.DEB.2.00.1207101721510.24998@blackhole.kfki.hu> <4FFCBDB8.9080101@googlemail.com> <alpine.DEB.2.00.1207112154070.26540@blackhole.kfki.hu> <4FFF6EF2.6010108@googlemail.com> <alpine.DEB.2.00.1207130857480.31126@blackhole.kfki.hu> <5000293F.4030901@googlemail.com> <alpine.DEB.2.00.1207131608230.32475@blackhole.kfki.hu> <50002F3F.5020408@googlemail.com> <alpine.DEB.2.00.1207141009340.1031@blackhole.kfki.hu> <5001678C.6000505@googlemail.com> <alpine.DEB.2.00.1207141816580.1593@blackhole.kfki.hu> <5002AF68.9070204@googlemail.com> <alpine.DEB.2.00.1207151552140.3610@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Core Team <netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:62119 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152Ab2GOQc6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 15 Jul 2012 12:32:58 -0400
Received: by weyx8 with SMTP id x8so3490626wey.19
        for <netfilter-devel@vger.kernel.org>; Sun, 15 Jul 2012 09:32:56 -0700 (PDT)
In-Reply-To: <alpine.DEB.2.00.1207151552140.3610@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


>> I fail to see how your answer addresses my point above, which I raised 
>> in response to the restriction imposed by "solution a." of not allowing 
>> in/out in a list:set where there could be hash:net,iface members 
>> registered.
>>     
>
> My answer stated the conditions which any solution must satisfy.
>   
Which wasn't what I asked originally, was it Jozsef? Even if that was 
the case and I did ask you that, I fail to see how "solution b" isn't 
enforcing what you have just written above.

On the contrary, with regards the result being "the same", there is no 
difference between "solution a." and "solution b." - I think we can both 
agree with that, right? Regardless of whether in/out or src/dst has been 
used in a list:set, it will produce the same number of results - I have 
never stated, nor implied otherwise! Where do you get that from?

So, the difference then, is that "solution a" places a restriction on 
the use of in/out in a set (i.e. prohibits it) where hash:net,iface 
members can be registered and it is exactly what I asked you to justify?

Let me repeat that again, for your own benefit: How do you justify the 
restriction your "solution a." places when someone is forced (by your 
own words, not mine!) to use src/dst only (and not in/out, in addition 
to src/dst) when hash:net,iface set needs to be registered as a member 
of list:set, given your "unhappiness" expressed by yourself just a few 
days earlier (see more on the semantics of that below) that same 
restriction imposes, and also given that regardless of whether in/out or 
src/dst is used, the "end result", i.e. the number of matches produced 
will *not* be any different and dependant on the options used in that 
list:set?

>  
>   
>> You know very well that by allowing in/out alongside src/dst in a 
>> list:set this *will* produce the same members match - that was your 
>> previous objection for not allowing in/out to be used alongside src/dst 
>> in list:set, until I found you this solution and then you swiftly moved 
>> the goalposts, again!
>>     
>
> The goal - for me - is the same from the very beginning: an alternate 
> syntax must be what it is: just an alternative. The result cannot depend 
> on which syntax is used.
>   
And how is that any different from what I have just written above?

>>> I don't favour b. Ugly like hell, a. were much cleaner.
>>>   
>>>       
>> You couldn't make this up! I mean, really Jozsef?
>>
>> In a couple of hours yesterday, you went from:
>>
>> "Solution b. is also acceptable but it's more controversial", then
>> "Therefore I'm not really happy with solution b. but I can stomach it", 
>>     
>
> I don't have to like a solution. This one is controversial. Originally I 
> came up with it, but I don't like it.
>   
No. What you have "come up with" was that initially this same solution was:

1. "acceptable, but controversial"; then
2. "I am not happy, but I can stomach it"; followed a few hours later by
3. "I do not favour it, ugly like hell";

All this, given your initial reaction of that same restriction being, at 
best undesirable, at worse unacceptable.

Let me ask you this then: Do you think all of the answers I listed above 
are consistent?

>> and finally, the above answer, not to mention that you started all of 
>> this with you being "unhappy" with users being "forced" to use src/dst 
>> only on list:set types.
>>     
>
> Here is my paragraph you might think of:
>
> "You must handle the case of the list:set type: how should then the new 
> "in", "out" be interpreted? Or should those be rejected? But then it'd 
> mean that if someone used a hash:net,iface type as a member of list:set, 
> then he is forced to use "src", "dst" only."
>
> I asked questions. Did I write I was unhappy if only src/dst were allowed? 
> No. The only thing I stated was that the case of list:set types must be 
> handled. Something really doesn't work in the communication between us if 
> my sentences above misled you.
>   
Jozsef, I don't really need any lessons, particularly from you, on the 
semantics of the English language! Let's make that clear once and for 
all, OK?

Your last sentence you quoted above: "...but then it'd mean that if 
someone used a hash:net,iface type as a member of list:set, then he is 
forced to use 'src', 'dst' only." clearly indicates, or at least implies 
to anyone with a basic grasp of the English language, that this action 
(using src/dst only for hash:net,iface in a list:set) is, at best 
undesirable, at worse unacceptable.

It is certainly exactly the opposite of what you have stated since 
yesterday as I quoted in 1, 2 and 3 above, which is what I call a 
classic case of someone making a full circle - from start to finish, 
unless you think that all of the 4 answers you have provided mean the 
same thing. Do you? =-O

>> In other words - you have gone full circle - twice - in a space of just a
>> couple of days. I see that "debating" with you is becoming a bit of a
>> pointless exercise.
>>     
>
> It's a mutual feeling then. I repeat again and again, that where two 
> syntaxes are allowed (the subject is an iptables rule) then the result 
> must not depend on which one is used.
>   
I haven't disagreed with that point at all. Again, allowing in/out as 
well as src/dst in a list:set won't produce "different results" 
depending on whether one uses either of these values! Where do you get 
that from?

Let me repeat that so it is clear - they won't, but if you know any 
different I am all eyes/ears etc.

> So better close it down: send your patches according to solution a, that 
> is the "in/out" keywords are allowed only with hash:net,iface type of sets 
> alone and rejected with a proper error message when attempted to use with 
> any other set type.
>   
I would like to see why do you think the use of in/out should be 
restricted in list:set types, given the fact that there could be 
hash:net,iface members registered in that type of set?

Why should I (and I am sure I am not going to be the only one) have to 
scratch my head and think what is corresponding to 'src' and 'dst' every 
time I place a hash:net,iface set member in a list:set and why I can't 
make use of in or out, in addition to src/dst in that list:set?
