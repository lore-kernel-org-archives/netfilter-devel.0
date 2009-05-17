From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: user-space xtables ABI [was Re: [Fwd: Re: iptables pull	request]]
Date: Sun, 17 May 2009 17:40:00 +0200
Message-ID: <4A102FD0.2050007@netfilter.org>
References: <4A0E9786.8060407@netfilter.org>	 <1242566196.3996.23.camel@dogo.mojatatu.com>	 <4A10235B.3070607@netfilter.org> <1242573261.3996.36.camel@dogo.mojatatu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	Jan Engelhardt <jengelh@medozas.de>,
	Patrick McHardy <kaber@trash.net>
To: hadi@cyberus.ca
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33248 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753488AbZEQPkK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 17 May 2009 11:40:10 -0400
In-Reply-To: <1242573261.3996.36.camel@dogo.mojatatu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

jamal wrote:
> On Sun, 2009-05-17 at 16:46 +0200, Pablo Neira Ayuso wrote:
> 
>> Now that we have a public API for extensions and your tc ipt thing uses
>> it, I would not expect more breakages as long as we're aware of it.
> [..]
>> I think that, now that we have a public API, ABI should be not broken.
> 
> That would be fantastic.
> 
>> In case that some interface has limitations, we can add a new one while
>> keeping the old. 
> 
> And maybe spit out some warning somewhere that the interface being used
> is deprecated (the way the kernel does it so well currently).

There is an __attribute__((deprecated)) in gcc that displays a message
during compilation time to warn that the software is using obsolete
interfaces. Then, we can remove it 1 or 2 years later.

>> The result is not nice since you end having two
>> functions that do the same with different interfaces but this doesn't
>> break binary backward compatibility. 
> 
> Would be an improvement - currently i have to find out over configure
> scripts at compile time i.e write a little program using old API and if
> doesnt compile, try the next thing etc.
> I think if you also depracate over a period of time the old interface
> by giving ample warnings the API users are surely going to migrate.

Yes, that will help, however some lazy users wait for the breakage to
move on, but who cares about them ;)

>> Of course, the change would need
>> some justification, eg. some client code do need something that the
>> current interface does not allow in any way.
> 
> Indeed.
> 
>> With this policy, design errors accumulate along time so we learn the
>> lesson from our own mistakes and, then, we work on a new version 2 of
>> the API to resolve the accumulated issues after some time. This is how
>> I'm managing existing netfilter libraries. This policy makes the
>> developement of libraries/public interfaces slower but I think that
>> users are way happier (no binary breakages).
> 
> I think there will always be challenges and lessons learnt but i dont
> see the approach you outline as making "development slower" - it just
> forces whoever introduces a new interface thinks at least twice ;->

Right :)

> An evolution instead of a revolution is a lot more acceptable
> i.e build on existing interface and give it more features than totaly
> changing it like you change your socks.

In my case, it's been four years with the current library APIs and
following an evolution approach as you have mentioned (adding new
functions and obsoleting old ones but keeping them in the tree for a
while). Now I'm doing more like a full re-design that needs the
"revolution", no way to keep backward compatibility to resolve several
issues.

Still, people would be able to have both version 1 and 2 of the
libraries installed in their computer so they can keep attached to old
versions without breaking binary backward compatibility. I've been
discussing this with a friend of mine that maintains a couple of
critical libraries in the gnome project, it was nice to expose him my
ideas and see that I was on the right track.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
