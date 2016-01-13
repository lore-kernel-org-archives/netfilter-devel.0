From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] extensions: libip6t_REDIRECT: Add translation to nft
Date: Wed, 13 Jan 2016 21:07:54 +0100
Message-ID: <20160113200754.GC16787@salvia>
References: <20160112192644.GA5574@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60984 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752824AbcAMUH6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Jan 2016 15:07:58 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id BA7B5303D00
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Jan 2016 21:07:57 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A9E5ADA804
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Jan 2016 21:07:57 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 3423EDA803
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Jan 2016 21:07:55 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160112192644.GA5574@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jan 13, 2016 at 12:56:44AM +0530, Shivani Bhardwaj wrote:
> Add translation for REDIRECT target to nftables.
> 
> Examples:
> 
> $ sudo ip6tables-translate -t nat -A prerouting -p tcp --dport 80 -j REDIRECT --to-ports 8080
> nft add rule ip6 nat prerouting tcp dport 80 counter redirect to 8080
> 
> $ sudo ip6tables-translate -t nat -A prerouting -p tcp --dport 80 -j REDIRECT --to-ports 8080 --random
> nft add rule ip6 nat prerouting tcp dport 80 counter redirect to 8080 random

Also applied, thanks.
