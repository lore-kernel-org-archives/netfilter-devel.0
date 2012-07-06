From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [PATCH 0/3] ipset: change 'iface' part in hash:net,iface set
Date: Fri, 06 Jul 2012 22:04:39 +0100
Message-ID: <4FF752E7.90102@googlemail.com>
References: <cover.1341525006.git.mr.dash.four@googlemail.com> <alpine.DEB.2.00.1207060947530.14535@blackhole.kfki.hu> <4FF736FE.8030109@googlemail.com> <alpine.DEB.2.00.1207062138140.16055@blackhole.kfki.hu> <4FF74868.3070303@googlemail.com> <alpine.DEB.2.00.1207062225290.16055@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Core Team <netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:47381 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758021Ab2GFVEs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Jul 2012 17:04:48 -0400
Received: by werb14 with SMTP id b14so6633198wer.19
        for <netfilter-devel@vger.kernel.org>; Fri, 06 Jul 2012 14:04:47 -0700 (PDT)
In-Reply-To: <alpine.DEB.2.00.1207062225290.16055@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> Your example is wrong, because the effect of two command are of course 
> different.
>   
So are yours as well, quite evidently. See my previous reply to Maciej.

> But what I gave above, the results depends from the type of the members of 
> the set list, which is invisible in the command line.
It is quite visible as the 'in' bit suggests (similar to the 'dst' bit).

>  Even if it's 
> stressed in the manpage that "in" is equivalent with "src" but just for 
> the hash:net,iface type,
'In' is defined as match on incoming interface only - if that is not 
clear, then it should be made clear (again, I draw similarities with 
your clarifications of 'src' and 'dst' of the very same issue during the 
last ipset update you've made).

Again, this is a choice for people who understand that choice - if 
someone is uncomfortable with that choice, then s/he is free not to use 
it. if I, on the other hand, am not comfortable with using 'src' and 
'dst' for interface matching (I am sure I am not the only one!) then 
there is a help at hand with the above choice.

>  that is an equivalency and users will expect the 
> same result for the cited commands. And they're right.
>   
How so? How would one expect a match on "income interface only" with a 
match on "source ip addresses, source subnets, source ports, source 
everything else you care to mention ... and income interface" to be an 
"equivalent"? it isn't - not in a million years!

