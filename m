Return-Path: <SRS0=20nZ=ZY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31F84C432C0
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Dec 2019 08:28:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9856215E5
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Dec 2019 08:28:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Kk9qtKvI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726087AbfLBI2u (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Dec 2019 03:28:50 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:41402 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbfLBI2u (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Dec 2019 03:28:50 -0500
Received: by mail-io1-f67.google.com with SMTP id z26so35939340iot.8
        for <netfilter-devel@vger.kernel.org>; Mon, 02 Dec 2019 00:28:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=ms7SYMr2Kk2WDQg/1eYvcXRMKFp3mI/jI093IxdGTNI=;
        b=Kk9qtKvI+JbGnB3SvZ/YNhHV0oeWf20tMnPB/ky7sC1HWX5hkoF8a6cChjWy6aiOBP
         /Or/ZumIHnQp9dMAyCAYx+oOSHuSF5+iBRs660/QOIq8wS9r0a1nbJ+C+0LB4yhv3KIX
         EV1JPny10mefGADnk02MloJOoDuXtIYWu9CDF0+UqXrsPq2NpJoIvvcN1P5tbeJldXKj
         gkkU3FNUmOndLe6fg2X6cH0MdlsmiwDOUud+eh7+fQwcW7ISRUn9zs8k60xCn5JNS3V0
         oxtvkmjO4m9ep/VS3Uyaq8T2ZFSbG9l/n2FlD/lWmE891cNBr0m29b0qfOqFJqjLQwIr
         na2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=ms7SYMr2Kk2WDQg/1eYvcXRMKFp3mI/jI093IxdGTNI=;
        b=rw3MOZ4S1NrpRrCGWMsifj6sok6OyBXnXY9Ic2tdIiBHjb4LD8coXZWli4rWLmOKBa
         uTJ8LGf+Cep+gnIeZqS2E2XXXFE7zFunjR8uouWrriLegKPnB91ygCkHwFXQxu+Nv00O
         3DyMjZYNKb0XCN3/tiu7Xh/7snw/ymj631ywYWCKOuIEughBy0W2riF38RiSfuAF8w5q
         6fi4cDs9vyyw5BUPlYHX0AB6j/NnLqwwGZSOOH0nBY7fsX1nMXsl/uyrM4O8VKjwKBXj
         k/I3msohGuShLe7Z5GvHfLurott7uhWnJPo9XObwaer2TfSGpxLWv+Z3XtikazaiS+BZ
         2TEg==
X-Gm-Message-State: APjAAAXRZLN6lJ/k7qi2uoJ72DNxtunKc9PCtebtS/NjlPNO6xvPdtSe
        BCTXzEEpfe66Hxvx1+shP/JAIgB8BVY0WfsxtihpeHD1
X-Google-Smtp-Source: APXvYqxf9gojEFRjzfOI+TZzVcYS7WQGR4Q5XBlndahaXfapWCq2crtgPq5JLj/LRINWBl7dlwWCYMemJbZTNAmj1s4=
X-Received: by 2002:a05:6602:93:: with SMTP id h19mr42995165iob.200.1575275329152;
 Mon, 02 Dec 2019 00:28:49 -0800 (PST)
MIME-Version: 1.0
References: <20191129143039.880-1-ejallot@gmail.com>
In-Reply-To: <20191129143039.880-1-ejallot@gmail.com>
From:   Eric Jallot <ejallot@gmail.com>
Date:   Mon, 2 Dec 2019 09:28:33 +0100
Message-ID: <CAMV0XWEk0CR4HPTmH1OVHypHzDF7W19PVbh=Z0NJc7QeEvaVYw@mail.gmail.com>
Subject: Re: [PATCH v2 nft] scanner: fix out-of-bound memory write in include_file()
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

I forgot to say that v2 is only an update on the commit's message.
Sorry.

Le ven. 29 nov. 2019 =C3=A0 15:32, Eric Jallot <ejallot@gmail.com> a =C3=A9=
crit :
>
> Before patch:
>  # echo 'include "/tmp/rules.nft"' > /tmp/rules.nft
>  # nft -f /tmp/rules.nft
>  In file included from /tmp/rules.nft:1:1-25:
>                   from /tmp/rules.nft:1:1-25:
>  [snip]
>                   from /tmp/rules.nft:1:1-25:
>  /tmp/rules.nft:1:1-25: Error: Include nested too deeply, max 16 levels
>  include "/tmp/rules.nft"
>  ^^^^^^^^^^^^^^^^^^^^^^^^^
>  double free or corruption (out)
>  Aborted (core dumped)
>
> valgrind reports:
>
> =3D=3D8856=3D=3D Invalid write of size 8
> =3D=3D8856=3D=3D    at 0x4E8FCAF: include_file (scanner.l:718)
> =3D=3D8856=3D=3D    by 0x4E8FEF6: include_glob (scanner.l:793)
> =3D=3D8856=3D=3D    by 0x4E9985D: scanner_include_file (scanner.l:875)
> =3D=3D8856=3D=3D    by 0x4E89D7A: nft_parse (parser_bison.y:828)
> =3D=3D8856=3D=3D    by 0x4E765E1: nft_parse_bison_filename (libnftables.c=
:394)
> =3D=3D8856=3D=3D    by 0x4E765E1: nft_run_cmd_from_filename (libnftables.=
c:497)
> =3D=3D8856=3D=3D    by 0x40172D: main (main.c:340)
>
> So perform bounds checking on MAX_INCLUDE_DEPTH before writing.
>
> After patch:
>  # nft -f /tmp/rules.nft
>  In file included from /tmp/rules.nft:1:1-25:
>                   from /tmp/rules.nft:1:1-25:
>  [snip]
>                   from /tmp/rules.nft:1:1-25:
>  /tmp/rules.nft:1:1-25: Error: Include nested too deeply, max 16 levels
>  include "/tmp/rules.nft"
>  ^^^^^^^^^^^^^^^^^^^^^^^^^
>  # echo $?
>  1
>
> Also:
> Update scanner_push_file() function definition accordingly.
>
> Fixes: 32325e3c3fab4 ("libnftables: Store top_scope in struct nft_ctx")
> Signed-off-by: Eric Jallot <ejallot@gmail.com>
> ---
>  src/scanner.l | 21 +++++++++------------
>  1 file changed, 9 insertions(+), 12 deletions(-)
>
> diff --git a/src/scanner.l b/src/scanner.l
> index 80b5a5f0dafc..d32adf4897ae 100644
> --- a/src/scanner.l
> +++ b/src/scanner.l
> @@ -672,17 +672,13 @@ static void scanner_pop_buffer(yyscan_t scanner)
>         state->indesc =3D state->indescs[--state->indesc_idx];
>  }
>
> -static struct error_record *scanner_push_file(struct nft_ctx *nft, void =
*scanner,
> -                                             const char *filename, const=
 struct location *loc)
> +static void scanner_push_file(struct nft_ctx *nft, void *scanner,
> +                             const char *filename, const struct location=
 *loc)
>  {
>         struct parser_state *state =3D yyget_extra(scanner);
>         struct input_descriptor *indesc;
>         YY_BUFFER_STATE b;
>
> -       if (state->indesc_idx =3D=3D MAX_INCLUDE_DEPTH)
> -               return error(loc, "Include nested too deeply, max %u leve=
ls",
> -                            MAX_INCLUDE_DEPTH);
> -
>         b =3D yy_create_buffer(nft->f[state->indesc_idx], YY_BUF_SIZE, sc=
anner);
>         yypush_buffer_state(b, scanner);
>
> @@ -697,8 +693,6 @@ static struct error_record *scanner_push_file(struct =
nft_ctx *nft, void *scanner
>         state->indescs[state->indesc_idx] =3D indesc;
>         state->indesc =3D state->indescs[state->indesc_idx++];
>         list_add_tail(&indesc->list, &state->indesc_list);
> -
> -       return NULL;
>  }
>
>  static int include_file(struct nft_ctx *nft, void *scanner,
> @@ -708,6 +702,12 @@ static int include_file(struct nft_ctx *nft, void *s=
canner,
>         struct error_record *erec;
>         FILE *f;
>
> +       if (state->indesc_idx =3D=3D MAX_INCLUDE_DEPTH) {
> +               erec =3D error(loc, "Include nested too deeply, max %u le=
vels",
> +                            MAX_INCLUDE_DEPTH);
> +               goto err;
> +       }
> +
>         f =3D fopen(filename, "r");
>         if (f =3D=3D NULL) {
>                 erec =3D error(loc, "Could not open file \"%s\": %s\n",
> @@ -715,10 +715,7 @@ static int include_file(struct nft_ctx *nft, void *s=
canner,
>                 goto err;
>         }
>         nft->f[state->indesc_idx] =3D f;
> -
> -       erec =3D scanner_push_file(nft, scanner, filename, loc);
> -       if (erec !=3D NULL)
> -               goto err;
> +       scanner_push_file(nft, scanner, filename, loc);
>         return 0;
>  err:
>         erec_queue(erec, state->msgs);
> --
> 2.11.0
>
