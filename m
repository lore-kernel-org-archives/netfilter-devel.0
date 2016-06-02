From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] extensions: libip6t_hbh: Add translation to nft
Date: Thu, 2 Jun 2016 13:08:47 +0200
Message-ID: <20160602110847.GA3428@salvia>
References: <20160601220804.GA3515@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Laura Garcia Liebana <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60423 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751968AbcFBLI6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Jun 2016 07:08:58 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 705F77D834B
	for <netfilter-devel@vger.kernel.org>; Thu,  2 Jun 2016 13:08:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 6022C15D628
	for <netfilter-devel@vger.kernel.org>; Thu,  2 Jun 2016 13:08:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 588249EBC4
	for <netfilter-devel@vger.kernel.org>; Thu,  2 Jun 2016 13:08:55 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160601220804.GA3515@sonyv>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jun 02, 2016 at 12:08:08AM +0200, Laura Garcia Liebana wrote:
> Add translation for Hop-By-Hop header to nftables. Hbh options are not
> supported yet in nft.

It would be good to document this in the wiki, as Shivani did already.
It would be also good if you can document what is missing to be
capable of matching these hbh options there.

> $ sudo ip6tables-translate -t filter -A INPUT -m hbh --hbh-len 22
> nft add rule ip6 filter INPUT hbh hdrlength 22 counter
> 
> $ sudo ip6tables-translate -t filter -A INPUT -m hbh ! --hbh-len 22
> nft add rule ip6 filter INPUT hbh hdrlength != 22 counter

Applied, thanks Laura.
