From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] Allow use of 'socket' match in OUTPUT
Date: Mon, 27 Apr 2015 13:47:59 +0200
Message-ID: <20150427114759.GA6278@salvia>
References: <CAOmdcgWRmvq=4Fd8WN=QwptAXNUST49uAPU1BLa=ykterAyPhw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Harry Mason <harry.mason@smoothwall.net>
To: Daniel Collins <daniel.collins@smoothwall.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45491 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752936AbbD0Lnc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 27 Apr 2015 07:43:32 -0400
Content-Disposition: inline
In-Reply-To: <CAOmdcgWRmvq=4Fd8WN=QwptAXNUST49uAPU1BLa=ykterAyPhw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Apr 20, 2015 at 11:19:16AM +0100, Daniel Collins wrote:
> Hi
> 
> A little background: The 'socket' match is used with the tproxy
> feature, so a process may bind to and spoof an arbitrary client IP
> address. In iptables, the socket match is used in PREROUTING to match
> any traffic addressed to such sockets, we then use that to set a mark
> on the packet and force it to be routed locally rather than being
> passed onto the real holder of that IP address.
> 
> If tproxy AND iptables-controlled policy routing (i.e. set mark in
> OUTPUT, use that in ip rule) is in use AND the new egress interface
> has a lower MTU than the original AND the server sent us a SYN-ACK
> packet with an MSS larger than the new egress interface can transmit,
> Linux will generate an ICMP fragmentation needed message, but we don't
> get to process that since socket cannot be used in OUTPUT.

I think you can use the TCPMSS target from INPUT to mangle the mss to
your mtu. I guess you're willing to avoid fragmentation as well.
