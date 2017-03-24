From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf 1/1] netfilter: expect: Make sure the max_expected
 limit is effective
Date: Fri, 24 Mar 2017 12:43:25 +0100
Message-ID: <20170324114325.GA2397@salvia>
References: <1490319517-47760-1-git-send-email-gfree.wind@foxmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Gao Feng <fgao@ikuai8.com>
To: gfree.wind@foxmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60272 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935564AbdCXLxo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Mar 2017 07:53:44 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E95CFEBAE9
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Mar 2017 12:43:28 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DA6CEDA872
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Mar 2017 12:43:28 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 38DE8DA86F
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Mar 2017 12:43:25 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1490319517-47760-1-git-send-email-gfree.wind@foxmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Mar 24, 2017 at 09:38:37AM +0800, gfree.wind@foxmail.com wrote:
> From: Gao Feng <fgao@ikuai8.com>
> 
> Because the type of expecting, the member of nf_conn_help, is u8, it
> would overflow after reach U8_MAX(255). So it doesn't work when we
> configure the max_expected exceeds 255 with expect policy.
> 
> Now add the check for max_expected. Return the -EINVAL when it exceeds
> the limit.
> 
> Signed-off-by: Gao Feng <fgao@ikuai8.com>
> ---
>  include/net/netfilter/nf_conntrack_expect.h | 1 +
>  net/netfilter/nf_conntrack_helper.c         | 3 +++
>  net/netfilter/nfnetlink_cthelper.c          | 4 ++++
>  3 files changed, 8 insertions(+)
> 
> diff --git a/include/net/netfilter/nf_conntrack_expect.h b/include/net/netfilter/nf_conntrack_expect.h
> index 5ed33ea..aa36a31 100644
> --- a/include/net/netfilter/nf_conntrack_expect.h
> +++ b/include/net/netfilter/nf_conntrack_expect.h
> @@ -71,6 +71,7 @@ struct nf_conntrack_expect_policy {
>  };
>  
>  #define NF_CT_EXPECT_CLASS_DEFAULT	0
> +#define NF_CT_EXPECT_MAX_CNT		U8_MAX

use NF_CT_EXPECT_MAX. We will expose this to userspace at some point
now that we have infrastructure to configure helpers from nft
(Florian's work already in nf-next) so use 255 instead of U8_MAX is
fine.

>  int nf_conntrack_expect_pernet_init(struct net *net);
>  void nf_conntrack_expect_pernet_fini(struct net *net);
> diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
> index 6dc44d9..752a977 100644
> --- a/net/netfilter/nf_conntrack_helper.c
> +++ b/net/netfilter/nf_conntrack_helper.c
> @@ -385,6 +385,9 @@ int nf_conntrack_helper_register(struct nf_conntrack_helper *me)
>  	BUG_ON(me->expect_class_max >= NF_CT_MAX_EXPECT_CLASSES);
>  	BUG_ON(strlen(me->name) > NF_CT_HELPER_NAME_LEN - 1);
>  
> +	if (me->expect_policy->max_expected > NF_CT_EXPECT_MAX_CNT)
> +		return -EINVAL;

I swear this is also exposed through modparams, right? So this patch
may be missing something.
