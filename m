From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf 1/1] netfilter: helper: Fix possible panic caused by
 invoking expectfn unloaded
Date: Wed, 15 Mar 2017 14:07:26 +0100
Message-ID: <20170315130726.GA6318@salvia>
References: <1489472766-89568-1-git-send-email-fgao@ikuai8.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, gfree.wind@gmail.com
To: fgao@ikuai8.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33670 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751111AbdCONHo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Mar 2017 09:07:44 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1C27BE7B9E
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Mar 2017 14:07:41 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0D33CDA3F4
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Mar 2017 14:07:41 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 76369DA87B
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Mar 2017 14:07:35 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1489472766-89568-1-git-send-email-fgao@ikuai8.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 14, 2017 at 02:26:06PM +0800, fgao@ikuai8.com wrote:
> From: Gao Feng <fgao@ikuai8.com>
> 
> The helper module permits the helper modules register expectfn, and
> it could be hold by external caller. But when the module is unloaded,
> there may be some pending expect nodes which still hold the function
> reference. It may cause unexpected behavior, even panic.
> 
> Now it would delete the expect nodes which uses the expectfn when
> unregister expectfn. And it must use the rcu_read_lock to protect
> the expectfn until insert it or doesn't access it ever.

Expectations should be removed by when the helper module is gone, so
what is the problem here?
