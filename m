From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] extensions: libip6t_hl: Add translation to nft
Date: Wed, 13 Jan 2016 21:07:23 +0100
Message-ID: <20160113200723.GA16787@salvia>
References: <20160112142829.GA5879@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60940 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752213AbcAMUH2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Jan 2016 15:07:28 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 0D7E7303D01
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Jan 2016 21:07:27 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id F225EDA801
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Jan 2016 21:07:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 358C4DA807
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Jan 2016 21:07:24 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160112142829.GA5879@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jan 12, 2016 at 07:58:29PM +0530, Shivani Bhardwaj wrote:
> Add translation for hop limit to nftables.
> 
> Examples:
> 
> $ sudo ip6tables-translate -t nat -A postrouting -m hl --hl-gt 3
> nft add rule ip6 nat postrouting ip6 hoplimit gt 3 counter
> 
> $ sudo ip6tables-translate -t nat -A postrouting -m hl ! --hl-eq 3
> nft add rule ip6 nat postrouting ip6 hoplimit != 3 counter

Applied, thanks.
