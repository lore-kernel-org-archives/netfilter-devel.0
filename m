From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 2/3] xtables: deactivate intrapositional support
Date: Mon, 2 Nov 2009 21:49:50 +0100 (CET)
Message-ID: <alpine.DEB.2.00.0911022142340.8139@blackhole.kfki.hu>
References: <1256891969-18437-1-git-send-email-jengelh@medozas.de> <1256891969-18437-3-git-send-email-jengelh@medozas.de> <4AEF0636.6010604@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org,
	Netfilter Core Team <coreteam@netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:44310 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932399AbZKBUtr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Nov 2009 15:49:47 -0500
In-Reply-To: <4AEF0636.6010604@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 2 Nov 2009, Patrick McHardy wrote:

> Jan Engelhardt wrote:
> > In going to fix NF bug #611, "argv" would be needed in
> > xtables_check_inverse to set "optarg" to the right spot in case of an
> > intrapositional negation. Adding argv to the parameter list would
> > cause an API change, which I would like to avoid because it is
> > planned to be thrown out anyway.
> > 
> > So deactive intrapositional support now already, but leave the error
> > message (which has already been there for two releases). Slightly
> > adjust it, because some users have been wondering whether iptables
> > or they are at "fault".
> 
> I'm worried that this is too early, two releases is not particulary
> long and I'd expect a lot of people haven't noticed the warning yet,
> especially on headless systems. Looking at bug #611, we've never
> claimed "-ptcp" would be supported, so this hardly justifies the
> risk IMO.

I agree with Patrick - it's no good to break unknown number of firewall 
setups out there. We did support intrapositional negation and a lot of 
scripts may use that syntax. It's a too high price for "fixing" what's 
actually a feature request.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
