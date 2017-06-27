From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: ebt_nflog: fix unexpected truncated packet
Date: Tue, 27 Jun 2017 18:12:24 +0200
Message-ID: <20170627160104.GA4928@salvia>
References: <1497754269-44413-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <zlpnobody@gmail.com>,
        Vishwanath Pai <vpai@akamai.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54642 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751693AbdF0QMd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 27 Jun 2017 12:12:33 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0B445EAA67
        for <netfilter-devel@vger.kernel.org>; Tue, 27 Jun 2017 18:12:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E2F3ADA241
        for <netfilter-devel@vger.kernel.org>; Tue, 27 Jun 2017 18:12:21 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 93F6ACFDE6
        for <netfilter-devel@vger.kernel.org>; Tue, 27 Jun 2017 18:12:19 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1497754269-44413-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Jun 18, 2017 at 10:51:09AM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> "struct nf_loginfo li;" is a local variable, so we should set the flags
> to 0 explicitly, else, packets maybe truncated unexpectedly when copied
> to the userspace.
> 
> Fixes: 7643507fe8b5 ("netfilter: xt_NFLOG: nflog-range does not truncate packets")
> Cc: Vishwanath Pai <vpai@akamai.com>
> Signed-off-by: Liping Zhang <zlpnobody@gmail.com>

Applied to nf, thanks.
