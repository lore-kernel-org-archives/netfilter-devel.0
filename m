From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nf_tables_netdev: set nft_pktinfo field
 for non-IP traffic
Date: Wed, 17 Aug 2016 17:28:33 +0200
Message-ID: <20160817152833.GA15146@salvia>
References: <1471446899-12952-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39208 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764AbcHQP2q (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Aug 2016 11:28:46 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id E7E2ED1636
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 17:28:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D1A8CDA7F6
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 17:28:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C0DBFDA800
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 17:28:42 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1471446899-12952-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 17, 2016 at 05:14:59PM +0200, Pablo Neira Ayuso wrote:
> For non-IP traffic seen from the netdev family, set nft_pktinfo fields
> other the value of these fields is garbage.

Will send a v2. It seems we can leave unset field in bridge too for
non-IP traffic.

This should be a problem since nft doesn't generate bytecode using
expression that require this fields.

But given that we assume the nftables VM can be used rawly by anyone,
entirely bypassing libraries and nft, it is good to have this
sanitized.
