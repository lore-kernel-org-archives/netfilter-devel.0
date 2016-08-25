From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nft_meta: improve the validity check of
 pkttype set expr
Date: Thu, 25 Aug 2016 13:10:21 +0200
Message-ID: <20160825111021.GE5242@salvia>
References: <1471877876-52486-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54940 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753343AbcHYLLR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Aug 2016 07:11:17 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 19A72F9477
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Aug 2016 13:10:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4F43A100A7B
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Aug 2016 13:10:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AC254FC61E
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Aug 2016 13:10:21 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1471877876-52486-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 22, 2016 at 10:57:56PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> "meta pkttype set" is only supported on prerouting chain with bridge
> family and ingress chain with netdev family.
> 
> But the validate check is incomplete, and the user can add the nft
> rules on input chain with bridge family, for example:
>   # nft add table bridge filter
>   # nft add chain bridge filter input {type filter hook input \
>     priority 0 \;}
>   # nft add chain bridge filter test
>   # nft add rule bridge filter test meta pkttype set unicast
>   # nft add rule bridge filter input jump test
> 
> This patch fixes the problem.

Good catch, applied, thanks!

Actually, it would be good to allow mangling this pkttype from
prerouting ip and ip6 too, so we can emulate the 'cluster match' very
easily.

Now we have a hash expression in place, which is what was missing to
support this.

So, once your fix shows up in the nf-next tree, I'd appreciate if you
can follow up with a patch to allow the use of this from there.
Thanks!
