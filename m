From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nf-next PATCH 6/5] netfilter: nf_tables: Reintroduce name
 length boundary
Date: Mon, 24 Jul 2017 17:21:53 +0200
Message-ID: <20170724152153.GA30810@salvia>
References: <20170720152450.27693-1-phil@nwl.cc>
 <20170724151005.9454-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40734 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754015AbdGXPWI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Jul 2017 11:22:08 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 22CF4E122E
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Jul 2017 17:21:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 15270D2AE7
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Jul 2017 17:21:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3BAD0DA46B
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Jul 2017 17:21:51 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170724151005.9454-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jul 24, 2017 at 05:10:05PM +0200, Phil Sutter wrote:
> Since all names in nftables are now dynamically allocated, choosing a
> large hard-coded length limit does not bloat nftables' footprint
> anymore.
> 
> Introduce a common upper limit on all names for sanity reasons - the
> chosen value of 255 characters allows to use a DNS name as per RFC 1035.

Please, rebase your patcheset including this change and send me a v2.

Thanks!
