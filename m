From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] extensions: libipt_ah: Add translation to nft
Date: Fri, 25 Dec 2015 13:07:42 +0100
Message-ID: <20151225120742.GF4308@salvia>
References: <20151224173058.GA6563@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46256 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335AbbLYMHq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Dec 2015 07:07:46 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id B0D607B544
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Dec 2015 13:07:45 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A2878DA807
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Dec 2015 13:07:45 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id DA5AEDA801
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Dec 2015 13:07:43 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20151224173058.GA6563@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Dec 24, 2015 at 11:00:58PM +0530, Shivani Bhardwaj wrote:
> Add translation for Authentication Header to nftables.
> 
> Examples:
> 
> $ sudo iptables-translate -A INPUT -p 51 -m ah --ahspi 500 -j DROP
> nft add rule ip filter INPUT ah spi 500 counter drop
> 
> $ sudo iptables-translate -A INPUT -p 51 -m ah --ahspi 500:600 -j DROP
> nft add rule ip filter INPUT ah spi 500-600 counter drop
> 
> $ sudo iptables-translate -A INPUT -p 51 -m ah ! --ahspi 50 -j DROP
> nft add rule ip filter INPUT ah spi != 50 counter drop

Applied, thanks.
