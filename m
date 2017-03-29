From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nf_ct_helper: permit cthelpers with
 different names via nfnetlink
Date: Wed, 29 Mar 2017 12:36:05 +0200
Message-ID: <20170329103605.GA6143@salvia>
References: <1490447003-18592-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49154 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755663AbdC2KgZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Mar 2017 06:36:25 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4D206BA1B1
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Mar 2017 12:36:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3B090DA87A
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Mar 2017 12:36:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B4FE4DA804
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Mar 2017 12:36:04 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1490447003-18592-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Mar 25, 2017 at 09:03:23PM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> cthelpers added via nfnetlink may have the same tuple, i.e. except for
> the l3proto and l4proto, other fields are all zero. So even with the
> different names, we will also fail to add them:
>   # nfct helper add ssdp inet udp
>   # nfct helper add tftp inet udp
>   nfct v1.4.3: netlink error: File exists
> 
> So in order to avoid unpredictable behaviour, we should:
> 1. cthelpers can be selected by nft ct helper obj or xt_CT target, so
> report error if duplicated { name, l3proto, l4proto } tuple exist.
> 2. cthelpers can be selected by nf_ct_tuple_src_mask_cmp when
> nf_ct_auto_assign_helper is enabled, so also report error if duplicated
> { l3proto, l4proto, src-port } tuple exist.
> 
> Also note, if the cthelper is added from userspace, then the src-port will
> always be zero, it's invalid for nf_ct_auto_assign_helper, so there's no
> need to check the second point listed above.

Also applied, thanks.
