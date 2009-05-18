From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: user-space xtables ABI [was Re: [Fwd: Re: iptables	pull	request]]
Date: Mon, 18 May 2009 16:18:19 +0200
Message-ID: <4A116E2B.6050600@netfilter.org>
References: <4A0E9786.8060407@netfilter.org>	 <1242566196.3996.23.camel@dogo.mojatatu.com>	 <4A10235B.3070607@netfilter.org>	 <1242573261.3996.36.camel@dogo.mojatatu.com>	 <4A102FD0.2050007@netfilter.org> <1242578893.3996.70.camel@dogo.mojatatu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	Jan Engelhardt <jengelh@medozas.de>,
	Patrick McHardy <kaber@trash.net>
To: hadi@cyberus.ca
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58852 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752522AbZEROSd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 May 2009 10:18:33 -0400
In-Reply-To: <1242578893.3996.70.camel@dogo.mojatatu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

jamal wrote:
> On Sun, 2009-05-17 at 17:40 +0200, Pablo Neira Ayuso wrote:
>> There is an __attribute__((deprecated)) in gcc that displays a message
>> during compilation time to warn that the software is using obsolete
>> interfaces. Then, we can remove it 1 or 2 years later.
> 
> Also something runtime maybe on syslog (example what packet socket
> used to do - complaining about tcpdump until they changed it).
> I did forget to mention one thing which may sound extreme,
> Documentation:
> A document aptly named "ABI breakage" which outlines all revisions and
> what they break. Maybe even an extra document called
> "Deprecation" which announces what is going to break and when.

That seems fine, although I'm not sure that users usually look at these
sort of files. I think that they wait until things break so they have to
put out the fire :).

>> In my case, it's been four years with the current library APIs and
>> following an evolution approach as you have mentioned (adding new
>> functions and obsoleting old ones but keeping them in the tree for a
>> while). Now I'm doing more like a full re-design that needs the
>> "revolution", no way to keep backward compatibility to resolve several
>> issues.
> 
> I think there is room for revolutions with the caveat of ample warnings.
> Like you said if you have been giving warning for 2 years about
> something deprecating then you are absolved of dropping the interface.
> 
>> Still, people would be able to have both version 1 and 2 of the
>> libraries installed in their computer so they can keep attached to old
>> versions without breaking binary backward compatibility. I've been
>> discussing this with a friend of mine that maintains a couple of
>> critical libraries in the gnome project, it was nice to expose him my
>> ideas and see that I was on the right track.
> 
> Good motivation to migrate from version 1 to 2 is always a key 
> factor. Give me some compelling reason to migrate. At the risk of
> sounding politically  incorrect: Example, IPV4 works just fine; add 
> NAT and you address the major  sticking point and i dont care about
> the fact that IPV6 has the insurance that i can slice bread with it
> someday when i need to. OTOH, pay me some $$ per packet
> (a .01 Canadian penny would do) and i will migrate to IPV6;->

Well, shiny new features is the only thing that I can "sell" in this
case. Something like: "if you migrate from version 1 to 2, you will get
these set of new features in return". Of course, if they don't need
them, it's a hard sell ;).

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
