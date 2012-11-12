From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: UDP packets sent with wrong source address after routing change
 [AV#3431]
Date: Mon, 12 Nov 2012 20:34:26 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1211122020280.18729@blackhole.kfki.hu>
References: <alpine.DEB.2.02.1211081627150.6644@lap-x201> <alpine.LNX.2.01.1211081829150.28568@nerf07.vanv.qr> <alpine.DEB.2.00.1211081823030.5637@chris-desktop.fen.aptivate.org> <20121110140720.GA9610@1984> <alpine.LNX.2.01.1211101957320.1938@nerf07.vanv.qr>
 <alpine.DEB.2.00.1211102216540.14307@blackhole.kfki.hu> <alpine.DEB.2.02.1211121019280.23195@lap-x201> <alpine.DEB.2.00.1211121556480.18137@blackhole.kfki.hu> <alpine.DEB.2.02.1211121523190.23195@lap-x201>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Chris Wilson <chris-netfilter-110904@aptivate.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:57868 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752507Ab2KLTe2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Nov 2012 14:34:28 -0500
In-Reply-To: <alpine.DEB.2.02.1211121523190.23195@lap-x201>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 12 Nov 2012, Chris Wilson wrote:

> I propose that:
> 
> * when the packet matches an existing conntrack rule, and
> 
> * is sent out of an interface that does not list the packet's new (SNAT-to)
> source address as one of its IP addresses (i.e. if this were a new
> connection, MASQUERADE would not choose this source address), and
> 
> * the --update-source-address flag is set on the MASQUERADE target
> 
> then update the source address on the conntrack rule to the new one.
> 
> That's the same thing that would happen if we deleted the conntrack entry
> first: MASQUERADE would choose a new source address and save it in the new
> conntrack entry.

What do you think about this?

- add route change notification event to the net core
- add --update-source-address flag to the MASQUERADE target
- add a call for such events to the MASQUERADE target, when
  the flag is enabled

The called function then can scan the conntrack table and for every entry 
which has got the update-source-address flag, can check whether the source 
IP address should be changed. Those entries are then deleted.

Best regards,
Joysef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
