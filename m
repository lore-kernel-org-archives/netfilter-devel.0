From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf 1/1] netfilter: cttimeout: Fix one possible
 use-after-free issue
Date: Thu, 13 Apr 2017 23:47:56 +0200
Message-ID: <20170413214756.GA3960@salvia>
References: <1491476949-92872-1-git-send-email-gfree.wind@foxmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Gao Feng <fgao@ikuai8.com>
To: gfree.wind@foxmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44370 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752273AbdDMVsK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Apr 2017 17:48:10 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3FF0EBA6E7
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Apr 2017 23:48:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6F846DA865
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Apr 2017 23:48:10 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 01FC5DA7F7
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Apr 2017 23:48:07 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1491476949-92872-1-git-send-email-gfree.wind@foxmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 06, 2017 at 07:09:09PM +0800, gfree.wind@foxmail.com wrote:
> From: Gao Feng <fgao@ikuai8.com>
> 
> The function ctnl_untimeout is used to untimeout every conntrack
> which is using the timeout. But it is necessary to add one barrier
> synchronize_rcu because of racing. Maybe one conntrack has already
> owned this timeout, but it is not inserted into unconfirmed list or
> the hash list, when ctnl_untimeout untimeout the conntracks

This object is released via kfree_rcu().

You have to describe better the race scenario.
