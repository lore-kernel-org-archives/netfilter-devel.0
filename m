From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: make it safer during the
 inet6_dev->addr_list traversal
Date: Sat, 8 Apr 2017 23:33:27 +0200
Message-ID: <20170408213327.GC5301@salvia>
References: <1491125273-8002-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34570 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752002AbdDHVde (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 8 Apr 2017 17:33:34 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A206224944
        for <netfilter-devel@vger.kernel.org>; Sat,  8 Apr 2017 23:33:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3C03FDA865
        for <netfilter-devel@vger.kernel.org>; Sat,  8 Apr 2017 23:33:34 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3ABDEDA729
        for <netfilter-devel@vger.kernel.org>; Sat,  8 Apr 2017 23:33:32 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1491125273-8002-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Apr 02, 2017 at 05:27:53PM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> inet6_dev->addr_list is protected by inet6_dev->lock, so only using
> rcu_read_lock is not enough, we should acquire read_lock_bh(&idev->lock)
> before the inet6_dev->addr_list traversal.

Applied, thanks.
