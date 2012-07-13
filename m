From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [PATCH v2 3/3] ipset: change 'iface' part in hash:net,iface set
Date: Fri, 13 Jul 2012 14:57:19 +0100
Message-ID: <5000293F.4030901@googlemail.com>
References: <cover.1341871199.git.mr.dash.four@googlemail.com> <1341872622-5015-2-git-send-email-mr.dash.four@googlemail.com> <alpine.DEB.2.00.1207101721510.24998@blackhole.kfki.hu> <4FFCBDB8.9080101@googlemail.com> <alpine.DEB.2.00.1207112154070.26540@blackhole.kfki.hu> <4FFF6EF2.6010108@googlemail.com> <alpine.DEB.2.00.1207130857480.31126@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Core Team <netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:53361 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab2GMN51 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Jul 2012 09:57:27 -0400
Received: by eekb15 with SMTP id b15so948301eek.19
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Jul 2012 06:57:26 -0700 (PDT)
In-Reply-To: <alpine.DEB.2.00.1207130857480.31126@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> You stated: "I fail to see where "src,in" == "src,src" - that is *never* 
> the case!". 
>
> I provided an example, and you simply skipped the answer and made no 
> effort to understand it.
>   
I responded to that point of yours the very next day (see my two posts 
of 09 July if you are "confused") - you can't expect to get the same 
results when you alter the members of a given set. Not to mention your 
earlier - contradictory - claim to use "same member sets" and "same 
elements", which isn't the case with your example given below. As I 
posted previously, you are moving the goal posts to suit your arguments 
with zero self-awareness.

>> JK: Moreover, "list1" can be updated with new member sets any time, and
>> JK: depending on the *syntax*, again, the result may change.
>>
>> 09/07/2012
>> ~~~~~~~~~~
>> Me: You are changing the members of a given set - therefore, the result is
>> always
>> Me: bound to be different, no matter what. 
>>     
> [...]
>
> Here again, no effort on your part to understand the case, just a 
> ridiculous comment.
>
> Just for you, just for one time, because it seems you do not want to get 
> it at all, let the last case *also* be expressed, letter by letter.
>
> Let there be four sets: 
>
> 	list1 is list:set type
> 	ip0 is say hash:ip type 
> 	netiface0 is hash:net,iface type
> 	ipport0 is hash:ip,port type
>
> list1 is empty and ip0, netiface0 and ipport0 have got elements.
>
> We have an iptables rule matching list1, which - according to you - could 
> be expressed using "src/dst" or "in/out" syntax.
>   
The two are not equivalent and are not always interchangeable - I get 
the feeling I am not repeating this for a first time.

> 	a. iptables -m set --match set list1 src,dst -j ACCEPT
>
> 	OR
>
> 	b. iptables -m set --match set list1 src,out -j ACCEPT
>
> 1. step
>
> 	ipset add list1 ip0
>
>     Rule a. and rule b. produce exactly the same result.
>   
That is simply because the second dimension parameter is ignored (I 
could put "src,mickey_mouse" for all I care and compare it to "src,dst" 
- it will always produce the same result, simply because all set members 
of list1 are one-dimensional and the second direction parameter is 
always ignored - by definition). Show me where the "inconsistency" or 
the "confusion" is here then?

> 2. step
>
> 	ipset add list1 netiface0
>
>     Rule a. and rule b. still produce exactly the same result.
>   
They do, because src/dst is equivalent to in/out for hash:net,iface type 
set- by definition. Show me where the "inconsistency" or the "confusion" 
is here then?

> 3. step
>
> 	ipset add list1 ipport0
>
>     From now on, rule a. and rule b. can produce different results.
>   
And that is because the second dimension parameter is accounted for and 
you have a member of the list1 set which is not of type hash:net,iface - 
that is where the definition of in/out are different. Show me where the 
"inconsistency" or the "confusion" is here then?

> 4. step
>
> 	ipset del list1 netiface0
>
>     Rule a. and rule b. produce again the same result.
>   
Oh yeah? Are you for real? They produce different results! The reason 
for that is because the second dimension ('dst' and 'out') differ - by 
definition - for sets other than hash:net,iface, which is the case here 
(ipport0 is still a member of list1) - the same as step 3 above. Show me 
where the "inconsistency" or the "confusion" is here then?

> That is exactly what I originally wrote, even highlighted the important 
> factor: "Moreover, "list1" can be updated with new member sets any time, 
> and depending on the *syntax*, again, the result may change."
>   
See above - you can't expect to get the same results when you alter the 
members of a given set. I also fail to see where the "inconsistency" 
with regards to the use of 'in' and 'out' is either - to only match 
against incoming/outgoing interfaces, which is the case with steps 3 & 4 
above - you add hash:ip,port set (and keep it there) and that is not 
matched by 'out' (2nd dimension parameter). If you still fail to grasp 
what the definition of 'in' and 'out' is, then I am afraid you are truly 
lost.

In all other cases you either have the second dimension completely 
ignored - by definition (see my "mickey_mouse" example above) or you use 
hash:net,iface sets where src/dst and in/out are equivalent - by definition.

The results only differ when the second dimension parameter is not 
ignored and you have sets in list:set which are not of hash:net,iface 
type - that is to be expected as in/out, when accounted for (and not 
ignored!) have different meaning for these type of sets.

To repeat what I've said above - given the definition of in/out, show me 
where the "inconsistency" or the "confusion" is and I'll concede that 
particular argument.

> I'm awaiting your patches. If my comments are handled properly (and no 
> other, including coding style mistakes are there), I'll apply them. 
> Otherwise your patches will be rejected, with terse comments.
>   
Unless I get a reasonable explanation (either from you or anyone else 
following this) as to what is wrong with allowing 'in' and 'out' to be 
used in the list:set (in addition to hash:net,iface sets) and where the 
"inconsistency" and "confusion" is, as you claimed before, I will be 
submitting the new set of  patches with that option activated so that 
one has a choice of using 'in' and 'out' where it makes sense: in 
hash:net,iface as well as list:set type of sets.
