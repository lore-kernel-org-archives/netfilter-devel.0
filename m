From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/2] netfilter: ctnetlink: fix wrong message type in user
 updates
Date: Tue, 05 May 2009 17:49:06 +0200
Message-ID: <4A005FF2.7010502@trash.net>
References: <20090505131219.7241.85258.stgit@Decadence> <20090505131429.7241.88268.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45294 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbZEEPtI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 May 2009 11:49:08 -0400
In-Reply-To: <20090505131429.7241.88268.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> This patch fixes the wrong message type that are triggered by
> user updates, the following commands:
> 
> (term1)# conntrack -I -p tcp -s 1.1.1.1 -d 2.2.2.2 -t 10 --sport 10 --dport 20 --state LISTEN
> (term1)# conntrack -U -p tcp -s 1.1.1.1 -d 2.2.2.2 -t 10 --sport 10 --dport 20 --state SYN_SENT
> (term1)# conntrack -U -p tcp -s 1.1.1.1 -d 2.2.2.2 -t 10 --sport 10 --dport 20 --state SYN_RECV
> 
> only trigger event message of type NEW, when only the first is NEW
> while others should be UPDATE.
> 
> (term2)# conntrack -E
>     [NEW] tcp      6 10 LISTEN src=1.1.1.1 dst=2.2.2.2 sport=10 dport=20 [UNREPLIED] src=2.2.2.2 dst=1.1.1.1 sport=20 dport=10 mark=0
>     [NEW] tcp      6 10 SYN_SENT src=1.1.1.1 dst=2.2.2.2 sport=10 dport=20 [UNREPLIED] src=2.2.2.2 dst=1.1.1.1 sport=20 dport=10 mark=0
>     [NEW] tcp      6 10 SYN_RECV src=1.1.1.1 dst=2.2.2.2 sport=10 dport=20 [UNREPLIED] src=2.2.2.2 dst=1.1.1.1 sport=20 dport=10 mark=0
> 
> This patch also removes IPCT_REFRESH from the bitmask since it is
> not of any use.

Also applied, thanks.
