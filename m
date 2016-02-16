From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] extensions: libxt_tos: Add translation to nft
Date: Tue, 16 Feb 2016 12:26:41 +0100
Message-ID: <20160216112641.GA2144@salvia>
References: <20160214142500.GA3397@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50958 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754515AbcBPL0p (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Feb 2016 06:26:45 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 3FA416C22
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Feb 2016 12:26:44 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 2B1E2A8E3
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Feb 2016 12:26:44 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 5B0F7330D3
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Feb 2016 12:26:42 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160214142500.GA3397@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Feb 14, 2016 at 07:55:00PM +0530, Shivani Bhardwaj wrote:
> Add translation for match tos to nftables.
> 
> Examples:
> 
> $ sudo iptables-translate -A INPUT -m tos --tos 0x02  -j ACCEPT
> nft add rule ip filter INPUT ip tos 0x02 counter accept
> 
> $ sudo iptables-translate -A INPUT -m tos --tos 0x02/0x04  -j ACCEPT
> nft add rule ip filter INPUT ip tos and 0x02 == 0x04 counter accept
> 
> $ sudo iptables-translate -A INPUT -m tos ! --tos 0x02/0x04  -j ACCEPT
> nft add rule ip filter INPUT ip tos and 0x02 != 0x04 counter accept
> 
> Details:
> This patch was sent by Ana, Shivani modified it as per the current
> nftables structure, applied it to the latest branch and tested it.

we're going to get rid of tos in nft soon since dscp supersedes it and
it is not compatible with is, so we won't be supporting this.

So please document this on the wiki. Thanks.
