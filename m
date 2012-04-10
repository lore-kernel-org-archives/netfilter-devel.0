From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: nomatch in bitmap:* sets
Date: Tue, 10 Apr 2012 14:36:20 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1204101434360.7730@blackhole.kfki.hu>
References: <4F81A7E5.3040400@googlemail.com> <alpine.DEB.2.00.1204082006190.4765@blackhole.kfki.hu> <4F82110E.70100@googlemail.com> <alpine.DEB.2.00.1204092031110.6233@blackhole.kfki.hu> <4F835B99.8060901@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:60812 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758374Ab2DJMgW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Apr 2012 08:36:22 -0400
In-Reply-To: <4F835B99.8060901@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 9 Apr 2012, Mr Dash Four wrote:

> > That's equivalent with
> > 
> > n test-ports bitmap:port range 1-1023 timeout 0
> > a test-ports 1-1023
> > d test-ports 21
> > d test-ports 80
> > d test-ports 119
> > d test-ports 443
> >   
> It is indeed! That's something I did not know about! The "delete" command
> wasn't acceptable in ipset restore file before (in all honesty I did try this
> back in 4.x and gave up after it was rejected). Which version of ipset was
> this introduced into?

That was introduced in 6.x (actually, in 5.x).

Every command is accepted in a restore file, except the information ones 
(help, list).

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
