From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] netfilter: nf_ct_tcp: better handling for SYN retransmissions
 after SYN+ACK
Date: Sat, 26 Feb 2011 22:45:22 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1102262238360.23113@blackhole.kfki.hu>
References: <20110226032834.4335.74168.stgit@decadence> <20110226033324.4335.53000.stgit@decadence> <alpine.DEB.2.00.1102261917180.22866@blackhole.kfki.hu> <4D695E73.2090006@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
	Changli Gao <xiaosuo@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:36360 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112Ab1BZVpY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 26 Feb 2011 16:45:24 -0500
In-Reply-To: <4D695E73.2090006@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

On Sat, 26 Feb 2011, Pablo Neira Ayuso wrote:

> On 26/02/11 19:30, Jozsef Kadlecsik wrote:
> > Maybe I'm just blind, but I don't see what you try to achieve. Actually, 
> > with your patch you switch off the path which would handle the case when 
> > conntrack holds an outdated entry from whatever reason.
> > 
> > Present code, cases:
> > 
> > a. conntrack in sync, SYN/ACK lost and client resends the SYN
> >    - we ignore it but it does not do any harm
> > b. conntrack entry is outdated, new SYN received
> >    - we ignore it but save the initialization data from it
> >    - when the reply SYN/ACK receives and it matches the saved data,
> >      we pick up the new connection
> 
> This is what it seems at first sight, but this is not what it happens if
> the conntrack is in SYN_RECV state.
> 
> Initially, the SYN packet hits first item of 'b', thus we save data from
> it. But the SYN/ACK packet is considered a retransmission given that
> we're in SYN_RECV state. Therefore, we never hit the second item of 'b'.

Yes, you're right! We don't hit 'b' in the SYN_RECV state.
 
> > With your patch, cases:
> > 
> > a. conntrack in sync, SYN/ACK lost and client resends the SYN
> >   - SYN is out of window and will be marked as invalid
> > b. conntrack entry is outdated, new SYN received
> >   - SYN is out of window and will be marked as invalid
> 
> Damn, you're right, this patch is broken, that SYN packet won't pass
> boundary III, IIRC.
> 
> > What do I miss?
> 
> That we're in SYN_RECV state :-).
> 
> >> This patch also helps a lot to conntrackd in stress scenarios
> >> (assumming a client that generates lots of small TCP connections).
> >> During the failover, consider that the new primary has injected
> >> one outdated flow in SYN_RECV state (this is likely to happen if
> >> the conntrack event rate is high because the backup will be a bit
> >> delayed from the primary). With the current code, if the client
> >> starts a new fresh connection that matches the tuple, the SYN
> >> packet will be ignored without updating the state tracking, and
> >> the SYN+ACK in reply will blocked as it will not pass checkings
> >> III or IV (since all state tracking in the original direction is
> >> not initialized because of the SYN packet was ignored).
> > 
> > The last_dir entries are updated from the ignored SYN packet and thus the 
> > SYN+ACK won't be blocked - if the packet is a true answer to the SYN.
> 
> This is what it happens with other states, but not for SYN_RECV.
> 
> I have reworked the patch and the description. With this, the SYN_RECV
> state if we're out of sync receives the same handling.
> 
> I have test it here, it works fine. Let me know if you're OK with it.

The patch looks OK but I think Changli Gao is also right and it'd be 
simpler to set the [reply][synack][SR] state to sIG. What do you think?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
