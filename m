From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [4.9.y,netfilter] please, cherry-pick da2f27e9e615
Date: Mon, 29 May 2017 13:22:23 +0200
Message-ID: <20170529112223.GA5252@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Juergen Schmidt <abcdmail@freenet.de>,
        netfilter-devel@vger.kernel.org
To: stable@lists.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42764 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750871AbdE2LWd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 29 May 2017 07:22:33 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 754211EC2C1
        for <netfilter-devel@vger.kernel.org>; Mon, 29 May 2017 13:22:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 64E05114D8A
        for <netfilter-devel@vger.kernel.org>; Mon, 29 May 2017 13:22:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AD266114D82
        for <netfilter-devel@vger.kernel.org>; Mon, 29 May 2017 13:22:20 +0200 (CEST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Please, 4.9 stable maintainer, cherry-pick this commit:

commit da2f27e9e615d1c799c9582b15262458da61fddc
Author: Christophe Leroy <christophe.leroy@c-s.fr>
Date:   Wed Mar 1 15:33:26 2017 +0100

    netfilter: nf_conntrack_sip: fix wrong memory initialisation

We have a user complaining about this bug that manifests in 4.9:

http://marc.info/?l=netfilter&m=149577235017072&w=2

Thanks!
