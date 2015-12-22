From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] extensions: libxt_iprange: Add translation to nft
Date: Tue, 22 Dec 2015 17:44:12 +0100
Message-ID: <20151222164412.GB18134@salvia>
References: <20151222070520.GA20511@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:32780 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753851AbbLVQoQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Dec 2015 11:44:16 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 7D8C723CF62
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Dec 2015 17:44:15 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 727A3DA80D
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Dec 2015 17:44:15 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 12B9DDA80B
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Dec 2015 17:44:13 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20151222070520.GA20511@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Dec 22, 2015 at 12:35:20PM +0530, Shivani Bhardwaj wrote:
> Add translation for iprange to nftables.
> 
> Examples:
> 
> $ sudo iptables-translate -A INPUT -m iprange --src-range 192.168.25.149-192.168.25.151 -j ACCEPT
> nft add rule ip filter INPUT  ip saddr 192.168.25.149-192.168.25.151 counter accept
> 
> $ sudo iptables-translate -A INPUT -m iprange --dst-range 192.168.25.149-192.168.25.151 -j ACCEPT
> nft add rule ip filter INPUT  ip daddr 192.168.25.149-192.168.25.151 counter accept

Applied, thanks Shivani.
