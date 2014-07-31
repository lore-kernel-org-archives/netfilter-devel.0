From: Julian Anastasov <ja@ssi.bg>
Subject: Re: [PATCH nf-next] netfilter: don't use
 mutex_lock_interruptible()
Date: Thu, 31 Jul 2014 22:12:02 +0300 (EEST)
Message-ID: <alpine.LFD.2.11.1407312207280.1630@ja.home.ssi.bg>
References: <1406831926-7249-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net,
	edumazet@google.com, horms@verge.net.au
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ja.ssi.bg ([178.16.129.10]:33695 "EHLO ja.home.ssi.bg"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750781AbaGaTMr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Jul 2014 15:12:47 -0400
In-Reply-To: <1406831926-7249-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


	Hello,

On Thu, 31 Jul 2014, Pablo Neira Ayuso wrote:

> Eric Dumazet reports that getsockopt() or setsockopt() sometimes
> returns -EINTR instead of -ENOPROTOOPT, causing headaches to
> application developers.
> 
> This patch replaces all the mutex_lock_interruptible() by mutex_lock()
> in the netfilter tree, as there is no reason we should sleep for a
> long time there.
> 
> Reported-by: Eric Dumazet <edumazet@google.com>
> Suggested-by: Patrick McHardy <kaber@trash.net>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---

	IPVS part looks ok, here is ack if needed:

Acked-by: Julian Anastasov <ja@ssi.bg>

>  net/bridge/netfilter/ebtables.c |   10 ++-------
>  net/netfilter/core.c            |   11 ++-------
>  net/netfilter/ipvs/ip_vs_ctl.c  |   19 ++++------------
>  net/netfilter/nf_sockopt.c      |    8 ++-----
>  net/netfilter/x_tables.c        |   47 ++++++++++-----------------------------
>  5 files changed, 22 insertions(+), 73 deletions(-)

Regards

--
Julian Anastasov <ja@ssi.bg>
