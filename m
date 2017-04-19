From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 0/6] netfilter: remove support for variably-sized
 extensions
Date: Wed, 19 Apr 2017 17:56:14 +0200
Message-ID: <20170419155614.GA8531@salvia>
References: <20170415232919.13671-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56220 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S937335AbdDSP4W (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Apr 2017 11:56:22 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 38FD32E786B
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Apr 2017 17:56:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 297E1FC5F2
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Apr 2017 17:56:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2C957FC5F8
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Apr 2017 17:56:14 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170415232919.13671-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Apr 16, 2017 at 01:29:13AM +0200, Florian Westphal wrote:
> 3 years ago we had to bump the offsets to the extensions
> (223b02d923ecd7c84cf9780bb3686f455d279279,
> "netfilter: nf_conntrack: reserve two bytes for nf_ct_ext->len")
> because total size of all extensions had increased to a point where u8
> did overflow.
> 
> We already dieted the extensions back to more reasonable sizes, however,
> I never wanted to switch back because overflow produces hard to diagnose
> crash bugs, and we could not add compile-time assert because extensions
> can be dynamically sized.
> 
> This series makes the last veriable-sized extension (helper)
> fixed in size by adding a 32byte scratch area for helpers to use
> and then adds the compile-time asserts to catch overflow during build
> time.

Series applied.
