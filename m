From: Patrick McHardy <kaber@trash.net>
Subject: Re: netfilter: xt_connlimit: pick right dstaddr in NAT scenario
Date: Wed, 26 Jan 2011 16:29:13 +0100
Message-ID: <4D403DC9.2000708@trash.net>
References: <alpine.LNX.2.01.1101261304310.4561@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Jan Rovner <jan.rovner@diadema.cz>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45913 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364Ab1AZP3U (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Jan 2011 10:29:20 -0500
In-Reply-To: <alpine.LNX.2.01.1101261304310.4561@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 26.01.2011 13:07, Jan Engelhardt wrote:
> 
> 
> The following changes since commit 4b3fd57138c969dd940651fadf90db627254edbf:
> 
>   IPVS: Change sock_create_kernel() to __sock_create() (2011-01-22 13:48:01 +1100)
> 
> are available in the git repository at:
>   git://dev.medozas.de/linux connlimit
> 
> Jan Engelhardt (1):
>       netfilter: xt_connlimit: pick right dstaddr in NAT scenario
> 
>  net/netfilter/xt_connlimit.c |   12 ++++++++----
>  1 files changed, 8 insertions(+), 4 deletions(-)
> 
> ===
> 
> parent 4b3fd57138c969dd940651fadf90db627254edbf (v2.6.38-rc1-151-g4b3fd57)
> commit ad86e1f27a9a97a9e50810b10bca678407b1d6fd
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Wed Jan 26 11:50:03 2011 +0100
> 
> netfilter: xt_connlimit: pick right dstaddr in NAT scenario
> 
> xt_connlimit normally records the "original" tuples in a hashlist
> (such as "1.2.3.4 -> 5.6.7.8"), and looks in this list for iph->daddr
> when counting.
> 
> When the user however uses DNAT in PREROUTING, looking for
> iph->daddr -- which is now 192.168.9.10 -- will not match. Thus in
> daddr mode, we need to record the reverse direction tuple
> ("192.168.9.10 -> 1.2.3.4") instead. In the reverse tuple, the dst
> addr is on the src side, which is convenient, as count_them still uses
> &conn->tuple.src.u3.
> 

Pulled, thanks Jan.
