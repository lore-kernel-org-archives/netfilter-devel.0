From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: RFC: netfilter: xtables: add CT target
Date: Wed, 20 Jan 2010 10:50:36 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1001201039071.8728@blackhole.kfki.hu>
References: <4B5575CB.5050207@trash.net> <alpine.DEB.2.00.1001191115160.3138@blackhole.kfki.hu> <4B558C11.9020607@trash.net> <alpine.DEB.2.00.1001200941070.8728@blackhole.kfki.hu> <4B56CED1.1070109@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:47439 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752398Ab0ATJuh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Jan 2010 04:50:37 -0500
In-Reply-To: <4B56CED1.1070109@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 20 Jan 2010, Patrick McHardy wrote:

> Jozsef Kadlecsik wrote:
> > 
> > On Tue, 19 Jan 2010, Patrick McHardy wrote:
> > 
> >> Adding an event mask to the ecache extension also looks unproblematic.
> >> You could then use a rule like this:
> >>
> >> iptables -t raw .. -j CT --ctevents new,related,protoinfo,helper
> >>
> >> or something like that. Are the existing event types fine grained
> >> enough for this?
> > 
> > The possible events were cut back strongly and now the conntrack state 
> > changes ASSURED and SEEN_REPLY cannot be distinguished. In my opinion 
> > either SEEN_REPLY should not trigger an event at all or IPCT_ASSURED 
> > should be put back.
> 
> I think it makes sense to generate an event for SEEN_REPLY since
> its a synchronizable event (ctnetlink can also set the SEEN_REPLY
> bit). I'm not opposed to add back IPCT_ASSURED, but I'm wondering,
> in what case would userspace be interested in only one of both
> updates?

I have only one case, but I think that's worth it: "sparse" conntrack 
replication. Start replicating the conntrack entry after it reached the 
ASSURED state and that way it's SYN-flood resistant. (Of course conntrack 
could filter out the NEW/SEEN_REPLY state changes and wait for ASSURED, 
but then the events are just sent unnecessarily.)

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
