Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E612E75455
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Oct 2023 17:51:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232064AbjJCRvo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 3 Oct 2023 13:51:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231967AbjJCRvo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 Oct 2023 13:51:44 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A36195
        for <netfilter-devel@vger.kernel.org>; Tue,  3 Oct 2023 10:51:41 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id 3f1490d57ef6-d84d883c1b6so70841276.0
        for <netfilter-devel@vger.kernel.org>; Tue, 03 Oct 2023 10:51:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1696355500; x=1696960300; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=48BWQwPh2K54L8OtDceJIKDMlt1uxT8fEejbEi1kObY=;
        b=NYMnLQxYmN6kM16HWpf+p9KGiFS6mt3Gbkvom7qEhPIeQl1rpW91Fr+omYOLhmLvhS
         FHV9JQPDNu4fnAAzh2SPqZRNaoCxKoinlIzwzchh4oWEkWJsj3mnRINoTPZj3PvlMfyC
         ODjGlX0laplztNVnsm739J9m/Az7WwMloDb7jtGlAGfsy+DVAPYGiXJjnsYLL5KKkQT+
         GrbOlSXciadKMlITE4kfMcSxMK6DL6AUURnoJRH33NlWm2ELNGDZ2+QWiMZqO2AOzU6U
         Dh6UzlKsx5Hs2CkmLOSpQbxou/Kp3JqiKtA/M/qVnMk+Lezw4VJkU0ruzKmpzTRKKap5
         dTOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696355500; x=1696960300;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=48BWQwPh2K54L8OtDceJIKDMlt1uxT8fEejbEi1kObY=;
        b=lmc8J41oJOi7NUiCeaDtdMycjn8SxkgLG8vh6wuT9TSsJG9/p2cAXEqdfguS8B9dc6
         nj7CQDGeYoXPSe2JKID5hKAs9zAGSs0nC8VPlMuwOpBuw4yysLAJPJsXqNWsbczbVF64
         vJwW5QJzobb/xz0GCX2y04fWd/jlZ1A9mVfCcBQ3Y3R7eFuYFkCW/0g37WGUSzFYhPFd
         ODYVq12Lx+P3H6vwVTyB+5ifTA5CjnopQ6FcHB/WELDCy5lyr3zwd+Cx8Ixr3AZxIwR1
         1HY8yY/++uWtf7ueY9mpZM63lAsjVyDPsHF2qsUnz5JodfcZUaFZyrtLsVWs48L+K+oM
         /l+A==
X-Gm-Message-State: AOJu0YxH3de5nvG4v88gkG73RU0m25LWkvEr6HWXmDpAyclUCR5WwH4j
        Yhh/gSE7iD3nzzPv8u9cou48RFkIQIwQaqgOhJcoRRGVdad3XeU=
X-Google-Smtp-Source: AGHT+IEwSKYo0Tqq5yjhf87gg13I2zziXciKBXawB3BzGZ/jtJnEvUPgkFRh3gX04iaUHE6Np8Zm1+hyrwyNkKCTEcI=
X-Received: by 2002:a25:f607:0:b0:d86:5cb8:29e0 with SMTP id
 t7-20020a25f607000000b00d865cb829e0mr2636045ybd.6.1696355500577; Tue, 03 Oct
 2023 10:51:40 -0700 (PDT)
MIME-Version: 1.0
References: <20230923015351.15707-1-phil@nwl.cc> <20230923015351.15707-4-phil@nwl.cc>
In-Reply-To: <20230923015351.15707-4-phil@nwl.cc>
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 3 Oct 2023 13:51:29 -0400
Message-ID: <CAHC9VhT=C9K8bkzdDiDNp383CS_U=YMOVbzzHMnXET2D+XLZDg@mail.gmail.com>
Subject: Re: [nf PATCH 3/3] netfilter: nf_tables: Audit log object reset once
 per table
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        audit@vger.kernel.org, Richard Guy Briggs <rgb@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Sep 22, 2023 at 9:53=E2=80=AFPM Phil Sutter <phil@nwl.cc> wrote:
>
> When resetting multiple objects at once (via dump request), emit a log
> message per table (or filled skb) and resurrect the 'entries' parameter
> to contain the number of objects being logged for.
>
> With the above in place, all audit logs for op=3Dnft_register_obj have a
> predictable value in 'entries', so drop the value zeroing for them in
> audit_logread.c.
>
> To test the skb exhaustion path, perform some bulk counter and quota
> adds in the kselftest.
>
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  net/netfilter/nf_tables_api.c                 | 51 ++++++++++---------
>  .../testing/selftests/netfilter/nft_audit.sh  | 46 +++++++++++++++++
>  2 files changed, 74 insertions(+), 23 deletions(-)

Thanks Phil.

Acked-by: Paul Moore <paul@paul-moore.com> (Audit)

--=20
paul-moore.com
