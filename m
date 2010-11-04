From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: rules matching ipv6 prefix addrs
Date: Thu, 4 Nov 2010 14:34:42 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1011041426350.21953@blackhole.kfki.hu>
References: <4CD12B8B.9090506@plouf.fr.eu.org> <20101103.051925.193703726.davem@davemloft.net> <alpine.LNX.2.01.1011031331170.19124@obet.zrqbmnf.qr> <20101103.145503.104044664.davem@davemloft.net> <5ca75042-e809-4439-856a-e3da43cb6c23@email.android.com>
 <alpine.LNX.2.01.1011032339220.29167@obet.zrqbmnf.qr> <4CD21679.2070508@zytor.com> <4CD29423.6050009@earthlink.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	Jan Engelhardt <jengelh@medozas.de>,
	David Miller <davem@davemloft.net>,
	pascal.mail@plouf.fr.eu.org, netfilter-devel@vger.kernel.org
To: Stephen Clark <sclark46@earthlink.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:48560 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782Ab0KDNeo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Nov 2010 09:34:44 -0400
In-Reply-To: <4CD29423.6050009@earthlink.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 4 Nov 2010, Stephen Clark wrote:

> > Consider for example the case where I get from my ISP the netblock
> > 2001:0db8:ac10::/48.  I subnet this internally with subnet numbers prefixed
> > by /52 security domains, i.e 2001:0db8:ac10:0000::/52,
> > 2001:0db8:ac10:1000::/52 and so forth.  Accordingly, my ip6tables would
> > contain rules as to what kind of traffic can flow between these prefixes.
> > 
> > Now, the upstream (ISP-assigned) prefix changes to 2001:6b2f:1705::/48.  RA
> > will handle reassigning addresses to actual downstream hosts, but things
> > that explicitly encode IPv6 addresses need to be changed, and that includes
> > ip6tables, in this case these rules now need to refer to
> > 2001:6b2f:1705:0000::/52, 2001:62bf:1705:1000::/52 and so on.
> > 
> Won't this break existing tcp connections if all of a sudden you get a new
> address?

Actually, not: according to the IPv6 design, the old prefix and 
address(es) should be kept until there's a single existing connection (and 
the old addresses must not be assigned to new connections of course). That 
gives a smooth path to change prefix anytime.

However, as others already expressed, that does not mean upstream should 
change the prefix anytime. The whole process is to make possible to change 
*ISP* anytime so the administrators are fully aware that there's a prefix 
issue.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
