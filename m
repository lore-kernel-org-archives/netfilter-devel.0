From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 1/2] src: sort set elements in netlink_get_setelems()
Date: Tue, 10 Jan 2017 22:11:00 +0100
Message-ID: <20170110211100.GA16808@salvia>
References: <20170106214331.GA3265@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Elise Lennion <elise.lennion@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58808 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752240AbdAJVLI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 10 Jan 2017 16:11:08 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A1BDD16B286
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Jan 2017 22:11:04 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 63215DA790
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Jan 2017 22:11:04 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CFA8CA6B3
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Jan 2017 22:11:01 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170106214331.GA3265@lennorien.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jan 06, 2017 at 07:43:32PM -0200, Elise Lennion wrote:
> So users can better track their ruleset via git.
>
> Without sorting, the elements can be listed in a different order
> every time the set is created, generating unnecessary git changes.
>
> Mergesort is used. Doesn't sort sets with 'flags interval' set on.

Applied, thanks Elise! I'm appending this to your description BTW:

Currently these interval set elements are dumped in order. We'll
likely get new representations soon that may not guarantee this
anymore, so let's revisit this later in case we need it.

Without this patch, nft list ruleset with a set containing 40000
elements takes on my laptop:

        real    0m2.742s
        user    0m0.112s
        sys     0m0.280s

With this patch:

        real    0m2.846s
        user    0m0.180s
        sys     0m0.284s

Difference is small, so don't get nft more complicated with yet
another getopt() option, enable this by default.
