From: jamal <hadi@cyberus.ca>
Subject: Re: user-space xtables ABI [was Re: [Fwd: Re: iptables
	pull	request]]
Date: Sun, 17 May 2009 12:48:12 -0400
Message-ID: <1242578893.3996.70.camel@dogo.mojatatu.com>
References: <4A0E9786.8060407@netfilter.org>
	 <1242566196.3996.23.camel@dogo.mojatatu.com>
	 <4A10235B.3070607@netfilter.org>
	 <1242573261.3996.36.camel@dogo.mojatatu.com>
	 <4A102FD0.2050007@netfilter.org>
Reply-To: hadi@cyberus.ca
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	Jan Engelhardt <jengelh@medozas.de>,
	Patrick McHardy <kaber@trash.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qy0-f180.google.com ([209.85.221.180]:38852 "EHLO
	mail-qy0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbZEQQs4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 17 May 2009 12:48:56 -0400
Received: by qyk10 with SMTP id 10so630941qyk.33
        for <netfilter-devel@vger.kernel.org>; Sun, 17 May 2009 09:48:57 -0700 (PDT)
In-Reply-To: <4A102FD0.2050007@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, 2009-05-17 at 17:40 +0200, Pablo Neira Ayuso wrote:
> 
> There is an __attribute__((deprecated)) in gcc that displays a message
> during compilation time to warn that the software is using obsolete
> interfaces. Then, we can remove it 1 or 2 years later.

Also something runtime maybe on syslog (example what packet socket
used to do - complaining about tcpdump until they changed it).
I did forget to mention one thing which may sound extreme,
Documentation:
A document aptly named "ABI breakage" which outlines all revisions and
what they break. Maybe even an extra document called
"Deprecation" which announces what is going to break and when.

> In my case, it's been four years with the current library APIs and
> following an evolution approach as you have mentioned (adding new
> functions and obsoleting old ones but keeping them in the tree for a
> while). Now I'm doing more like a full re-design that needs the
> "revolution", no way to keep backward compatibility to resolve several
> issues.

I think there is room for revolutions with the caveat of ample warnings.
Like you said if you have been giving warning for 2 years about
something deprecating then you are absolved of dropping the interface.

> Still, people would be able to have both version 1 and 2 of the
> libraries installed in their computer so they can keep attached to old
> versions without breaking binary backward compatibility. I've been
> discussing this with a friend of mine that maintains a couple of
> critical libraries in the gnome project, it was nice to expose him my
> ideas and see that I was on the right track.

Good motivation to migrate from version 1 to 2 is always a key 
factor. Give me some compelling reason to migrate. At the risk of
sounding politically  incorrect: Example, IPV4 works just fine; add 
NAT and you address the major  sticking point and i dont care about
the fact that IPV6 has the insurance that i can slice bread with it
someday when i need to. OTOH, pay me some $$ per packet
(a .01 Canadian penny would do) and i will migrate to IPV6;->

On Sun, 2009-05-17 at 18:01 +0200, Jan Engelhardt wrote:

> For the kernel modules, it uses a separate compat_xtables.c glue
> module that hides the hacks needed for older versions.
> 
> Would tc profit from something similar for libxtables? It would gain
> the capability to work with iptableses potentially older than the
> reference point. But is that truly required? Upgrading userspace is a
> lot easier than the kernel. If a newer tc is installed on one's
> system, the user might just as well do so for iptables in the same
> run.

If you give me a backward compat i would be happier. I think providing
backward compat in general is important for the reason that the API is
public.
If it is not public, then dont put it in libxtables otherwise I will
use it (and you should not complain;->)
The other side of the coin (point i am trying to make to Pablo above) is
once i get to be backward compat, I have zero reason to upgrade.
The only reason i would want to upgrade is the fear factor that in time
my old binaries will not work. And for that it is polite to give the
user ample warnings...

cheers,
jamal

