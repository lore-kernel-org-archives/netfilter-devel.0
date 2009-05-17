From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: user-space xtables ABI [was Re: [Fwd: Re: iptables pull
 request]]
Date: Sun, 17 May 2009 18:39:29 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0905171822570.6819@fbirervta.pbzchgretzou.qr>
References: <4A0E9786.8060407@netfilter.org> <1242566196.3996.23.camel@dogo.mojatatu.com> <4A10235B.3070607@netfilter.org> <alpine.LSU.2.00.0905171711230.6819@fbirervta.pbzchgretzou.qr> <4A103751.9060501@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: hadi@cyberus.ca,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:43126 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbZEQQj3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 17 May 2009 12:39:29 -0400
In-Reply-To: <4A103751.9060501@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2009-05-17 18:12, Pablo Neira Ayuso wrote:
>Jan wrote:
>>jamal wrote:
>>> With this policy, design errors accumulate along time so we learn the        
>>> lesson from our own mistakes and[...]
>>                                                                               
>> With that policy we end up with the same crap that is happening               
>> in the kernel.                                                                
>                                                                                
>I didn't say that this was nice, it's functional :)

I am saying if we had learnt something then we should not do the same
in userspace.

>> Just because we magically managed to stuff lots of functions into an
>> .so file does not make it public. It just so happens to save a bunch
>> of kilobytes in all of the binaries that were previously statically
>> linked to xtables.c, and was deemed one way to figure out how to deal
>> with intrusive m_ipt. Sorry, but in all efforts that went in so far,
>> I discharge libxtables having a stable API. For that, the iptables
>> code is not beauty enough yet.
>
>I think that we should prioritize backward compatibility versus beauty.

And put a halt on evolvement. Compatibility is the ultimate killer
argument against about anything. Not that I am fuzzing over the
smallish int->bool changes, but potential larger changes.

>> Now, I had to just think of Xtables-addons that has a similar issue.
>
>Indeed, actually I think that a stable ABI would make this easier for you.

Not really. The currently release cycle of iptables is long enough.
