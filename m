From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] extensions: libxt_conntrack: Add translation to nft
Date: Wed, 15 Jun 2016 14:21:27 +0200
Message-ID: <20160615122127.GA3188@salvia>
References: <20160614180242.GA26384@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Laura Garcia Liebana <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50672 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976AbcFOMVb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jun 2016 08:21:31 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 70BAAE7DBC
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Jun 2016 14:21:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 61D8E1B300D
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Jun 2016 14:21:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 5E0401B3000
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Jun 2016 14:21:28 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160614180242.GA26384@sonyv>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jun 14, 2016 at 08:02:45PM +0200, Laura Garcia Liebana wrote:
> Add translation of conntrack to nftables.
> 
> Examples:
> 
> $ sudo iptables-translate -t filter -A INPUT -m conntrack --ctstate NEW,RELATED -j ACCEPT
> nft add rule ip filter INPUT ct state { new,related } counter accept

No need to use a set here, instead:

nft add rule ip filter INPUT ct state new,related counter accept

> $ sudo ip6tables-translate -t filter -A INPUT -m conntrack ! --ctstate NEW,RELATED -j ACCEPT
> nft add rule ip6 filter INPUT ct state != { new,related } counter accept

Same thing here.

Thanks.
