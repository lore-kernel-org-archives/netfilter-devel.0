From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] extensions: libxt_ipcomp: Add translation to nft
Date: Wed, 1 Jun 2016 17:11:20 +0200
Message-ID: <20160601151120.GA1537@salvia>
References: <20160531220657.GA31779@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Laura Garcia Liebana <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59929 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751545AbcFAPLs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 1 Jun 2016 11:11:48 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id EA6041BFA8F
	for <netfilter-devel@vger.kernel.org>; Wed,  1 Jun 2016 17:11:23 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id DCEE19EBB2
	for <netfilter-devel@vger.kernel.org>; Wed,  1 Jun 2016 17:11:23 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D06709EBB1
	for <netfilter-devel@vger.kernel.org>; Wed,  1 Jun 2016 17:11:21 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160531220657.GA31779@sonyv>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 01, 2016 at 12:06:59AM +0200, Laura Garcia Liebana wrote:
> Add translation of ipcomp to nftables.
> 
> First value of the parameter 'ipcompspi' will be translated to 'cpi'
> parameter in nftables. Parameter 'compres' is not supported in nftables.
> 
> Examples:
> 
> $ sudo iptables-translate -t filter -A INPUT -m ipcomp --ipcompspi 0x12 -j ACCEPT
> nft add rule ip filter INPUT comp cpi 18 counter accept
> 
> $ sudo iptables-translate -t filter -A INPUT -m ipcomp ! --ipcompspi 0x12 -j ACCEPT
> nft add rule ip filter INPUT comp cpi != 18 counter accept

Applied, thanks Laura.
