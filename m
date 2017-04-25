From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf V3] netfilter: nf_ct_helper: permit cthelpers with
 different names via nfnetlink
Date: Tue, 25 Apr 2017 11:06:23 +0200
Message-ID: <20170425090623.GA2876@salvia>
References: <1492255662-57602-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43648 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1176999AbdDYJGg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Apr 2017 05:06:36 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A40F26D584
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Apr 2017 11:06:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 95317FF2DC
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Apr 2017 11:06:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 40D95FF14D
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Apr 2017 11:06:28 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1492255662-57602-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Apr 15, 2017 at 07:27:42PM +0800, Liping Zhang wrote:
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

Applied, thanks.
