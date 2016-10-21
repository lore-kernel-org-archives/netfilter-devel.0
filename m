From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] tests: shell: update kernel modules to clean
Date: Fri, 21 Oct 2016 12:22:45 +0200
Message-ID: <20161021102245.GA1814@salvia>
References: <147678057414.13185.13617317125083465042.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43044 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752886AbcJUKWy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 Oct 2016 06:22:54 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5EBC626E0A
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Oct 2016 12:22:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4DC55BAC27
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Oct 2016 12:22:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1E36EBAC3B
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Oct 2016 12:22:50 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <147678057414.13185.13617317125083465042.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Oct 18, 2016 at 10:49:34AM +0200, Arturo Borrero Gonzalez wrote:
> From: Arturo Borrero Gonzalez <arturo@debian.org>
> 
> Let's keep the kernel_cleanup() function updated with latest
> kernel changes:
> 
>  * added nft_quota, nft_queue, nft_numgen, nft_range
>  * rename nft_hash to nft_set_hash
>  * keep nft_hash as well
>  * rename nft_rbtree to nft_set_rbtree
> 
> The idea is to run each test in a clean evironment.

Applied, thanks Arturo.
