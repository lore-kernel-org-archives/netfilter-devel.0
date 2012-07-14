From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [PATCH v2 3/3] ipset: change 'iface' part in hash:net,iface set
Date: Sat, 14 Jul 2012 13:35:24 +0100
Message-ID: <5001678C.6000505@googlemail.com>
References: <cover.1341871199.git.mr.dash.four@googlemail.com> <1341872622-5015-2-git-send-email-mr.dash.four@googlemail.com> <alpine.DEB.2.00.1207101721510.24998@blackhole.kfki.hu> <4FFCBDB8.9080101@googlemail.com> <alpine.DEB.2.00.1207112154070.26540@blackhole.kfki.hu> <4FFF6EF2.6010108@googlemail.com> <alpine.DEB.2.00.1207130857480.31126@blackhole.kfki.hu> <5000293F.4030901@googlemail.com> <alpine.DEB.2.00.1207131608230.32475@blackhole.kfki.hu> <50002F3F.5020408@googlemail.com> <alpine.DEB.2.00.1207141009340.1031@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Core Team <netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:51343 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313Ab2GNMfe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 14 Jul 2012 08:35:34 -0400
Received: by wibhm11 with SMTP id hm11so1414371wib.1
        for <netfilter-devel@vger.kernel.org>; Sat, 14 Jul 2012 05:35:32 -0700 (PDT)
In-Reply-To: <alpine.DEB.2.00.1207141009340.1031@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> a. The keywords are not permitted at all.
> b. "in/out" is permitted but "converted" to "src/dst" wherever needed for
>    the member sets, that is all types but hash:net,iface.
>   
Solution "b.", as you put it above, is what I have implied with my 
question yesterday.

> Solution a. is completely acceptable for me. It can nicely be documented, 
> there's no chance for misunderstanding.
>
> Solution b. is also acceptable but it's more controversial: if "in/out" is 
> accepted with list:set type, then it's very hard to explain why it's *not* 
> allowed with every type, when actually "in/out" is allowed then for every 
> type of member sets of list:set type of sets. So solution b. implies that 
> "in/out" is then a general synonym of "src/dst" and should be allowed 
> everywhere. Therefore I'm not really happy with solution b. but I can 
> stomach it.
>   
There is a flip side to that particular coin - I could argue that since 
in/out *is* allowed to be used in hash:net,iface, why can't it be used 
in list:set where I could have hash:net,iface type sets accepted as 
members? You are imposing an  unnecessary restriction where none is needed.

Also, don't forget that this may be OK with someone, like yourself, who 
is comfortable interchanging in/out with src/dst quite easily, but for 
people like myself, where I have to scratch my head and think "god, what 
the hell was the substitution for 'in' now?" before specifying src/dst, 
this is not as straight-forward as you might think.

So, to conclude: "solution b." is a good compromise - one I will be 
quite happy with. If src/dst is used together with in/out (in 
list:sets!), you leave the end user to decide what is more appropriate 
for each case as list:set could have hash:net,iface as well as other 
type of sets as members and in this case that is OK to be allowed (one 
cannot guess what will be entered in advance as members of that 
list:set, so it makes perfect sense to leave that decision to the end user).

> Do you see other possibilities, which produce result independent of the 
> allowed syntax?
>   
No, not without you being on my case. For list:set types, as it is kind 
of a "unique" set (as it could have different types of sets as members) 
I think "solution b." is quite acceptable.

