From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: nft_ct: fix random validation errors
 for zone set support
Date: Thu, 23 Feb 2017 21:51:05 +0100
Message-ID: <20170223205105.GA7414@salvia>
References: <20170213191354.GA5325@mwanda>
 <20170213212649.10176-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35240 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751201AbdBWUvQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Feb 2017 15:51:16 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B2B9796ED2
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Feb 2017 21:51:11 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A38F7DA842
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Feb 2017 21:51:11 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 05446DA804
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Feb 2017 21:51:07 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170213212649.10176-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Feb 13, 2017 at 10:26:49PM +0100, Florian Westphal wrote:
> Dan reports:
>  net/netfilter/nft_ct.c:549 nft_ct_set_init()
>  error: uninitialized symbol 'len'.

Applied, thanks.
