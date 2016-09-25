From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 2/2] netfilter: nft_ct: report error if mark and
 dir specified simultaneously
Date: Sun, 25 Sep 2016 13:32:41 +0200
Message-ID: <20160925113241.GC8331@salvia>
References: <1474554532-50664-1-git-send-email-zlpnobody@163.com>
 <1474554532-50664-2-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38386 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965662AbcIYLcu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 25 Sep 2016 07:32:50 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0BAFFED07F
        for <netfilter-devel@vger.kernel.org>; Sun, 25 Sep 2016 13:32:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EFC71DA816
        for <netfilter-devel@vger.kernel.org>; Sun, 25 Sep 2016 13:32:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DFDB2DA815
        for <netfilter-devel@vger.kernel.org>; Sun, 25 Sep 2016 13:32:46 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1474554532-50664-2-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 22, 2016 at 10:28:52PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> NFT_CT_MARK is unrelated to direction, so if NFTA_CT_DIRECTION attr is
> specified, report EINVAL to the userspace. This validation check was
> already done at nft_ct_get_init, but we missed it in nft_ct_set_init.

Also applied, thanks.
