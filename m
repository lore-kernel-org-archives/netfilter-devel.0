From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables] extensions: libipt_realm: fix order of mask and
 id when do nft translation
Date: Fri, 1 Jul 2016 16:19:18 +0200
Message-ID: <20160701141918.GA8762@salvia>
References: <1467035845-28485-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>,
	Shivani Bhardwaj <shivanib134@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59753 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752296AbcGAOTb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Jul 2016 10:19:31 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 48F9C1B1DFE
	for <netfilter-devel@vger.kernel.org>; Fri,  1 Jul 2016 16:19:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 3863AFAB5D
	for <netfilter-devel@vger.kernel.org>; Fri,  1 Jul 2016 16:19:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 1E2E8FAB4E
	for <netfilter-devel@vger.kernel.org>; Fri,  1 Jul 2016 16:19:19 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1467035845-28485-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jun 27, 2016 at 09:57:25PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> Before:
>   # iptables-translate -A INPUT -m realm --realm 1/0xf
>   nft add rule ip filter INPUT rtclassid and 0x1 == 0xf counter
> 
> Apply this patch:
>   # iptables-translate -A INPUT -m realm --realm 1/0xf
>   nft add rule ip filter INPUT rtclassid and 0xf == 0x1 counter

Applied, thanks.
