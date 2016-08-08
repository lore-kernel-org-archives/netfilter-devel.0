From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nf_expect_proc: remove the redundant slash
 when policy name is empty
Date: Mon, 8 Aug 2016 16:06:23 +0200
Message-ID: <20160808140623.GA5269@salvia>
References: <1470664678-19155-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60294 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752495AbcHHOG3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Aug 2016 10:06:29 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 8EC6A1878A1
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Aug 2016 16:06:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 805A71B3328
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Aug 2016 16:06:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 69A8B1B3260
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Aug 2016 16:06:25 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1470664678-19155-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 08, 2016 at 09:57:58PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> The 'name' filed in struct nf_conntrack_expect_policy{} is not a
> pointer, so check it is NULL or not will always return true. Even if the
> name is empty, slash will always be displayed like follows:
>   # cat /proc/net/nf_conntrack_expect
>   297 l3proto = 2 proto=6 src=1.1.1.1 dst=2.2.2.2 sport=1 dport=1025 ftp/
>                                                                         ^
> 
> Fixes: 3a8fc53a45c4 ("netfilter: nf_ct_helper: allocate 16 bytes for the helper and policy names")
> Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
> ---
>  net/netfilter/nf_conntrack_expect.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
> index 9e36931..a4f3cc8 100644
> --- a/net/netfilter/nf_conntrack_expect.c
> +++ b/net/netfilter/nf_conntrack_expect.c
> @@ -574,7 +574,7 @@ static int exp_seq_show(struct seq_file *s, void *v)
>  	helper = rcu_dereference(nfct_help(expect->master)->helper);
>  	if (helper) {
>  		seq_printf(s, "%s%s", expect->flags ? " " : "", helper->name);
> -		if (helper->expect_policy[expect->class].name)
> +		if (helper->expect_policy[expect->class].name[0] != '\0')

Good catch. I can simplify this here to:

                if (helper->expect_policy[expect->class].name[0])

We use similar idiom in other locations in the netfilter code. No need
to resend if OK with it.
