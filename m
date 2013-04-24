From: Nishit Shah <nsshah.82@gmail.com>
Subject: Re: [PATCH 14/14] nfnetlink: add support for memory mapped netlink
Date: Wed, 24 Apr 2013 20:14:06 +0530
Message-ID: <CAED+v=bdjZE=CKMvKfmE_Z=57K-K6xy_EeLMCU8xsokq4Kc6ZA@mail.gmail.com>
References: <1366217229-22705-1-git-send-email-kaber@trash.net>
	<1366217229-22705-15-git-send-email-kaber@trash.net>
	<CAED+v=bCkEa8gOO9pu62hmj_H9WXz4+OBiCeyxBUO10L9EdDkA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:61619 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755906Ab3DXOoH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Apr 2013 10:44:07 -0400
Received: by mail-ob0-f178.google.com with SMTP id 16so1578516obc.9
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Apr 2013 07:44:06 -0700 (PDT)
In-Reply-To: <CAED+v=bCkEa8gOO9pu62hmj_H9WXz4+OBiCeyxBUO10L9EdDkA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Wed, Apr 17, 2013 at 10:17 PM, Patrick McHardy <kaber@trash.net> wrote:
>
> Signed-off-by: Patrick McHardy <kaber@trash.net>
> ---
>  include/linux/netfilter/nfnetlink.h  |  2 ++
>  net/netfilter/nfnetlink.c            |  7 +++++++
>  net/netfilter/nfnetlink_log.c        | 10 ++++++----
>  net/netfilter/nfnetlink_queue_core.c |  3 ++-
>  4 files changed, 17 insertions(+), 5 deletions(-)
>
> diff --git a/net/netfilter/nfnetlink_queue_core.c b/net/netfilter/nfnetlink_queue_core.c
> index 5e280b3..ef3cdb4 100644
> --- a/net/netfilter/nfnetlink_queue_core.c
> +++ b/net/netfilter/nfnetlink_queue_core.c
> @@ -339,7 +339,8 @@ nfqnl_build_packet_message(struct nfqnl_instance *queue,
>         if (queue->flags & NFQA_CFG_F_CONNTRACK)
>                 ct = nfqnl_ct_get(entskb, &size, &ctinfo);
>
> -       skb = alloc_skb(size, GFP_ATOMIC);
> +       skb = nfnetlink_alloc_skb(&init_net, size, queue->peer_portid,
> +                                 GFP_ATOMIC);
>         if (!skb)
>                 return NULL;
>

does this mean that we have a true zero copy support with Eric D's
patch (nfnetlink_queue: zero-copy support) and this patch ?

Rgds,
Nishit Shah.
