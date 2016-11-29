From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 2/3] tests: Add regression test for malformed sets
Date: Tue, 29 Nov 2016 22:02:23 +0100
Message-ID: <20161129210223.GB19613@salvia>
References: <b02aab6dfd61eff6e5fd9b2e517fd13f493e4887.1480350941.git.anatole@rezel.net>
 <3808d7e70955006aa8bebaab262110fdec391314.1480350941.git.anatole@rezel.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Anatole Denis <anatole@rezel.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36272 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756321AbcK2VC2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Nov 2016 16:02:28 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BAA16174D13
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2016 22:02:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id ABF75DA848
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2016 22:02:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 16EC7DA849
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2016 22:02:24 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <3808d7e70955006aa8bebaab262110fdec391314.1480350941.git.anatole@rezel.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 28, 2016 at 05:43:09PM +0100, Anatole Denis wrote:
> see: 5afa5a164ff1c066af1ec56d875b91562882bd50
> When a malformed set is added, it was added before erroring out, causing a
> segfault further down when used. This tests for this case, ensuring that
> nftables doesn't segfault but errors correctly
> 
> Signed-off-by: Anatole Denis <anatole@rezel.net>
> ---
>  This test is maybe not that useful, but I used it to test that I didn't
>  reintroduce the bug. Maybe a different naming rule for regression tests could
>  be used ?

Another test to increase coverage doesn't harm, so I'm applying this.

Thanks!
