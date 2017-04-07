From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] net: netfilter: Use list_{next/prev}_entry instead of
 list_entry
Date: Fri, 7 Apr 2017 17:31:22 +0200
Message-ID: <20170407153122.GC1466@salvia>
References: <20170329054540.GA15593@singhal-Inspiron-5558>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        outreachy-kernel@googlegroups.com
To: simran singhal <singhalsimran0@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53188 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756518AbdDGPbc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Apr 2017 11:31:32 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DCC611324C5
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Apr 2017 17:31:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CE6D4DA80B
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Apr 2017 17:31:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B53F0DA862
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Apr 2017 17:31:25 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170329054540.GA15593@singhal-Inspiron-5558>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 29, 2017 at 11:15:40AM +0530, simran singhal wrote:
> This patch replace list_entry with list_prev_entry as it makes the
> code more clear to read.

Also applied, thanks.
