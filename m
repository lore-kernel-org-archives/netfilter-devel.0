From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v4] extensions: libxt_devgroup: Add translation to nft
Date: Fri, 25 Dec 2015 13:07:08 +0100
Message-ID: <20151225120708.GD4308@salvia>
References: <20151223144402.GA17250@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46207 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335AbbLYMHQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Dec 2015 07:07:16 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 0F8D57B551
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Dec 2015 13:07:15 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 01A5DDA801
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Dec 2015 13:07:15 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 24009DA80C
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Dec 2015 13:07:13 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20151223144402.GA17250@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Dec 23, 2015 at 08:14:02PM +0530, Shivani Bhardwaj wrote:
> Add translation for device group to nftables.
> 
> Examples:
> 
> $ sudo iptables-translate -A FORWARD -m devgroup --src-group 0x2 -j ACCEPT
> nft add rule ip filter FORWARD iifgroup 0x2 counter accept
> 
> $ sudo iptables-translate -A FORWARD -m devgroup --dst-group 0xc/0xc -j ACCEPT
> nft add rule ip filter FORWARD oifgroup and 0xc == 0xc counter accept
> 
> $ sudo iptables-translate -t mangle -A PREROUTING -p tcp --dport 46000 -m devgroup --src-group 23 -j ACCEPT
> nft add rule ip mangle PREROUTING tcp dport 46000 iifgroup 0x17 counter accept
> 
> $ sudo iptables-translate -A FORWARD -m devgroup ! --dst-group 0xc/0xc -j ACCEPT
> nft add rule ip filter FORWARD oifgroup and 0xc != 0xc counter accept
> 
> $ sudo iptables-translate -A FORWARD -m devgroup ! --src-group 0x2 -j ACCEPT
> nft add rule ip filter FORWARD iifgroup != 0x2 counter accept

Applied, thanks.
