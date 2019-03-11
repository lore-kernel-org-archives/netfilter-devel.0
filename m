Return-Path: <SRS0=8PdD=RO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA668C43381
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Mar 2019 13:13:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 819A320657
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Mar 2019 13:13:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbfCKNNG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 11 Mar 2019 09:13:06 -0400
Received: from mail.us.es ([193.147.175.20]:54856 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726592AbfCKNNG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 Mar 2019 09:13:06 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3B63EC5103
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Mar 2019 14:13:04 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 20DECDA846
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Mar 2019 14:13:04 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 197EEDA876; Mon, 11 Mar 2019 14:13:04 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7F9FADA87A;
        Mon, 11 Mar 2019 14:13:01 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 11 Mar 2019 14:13:01 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 408594265A4C;
        Mon, 11 Mar 2019 14:13:01 +0100 (CET)
Date:   Mon, 11 Mar 2019 14:13:00 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_tables: return immediately on empty
 commit
Message-ID: <20190311131300.45t6rdmz25ff3kid@salvia>
References: <20190307222011.25091-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190307222011.25091-1-fw@strlen.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Florian,

On Thu, Mar 07, 2019 at 11:20:11PM +0100, Florian Westphal wrote:
> When running 'nft flush ruleset' while no rules exist, we will increment
> the generation counter and announce a new genid to userspace, yet
> nothing had changed in the first place.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/netfilter/nf_tables_api.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index dcd9cb68d826..1904e081853c 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -6536,6 +6536,11 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
>  	struct nft_chain *chain;
>  	struct nft_table *table;
>  
> +	if (list_empty(&net->nft.commit_list)) {
> +		mutex_unlock(&net->nft.commit_mutex);
> +		return 0;
> +	}

This looks good to catch this case.

I think we should probably address these too:

term1# nft add table x
term1# nft add table x

term2# nft monitor
add table ip x
# new generation 1587 by process 14422 (nft)
# new generation 1588 by process 14423 (nft)

So re-insertion of existing objects should not trigger unnecessary
generation counter bump. We can probably count the number of events
that have been sent from the commit path before we bump it.
