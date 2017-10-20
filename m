From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 1/7] nft_ctx_free: Fix for wrong argument passed to
 cache_release
Date: Fri, 20 Oct 2017 14:01:43 +0200
Message-ID: <20171020120143.GA4068@salvia>
References: <20171019081847.16171-1-phil@nwl.cc>
 <20171019081847.16171-2-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Leblond <eric@regit.org>, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35722 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753114AbdJTMBs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Oct 2017 08:01:48 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7154469271
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Oct 2017 14:01:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5F191DA7E9
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Oct 2017 14:01:46 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20171019081847.16171-2-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 19, 2017 at 10:18:41AM +0200, Phil Sutter wrote:
> nft_ctx_free() should not refer to the global 'nft' variable, this will
> break as soon as the function is moved away from main.c. In order to use
> the cache reference from passed argument, the latter must not be const.

Applied, thanks.
