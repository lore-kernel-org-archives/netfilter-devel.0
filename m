From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nf_ct_helper: bail out on duplicated ports
Date: Mon, 30 May 2016 12:25:04 +0200
Message-ID: <20160530102433.GA1817@salvia>
References: <1464167637-7996-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52580 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754658AbcE3KZP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 May 2016 06:25:15 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 0CF9E178E8A
	for <netfilter-devel@vger.kernel.org>; Mon, 30 May 2016 12:25:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id F04E815D633
	for <netfilter-devel@vger.kernel.org>; Mon, 30 May 2016 12:25:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 04BE915D633
	for <netfilter-devel@vger.kernel.org>; Mon, 30 May 2016 12:25:10 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1464167637-7996-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, May 25, 2016 at 11:13:57AM +0200, Pablo Neira Ayuso wrote:
> Compare the helper name up to the dash, so we can catch if the user has
> supplied duplicated ports via module parameters.
> 
> Reported-by: Feng Gao <gfree.wind@gmail.com>
> Reported-by: Taehee Yoo <ap420073@gmail.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  net/netfilter/nf_conntrack_helper.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
> index 3b40ec5..94f36f2 100644
> --- a/net/netfilter/nf_conntrack_helper.c
> +++ b/net/netfilter/nf_conntrack_helper.c
> @@ -361,9 +361,10 @@ EXPORT_SYMBOL_GPL(nf_ct_helper_log);
>  
>  int nf_conntrack_helper_register(struct nf_conntrack_helper *me)
>  {
> -	int ret = 0;
>  	struct nf_conntrack_helper *cur;
>  	unsigned int h = helper_hash(&me->tuple);
> +	const char *slash;
> +	int len, ret = 0;
>  
>  	BUG_ON(me->expect_policy == NULL);
>  	BUG_ON(me->expect_class_max >= NF_CT_MAX_EXPECT_CLASSES);
> @@ -371,7 +372,13 @@ int nf_conntrack_helper_register(struct nf_conntrack_helper *me)
>  
>  	mutex_lock(&nf_ct_helper_mutex);
>  	hlist_for_each_entry(cur, &nf_ct_helper_hash[h], hnode) {
> -		if (strncmp(cur->name, me->name, NF_CT_HELPER_NAME_LEN) == 0 &&
> +		slash = strchr(cur->name, '-');

I'm discarding this, we have a valid helper using dash in the name.

net/netfilter/nf_conntrack_netbios_ns.c:        .name = "netbios-ns",

Will send a new version of this patch.
