From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] extensions: libxt_NFQUEUE: Add translation to nft
Date: Tue, 22 Dec 2015 17:40:20 +0100
Message-ID: <20151222164020.GA17410@salvia>
References: <20151221132342.GA2582@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59923 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386AbbLVQkZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Dec 2015 11:40:25 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 7E5E2226F62
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Dec 2015 17:40:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 71C00DA80B
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Dec 2015 17:40:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 04F6CDA85D
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Dec 2015 17:40:22 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20151221132342.GA2582@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Dec 21, 2015 at 06:53:43PM +0530, Shivani Bhardwaj wrote:
> Add translation of NF queue to nftables.
> 
> Examples:
> 
> $ sudo iptables-translate -t nat -A PREROUTING -p tcp --dport 80 -j NFQUEUE --queue-num 30
> nft add rule ip nat PREROUTING tcp dport 80 counter  queue num 30
> 
> $ sudo iptables-translate -A FORWARD -j NFQUEUE --queue-num 0 --queue-bypass -p TCP --sport 80
> nft add rule ip filter FORWARD tcp sport 80 counter  queue num 0 bypass
                                                     ^
Make sure this space is gone in a v2 of this patch.

> $ sudo iptables-translate -A FORWARD -j NFQUEUE --queue-balance 0:3
> nft add rule ip filter FORWARD counter  queue num 0-3 fanout

I think --queue-balance is independent from fanout. Check the code and
make sure this is correct.

> $ sudo iptables-translate -A FORWARD -j NFQUEUE --queue-bypass -p TCP --sport 80 --queue-balance 0:3
> nft add rule ip filter FORWARD tcp sport 80 counter  queue num 0-3 fanout bypass

Although this syntax is correct, we prefer:

nft add rule ip filter FORWARD tcp sport 80 counter queue num 0-3 fanout,bypass
                                                                        ^
                                                comma-separated values for flags.

Thanks.
