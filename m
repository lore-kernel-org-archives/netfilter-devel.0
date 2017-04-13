From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: xt_CT: fix cthelper module's refcnt leak
Date: Fri, 14 Apr 2017 00:30:56 +0200
Message-ID: <20170413223056.GA5106@salvia>
References: <1491622728-55625-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49804 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750735AbdDMWbU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Apr 2017 18:31:20 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9C845BA717
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2017 00:31:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DA3C7DA862
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2017 00:31:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C6ED8DA793
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2017 00:31:18 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1491622728-55625-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Apr 08, 2017 at 11:38:48AM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> We should call module_put when the time policy is not found. Otherwise,
> the related cthelper module cannot be removed anymore.
> 
> It is easy to reproduce by typing the following command:
>   # iptables -t raw -A OUTPUT -p tcp -j CT --helper ftp --timeout xxx

Can we fix all leaks in the error path in one single patch for xt_CT?

Feng sent me a patch to fix another issue there, so if either you or
him send me one single patch to fix all xt_CT refcount leaks in one
go, I'd appreciate.

Thanks.
