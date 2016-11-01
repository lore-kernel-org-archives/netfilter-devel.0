From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Rebasing nf-next...
Date: Tue, 1 Nov 2016 20:37:00 +0100
Message-ID: <20161101193700.GA17249@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Arnd Bergmann <arnd@arndb.de>, Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56544 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751135AbcKAThH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Nov 2016 15:37:07 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CFF3E168381
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Nov 2016 20:37:05 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C2037DA911
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Nov 2016 20:37:05 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CC5F4DA8EF
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Nov 2016 20:37:01 +0100 (CET)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I'm rebasing nf-next because I found problems on the ipset batch.

As part of the rebase, I'm going to squash this Arnd's patch:

        http://patchwork.ozlabs.org/patch/688615/

into original Florian's fib nf_tables expression patch.

As well as this one:

        http://patchwork.ozlabs.org/patch/689267/

into the nf_socket lookup infrastructure.

Given I'm rebasing, I don't think it's useful to keep those around
after the rebase to upstream this to David's net-next.

Sorry.
