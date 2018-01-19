From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] doc/nft.xml: mention nftables earlier
Date: Fri, 19 Jan 2018 13:49:55 +0100
Message-ID: <20180119124955.iwbqi3m6mhiozr5j@salvia>
References: <151636426787.19915.2075416375709343233.stgit@endurance>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39550 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751212AbeASMt7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Jan 2018 07:49:59 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6119620A52A
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jan 2018 13:49:58 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5104CDA854
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jan 2018 13:49:58 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <151636426787.19915.2075416375709343233.stgit@endurance>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jan 19, 2018 at 01:17:47PM +0100, Arturo Borrero Gonzalez wrote:
> Mention nftables earlier in the documentation, so users have more context on what
> we are talking about.
> 
> This is Debian bug #887718, which contains:
> 
> <<<
> Currently one must read down 100 lines before it is even mentioned.
> You might want to make the connection between "nft" and "nftables" as
> early as the NAME or DESCRIPTION.
> >>>

Applied, thanks Arturo.
