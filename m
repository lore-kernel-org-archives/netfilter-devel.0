From: Joe Pruett <joey@clean.q7.com>
Subject: Re: iptables, ipsec, and host2host
Date: Tue, 17 Feb 2009 10:46:29 -0800 (PST)
Message-ID: <alpine.LRH.2.00.0902171044460.25041@q7.q7.com>
References: <alpine.LRH.2.00.0902170903140.25041@q7.q7.com> <499B0097.4000505@trash.net> <alpine.LRH.2.00.0902171029560.25041@q7.q7.com> <alpine.LSU.2.00.0902171940330.999@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from q7.q7.com ([207.173.201.42]:52333 "EHLO q7.q7.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752020AbZBQSqm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Feb 2009 13:46:42 -0500
In-Reply-To: <alpine.LSU.2.00.0902171940330.999@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 17 Feb 2009, Jan Engelhardt wrote:

> ipip is not used for ipsec.

my reading of the code was that in tunnel mode, the next protocol header 
is ip and so the packet then gets handed off to the ip-ip handler.  and 
that is where i saw it being handed off to the recv routine again.  that 
seemed to match what i see with tcpdump since both the ipsec packet and 
the decrypted packet show up.
