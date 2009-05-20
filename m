From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: conntrack and RSTs received during CLOSE_WAIT
Date: Wed, 20 May 2009 23:40:23 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.0905202327240.11796@blackhole.kfki.hu>
References: <4A0DE859.7000209@tigertech.com> <alpine.DEB.2.00.0905162348430.4156@blackhole.kfki.hu> <4A0F7FEE.3010405@tigertech.com> <4A139222.2020505@tigertech.com> <alpine.DEB.2.00.0905200904310.10018@blackhole.kfki.hu> <4A1466F6.8070304@tigertech.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Robert L Mathews <lists@tigertech.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:55251 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126AbZETVkX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 May 2009 17:40:23 -0400
In-Reply-To: <4A1466F6.8070304@tigertech.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[Cc-ing netfilter-devel]

On Wed, 20 May 2009, Robert L Mathews wrote:

> > It seems that all an attacker needs to do is send invalid RST packets 
> > with a sequence number one less than the last ACK received from the 
> > server. Then conntrack will forget about the connection, allowing the 
> > attacker to open as many connections as desired, regardless of 
> > connlimit limits.
> >
> > I wrote a little perl script that I can leave running in the 
> > background on the client to send the necessary RST packets. In my 
> > testing, it does allow me to bypass connlimit restrictions on a 
> > server:
> > 
> >  http://www.tigertech.net/patches/rawip.pl
> > 
> > This seems to make connlimit less useful than I'd previously believed. 
> > Am I just misunderstanding something?
> 
> > No, you are correct.
> 
> Hmmm, okay. I must say I'm a little surprised by that. I've seen plenty 
> of people using connlimit and connbytes (for example) to protect against 
> all kinds of things, and I don't think it's widely known that it's 
> trivial for an attacker to bypass those restrictions.

I think because it is *not* widely known. The credit is yours for 
discovering how to bypass connlimit/connbytes.
 
> > If you want to eliminate the possibility to bypass connlimit with 
> > properly crafted RST segments, probably you should use the recent 
> > match and count the created NEW connections.
> 
> My goal with connlimit is to limit simultaneous connections so that it
> prevents a single client from using up all the Apache process slots.
> 
> However, I don't want to limit how many connections they can open in a 
> period of time.
> 
> For example, it's perfectly fine for someone to open, say, 500 
> connections per minute, as long as they don't open more than 40 at a 
> time. But I do need to block the 41st simultaneous connection even from 
> people who open up connections very slowly, such as someone who opens up 
> just five connections per hour and never closes them.
> 
> Is that something the "recent" feature can help with? I'm not seeing how
> that's possible, but perhaps I'm missing something.

No, that's not possible with "recent".

Because connlimit/connbytes rely on conntrack, the latter should be 
"fixed". However I do not see any way to make it resistant against such 
attacks: if we shrink the window (by which alogrithm?) we may block valid 
RST segments and thus cause connections to hang instead of termination.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
