From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Rebasing nf-next git tree
Date: Thu, 16 Nov 2017 15:18:59 +0100
Message-ID: <20171116141859.GA15511@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38362 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933562AbdKPOTE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Nov 2017 09:19:04 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0DB002EFEAA
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Nov 2017 15:19:03 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EF90ADA86B
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Nov 2017 15:19:02 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4D16EDA86B
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Nov 2017 15:19:00 +0100 (CET)
Received: from us.es (129.166.216.87.static.jazztel.es [87.216.166.129])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 0B8C6403DF98
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Nov 2017 15:18:59 +0100 (CET)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This fix needed to get into net.git asap:

http://patchwork.ozlabs.org/patch/835281/

And part of those patches are fixes, that I'll route through nf.git
asap.

Sorry for the inconvenience.
