From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Rebasing nf-next
Date: Tue, 6 Dec 2016 21:57:37 +0100
Message-ID: <20161206205737.GA22832@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38548 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751266AbcLFU6z (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Dec 2016 15:58:55 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1ED758CD66
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Dec 2016 21:57:40 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 126FFDA841
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Dec 2016 21:57:40 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 226F8DA843
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Dec 2016 21:57:38 +0100 (CET)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

In order to reduce the (already large) batch that I'm going to pass to
David, I'm rebasing nf-next to squash patches that fix bugs,
compilation warnings and other fallout from ongoing development. List
of patches that I have squashed into master patch are:

* netfilter: nf_tables: silence gcc warning with stateful object maps
* netfilter: nf_tables: restore check for NFTA_SET_ELEM_LIST_ELEMENTS
* netfilter: nft_counter: move counter reset into separated function
* netfilter: nft_quota: don't read quota twice on reset
* netfilter: add list element test to br_netfilter_hooks
* netfilter: fix build failure with CONNTRACK=n NF_DEFRAG=y
* netfilter: nft_payload: restrict l4 checksum updates to l3 header mangling

Sorry.
