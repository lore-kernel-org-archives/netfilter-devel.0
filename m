From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 1/2] rule: Introduce helper function cache_flush
Date: Thu, 1 Dec 2016 12:41:36 +0100
Message-ID: <20161201114136.GA3016@salvia>
References: <311a646975862ca11499066a4392683ad2265c43.1480587885.git.anatole@rezel.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Anatole Denis <anatole@rezel.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55662 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751301AbcLALmg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Dec 2016 06:42:36 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C27DB1DF5BB
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Dec 2016 12:41:39 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EE5A24E0E0
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Dec 2016 12:41:39 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9D1014E0E0
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Dec 2016 12:41:37 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <311a646975862ca11499066a4392683ad2265c43.1480587885.git.anatole@rezel.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Dec 01, 2016 at 11:50:16AM +0100, Anatole Denis wrote:
> cache_release empties the cache, and marks it as uninitialized. Add cache_flush,
> which does the same, except it keeps the cache initialized, eg. after a "nft
> flush ruleset" when empty is the correct state of the cache.

Applied, thanks Anatole.
