From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ipset : ip range insertion to hash:net list does not work
Date: Fri, 10 Aug 2012 23:16:59 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1208102313300.12235@blackhole.kfki.hu>
References: <CAK6Qs9nVL6hzcjdaF98RkPhvH-sf+KUYnoeNxMyDvf92O9bK3A@mail.gmail.com> <alpine.DEB.2.00.1208102253290.12102@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: =?UTF-8?Q?=C4=B0brahim_Ercan?= <ibrahim.ercan@engineer.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:52017 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758010Ab2HJVRB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Aug 2012 17:17:01 -0400
In-Reply-To: <alpine.DEB.2.00.1208102253290.12102@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 10 Aug 2012, Jozsef Kadlecsik wrote:

> On Fri, 10 Aug 2012, ?brahim Ercan wrote:
> 
> > Hi. This is my first post. Sorry if there is impropriety. Here is the story.
> > 
> >  I made rpm packet 6.13 for centos 5. While compilation, I got these errors:
> > 
> > ipset v6.13: Syntax error: IP address or IP/cidr must be specified:
> > 1.2.3.4-1.2.3.10
> > print.c:675: error: ?IPPROTO_UDPLITE? undeclared (first use in this function)
> > 
> > Then I added below lines to needed files(print.c , parse.c) and
> > problem solved and I installed rpm.
> > 
> > #ifndef IPPROTO_UDPLITE
> > #define IPPROTO_UDPLITE 136 /* from IANA */
> > #endif
> > 
> > 
> > Now I need to use hash:net and insert ip range. When I call following
> > commands, I get error.
> > 
> > # ipset create foo hash:net family inet
> > # ipset add foo 192.168.0.1-192.168.0.20
> > ipset v6.13: Syntax error: IP address or IP/cidr must be specified:
> > 192.168.0.1-192.168.0.20
> > 
> > Here is some information
> > kernel 3.0.4
> > ipset 6.13
> > iptables 1.4.14
> 
> I'm unable to reproduce this. 

Ohh, you need the kernel modules from the ipset package itself.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
