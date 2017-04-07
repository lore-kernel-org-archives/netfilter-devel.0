From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] net: netfilter: Use seq_puts()/seq_putc() where possible
Date: Fri, 7 Apr 2017 17:30:22 +0200
Message-ID: <20170407153022.GB1466@salvia>
References: <20170328215517.GA18237@singhal-Inspiron-5558>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: wensong@linux-vs.org, Simon Horman <horms@verge.net.au>,
        Julian Anastasov <ja@ssi.bg>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, linux-kernel@vger.kernel.org,
        outreachy-kernel@googlegroups.com
To: simran singhal <singhalsimran0@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52620 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755811AbdDGPa2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Apr 2017 11:30:28 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 44E391324C5
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Apr 2017 17:30:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 30E29DA913
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Apr 2017 17:30:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E72D6DA874
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Apr 2017 17:30:21 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170328215517.GA18237@singhal-Inspiron-5558>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 29, 2017 at 03:25:17AM +0530, simran singhal wrote:
> For string without format specifiers, use seq_puts(). For
> seq_printf("\n"), use seq_putc('\n').

Applied, thanks.
