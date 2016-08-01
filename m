From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables] iptables-translate: add in/out ifname wildcard
 match translation to nft
Date: Mon, 1 Aug 2016 14:22:07 +0200
Message-ID: <20160801122207.GA13771@salvia>
References: <1469856059-11891-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49749 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752342AbcHAMXb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Aug 2016 08:23:31 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 034971683AB
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Aug 2016 14:22:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E7A70FC619
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Aug 2016 14:22:21 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 2699BFAB51
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Aug 2016 14:22:17 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1469856059-11891-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jul 30, 2016 at 01:20:59PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> In iptables, "-i eth+" means match all in ifname with the prefix "eth".
> But in nftables, this was changed to "iifname eth*". So we should handle
> this subtle difference.
> 
> Apply this patch, translation will become:
>   # iptables-translate -A INPUT -i eth+
>   nft add rule ip filter INPUT iifname eth* counter
>   # ip6tables-translate -A OUTPUT ! -o eth+
>   nft add rule ip6 filter OUTPUT oifname != eth* counter

Applied, thanks.
