From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ipset website
Date: Sun, 30 Nov 2014 20:33:33 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1411302030150.3940@blackhole.kfki.hu>
References: <547919CB.7030202@nospam.hostisimo.com> <alpine.LSU.2.11.1411290212430.31411@nerf08.vanv.qr> <547946BA.106@nospam.hostisimo.com> <alpine.LSU.2.11.1411291212290.5728@nerf08.vanv.qr> <547A0277.3040301@nospam.hostisimo.com>
 <547A3893.1060009@nospam.hostisimo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Mike Wright <nobody@nospam.hostisimo.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:34315 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751614AbaK3Tch (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Nov 2014 14:32:37 -0500
In-Reply-To: <547A3893.1060009@nospam.hostisimo.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, 29 Nov 2014, Mike Wright wrote:

> On 11/29/2014 09:29 AM, Mike Wright wrote:
> > 
> Upgraded to ipset-6.24
> > 
> > Ready for review.
> > 
> > site: http://ipset.hostisimo.com
> > diff: http://ipset.hostisimo.com/diff
> > bzip: http://ipset.hostisimo.com/ipset.netfilter.org.tar.bz2
> > 
> > Does anybody else have any comments?

According to the diff:

Only in new/ipset.netfilter.org: ipset.php
Only in new/ipset.netfilter.org: iptables-extensions.php
Only in new/ipset.netfilter.org: iptables.php

There's no php at the site at all, it's totally static. Please keep 
the html files.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
