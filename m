Return-Path: <SRS0=Ro/3=TA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4D1DC43219
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Apr 2019 11:59:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BEABE21670
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Apr 2019 11:59:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727406AbfD3L7O (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Apr 2019 07:59:14 -0400
Received: from mail.us.es ([193.147.175.20]:55832 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727637AbfD3L7N (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Apr 2019 07:59:13 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5E660961F5
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Apr 2019 13:59:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4EECCDA70A
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Apr 2019 13:59:11 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 44424DA703; Tue, 30 Apr 2019 13:59:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3C904DA70D;
        Tue, 30 Apr 2019 13:59:09 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 30 Apr 2019 13:59:07 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (129.166.216.87.static.jazztel.es [87.216.166.129])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 042704265A5B;
        Tue, 30 Apr 2019 13:59:08 +0200 (CEST)
Date:   Tue, 30 Apr 2019 13:59:08 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     fw@strlen.de, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf v2 3/3] netfilter: nf_flow_table: do not use deleted
 CT's flow offload
Message-ID: <20190430115908.2heamxb6yenzh65s@salvia>
References: <20190429165614.1506-1-ap420073@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190429165614.1506-1-ap420073@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Apr 30, 2019 at 01:56:14AM +0900, Taehee Yoo wrote:
> flow offload of CT can be deleted by the masquerade module. then,
> flow offload should be deleted too. but GC and data-path of flow offload
> do not check CT's status. hence they will be removed only by the timeout.
> 
> GC and data-path routine will check ct->status.
> If IPS_DYING_BIT is set, GC will delete CT and data-path routine
> do not use it.
> 
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> ---
> 
> v1 -> v2 : use IPS_DYING_BIT instead of ct->ct_general.use refcnt.
> 
>  net/netfilter/nf_flow_table_core.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
> index 7aabfd4b1e50..50d04a718b41 100644
> --- a/net/netfilter/nf_flow_table_core.c
> +++ b/net/netfilter/nf_flow_table_core.c
> @@ -232,6 +232,7 @@ flow_offload_lookup(struct nf_flowtable *flow_table,
>  {
>  	struct flow_offload_tuple_rhash *tuplehash;
>  	struct flow_offload *flow;
> +	struct flow_offload_entry *e;
>  	int dir;
>  
>  	tuplehash = rhashtable_lookup(&flow_table->rhashtable, tuple,
> @@ -244,6 +245,10 @@ flow_offload_lookup(struct nf_flowtable *flow_table,
>  	if (flow->flags & (FLOW_OFFLOAD_DYING | FLOW_OFFLOAD_TEARDOWN))
>  		return NULL;
>  
> +	e = container_of(flow, struct flow_offload_entry, flow);
> +	if (unlikely(test_bit(IPS_DYING_BIT, &e->ct->status)))

Please, send a new version of this patch that uses:

        nf_ct_is_dying()

Thanks.

> +		return NULL;
> +
>  	return tuplehash;
>  }
>  EXPORT_SYMBOL_GPL(flow_offload_lookup);
> @@ -290,9 +295,12 @@ static inline bool nf_flow_has_expired(const struct flow_offload *flow)
>  static void nf_flow_offload_gc_step(struct flow_offload *flow, void *data)
>  {
>  	struct nf_flowtable *flow_table = data;
> +	struct flow_offload_entry *e;
>  
> +	e = container_of(flow, struct flow_offload_entry, flow);
>  	if (nf_flow_has_expired(flow) ||
> -	    (flow->flags & (FLOW_OFFLOAD_DYING | FLOW_OFFLOAD_TEARDOWN)))
> +	    (flow->flags & (FLOW_OFFLOAD_DYING | FLOW_OFFLOAD_TEARDOWN)) ||
> +	    (test_bit(IPS_DYING_BIT, &e->ct->status)))
>  		flow_offload_del(flow_table, flow);
>  }
>  
> -- 
> 2.17.1
> 
