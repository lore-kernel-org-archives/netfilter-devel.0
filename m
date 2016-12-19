From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [-stable 4.8.y] Revert NAT conversion to rhashtable
Date: Mon, 19 Dec 2016 17:43:33 +0100
Message-ID: <20161219164333.GA2811@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netfilter-devel@vger.kernel.org, fw@strlen.int, davem@davemloft.net
To: stable@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56042 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751652AbcLSQnr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 19 Dec 2016 11:43:47 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 266848ADF
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Dec 2016 17:43:45 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 17507DA80B
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Dec 2016 17:43:45 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B6B1ADA811
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Dec 2016 17:43:42 +0100 (CET)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Greg,

Please revert the following two patches from 4.8.y:

870190a9ec9075205c0fa795a09fa931694a3ff1 ("netfilter: nat: convert nat
bysrc hash to rhashtable")

7c9664351980aaa6a4b8837a314360b3a4ad382a ("netfilter: move nat
hlist_head to nf_conn")

There are incremental fixes in 4.9 to resolve the problems in these
two, but they also require the new rhlist interface not available
there.

Thanks!
