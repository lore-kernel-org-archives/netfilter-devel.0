From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] extensions: libxt_owner: Add translation to nft
Date: Thu, 3 Mar 2016 13:21:41 +0100
Message-ID: <20160303122141.GA2094@salvia>
References: <20160302191555.GA32247@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39486 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976AbcCCMVo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Mar 2016 07:21:44 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id CD739C1258
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Mar 2016 13:21:42 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id BBFA4DA388
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Mar 2016 13:21:42 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A92A4DA38A
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Mar 2016 13:21:40 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160302191555.GA32247@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 03, 2016 at 12:45:55AM +0530, Shivani Bhardwaj wrote:
> Add translation for module owner to nftables.
> Full translation of this match awaits the support for --socket-exists
> option.
> 
> Examples:
> 
> $ sudo iptables-translate -t nat -A OUTPUT -p tcp --dport 80 -m owner --uid-owner root -j ACCEPT
> nft add rule ip nat OUTPUT tcp dport 80 skuid 0 counter accept
> 
> $ sudo iptables-translate -t nat -A OUTPUT -p tcp --dport 80 -m owner --gid-owner 0-10 -j ACCEPT
> nft add rule ip nat OUTPUT tcp dport 80 skgid 0-10 counter accept
> 
> $ sudo iptables-translate -t nat -A OUTPUT -p tcp --dport 80 -m owner ! --uid-owner shivani -j ACCEPT
> nft add rule ip nat OUTPUT tcp dport 80 skuid != 1000 counter accept

Applied, thanks Shivani.
