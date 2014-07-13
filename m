From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] MAINTAINERS: merge ebtables into netfilter entry
Date: Sun, 13 Jul 2014 09:50:26 +0200 (CEST)
Message-ID: <alpine.LSU.2.11.1407130949230.20820@nerf08.vanv.qr>
References: <1402916512-15164-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares08.inai.de ([46.4.84.70]:60427 "EHLO ares08.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751555AbaGMHu3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 13 Jul 2014 03:50:29 -0400
In-Reply-To: <1402916512-15164-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2014-06-16 13:01, Pablo Neira Ayuso wrote:

>Moreover, remove reference to the netfilter users mailing list,
>so they don't receive patches.
>
>-NETFILTER/IPTABLES
>+NETFILTER ({IP,IP6,ARP,EB,NF}TABLES)

I think the combinations should be spelled out so that grepping
for the name continues to match.

+NETFILTER (IPTABLES,IP6TABLES,ARPTABLES,EBTABLES,NFTABLES)
