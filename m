From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [PATCH 0/3] ipset: change 'iface' part in hash:net,iface set
Date: Mon, 09 Jul 2012 21:19:39 +0100
Message-ID: <4FFB3CDB.80206@googlemail.com>
References: <cover.1341525006.git.mr.dash.four@googlemail.com> <4FF74868.3070303@googlemail.com> <CAHo-OowHXH9f526QQc4Ln5_P_Osdm1Q_RrBkw83hSGj=oES5ww@mail.gmail.com> <4FF74D5C.6060909@googlemail.com> <alpine.DEB.2.00.1207062243080.16055@blackhole.kfki.hu> <4FF752F0.3010007@googlemail.com> <alpine.DEB.2.00.1207062319130.16055@blackhole.kfki.hu> <4FF765E7.6020809@googlemail.com> <alpine.DEB.2.00.1207071646130.17386@blackhole.kfki.hu> <alpine.DEB.2.00.1207071821560.17542@blackhole.kfki.hu> <4FF9852C.7080201@googlemail.com> <alpine.DEB.2.00.1207082051150.19776@blackhole.kfki.hu> <4FF9D97D.7040309@googlemail.com> <alpine.DEB.2.00.1207082104290.19776@blackhole.kfki.hu> <4FF9DB46.5000302@googlemail.com> <alpine.DEB.2.00.1207082225250.20080@blackhole.kfki.hu> <4FFA056C.8000709@googlemail.com> <alp
 ine.DEB.2.00.1207090014450.20627@blackhole.k fki.hu> <4FFA08CE.1090406@googlemail.com> <alpine.DEB.2.00.1207090035050.20788@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Core Team <netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:63325 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968Ab2GIUTn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Jul 2012 16:19:43 -0400
Received: by weyx8 with SMTP id x8so1525154wey.19
        for <netfilter-devel@vger.kernel.org>; Mon, 09 Jul 2012 13:19:42 -0700 (PDT)
In-Reply-To: <alpine.DEB.2.00.1207090035050.20788@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


>> Well, in the above example I fail to see where "src,in" == "src,src" - 
>> that is *never* the case!
>>     
>
> According to your patches if list1 contains *only* hash:net,iface type of 
> setst, then "src,in" == "src,src" because
>
> iptables -A INPUT -m set --match-set list1 src,in -j ACCEPT
>
> is identical in result with
>
> iptables -A INPUT -m set --match-set list1 src,src -j ACCEPT
>
> However, if list1 contains hash:net,iface type of sets *and* other types 
> as well, then "src,in" != "src,src" because
>
> iptables -A INPUT -m set --match-set list1 src,in -j ACCEPT
>
> is not identical in result with
>
> iptables -A INPUT -m set --match-set list1 src,src -j ACCEPT
>
> Moreover, "list1" can be updated with new member sets any time, and 
> depending on the *syntax*, again, the result may change.
>   
You are changing the members of a given set - therefore, the result is 
always bound to be different, no matter what. In such a case all bets 
are off!

When you have different members of a given set of course you are going 
to have different results depending on the parameters you use. A small 
example which comes to mind is how you treat multi-dimensional matches - 
by definition, one has to specify all dimensions in order to get a 
complete match, otherwise that won't happen. No matter how many 2 or 3 
dimensional sets I add to a list:set, I'll get the same number of 
results when I use single dimension for example, simply because of the 
way it works - by definition.

It is the same with 'in' and 'out' - again, by definition, they match 
only on incoming and outgoing interface, nothing else. No matter how 
many members of other set types you add to the list:set, you will always 
get matches against incoming/outgoing interfaces.

So, I fail to see where the confusion or inconsistency is?

