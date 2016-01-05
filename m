From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 5/5] netfilter: nfnetlink_log: just returns error
 for unknown command
Date: Tue, 5 Jan 2016 12:03:53 +0100
Message-ID: <20160105110353.GA6085@salvia>
References: <20151006021246.GB30037@gmail.com>
 <20151006100728.GA2429@salvia>
 <20151007042016.GA23203@gmail.com>
 <20151007042550.GC23203@gmail.com>
 <20151016170532.GA18148@salvia>
 <20151106004640.GA11266@gmail.com>
 <20151106004947.GB11266@gmail.com>
 <20151108221454.GA21221@salvia>
 <20160105002456.GA27154@gmail.com>
 <20160105003434.GF27154@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35363 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751748AbcAELEB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Jan 2016 06:04:01 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id B68F9130FDC
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Jan 2016 12:03:57 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A6884DA803
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Jan 2016 12:03:57 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id BBE61DA803
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Jan 2016 12:03:54 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160105003434.GF27154@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jan 05, 2016 at 09:34:34AM +0900, Ken-ichirou MATSUZAWA wrote:
> This patch stops processing options for unknown command.
> 
> Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
> ---
>  net/netfilter/nfnetlink_log.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
> index 6a57f10..643c2d3 100644
> --- a/net/netfilter/nfnetlink_log.c
> +++ b/net/netfilter/nfnetlink_log.c
> @@ -888,7 +888,9 @@ static int nfulnl_recv_config(struct net *net, struct sock *ctnl,
>  			goto out_put;
>  		default:
>  			ret = -ENOTSUPP;
> -			break;
> +			if (inst)
> +				goto out_put;
> +			goto out;

We can simplify this to:

                        goto out_put;

since instance_put() already checks if inst is non-null.

No need to resend, I'll fix this here.

Thanks a lot for following up on this series Ken-ichirou :-).
