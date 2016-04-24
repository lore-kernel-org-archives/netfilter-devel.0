From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 2/3] netfilter: conntrack: use get_random_once
 for nat and expectations
Date: Sun, 24 Apr 2016 16:09:15 +0200
Message-ID: <20160424140915.GA1141@salvia>
References: <1460989021-10780-1-git-send-email-fw@strlen.de>
 <1460989021-10780-3-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42878 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752539AbcDXOJV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 24 Apr 2016 10:09:21 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 13F2480B1D
	for <netfilter-devel@vger.kernel.org>; Sun, 24 Apr 2016 16:09:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 041769D10C
	for <netfilter-devel@vger.kernel.org>; Sun, 24 Apr 2016 16:09:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id EEA0A9D112
	for <netfilter-devel@vger.kernel.org>; Sun, 24 Apr 2016 16:09:16 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1460989021-10780-3-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

On Mon, Apr 18, 2016 at 04:17:00PM +0200, Florian Westphal wrote:
> Use a private seed and init it using get_random_once.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/netfilter/nf_conntrack_expect.c | 7 +++----
>  net/netfilter/nf_nat_core.c         | 6 ++++--
>  2 files changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
> index 278927a..c2f7c4f 100644
> --- a/net/netfilter/nf_conntrack_expect.c
> +++ b/net/netfilter/nf_conntrack_expect.c
> @@ -38,6 +38,7 @@ EXPORT_SYMBOL_GPL(nf_ct_expect_hsize);
>  unsigned int nf_ct_expect_max __read_mostly;
>  
>  static struct kmem_cache *nf_ct_expect_cachep __read_mostly;
> +static unsigned int nf_ct_expect_hashrnd __read_mostly;
>  
>  /* nf_conntrack_expect helper functions */
>  void nf_ct_unlink_expect_report(struct nf_conntrack_expect *exp,
> @@ -76,13 +77,11 @@ static unsigned int nf_ct_expect_dst_hash(const struct nf_conntrack_tuple *tuple
>  {
>  	unsigned int hash;
>  
> -	if (unlikely(!nf_conntrack_hash_rnd)) {
> -		init_nf_conntrack_hash_rnd();
> -	}
> +	get_random_once(&nf_ct_expect_hashrnd, sizeof(nf_ct_expect_hashrnd));

Not related to your patch, but to the underlying infrastructure: I can
see get_random_once() implementation uses static_key_true() branch
check.

Shouldn't this be static_key_false() instead? On architectures with
not jump_labels support, this will translate to unlikely().

If so, I can send a patch for this. I can see this DO_ONCE() API is
also using the deprecated interfaces.
