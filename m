From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: netfilter patches for stable 4.13
Date: Fri, 10 Nov 2017 01:55:57 +0100
Message-ID: <20171110005556.GA15570@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59702 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755136AbdKJA4J (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Nov 2017 19:56:09 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 833C2443824
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Nov 2017 01:56:07 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 75337DA807
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Nov 2017 01:56:07 +0100 (CET)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Greg,

I'd appreciate if you can cherry-pick these two patches into stable 4.13:

e1bf1687740c ("netfilter: nat: Revert "netfilter: nat: convert nat bysrc
hash to rhashtable"")

0414c78f1486 ("netfilter: nft_set_hash: disable fast_ops for 2-len keys")

Thanks a lot!
