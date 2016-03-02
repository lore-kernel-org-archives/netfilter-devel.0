From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] extensions: libip6t_MASQUERADE: Add translation to nft
Date: Wed, 2 Mar 2016 12:51:44 +0100
Message-ID: <20160302115144.GA3579@salvia>
References: <20160302102401.GA9921@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54188 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144AbcCBLvx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Mar 2016 06:51:53 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id BC11C61E9E
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2016 12:51:51 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A64FADA39D
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2016 12:51:51 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 36B2DDA3A5
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2016 12:51:49 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160302102401.GA9921@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 02, 2016 at 03:54:01PM +0530, Shivani Bhardwaj wrote:
> Add translation for masquerade to nftables.
> 
> Examples:
> 
> $ sudo ip6tables-translate -t nat -A POSTROUTING -j MASQUERADE
> nft add rule ip6 nat POSTROUTING counter masquerade
> 
> $ sudo ip6tables-translate -t nat -A POSTROUTING -p tcp -j MASQUERADE --to-ports 10
> nft add rule ip6 nat POSTROUTING ip6 nexthdr tcp counter masquerade to :10
> 
> $ sudo ip6tables-translate -t nat -A POSTROUTING -p tcp -j MASQUERADE --to-ports 10-20 --random
> nft add rule ip6 nat POSTROUTING ip6 nexthdr tcp counter masquerade to :10-20 random

Also applied, thanks Shivani.
