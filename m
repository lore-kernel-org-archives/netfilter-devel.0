From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] extensions: libxt_mac: Add translation to nft
Date: Tue, 22 Dec 2015 17:48:27 +0100
Message-ID: <20151222164827.GE18134@salvia>
References: <20151222123617.GA8413@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33553 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751178AbbLVQsf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Dec 2015 11:48:35 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 4523E23CF67
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Dec 2015 17:48:34 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 2D68DDA811
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Dec 2015 17:48:34 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 46067DA811
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Dec 2015 17:48:32 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20151222123617.GA8413@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Dec 22, 2015 at 06:06:17PM +0530, Shivani Bhardwaj wrote:
> Add translation for module mac to nftables.
> 
> Examples:
> 
> $ sudo iptables-translate -A INPUT -m mac --mac-source 0a:12:3e:4f:b2:c6 -j DROP
> nft add rule ip filter INPUT  ether saddr 0A:12:3E:4F:B2:C6 counter drop
> 
> $ sudo iptables-translate -A INPUT -p tcp --dport 80 -m mac --mac-source 0a:12:3e:4f:b2:c6 -j ACCEPT
> nft add rule ip filter INPUT tcp dport 80  ether saddr 0A:12:3E:4F:B2:C6 counter accept
                                           ^
                                      I have removed this space.

And mac address I have changed to show in lower-case.

So applied with minor glitches, thanks Shivani.
