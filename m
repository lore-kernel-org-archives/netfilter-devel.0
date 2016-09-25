From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 1/2] netfilter: nft_log: complete NFTA_LOG_FLAGS
 attr support
Date: Sun, 25 Sep 2016 15:15:36 +0200
Message-ID: <20160925131536.GA12130@salvia>
References: <1474792557-3349-1-git-send-email-zlpnobody@163.com>
 <1474792557-3349-2-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54348 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966265AbcIYNPr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 25 Sep 2016 09:15:47 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 36B69F9461
        for <netfilter-devel@vger.kernel.org>; Sun, 25 Sep 2016 15:15:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1DC91DA819
        for <netfilter-devel@vger.kernel.org>; Sun, 25 Sep 2016 15:15:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0B457DA7FA
        for <netfilter-devel@vger.kernel.org>; Sun, 25 Sep 2016 15:15:42 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1474792557-3349-2-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Sep 25, 2016 at 04:35:56PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> NFTA_LOG_FLAGS attribute is already supported, but the related
> NF_LOG_XXX flags are not exposed to the userspace. So we cannot
> explicitly enable log flags to log uid, tcp sequence, ip options
> and so on, i.e. such rule "nft add rule filter output log uid"
> is not supported yet.
> 
> So move NF_LOG_XXX macro definitions to the uapi/../nf_log.h. In
> order to keep consistent with other modules, change NF_LOG_MASK to
> refer to all supported log flags. On the other hand, add a new
> NF_LOG_DEFAULT_MASK to refer to the original default log flags.
> 
> Finally, if user specify the unsupported log flags or NFTA_LOG_GROUP
> and NFTA_LOG_FLAGS are set at the same time, report EINVAL to the
> userspace.

Applied, thanks!
