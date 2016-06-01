From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] extensions: libxt_mark: fix a wrong translation to nft
 when mask is specified
Date: Wed, 1 Jun 2016 17:08:32 +0200
Message-ID: <20160601150832.GA1412@salvia>
References: <1464782837-40104-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>,
	Shivani Bhardwaj <shivanib134@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59226 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751545AbcFAPIl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 1 Jun 2016 11:08:41 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 9C94A1B9BA6
	for <netfilter-devel@vger.kernel.org>; Wed,  1 Jun 2016 17:08:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 8DCD19EBBE
	for <netfilter-devel@vger.kernel.org>; Wed,  1 Jun 2016 17:08:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id CFE479EBC1
	for <netfilter-devel@vger.kernel.org>; Wed,  1 Jun 2016 17:08:33 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1464782837-40104-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 01, 2016 at 08:07:17PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> The mask and mark's order is reversed, so when we specify the mask, we will
> get the wrong translation result:
>   # iptables-translate -A INPUT -m mark --mark 0x1/0xff
>   nft add rule ip filter INPUT mark and 0x1 == 0xff counter
> 
> Apply this patch, translation will become:
>   # iptables-translate -A INPUT -m mark --mark 0x1/0xff
>   nft add rule ip filter INPUT mark and 0xff == 0x1 counter

Applied, thanks.
