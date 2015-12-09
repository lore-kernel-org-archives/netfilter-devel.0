From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH -next] netfilter: meta: add support for setting
 skb->pkttype
Date: Wed, 9 Dec 2015 23:54:08 +0100
Message-ID: <20151209225408.GA3086@salvia>
References: <1449158201-23868-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44142 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497AbbLIWyY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Dec 2015 17:54:24 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id ECCD732F81
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Dec 2015 23:54:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id DE80EDA7E0
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Dec 2015 23:54:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E9353DA7E0
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Dec 2015 23:54:20 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1449158201-23868-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Dec 03, 2015 at 04:56:41PM +0100, Florian Westphal wrote:
> This allows to redirect bridged packets to local machine.
> 
> ether type ip ether daddr set aa:53:08:12:34:56 meta pkttype set unicast
> 
> Without 'set unicast', ip stack discards PACKET_OTHERHOST skbs.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  Hi Patrick,
> 
>  as discussed this adds meta set support for pkttype.
> 
>  I'm not sure how restricted it should be; this only allows
>  changing PACKET_OTHERHOST to something else, but I'm not sure
>  if this should do more checks on value (e.g. only allow
>  PACKET_HOST?) or even less (e.g. also allow mangling
>  mcast and the like?).
>
>  It only allows NETDEV and BRIDGE families but thats mainly
>  because the other ones make no sense (PACKET_OTHERHOST
>  cannot happen w. IPV4, 6, INET since stack already drops them earlier).

With a 'hash' expression and this mangling, we can emulate the cluster
match (hence its CLUSTERIP target predecesor too).

If mangling doesn't crash the kernel, ie. nonsense configuration just
results in a drop, then I would make no restrictions.
