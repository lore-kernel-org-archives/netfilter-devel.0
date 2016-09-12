From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v3 1/2 nf-next] netfilter: Add the missed return value
 check of register_netdevice_notifier
Date: Mon, 12 Sep 2016 19:42:13 +0200
Message-ID: <20160912174213.GC30541@salvia>
References: <1473434709-4432-1-git-send-email-fgao@ikuai8.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, gfree.wind@gmail.com
To: fgao@ikuai8.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41840 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755599AbcILRmS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Sep 2016 13:42:18 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1C4B111E587
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Sep 2016 19:42:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0BD88114D62
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Sep 2016 19:42:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CA5D51150D4
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Sep 2016 19:42:14 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1473434709-4432-1-git-send-email-fgao@ikuai8.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Sep 09, 2016 at 11:25:09PM +0800, fgao@ikuai8.com wrote:
> From: Gao Feng <fgao@ikuai8.com>
> 
> There are some codes of netfilter module which did not check the return
> value of register_netdevice_notifier. Add the checks now.

Applied.
