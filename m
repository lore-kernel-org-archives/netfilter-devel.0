From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf 1/1] netfilter: CLUSTERIP: Fix one wrong refcnt usage
Date: Thu, 13 Apr 2017 23:21:38 +0200
Message-ID: <20170413212138.GB2387@salvia>
References: <1491443122-107940-1-git-send-email-gfree.wind@foxmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Gao Feng <fgao@ikuai8.com>
To: gfree.wind@foxmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41434 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751404AbdDMVVs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Apr 2017 17:21:48 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C7B5BBA6E6
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Apr 2017 23:21:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B37B1DA8F8
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Apr 2017 23:21:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 04F93DA87F
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Apr 2017 23:21:40 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1491443122-107940-1-git-send-email-gfree.wind@foxmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 06, 2017 at 09:45:22AM +0800, gfree.wind@foxmail.com wrote:
> From: Gao Feng <fgao@ikuai8.com>
> 
> Current codes invoke wrongly nf_ct_netns_get in the destroy routine,
> it should use nf_ct_netns_put, not nf_ct_netns_get.
> It could cause some modules could not be unloaded.

Applied with patch title:

netfilter: CLUSTERIP: Fix wrong conntrack netns refcnt usage

Thanks!
