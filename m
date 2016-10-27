From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf 0/3] netfilter: nf_tables: fix some bugs related to
 dynset
Date: Thu, 27 Oct 2016 18:23:08 +0200
Message-ID: <20161027162308.GA9934@salvia>
References: <1477133486-60686-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33104 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755710AbcJ0QX0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Oct 2016 12:23:26 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 271CC9B7EC
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Oct 2016 18:23:23 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 16DE6DA854
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Oct 2016 18:23:23 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 73C96DA84A
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Oct 2016 18:23:17 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1477133486-60686-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Oct 22, 2016 at 06:51:23PM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> Suppose that the user input the following nft rules, then a dynset expr is
> created:
>   # nft add rule filter output flow table test { ip daddr counter }
> 
> But actually, there are some bugs exist in kernel:
> 1. If CONFIG_NFT_SET_HASH is not enabled, kernel panic will happen
> 2. In extreme case, i.e. memory is exhausted, then expr clone will
>    fail, this will cause module refcnt leak, memory leak and incorrect
>    set's nelems
> 3. Packets may race when create the new element, and these *racing*
>    packets will not be handled properly.
> 
> This patch set is aimed to fix these problems.

Series applied, thanks!
