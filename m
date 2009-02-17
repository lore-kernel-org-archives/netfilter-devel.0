From: Joe Pruett <joey@clean.q7.com>
Subject: Re: iptables, ipsec, and host2host
Date: Tue, 17 Feb 2009 11:13:07 -0800 (PST)
Message-ID: <alpine.LRH.2.00.0902171109410.25041@q7.q7.com>
References: <alpine.LRH.2.00.0902170903140.25041@q7.q7.com> <499B0097.4000505@trash.net> <alpine.LRH.2.00.0902171029560.25041@q7.q7.com> <alpine.LSU.2.00.0902171940330.999@fbirervta.pbzchgretzou.qr> <alpine.LRH.2.00.0902171044460.25041@q7.q7.com>
 <alpine.LSU.2.00.0902171946520.999@fbirervta.pbzchgretzou.qr> <alpine.LRH.2.00.0902171104530.25041@q7.q7.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from q7.q7.com ([207.173.201.42]:53827 "EHLO q7.q7.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740AbZBQTNP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Feb 2009 14:13:15 -0500
In-Reply-To: <alpine.LRH.2.00.0902171104530.25041@q7.q7.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 17 Feb 2009, Joe Pruett wrote:

> i have to now beg forgivness.  i think i ended up doing some of my testing on 
> a rhel/centos 4 box which is only 2.6.9 with ipsec backported.  now that i 
> correctly tested on my version 5 box, everything is working as i expect. 
> follow that with a few minutes of code reading and i convinced myself that 
> host2host just wasn't doing what i wanted.  i'll go crawl back under the 
> rocks now :-).

and i forgot to add that the rhel/centos 4 kernel does not reprocess the 
decrypted/decapsulated packets.  once you accept the ah/esp packet, it 
doesn't go through the iptables again.  this is ok for my scenario where i 
want my central machine to be able to see inside the firewall of the 
remote systems.  i just don't want the remotes to be able to see back 
beyond what the normal firewall allows.  i've already learned about using 
packet marks to allow my net2net traffic to bypass the firewalls and was 
expecting to need the same for host2host and when the first box i tried 
didn't need that, i started digging and got myself turned around.  so at 
least i'm not a total crackpot.
