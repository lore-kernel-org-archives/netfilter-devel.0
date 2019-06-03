Return-Path: <SRS0=Me6e=UC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0EA3C04AB5
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Jun 2019 16:59:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B4DCC25521
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Jun 2019 16:59:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbfFCQ7X (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 3 Jun 2019 12:59:23 -0400
Received: from mail.us.es ([193.147.175.20]:36258 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725856AbfFCQ7W (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 3 Jun 2019 12:59:22 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9E458DA738
        for <netfilter-devel@vger.kernel.org>; Mon,  3 Jun 2019 18:59:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8EA3CDA70B
        for <netfilter-devel@vger.kernel.org>; Mon,  3 Jun 2019 18:59:20 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8431ADA709; Mon,  3 Jun 2019 18:59:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 52073DA701;
        Mon,  3 Jun 2019 18:59:18 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 03 Jun 2019 18:59:18 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 3138B4265A2F;
        Mon,  3 Jun 2019 18:59:18 +0200 (CEST)
Date:   Mon, 3 Jun 2019 18:59:17 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v4 7/7] src: Support intra-transaction rule references
Message-ID: <20190603165917.pnub5grz3eaixdwt@salvia>
References: <20190528210323.14605-1-phil@nwl.cc>
 <20190528210323.14605-8-phil@nwl.cc>
 <20190531165625.nxtgnokrxzgol2nk@egarver.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190531165625.nxtgnokrxzgol2nk@egarver.localdomain>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, May 31, 2019 at 12:56:25PM -0400, Eric Garver wrote:
> [..]
> > diff --git a/src/rule.c b/src/rule.c
> > index b00161e0e4350..0048a8e064523 100644
> > --- a/src/rule.c
> > +++ b/src/rule.c
> > @@ -293,6 +293,23 @@ static int cache_add_set_cmd(struct eval_ctx *ectx)
> >  	return 0;
> >  }
> >
> > +static int cache_add_rule_cmd(struct eval_ctx *ectx)
> > +{
> > +	struct table *table;
> > +	struct chain *chain;
> > +
> > +	table = table_lookup(&ectx->cmd->rule->handle, &ectx->nft->cache);
> > +	if (!table)
> > +		return table_not_found(ectx);
> > +
> > +	chain = chain_lookup(table, &ectx->cmd->rule->handle);
> > +	if (!chain)
> > +		return chain_not_found(ectx);
> > +
> > +	rule_cache_update(ectx->cmd->op, chain, ectx->cmd->rule, NULL);
> > +	return 0;
> > +}
> > +
> >  static int cache_add_commands(struct nft_ctx *nft, struct list_head *msgs)
> >  {
> >  	struct eval_ctx ectx = {
> > @@ -314,6 +331,11 @@ static int cache_add_commands(struct nft_ctx *nft, struct list_head *msgs)
> >  				continue;
> >  			ret = cache_add_set_cmd(&ectx);
> >  			break;
> > +		case CMD_OBJ_RULE:
> > +			if (!cache_is_complete(&nft->cache, CMD_LIST))
> > +				continue;
> > +			ret = cache_add_rule_cmd(&ectx);
> > +			break;
> >  		default:
> >  			break;
> >  		}
> > @@ -727,6 +749,37 @@ struct rule *rule_lookup_by_index(const struct chain *chain, uint64_t index)
> >  	return NULL;
> >  }
> >
> > +void rule_cache_update(enum cmd_ops op, struct chain *chain,
> > +		       struct rule *rule, struct rule *ref)
> > +{
> > +	switch (op) {
> > +	case CMD_INSERT:
> > +		rule_get(rule);
> > +		if (ref)
> > +			list_add_tail(&rule->list, &ref->list);
> > +		else
> > +			list_add(&rule->list, &chain->rules);
> > +		break;
> > +	case CMD_ADD:
> > +		rule_get(rule);
> > +		if (ref)
> > +			list_add(&rule->list, &ref->list);
> > +		else
> > +			list_add_tail(&rule->list, &chain->rules);
> > +		break;
> > +	case CMD_REPLACE:
> > +		rule_get(rule);
> > +		list_add(&rule->list, &ref->list);
> > +		/* fall through */
> > +	case CMD_DELETE:
> > +		list_del(&ref->list);
> > +		rule_free(ref);
> > +		break;
> > +	default:
> > +		break;
> > +	}
> > +}
> 
> I'm seeing a NULL pointer dereferenced here. It occurs when we delete a rule
> and add a new rule using the "index" keyword in the same transaction/batch.

I think we need two new things here:

#1 We need a new initial step, before evalution, to calculate the cache
   completeness level. This means, we interate over the batch to see what
   kind of completeness is needed. Then, cache is fetched only once, at
   the beginning of the batch processing. Ensure that cache is
   consistent from that step.

#2 Update the cache incrementally: Add new objects from the evaluation
   phase. If RESTART is hit, then release the cache, and restart the
   evaluation. Probably we don't need to restart the evaluation, just
   a function to refresh the batch, ie. check if several objects are
   there.
