From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 5/5] conntrack: man: Add description of tables dying and
 unconfirmed.
Date: Fri, 8 Apr 2016 12:19:21 +0200
Message-ID: <20160408101921.GD2142@salvia>
References: <1460053902-2200-1-git-send-email-mart.frauenlob@chello.at>
 <1460053902-2200-6-git-send-email-mart.frauenlob@chello.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Mart Frauenlob <mart.frauenlob@chello.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36270 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753756AbcDHKT0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 Apr 2016 06:19:26 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 21339C9ECF
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Apr 2016 12:19:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 0F170DA8F7
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Apr 2016 12:19:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id AC8B3DA392
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Apr 2016 12:19:22 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1460053902-2200-6-git-send-email-mart.frauenlob@chello.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Applied, thanks.

On Thu, Apr 07, 2016 at 08:31:42PM +0200, Mart Frauenlob wrote:
> 
> Signed-off-by: Mart Frauenlob <mart.frauenlob@chello.at>
> ---
>  conntrack.8 |   17 +++++++++++++++++
>  1 files changed, 17 insertions(+), 0 deletions(-)
> 
> diff --git a/conntrack.8 b/conntrack.8
> index e54951a..dfde9f0 100644
> --- a/conntrack.8
> +++ b/conntrack.8
> @@ -48,6 +48,23 @@ mechanism used to "expect" RELATED connections to existing ones.  Expectations
>  are generally used by "connection tracking helpers" (sometimes called
>  application level gateways [ALGs]) for more complex protocols such as FTP,
>  SIP, H.323.
> +.TP
> +.BR "dying" :
> +This table shows the conntrack entries, that have expired and that have been
> +destroyed by the connection tracking system itself, or via the conntrack utility.
> +.TP
> +.BR "unconfirmed" :
> +This table shows new entries, that are not yet inserted into the conntrack table.
> +These entries are attached to packets that are traversing the stack,
> +but did not reach the confirmation point at the postrouting hook.
> +.PP
> +The tables "dying" and "unconfirmed" are basically only useful for debugging purposes.
> +Under normal operation, it is hard to see entries in any of them.
> +There are corner cases, where it is valid to see entries in the
> +unconfirmed table:
> +1) when packets that are enqueued via nfqueue, or
> +2) when conntrackd runs in event reliable mode.
> +.PP
>  .SH OPTIONS
>  The options recognized by 
>  .B conntrack
> -- 
> 1.7.2.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
