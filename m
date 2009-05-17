From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: user-space xtables ABI [was Re: [Fwd: Re: iptables pull
 request]]
Date: Sun, 17 May 2009 18:01:17 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0905171711230.6819@fbirervta.pbzchgretzou.qr>
References: <4A0E9786.8060407@netfilter.org> <1242566196.3996.23.camel@dogo.mojatatu.com> <4A10235B.3070607@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: hadi@cyberus.ca,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:45671 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbZEQQBR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 17 May 2009 12:01:17 -0400
In-Reply-To: <4A10235B.3070607@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2009-05-17 16:46, Pablo Neira Ayuso wrote:
>jamal wrote:
>> On Sat, 2009-05-16 at 12:37 +0200, Pablo Neira Ayuso wrote:
>>
>> maybe we can have some simple working relationship rules:
>> 
>> a) whoever breaks ABI (hopefully there are good reasons
>> to intentionally break it) should also fix ipt, just like they
>> fix iptables. 
>> b) whoever breaks the ABI should consider both backward and
>> forward compatibility. I will review patches to make sure this
>> is still so.
>
>I think that, now that we have a public API, ABI should be not broken.
>In case that some interface has limitations, we can add a new one while
>keeping the old. The result is not nice since you end having two
>functions that do the same with different interfaces but this doesn't
>break binary backward compatibility. Of course, the change would need
>some justification, eg. some client code do need something that the
>current interface does not allow in any way.
>
>With this policy, design errors accumulate along time so we learn the
>lesson from our own mistakes and, then, we work on a new version 2 of
>the API to resolve the accumulated issues after some time. This is how
>I'm managing existing netfilter libraries. This policy makes the
>developement of libraries/public interfaces slower but I think that
>users are way happier (no binary breakages).

With that policy we end up with the same crap that is happening
in the kernel.

Just because we magically managed to stuff lots of functions into an
.so file does not make it public. It just so happens to save a bunch
of kilobytes in all of the binaries that were previously statically
linked to xtables.c, and was deemed one way to figure out how to deal
with intrusive m_ipt. Sorry, but in all efforts that went in so far,
I discharge libxtables having a stable API. For that, the iptables
code is not beauty enough yet.

Now, I had to just think of Xtables-addons that has a similar issue.
For the kernel modules, it uses a separate compat_xtables.c glue
module that hides the hacks needed for older versions.

Would tc profit from something similar for libxtables? It would gain
the capability to work with iptableses potentially older than the
reference point. But is that truly required? Upgrading userspace is a
lot easier than the kernel. If a newer tc is installed on one's
system, the user might just as well do so for iptables in the same
run.
