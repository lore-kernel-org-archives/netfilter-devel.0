From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCE] ipset 2.4 released
Date: Wed, 22 Oct 2008 00:20:01 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0810212328190.25309@blackhole.kfki.hu>
References: <Pine.LNX.4.64.0810201254190.23040@blackhole.kfki.hu>
 <alpine.LNX.1.10.0810212240190.30799@bizon.gios.gov.pl>
 <Pine.LNX.4.64.0810212300020.25236@blackhole.kfki.hu>
 <alpine.LNX.1.10.0810211707130.16007@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.1.10.0810211707130.16007@fbirervta.pbzchgretzou.qr>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, 21 Oct 2008, Jan Engelhardt wrote:

> On Tuesday 2008-10-21 17:05, Jozsef Kadlecsik wrote:
> >
> >No, the separator between the different kind of elements, i.e. between IP 
> >address and port or between IP address and MAC address. The token 
> >separators inside IPv4(/IPv6) and MAC addresses remain the usual ones.
> >
> >That message is just misleading and I'm going to fix it.
> >
> >Sorry for the mess created by introducing earlier the '%' as a separator,
> >that was a bad choice. :-(
> 
> 	1.2.3.4,5.6.7.8,[2001:db8::90]
> works wonders to distuinguish IPv6 addresses ;-)

Yes, but in my opinion it's ugly. Sometimes [] makes simpler to parse IPv6 
addresses, but fortunately ipset won't need it. (Of course it's easy to 
support square brackets.)

Best regards, 
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
