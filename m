From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCHv3 2/3] netfilter: xt_NFQUEUE: separate reusable code
Date: Thu, 5 Dec 2013 22:41:33 +0100
Message-ID: <20131205214133.GA4307@localhost>
References: <20131205170955.GA8663@localhost>
 <1386279088-4895-1-git-send-email-eric@regit.org>
 <1386279088-4895-3-git-send-email-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52400 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877Ab3LEVlt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Dec 2013 16:41:49 -0500
Content-Disposition: inline
In-Reply-To: <1386279088-4895-3-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Dec 05, 2013 at 10:31:27PM +0100, Eric Leblond wrote:
> This patch prepares the adding of nft_queue module by putting
> reusable code into a header file.
> 
> Signed-off-by: Eric Leblond <eric@regit.org>
> ---
>  net/netfilter/nf_queue.h   | 77 ++++++++++++++++++++++++++++++++++++++++++++++
>  net/netfilter/xt_NFQUEUE.c | 75 +++++---------------------------------------
>  2 files changed, 85 insertions(+), 67 deletions(-)
>  create mode 100644 net/netfilter/nf_queue.h
> 
> diff --git a/net/netfilter/nf_queue.h b/net/netfilter/nf_queue.h
> new file mode 100644
> index 0000000..c8225a1
> --- /dev/null
> +++ b/net/netfilter/nf_queue.h

Ops, sorry I meant to point to the existing include/net/netfilter/nf_queue.h
