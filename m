From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables] extensions: libxt_TRACE: Add translation to nft
Date: Wed, 8 Jun 2016 16:56:05 +0200
Message-ID: <20160608145605.GA5586@salvia>
References: <1465390023-28026-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41428 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754088AbcFHO4O (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Jun 2016 10:56:14 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id D5D136FB87B
	for <netfilter-devel@vger.kernel.org>; Wed,  8 Jun 2016 16:56:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C7E7A9EBA3
	for <netfilter-devel@vger.kernel.org>; Wed,  8 Jun 2016 16:56:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D83839EBA9
	for <netfilter-devel@vger.kernel.org>; Wed,  8 Jun 2016 16:56:06 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1465390023-28026-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 08, 2016 at 08:47:03PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> For example:
> 
>   # iptables-translate -t raw -A PREROUTING -j TRACE
>   nft add rule ip raw PREROUTING counter nftrace set 1

Applied, thanks.
