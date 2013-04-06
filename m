From: Michael Zintakis <michael.zintakis@googlemail.com>
Subject: Re: iptables nfacct match question
Date: Sat, 06 Apr 2013 17:14:15 +0100
Message-ID: <516049D7.7010102@googlemail.com>
References: <51292D41.8000703@googlemail.com> <20130225154848.GA20609@localhost> <512BC79F.1070708@googlemail.com> <20130226135529.GA9526@localhost> <512D0BA4.7060809@googlemail.com> <20130226214707.GA3555@localhost> <512E7331.10304@googlemail.com> <515DE487.9020209@googlemail.com> <alpine.DEB.2.00.1304042341530.24744@blackhole.kfki.hu> <515F21AC.3080504@googlemail.com> <alpine.DEB.2.00.1304052116350.27405@blackhole.kfki.hu> <515F2761.80707@googlemail.com> <alpine.DEB.2.00.1304052255351.27405@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:35855 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423258Ab3DFQPT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 6 Apr 2013 12:15:19 -0400
Received: by mail-lb0-f179.google.com with SMTP id t1so4631492lbd.38
        for <netfilter-devel@vger.kernel.org>; Sat, 06 Apr 2013 09:15:17 -0700 (PDT)
In-Reply-To: <alpine.DEB.2.00.1304052255351.27405@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello Jozsef,

Jozsef Kadlecsik wrote:
> Hi Michael,
> 
> On Fri, 5 Apr 2013, Michael Zintakis wrote:
> 
>> Jozsef Kadlecsik wrote:
>>> On Fri, 5 Apr 2013, Michael Zintakis wrote:
>>>
>>>> Jozsef Kadlecsik wrote:
>>>>> On Thu, 4 Apr 2013, Michael Zintakis wrote:
>>>>>> Something we've discovered with regards to the nfacct match recently. If 
>>>>>> I have the following iptables statement:
>>>>>>
>>>>>> iptables -A INPUT -m nfacct --nfacct <nfacct_obj> -m <match2> -m <match3>
>>>>>>
>>>>>> The above aklways updates the "nfacct_obj" byte and packet counters, 
>>>>>> regardless of whether "match2" and "match3" actually matches. However, 
>>>>>> if we have:
>>>>>>
>>>>>> iptables -A INPUT -m <match2> -m nfacct --nfacct <nfacct_obj> -m <match3>
>>>>>>
>>>>>> then "nfacct_obj" counters are updated only when "match1" is satisfied, 
>>>>>> but if we have:
>>>>>>
>>>>>> iptables -A INPUT -m <match2> -m <match3> -m nfacct --nfacct <nfacct_obj>
>>>>>>
>>>>>> then "nfacct_obj" counters are updated when both match2 and match3 are 
>>>>>> matched (which was the initial intention).
>>>>>>
>>>>>> This inconsistency stems from the fact that the nfacct match in the 
>>>>>> kernel (xt_nfacct.c::nfacct_mt) always returns true, but also because of 
>>>>>> how iptables evaluates matches: it does so from left to right.
>>>>>>
>>>>>> Since there isn't a callback in the xt_match struct which is called 
>>>>>> after ALL matches have been satisfied (xt_match.match is called for each 
>>>>>> registered match in that statement), this causes the nfacct counters to 
>>>>>> be updated (or not) depending on the position of the nfacct match.
>>>>>>
>>>>>> What I have done locally is to add a separate callback (I called it 
>>>>>> "matched") which is called for all matches after all such matches in a 
>>>>>> particular statement have been satisfied, but that obviously will break 
>>>>>> lots of code depending on the old xt_match struct if such approach is 
>>>>>> adopted. My question is: is there more elegant solution to do this? 
>>>>> In my opinion this is not inconsistency at all, but the intended 
>>>>> behaviour. So I don't see any reason to add such a hack to override it.
>>>> I meant inconsistent in terms of the end result, which in the example 
>>>> above is packet/bytes counting.
>>>>
>>>> That result is different depending on the order of the conditions (i.e. 
>>>> matches) attached to the iptables rule. With the 'old' accounting we 
>>>> didn't have that. In other words, with the old accounting we've had:
>>>>
>>>> If (match1 && match2 && matchN) {
>>>>   do_packet_and_bytes_counting();
>>>> }
>>>>
>>>> No matter how we arrange the order of match1, match2 and matchN, the end 
>>>> result is (or should be) the same. With the nfacct match that isn't the 
>>>> case, but that isn't nfacct match's fault, but I guess it is because of 
>>>> the way iptables is examining the matches.
>>> Yes, exactly. And actually it supports rules like this:
>>>
>>> iptables -A INPUT -m <match0> -m nfacct --nfacct acct0 \
>>>                   -m <match1> -m nfacct --nfacct acct1 \ 
>>> 		  ...
>> Hm, never thought of that, but I guess one learns something new every 
>> day. Thanks Jozsef!
Just as a side note (which wasn't obvious to me at first): even though acct0 gets updated when match0 returns true, acct1 only gets updated when both match0 AND match1 return true...


>>> Also, this is a new accounting method, which is just not the same as the 
>>> old one.
>> Yes, I know, I wasn't disputing that - it is just that I am used to the 
>> 'old' accounting and when you've been using it for years it is not so 
>> easy to 'detach' yourself from that.
>>
>>>> We would have had the consistency (in other words, getting a consistent 
>>>> result regardless of the order of the various conditions/matches) if 
>>>> nfacct was a target, not a match, but I know that would be difficult (I 
>>>> already examined that possibility) since the x_tables target does not 
>>>> provide a 'destroy' method, so there isn't a way to track the 'refcnt' 
>>>> in the nfacct kernel struct, so inventing this method is as equally as 
>>>> ugly as the hack I did with the nfacct match above, so I thought to ask 
>>>> and see whether there is a better solution.
>>> Targets do have a destroy method.
>> Haha, you are far too quick for me!
>>
>> I just found that out - I don't know how I did not see it when I first 
>> looked at it. I guess if I 'convert' nfacct to a target I could get that 
>> 'consistency', but I appreciate the new example you gave above, which I 
>> have to admit is very useful indeed (one can hit two or more birds with 
>> one stone so to speak).
> 
> nfacct can't be converted to a target, because it'd result backward 
> incompatibilty - it already exists as a match.
Sorry Jozsef, I meant for nfacct to be added as a target (in addition to nfacct as a match).

? The module could be 
> extended to play the role of target as well, but it seems to be 
> unnecessary: there's no need to have a target in a rule,
I agree. nfacct (as a match) has the full functionality of nfacct (as a target), though one needs to get used to the 'new' matching and be aware of it. Maybe a note in the man pages to that effect would do.

> so in userspace 
> "-j NFACCT" could simply be replaced by "-m nfacct".
I just did a quick hack and implemented nfacct as a target - just out of curiosity, if not anything else. It works well and I could do something like:

iptables -I INPUT 1 -m nfacct --nfacct-name test -m conntrack --ctstate NEW -j NFACCT --nfacct-name test2

In the above statement the nfacct match on 'test' gets updated regardless of the state of the connection, while the nfacct target gets only executed (for 'test2') when cstate is NEW (this statement even works with '-j NFACCT --nfacct-name test').

This is all academical though - I agree that the existing nfacct match covers all the functionality of the nfacct target even if one needs to be aware of how this all works...


MZ
