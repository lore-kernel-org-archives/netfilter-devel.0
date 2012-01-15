From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCE] ipset 6.11 released
Date: Sun, 15 Jan 2012 21:21:52 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1201152100050.29766@blackhole.kfki.hu>
References: <alpine.DEB.2.00.1201141542490.26282@blackhole.kfki.hu> <4F130A03.7080208@googlemail.com> <alpine.DEB.2.00.1201151825570.29134@blackhole.kfki.hu> <4F131551.2090608@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:55329 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051Ab2AOUVy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 15 Jan 2012 15:21:54 -0500
In-Reply-To: <4F131551.2090608@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, 15 Jan 2012, Mr Dash Four wrote:

> > > Any chance of fixing this bug soon:
> > > 
> > > ~# ipset n test hash:net family inet timeout 0
> > > ~# ipset a test 10.1.0.0/16
> > > ~# ipset t test 10.1.12.12
> > > 10.1.12.12 is in set test.
> > > ~# ipset t test 10.1.12.0/24
> > > 10.1.12.0/24 is NOT in test.
> > 
> > It's a feature which I'm not going to fix in any near future.
> >   
> It isn't a "feature", it is a bug: 10.1.12.0/24 is within the 10.1.0.0/16
> range, so the above test should return true, not false. Either that, or ip
> range values should be restricted/excluded from the "test" command in the
> ipset userspace binary.

The "test" functionality is already overloaded. It has two "modes":

- you can test how the *kernel* sees the set, when checking a single IP
  address
- you can check whether an *exact* element is added to the set or not.

As the first one overloads the second one, for hash:*net* types the second 
mode is already "incomplete" in the sense that one cannot check whether a 
given single IP address is already added to a hash:*net* type of set as an 
exact element or not, because a network element may match it.

Your request means a third mode, which could lead to even more confusion, 
because that way one could not check whether the tested address as 
*element* is added to the set or not.

There's no magical element-aggregation in the hash:* types. That is, even 
if 10.1.0.0/16 is added as an element, 10.1.0.0/24 can be added again as 
an independent element: either it should be rejected (when the command was 
issued without the --exist flag) or silently ignored (when was issued with 
it). So even to consider your feature requests, it could come only after 
implementing element-aggregation.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
