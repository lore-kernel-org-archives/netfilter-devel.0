From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables-translate: Moving printing of nft to individual
 commands.
Date: Thu, 31 Mar 2016 12:37:27 +0200
Message-ID: <20160331103727.GA3104@salvia>
References: <20160331102654.GA14649@inbhdhcp21574.apac.nsn-net.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Guruswamy Basavaiah <guru2018@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54520 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751664AbcCaKhg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Mar 2016 06:37:36 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id E6140E8628
	for <netfilter-devel@vger.kernel.org>; Thu, 31 Mar 2016 12:37:34 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D7CA3DA38A
	for <netfilter-devel@vger.kernel.org>; Thu, 31 Mar 2016 12:37:34 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E7057DA38A
	for <netfilter-devel@vger.kernel.org>; Thu, 31 Mar 2016 12:37:32 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160331102654.GA14649@inbhdhcp21574.apac.nsn-net.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 31, 2016 at 03:56:55PM +0530, Guruswamy Basavaiah wrote:
> Moving printing of "nft" to individual commands.
> 
> At present the "nft" is not printed, if iptables command is translated into
> multiple commads.
> 
> Before this patch:
> sudo ./iptables-translate -A INPUT --source "40.0.0.1, 30.0.0.1" --dest "20.0.0.1, 60.0.0.1" -j ACCEPT
> nft add rule ip filter INPUT ip saddr 40.0.0.1 ip daddr 20.0.0.1 counter accept
> add rule ip filter INPUT ip saddr 40.0.0.1 ip daddr 60.0.0.1 counter accept
> add rule ip filter INPUT ip saddr 30.0.0.1 ip daddr 20.0.0.1 counter accept
> add rule ip filter INPUT ip saddr 30.0.0.1 ip daddr 60.0.0.1 counter accept
> 
> After this patch:
> sudo ./iptables-translate -A INPUT --source "40.0.0.1, 30.0.0.1" --dest "20.0.0.1, 60.0.0.1" -j ACCEPT
> nft add rule ip filter INPUT ip saddr 40.0.0.1 ip daddr 20.0.0.1 counter accept
> nft add rule ip filter INPUT ip saddr 40.0.0.1 ip daddr 60.0.0.1 counter accept
> nft add rule ip filter INPUT ip saddr 30.0.0.1 ip daddr 20.0.0.1 counter accept
> nft add rule ip filter INPUT ip saddr 30.0.0.1 ip daddr 60.0.0.1 counter accept
> 
> Signed-off-by: Guruswamy Basavaiah <guru2018@gmail.com>
> ---
>  iptables/xtables-translate.c | 15 +++++++--------
>  1 file changed, 7 insertions(+), 8 deletions(-)
> 
> diff --git a/iptables/xtables-translate.c b/iptables/xtables-translate.c
> index 354357c..569c26e 100644
> --- a/iptables/xtables-translate.c
> +++ b/iptables/xtables-translate.c
> @@ -107,10 +107,10 @@ static int nft_rule_xlate_add(struct nft_handle *h,
>  	int ret;
>  
>  	if (append) {
> -		xt_xlate_add(xl, "add rule %s %s %s ",
> +		xt_xlate_add(xl, "nft add rule %s %s %s ",
>  			   family2str[h->family], p->table, p->chain);

This breaks iptables-restore-translate:

# iptables-restore-translate -f my-iptables-ruleset

Actually this is currently broken, could you send a patch that fixes
this in first place.

Thanks.
