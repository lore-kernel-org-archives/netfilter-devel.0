From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: x_tables: suppress kmemcheck warning
Date: Wed, 19 Oct 2016 18:33:32 +0200
Message-ID: <20161019163332.GA7994@salvia>
References: <1476733823-10714-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37074 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932707AbcJSQdl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Oct 2016 12:33:41 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 939E89B7E9
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Oct 2016 18:33:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 85D26DA916
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Oct 2016 18:33:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 50C6CDA854
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Oct 2016 18:33:37 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1476733823-10714-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Oct 17, 2016 at 09:50:23PM +0200, Florian Westphal wrote:
> Markus Trippelsdorf reports:
> 
> WARNING: kmemcheck: Caught 64-bit read from uninitialized memory (ffff88001e605480)
> 4055601e0088ffff000000000000000090686d81ffffffff0000000000000000
>  u u u u u u u u u u u u u u u u i i i i i i i i u u u u u u u u
>  ^
> |RIP: 0010:[<ffffffff8166e561>]  [<ffffffff8166e561>] nf_register_net_hook+0x51/0x160
> [..]
>  [<ffffffff8166e561>] nf_register_net_hook+0x51/0x160
>  [<ffffffff8166eaaf>] nf_register_net_hooks+0x3f/0xa0
>  [<ffffffff816d6715>] ipt_register_table+0xe5/0x110
> [..]
> 
> This warning is harmless; we copy 'uninitialized' data from the hook ops
> but it will not be used.
> Long term the structures keeping run-time data should be disentangled
> from those only containing config-time data (such as where in the list
> to insert a hook), but thats -next material.

Applied, thanks.
