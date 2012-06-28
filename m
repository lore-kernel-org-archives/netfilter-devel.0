From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH 3/3] nfnetlink: Unlock a previously locked rcu_read in
 nfnetlink_rcv_msg
Date: Thu, 28 Jun 2012 15:30:10 +0200
Message-ID: <1340890210.13187.100.camel@edumazet-glaptop>
References: <1340888269-4926-1-git-send-email-tomasz.bursztyka@linux.intel.com>
	 <1340888269-4926-4-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:52371 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567Ab2F1NaS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Jun 2012 09:30:18 -0400
Received: by eaak11 with SMTP id k11so791401eaa.19
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Jun 2012 06:30:16 -0700 (PDT)
In-Reply-To: <1340888269-4926-4-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 2012-06-28 at 15:57 +0300, Tomasz Bursztyka wrote:
> Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
> ---
>  net/netfilter/nfnetlink.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
> index 4acdd76..a6366ae 100644
> --- a/net/netfilter/nfnetlink.c
> +++ b/net/netfilter/nfnetlink.c
> @@ -169,8 +169,10 @@ replay:
>  
>  		err = nla_parse(cda, ss->cb[cb_id].attr_count,
>  				attr, attrlen, ss->cb[cb_id].policy);
> -		if (err < 0)
> +		if (err < 0) {
> +			rcu_read_unlock();
>  			return err;
> +		}
>  
>  		if (nc->call_rcu) {
>  			err = nc->call_rcu(net->nfnl, skb, nlh,

Nice catch, thanks.

Please someone add in changelog to ease stable team work :

Bug added in commit 6b75e3e8d664a9a (netfilter: nfnetlink: add RCU in
nfnetlink_rcv_msg())

Acked-by: Eric Dumazet <edumazet@google.com>


