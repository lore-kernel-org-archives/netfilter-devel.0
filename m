From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [PATCH 0/3] ipset: change 'iface' part in hash:net,iface set
Date: Fri, 06 Jul 2012 21:19:52 +0100
Message-ID: <4FF74868.3070303@googlemail.com>
References: <cover.1341525006.git.mr.dash.four@googlemail.com> <alpine.DEB.2.00.1207060947530.14535@blackhole.kfki.hu> <4FF736FE.8030109@googlemail.com> <alpine.DEB.2.00.1207062138140.16055@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Core Team <netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:45984 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483Ab2GFUUB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Jul 2012 16:20:01 -0400
Received: by werb14 with SMTP id b14so6604579wer.19
        for <netfilter-devel@vger.kernel.org>; Fri, 06 Jul 2012 13:20:00 -0700 (PDT)
In-Reply-To: <alpine.DEB.2.00.1207062138140.16055@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> ...you are right, because "in" is equivalent with "src".
>   
Except that it isn't. It is only "equivalent" for the 'iface' part of 
hash:net,iface sets and nothing else. Consider it as an alternative to 
select 'iface' part of a hash:net,iface set. It servers no other purpose 
and should *not* be used for anything else.

> This creates more confusion for the users than the current state: one 
> had to keep in mind what kind of sets are stored in a list of sets and 
> depending on them, use "src/dst" or "in/out" in the second direction 
> parameter.
Please explain the 'confusion' bit?

I've made it quite clear in the definition of 'in' and 'out' (not least 
in the various man pages which form part of these patch series - a bit 
like you trying to clarify the use of 'src' and 'dst' for the 'iface' 
part in the last ipset update) - 'in' is meant for a match on the 
'incoming', 'out' on the 'outgoing' interfaces.

If one wishes to produce a match against those interfaces, then 'in' and 
'out' is one possible way to go, if not - then use 'src' or 'dst' if you 
feel more comfortable with it.

What I am offering with my patch series is a choice (a choice I didn't 
have before, I might add!) - nobody is forced to use it, except those 
who understand that choice. If one is unwilling/unable to deploy this 
for one reason or another, no problem - quite simple really.

>  And additionally,
>
> iptables -A INPUT -m set --match-set list1 src,src -j ACCEPT
>
> and
>
> iptables -A INPUT -m set --match-set list1 src,in -j ACCEPT
>
> produced different results for the same member sets with the same elements 
> against the same packets. This is unacceptable for me.
>   
You can't expect to issue two different iptables statements (as in your 
example above) and get the same number of matches! Not going to happen, 
is it? By the same token, if I execute the following two statements:

iptables -A INPUT -m set --match-set list1 src,src -j ACCEPT

and

iptables -A INPUT -m set --match-set list1 src,dst -j ACCEPT

The above will also produce "different results for the same member sets 
with the same elements against the same packets". So why is this not 
"unacceptable" then?
