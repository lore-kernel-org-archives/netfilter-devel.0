From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 1/2] netfilter: nft_ct: unnecessary to require
 dir when use ct l3proto/protocol
Date: Sun, 25 Sep 2016 13:32:30 +0200
Message-ID: <20160925113230.GB8331@salvia>
References: <1474554532-50664-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38328 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965662AbcIYLch (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 25 Sep 2016 07:32:37 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AC88AED07A
        for <netfilter-devel@vger.kernel.org>; Sun, 25 Sep 2016 13:32:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9D0C9DA81C
        for <netfilter-devel@vger.kernel.org>; Sun, 25 Sep 2016 13:32:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E0704DA846
        for <netfilter-devel@vger.kernel.org>; Sun, 25 Sep 2016 13:32:31 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1474554532-50664-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 22, 2016 at 10:28:51PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> Currently, if the user want to match ct l3proto, we must specify the
> direction, for example:
>   # nft add rule filter input ct original l3proto ipv4
>                                  ^^^^^^^^
> Otherwise, error message will be reported:
>   # nft add rule filter input ct l3proto ipv4
>   nft add rule filter input ct l3proto ipv4
>   <cmdline>:1:1-38: Error: Could not process rule: Invalid argument
>   add rule filter input ct l3proto ipv4
>   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> Actually, there's no need to require NFTA_CT_DIRECTION attr, because
> ct l3proto and protocol are unrelated to direction.
> 
> And for compatibility, even if the user specify the NFTA_CT_DIRECTION
> attr, do not report error, just skip it.

Applied, thanks.
