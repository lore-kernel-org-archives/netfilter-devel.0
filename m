From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/3] net/netfilter: refactor notifier registration
Date: Fri, 24 Feb 2012 03:25:30 +0100
Message-ID: <20120224022530.GA7423@1984>
References: <1329893281-508699-1-git-send-email-antonz@parallels.com>
 <1329893281-508699-3-git-send-email-antonz@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Eric Dumazet <eric.dumazet@gmail.com>
To: Tony Zelenoff <antonz@parallels.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42101 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753632Ab2BXCZi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Feb 2012 21:25:38 -0500
Content-Disposition: inline
In-Reply-To: <1329893281-508699-3-git-send-email-antonz@parallels.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 22, 2012 at 10:48:00AM +0400, Tony Zelenoff wrote:
> * ret variable initialization removed as useless
> * Similar code strings concatenated and functions code
>   flow became more plain
> 
> Signed-off-by: Tony Zelenoff <antonz@parallels.com>
> ---
>  net/netfilter/nf_conntrack_ecache.c |   26 ++++++++++----------------
>  1 files changed, 10 insertions(+), 16 deletions(-)
> 
> diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
> index aa15977..9b8e986 100644
> --- a/net/netfilter/nf_conntrack_ecache.c
> +++ b/net/netfilter/nf_conntrack_ecache.c
> @@ -81,21 +81,18 @@ EXPORT_SYMBOL_GPL(nf_ct_deliver_cached_events);
>  int nf_conntrack_register_notifier(struct net *net,
>  				   struct nf_ct_event_notifier *new)
>  {
> -	int ret = 0;
> +	int ret;
>  	struct nf_ct_event_notifier *notify;
>  
>  	mutex_lock(&nf_ct_ecache_mutex);
>  	notify = rcu_dereference_protected(net->ct.nf_conntrack_event_cb,
>  					   lockdep_is_held(&nf_ct_ecache_mutex));
> -	if (notify != NULL) {
> +	if (likely(!notify)) {
> +		rcu_assign_pointer(net->ct.nf_conntrack_event_cb, new);
> +		ret = 0;

I agree with Eric here.

1) Code readability is worst after this change.
2) More important, event notifier registration is not in the hot path,
so this likely is not worth to have.

Sorry, I won't take this patch.
