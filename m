From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: nf_conntrack: set conntrack templates again
 if we	return NF_REPEAT
Date: Wed, 09 Feb 2011 08:09:17 +0100
Message-ID: <4D523D9D.5050405@trash.net>
References: <20110207113905.32414.94829.stgit@decadence> <20110207114051.32414.65019.stgit@decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45878 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238Ab1BIHJS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Feb 2011 02:09:18 -0500
In-Reply-To: <20110207114051.32414.65019.stgit@decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 07.02.2011 12:40, schrieb Pablo Neira Ayuso:
> The TCP tracking code has a special case that allows to return
> NF_REPEAT if we receive a new SYN packet while in TIME_WAIT state.
> 
> In this situation, the TCP tracking code destroys the existing
> conntrack to start a new clean session.
> 
> [DESTROY] tcp      6 src=192.168.0.2 dst=192.168.1.2 sport=38925 dport=8000 src=192.168.1.2 dst=192.168.1.100 sport=8000 dport=38925 [ASSURED]
>     [NEW] tcp      6 120 SYN_SENT src=192.168.0.2 dst=192.168.1.2 sport=38925 dport=8000 [UNREPLIED] src=192.168.1.2 dst=192.168.1.100 sport=8000 dport=38925
> 
> However, this is a problem for the iptables' CT target event filtering
> which will not work in this case since the conntrack template will not
> be there for the new session. To fix this, we reassign the conntrack
> template to the packet if we return NF_REPEAT.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  net/netfilter/nf_conntrack_core.c |   11 +++++++++--
>  1 files changed, 9 insertions(+), 2 deletions(-)

Nice catch. Applied, thanks.
