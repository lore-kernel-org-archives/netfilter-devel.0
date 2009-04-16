From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ipt_ACCOUNT 1.15 released
Date: Thu, 16 Apr 2009 23:19:38 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.0904162317130.20364@blackhole.kfki.hu>
References: <200904141744.57570.thomas.jarosch@intra2net.com>  <200904151011.42360.thomas.jarosch@intra2net.com>  <1239788429.11865.20.camel@enterprise.ims-firmen.de>  <200904161834.17450.thomas.jarosch@intra2net.com>
 <1239906586.26220.58.camel@enterprise.ims-firmen.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Thomas Jarosch <thomas.jarosch@intra2net.com>,
	netfilter-devel@vger.kernel.org
To: Thomas Jacob <jacob@internet24.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:47050 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753296AbZDPVTk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Apr 2009 17:19:40 -0400
In-Reply-To: <1239906586.26220.58.camel@enterprise.ims-firmen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 16 Apr 2009, Thomas Jacob wrote:

> On Thu, 2009-04-16 at 18:34 +0200, Thomas Jarosch wrote:
> > Hello Thomas,
> 
> > Interesting findings. The "IPT_BASE_CTL" socket operation usually starts
> > at 64 and then various operations get added to it by incrementing the value.
> > 
> > ipset's socket operations use absolute values like 0x201,
> > I'm wondering if they were registered somewhere or just "allocated".
> 
> include/linux/netfilter_ipv4/ip_set.h
> 
> /*
>  * A sockopt of such quality has hardly ever been seen before on the
> open
>  * market!  This little beauty, hardly ever used: above 64, so it's
>  * traditionally used for firewalling, not touched (even once!) by the
>  * 2.0, 2.2 and 2.4 kernels!
>  *
>  * Comes with its own certificate of authenticity, valid anywhere in the
>  * Free world!
>  *
>  * Rusty, 19.4.2000
>  */
> #define SO_IP_SET       83
> 
> But maybe someone on the list who remembers how this number got
> to be can comment on the issue ;)

Maybe Joakim Axelsson or Rusty could answer it, if they remember how that 
number was figured out.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
