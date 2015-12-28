From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] extensions: libipt_SNAT: Add translation to nft
Date: Mon, 28 Dec 2015 13:20:35 +0100
Message-ID: <20151228122035.GB19188@salvia>
References: <20151225171659.GA11250@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59497 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751845AbbL1MXs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Dec 2015 07:23:48 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 0206515C11C
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Dec 2015 13:23:47 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 6F9994CA0F
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Dec 2015 13:23:46 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D45B152117
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Dec 2015 13:23:31 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20151225171659.GA11250@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Dec 25, 2015 at 10:46:59PM +0530, Shivani Bhardwaj wrote:
> Add translation for target SNAT to nftables.
> 
> Examples:
> 
> $ sudo iptables-translate -t nat -A postrouting -o eth0 -j SNAT --to 1.2.3.4
> nft add rule ip nat postrouting oifname eth0 counter snat 1.2.3.4
> 
> $ sudo iptables-translate -t nat -A postrouting -o eth0 -j SNAT --to 1.2.3.4-1.2.3.6
> nft add rule ip nat postrouting oifname eth0 counter snat 1.2.3.4-1.2.3.6
> 
> $ sudo iptables-translate -t nat -A postrouting -p tcp -o eth0 -j SNAT --to 1.2.3.4:1-1023
> nft add rule ip nat postrouting oifname eth0 ip protocol tcp counter snat 1.2.3.4:1-1023
> 
> $ sudo iptables-translate -t nat -A postrouting -o eth0 -j SNAT --to 1.2.3.4 --random
> nft add rule ip nat postrouting oifname eth0 counter snat 1.2.3.4 random
> 
> $ sudo iptables-translate -t nat -A postrouting -o eth0 -j SNAT --to 1.2.3.4 --random-fully
> nft add rule ip nat postrouting oifname eth0 counter snat 1.2.3.4 fully-random

If two flags are specified, then this should look like:

... postrouting oifname eth0 counter snat 1.2.3.4 fully-random,persistent
                                                              ^

In nft, we always represents flags as command separated values.

Same applied to NFQUEUE translation and its flags; BTW you sent a
patch for this:

http://patchwork.ozlabs.org/patch/559554/

It would be good if you can send a v2:

Thanks.
