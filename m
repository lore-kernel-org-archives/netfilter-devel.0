From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ipset : ip range insertion to hash:net list does not work
Date: Mon, 13 Aug 2012 14:03:27 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1208131401350.14727@blackhole.kfki.hu>
References: <CAK6Qs9nVL6hzcjdaF98RkPhvH-sf+KUYnoeNxMyDvf92O9bK3A@mail.gmail.com> <alpine.DEB.2.00.1208102253290.12102@blackhole.kfki.hu> <alpine.DEB.2.00.1208102313300.12235@blackhole.kfki.hu>
 <CAK6Qs9mHoV9GSNmDpA_3feR=x-aNOWAGHH9+0DcPsCYCyiOrNg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: =?UTF-8?Q?=C4=B0brahim_Ercan?= <ibrahim.ercan@engineer.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:52597 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497Ab2HMMD3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 13 Aug 2012 08:03:29 -0400
In-Reply-To: <CAK6Qs9mHoV9GSNmDpA_3feR=x-aNOWAGHH9+0DcPsCYCyiOrNg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 13 Aug 2012, ?brahim Ercan wrote:

> On 11 August 2012 00:16, Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> wrote:
> > On Fri, 10 Aug 2012, Jozsef Kadlecsik wrote:
> >
> >> On Fri, 10 Aug 2012, ?brahim Ercan wrote:
> >>
> >> > Hi. This is my first post. Sorry if there is impropriety. Here is the story.
> >> >
> >> >  I made rpm packet 6.13 for centos 5. While compilation, I got these errors:
> >> >
> >> > ipset v6.13: Syntax error: IP address or IP/cidr must be specified:
> >> > 1.2.3.4-1.2.3.10
> >> > print.c:675: error: ?IPPROTO_UDPLITE? undeclared (first use in this function)
> >> >
> >> > Then I added below lines to needed files(print.c , parse.c) and
> >> > problem solved and I installed rpm.
> >> >
> >> > #ifndef IPPROTO_UDPLITE
> >> > #define IPPROTO_UDPLITE 136 /* from IANA */
> >> > #endif
> >> >
> >> >
> >> > Now I need to use hash:net and insert ip range. When I call following
> >> > commands, I get error.
> >> >
> >> > # ipset create foo hash:net family inet
> >> > # ipset add foo 192.168.0.1-192.168.0.20
> >> > ipset v6.13: Syntax error: IP address or IP/cidr must be specified:
> >> > 192.168.0.1-192.168.0.20
> >> >
> >> > Here is some information
> >> > kernel 3.0.4
> >> > ipset 6.13
> >> > iptables 1.4.14
> >>
> >> I'm unable to reproduce this.
> >
> > Ohh, you need the kernel modules from the ipset package itself.
> 
> I checked all modules, there is no missing. Here is kernel config
> CONFIG_IP_SET=m
> CONFIG_IP_SET_MAX=2560
> CONFIG_IP_SET_BITMAP_IP=m
> CONFIG_IP_SET_BITMAP_IPMAC=m
> CONFIG_IP_SET_BITMAP_PORT=m
> CONFIG_IP_SET_HASH_IP=m
> CONFIG_IP_SET_HASH_IPPORT=m
> CONFIG_IP_SET_HASH_IPPORTIP=m
> CONFIG_IP_SET_HASH_IPPORTNET=m
> CONFIG_IP_SET_HASH_NET=m
> CONFIG_IP_SET_HASH_NETPORT=m
> CONFIG_IP_SET_LIST_SET=m
> 
> By the way gcc version I used is 4.1.2 if you need.

The kernel modules in 3.0.4 are behind of the modules from the ipset 
package.

You need the kernel modules from the ipset package if you want the range 
support in the hash:*net* types.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
