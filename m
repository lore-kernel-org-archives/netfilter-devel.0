From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: expect: add to hash table after expect init
Date: Mon, 24 Jul 2017 12:20:44 +0200
Message-ID: <20170724102044.GA4608@salvia>
References: <20170710130639.24167-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60908 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751376AbdGXKUv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Jul 2017 06:20:51 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0304917988D
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Jul 2017 12:20:38 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DB972D1D98
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Jul 2017 12:20:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B8A52DA7F4
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Jul 2017 12:20:35 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170710130639.24167-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jul 10, 2017 at 03:06:39PM +0200, Florian Westphal wrote:
> assuming we have lockless readers we should make sure they can only
> see expectations that have already been initialized.
> 
> hlist_add_head_rcu acts as memory barrier, move it after timer setup.
> 
> Theoretically we could crash due to a del_timer() on other cpu
> seeing garbage data.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  Not seen in practice, however i think this race
>  is real.  Defer to nf-next if you think its not urgent.

Applied to nf-next, thanks!
