From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCE] ipset 6.11 released
Date: Fri, 20 Jan 2012 13:49:47 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1201201342400.11124@blackhole.kfki.hu>
References: <alpine.DEB.2.00.1201141542490.26282@blackhole.kfki.hu> <4F130A03.7080208@googlemail.com> <alpine.DEB.2.00.1201151825570.29134@blackhole.kfki.hu> <4F131551.2090608@googlemail.com> <alpine.DEB.2.00.1201152100050.29766@blackhole.kfki.hu>
 <4F135552.4070804@googlemail.com> <alpine.DEB.2.00.1201160914550.30763@blackhole.kfki.hu> <4F175B94.60001@googlemail.com> <alpine.DEB.2.00.1201191154330.7547@blackhole.kfki.hu> <4F189283.4000401@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:41309 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751352Ab2ATMtt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Jan 2012 07:49:49 -0500
In-Reply-To: <4F189283.4000401@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 19 Jan 2012, Mr Dash Four wrote:

> > The userspace testing is passed to the kernel for execution. There's no
> > shadow or backup or whatever set in userspace. The sets exist in kernel
> > space and therefore all operations happen there.
> >   
> So, is the above doable in any shape or form or not?

Doable, but needs time and would involve adding the logic to auto-merge 
smaller subnets into larger ones and to make possible to delete subnets 
from larger networks.

I'm sure you are aware, this is a free time project.

> > Why do you need such tests at all?
> >   
> Various reasons. Two common uses (at least in my case) would be to test ip
> range against quite a large set of registered subnets (taken from the geoip
> database and sorted using my own criteria). The tested ip range is either
> candidate to 1). ban that network, in which case I do not want duplicates if
> the existing range is already there; or 2) include the ip range in a separate
> set, making sure that it is not already in the 'banned' set and also that it
> is not already included in the 'customer' set (which although limited, has
> quite significant number of set members - usually small subnets).
> 
> Because the ip range in ipset is not working correctly, I had to first
> manually go over the testing ranges. Later on I devised a small shell script
> doing what I just described in my previous post (quoted above), but it is
> quite ugly and inefficient - it would be much better if ip range testing in
> ipset was functioning properly, saving me all this hassle.

Sorry, for a while you have to use workarounds like you described.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
