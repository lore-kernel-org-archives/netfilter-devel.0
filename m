From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Add packet statistics to ipset?
Date: Wed, 23 Jan 2013 20:20:33 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1301232019330.4495@blackhole.kfki.hu>
References: <510029CC.5000902@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Jonathan <jdccdevel@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:42922 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028Ab3AWTUf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jan 2013 14:20:35 -0500
In-Reply-To: <510029CC.5000902@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 23 Jan 2013, Jonathan wrote:

> How difficult would it be to add packet/byte counters to ipset?
> 
> I have a iptables ruleset that I'm looking to simplify, and I would like to
> use the ipset module. However, I also have a need to collect per-host byte
> counters. Currently I scrape them from the iptables output, but with ipset
> this is not possible afaik. This makes the ipset module (which I would
> _really_ like to use) useless for me.
> 
> I am not familiar with kernel programming, but I do know C. If it's not too
> difficult, I would be very interested in helping with implementing this, or
> even implementing it myself with some help.
> 
> Other options I have considered are adding some sort of ip-bitmap or hash
> support to the nfacct system, or an aggregation filter module for ulogd. From
> what I can tell, adding bitmaps/hashes to the nfacct system would be much more
> complicated, and adding an aggregation filter to ulogd would be far less
> efficient.

It was already requested and I'm working on it. The next ipset release 
will come with counters support.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
