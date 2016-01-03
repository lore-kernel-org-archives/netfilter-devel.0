From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] extensions: libxt_length: Add translation to nft
Date: Sun, 3 Jan 2016 21:25:16 +0100
Message-ID: <20160103202516.GA18244@salvia>
References: <20151229182425.GA7400@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43674 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385AbcACUZY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 Jan 2016 15:25:24 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 3E61E1022A1
	for <netfilter-devel@vger.kernel.org>; Sun,  3 Jan 2016 21:25:23 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 30645DA7E0
	for <netfilter-devel@vger.kernel.org>; Sun,  3 Jan 2016 21:25:23 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 4F965DA804
	for <netfilter-devel@vger.kernel.org>; Sun,  3 Jan 2016 21:25:21 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20151229182425.GA7400@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Dec 29, 2015 at 11:54:25PM +0530, Shivani Bhardwaj wrote:
> Add translation for module length to nftables.
> 
> Examples:
> 
> $ sudo iptables-translate -A INPUT -p icmp -m length --length 86:0xffff -j DROP
> nft add rule ip filter INPUT ip protocol icmp meta length 86-65535 counter drop
> 
> $ sudo iptables-translate -A INPUT -p udp -m length --length :400
> nft add rule ip filter INPUT ip protocol udp meta length 0-400 counter
> 
> $ sudo iptables-translate -A INPUT -p udp -m length --length 40
> nft add rule ip filter INPUT ip protocol udp meta length 40 counter
> 
> $ sudo iptables-translate -A INPUT -p udp -m length ! --length 40
> nft add rule ip filter INPUT ip protocol udp meta length != 40 counter

Applied, thanks.
