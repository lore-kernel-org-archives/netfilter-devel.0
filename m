From: Amos Jeffries <squid3@treenet.co.nz>
Subject: Re: [net-next PATCH 00/16] Transparent proxying patches, take six
Date: Fri, 03 Oct 2008 02:20:42 +1300
Message-ID: <48E4CAAA.3030000@treenet.co.nz>
References: <20081001142431.4893.48078.stgit@este>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from treenet.co.nz ([60.234.233.111]:41771 "EHLO treenet.co.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756416AbYJBNau (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Oct 2008 09:30:50 -0400
Received: from troja.treenetnz.com. (unknown [IPv6:2002:3cea:e96f:0:20d:9dff:fe84:7b47])
	by treenet.co.nz (Postfix) with ESMTP id 8DA43E71A8
	for <netfilter-devel@vger.kernel.org>; Fri,  3 Oct 2008 01:20:41 +1200 (NZST)
In-Reply-To: <20081001142431.4893.48078.stgit@este>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

KOVACS Krisztian wrote:
> Hi Dave,
> 
> This is the sixth round of transparent proxying patches recently
> discussed on the Netfilter Workshop. Since the last incarnation [1]
> we've added support for related ICMP packets in the socket
> match. Should apply cleanly on top of net-next-2.6. Could you please
> apply patches 1-11 (those touching core networking parts) and I'll ask
> Patrick McHardy to take care of patches 12-16 (the Netfilter parts).
>
<snip>
> 
> The last patch adds a short intro on how to use it. A trivial patch
> for netcat demonstrating the necessary modifications for proxies is
> available separately at [3]. Squid has support for it in the 3.HEAD
> (3.1) branch.
> 
> 
> References:
> [1] http://lwn.net/Articles/254527/
> [2] http://marc.info/?l=linux-netdev&m=118065358510836&...
> [3] http://people.netfilter.org/hidden/tproxy/netcat-ip_trans...
> 

Now that these patches got accepted. Can anyone update me on what 
release of iptables and/or kernel are expected to have native TPROXY 
target support?

Cheers and thanks for everything guys

Amos Jeffries
Squid Developer
