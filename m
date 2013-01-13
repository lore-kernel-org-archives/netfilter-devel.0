From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: x_tables: print correct hook names for ARP
Date: Sun, 13 Jan 2013 16:07:38 +0100
Message-ID: <20130113150738.GA32515@1984>
References: <1357857005-2825-1-git-send-email-jengelh@inai.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57129 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755138Ab3AMPHo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 13 Jan 2013 10:07:44 -0500
Content-Disposition: inline
In-Reply-To: <1357857005-2825-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 10, 2013 at 11:30:05PM +0100, Jan Engelhardt wrote:
> arptables 0.0.4 supports calling the CLASSIFY target, but on adding a
> rule to the wrong chain, the diagnostic is as follows:
> 
> 	# arptables -A INPUT -j CLASSIFY --set-class 0:0
> 	arptables: Invalid argument
> 	# dmesg | tail -n1
> 	x_tables: arp_tables: CLASSIFY target: used from hooks
> 	PREROUTING, but only usable from INPUT/FORWARD
> 
> This is incorrect, since xt_CLASSIFY.c does specify
> (1 << NF_ARP_OUT) | (1 << NF_ARP_FORWARD).
> 
> This patch corrects the x_tables diagnostic message to print the
> proper hook names for the NFPROTO_ARP case.

I have applied this patch to the nf tree.
