From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf 4/5] netfilter: nfnl_cthelper: fix memory leak when do
 update
Date: Tue, 21 Mar 2017 11:32:08 +0100
Message-ID: <20170321103208.GC1940@salvia>
References: <1489934162-7415-1-git-send-email-zlpnobody@163.com>
 <1489934162-7415-5-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34782 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756773AbdCUKcf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Mar 2017 06:32:35 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 66175EBAC6
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Mar 2017 11:32:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 516B3DA395
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Mar 2017 11:32:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C5565DA874
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Mar 2017 11:32:23 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1489934162-7415-5-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Mar 19, 2017 at 10:36:01PM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> When invoke nfnl_cthelper_update, we will malloc a new expect_policy,
> then only point the helper->expect_policy to the new one but ignore
> the old one, so it will be leaked forever.
> 
> Another issue is that the user can modify the expect_class_max to a
> new value, for example, decrease the expect_class_max from 3 to 0.

If the code is allowing this, we should fix it since this is not
valid. We cannot change the number of classes once the helper has been
created.

Users may update the maximum number of expectations and its timeout
per policy, but not the number of classes once this has been created.
