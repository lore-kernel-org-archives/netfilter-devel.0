From: Shyam Saini <mayhs11saini@gmail.com>
Subject: Re: [PATCH nft] parser_bison: restore nft {import,export} ruleset
Date: Thu, 15 Feb 2018 00:34:31 +0530
Message-ID: <CAOfkYf4aYq8bkzC5i+mrxrxO0EgzxzL46yphGKfUZettW4LspA@mail.gmail.com>
References: <20180214183244.16184-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>, anthonyryan1@gmail.com,
        Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:33377 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1162347AbeBNTEc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Feb 2018 14:04:32 -0500
Received: by mail-oi0-f67.google.com with SMTP id l124so5072525oib.0
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Feb 2018 11:04:32 -0800 (PST)
In-Reply-To: <20180214183244.16184-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

On Thu, Feb 15, 2018 at 12:02 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Restore original syntax for the yet experimental VM low-level json
> representation.
>
> Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1224
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> I asked for this change to make room for the high-level json
> representation, but we can use -j options for this instead.  Given there
> are more users for the json representation that I expected, I'm fixing
> it myself by restoring the former behaviour.

Why would one use "nft export"  without "nft import".
if someone exports rules in json then they can't use those rules
given the fact that "nft import" was not available earlier.

Am i missing something?


Thanks!!

>  src/parser_bison.y | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/src/parser_bison.y b/src/parser_bison.y
> index 578bfdc10429..4cfc54cfd7b2 100644
> --- a/src/parser_bison.y
> +++ b/src/parser_bison.y
> @@ -1186,7 +1186,7 @@ rename_cmd                :       CHAIN           chain_spec      identifier
>                         }
>                         ;
>
> -import_cmd                     :       RULESET         markup_format
> +import_cmd             :       RULESET         markup_format
>                         {
>                                 struct handle h = { .family = NFPROTO_UNSPEC };
>                                 struct markup *markup = markup_alloc($2);
> @@ -1198,7 +1198,6 @@ import_cmd                        :       RULESET         markup_format
>                                 struct markup *markup = markup_alloc($1);
>                                 $$ = cmd_alloc(CMD_IMPORT, CMD_OBJ_MARKUP, &h, &@$, markup);
>                         }
> -                       |       JSON            { $$ = NULL; }
>                         ;
>
>  export_cmd             :       RULESET         markup_format
> @@ -1213,7 +1212,6 @@ export_cmd                :       RULESET         markup_format
>                                 struct markup *markup = markup_alloc($1);
>                                 $$ = cmd_alloc(CMD_EXPORT, CMD_OBJ_MARKUP, &h, &@$, markup);
>                         }
> -                       |       JSON            { $$ = NULL; }
>                         ;
>
>  monitor_cmd            :       monitor_event   monitor_object  monitor_format
> @@ -1241,10 +1239,10 @@ monitor_object          :       /* empty */     { $$ = CMD_MONITOR_OBJ_ANY; }
>
>  monitor_format         :       /* empty */     { $$ = NFTNL_OUTPUT_DEFAULT; }
>                         |       markup_format
> -                       |       JSON            { $$ = NFTNL_OUTPUT_JSON; }
>                         ;
>
>  markup_format          :       XML             { $$ = NFTNL_OUTPUT_XML; }
> +                       |       JSON            { $$ = NFTNL_OUTPUT_JSON; }
>                         |       VM JSON         { $$ = NFTNL_OUTPUT_JSON; }
>                         ;
>
> --
> 2.11.0
>
