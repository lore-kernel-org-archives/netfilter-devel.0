From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [PATCH v2 3/3] ipset: change 'iface' part in hash:net,iface set
Date: Fri, 13 Jul 2012 01:42:26 +0100
Message-ID: <4FFF6EF2.6010108@googlemail.com>
References: <cover.1341871199.git.mr.dash.four@googlemail.com> <1341872622-5015-2-git-send-email-mr.dash.four@googlemail.com> <alpine.DEB.2.00.1207101721510.24998@blackhole.kfki.hu> <4FFCBDB8.9080101@googlemail.com> <alpine.DEB.2.00.1207112154070.26540@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Core Team <netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:36572 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515Ab2GMAts (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Jul 2012 20:49:48 -0400
Received: by wibhm11 with SMTP id hm11so83224wib.1
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Jul 2012 17:49:46 -0700 (PDT)
In-Reply-To: <alpine.DEB.2.00.1207112154070.26540@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


>> Now that the latter is being resolved via the 
>> get_set_byname_with_features function, I would still like to keep this 
>> and relax the restriction for 'in' and 'out' on the list:set as I am yet 
>> to get a reasonable and adequate explanation as to why that should not 
>> be allowed (the use of 'in' and 'out' in list:set)?
>>     
>  
> Go back and read my answer. I won't repeat myself any more again and again 
> and again.
>   
This is a "brief" summary of what we discussed with regards to the 'in' 
and 'out' options since I submitted the patches initially:

06/07/2012
~~~~~~~~~~
JK: You must handle the case of the list:set type: how should then the new
JK: "in", "out" be interpreted? Or should those be rejected? But then it'd
JK: mean that if someone used a hash:net,iface type as a member of 
list:set,
JK: then he is forced to use "src", "dst" only.
JK: much simpler to introduce the keywords as aliases, all over:
JK: "in" as "dst" and "out" as "src"

Me: Definition of 'in' and 'out' - to match against network interfaces. 
Nothing else!
Me: It doesn't make sense at all to be used anywhere else - if they are 
allowed to
Me: be used to specify source/destination ip addresses/subnets, 
protocols or ports,
Me: this would be completely nonsensical.
Me: "list1 src,in" - *only* match packets against members of list1 which 
have a
Me: matching source IP address and incoming interface;
Me: "list1 src,src" - match packets against *all* members of list1 which 
have a
Me: matching source IP address, incoming interface as well as src port 
values.

JK: ...creates more confusion for the users than the current state: one
JK: had to keep in mind what kind of sets are stored in a list of sets and
JK: depending on them, use "src/dst" or "in/out" in the second direction
JK: parameter. And additionally,
JK:
JK: "list1 src,src"
JK: and
JK: "list1 src,in"
JK:
JK: produced different results for the same member sets with the same 
elements
JK: against the same packets. This is unacceptable for me.

Me: Please explain the 'confusion' bit? I've made it quite clear in the 
definition
Me: of 'in' and 'out' - 'in' is meant for a match on the 'incoming', 
'out' on
Me: the 'outgoing' interfaces. If one wishes to produce a match against 
those
Me: interfaces, then 'in' and 'out' is one possible way to go, if not - 
then use
Me: 'src' or 'dst' if you feel more comfortable with it.
Me: You can't expect to issue two different iptables statements and get 
the same
Me: number of matches! By the same token, if I execute the following two 
statements:
Me: "list1 src,src"
Me: and
Me: "list1 src,dst"
Me: will also produce "different results for the same member sets with 
the same
Me: elements against the same packets". So why is this not 
"unacceptable" then?

JK: list1 src,src
JK: list1 src,in
JK:
JK: the underlying set types "decide" how to act to "src/in", when actually
JK: "src" == "in".But "list1" is a list type of set, not hash:net,iface.
JK: Still, the result is different.

Me: Whoever produces the above statements is making a concious decision 
on what to
Me: use/deploy ... my patch series are offering a choice.

JK: Your example is wrong, because the effect of two command are of course
JK: different.

JK: But what I gave above, the results depends from the type of the 
members of
JK: the set list, which is invisible in the command line. Even if it's
JK: stressed in the manpage that "in" is equivalent with "src" but just for
JK: the hash:net,iface type, that is an equivalency and users will 
expect the
JK: same result for the cited commands. And they're right.

Me: It is quite visible as the 'in' bit suggests (similar to the 'dst' bit).
Me: 'In' is defined as match on incoming interface only - if that is not 
clear,
Me: then it should be made clear...How would one expect a match on 
"income interface only"
Me: with a match on "source ip addresses, source subnets, source ports, 
source
Me: everything else you care to mention ... and income interface" to be an
Me: "equivalent"? it isn't - not in a million years!

JK: You want a choice to be introduced which lead to confusion - I'm 
repeating
JK: it countless times and you just ignore it. In order to prevent such
JK: confusions, I offered that let "in/out" be alias to "src/dst": 
accepted as
JK: input everywhere but printed/saved with hash:net,iface only. You point
JK: blank refused it. Then come up with a better solution than the 
submitted
JK: one.

Me: How am I ignoring it? I asked you before and I am asking you again 
to explain
Me: what that "confusion" is? It is quite clear to me what the meaning 
of "in" and
Me: "out" is ... if there is something "confusing" in that meaning,
Me: then I'd like to know. As for your suggestion above, I'll repeat 
what I've
Me: already posted - of course I'll refuse it, because it is completely 
nonsensical.
Me: Do you not think that referring to a destination IP address, for 
example,
Me: as "out" IP address isn't confusing in the slightest?

07/07/2012
~~~~~~~~~~
JK: ...your patches do not address the example of the
JK: two rules with list:set type of sets, which give different results
JK: depending on "in/out" or "src/dst" in the second direction position.
JK: In the given example, in rule level, there is no hash:net,iface type of
JK: set. Still, the result depends on the syntax. I wait for a better 
solution,
JK: which does not produce different results depending on the "in/out" or
JK: "src/dst" syntax, for all set types, including the list of sets ...
JK: and where both syntax is accepted.

08/07/2012
~~~~~~~~~~
Me: If you know of a case where 'in' or 'out' direction parameters "are 
accepted"
Me: and produce "different results" (by "different results" I mean 
different from
Me: their own definition - match on incoming/outgoing interfaces only),
Me: then, by all means, let me know.

JK: list1 src,src
JK: list1 src,in
JK: would produce different results and that's unacceptable.

Me: Why not?

JK: Because that's too subtle, error prone and hard to catch if not used
JK: really intentionally. Because that's illogical. Because there are a 
couple
JK: of ways to avoid it.

Me: If I use 'src,dst' instead of 'src,src' would you consider
Me: this "error prone", "hard to catch" or not? What do you see as 
"illogical"?
Me: Avoid what exactly? Using 'in' or 'out' in list:set types?

JK: "src,src" != "src,dst", but
JK: with your patches in some cases
JK: "src,in" == "src,src" or "src,in" != "src,src"

Me: Could you provide me with an example please? I am intrigued!

JK: This is ridiculous, as if I haven't provided it countless times:
JK: list1 src,src
JK: list1 src,in

Me: Well, in the above example I fail to see where "src,in" == "src,src" -
Me: that is *never* the case!

JK: According to your patches if list1 contains *only* hash:net,iface 
type of
JK: setst, then "src,in" == "src,src" because
JK:
JK: list1 src,in
JK:
JK: is identical in result with
JK:
JK: list1 src,src
JK:
JK: However, if list1 contains hash:net,iface type of sets *and* other 
types
JK: as well, then "src,in" != "src,src" because
JK:
JK: list1 src,in
JK:
JK: is not identical in result with
JK:
JK: list1 src,src
JK:
JK: Moreover, "list1" can be updated with new member sets any time, and
JK: depending on the *syntax*, again, the result may change.

09/07/2012
~~~~~~~~~~
Me: You are changing the members of a given set - therefore, the result 
is always
Me: bound to be different, no matter what. In such a case all bets are off!
Me:
Me: When you have different members of a given set of course you are 
going to
Me: have different results depending on the parameters you use. A small 
example
Me: which comes to mind is how you treat multi-dimensional matches - by 
definition,
Me: one has to specify all dimensions in order to get a complete match, 
otherwise
Me: that won't happen. No matter how many 2 or 3 dimensional sets I add 
to a list:set,
Me: I'll get the same number of results when I use single dimension for 
example,
Me: simply because of the way it works - by definition.
Me:
Me: It is the same with 'in' and 'out' - again, by definition, they 
match only on
Me: incoming and outgoing interface, nothing else. No matter how many 
members of
Me: other set types you add to the list:set, you will always get matches
Me: against incoming/outgoing interfaces.
Me:
Me: So, I fail to see where the confusion or inconsistency is?

And also...

Me: you get "different results" because you apply direction parameters 
which have
Me: different meaning - by definition. So, to summarise, again, for your 
own benefit:
Me:
Me: - "in" means match on incoming interface only;
Me: - "out" means match on outgoing interface only;
Me:
Me: Example: If list1 - list:set type of set has, say, 5 members: iface1 
and iface2 -
Me: type hash:net,iface, and ipp1, ipp2 and ipp3 - type hash:ip,port,
Me: then the following iptables statement:
Me:
Me: list1 src,in
Me:
Me: will only match packets on src IP address/subnet (the 1st direction 
parameter) and
Me: the incoming interface (the 2nd direction parameter) - nothing else, 
simply because
Me: of the definition of the second parameter - "in" above, means "match 
on incoming
Me: interfaces only". In other words, the above statement will produce 
matching members
Me: of iface1 and iface2, while members of ipp1, ipp2 and ipp3 will be 
excluded
Me: from the match, quite naturally. However,
Me:
Me: list1 src,src
Me:
Me: will match packets on source IP address/subnet (1st direction 
parameter), 'src'
Me: interface (which you defined to mean incoming interface) as well as 
source ports
Me: (2nd direction parameter), simply because 'src' has a different 
definition from
Me: that of 'in' - it is more broad and does not have the restriction 
'in' has.
Me:
Me: So, given the above, I fail to see how by applying direction 
parameters with different
Me: meanings (by definition) surprises you, "confuses" you or is in any 
way inconsistent
Me: when it produces different results for different set members, but if 
you know any
Me: different I am all eyes/ears!


So, we started off with you being unhappy with users being "forced" to 
use src/dst only on list:set types (ahem :-) !) and your suggestion to 
use in/out everywhere - in every set and in every direction parameter.

Then you became "confused" because users, apparently, need to keep track 
of what kind of sets are stored in a list:set to do the matching, 
despite the clear definition of what in/out means and what it matches 
against (and despite myself reciting that same definition to you on at 
least 5 occasions). Also, the irony of you suggesting to use in/out 
everywhere - in every set and every conceivable direction parameter - 
and not see how confusing that could be for the end user was completely 
lost on you, it seems.

We then moved on to your "inconsistency" claim and the example where 
"list1 src,src" and "list1 src,in", apparently, "produced different 
results for the same member sets with the same elements against the same 
packets" and that was to you, of course, "unacceptable".

Please note the use of "same member sets" and "same elements" phrase 
above, because when I showed you that the examples I have given 
throughout are pretty consistent with the use and definition of 'in' and 
'out', you then moved the goal posts yet again, quickly changed the 
above stance and decided to suddenly start deleting members of the same 
list1 set and add new ones to fit your argument again (so much for "same 
members set" and "same elements" then, eh?) - see your last post on 
08/07 above if you think that I am making things up. And of course you 
decided to conveniently ignore the last two posts from me on 09 July 
(above) when I challenged you on this.

So, what should I "go back and read" exactly?

The fact that you are, apparently, unable to grasp the definition of 
'in' and 'out' and its proposed use, despite myself having to recite it 
for you on at least 5 occasions in the past couple of days, or the fact 
that you are unwilling or unable to hold an argument, scurrying around 
moving the goal posts every time I dig a gaping hole in your claims?

The proposed definition and use of 'in' and 'out' is quite clear - it is 
to match on incoming and outgoing interfaces only.

There are just two sets where this option could be used and deployed (in 
addition to the "standard" src/dst): hash:net,iface, because by 
definition, this set can hold interface names; and list:set, because, by 
extension, this type of set could have a member which is of type 
hash:net,iface and therefore specifying in/out makes perfect sense 
there. The list:set type does not match on set member names, it matches 
on set members' members, if that makes sense, so specifying 'in' and 
'out' should be allowed there, as is the case with hash:net,iface type sets.

Since none of the other sets can have interfaces specified in them, it 
does not make any sense whatsoever for 'in' and 'out' to be used there!

This was one of the minor issues I have corrected with version 2 of the 
patches, because even though no matching on interfaces was allowed in 
those "other" type of sets, input of 'in' and 'out' was still allowed 
simply because iptables did not have the means to find out what kind of 
set it was dealing with - this was corrected in version 2 of the 
patchset with the introduction of the new get_set_byname_with_features 
function.
