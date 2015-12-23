From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] extensions: libxt_NFLOG: Add group_info and remove
 multiple keywords
Date: Wed, 23 Dec 2015 11:13:33 +0100
Message-ID: <20151223101333.GA3026@salvia>
References: <20151222200246.GA11677@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44224 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932485AbbLWKNl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Dec 2015 05:13:41 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 34AB010214F
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Dec 2015 11:13:40 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 254C6DA872
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Dec 2015 11:13:40 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 4AE82DA865
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Dec 2015 11:13:38 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20151222200246.GA11677@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Dec 23, 2015 at 01:32:46AM +0530, Shivani Bhardwaj wrote:
> Add group_info with every rule as it is mandatory to consider logging to
> be same type as NFLOG.
> Remove multiple log keywords to avoid loading multiple log expressions
> at a time.
> 
> Examples:
> 
> $ sudo iptables-translate -I INPUT -j NFLOG --nflog-threshold 2
> nft insert rule ip filter INPUT counter log queue-threshold 2 group 0
> 
> $ sudo iptables-translate -A FORWARD -j NFLOG --nflog-group 32 --nflog-prefix "Prefix 1.0"
> nft add rule ip filter FORWARD counter log prefix \"Prefix 1.0\" group 32

Applied, thanks Shivani.

BTW, it's a good practise to credit people that report problems, ie.
add this tag:

Reported-by: Arturo Borrero <arturoborreroglez@gmail.com>

> Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>

