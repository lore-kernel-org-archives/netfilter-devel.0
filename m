From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCHv4 2/3] netfilter: xt_NFQUEUE: separate reusable code
Date: Sat, 7 Dec 2013 23:56:38 +0100
Message-ID: <20131207225638.GA4313@localhost>
References: <20131205214133.GA4307@localhost>
 <1386285853-464-1-git-send-email-eric@regit.org>
 <1386285853-464-3-git-send-email-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42817 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754446Ab3LGW4n (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 7 Dec 2013 17:56:43 -0500
Content-Disposition: inline
In-Reply-To: <1386285853-464-3-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Dec 06, 2013 at 12:24:12AM +0100, Eric Leblond wrote:
> This patch prepares the adding of nft_queue module by putting
> reusable code into a header file.
> 
> Signed-off-by: Eric Leblond <eric@regit.org>
> ---
>  include/net/netfilter/nf_queue.h | 63 +++++++++++++++++++++++++++++++++
>  net/netfilter/xt_NFQUEUE.c       | 75 +++++-----------------------------------
>  2 files changed, 71 insertions(+), 67 deletions(-)
> 
> diff --git a/include/net/netfilter/nf_queue.h b/include/net/netfilter/nf_queue.h
> index c1d5b3e..0a71ab0 100644
> --- a/include/net/netfilter/nf_queue.h
> +++ b/include/net/netfilter/nf_queue.h

This header file is also used by net/netfilter/nfnetlink_queue_core,
then...

> @@ -1,6 +1,10 @@
>  #ifndef _NF_QUEUE_H
>  #define _NF_QUEUE_H
>  
> +#include <linux/ip.h>
> +#include <linux/ipv6.h>
> +#include <linux/jhash.h>
> +
>  /* Each queued (to userspace) skbuff has one of these. */
>  struct nf_queue_entry {
>  	struct list_head	list;
> @@ -33,4 +37,63 @@ void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict);
>  bool nf_queue_entry_get_refs(struct nf_queue_entry *entry);
>  void nf_queue_entry_release_refs(struct nf_queue_entry *entry);
>  
> +static u32 jhash_initval __read_mostly;

This variable will be also reserved in that module as well. I have
fixed this by adding a jhash_initval parameter to init_hashrandom,
hash_v4, hash_v6 and nfqueue_hash.

Please, no need to send a new patchset, check my nftables tree and
tell if you find any issue, otherwise I'll pull these changes to
nf-next. Thanks.
