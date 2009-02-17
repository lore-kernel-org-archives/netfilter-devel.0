From: Joe Pruett <joey@clean.q7.com>
Subject: iptables, ipsec, and host2host
Date: Tue, 17 Feb 2009 09:07:01 -0800 (PST)
Message-ID: <alpine.LRH.2.00.0902170903140.25041@q7.q7.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from q7.q7.com ([207.173.201.42]:47900 "EHLO q7.q7.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752571AbZBQRgT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Feb 2009 12:36:19 -0500
Received: from q7.q7.com (localhost [127.0.0.1])
	by q7.q7.com (8.13.1/8.13.1) with ESMTP id n1HH72Jx021131
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Feb 2009 09:07:02 -0800
Received: from localhost (joey@localhost)
	by q7.q7.com (8.13.1/8.13.1/Submit) with ESMTP id n1HH71od021124
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Feb 2009 09:07:01 -0800
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

trying this again on the -devel list.  the basic question i'm trying to 
answer is if there really isn't a way to filter esp/ah packets after 
decryption/decapsulation in host2host mode.  i've looked at what i think 
is the current linus kernel and don't see any changes to esp/ah handling 
to address this.  is tunnel mode the only way i can do filtering on the 
packets after ah/esp have done their work?

> > i have been scouring the net and i can't find any clues to whether i 
> > can do filtering after ipsec has decrypted a packet on a host2host 
> > connection. net2net goes through the filters a second time, but 
> > host2host doesn't seem to do that.  is there some other method i can 
> > use to filter the traffic after being decrypted?
> 
> ok, i'm following up to myself.  i dug into the kernel source (for 
> redhat/centos 5) and have found that there don't appear to be any hooks 
> in the ah4.c or esp4.c code to pass packets back through netfilter after 
> decapsution/decryption.  from what i can tell tunnel mode (net2net) gets 
> the double pass through netfilter only because of the use of the ip-ip 
> protocol and ipip.c does a netif_rx call after decapsulation.
> 
> so maybe i should go dig into the current (from linus) kernel sources to 
> see if there have been any changes.  but i'm hoping that someone here 
> might know if there is a reason that ah/esp packets aren't passed 
> through netfilter again after being decapsulated/decrypted? or should i 
> go find the ipsec mailing list?
> 
> my underlying goal is for a monitoring system that i want to be able to 
> see into customer sites via ipsec, but i don't want them to be able to 
> come back over the ipsec connection to my system.  i could setup tunnels 
> to each site, but host2host is really more what i want.

