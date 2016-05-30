From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 3/3] meta: fix a format error display when we set
 priority to root or none
Date: Mon, 30 May 2016 11:58:28 +0200
Message-ID: <20160530095828.GB20626@salvia>
References: <1464516489-21616-1-git-send-email-zlpnobody@163.com>
 <1464516489-21616-3-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44104 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932500AbcE3J6k (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 May 2016 05:58:40 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 2E43F1FE284
	for <netfilter-devel@vger.kernel.org>; Mon, 30 May 2016 11:58:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 1D7B215D639
	for <netfilter-devel@vger.kernel.org>; Mon, 30 May 2016 11:58:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 4CF2715D63A
	for <netfilter-devel@vger.kernel.org>; Mon, 30 May 2016 11:58:30 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1464516489-21616-3-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, May 29, 2016 at 06:08:09PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> Also delete the redundant '\n'.
> This fixes:
> 
>   # nft add rule filter test meta priority set root
>   # nft list chain filter test
>   table ip filter {
>       chain test {
>           meta priority set root
>   none
>   ffff:ffff
>       }
>   }

Also applied, thanks.
