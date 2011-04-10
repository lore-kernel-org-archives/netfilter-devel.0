From: Lennert Buytenhek <buytenh@wantstofly.org>
Subject: Re: ipset issues in 2.6.39-rc2
Date: Sun, 10 Apr 2011 13:44:20 +0200
Message-ID: <20110410114420.GC22881@wantstofly.org>
References: <20110409151655.GA22881@wantstofly.org>
 <alpine.DEB.2.00.1104092203520.32398@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:64214 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289Ab1DJLl3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 10 Apr 2011 07:41:29 -0400
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1104092203520.32398@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Apr 09, 2011 at 10:06:58PM +0200, Jozsef Kadlecsik wrote:

> Hi,

Hi there,


> > On the current Fedora Rawhide kernel (2.6.39-0.rc2.git0.0.fc16), I am
> > seeing the following two issues:
> > 
> > 1. Attempting to create a -j SET rule with a certain invalid set of
> >    flags leaks a reference to the specified pool:
> > 
> > 	# ipset create foo hash:ip
> > 	# ipset list foo | grep References
> > 	References: 0
> > 	# iptables -A INPUT -j SET --del-set foo src,src,src,src,src,src
> > 	iptables: Numerical result out of range.
> > 	# ipset list foo | grep References
> > 	References: 1
> > 	#
> > 
> > 2. --del-set doesn't seem to work (or I don't understand how it's supposed
> >    to work):
> > 
> > 	# ipset create bar hash:ip
> > 	# ipset add bar 127.0.0.1
> > 	# iptables -I INPUT -s 127.0.0.1 -p icmp -j SET --del-set bar src
> > 	# ping -c 1 127.0.0.1
> > 	[...]
> > 	# iptables -L INPUT -v | grep SET
> > 	    2   168 SET        icmp --  *      *       127.0.0.1            0.0.0.0/0           del-set bar src,dst,dst,dst,dst,dst 
> > 	# ipset list bar
> > 	[...]
> > 	Members:
> > 	127.0.0.1
> 
> Both are real bugs indeed. I have sent the fixes to netfilter-devel and 
> I'll release a new ipset version at the weekend. I also fixed the set 
> match/target in iptables to catch properly the invalid number of dir 
> parameters and committed it in git.

I didn't test (1), but your patch at least fixes (2) -- thanks!


cheers,
Lennert
