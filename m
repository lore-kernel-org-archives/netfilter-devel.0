Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B18AC433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Mar 2022 21:26:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234009AbiC2V2i (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Mar 2022 17:28:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233971AbiC2V2e (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Mar 2022 17:28:34 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9246823574C
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Mar 2022 14:26:49 -0700 (PDT)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 3332B63032;
        Tue, 29 Mar 2022 23:23:35 +0200 (CEST)
Date:   Tue, 29 Mar 2022 23:26:46 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [libnetfilter_conntrack PATCH] expect/conntrack: Avoid spurious
 covscan overrun warning
Message-ID: <YkN5llEUhMGRUmv4@salvia>
References: <20220325144807.18049-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220325144807.18049-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Mar 25, 2022 at 03:48:07PM +0100, Phil Sutter wrote:
> It doesn't like how memset() is called for a struct nfnlhdr pointer with
> large size value. Pass void pointers instead. This also removes the call
> from __build_{expect,conntrack}() which is duplicate in
> __build_query_{exp,ct}() code-path.

LGTM.

> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  src/conntrack/api.c   | 4 +++-
>  src/conntrack/build.c | 2 --
>  src/expect/api.c      | 4 +++-
>  src/expect/build.c    | 2 --
>  4 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/src/conntrack/api.c b/src/conntrack/api.c
> index b7f64fb43ce83..7f72d07f2e7f6 100644
> --- a/src/conntrack/api.c
> +++ b/src/conntrack/api.c
> @@ -779,6 +779,8 @@ int nfct_build_conntrack(struct nfnl_subsys_handle *ssh,
>  	assert(req != NULL);
>  	assert(ct != NULL);
>  
> +	memset(req, 0, size);
> +
>  	return __build_conntrack(ssh, req, size, type, flags, ct);
>  }
>  
> @@ -812,7 +814,7 @@ __build_query_ct(struct nfnl_subsys_handle *ssh,
>  	assert(data != NULL);
>  	assert(req != NULL);
>  
> -	memset(req, 0, size);
> +	memset(buffer, 0, size);
>  
>  	switch(qt) {
>  	case NFCT_Q_CREATE:
> diff --git a/src/conntrack/build.c b/src/conntrack/build.c
> index b5a7061d53698..f80cfc12d5e38 100644
> --- a/src/conntrack/build.c
> +++ b/src/conntrack/build.c
> @@ -27,8 +27,6 @@ int __build_conntrack(struct nfnl_subsys_handle *ssh,
>  		return -1;
>  	}
>  
> -	memset(req, 0, size);
> -
>  	buf = (char *)&req->nlh;
>  	nlh = mnl_nlmsg_put_header(buf);
>  	nlh->nlmsg_type = (NFNL_SUBSYS_CTNETLINK << 8) | type;
> diff --git a/src/expect/api.c b/src/expect/api.c
> index 39cd09249684c..b100c72ded50e 100644
> --- a/src/expect/api.c
> +++ b/src/expect/api.c
> @@ -513,6 +513,8 @@ int nfexp_build_expect(struct nfnl_subsys_handle *ssh,
>  	assert(req != NULL);
>  	assert(exp != NULL);
>  
> +	memset(req, 0, size);
> +
>  	return __build_expect(ssh, req, size, type, flags, exp);
>  }
>  
> @@ -546,7 +548,7 @@ __build_query_exp(struct nfnl_subsys_handle *ssh,
>  	assert(data != NULL);
>  	assert(req != NULL);
>  
> -	memset(req, 0, size);
> +	memset(buffer, 0, size);
>  
>  	switch(qt) {
>  	case NFCT_Q_CREATE:
> diff --git a/src/expect/build.c b/src/expect/build.c
> index 2e0f968f36dad..1807adce26f62 100644
> --- a/src/expect/build.c
> +++ b/src/expect/build.c
> @@ -29,8 +29,6 @@ int __build_expect(struct nfnl_subsys_handle *ssh,
>  	else
>  		return -1;
>  
> -	memset(req, 0, size);
> -
>  	buf = (char *)&req->nlh;
>  	nlh = mnl_nlmsg_put_header(buf);
>  	nlh->nlmsg_type = (NFNL_SUBSYS_CTNETLINK_EXP << 8) | type;
> -- 
> 2.34.1
> 
