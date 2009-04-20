From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] Add support to log original and NAT-ed IP addresses
Date: Mon, 20 Apr 2009 13:23:24 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.0904201315030.10463@blackhole.kfki.hu>
References: <alpine.DEB.2.00.0904201012170.10463@blackhole.kfki.hu> <49EC474E.8090604@netfilter.org> <alpine.DEB.2.00.0904201200240.10463@blackhole.kfki.hu> <49EC5794.8090204@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:56042 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753817AbZDTLXZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Apr 2009 07:23:25 -0400
In-Reply-To: <49EC5794.8090204@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

On Mon, 20 Apr 2009, Pablo Neira Ayuso wrote:

> Jozsef Kadlecsik wrote:
> > 
> > On Mon, 20 Apr 2009, Pablo Neira Ayuso wrote:
> > 
> >>> Attached you can find patches for netfilter and iptabes to support the 
> >>> logging of the original and NAT-ed IP addresses together.
> >>>
> >>> Currently there's no way to do it by netfilter/iptables. If we log in the 
> >>> filter table, there we can record the original src IP address only. 
> >>> However, we cannot log the src IP address after NAT at all: SNAT happens 
> >>> in the nat table at POSTROUTING, and there's no other table to which the 
> >>> logging rule could be added (and the NAT targets return ACCEPT, so we 
> >>> cannot add the loggin rule to the nat table either).
> >>>
> >>> The only way to log src/dst IP before/after NAT presently is to run 
> >>> 'conntrack' in event mode like this:
> >>>
> >>> 	conntrack -E -e NEW | logger -p kernel.info
> >> We can also do this by means of ulogd2 or, alternatively, conntrackd in
> >> its very basic statistics mode.
> > 
> > But ulogd2 requires the ULOG target and ULOG cannot log the SNAT-ed 
> > address either, similarly to the vanilla LOG target: there's presently no 
> > hook at which the information is available for the LOG/ULOG targets.
> 
> I wasn't refering to any iptables target. New ulogd2 includes support
> for ctnetlink, which can do this. I know, that means the extra libraries
> dependencies.

I see. Thanks the info, good to know that ulogd2 is capable of this.
(Calling 'conntrack' for logging looked really ugly. :-)

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
