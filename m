From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nft PATCH 4/4 v4] nft: complete reject support
Date: Fri, 26 Sep 2014 20:18:58 +0200
Message-ID: <F1CD73EA-82D6-4D9A-B749-8531AFD67F5B@trash.net>
References: <1411750255-7663-1-git-send-email-alvaroneay@gmail.com> <1411750255-7663-4-git-send-email-alvaroneay@gmail.com> <20140926180612.GB11463@salvia>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45871 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755300AbaIZSTG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Sep 2014 14:19:06 -0400
In-Reply-To: <20140926180612.GB11463@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 26. September 2014 20:06:12 MESZ, schrieb Pablo Neira Ayuso <pablo@netfilter.org>:
>First off, thanks for the effort. Several comments below.
>
>On Fri, Sep 26, 2014 at 06:50:55PM +0200, Alvaro Neira Ayuso wrote:
>> +/* The reason to reject this hasn't been specified */
>
>You can remove this comment above. You selected a function to
>encapsulate the code per reason that explains the thing by itself.
>
>> +static int stmt_evaluate_reject_no_reason(struct eval_ctx *ctx,
>> +					  struct stmt *stmt)
>> +{
>> +	switch (ctx->pctx.family) {
>> +	case NFPROTO_IPV4:
>> +	case NFPROTO_IPV6:
>> +		stmt->reject.type = NFT_REJECT_ICMP_UNREACH;
>> +		stmt->reject.family = ctx->pctx.family;
>> +		if (ctx->pctx.family == NFPROTO_IPV4)
>> +			stmt->reject.icmp_code = ICMP_PORT_UNREACH;
>> +		else
>> +			stmt->reject.icmp_code = ICMP6_DST_UNREACH_NOPORT;
>> +		break;
>> +	case NFPROTO_INET:
>> +	case NFPROTO_BRIDGE:
>> +		stmt->reject.type = NFT_REJECT_ICMPX_UNREACH;
>> +		stmt->reject.icmp_code = NFT_REJECT_ICMPX_PORT_UNREACH;
>> +		break;
>> +	}
>> +	return 0;
>> +}
>> +
>> +/* The reason to reject this has been specified with icmp reason */
>
>Same thing here.
>
>> +static int stmt_evaluate_reject_icmp_reason(struct eval_ctx *ctx,
>> +					    struct stmt *stmt)
>
>I'd suggest: stmt_evaluate_reject_with_icmp(...)
>
>> +{
>> +	struct error_record *erec;
>> +	struct expr *code;
>> +
>> +	erec = symbol_parse(stmt->reject.expr, &code);
>> +	if (erec != NULL) {
>> +		erec_queue(erec, ctx->msgs);
>> +		return -1;
>> +	}
>> +	stmt->reject.icmp_code = mpz_get_uint8(code->value);
>> +	return 0;
>> +}
>> +
>> +/* The reason to reject this has been specified with tcp reset */
>
>And here.
>
>> +static int stmt_evaluate_reject_tcp_reason(struct eval_ctx *ctx,
>> +					   struct stmt *stmt)
>
>I'd suggest: stmt_evaluate_reject_with_tcp(...)

I'd like to propose to rename active reject to reset. Its more precise and not specific to a protocol.

