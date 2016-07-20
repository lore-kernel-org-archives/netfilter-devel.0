From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: nf_tables: allow to filter out rules
 by table and chain
Date: Wed, 20 Jul 2016 18:13:13 +0200
Message-ID: <20160720161313.GA1316@salvia>
References: <1468923645-11722-1-git-send-email-pablo@netfilter.org>
 <578F833D.202@toulouse.viveris.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: jalvarez <jalvarez@toulouse.viveris.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47207 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752340AbcGTQN2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Jul 2016 12:13:28 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 28176392E0B
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Jul 2016 18:13:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 163146DC5D
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Jul 2016 18:13:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D80CFFF12C
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Jul 2016 18:13:22 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <578F833D.202@toulouse.viveris.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jul 20, 2016 at 03:57:17PM +0200, jalvarez wrote:
> @@ -1877,7 +1883,15 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
>              continue;
> 
>          list_for_each_entry_rcu(table, &afi->tables, list) {
> +            if (ctx->table[0] &&

We could just check for this instead:

               if (ctx && ctx->table[0] &&
                   strcmp(ctx->table, table->name) != 0)
                        continue;

Will send a v2 including this.
