From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: move zone info into struct nf_conn
Date: Thu, 23 Jun 2016 19:38:30 +0200
Message-ID: <20160623173830.GC3515@salvia>
References: <1465675055-7655-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56490 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835AbcFWRii (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Jun 2016 13:38:38 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 374008D051C
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 19:38:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 256D79EBAE
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 19:38:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 161DD9EBA7
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 19:38:35 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1465675055-7655-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jun 11, 2016 at 09:57:35PM +0200, Florian Westphal wrote:
> Curently we store zone information as a conntrack extension.
> This has one drawback: for every lookup we need to fetch the zone data
> from the extension area.
> 
> This change place the zone data directly into the main conntrack object
> structure and then removes the zone conntrack extension.
> 
> The zone data is just 4 bytes, it fits into a padding hole before
> the tuplehash info, so we do not even increase the nf_conn structure size.

Applied, thanks.
