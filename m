Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DBF52E336F
	for <netfilter-devel@vger.kernel.org>; Tue, 30 Dec 2025 11:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767093111; cv=none; b=fCQUhkIZESgH5qp342ZJVwKwdezCvdpGMpa4pQ57HTr9OGXS3KmNh4xNGXqmCF0SeI/x/zSiWUO/M4dlJGlLT1Ox8GIWzKbzKNgcu+bEOK5Ay1F/mjxID/bInYVjilotvkBQavo2NPgcw1ReQDrOQ9rq8qv+LiYc8X52hQl8/l4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767093111; c=relaxed/simple;
	bh=Hh8iFccPakNUQwU2fWmmFVD0glsN5+caiFrAmMLpEoA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bIMvI9e09+bVH3+ZeesoBA8tjhG3yG3iPF2FJcNxGsj/bXiBv9hLiUUNnWJp423LLpKAp5eALoollF+WGtrzSCg6u8fTNWnAwVyf/B35z8qiRT+F1xY5AXkgq/VqNsZXCxJkEPIBm8af0mH5DUeZrqVsiAQ61ZTtMaslqxIjfKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=QfrCKp1F; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=/tpfy4Uf; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=QfrCKp1F; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=/tpfy4Uf; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="QfrCKp1F";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="/tpfy4Uf";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="QfrCKp1F";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="/tpfy4Uf"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2D1585BCD9;
	Tue, 30 Dec 2025 11:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1767093105; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ES1HVEXhcDBDIfILkrU8OfwSXC/x3QLxbapufq4DV4o=;
	b=QfrCKp1FL7NLWwRK8ARaCcgkrZsjGAYIH0DJhjWMfANwHRKSpDjSX4d4Wwit2Neyyy5ed1
	friyaApBUe0ZajXw2zTaUoXZSLSfz3WkYwICuohWfDhALdPUGH5QHKZT7QfL7U7OnBTNO3
	sjCWSipfBxYPdgmhvSGseve5gvSqk8U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1767093105;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ES1HVEXhcDBDIfILkrU8OfwSXC/x3QLxbapufq4DV4o=;
	b=/tpfy4UfDrFXANOdZ6KrYsKjM/x/Q4qGEzfrNHc5hSfof8D/BeTI90eQx3XUGTrqKt/dK0
	2Dqo4pmheFmzDMBw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1767093105; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ES1HVEXhcDBDIfILkrU8OfwSXC/x3QLxbapufq4DV4o=;
	b=QfrCKp1FL7NLWwRK8ARaCcgkrZsjGAYIH0DJhjWMfANwHRKSpDjSX4d4Wwit2Neyyy5ed1
	friyaApBUe0ZajXw2zTaUoXZSLSfz3WkYwICuohWfDhALdPUGH5QHKZT7QfL7U7OnBTNO3
	sjCWSipfBxYPdgmhvSGseve5gvSqk8U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1767093105;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ES1HVEXhcDBDIfILkrU8OfwSXC/x3QLxbapufq4DV4o=;
	b=/tpfy4UfDrFXANOdZ6KrYsKjM/x/Q4qGEzfrNHc5hSfof8D/BeTI90eQx3XUGTrqKt/dK0
	2Dqo4pmheFmzDMBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B27833EA63;
	Tue, 30 Dec 2025 11:11:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GrI2KHCzU2kEegAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 30 Dec 2025 11:11:44 +0000
Message-ID: <30e89e05-94ba-4f1e-894b-3ffe86182925@suse.de>
Date: Tue, 30 Dec 2025 12:11:29 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/7 nft v3] src: add tunnel statement and expression
 support
To: Yi Chen <yiche@redhat.com>, pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de, Phil Sutter <phil@nwl.cc>,
 Eric Garver <egarver@redhat.com>
References: <20250821091302.9032-1-fmancera@suse.de>
 <20250821091302.9032-3-fmancera@suse.de>
 <CAJsUoE2uoZJH2VA6E+J+SK=G1W06JE2+0v-NmgGyGWBNRKFgng@mail.gmail.com>
Content-Language: en-US
From: Fernando Fernandez Mancera <fmancera@suse.de>
In-Reply-To: <CAJsUoE2uoZJH2VA6E+J+SK=G1W06JE2+0v-NmgGyGWBNRKFgng@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 
X-Spamd-Result: default: False [-4.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-0.976];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:mid]

On 12/29/25 2:51 PM, Yi Chen wrote:
> Hello Pablo and Fernando,
> I have started working on a test script (attached) to exercise this
> feature, using a geneve tunnel with an egress hook.
> Please let me know if egress is the correct hook to use in this context.
> 
> However, the behavior is not what I expected: the tunnel template does
> not appear to be attached, and even ARP packets are not being
> encapsulated.
> I would appreciate any guidance on what I might be missing, or
> suggestions on how this test could be improved.
> Thank you for your time and help.
> 

Hi Yi Chen,

I am working on a patch adding proper documentation to nft manpage that 
will clarify all these questions. I plan to send it out this week. I 
will CC you in the patch.

Thanks,
Fernando.

> 
> On Thu, Aug 21, 2025 at 5:18 PM Fernando Fernandez Mancera
> <fmancera@suse.de> wrote:
>>
>> From: Pablo Neira Ayuso <pablo@netfilter.org>
>>
>> This patch allows you to attach tunnel metadata through the tunnel
>> statement.
>>
>> The following example shows how to redirect traffic to the erspan0
>> tunnel device which will take the tunnel configuration that is
>> specified by the ruleset.
>>
>>       table netdev x {
>>              tunnel y {
>>                      id 10
>>                      ip saddr 192.168.2.10
>>                      ip daddr 192.168.2.11
>>                      sport 10
>>                      dport 20
>>                      ttl 10
>>                      erspan {
>>                              version 1
>>                              index 2
>>                      }
>>              }
>>
>>              chain x {
>>                      type filter hook ingress device veth0 priority 0;
>>
>>                      ip daddr 10.141.10.123 tunnel name y fwd to erspan0
>>              }
>>       }
>>
>> This patch also allows to match on tunnel metadata via tunnel expression.
>>
>> Joint work with Fernando.
>>
>> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
>> Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
>> ---
>> v3: rebased
>> ---
>>   Makefile.am               |  2 +
>>   include/expression.h      |  6 +++
>>   include/tunnel.h          | 33 ++++++++++++++++
>>   src/evaluate.c            |  8 ++++
>>   src/expression.c          |  1 +
>>   src/netlink_delinearize.c | 17 ++++++++
>>   src/netlink_linearize.c   | 14 +++++++
>>   src/parser_bison.y        | 33 +++++++++++++---
>>   src/scanner.l             |  3 +-
>>   src/statement.c           |  1 +
>>   src/tunnel.c              | 81 +++++++++++++++++++++++++++++++++++++++
>>   11 files changed, 193 insertions(+), 6 deletions(-)
>>   create mode 100644 include/tunnel.h
>>   create mode 100644 src/tunnel.c
>>
>> diff --git a/Makefile.am b/Makefile.am
>> index 4909abfe..152a80d6 100644
>> --- a/Makefile.am
>> +++ b/Makefile.am
>> @@ -100,6 +100,7 @@ noinst_HEADERS = \
>>          include/statement.h \
>>          include/tcpopt.h \
>>          include/trace.h \
>> +       include/tunnel.h \
>>          include/utils.h \
>>          include/xfrm.h \
>>          include/xt.h \
>> @@ -243,6 +244,7 @@ src_libnftables_la_SOURCES = \
>>          src/socket.c \
>>          src/statement.c \
>>          src/tcpopt.c \
>> +       src/tunnel.c \
>>          src/utils.c \
>>          src/xfrm.c \
>>          $(NULL)
>> diff --git a/include/expression.h b/include/expression.h
>> index e483b7e7..7185ee66 100644
>> --- a/include/expression.h
>> +++ b/include/expression.h
>> @@ -77,6 +77,7 @@ enum expr_types {
>>          EXPR_NUMGEN,
>>          EXPR_HASH,
>>          EXPR_RT,
>> +       EXPR_TUNNEL,
>>          EXPR_FIB,
>>          EXPR_XFRM,
>>          EXPR_SET_ELEM_CATCHALL,
>> @@ -229,6 +230,7 @@ enum expr_flags {
>>   #include <hash.h>
>>   #include <ct.h>
>>   #include <socket.h>
>> +#include <tunnel.h>
>>   #include <osf.h>
>>   #include <xfrm.h>
>>
>> @@ -368,6 +370,10 @@ struct expr {
>>                          enum nft_socket_keys    key;
>>                          uint32_t                level;
>>                  } socket;
>> +               struct {
>> +                       /* EXPR_TUNNEL */
>> +                       enum nft_tunnel_keys    key;
>> +               } tunnel;
>>                  struct {
>>                          /* EXPR_RT */
>>                          enum nft_rt_keys        key;
>> diff --git a/include/tunnel.h b/include/tunnel.h
>> new file mode 100644
>> index 00000000..9e6bd97a
>> --- /dev/null
>> +++ b/include/tunnel.h
>> @@ -0,0 +1,33 @@
>> +#ifndef NFTABLES_TUNNEL_H
>> +#define NFTABLES_TUNNEL_H
>> +
>> +/**
>> + * struct tunnel_template - template for tunnel expressions
>> + *
>> + * @token:     parser token for the expression
>> + * @dtype:     data type of the expression
>> + * @len:       length of the expression
>> + * @byteorder: byteorder
>> + */
>> +struct tunnel_template {
>> +       const char              *token;
>> +       const struct datatype   *dtype;
>> +       enum byteorder          byteorder;
>> +       unsigned int            len;
>> +};
>> +
>> +extern const struct tunnel_template tunnel_templates[];
>> +
>> +#define TUNNEL_TEMPLATE(__token, __dtype, __len, __byteorder) {        \
>> +       .token          = (__token),                            \
>> +       .dtype          = (__dtype),                            \
>> +       .len            = (__len),                              \
>> +       .byteorder      = (__byteorder),                        \
>> +}
>> +
>> +extern struct expr *tunnel_expr_alloc(const struct location *loc,
>> +                                     enum nft_tunnel_keys key);
>> +
>> +extern const struct expr_ops tunnel_expr_ops;
>> +
>> +#endif /* NFTABLES_TUNNEL_H */
>> diff --git a/src/evaluate.c b/src/evaluate.c
>> index da8794dd..6bf14b0c 100644
>> --- a/src/evaluate.c
>> +++ b/src/evaluate.c
>> @@ -1737,6 +1737,7 @@ static int expr_evaluate_concat(struct eval_ctx *ctx, struct expr **expr)
>>                  case EXPR_SOCKET:
>>                  case EXPR_OSF:
>>                  case EXPR_XFRM:
>> +               case EXPR_TUNNEL:
>>                          break;
>>                  case EXPR_RANGE:
>>                  case EXPR_PREFIX:
>> @@ -3053,6 +3054,11 @@ static int expr_evaluate_osf(struct eval_ctx *ctx, struct expr **expr)
>>          return expr_evaluate_primary(ctx, expr);
>>   }
>>
>> +static int expr_evaluate_tunnel(struct eval_ctx *ctx, struct expr **exprp)
>> +{
>> +       return expr_evaluate_primary(ctx, exprp);
>> +}
>> +
>>   static int expr_evaluate_variable(struct eval_ctx *ctx, struct expr **exprp)
>>   {
>>          struct symbol *sym = (*exprp)->sym;
>> @@ -3170,6 +3176,8 @@ static int expr_evaluate(struct eval_ctx *ctx, struct expr **expr)
>>                  return expr_evaluate_meta(ctx, expr);
>>          case EXPR_SOCKET:
>>                  return expr_evaluate_socket(ctx, expr);
>> +       case EXPR_TUNNEL:
>> +               return expr_evaluate_tunnel(ctx, expr);
>>          case EXPR_OSF:
>>                  return expr_evaluate_osf(ctx, expr);
>>          case EXPR_FIB:
>> diff --git a/src/expression.c b/src/expression.c
>> index 8cb63979..e3c27a13 100644
>> --- a/src/expression.c
>> +++ b/src/expression.c
>> @@ -1762,6 +1762,7 @@ static const struct expr_ops *__expr_ops_by_type(enum expr_types etype)
>>          case EXPR_NUMGEN: return &numgen_expr_ops;
>>          case EXPR_HASH: return &hash_expr_ops;
>>          case EXPR_RT: return &rt_expr_ops;
>> +       case EXPR_TUNNEL: return &tunnel_expr_ops;
>>          case EXPR_FIB: return &fib_expr_ops;
>>          case EXPR_XFRM: return &xfrm_expr_ops;
>>          case EXPR_SET_ELEM_CATCHALL: return &set_elem_catchall_expr_ops;
>> diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
>> index b97962a3..5627826d 100644
>> --- a/src/netlink_delinearize.c
>> +++ b/src/netlink_delinearize.c
>> @@ -940,6 +940,21 @@ static void netlink_parse_osf(struct netlink_parse_ctx *ctx,
>>          netlink_set_register(ctx, dreg, expr);
>>   }
>>
>> +static void netlink_parse_tunnel(struct netlink_parse_ctx *ctx,
>> +                                const struct location *loc,
>> +                                const struct nftnl_expr *nle)
>> +{
>> +       enum nft_registers dreg;
>> +       struct expr * expr;
>> +       uint32_t key;
>> +
>> +       key = nftnl_expr_get_u32(nle, NFTNL_EXPR_TUNNEL_KEY);
>> +       expr = tunnel_expr_alloc(loc, key);
>> +
>> +       dreg = netlink_parse_register(nle, NFTNL_EXPR_TUNNEL_DREG);
>> +       netlink_set_register(ctx, dreg, expr);
>> +}
>> +
>>   static void netlink_parse_meta_stmt(struct netlink_parse_ctx *ctx,
>>                                      const struct location *loc,
>>                                      const struct nftnl_expr *nle)
>> @@ -1922,6 +1937,7 @@ static const struct expr_handler netlink_parsers[] = {
>>          { .name = "exthdr",     .parse = netlink_parse_exthdr },
>>          { .name = "meta",       .parse = netlink_parse_meta },
>>          { .name = "socket",     .parse = netlink_parse_socket },
>> +       { .name = "tunnel",     .parse = netlink_parse_tunnel },
>>          { .name = "osf",        .parse = netlink_parse_osf },
>>          { .name = "rt",         .parse = netlink_parse_rt },
>>          { .name = "ct",         .parse = netlink_parse_ct },
>> @@ -3023,6 +3039,7 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
>>          case EXPR_NUMGEN:
>>          case EXPR_FIB:
>>          case EXPR_SOCKET:
>> +       case EXPR_TUNNEL:
>>          case EXPR_OSF:
>>          case EXPR_XFRM:
>>                  break;
>> diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
>> index 8ac33d34..d01cadf8 100644
>> --- a/src/netlink_linearize.c
>> +++ b/src/netlink_linearize.c
>> @@ -334,6 +334,18 @@ static void netlink_gen_osf(struct netlink_linearize_ctx *ctx,
>>          nft_rule_add_expr(ctx, nle, &expr->location);
>>   }
>>
>> +static void netlink_gen_tunnel(struct netlink_linearize_ctx *ctx,
>> +                              const struct expr *expr,
>> +                              enum nft_registers dreg)
>> +{
>> +       struct nftnl_expr *nle;
>> +
>> +       nle = alloc_nft_expr("tunnel");
>> +       netlink_put_register(nle, NFTNL_EXPR_TUNNEL_DREG, dreg);
>> +       nftnl_expr_set_u32(nle, NFTNL_EXPR_TUNNEL_KEY, expr->tunnel.key);
>> +       nftnl_rule_add_expr(ctx->nlr, nle);
>> +}
>> +
>>   static void netlink_gen_numgen(struct netlink_linearize_ctx *ctx,
>>                              const struct expr *expr,
>>                              enum nft_registers dreg)
>> @@ -932,6 +944,8 @@ static void netlink_gen_expr(struct netlink_linearize_ctx *ctx,
>>                  return netlink_gen_fib(ctx, expr, dreg);
>>          case EXPR_SOCKET:
>>                  return netlink_gen_socket(ctx, expr, dreg);
>> +       case EXPR_TUNNEL:
>> +               return netlink_gen_tunnel(ctx, expr, dreg);
>>          case EXPR_OSF:
>>                  return netlink_gen_osf(ctx, expr, dreg);
>>          case EXPR_XFRM:
>> diff --git a/src/parser_bison.y b/src/parser_bison.y
>> index 557977e2..08d75dbb 100644
>> --- a/src/parser_bison.y
>> +++ b/src/parser_bison.y
>> @@ -321,6 +321,8 @@ int nft_lex(void *, void *, void *);
>>   %token RULESET                 "ruleset"
>>   %token TRACE                   "trace"
>>
>> +%token PATH                    "path"
>> +
>>   %token INET                    "inet"
>>   %token NETDEV                  "netdev"
>>
>> @@ -779,8 +781,8 @@ int nft_lex(void *, void *, void *);
>>   %destructor { stmt_free($$); } counter_stmt counter_stmt_alloc stateful_stmt last_stmt
>>   %type <stmt>                   limit_stmt_alloc quota_stmt_alloc last_stmt_alloc ct_limit_stmt_alloc
>>   %destructor { stmt_free($$); } limit_stmt_alloc quota_stmt_alloc last_stmt_alloc ct_limit_stmt_alloc
>> -%type <stmt>                   objref_stmt objref_stmt_counter objref_stmt_limit objref_stmt_quota objref_stmt_ct objref_stmt_synproxy
>> -%destructor { stmt_free($$); } objref_stmt objref_stmt_counter objref_stmt_limit objref_stmt_quota objref_stmt_ct objref_stmt_synproxy
>> +%type <stmt>                   objref_stmt objref_stmt_counter objref_stmt_limit objref_stmt_quota objref_stmt_ct objref_stmt_synproxy objref_stmt_tunnel
>> +%destructor { stmt_free($$); } objref_stmt objref_stmt_counter objref_stmt_limit objref_stmt_quota objref_stmt_ct objref_stmt_synproxy objref_stmt_tunnel
>>
>>   %type <stmt>                   payload_stmt
>>   %destructor { stmt_free($$); } payload_stmt
>> @@ -940,9 +942,9 @@ int nft_lex(void *, void *, void *);
>>   %destructor { expr_free($$); } mh_hdr_expr
>>   %type <val>                    mh_hdr_field
>>
>> -%type <expr>                   meta_expr
>> -%destructor { expr_free($$); } meta_expr
>> -%type <val>                    meta_key        meta_key_qualified      meta_key_unqualified    numgen_type
>> +%type <expr>                   meta_expr       tunnel_expr
>> +%destructor { expr_free($$); } meta_expr       tunnel_expr
>> +%type <val>                    meta_key        meta_key_qualified      meta_key_unqualified    numgen_type     tunnel_key
>>
>>   %type <expr>                   socket_expr
>>   %destructor { expr_free($$); } socket_expr
>> @@ -3206,6 +3208,14 @@ objref_stmt_synproxy     :       SYNPROXY        NAME    stmt_expr close_scope_synproxy
>>                          }
>>                          ;
>>
>> +objref_stmt_tunnel     :       TUNNEL  NAME    stmt_expr       close_scope_tunnel
>> +                       {
>> +                               $$ = objref_stmt_alloc(&@$);
>> +                               $$->objref.type = NFT_OBJECT_TUNNEL;
>> +                               $$->objref.expr = $3;
>> +                       }
>> +                       ;
>> +
>>   objref_stmt_ct         :       CT      TIMEOUT         SET     stmt_expr       close_scope_ct
>>                          {
>>                                  $$ = objref_stmt_alloc(&@$);
>> @@ -3226,6 +3236,7 @@ objref_stmt               :       objref_stmt_counter
>>                          |       objref_stmt_quota
>>                          |       objref_stmt_synproxy
>>                          |       objref_stmt_ct
>> +                       |       objref_stmt_tunnel
>>                          ;
>>
>>   stateful_stmt          :       counter_stmt    close_scope_counter
>> @@ -3904,6 +3915,7 @@ primary_stmt_expr :       symbol_expr                     { $$ = $1; }
>>                          |       boolean_expr                    { $$ = $1; }
>>                          |       meta_expr                       { $$ = $1; }
>>                          |       rt_expr                         { $$ = $1; }
>> +                       |       tunnel_expr                     { $$ = $1; }
>>                          |       ct_expr                         { $$ = $1; }
>>                          |       numgen_expr                     { $$ = $1; }
>>                          |       hash_expr                       { $$ = $1; }
>> @@ -4381,6 +4393,7 @@ selector_expr             :       payload_expr                    { $$ = $1; }
>>                          |       exthdr_expr                     { $$ = $1; }
>>                          |       exthdr_exists_expr              { $$ = $1; }
>>                          |       meta_expr                       { $$ = $1; }
>> +                       |       tunnel_expr                     { $$ = $1; }
>>                          |       socket_expr                     { $$ = $1; }
>>                          |       rt_expr                         { $$ = $1; }
>>                          |       ct_expr                         { $$ = $1; }
>> @@ -5493,6 +5506,16 @@ socket_key               :       TRANSPARENT     { $$ = NFT_SOCKET_TRANSPARENT; }
>>                          |       WILDCARD        { $$ = NFT_SOCKET_WILDCARD; }
>>                          ;
>>
>> +tunnel_key             :       PATH            { $$ = NFT_TUNNEL_PATH; }
>> +                       |       ID              { $$ = NFT_TUNNEL_ID; }
>> +                       ;
>> +
>> +tunnel_expr            :       TUNNEL  tunnel_key
>> +                       {
>> +                               $$ = tunnel_expr_alloc(&@$, $2);
>> +                       }
>> +                       ;
>> +
>>   offset_opt             :       /* empty */     { $$ = 0; }
>>                          |       OFFSET  NUM     { $$ = $2; }
>>                          ;
>> diff --git a/src/scanner.l b/src/scanner.l
>> index def0ac0e..9695d710 100644
>> --- a/src/scanner.l
>> +++ b/src/scanner.l
>> @@ -410,7 +410,7 @@ addrstring  ({macaddr}|{ip4addr}|{ip6addr})
>>   }
>>
>>   "counter"              { scanner_push_start_cond(yyscanner, SCANSTATE_COUNTER); return COUNTER; }
>> -<SCANSTATE_COUNTER,SCANSTATE_LIMIT,SCANSTATE_QUOTA,SCANSTATE_STMT_SYNPROXY,SCANSTATE_EXPR_OSF>"name"                   { return NAME; }
>> +<SCANSTATE_COUNTER,SCANSTATE_LIMIT,SCANSTATE_QUOTA,SCANSTATE_STMT_SYNPROXY,SCANSTATE_EXPR_OSF,SCANSTATE_TUNNEL>"name"                  { return NAME; }
>>   <SCANSTATE_COUNTER,SCANSTATE_CT,SCANSTATE_LIMIT>"packets"              { return PACKETS; }
>>   <SCANSTATE_COUNTER,SCANSTATE_CT,SCANSTATE_LIMIT,SCANSTATE_QUOTA>"bytes"        { return BYTES; }
>>
>> @@ -826,6 +826,7 @@ addrstring  ({macaddr}|{ip4addr}|{ip6addr})
>>          "erspan"                { return ERSPAN; }
>>          "egress"                { return EGRESS; }
>>          "ingress"               { return INGRESS; }
>> +       "path"                  { return PATH; }
>>   }
>>
>>   "notrack"              { return NOTRACK; }
>> diff --git a/src/statement.c b/src/statement.c
>> index 2bfed4ac..20241f68 100644
>> --- a/src/statement.c
>> +++ b/src/statement.c
>> @@ -290,6 +290,7 @@ static const char *objref_type[NFT_OBJECT_MAX + 1] = {
>>          [NFT_OBJECT_QUOTA]      = "quota",
>>          [NFT_OBJECT_CT_HELPER]  = "ct helper",
>>          [NFT_OBJECT_LIMIT]      = "limit",
>> +       [NFT_OBJECT_TUNNEL]     = "tunnel",
>>          [NFT_OBJECT_CT_TIMEOUT] = "ct timeout",
>>          [NFT_OBJECT_SECMARK]    = "secmark",
>>          [NFT_OBJECT_SYNPROXY]   = "synproxy",
>> diff --git a/src/tunnel.c b/src/tunnel.c
>> new file mode 100644
>> index 00000000..cd92d039
>> --- /dev/null
>> +++ b/src/tunnel.c
>> @@ -0,0 +1,81 @@
>> +/*
>> + * Copyright (c) 2018 Pablo Neira Ayuso <pablo@netfilter.org>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +#include <errno.h>
>> +#include <limits.h>
>> +#include <stddef.h>
>> +#include <stdlib.h>
>> +#include <stdio.h>
>> +#include <stdbool.h>
>> +#include <stdint.h>
>> +#include <string.h>
>> +#include <net/if.h>
>> +#include <net/if_arp.h>
>> +#include <pwd.h>
>> +#include <grp.h>
>> +#include <arpa/inet.h>
>> +#include <linux/netfilter.h>
>> +#include <linux/pkt_sched.h>
>> +#include <linux/if_packet.h>
>> +
>> +#include <nftables.h>
>> +#include <expression.h>
>> +#include <datatype.h>
>> +#include <tunnel.h>
>> +#include <gmputil.h>
>> +#include <utils.h>
>> +#include <erec.h>
>> +
>> +const struct tunnel_template tunnel_templates[] = {
>> +       [NFT_TUNNEL_PATH]       = META_TEMPLATE("path", &boolean_type,
>> +                                               BITS_PER_BYTE, BYTEORDER_HOST_ENDIAN),
>> +       [NFT_TUNNEL_ID]         = META_TEMPLATE("id",  &integer_type,
>> +                                               4 * 8, BYTEORDER_HOST_ENDIAN),
>> +};
>> +
>> +static void tunnel_expr_print(const struct expr *expr, struct output_ctx *octx)
>> +{
>> +       uint32_t key = expr->tunnel.key;
>> +       const char *token = "unknown";
>> +
>> +       if (key < array_size(tunnel_templates))
>> +               token = tunnel_templates[key].token;
>> +
>> +       nft_print(octx, "tunnel %s", token);
>> +}
>> +
>> +static bool tunnel_expr_cmp(const struct expr *e1, const struct expr *e2)
>> +{
>> +       return e1->tunnel.key == e2->tunnel.key;
>> +}
>> +
>> +static void tunnel_expr_clone(struct expr *new, const struct expr *expr)
>> +{
>> +       new->tunnel.key = expr->tunnel.key;
>> +}
>> +
>> +const struct expr_ops tunnel_expr_ops = {
>> +       .type           = EXPR_TUNNEL,
>> +       .name           = "tunnel",
>> +       .print          = tunnel_expr_print,
>> +       .cmp            = tunnel_expr_cmp,
>> +       .clone          = tunnel_expr_clone,
>> +};
>> +
>> +struct expr *tunnel_expr_alloc(const struct location *loc,
>> +                              enum nft_tunnel_keys key)
>> +{
>> +       const struct tunnel_template *tmpl = &tunnel_templates[key];
>> +       struct expr *expr;
>> +
>> +       expr = expr_alloc(loc, EXPR_TUNNEL, tmpl->dtype, tmpl->byteorder,
>> +                         tmpl->len);
>> +       expr->tunnel.key = key;
>> +
>> +       return expr;
>> +}
>> --
>> 2.50.1
>>
>>

