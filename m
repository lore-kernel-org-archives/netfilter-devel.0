From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] extensions: libxt_dccp: Add translation to nft
Date: Thu, 3 Mar 2016 18:59:30 +0100
Message-ID: <20160303175930.GA2055@salvia>
References: <20160301131133.GA9134@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60955 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757622AbcCCR7h (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Mar 2016 12:59:37 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 448114B112
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Mar 2016 18:59:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 334BADA8FB
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Mar 2016 18:59:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 32C38DA8F8
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Mar 2016 18:59:29 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160301131133.GA9134@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 01, 2016 at 06:41:33PM +0530, Shivani Bhardwaj wrote:
> Add translation for dccp to nftables.
> 
> Full translation of this match awaits the support for --dccp-option.
> Also, since inversion of set is not possible in nftables, using dccp
> with rules like
> ...dccp type != {request, response}..
> is going to throw errors.

Yes, this needs a small patch for the kernel and some userspace bits.
Please document that we need inversion of sets support in the wiki so
we can assign this task to someone.

> Examples:
> 
> $ sudo iptables-translate -A INPUT -p dccp -m dccp --sport 100
> nft add rule ip filter INPUT dccp sport 100 counter
> 
> $ sudo iptables-translate -A INPUT -p dccp -m dccp --dport 100:200
> nft add rule ip filter INPUT dccp dport 100-200 counter
> 
> $ sudo iptables-translate -A INPUT -p dccp -m dccp ! --dport 100
> nft add rule ip filter INPUT dccp dport != 100 counter
> 
> $ sudo iptables-translate -A INPUT -p dccp -m dccp --dccp-type REQUEST,RESPONSE
> nft add rule ip filter INPUT dccp type {request, response} counter

Could you send a v2 removing the invalid type as it doesn't make any
sense?

Thanks.
