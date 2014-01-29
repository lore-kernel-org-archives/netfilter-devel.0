From: Florian Westphal <fw@strlen.de>
Subject: Re: TPROXY does not redirect to squid port
Date: Wed, 29 Jan 2014 11:25:04 +0100
Message-ID: <20140129102504.GE30123@breakpoint.cc>
References: <52E8D3AF.4020600@endian.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Peter Warasin <peter@endian.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:46300 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750930AbaA2KZH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 Jan 2014 05:25:07 -0500
Content-Disposition: inline
In-Reply-To: <52E8D3AF.4020600@endian.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Peter Warasin <peter@endian.com> wrote:
> howto on the squid wiki http://wiki.squid-cache.org/Features/Tproxy4
> I setup a tproxy port in squid on port 18080 and created the following
> iptables rule:
> 
> -A PREROUTING -p tcp --dport 80 -j TPROXY --on-port 18080 --tproxy-mark
> 0x1/0x1
> 
> But squid does never see packets coming in.

You need to add policy routing rules.
http://wiki.squid-cache.org/Features/Tproxy4#Routing_configuration
