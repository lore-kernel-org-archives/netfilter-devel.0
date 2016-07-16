From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH V2 iptables] extensions: libxt_connlabel: Add translation
 to nft
Date: Sat, 16 Jul 2016 16:48:16 +0200
Message-ID: <20160716144816.GA2169@salvia>
References: <1468665744-21839-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38794 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751809AbcGPOsV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 Jul 2016 10:48:21 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 7ED78114802
	for <netfilter-devel@vger.kernel.org>; Sat, 16 Jul 2016 16:48:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 725C2FAB53
	for <netfilter-devel@vger.kernel.org>; Sat, 16 Jul 2016 16:48:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 1E299EBADB
	for <netfilter-devel@vger.kernel.org>; Sat, 16 Jul 2016 16:48:17 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1468665744-21839-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jul 16, 2016 at 06:42:24PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> Add translation for connlabel to nftables.
> For examples:
> 
>   # iptables-translate -A INPUT -m connlabel --label bit40
>   nft add rule ip filter INPUT ct label bit40 counter
> 
>   # iptables-translate -A INPUT -m connlabel ! --label bit40 --set
>   nft add rule ip filter INPUT ct label set bit40 ct label and bit40 != bit40 counter

Applied, thanks.
