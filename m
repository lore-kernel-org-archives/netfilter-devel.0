From: Arturo Borrero Gonzalez <arturo@netfilter.org>
Subject: Re: [RFC PATCH nft V3] src: Add import command for json
Date: Tue, 12 Sep 2017 20:14:08 +0200
Message-ID: <CAOkSjBiJy31beep0eekC7LFobjGvFe6Q3xiA3dxhWJtZGDNHzw@mail.gmail.com>
References: <1505148790-6585-1-git-send-email-mayhs11saini@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Shyam Saini <mayhs11saini@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36504 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751549AbdILSOa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 Sep 2017 14:14:30 -0400
Received: by mail-wm0-f68.google.com with SMTP id r136so486433wmf.3
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Sep 2017 11:14:30 -0700 (PDT)
Received: from mail-wm0-f51.google.com (mail-wm0-f51.google.com. [74.125.82.51])
        by smtp.gmail.com with ESMTPSA id h33sm5566279edd.60.2017.09.12.11.14.29
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Sep 2017 11:14:29 -0700 (PDT)
Received: by mail-wm0-f51.google.com with SMTP id 189so1775962wmh.1
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Sep 2017 11:14:29 -0700 (PDT)
In-Reply-To: <1505148790-6585-1-git-send-email-mayhs11saini@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 11 September 2017 at 18:53, Shyam Saini <mayhs11saini@gmail.com> wrote:
> This new operation allows to import ruleset in json to make
> incremental changes using the parse functions of libnftnl.
>
> A basic way to test this new functionality is:
>
>  % cat file.json | nft import json
>
> where the file.json is a ruleset exported in json format.
>
> Highly based on work from  Alvaro Neira <alvaroneay@gmail.com>
> and Arturo Borrero <arturo@netfilter.org>
>
> Signed-off-by: Shyam Saini <mayhs11saini@gmail.com>
> ---
> V3:
>    Follow kernel coding style
> ---

Hi Shyam,

almost there. Still some changes required in the coding style. See below.

BTW, you forgot to include the Acked-by: line I mentioned in the last email.

>  include/netlink.h  |   9 ++
>  include/rule.h     |  14 +--
>  src/evaluate.c     |   2 +
>  src/netlink.c      | 288 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  src/parser_bison.y |  38 +++++--
>  src/rule.c         |  45 +++++++--
>  src/scanner.l      |   1 +
>  7 files changed, 370 insertions(+), 27 deletions(-)
>
> diff --git a/include/netlink.h b/include/netlink.h
> index b395cf1cd9ad..b63740b38c2a 100644
> --- a/include/netlink.h
> +++ b/include/netlink.h
> @@ -225,4 +225,13 @@ bool netlink_batch_supported(struct mnl_socket *nf_sock, uint32_t *seqnum);
>
>  int netlink_echo_callback(const struct nlmsghdr *nlh, void *data);
>
> +struct ruleset_parse {
> +       struct netlink_ctx      *nl_ctx;
> +       struct cmd              *cmd;
> +};
> +
> +struct nftnl_parse_ctx;
> +
> +int netlink_markup_parse_cb(const struct nftnl_parse_ctx *ctx);
> +
>  #endif /* NFTABLES_NETLINK_H */
> diff --git a/include/rule.h b/include/rule.h
> index 631a1bcdf84e..56dee9766b2b 100644
> --- a/include/rule.h
> +++ b/include/rule.h
> @@ -327,6 +327,7 @@ uint32_t obj_type_to_cmd(uint32_t type);
>   * @CMD_RESET:         reset container
>   * @CMD_FLUSH:         flush container
>   * @CMD_RENAME:                rename object
> + * @CMD_IMPORT:                import a ruleset in a given format
>   * @CMD_EXPORT:                export the ruleset in a given format
>   * @CMD_MONITOR:       event listener
>   * @CMD_DESCRIBE:      describe an expression
> @@ -342,6 +343,7 @@ enum cmd_ops {
>         CMD_RESET,
>         CMD_FLUSH,
>         CMD_RENAME,
> +       CMD_IMPORT,
>         CMD_EXPORT,
>         CMD_MONITOR,
>         CMD_DESCRIBE,
> @@ -361,7 +363,7 @@ enum cmd_ops {
>   * @CMD_OBJ_RULESET:   ruleset
>   * @CMD_OBJ_EXPR:      expression
>   * @CMD_OBJ_MONITOR:   monitor
> - * @CMD_OBJ_EXPORT:    export
> + * @CMD_OBJ_MARKUP:    import/export
>   * @CMD_OBJ_COUNTER:   counter
>   * @CMD_OBJ_COUNTERS:  multiple counters
>   * @CMD_OBJ_QUOTA:     quota
> @@ -381,7 +383,7 @@ enum cmd_obj {
>         CMD_OBJ_RULESET,
>         CMD_OBJ_EXPR,
>         CMD_OBJ_MONITOR,
> -       CMD_OBJ_EXPORT,
> +       CMD_OBJ_MARKUP,
>         CMD_OBJ_FLOWTABLE,
>         CMD_OBJ_FLOWTABLES,
>         CMD_OBJ_MAP,
> @@ -396,12 +398,12 @@ enum cmd_obj {
>         CMD_OBJ_LIMITS,
>  };
>
> -struct export {
> +struct markup {
>         uint32_t        format;
>  };
>
> -struct export *export_alloc(uint32_t format);
> -void export_free(struct export *e);
> +struct markup *markup_alloc(uint32_t format);
> +void markup_free(struct markup *m);
>
>  enum {
>         CMD_MONITOR_OBJ_ANY,
> @@ -454,7 +456,7 @@ struct cmd {
>                 struct chain    *chain;
>                 struct table    *table;
>                 struct monitor  *monitor;
> -               struct export   *export;
> +               struct markup   *markup;
>                 struct obj      *object;
>         };
>         const void              *arg;
> diff --git a/src/evaluate.c b/src/evaluate.c
> index e767542a868e..2275a3026255 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -3407,6 +3407,8 @@ int cmd_evaluate(struct eval_ctx *ctx, struct cmd *cmd)
>                 return 0;
>         case CMD_MONITOR:
>                 return cmd_evaluate_monitor(ctx, cmd);
> +       case CMD_IMPORT:
> +               return 0;
>         default:
>                 BUG("invalid command operation %u\n", cmd->op);
>         };
> diff --git a/src/netlink.c b/src/netlink.c
> index 291bbdeeaa68..de4d284d5e9b 100644
> --- a/src/netlink.c
> +++ b/src/netlink.c
> @@ -24,6 +24,7 @@
>  #include <libnftnl/object.h>
>  #include <libnftnl/set.h>
>  #include <libnftnl/udata.h>
> +#include <libnftnl/ruleset.h>
>  #include <libnftnl/common.h>
>  #include <linux/netfilter/nfnetlink.h>
>  #include <linux/netfilter/nf_tables.h>
> @@ -3030,6 +3031,293 @@ int netlink_monitor(struct netlink_mon_handler *monhandler,
>         return mnl_nft_event_listener(&ctx, netlink_events_cb, monhandler);
>  }
>
> +static int netlink_markup_setelems(const struct nftnl_parse_ctx *ctx)
> +{
> +       const struct ruleset_parse *rp;
> +       struct nftnl_set *set;
> +       uint32_t cmd;
> +       int ret = -1;
> +
> +       set = nftnl_ruleset_ctx_get(ctx, NFTNL_RULESET_CTX_SET);
> +       rp = nftnl_ruleset_ctx_get(ctx, NFTNL_RULESET_CTX_DATA);
> +
> +       cmd = nftnl_ruleset_ctx_get_u32(ctx, NFTNL_RULESET_CTX_CMD);
> +       switch (cmd) {
> +       case NFTNL_CMD_ADD:
> +               ret = mnl_nft_setelem_batch_add(set, rp->nl_ctx->batch,
> +                                                       0, rp->nl_ctx->seqnum);

This indentation is weird, not following coding style.
Please, read the docs, and read other Netfilter source code for
examples (i.e, nftables)
In general, if a function call requires a line break you should align
the second (and following)
lines with the '(' character. Do this by using tabs with traling
spaces if required.

There are several issues like this all over the patch. Please, fix
them, recheck coding style by yourself and resend.

regards
