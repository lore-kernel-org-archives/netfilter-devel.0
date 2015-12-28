From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] extensions: libxt_pkttype: Add translation to nft
Date: Mon, 28 Dec 2015 13:11:32 +0100
Message-ID: <20151228121132.GA18916@salvia>
References: <20151225150733.GA3105@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58258 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479AbbL1MLs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Dec 2015 07:11:48 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 00E0B1324C2
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Dec 2015 13:11:44 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E6F3EDA85D
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Dec 2015 13:11:43 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 5FC11DA803
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Dec 2015 13:11:41 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20151225150733.GA3105@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Dec 25, 2015 at 08:37:33PM +0530, Shivani Bhardwaj wrote:
> Add translation for packet type to nftables.
> 
> Examples:
> 
> $ sudo iptables-translate -A INPUT -m pkttype --pkt-type broadcast -j DROP
> nft add rule ip filter INPUT pkttype broadcast counter drop
> 
> $ sudo iptables-translate -A INPUT -m pkttype ! --pkt-type unicast -j DROP
> nft add rule ip filter INPUT pkttype != unicast counter drop

Applied, thanks Shivani.
