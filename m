From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCE] ipset 6.7 released
Date: Wed, 1 Jun 2011 09:34:49 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1106010925300.31195@blackhole.kfki.hu>
References: <alpine.DEB.2.00.1105312155260.29607@blackhole.kfki.hu> <1306878128.3171.4.camel@edumazet-laptop> <4DE5619F.5040408@googlemail.com> <alpine.LNX.2.01.1105312347170.14867@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Mr Dash Four <mr.dash.four@googlemail.com>,
	Eric Dumazet <eric.dumazet@gmail.com>,
	netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:50430 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752192Ab1FAHev (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 1 Jun 2011 03:34:51 -0400
In-Reply-To: <alpine.LNX.2.01.1105312347170.14867@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 31 May 2011, Jan Engelhardt wrote:

> On Tuesday 2011-05-31 23:46, Mr Dash Four wrote:
> 
> >> tc filter add dev ifb0 protocol ip parent 10: handle 2 \
> >> 	flow ipset ipset keys src \
> >> 	flowid 1:40
> >>
> >> Any plan on this side ?
> >>  
> > ++1!
> 
> There is already m_xt in iproute2... now it would only need f_xt.
> Maybe you can convince Jamal..

Yes, f_xt would be required to integrate ipset into tc.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
