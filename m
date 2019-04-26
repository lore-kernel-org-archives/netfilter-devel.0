Return-Path: <SRS0=OoQ/=S4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A58F6C43219
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 17:00:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B594206E0
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 17:00:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726376AbfDZRAd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 26 Apr 2019 13:00:33 -0400
Received: from mail.us.es ([193.147.175.20]:59562 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726083AbfDZRAd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Apr 2019 13:00:33 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DB3981031B0
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Apr 2019 19:00:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C8388DA712
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Apr 2019 19:00:30 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id BDE12DA709; Fri, 26 Apr 2019 19:00:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BF6F7DA709;
        Fri, 26 Apr 2019 19:00:28 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 26 Apr 2019 19:00:28 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 95B404265A31;
        Fri, 26 Apr 2019 19:00:28 +0200 (CEST)
Date:   Fri, 26 Apr 2019 19:00:28 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     fw@strlen.de, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf 4/4] netfilter: nf_flow_table: do not use deleted CT's
 flow offload
Message-ID: <20190426170028.ssosw4kg3pl4bicc@salvia>
References: <20190426165454.3943-1-ap420073@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190426165454.3943-1-ap420073@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Apr 27, 2019 at 01:54:54AM +0900, Taehee Yoo wrote:
> flow offload of CT can be deleted by the masquerade module. then,
> flow offload should be deleted too. but GC and data-path of flow offload
> do not check CT's status. hence they will be removed only by the timeout.
> 
> GC and data-path routine will check ct_general.use value.
> If that value is 1, it means that CT is removed from the list.
> So, GC will delete this and data-path do not use this.
>
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> ---
>  net/netfilter/nf_flow_table_core.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
> index 7aabfd4b1e50..334eb561ae48 100644
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
> +	if (unlikely(atomic_read(&e->ct->ct_general.use) == 1))

Could we use the IPS_DYING_BIT instead?
