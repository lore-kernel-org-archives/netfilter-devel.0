From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: user-space xtables ABI [was Re: [Fwd: Re: iptables pull request]]
Date: Sun, 17 May 2009 18:12:01 +0200
Message-ID: <4A103751.9060501@netfilter.org>
References: <4A0E9786.8060407@netfilter.org> <1242566196.3996.23.camel@dogo.mojatatu.com> <4A10235B.3070607@netfilter.org> <alpine.LSU.2.00.0905171711230.6819@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: hadi@cyberus.ca,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37556 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751442AbZEQQMS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 17 May 2009 12:12:18 -0400
In-Reply-To: <alpine.LSU.2.00.0905171711230.6819@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Sunday 2009-05-17 16:46, Pablo Neira Ayuso wrote:
>> With this policy, design errors accumulate along time so we learn the
>> lesson from our own mistakes and, then, we work on a new version 2 of
>> the API to resolve the accumulated issues after some time. This is how
>> I'm managing existing netfilter libraries. This policy makes the
>> developement of libraries/public interfaces slower but I think that
>> users are way happier (no binary breakages).
> 
> With that policy we end up with the same crap that is happening
> in the kernel.

I didn't say that this was nice, it's functional :)

> Just because we magically managed to stuff lots of functions into an
> .so file does not make it public. It just so happens to save a bunch
> of kilobytes in all of the binaries that were previously statically
> linked to xtables.c, and was deemed one way to figure out how to deal
> with intrusive m_ipt. Sorry, but in all efforts that went in so far,
> I discharge libxtables having a stable API. For that, the iptables
> code is not beauty enough yet.

I think that we should prioritize backward compatibility versus beauty.

> Now, I had to just think of Xtables-addons that has a similar issue.

Indeed, actually I think that a stable ABI would make this easier for you.

> For the kernel modules, it uses a separate compat_xtables.c glue
> module that hides the hacks needed for older versions.
> 
> Would tc profit from something similar for libxtables? It would gain
> the capability to work with iptableses potentially older than the
> reference point. But is that truly required? Upgrading userspace is a
> lot easier than the kernel. If a newer tc is installed on one's
> system, the user might just as well do so for iptables in the same
> run.

Sorry, I don't like that policy at all.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
