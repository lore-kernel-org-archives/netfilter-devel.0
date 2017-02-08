From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nftables 0/7] TCP option matching
Date: Wed, 8 Feb 2017 10:32:35 +0100
Message-ID: <20170208093235.GA4433@salvia>
References: <20170207021415.22460-1-mm@skelett.io>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
To: Manuel Messner <mm@skelett.io>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:32940 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932631AbdBHJcv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Feb 2017 04:32:51 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8C6CB1373A8
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Feb 2017 10:32:49 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 74A8BBAAA7
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Feb 2017 10:32:49 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4AE76BAAAC
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Feb 2017 10:32:47 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170207021415.22460-1-mm@skelett.io>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Feb 07, 2017 at 03:14:08AM +0100, Manuel Messner wrote:
> This patch set is part of the TCP option matching implementation for nftables.
> 
> These patch sets enable nft to match against the following TCP options:
> * End of Option List
> * No-Operation
> * Maximum Segment Size
> * Window Scale
> * SACK
> * SACK Permitted
> * Timestamps

Florian, please feel free to push out this once the kernel side hits
David's tree.

Thanks!
