From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCE] ipset 6.13 released
Date: Sun, 1 Jul 2012 14:09:32 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1207011405160.2289@blackhole.kfki.hu>
References: <alpine.DEB.2.00.1206292201340.29738@blackhole.kfki.hu> <4FF02A93.8080603@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:53474 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932253Ab2GAMJe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 Jul 2012 08:09:34 -0400
In-Reply-To: <4FF02A93.8080603@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, 1 Jul 2012, Mr Dash Four wrote:

> > I have just released ipset 6.13 with a few bugfixes and some new features.
> > 
> > Userspace changes:
> >  - Explain in more detail src/dst for hash:net,iface
> >   
> Assuming this is what you've had in mind (taken from "man ipset"):
> 
> The second direction parameter of the set match and
> SET target modules corresponds to the incoming/outgoing interface:
> src to the incoming one (similar to the -i flag of iptables), while
> dst to the outgoing one (similar to the -o flag of iptables). When
> the interface is flagged with physdev:, the interface is interpreted
> as the incoming/outgoing bridge port.
> 
> I think that is plain wrong!
> 
> You refer to the incoming interface (interface on which packets arrive) as the
> "source". That cannot be right. To me, it should be a "destination", not
> "source" as the very definition of a "destination" is where something ends,
> this is where a packet arrives and where the journey of the packet "stops" (or
> where the packet is "destined" to arrive anyway). It should definitely not be
> a "source" as the packet does not originate there, nor does it start its
> journey there.
> 
> Similarly for the outgoing interface - this isn't a "destination" interface as
> the packet doesn't arrive there - it is where it starts its journey from!
> 
> So, I think you should reverse both definitions and match "src" with the
> outgoing interface and "dst" with the incoming interface - exactly the
> opposite of what you have now. Documenting something which was done wrong in
> the first place doesn't make it right.

The hash:net,iface type is out for a long time. It is not possible to 
change the meaning of src/dst without breaking backward compatibility, 
therefore I won't do it. As a "workaround" I tried to explain the meaning 
of src/dst for iface as clearly as possible.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
