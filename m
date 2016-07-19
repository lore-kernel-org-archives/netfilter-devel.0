From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables 2/2] extensions: libxt_NFLOG: translate to nft
 log snaplen if nflog-size is specified
Date: Tue, 19 Jul 2016 20:17:52 +0200
Message-ID: <20160719181752.GF6116@salvia>
References: <1468851268-35370-1-git-send-email-zlpnobody@163.com>
 <1468851268-35370-2-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57636 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752914AbcGSSR5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Jul 2016 14:17:57 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id C8D0B114818
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Jul 2016 20:17:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B9787FAB52
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Jul 2016 20:17:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B151C9EBBA
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Jul 2016 20:17:53 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1468851268-35370-2-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jul 18, 2016 at 10:14:28PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> The nflog-size was introduced by commit 7070b1f3c88a ("extensions:
> libxt_NFLOG: nflog-range does not truncate packets"). Then make
> the nflog-range become deprecated, because it has no effect from
> the beginning.
> 
> So when we do translation, nft log snaplen is translated only if the
> nflog-size is specified.

Applied, thanks.

So the only chunk missing is userspace nftables, basically set the new
flag when snaplen is set.
