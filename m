From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH -next] Revert "netfilter: tproxy: do not assign timewait
 sockets to skb->sk"
Date: Wed, 29 May 2013 07:56:51 -0700
Message-ID: <1369839411.5109.31.camel@edumazet-glaptop>
References: <1369792719-3945-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f42.google.com ([209.85.160.42]:55449 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966347Ab3E2O4x (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 May 2013 10:56:53 -0400
Received: by mail-pb0-f42.google.com with SMTP id uo1so9314871pbc.15
        for <netfilter-devel@vger.kernel.org>; Wed, 29 May 2013 07:56:52 -0700 (PDT)
In-Reply-To: <1369792719-3945-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 2013-05-29 at 03:58 +0200, Florian Westphal wrote:
> This reverts commit d503b30bd648b3cb4e5f50b65d27e389960cc6d9.
> 
> Nowadays we have early socket demux; all the input code paths
> should handle "skb->sk points to timewait sock" properly.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  include/net/netfilter/nf_tproxy_core.h |   12 +++++++++++-
>  net/netfilter/nf_tproxy_core.c         |   27 +++++++++++++++------------
>  net/netfilter/xt_TPROXY.c              |   22 ++--------------------
>  net/netfilter/xt_socket.c              |   13 ++-----------
>  4 files changed, 30 insertions(+), 44 deletions(-)

BTW, why xt_socket ignores listener bound on INADDR_ANY ?



