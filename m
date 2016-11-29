From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 1/3] evaluate: Add set to cache only when well-formed
Date: Tue, 29 Nov 2016 21:55:27 +0100
Message-ID: <20161129205527.GA19613@salvia>
References: <b02aab6dfd61eff6e5fd9b2e517fd13f493e4887.1480350941.git.anatole@rezel.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Anatole Denis <anatole@rezel.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34954 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754890AbcK2Uzk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Nov 2016 15:55:40 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9011A174D1E
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2016 21:55:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 81F6BDA38C
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2016 21:55:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 821F0DA38F
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2016 21:55:36 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <b02aab6dfd61eff6e5fd9b2e517fd13f493e4887.1480350941.git.anatole@rezel.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 28, 2016 at 05:43:08PM +0100, Anatole Denis wrote:
> When creating a set (in set_evaluate), it is added to the table cache before
> being checked for correctness. When the set is ill-formed, the function returns
> without removing the (non-existent, since the function returned) set. Further
> references to this set will not result in an error (since the set is in the
> lookup table), but the malformed set will probably cause a segfault.
> 
> The symptom (the segfault) was fixed by checking for NULL when evaluating a
> reference to the set (commit 5afa5a164ff1c066af1ec56d875b91562882bd50), this
> should fix the root cause.

Applied, thanks.
