Return-Path: <SRS0=LRZR=3U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1BF8C33CB2
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 Jan 2020 03:18:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 93FB620CC7
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 Jan 2020 03:18:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore-com.20150623.gappssmtp.com header.i=@paul-moore-com.20150623.gappssmtp.com header.b="qLxxa4ib"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727998AbgAaDSe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 30 Jan 2020 22:18:34 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:43275 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727926AbgAaDSe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Jan 2020 22:18:34 -0500
Received: by mail-ed1-f67.google.com with SMTP id dc19so6187274edb.10
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Jan 2020 19:18:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xEOcbam6lkpewzM/QAeXoI3lqiVgnug3kiCPMonrhtk=;
        b=qLxxa4iblEFXTNkhpXnrUE2jEwWkTF32sgj/WripjIkzr3FN5HhP+oxWGrK5LPpeuX
         BdXC/ta5pWwYxoPmPnwjyLYrwwhu7PdqsdsxD3QJRTXNF9VLcur/Uj0QPrDJcKIFK8WD
         Inivp0E1OGD97QK5cDwi9NeziJ+2uXu9lI+OXOSAm0+8v2S6H4KOsHn8wuuNXLazSbUE
         J6UGrQcl0tp7vQIZZp9zz4E90wuPARtwIjqUV/+PA+6v0Iurpdm3MMtRHB40DfNWd/ee
         C9jmr/5Z3KydS+TdtygpRDTCkMiW2RKiaolxrMJkE9uV7rR8TdU5widouDLZI3z9nH7O
         LUOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xEOcbam6lkpewzM/QAeXoI3lqiVgnug3kiCPMonrhtk=;
        b=Hwqe5+/jJnINhxkZRllncgqydV8u/5mbu0zOpvjZtDfm1v3Fo8Pt3BKWisfHssglhf
         5o2xagHdvRZMIAagf5uABLjMn7FaImxJT3hW7UVDXV/YdABZTf20QJzsIFPo/Np9rSIq
         uE72R3W1GpbWh0QdbyQMw4/lSF+/vnept5HivqY7gzvF6o30nE5hWVOAOyCD//11adij
         wiccNWN1Ve83b9DRxbzf/oMeuE7uRsL+SnJ2p8En198NScoIkG/lgjcPJMO0uAe3Li6d
         tb1xaDr2bKXbi/XqMjearia9HWPH3HOtKsuquwHIfyVirTlqvC/XtzeodMewGHta6Xlk
         vtRQ==
X-Gm-Message-State: APjAAAU5mWuokRChVIwvrJmblinIrXeKkG4xKr9zyB3B0/k6tyXoLsJ1
        j15oy3bVOd2TWPosRLLvZXMKy44LBKtGE5YFN0nq
X-Google-Smtp-Source: APXvYqxufqzKyb49egpBrJmvUXyLRz88Mm+V9y+cHsgviO9ZYjgLZ0WhxG3Xh0NApIF+UruakQs1vxR25nSGP/fXa80=
X-Received: by 2002:a17:906:f251:: with SMTP id gy17mr6798194ejb.308.1580440712079;
 Thu, 30 Jan 2020 19:18:32 -0800 (PST)
MIME-Version: 1.0
References: <cover.1577830902.git.rgb@redhat.com> <9f16dee52bac9a3068939283a0122a632ee0438d.1577830902.git.rgb@redhat.com>
In-Reply-To: <9f16dee52bac9a3068939283a0122a632ee0438d.1577830902.git.rgb@redhat.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 30 Jan 2020 22:18:21 -0500
Message-ID: <CAHC9VhS4Cz1T=hycPVz3aCzOpPX-EDzwh284YQ2V5rUM7BJkzg@mail.gmail.com>
Subject: Re: [PATCH ghak25 v2 7/9] netfilter: ebtables audit table registration
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, sgrubb@redhat.com,
        omosnace@redhat.com, fw@strlen.de, twoerner@redhat.com,
        Eric Paris <eparis@parisplace.org>, ebiederm@xmission.com,
        tgraf@infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jan 6, 2020 at 1:56 PM Richard Guy Briggs <rgb@redhat.com> wrote:
>
> Generate audit NETFILTER_CFG records on ebtables table registration.
>
> Previously this was only being done for all x_tables operations and
> ebtables table replacement.
>
> Call new audit_nf_cfg() to store table parameters for later use with
> syscall records.
>
> Here is a sample accompanied record:
>   type=NETFILTER_CFG msg=audit(1494907217.558:5403): table=filter family=7 entries=0

Wait a minute ... in patch 4 you have code that explicitly checks for
"entries=0" and doesn't generate a record in that case; is the example
a lie or is the code a lie? ;)

> See: https://github.com/linux-audit/audit-kernel/issues/43
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  net/bridge/netfilter/ebtables.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
> index 57dc11c0f349..58126547b175 100644
> --- a/net/bridge/netfilter/ebtables.c
> +++ b/net/bridge/netfilter/ebtables.c
> @@ -1219,6 +1219,8 @@ int ebt_register_table(struct net *net, const struct ebt_table *input_table,
>                 *res = NULL;
>         }
>
> +       if (audit_enabled)
> +               audit_nf_cfg(repl->name, AF_BRIDGE, repl->nentries);
>         return ret;
>  free_unlock:
>         mutex_unlock(&ebt_mutex);
> --
> 1.8.3.1

--
paul moore
www.paul-moore.com
