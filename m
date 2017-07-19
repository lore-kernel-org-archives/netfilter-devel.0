From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH v3 2/3] monitor: Fix printing of range elements in
 named sets
Date: Wed, 19 Jul 2017 19:17:36 +0200
Message-ID: <20170719171736.GB18828@salvia>
References: <20170719130529.25398-1-phil@nwl.cc>
 <20170719130529.25398-3-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        Arturo Borrero Gonzalez <arturo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36172 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755408AbdGSRRp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Jul 2017 13:17:45 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E5EC5523C8
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Jul 2017 19:17:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D7341DA46D
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Jul 2017 19:17:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C8B69DA840
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Jul 2017 19:17:29 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170719130529.25398-3-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jul 19, 2017 at 03:05:28PM +0200, Phil Sutter wrote:
> diff --git a/include/rule.h b/include/rule.h
> index a25e99bdf4cfd..6acd5fa810ef5 100644
> --- a/include/rule.h
> +++ b/include/rule.h
> @@ -217,6 +217,7 @@ extern struct rule *rule_lookup(const struct chain *chain, uint64_t handle);
>   * @datalen:	mapping data len
>   * @objtype:	mapping object type
>   * @init:	initializer
> + * @rg_cache:	cached range element (left)

Just a side note. This field is very much exclusive to event monitor
printing, I would prefer this is cached somewhere else, away from the
structure, if possible.

Thanks.

>   * @policy:	set mechanism policy
>   * @desc:	set mechanism desc
>   */
> @@ -234,6 +235,7 @@ struct set {
>  	unsigned int		datalen;
>  	uint32_t		objtype;
>  	struct expr		*init;
> +	struct expr		*rg_cache;
>  	uint32_t		policy;
>  	struct {
>  		uint32_t	size;
