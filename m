From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] comment: Add translation to nft
Date: Mon, 1 Feb 2016 19:44:36 +0100
Message-ID: <20160201184436.GA18854@salvia>
References: <20160201060152.GA10787@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56639 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752061AbcBASon (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Feb 2016 13:44:43 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 572F261E9C
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Feb 2016 19:44:42 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 489C7DA85D
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Feb 2016 19:44:42 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 2EE70DA862
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Feb 2016 19:44:37 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160201060152.GA10787@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Feb 01, 2016 at 11:31:52AM +0530, Shivani Bhardwaj wrote:
> Add translation for match comment to nftables.
> 
> Example:
> 
> $ sudo iptables-translate -A INPUT -s 192.168.0.0 -m comment --comment "A privatized IP block"
> nft add rule ip filter INPUT ip saddr 192.168.0.0 counter comment \"A privatized IP block\"

Could you rework this patch on top of these:

http://patchwork.ozlabs.org/patch/576671/
http://patchwork.ozlabs.org/patch/576673/
http://patchwork.ozlabs.org/patch/576672/

I have only compile-tested them.
