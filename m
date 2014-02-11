From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables (nft-compat) PATCH 8/8] nft: Initialize according to
 requested table, if any
Date: Tue, 11 Feb 2014 14:07:01 +0100
Message-ID: <20140211130701.GA24450@localhost>
References: <1392115608-6733-1-git-send-email-tomasz.bursztyka@linux.intel.com>
 <1392115608-6733-9-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47443 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752334AbaBKNHK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Feb 2014 08:07:10 -0500
Content-Disposition: inline
In-Reply-To: <1392115608-6733-9-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Feb 11, 2014 at 12:46:48PM +0200, Tomasz Bursztyka wrote:
> This will prevent too much overhead when initializing the table when
> loading the configuration on builtin tables.
> 
> Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
> ---
>  iptables/nft.c                | 41 +++++++++++++++++++++++++++++++++--------
>  iptables/nft.h                |  4 +++-
>  iptables/xtables-arp.c        |  2 +-
>  iptables/xtables-config.c     |  2 +-
>  iptables/xtables-restore.c    | 16 ++++++++--------
>  iptables/xtables-save.c       | 16 ++++++++--------
>  iptables/xtables-standalone.c |  2 +-
>  iptables/xtables.c            |  1 +
>  8 files changed, 56 insertions(+), 28 deletions(-)
> 
> diff --git a/iptables/nft.c b/iptables/nft.c
> index 0283d92..4166046 100644
> --- a/iptables/nft.c
> +++ b/iptables/nft.c
> @@ -436,6 +436,9 @@ nft_table_builtin_add(struct nft_handle *h, struct builtin_table *_t,
>  	struct nft_table *t;
>  	int ret;
>  
> +	if (h->table && h->initialized)
> +		return 0;

Does it work the autochain load if you reload with rules in different
tables? eg. filter and raw.

This h->initialized field is global, I think we need one per table.
