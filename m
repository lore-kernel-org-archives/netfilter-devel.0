From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 1/2] netfilter: add extended accounting infrastructure
 over nfnetlink
Date: Wed, 14 Dec 2011 19:30:29 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1112141926580.7277@blackhole.kfki.hu>
References: <1323860443-7129-1-git-send-email-pablo@netfilter.org> <1323860443-7129-2-git-send-email-pablo@netfilter.org> <alpine.LNX.2.01.1112141439180.16886@frira.zrqbmnf.qr> <20111214165007.GA4765@1984>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org, kaber@trash.net,
	thomas.jarosch@intra2net.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:57898 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757717Ab1LNSac (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 Dec 2011 13:30:32 -0500
In-Reply-To: <20111214165007.GA4765@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 14 Dec 2011, Pablo Neira Ayuso wrote:

> On Wed, Dec 14, 2011 at 02:43:40PM +0100, Jan Engelhardt wrote:
> > On Wednesday 2011-12-14 12:00, pablo@netfilter.org wrote:
> > 
> > >Then, you can use one of this accounting objects in several iptables
> > >rules using the new NFACCT target (which comes in a follow-up patch):
> > >
> > > # iptables -I INPUT -p tcp --sport 80 -j NFACCT --nfacct-name http-traffic
> > > # iptables -I OUTPUT -p tcp --dport 80 -j NFACCT --nfacct-name http-traffic
> > >
> > >The idea is simple: if one packet matches the rule, the NFACCT target
> > >updates the counters.
> > 
> > This smells a lot like -m quota2 --grow, except that yours uses 
> > netlink instead of procfs and can only update the counters.
> > 
> > I suggest to turn -j NFACCT into -m nfacct instead, so that we can add 
> > counting-down mode and matching capabilities, so as to replace 
> > xt_quota*.
> 
> This makes sense.
> 
> My only concern is that -m nfacct will not really match anything (not
> by default at least).
> 
> But with -m nfacct, we can use it in one single multi-match rule, which
> comes in handy.

I second that turning it into a "match" makes it more flexible.

Best regards,
Joysef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
