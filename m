From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PACTH nf-next] netfilter: nf_reject_ipv4: don't send tcp RST if
 the packet is non-TCP
Date: Thu, 23 Jun 2016 19:33:28 +0200
Message-ID: <20160623173328.GA2267@salvia>
References: <1466429188-3942-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55523 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272AbcFWRdj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Jun 2016 13:33:39 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 1944E8D0523
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 19:33:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 0A3649EBB2
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 19:33:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D03A29EBA9
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 19:33:29 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1466429188-3942-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jun 20, 2016 at 09:26:28PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> In iptables, if the user add a rule to send tcp RST and specify the
> non-TCP protocol, such as UDP, kernel will reject this request. But
> in nftables, this validity check only occurs in nft tool, i.e. only
> in userspace.
> 
> This means that user can add such a rule like follows via nfnetlink:
>   "nft add rule filter forward ip protocol udp reject with tcp reset"
> 
> This will generate some confusing tcp RST packets. So we should send
> tcp RST only when it is TCP packet.

Applied, thanks.
