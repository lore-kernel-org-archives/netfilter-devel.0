From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] extensions: libxt_helper: Add translation to nft
Date: Wed, 23 Dec 2015 11:10:47 +0100
Message-ID: <20151223101047.GA2193@salvia>
References: <20151223100840.GA6413@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43201 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933900AbbLWKKw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Dec 2015 05:10:52 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 863C010214F
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Dec 2015 11:10:50 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 6C573DA874
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Dec 2015 11:10:50 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 9071DDA808
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Dec 2015 11:10:48 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20151223100840.GA6413@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Dec 23, 2015 at 03:38:40PM +0530, Shivani Bhardwaj wrote:
> Add translation for helper module to nftables.
> 
> Examples:
> 
> $ sudo iptables-translate -A FORWARD -m helper --helper sip
> nft add rule ip filter FORWARD ct helper \"sip\" counter
> 
> $ sudo iptables-translate -A FORWARD -m helper ! --helper ftp
> nft add rule ip filter FORWARD ct helper != \"ftp\" counter

Applied, thanks.
