From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ipset problem.
Date: Mon, 25 Jan 2010 12:49:50 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1001251246070.21944@blackhole.kfki.hu>
References: <4B5991E2.4090700@metu.edu.tr> <alpine.DEB.2.00.1001221419550.13886@blackhole.kfki.hu> <alpine.DEB.2.00.1001232157230.18023@blackhole.kfki.hu> <alpine.DEB.2.00.1001232243150.18342@blackhole.kfki.hu> <alpine.DEB.2.00.1001242243560.20757@blackhole.kfki.hu>
 <4B5D4582.2030603@metu.edu.tr> <alpine.DEB.2.00.1001251121370.21525@blackhole.kfki.hu> <4B5D81AF.1090808@metu.edu.tr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "netfilter-devel@vger.kernel.org >> Netfilter Developer Mailing List"
	<netfilter-devel@vger.kernel.org>
To: Husnu Demir <hdemir@metu.edu.tr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:39756 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849Ab0AYLtv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Jan 2010 06:49:51 -0500
In-Reply-To: <4B5D81AF.1090808@metu.edu.tr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 25 Jan 2010, Husnu Demir wrote:

> > On Mon, 25 Jan 2010, Husnu Demir wrote:
> > 
> >> I do download xtables-addons-1.22.tar.bz2 and installed it. It has the 
> >> same problem. 
> > 
> > xtables-addons-1.22 was released two days ago, before ipset-4.2.
> > 
> >> I could not try ipset-4.2.tar.bz2.
> > 
> > Why can't you install ipset itself? What's the problem?
>
> As far as I remember I should pacth the kernel and reload the server 
> which I did not want. But for the xtables no need to reload the kernel.

You have to patch the kernel only if you run 2.4.x, as it is written in 
the README of the ipset source tree...

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
