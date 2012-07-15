From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [PATCH v2 3/3] ipset: change 'iface' part in hash:net,iface set
Date: Sun, 15 Jul 2012 23:14:55 +0100
Message-ID: <500340DF.6070207@googlemail.com>
References: <cover.1341871199.git.mr.dash.four@googlemail.com> <1341872622-5015-2-git-send-email-mr.dash.four@googlemail.com> <alpine.DEB.2.00.1207101721510.24998@blackhole.kfki.hu> <4FFCBDB8.9080101@googlemail.com> <alpine.DEB.2.00.1207112154070.26540@blackhole.kfki.hu> <4FFF6EF2.6010108@googlemail.com> <alpine.DEB.2.00.1207130857480.31126@blackhole.kfki.hu> <5000293F.4030901@googlemail.com> <alpine.DEB.2.00.1207131608230.32475@blackhole.kfki.hu> <50002F3F.5020408@googlemail.com> <alpine.DEB.2.00.1207141009340.1031@blackhole.kfki.hu> <5001678C.6000505@googlemail.com> <alpine.DEB.2.00.1207141816580.1593@blackhole.kfki.hu> <5002AF68.9070204@googlemail.com> <alpine.DEB.2.00.1207151552140.3610@blackhole.kfki.hu> <5002F0AF.4000502@googlemail.com> <alpine.DEB.2.00.1207152041270.4159@blackhole.k
 fki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Core Team <netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:44048 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab2GOWPG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 15 Jul 2012 18:15:06 -0400
Received: by wgbdr13 with SMTP id dr13so387809wgb.1
        for <netfilter-devel@vger.kernel.org>; Sun, 15 Jul 2012 15:15:04 -0700 (PDT)
In-Reply-To: <alpine.DEB.2.00.1207152041270.4159@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


>> I would like to see why do you think the use of in/out should be restricted in
>> list:set types, given the fact that there could be hash:net,iface members
>> registered in that type of set?
>>
>> Why should I (and I am sure I am not going to be the only one) have to 
>> scratch my head and think what is corresponding to 'src' and 'dst' every 
>> time I place a hash:net,iface set member in a list:set and why I can't 
>> make use of in or out, in addition to src/dst in that list:set?
>>     
>
> Because this or that way, someone would scratch his/her head. For example 
> if the rule contains "in/out" and the list:set is a mixed one, contains 
> both hash:net,iface and other types of sets. They'll ask: "What the heck 
> is "in/out" for say hash:ip type of set?"
You still didn't answer my question: Why do you impose the restriction 
in "solution a", given that the result from both solutions (a & b) are 
exactly the same, which is what you wanted all along and which was the 
main reason for you not wanting in/out to be allowed/entered in a 
list:set in a first place?

What I have suggested to you was that you allow in/out to be *entered*, 
as input, in a list:set (i.e. in the iptables statement), but treated 
internally in the same way as src/dst ('in' to be treated internally as 
'src', 'out' as 'dst' obviously). In that way, there won't be any 
discrepancies and the results from both "solutions" will be the same. In 
other words (using the example you gave earlier), typing:

-bash-~# iptables -A INPUT -m set --match-set list1 src,in -j ACCEPT

and

-bash-~# iptables -A INPUT -m set --match-set list1 src,src -j ACCEPT

to be both accepted  and 'in', as *entered* above, to be interpreted in 
the same way as 'src'. That way there won't be any "different" results. 
This is, to my understanding, what "solution b" is. What you are asking 
is 'in' to be rejected completely (i.e. not accepted as input) and only 
the following to be allowed:

-bash-~# iptables -A INPUT -m set --match-set list1 src,src -j ACCEPT

even though in that list1 set I could have hash:net,iface elements. What 
you are doing by this (and in "solution a") is placing an unnecessary 
restriction on in/out and prevent it from being entered/accepted at all, 
and that is why I asked you to justify that restriction.

The users are not morons (well, not all of them anyway) - they make a 
concious decisions on what to use/enter as direction parameters, so I 
think they should be allowed to enter in/out, particularly because the 
list:set could contain hash:net,iface elements and it is why I think 
in/out should be allowed.

