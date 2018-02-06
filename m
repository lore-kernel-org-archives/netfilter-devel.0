From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: CPU load on queued_spin_lock_slowpath
Date: Tue, 6 Feb 2018 13:10:21 +0100
Message-ID: <20180206121021.hn4nx64yqof7wpwt@salvia>
References: <CA+whn7Qkg9ZJ-owuukfoA4+RHP26mBQG0oGoBCCtwL9oAs6MxQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tugrul Erdogan <h.tugrul.erdogan@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38026 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752246AbeBFMKZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Feb 2018 07:10:25 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B92691D94A2
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Feb 2018 13:10:23 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9502ABAC2D
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Feb 2018 13:10:23 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CA+whn7Qkg9ZJ-owuukfoA4+RHP26mBQG0oGoBCCtwL9oAs6MxQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Feb 06, 2018 at 10:56:20AM +0300, Tugrul Erdogan wrote:
> Hi All,
> 
> My server had a locking problem with the logs located below. I can not
> reproduce this erroneous situation again but I think that there is an
> active vulnerability at my server because of this error.
> 
> My server's kernel version is v4.6.4.

Probably this helps you?

commit 49f817d793d1bcc11d721881aac037b996feef5c
Author: Lin Zhang <xiaolou4617@gmail.com>
Date:   Fri Oct 6 00:44:03 2017 +0800

    netfilter: SYNPROXY: skip non-tcp packet in {ipv4, ipv6}_synproxy_hook

4.6.4 is rather old, BTW.
