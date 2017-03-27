From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 1/1] netfilter: Use bool type instead of int as
 the return value of nf_conntrack_tuple_taken and nf_nat_used_tuple
Date: Mon, 27 Mar 2017 14:24:43 +0200
Message-ID: <20170327122443.GA25192@salvia>
References: <1488860935-525-1-git-send-email-fgao@ikuai8.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, gfree.wind@gmail.com
To: fgao@ikuai8.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59994 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752147AbdC0MZf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Mar 2017 08:25:35 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 887B4EAA7F
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Mar 2017 14:24:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 771AEBAC28
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Mar 2017 14:24:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 69638BAC40
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Mar 2017 14:24:46 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1488860935-525-1-git-send-email-fgao@ikuai8.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 07, 2017 at 12:28:55PM +0800, fgao@ikuai8.com wrote:
> From: Gao Feng <fgao@ikuai8.com>
> 
> These two functions return 1/0 as true or false, so it could use bool
> type directly instead of int.

Too long patch subject.
 
> Signed-off-by: Gao Feng <fgao@ikuai8.com>
> ---
>  include/net/netfilter/nf_conntrack.h | 2 +-
>  include/net/netfilter/nf_nat.h       | 2 +-
>  net/netfilter/nf_conntrack_core.c    | 6 +++---
>  net/netfilter/nf_nat_core.c          | 2 +-
>  4 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
> index f540f9a..32a0394 100644
> --- a/include/net/netfilter/nf_conntrack.h
> +++ b/include/net/netfilter/nf_conntrack.h
> @@ -160,7 +160,7 @@ void nf_conntrack_alter_reply(struct nf_conn *ct,
>  
>  /* Is this tuple taken? (ignoring any belonging to the given
>     conntrack). */
> -int nf_conntrack_tuple_taken(const struct nf_conntrack_tuple *tuple,
> +bool nf_conntrack_tuple_taken(const struct nf_conntrack_tuple *tuple,
>  			     const struct nf_conn *ignored_conntrack);

Did you audit callers if they handle this type change accordingly? I
don't see any description about this on your patch.
