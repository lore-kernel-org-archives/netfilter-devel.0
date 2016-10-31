From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH next] nft_meta: add skb hash get support
Date: Mon, 31 Oct 2016 15:24:46 +0100
Message-ID: <20161031142446.GA21862@salvia>
References: <1477917869-26872-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53928 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S943418AbcJaOYv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 31 Oct 2016 10:24:51 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9A5D1E8394
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Oct 2016 15:24:49 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7E066DA81F
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Oct 2016 15:24:49 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 62DCCDA84E
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Oct 2016 15:24:47 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1477917869-26872-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Oct 31, 2016 at 01:44:29PM +0100, Florian Westphal wrote:
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
> NB1: Alternative is to place this in nft_hash, but that uses
> an sreg so i think meta is fine.
> 
> NB2: This causes a compile warning wrt. __skb_get_hash_symmetric;
> net-next tree contains a change to make its argument const so this
> warning won't show up anymore one this commit makes it to net-next.

Let me send a nf-next pull request, then I'll resync so I can take
this and my pending core rework on top. Will be doing this at some
point today.
