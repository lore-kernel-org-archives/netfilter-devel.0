From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 2/3] meta: fix endianness in priority
Date: Mon, 30 May 2016 11:58:16 +0200
Message-ID: <20160530095816.GA20626@salvia>
References: <1464516489-21616-1-git-send-email-zlpnobody@163.com>
 <1464516489-21616-2-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44021 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932675AbcE3J6Z (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 May 2016 05:58:25 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id A43921FE281
	for <netfilter-devel@vger.kernel.org>; Mon, 30 May 2016 11:58:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 952A015D63E
	for <netfilter-devel@vger.kernel.org>; Mon, 30 May 2016 11:58:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 4A00F15D641
	for <netfilter-devel@vger.kernel.org>; Mon, 30 May 2016 11:58:18 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1464516489-21616-2-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, May 29, 2016 at 06:08:08PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> For example, after we add rule to set priority 1:2, it will be displayed in network
> byte order as 0200:0100, this is wrong:
> 
>   # nft add rule filter test meta priority set 1:2
>   # nft list chain filter test
>   table ip filter {
>       chain test {
>           meta priority set 0200:0100
>       }
>   }

Applied, thanks.
