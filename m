From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] extensions: libxt_sctp: Add translation to nft
Date: Thu, 3 Mar 2016 13:22:01 +0100
Message-ID: <20160303122201.GB2094@salvia>
References: <20160302192848.GA683@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39644 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247AbcCCMWE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Mar 2016 07:22:04 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 1DA18C1259
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Mar 2016 13:22:03 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 0D43EDA39D
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Mar 2016 13:22:03 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B797ADA8F7
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Mar 2016 13:22:00 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160302192848.GA683@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 03, 2016 at 12:58:48AM +0530, Shivani Bhardwaj wrote:
> Add translation for sctp to nftables.
> Full translation of this match awaits the support for --chunk-types
> option.
> 
> Examples:
> 
> $ sudo iptables-translate -A INPUT -p sctp --dport 80 -j DROP
> nft add rule ip filter INPUT sctp dport 80 counter drop
> 
> $ sudo iptables-translate -A INPUT -p sctp ! --sport 80:100 -j ACCEPT
> nft add rule ip filter INPUT sctp sport != 80-100 counter accept

Also applied, thanks.
