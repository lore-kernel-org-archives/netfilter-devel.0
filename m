From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: ipt_ACCOUNT 1.15 released
Date: Mon, 20 Apr 2009 12:19:27 +0200
Message-ID: <200904201219.28011.thomas.jarosch@intra2net.com>
References: <200904141744.57570.thomas.jarosch@intra2net.com> <200904161834.17450.thomas.jarosch@intra2net.com> <1239906586.26220.58.camel@enterprise.ims-firmen.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Thomas Jacob <jacob@internet24.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rs02.intra2net.com ([81.169.173.116]:57811 "EHLO
	rs02.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362AbZDTKTb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Apr 2009 06:19:31 -0400
In-Reply-To: <1239906586.26220.58.camel@enterprise.ims-firmen.de>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday, 16. April 2009 20:29:46 Thomas Jacob wrote:
> Also, in order to make IPv6 accounting practical, I would probably add
> some sort of subnet accounting along the following lines.
>
> -j ACCOUNT --network 1234:4567::/32 --account_mask /64
>
> which would only account packets in --network, and count data
> for a whole subnet instead of a single IP, as assigning single
> IPv6 addresses to customers is kind of silly in an ISP environment.
>
> To collect data for single IPs just use --account_mask 128.

Well, for IPv4 you can alreay use "--src 172.16.0.0/16"
and then do "-j ACCOUNT --addr 0.0.0.0/0" to merge
the complete subnet into one single IP address.

This should be possible with IPv6, too.

> Another idea, possibly useful from an ISP perspective, might be
> to only start the counters (i.e. add the entry to the hash bucket) if
> packets with the IP/subnet have arrived from a certain direction first.
>
> This way, your tables don't overflow with all the IP scans
> from the Internet.

Maybe a conntrack "state" match can help here?

> approaches taken by ipt_ACCOUNT or ipt_account. All I am interested in
> is a byte counter per target IP/subnet that can be queried once a day
> so that I know who is consuming my bandwidth. Something that passes
> each connection track to user space doesn't look so good for that.
>
> But maybe I am wrong about this, I  haven't actually tried to use it.

Me neither :-) IIRC the problem in the past was that ulogd (v1) could lose 
packets when the userspace <-> kernel communication queue was not processed
as fast as new packets arrived. Though my memory on this is quite blurry...

Thomas

