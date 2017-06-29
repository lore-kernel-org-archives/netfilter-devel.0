From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [4.9.y,netfilter] please, cherry-pick 2638fd0f92d4
Date: Thu, 29 Jun 2017 17:00:21 +0200
Message-ID: <20170629150021.GA5346@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: stable@vger.kernel.org, Guillaume Nault <g.nault@alphalink.fr>,
        netfilter-devel@vger.kernel.org
To: Greg KH <greg@kroah.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46090 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752852AbdF2PA0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 29 Jun 2017 11:00:26 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2B60C523DE
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Jun 2017 17:00:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1D642DA57E
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Jun 2017 17:00:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E7B95D1CA9
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Jun 2017 17:00:12 +0200 (CEST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Greg,

Please, cherry-pick this commit:

commit 2638fd0f92d4397884fd991d8f4925cb3f081901
Author: Eric Dumazet <edumazet@google.com>
Date:   Mon Apr 3 10:55:11 2017 -0700

    netfilter: xt_TCPMSS: add more sanity tests on tcph->doff

People are experiencing crashes in production without this patch:

http://marc.info/?l=linux-netdev&m=149759912312430&w=2

[ Note for other stable maintainers: This patch applies cleanly here
  from 3.16 onwards. ]

Thanks!
