Return-Path: <SRS0=cAfZ=AO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DB21C433E1
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Jul 2020 12:41:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DE4622203
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Jul 2020 12:41:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M366pNrb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726147AbgGCMlK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Jul 2020 08:41:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726074AbgGCMlJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Jul 2020 08:41:09 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 952C5C08C5C1;
        Fri,  3 Jul 2020 05:41:09 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id q8so32315301iow.7;
        Fri, 03 Jul 2020 05:41:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/3fARxYuRtacDsta1lOXw0YQpGPHS40fG/Dlgh9w8EI=;
        b=M366pNrbiKkM1b6xE+0QpdAMagpAv24Q5q/wfLwg/Zn4G2nQo7mZSjDNcn53v8l93O
         LMbZ8qdFaFY105cX6XMyqohfH8jK3qqaI5DP67W8PXgL/6Cgb0q6/GmGNXsU2POpYPCL
         iM3iTrfKRwaXArU7FD/Y1N7YcvL9hz1pDgBJeonDWapwxCta/9/j5LSfvkYf7m1IbaUI
         COFr5y58ROXvmTzGHKZ4S4VyhFnEQDOObewoqX4pSHvS5DQkcFMlY4YSBNKD5hed8950
         Kyjty+p33+9ceSZjOrTT4kbOEkI1cO4UTDWngFqKU82lQL6uyrRODK+wAFPUZIR1a7uL
         MQDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/3fARxYuRtacDsta1lOXw0YQpGPHS40fG/Dlgh9w8EI=;
        b=YYzkjH1TjF1JndDVYI/zia5IJuRqgwoVfPv1DmfM+N/NhotXeVZlP/5fj/unnKVATq
         w43chRj8bECvZYmCLFolp8IJz+LnDJyV2ArKMotPIgYv7+RjvUbUQ8LPBHbYiiRtIJDG
         QDsvWP63e0Fymhngk5gFjnWpKArdmYSZqTBe7rFNcf2qWaWX//XtDF5mWsiezLXlDKd7
         ScmeihpLK/nBn4ljQNswdlhIII9Ch8T+jOvXCKrmtZvS4/Umf8WJ1uH4lrPF2E5UCzcy
         7JTtUa71A7aaTHm/3h2XslaJJ+bYIczRyqog5rIosnukplvIDrY26SDVO2UZyXqS0X2P
         wGRg==
X-Gm-Message-State: AOAM532QtC8ugNWTlu2Cs7AGa9FMMkZD2IJGra+hgYELc0d8RF+bTzFi
        xqIE2hn3ENzdOLVicxzOxkBV1LnQqPlBhmFWIrY=
X-Google-Smtp-Source: ABdhPJyaKBMDtXfp8jmSH/dLZJsnXIMsz48usB6Up3Wt1Y1DSANqMYxTz/l4fcbEYrunGZop8YhtM9fwEPOtlnfn92U=
X-Received: by 2002:a6b:5b0e:: with SMTP id v14mr12102540ioh.145.1593780068905;
 Fri, 03 Jul 2020 05:41:08 -0700 (PDT)
MIME-Version: 1.0
References: <3eda864fb69977252a061c8c3ccd2d8fcd1f3a9b.1593278952.git.rgb@redhat.com>
In-Reply-To: <3eda864fb69977252a061c8c3ccd2d8fcd1f3a9b.1593278952.git.rgb@redhat.com>
From:   Jones Desougi <jones.desougi+netfilter@gmail.com>
Date:   Fri, 3 Jul 2020 14:40:57 +0200
Message-ID: <CAGdUbJEwoxEFJZDUjF7ZwKurKNibPW86=s3yFSA6BBt-YsC=Nw@mail.gmail.com>
Subject: Re: [PATCH ghak124 v3fix] audit: add gfp parameter to audit_log_nfcfg
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, Paul Moore <paul@paul-moore.com>,
        sgrubb@redhat.com, omosnace@redhat.com,
        Florian Westphal <fw@strlen.de>, twoerner@redhat.com,
        eparis@parisplace.org, tgraf@infradead.org,
        dan.carpenter@oracle.com
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Doesn't seem entirely consistent now either though. Two cases below.

   /Jones

On Sun, Jun 28, 2020 at 5:27 AM Richard Guy Briggs <rgb@redhat.com> wrote:
>
> Fixed an inconsistent use of GFP flags in nft_obj_notify() that used
> GFP_KERNEL when a GFP flag was passed in to that function.  Given this
> allocated memory was then used in audit_log_nfcfg() it led to an audit
> of all other GFP allocations in net/netfilter/nf_tables_api.c and a
> modification of audit_log_nfcfg() to accept a GFP parameter.
>
> Reported-by: Dan Carptenter <dan.carpenter@oracle.com>
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
> Passes audit-testsuite.
>
>  include/linux/audit.h           |  8 ++++----
>  kernel/auditsc.c                |  4 ++--
>  net/bridge/netfilter/ebtables.c |  6 +++---
>  net/netfilter/nf_tables_api.c   | 33 +++++++++++++++++++++------------
>  net/netfilter/x_tables.c        |  5 +++--
>  5 files changed, 33 insertions(+), 23 deletions(-)
>
...
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 164700273947..f7ff91479647 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
...
> @@ -6071,13 +6077,14 @@ static int nf_tables_getobj(struct net *net, struct sock *nlsk,
>                 reset = true;
>
>         if (reset) {
> -               char *buf = kasprintf(GFP_KERNEL, "%s:%llu;?:0",
> +               char *buf = kasprintf(GFP_ATOMIC, "%s:%llu;?:0",
>                                       table->name, table->handle);
>
>                 audit_log_nfcfg(buf,
>                                 family,
>                                 obj->handle,
> -                               AUDIT_NFT_OP_OBJ_RESET);
> +                               AUDIT_NFT_OP_OBJ_RESET,
> +                               GFP_KERNEL);
>                 kfree(buf);
>         }
>

Replaces one GFP_KERNEL (with GFP_ATOMIC) but also adds a new one in
the following statement.
Is that intentional?

> @@ -6156,7 +6163,7 @@ void nft_obj_notify(struct net *net, const struct nft_table *table,
>  {
>         struct sk_buff *skb;
>         int err;
> -       char *buf = kasprintf(GFP_KERNEL, "%s:%llu;?:0",
> +       char *buf = kasprintf(gfp, "%s:%llu;?:0",
>                               table->name, table->handle);
>
>         audit_log_nfcfg(buf,
> @@ -6164,7 +6171,8 @@ void nft_obj_notify(struct net *net, const struct nft_table *table,
>                         obj->handle,
>                         event == NFT_MSG_NEWOBJ ?
>                                 AUDIT_NFT_OP_OBJ_REGISTER :
> -                               AUDIT_NFT_OP_OBJ_UNREGISTER);
> +                               AUDIT_NFT_OP_OBJ_UNREGISTER,
> +                       GFP_KERNEL);
>         kfree(buf);
>
>         if (!report &&

It would seem these two hunks form a similar discrepancy.

...

> --
> 1.8.3.1
>
