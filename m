From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [nft PATCH] src: add redirect support
Date: Wed, 15 Oct 2014 12:13:16 +0200
Message-ID: <CAOkSjBiU-65GEOiWnjqsMJ7VxDt5uHGhhu-caaNGLiZarkNCbg@mail.gmail.com>
References: <20141015074756.30515.90161.stgit@nfdev.cica.es> <20141015100829.GD4885@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:55242 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225AbaJOKNi convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Oct 2014 06:13:38 -0400
Received: by mail-la0-f45.google.com with SMTP id q1so742912lam.32
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Oct 2014 03:13:36 -0700 (PDT)
In-Reply-To: <20141015100829.GD4885@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 15 October 2014 12:08, Pablo Neira Ayuso <pablo@netfilter.org> wrote=
:
> On Wed, Oct 15, 2014 at 09:47:56AM +0200, Arturo Borrero Gonzalez wro=
te:
>> This patch adds redirect support for nft.
>>
>> The syntax is:
>>
>>  % nft add rule nat prerouting redirect [port|nat_flags]
>>
>> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.co=
m>
>> ---
>>  include/statement.h       |   10 +++++++++
>>  src/evaluate.c            |   42 ++++++++++++++++++++++++++++++++++=
++
>>  src/netlink_delinearize.c |   52 ++++++++++++++++++++++++++++++++++=
+++++++++++
>>  src/netlink_linearize.c   |   49 ++++++++++++++++++++++++++++++++++=
++++++++
>>  src/parser.y              |   23 ++++++++++++++++++--
>>  src/scanner.l             |    1 +
>>  src/statement.c           |   29 +++++++++++++++++++++++++
>>  7 files changed, 204 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/statement.h b/include/statement.h
>> index 35c1b7a..d143121 100644
>> --- a/include/statement.h
>> +++ b/include/statement.h
>> @@ -79,6 +79,13 @@ struct masq_stmt {
>>
>>  extern struct stmt *masq_stmt_alloc(const struct location *loc);
>>
>> +struct redir_stmt {
>> +     struct expr             *proto;
>> +     uint32_t                flags;
>> +};
>> +
>> +extern struct stmt *redir_stmt_alloc(const struct location *loc);
>> +
>>  struct queue_stmt {
>>       struct expr             *queue;
>>       uint16_t                flags;
>> @@ -110,6 +117,7 @@ extern struct stmt *ct_stmt_alloc(const struct l=
ocation *loc,
>>   * @STMT_REJECT:     REJECT statement
>>   * @STMT_NAT:                NAT statement
>>   * @STMT_MASQ:               masquerade statement
>> + * @STMT_REDIR:              redirect statement
>>   * @STMT_QUEUE:              QUEUE statement
>>   * @STMT_CT:         conntrack statement
>>   */
>> @@ -124,6 +132,7 @@ enum stmt_types {
>>       STMT_REJECT,
>>       STMT_NAT,
>>       STMT_MASQ,
>> +     STMT_REDIR,
>>       STMT_QUEUE,
>>       STMT_CT,
>>  };
>> @@ -172,6 +181,7 @@ struct stmt {
>>               struct reject_stmt      reject;
>>               struct nat_stmt         nat;
>>               struct masq_stmt        masq;
>> +             struct redir_stmt       redir;
>>               struct queue_stmt       queue;
>>               struct ct_stmt          ct;
>>       };
>> diff --git a/src/evaluate.c b/src/evaluate.c
>> index 108248a..6a2c724 100644
>> --- a/src/evaluate.c
>> +++ b/src/evaluate.c
>> @@ -1375,6 +1375,46 @@ out:
>>       return 0;
>>  }
>>
>> +static int stmt_evaluate_redir(struct eval_ctx *ctx, struct stmt *s=
tmt)
>> +{
>> +     int err;
>> +     struct proto_ctx *pctx =3D &ctx->pctx;
>> +
>> +     if (!pctx)
>> +             goto out;
>> +
>> +     switch (pctx->family) {
>> +     case AF_INET:
>> +             expr_set_context(&ctx->ectx, &ipaddr_type,
>> +                             4 * BITS_PER_BYTE);
>> +             break;
>> +     case AF_INET6:
>> +             expr_set_context(&ctx->ectx, &ip6addr_type,
>> +                              16 * BITS_PER_BYTE);
>> +             break;
>> +     default:
>> +             return stmt_error(ctx, stmt, "ip and ip6 support only"=
);
>> +     }
>> +
>> +     if (stmt->redir.proto !=3D NULL) {
>> +             if (pctx->protocol[PROTO_BASE_TRANSPORT_HDR].desc =3D=3D=
 NULL)
>> +                     return stmt_binary_error(ctx, stmt->redir.prot=
o, stmt,
>> +                                              "transport protocol m=
apping "
>> +                                              "is only valid after =
"
>> +                                              "transport protocol m=
atch");
>
> Errors have to fit in one line, preferably.
>

Could you please give some suggestion?

regards.

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
