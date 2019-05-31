Return-Path: <SRS0=7QpW=T7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE93BC04AB6
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 May 2019 16:56:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 941A226C9B
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 May 2019 16:56:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbfEaQ4e (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 31 May 2019 12:56:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38254 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726518AbfEaQ4e (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 31 May 2019 12:56:34 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 409E2300414E;
        Fri, 31 May 2019 16:56:32 +0000 (UTC)
Received: from egarver.localdomain (ovpn-122-157.rdu2.redhat.com [10.10.122.157])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C70DE1759D;
        Fri, 31 May 2019 16:56:27 +0000 (UTC)
Date:   Fri, 31 May 2019 12:56:25 -0400
From:   Eric Garver <eric@garver.life>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v4 7/7] src: Support intra-transaction rule references
Message-ID: <20190531165625.nxtgnokrxzgol2nk@egarver.localdomain>
Mail-Followup-To: Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20190528210323.14605-1-phil@nwl.cc>
 <20190528210323.14605-8-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190528210323.14605-8-phil@nwl.cc>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Fri, 31 May 2019 16:56:32 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Phil,

This series is close. I see one more issue below.

On Tue, May 28, 2019 at 11:03:23PM +0200, Phil Sutter wrote:
> A rule may be added before or after another one using index keyword. To
> support for the other rule being added within the same batch, one has to
> make use of NFTNL_RULE_ID and NFTNL_RULE_POSITION_ID attributes. This
> patch does just that among a few more crucial things:
>
> * Fetch full kernel ruleset upon encountering a rule which references
>   another one. Any earlier rule add/insert commands are then restored by
>   cache_add_commands().
>
> * Avoid cache updates for rules not referencing another one, but make
>   sure cache is not treated as complete afterwards so a later rule with
>   reference will cause cache update and repopulation from command list.
>
> * Reduce rule_translate_index() to its core code which is the actual
>   linking of rules and consequently rename the function. The removed
>   bits are pulled into the calling rule_evaluate() to reduce code
>   duplication in between cache inserts with and without rule reference.
>
> * Pass the current command op to rule_evaluate() as indicator whether to
>   insert before or after a referenced rule or at beginning or end of
>   chain in cache. Exploit this from chain_evaluate() to avoid adding
>   the chain's rules a second time.
>
> Light casts shadow though: It has been possible to reference another
> rule of the same transaction via its *guessed* handle - this patch
> removes that possibility.
>
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
[..]
> diff --git a/src/rule.c b/src/rule.c
> index b00161e0e4350..0048a8e064523 100644
> --- a/src/rule.c
> +++ b/src/rule.c
> @@ -293,6 +293,23 @@ static int cache_add_set_cmd(struct eval_ctx *ectx)
>  	return 0;
>  }
>
> +static int cache_add_rule_cmd(struct eval_ctx *ectx)
> +{
> +	struct table *table;
> +	struct chain *chain;
> +
> +	table = table_lookup(&ectx->cmd->rule->handle, &ectx->nft->cache);
> +	if (!table)
> +		return table_not_found(ectx);
> +
> +	chain = chain_lookup(table, &ectx->cmd->rule->handle);
> +	if (!chain)
> +		return chain_not_found(ectx);
> +
> +	rule_cache_update(ectx->cmd->op, chain, ectx->cmd->rule, NULL);
> +	return 0;
> +}
> +
>  static int cache_add_commands(struct nft_ctx *nft, struct list_head *msgs)
>  {
>  	struct eval_ctx ectx = {
> @@ -314,6 +331,11 @@ static int cache_add_commands(struct nft_ctx *nft, struct list_head *msgs)
>  				continue;
>  			ret = cache_add_set_cmd(&ectx);
>  			break;
> +		case CMD_OBJ_RULE:
> +			if (!cache_is_complete(&nft->cache, CMD_LIST))
> +				continue;
> +			ret = cache_add_rule_cmd(&ectx);
> +			break;
>  		default:
>  			break;
>  		}
> @@ -727,6 +749,37 @@ struct rule *rule_lookup_by_index(const struct chain *chain, uint64_t index)
>  	return NULL;
>  }
>
> +void rule_cache_update(enum cmd_ops op, struct chain *chain,
> +		       struct rule *rule, struct rule *ref)
> +{
> +	switch (op) {
> +	case CMD_INSERT:
> +		rule_get(rule);
> +		if (ref)
> +			list_add_tail(&rule->list, &ref->list);
> +		else
> +			list_add(&rule->list, &chain->rules);
> +		break;
> +	case CMD_ADD:
> +		rule_get(rule);
> +		if (ref)
> +			list_add(&rule->list, &ref->list);
> +		else
> +			list_add_tail(&rule->list, &chain->rules);
> +		break;
> +	case CMD_REPLACE:
> +		rule_get(rule);
> +		list_add(&rule->list, &ref->list);
> +		/* fall through */
> +	case CMD_DELETE:
> +		list_del(&ref->list);
> +		rule_free(ref);
> +		break;
> +	default:
> +		break;
> +	}
> +}

I'm seeing a NULL pointer dereferenced here. It occurs when we delete a rule
and add a new rule using the "index" keyword in the same transaction/batch.

FWIW, I've also got Pablo's recv buffer size patches applied.

# nft --handle list table inet foobar
table inet foobar { # handle 4004
        chain foo_chain { # handle 1
                accept # handle 2
                log # handle 3
        }
}

# nft -f -
delete rule inet foobar foo_chain handle 3
add rule inet foobar foo_chain index 0 drop
Segmentation fault (core dumped)

# nft --handle list table inet foobar
table inet foobar { # handle 4004
        chain foo_chain { # handle 1
                accept # handle 2
                log # handle 3
        }
}


(gdb) bt
#0  0x00007f76d3d6b9b2 in rule_cache_update (op=CMD_DELETE, chain=0x1865d70, rule=0x0, ref=0x0) at rule.c:755
#1  0x00007f76d3d6d16b in cache_add_rule_cmd (ectx=0x7fff51d96c00) at rule.c:309
#2  cache_add_commands (msgs=0x7fff51dab4e0, nft=0x17fba20) at rule.c:337
#3  cache_update (nft=0x17fba20, cmd=cmd@entry=CMD_LIST, msgs=0x7fff51dab4e0) at rule.c:381
#4  0x00007f76d3d7a261 in rule_evaluate (ctx=0x17fc160, rule=0x180df30, op=CMD_ADD) at evaluate.c:3249
#5  0x00007f76d3da423a in nft_parse (nft=nft@entry=0x17fba20, scanner=0x1824060, state=0x17fbb80) at parser_bison.y:799
#6  0x00007f76d3d91324 in nft_parse_bison_filename (cmds=0x17fbae0, msgs=0x7fff51dab4e0, filename=0x7f76d3db8385 "/dev/stdin", nft=0x17fba20) at libnftables.c:380
#7  nft_run_cmd_from_filename (nft=0x17fba20, filename=0x7f76d3db8385 "/dev/stdin", filename@entry=0x7fff51dac67d "-") at libnftables.c:446
#8  0x0000000000401698 in main (argc=3, argv=0x7fff51dab658) at main.c:310

(gdb) frame 1
#1  0x00007f76d3d6d16b in cache_add_rule_cmd (ectx=0x7fff51d96c00) at rule.c:309
309             rule_cache_update(ectx->cmd->op, chain, ectx->cmd->rule, NULL);

(gdb) print *ectx
$1 = {nft = 0x17fba20, msgs = 0x7fff51dab4e0, cmd = 0x1801730, table = 0x0, rule = 0x0, set = 0x0, stmt = 0x0, ectx = {dtype = 0x0, byteorder = BYTEORDER_INVALID, len = 0, maxval = 0}, pctx = {debug_mask = 0, family = 0, protocol = {{location = {indesc = 0x0, {{
              token_offset = 0, line_offset = 0, first_line = 0, last_line = 0, first_column = 0, last_column = 0}, {nle = 0x0}}}, desc = 0x0, offset = 0}, {location = {indesc = 0x0, {{token_offset = 0, line_offset = 0, first_line = 0, last_line = 0, first_column = 0,
              last_column = 0}, {nle = 0x0}}}, desc = 0x0, offset = 0}, {location = {indesc = 0x0, {{token_offset = 0, line_offset = 0, first_line = 0, last_line = 0, first_column = 0, last_column = 0}, {nle = 0x0}}}, desc = 0x0, offset = 0}, {location = {indesc = 0x0, {{
              token_offset = 0, line_offset = 0, first_line = 0, last_line = 0, first_column = 0, last_column = 0}, {nle = 0x0}}}, desc = 0x0, offset = 0}}}}

(gdb) print *ectx->cmd
$2 = {list = {next = 0x17fbae0, prev = 0x17fbae0}, location = {indesc = 0x17fbb88, {{token_offset = 6, line_offset = 0, first_line = 1, last_line = 1, first_column = 1, last_column = 43}, {nle = 0x6}}}, op = CMD_DELETE, obj = CMD_OBJ_RULE, handle = {family = 1, table = {
      location = {indesc = 0x17fbb88, {{token_offset = 23, line_offset = 0, first_line = 1, last_line = 1, first_column = 18, last_column = 23}, {nle = 0x17}}}, name = 0x18014c0 "foobar"}, chain = {location = {indesc = 0x17fbb88, {{token_offset = 33, line_offset = 0,
            first_line = 1, last_line = 1, first_column = 25, last_column = 33}, {nle = 0x21}}}, name = 0x180a740 "foo_chain"}, set = {location = {indesc = 0x0, {{token_offset = 0, line_offset = 0, first_line = 0, last_line = 0, first_column = 0, last_column = 0}, {
            nle = 0x0}}}, name = 0x0}, obj = {location = {indesc = 0x0, {{token_offset = 0, line_offset = 0, first_line = 0, last_line = 0, first_column = 0, last_column = 0}, {nle = 0x0}}}, name = 0x0}, flowtable = 0x0, handle = {location = {indesc = 0x17fbb88, {{
            token_offset = 40, line_offset = 0, first_line = 1, last_line = 1, first_column = 35, last_column = 42}, {nle = 0x28}}}, id = 3}, position = {location = {indesc = 0x0, {{token_offset = 0, line_offset = 0, first_line = 0, last_line = 0, first_column = 0,
            last_column = 0}, {nle = 0x0}}}, id = 0}, index = {location = {indesc = 0x0, {{token_offset = 0, line_offset = 0, first_line = 0, last_line = 0, first_column = 0, last_column = 0}, {nle = 0x0}}}, id = 0}, set_id = 0, rule_id = 0, position_id = 0}, seqnum = 0,
  {data = 0x0, expr = 0x0, set = 0x0, rule = 0x0, chain = 0x0, table = 0x0, flowtable = 0x0, monitor = 0x0, markup = 0x0, object = 0x0}, arg = 0x0}

(gdb) print ectx->cmd->rule
$3 = (struct rule *) 0x0
