From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: RFC: netfilter: xtables: add CT target
Date: Wed, 20 Jan 2010 10:19:03 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1001200941070.8728@blackhole.kfki.hu>
References: <4B5575CB.5050207@trash.net> <alpine.DEB.2.00.1001191115160.3138@blackhole.kfki.hu> <4B558C11.9020607@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:42986 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490Ab0ATJTI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Jan 2010 04:19:08 -0500
In-Reply-To: <4B558C11.9020607@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

On Tue, 19 Jan 2010, Patrick McHardy wrote:

> Jozsef Kadlecsik wrote:
> > On Tue, 19 Jan 2010, Patrick McHardy wrote:
> > 
> >> The attached two patches add a 'CT' target to specify parameters
> >> used during conntrack creation. This can be used to manually attach
> >> a helper to a connection. A couple of patches I'm still working
> >> on will additionally use this for the "conntrack zones" classification.
> >>
> >> I'm wondering if anyone has further ideas of parameters that might
> >> make sense to support. We could for example move parameters like
> >> sip_direct_signalling and sip_direct_media into the helper structure
> >> and allow to set them dynamically for each connection. Or perhaps
> >> selectively enable netlink events.
> > 
> > Selectively enabling netlink events (not only per connection but per event 
> > type) would be cool! Last year I used the CONNMARK target for that purpose 
> > - maybe it fits better to the CT target.
> 
> I think it would be a good fit since you probably would want to specify
> the events to be delivered before the conntrack is created.
> 
> Adding an event mask to the ecache extension also looks unproblematic.
> You could then use a rule like this:
> 
> iptables -t raw .. -j CT --ctevents new,related,protoinfo,helper
> 
> or something like that. Are the existing event types fine grained
> enough for this?

The possible events were cut back strongly and now the conntrack state 
changes ASSURED and SEEN_REPLY cannot be distinguished. In my opinion 
either SEEN_REPLY should not trigger an event at all or IPCT_ASSURED 
should be put back.

> Also, should the CT target override the global sysctl setting?

Yes, definitely.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
