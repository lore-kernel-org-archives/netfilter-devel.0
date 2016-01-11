From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] extensions: libxt_cgroup: Add translation to nft
Date: Mon, 11 Jan 2016 20:00:53 +0100
Message-ID: <20160111190053.GA15977@salvia>
References: <20160108195313.GA2507@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52496 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933424AbcAKTA6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Jan 2016 14:00:58 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id E2944E3A05
	for <netfilter-devel@vger.kernel.org>; Mon, 11 Jan 2016 20:00:56 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id CA21DDA804
	for <netfilter-devel@vger.kernel.org>; Mon, 11 Jan 2016 20:00:56 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 7B0BEDA807
	for <netfilter-devel@vger.kernel.org>; Mon, 11 Jan 2016 20:00:54 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160108195313.GA2507@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jan 09, 2016 at 01:23:13AM +0530, Shivani Bhardwaj wrote:
> Add translation for the network classifier cgroup to nftables.
> 
> Examples:
> 
> $ sudo iptables-translate -A input -m cgroup --cgroup 0x100001 -j DROP
> nft add rule ip filter input meta cgroup 1048577 counter drop
> 
> $ sudo iptables-translate -A input -m cgroup ! --cgroup 0x100001 -j DROP
> nft add rule ip filter input meta cgroup != 1048577 counter drop

Please, rebase upon the xlate4 branch. Tejun sent us the cgroups2
updates and this patch doesn't apply on top of those.

Thanks Shivani.
