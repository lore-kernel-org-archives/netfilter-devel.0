From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [conntrack-tools PATCH] conntrackd: request resync at startup
Date: Mon, 8 May 2017 19:53:47 +0200
Message-ID: <20170508175347.GB7916@salvia>
References: <149270883020.981.11533592085958035807.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo@debian.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55452 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753837AbdEHRyB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 May 2017 13:54:01 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1401D2519AA
        for <netfilter-devel@vger.kernel.org>; Mon,  8 May 2017 19:53:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 069991C4428
        for <netfilter-devel@vger.kernel.org>; Mon,  8 May 2017 19:53:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E34331C4421
        for <netfilter-devel@vger.kernel.org>; Mon,  8 May 2017 19:53:51 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <149270883020.981.11533592085958035807.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 20, 2017 at 07:21:06PM +0200, Arturo Borrero Gonzalez wrote:
> If a node goes to live, ask the other for resync at startup.
> This has to be done usually by hand, but I guess is an operation common
> enough to add some bits to ease people life here.

Can you rebase this on top of master? We agreed this new option is
useful. We can start upstreaming this into master, then look at the
problem you have more carefully.

Thanks.
