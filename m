From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH pom-ng 0/5] RFC: ip_nat|conntrack_h323.c on 2.6, first
 preview
Date: Wed, 19 Jan 2005 10:59:51 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0501191000400.10476@blackhole.kfki.hu>
References: <20050119004332.GA12629@roonstrasse.net>
	<Pine.LNX.4.58.0501190900080.10476@blackhole.kfki.hu>
	<20050119085615.GD10200@eychenne.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Max Kellermann <max@duempel.org>, netfilter-devel@lists.netfilter.org,
	Robert Iakobashvili <roberti@GoNetworks.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Herve Eychenne <rv@wallfire.org>
In-Reply-To: <20050119085615.GD10200@eychenne.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, 19 Jan 2005, Herve Eychenne wrote:

> > If you want to write a decent helper, then ethereal has got a H.323 (ASN)
> > decoder written in C, which could probably be re-used. :-)
>
> Yes... but do we really want a big ASN-1 parser in the kernel?
> Is there a nice way to have it rely on kernel facilities, while staying in
> userspace though?

We don't really need the complete parsing of H.225/H.245 and that'd make
the code a little bit simpler.

If ctnetlink would be in the vanilla kernel, we could rely on it as well:
the H.323 "helper" could just pass the packets to userspace for inspection
and the expectations would then set up from there.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
