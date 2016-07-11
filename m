From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: nft_ct: make byte/packet expr more
 friendly
Date: Mon, 11 Jul 2016 12:09:51 +0200
Message-ID: <20160711100951.GB18350@salvia>
References: <1467732180-3938-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43918 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752511AbcGKKJ4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Jul 2016 06:09:56 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 342B217AB67
	for <netfilter-devel@vger.kernel.org>; Mon, 11 Jul 2016 12:09:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 18A4D9EBCC
	for <netfilter-devel@vger.kernel.org>; Mon, 11 Jul 2016 12:09:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 580B59EBC7
	for <netfilter-devel@vger.kernel.org>; Mon, 11 Jul 2016 12:09:52 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1467732180-3938-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jul 05, 2016 at 11:23:00PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> If we want to use ct packets expr, and add a rule like follows:
>   # nft add rule filter input ct packets gt 1 counter
> 
> We will find that no packets will hit it, because
> nf_conntrack_acct is disabled by default. So It will
> not work until we enable it manually via
> "echo 1 > /proc/sys/net/netfilter/nf_conntrack_acct".
> 
> This is not friendly, so like xt_connbytes do, if the user
> want to use ct byte/packet expr, enable nf_conntrack_acct
> automatically.

Applied, thanks.
