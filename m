From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 2/2] netfilter: nft_compat: fix crash when
 related match/target module is removed
Date: Sat, 23 Jul 2016 12:31:16 +0200
Message-ID: <20160723103116.GB3282@salvia>
References: <1469260832-58903-1-git-send-email-zlpnobody@163.com>
 <1469260832-58903-2-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60944 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975AbcGWKb1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 23 Jul 2016 06:31:27 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 3C883E7DA8
	for <netfilter-devel@vger.kernel.org>; Sat, 23 Jul 2016 12:31:26 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 2FD08FF2C8
	for <netfilter-devel@vger.kernel.org>; Sat, 23 Jul 2016 12:31:26 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 7B928FC61C
	for <netfilter-devel@vger.kernel.org>; Sat, 23 Jul 2016 12:31:22 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1469260832-58903-2-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jul 23, 2016 at 04:00:32PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> We "cache" the loaded match/target modules and reuse them, but when the
> modules are removed, we still point to them. Then we may end up with
> invalid memory references when using iptables-compat to add rules later.
> 
> Input the following commands will reproduce the kernel crash:
>   # iptables-compat -A INPUT -j LOG
>   # iptables-compat -D INPUT -j LOG
>   # rmmod xt_LOG
>   # iptables-compat -A INPUT -j LOG
>   BUG: unable to handle kernel paging request at ffffffffa05a9010

Applied, thanks Zhang.
