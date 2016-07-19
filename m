From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 3/3] netfilter: nft_log: fix snaplen does not
 truncate packets
Date: Tue, 19 Jul 2016 20:16:00 +0200
Message-ID: <20160719181600.GD6116@salvia>
References: <1468845857-30291-1-git-send-email-zlpnobody@163.com>
 <1468845857-30291-4-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57452 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753553AbcGSSQG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Jul 2016 14:16:06 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 26C21114804
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Jul 2016 20:16:04 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 0F13F6DA2D
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Jul 2016 20:16:04 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 588269EBA7
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Jul 2016 20:16:01 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1468845857-30291-4-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jul 18, 2016 at 08:44:17PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> There's a similar problem in xt_NFLOG, and was fixed by commit 7643507fe8b5
> ("netfilter: xt_NFLOG: nflog-range does not truncate packets"). Only set
> copy_len here does not work, so we should enable NF_LOG_F_COPY_LEN also.

Applied, thanks.

Will you send me a patch for nftables userspace to enable this flag?

It would be good to update the translation to make sure --nflog-size
map to snaplen and ignore --nflog-range.
