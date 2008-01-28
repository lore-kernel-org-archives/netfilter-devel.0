From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: Bug with Fedora's 2.6.23.9-85 kernel (at least) and ESTABLISHED
 and SACK
Date: Mon, 28 Jan 2008 14:38:46 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801281434100.10533@bizon.gios.gov.pl>
References: <479D64B0.10101@acm.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@vger.kernel.org
To: Zan Lynx <zlynx@acm.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([212.244.124.8]:46643 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755188AbYA1Ni5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Jan 2008 08:38:57 -0500
In-Reply-To: <479D64B0.10101@acm.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



On Sun, 27 Jan 2008, Zan Lynx wrote:

> Please CC me on any replies as I am not subscribed.
>
> I was downloading a new Google Earth when I noticed a LOT of max-size dropped 
> packets in my firewall log.  I only allow RELATED,ESTABLISHED sessions into 
> my firewall.
>
> tcpdump showed that every time Google sent a packet to satisfy the missing 
> data identified by SACK, that packet was rejected.  So it must have been 
> missing the ESTABLISHED rule.
>
> I fixed the problem by adding an ALLOW source port 80 rule for the Google 
> download site IP.
>
> This makes me wonder how often this has happened and I haven't noticed it. 
> Is this a known bug or something new?

Which kernel version?

Most likely there is a broken box along the path that mangles seq numbers 
but forgets about sacks. Could you please provide a dump:
"tcpdump -v -S host (...)"?

As a short-term workaround you may disable net.ipv4.tcp_sack or use 
TCPOPTSTRIP to strip SackOK advertisement to the host.

Best regards,

 				Krzysztof Oledzki
