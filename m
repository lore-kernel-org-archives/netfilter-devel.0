From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables 1/3] extensions: libipt_DNAT/SNAT: fix "OOM"
 when do translation to nft
Date: Tue, 30 Aug 2016 11:56:31 +0200
Message-ID: <20160830095631.GA20699@salvia>
References: <1472374248-21912-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34816 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757856AbcH3J4h (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Aug 2016 05:56:37 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C718A12A689
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Aug 2016 11:56:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B77E9100A77
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Aug 2016 11:56:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1203D9EBB8
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Aug 2016 11:56:33 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1472374248-21912-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Aug 28, 2016 at 04:50:46PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> When I want to translate SNAT target to nft rule, an error message
> was printed out:
>   # iptables-translate -A POSTROUTING -j SNAT --to-source 1.1.1.1
>   iptables-translate v1.6.0: OOM
> 
> Because ipt_natinfo{} started with a xt_entry_target{}, so when we
> get the ipt_natinfo pointer, we should use the target itself,
> not its data pointer. Yes, it is a little tricky and it's different
> with other targets.

Applied, thanks!
