From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: conntrack, idle TCP connection and keep-alives
Date: Sun, 27 Oct 2013 21:49:47 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1310272141110.7234@blackhole.kfki.hu>
References: <526C22B8.5030102@torlan.ru> <20131027153408.GA20634@home> <20131027180129.GC27597@macbook.localnet> <20131027183825.GA17696@macbook.localnet> <alpine.DEB.2.10.1310272007460.7234@blackhole.kfki.hu> <20131027192019.GD32366@macbook.localnet>
 <526D6825.2090505@torlan.ru> <20131027193243.GA16338@macbook.localnet> <20131027193434.GA16816@macbook.localnet> <alpine.DEB.2.10.1310272041390.7234@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: WGH <wgh@torlan.ru>, Phil Oester <kernel@linuxace.com>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:60069 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753911Ab3J0Utt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 27 Oct 2013 16:49:49 -0400
In-Reply-To: <alpine.DEB.2.10.1310272041390.7234@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, 27 Oct 2013, Jozsef Kadlecsik wrote:

> On Sun, 27 Oct 2013, Patrick McHardy wrote:
> 
> > On Sun, Oct 27, 2013 at 07:32:44PM +0000, Patrick McHardy wrote:
> > > On Sun, Oct 27, 2013 at 11:23:17PM +0400, WGH wrote:
> > > > On 27.10.2013 23:20, Patrick McHardy wrote:
> > > > > On Sun, Oct 27, 2013 at 08:14:19PM +0100, Jozsef Kadlecsik wrote:
> > > > >> I think a single flag could be sufficient: if the timer in conntrack goes 
> > > > >> off and the entry is in the ESTABLISHED state and this flag is not set, 
> > > > >> then send a TCP keepalive packet and start the timer with a short timeout. 
> > > > >> If we receive the reply packet, then the long ESTABLISHED timeout value 
> > > > >> can be restored and the flag cleared.
> > > > > Sure, I think we wouldn't even need that flag, we can just send the keepalive
> > > > > and set a short timeout. If a RST is received, the connection is killed
> > > > > anyway, otherwise it will be refreshed with the ESTABLISHED timeout.
> > > > >
> > > > > But we do need a timestamp value to pass PAWS.
> > > > I believe you forgot the third scenario: neither ACK nor RST is received
> > > > in reply.
> > > 
> > > Actually no, "... and set a short timeout ...".
> > 
> > Well, OK, we do need a flag to distinguish normal timeout from probe 
> > timeout. But still I don't see how we can do this without increasing the 
> > size of every conntrack by at least 4 bytes.
> 
> Yes, you're right: PAWS assumes all packets carry timestamps option, an 
> option-less ACK isn't sufficient. And increasing every conntrack entry 
> does seem too expensive when the application itself could send keep-alive 
> packets.

Looking at the source code, actually, the Linux TCP stack handles 
gracefully TCP packets without timestamp options when sender originally 
announced TCP timestamps. So it seems to me we could send a simple, 
option-less "keep-alive" packet. RFC1323 does not discuss the case but if 
the option is missing, stacks should fall back to the base handling, 
isn't it? ;-)

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
