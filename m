From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [PATCH 0/3] ipset: change 'iface' part in hash:net,iface set
Date: Sun, 08 Jul 2012 14:03:22 +0100
Message-ID: <4FF9851A.8080400@googlemail.com>
References: <cover.1341525006.git.mr.dash.four@googlemail.com> <alpine.DEB.2.00.1207060947530.14535@blackhole.kfki.hu> <4FF736FE.8030109@googlemail.com> <alpine.DEB.2.00.1207062138140.16055@blackhole.kfki.hu> <4FF74868.3070303@googlemail.com> <CAHo-OowHXH9f526QQc4Ln5_P_Osdm1Q_RrBkw83hSGj=oES5ww@mail.gmail.com> <4FF74D5C.6060909@googlemail.com> <alpine.DEB.2.00.1207062243080.16055@blackhole.kfki.hu> <4FF752F0.3010007@googlemail.com> <alpine.DEB.2.00.1207062319130.16055@blackhole.kfki.hu> <4FF765E7.6020809@googlemail.com> <alpine.DEB.2.00.1207071646130.17386@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Core Team <netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:56059 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248Ab2GHNDd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 8 Jul 2012 09:03:33 -0400
Received: by wibhm11 with SMTP id hm11so2458738wib.1
        for <netfilter-devel@vger.kernel.org>; Sun, 08 Jul 2012 06:03:31 -0700 (PDT)
In-Reply-To: <alpine.DEB.2.00.1207071646130.17386@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> So I have to repeat again: your patches do not address the example of the 
> two rules with list:set type of sets, which give different results 
> depending on "in/out" or "src/dst" in the second direction position. 
>   
How many times would you like me to repeat this: they give "different 
results" because you are applying direction parameters which have 
different meanings by definition: "in" means "match on incoming 
interfaces *only*", "out" means "match on outgoing interface *only*", 
while "src" and "dst" do not have that restriction. This is how it 
works, by definition (if you know any different, please let me know).

This was stated from the outset in my patches and in the various man 
pages. So, given that in != src and out != dst (the same way as src != 
dst for example), one should not be surprised to get "different results" 
when different direction parameters are used (or direction parameters, 
which have different meaning). Simple logic and common sense will tell 
you all that.

>  
>   
>> To reiterate once again - 'in' is for matches of incoming interfaces 
>> only and should only be used for that particular purpose (it is one 
>> reason why I am dead against your idea for this to be used "everywhere" 
>> - to answer your other query below). Similar with 'out', but for 
>> outgoing interfaces.
>>     
>
> In the given example, in rule level, there is no hash:net,iface type of 
> set. Still, the result depends on the syntax.
>   
Please clarify, what "given example"?

> I wait for a better solution, which does not produce different results 
> depending on the "in/out" or "src/dst" syntax, for all set types, 
> including the list of sets.
>   
Again, you get "different results" because you apply direction 
parameters which have different meaning - by definition (see above if 
you are still "confused" what the definition of 'in' and 'out' is). So, 
to summarise, again, for your own benefit:

- "in" means match on incoming interface only;
- "out" means match on outgoing interface only;

Example: If list1 - list:set type of set has, say, 5 members: iface1 and 
iface2 - type hash:net,iface, and ipp1, ipp2 and ipp3 - type 
hash:ip,port, then the following iptables statement:

iptables -A INPUT -m set --match-set list1 src,in -j ACCEPT

will only match packets on src IP address/subnet (the 1st direction 
parameter) and the incoming interface (the 2nd direction parameter) - 
nothing else, simply because of the definition of the second parameter - 
"in" above, means "match on incoming interfaces only". In other words, 
the above statement will produce matching members of iface1 and iface2, 
while members of ipp1, ipp2 and ipp3 will be excluded from the match, 
quite naturally. However,

iptables -A INPUT -m set --match-set list1 src,src -j ACCEPT

will match packets on source IP address/subnet (1st direction 
parameter), 'src' interface (which you defined to mean incoming 
interface) as well as source ports (2nd direction parameter), simply 
because 'src' has a different definition from that of 'in' - it is more 
broad and does not have the restriction 'in' has.

So, given the above, I fail to see how by applying direction parameters 
with different meanings (by definition) surprises you, "confuses" you or 
is in any way inconsistent when it produces different results for 
different set members, but if you know any different I am all eyes/ears!

