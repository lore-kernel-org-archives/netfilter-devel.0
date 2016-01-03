From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] extensions: libip6t_ah: Add translation to nft
Date: Sun, 3 Jan 2016 21:22:55 +0100
Message-ID: <20160103202255.GA11992@salvia>
References: <20151231172528.GA11909@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43587 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385AbcACUXG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 Jan 2016 15:23:06 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 250381022A1
	for <netfilter-devel@vger.kernel.org>; Sun,  3 Jan 2016 21:23:03 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 17ACADA801
	for <netfilter-devel@vger.kernel.org>; Sun,  3 Jan 2016 21:23:03 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B423FDA801
	for <netfilter-devel@vger.kernel.org>; Sun,  3 Jan 2016 21:23:00 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20151231172528.GA11909@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Dec 31, 2015 at 10:55:28PM +0530, Shivani Bhardwaj wrote:
> Add translation for AH to nftables.
> 
> Examples:
> 
> $ sudo ip6tables-translate -A INPUT -m ah --ahspi 500 -j DROP
> nft add rule ip6 filter INPUT ah spi 500 counter drop
> 
> $ sudo ip6tables-translate -A INPUT -m ah --ahspi 500:550 -j DROP
> nft add rule ip6 filter INPUT ah spi 500-550 counter drop
> 
> $ sudo ip6tables-translate -A INPUT -m ah ! --ahlen 120
> nft add rule ip6 filter INPUT ah hdrlength != 120 counter
> 
> $ sudo ip6tables-translate -A INPUT -m ah --ahres
> nft add rule ip6 filter INPUT ah reserved 1 counter

Applied, thanks.
