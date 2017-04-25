From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nft_dynset: continue to next expr if
 _OP_ADD succeeded
Date: Tue, 25 Apr 2017 11:14:36 +0200
Message-ID: <20170425091436.GA3527@salvia>
References: <1492943370-38461-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, rwhite@pobox.com,
        Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48886 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932986AbdDYJOq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Apr 2017 05:14:46 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 932A16B183
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Apr 2017 11:14:40 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 84255FF2CE
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Apr 2017 11:14:40 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 088EDFF2D7
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Apr 2017 11:14:37 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1492943370-38461-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Apr 23, 2017 at 06:29:30PM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> Currently, after adding the following nft rules:
>   # nft add set x target1 { type ipv4_addr \; flags timeout \;}
>   # nft add rule x y set add ip daddr timeout 1d @target1 counter
> 
> the counters will always be zero despite of the elements are added
> to the dynamic set "target1" or not, as we will break the nft expr
> traversal unconditionally:
>   # nft list ruleset
>   ...
>   set target1 {
>       ...
>       elements = { 8.8.8.8 expires 23h59m53s}
>   }
>   chain output {
>       ...
>       set add ip daddr timeout 1d @target1 counter packets 0 bytes 0
>                                                            ^       ^
>       ...
>   }
> 
> Since we add the elements to the set successfully, we should continue
> to the next expression.
> 
> Additionally, if elements are added to "flow table" successfully, we
> will _always_ continue to the next expr, even if the operation is
> _OP_ADD. So it's better to keep them to be consistent.

Applied, thanks.
