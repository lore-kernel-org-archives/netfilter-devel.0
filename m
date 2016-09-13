From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v8 nf] netfilter: synproxy: Check oom when adding
 synproxy and seqadj ct extensions
Date: Tue, 13 Sep 2016 10:48:33 +0200
Message-ID: <20160913084833.GA2930@salvia>
References: <1473727758-332-1-git-send-email-fgao@ikuai8.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, gfree.wind@gmail.com
To: fgao@ikuai8.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44704 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755915AbcIMIsr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Sep 2016 04:48:47 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9EBA061506
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Sep 2016 10:48:38 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8F8761150D2
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Sep 2016 10:48:38 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9A61C114D63
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Sep 2016 10:48:34 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1473727758-332-1-git-send-email-fgao@ikuai8.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Sep 13, 2016 at 08:49:18AM +0800, fgao@ikuai8.com wrote:
> From: Gao Feng <fgao@ikuai8.com>
> 
> When memory is exhausted, nfct_seqadj_ext_add may fail to add the
> synproxy and seqadj extensions. The function nf_ct_seqadj_init doesn't
> check if get valid seqadj pointer by the nfct_seqadj.
> 
> Now drop the packet directly when fail to add seqadj extension to
> avoid dereference NULL pointer in nf_ct_seqadj_init from
> init_conntrack().

Applied to nf, thanks.
