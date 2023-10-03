Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3187BE7542B
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Oct 2023 17:50:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232148AbjJCRur (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 3 Oct 2023 13:50:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231967AbjJCRuq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 Oct 2023 13:50:46 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A982595
        for <netfilter-devel@vger.kernel.org>; Tue,  3 Oct 2023 10:50:42 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id 3f1490d57ef6-d81adf0d57fso1305917276.1
        for <netfilter-devel@vger.kernel.org>; Tue, 03 Oct 2023 10:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1696355442; x=1696960242; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/T8k80Cop+6L6ynJHtP67Ti3Be5WFhtcbWRJNuOWxf4=;
        b=PKx5Ikv5TtV+DY12Ul7VIopFb3HHpLvzLvuSCoTZMHFJxtXVtHsHw6yT9h7CkGPEpR
         slpQeuezvx7jJ4XEXwxBjd1SKbFdIssAzMAuWaKs1jSPQy/RWNxekmIJBhHW3/d2vJBg
         g0yJSFVAep4FvXGnZFyFF0BEv/K1Jj5ECyX2vnYZuVPwY0ZbXhnd/b6YEh9oxH2yw6c+
         ygL+3R7o32dCGoXffOJjzKQfhphpuFXRTT1lyrgyyfs8BDZ6Ta/c/nq/7tm7wmKR9rZU
         CPMu5/f2CfT7WmSpGXLjJit4NxhcFK1RDcSGP/LX+uL4CCY44wxIfNR+WCG6RDh9qT70
         +ZaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696355442; x=1696960242;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/T8k80Cop+6L6ynJHtP67Ti3Be5WFhtcbWRJNuOWxf4=;
        b=i+e/XLN1jGFq0a0nWBvzr7jxCoPx6FZa22foBPI7u/lTGYRzHaVbQ6MjA30LNpafFH
         60X4d7KHlrwbc24Onw/2TpaKobzI+T4xMGXfUhoa8YSXT6QdfRZs7Icyg9NIdkhbwDOy
         J+2m7knvfwZHuCSeOLCDZ97LEjhqB26xNGte8VPOHadnY3vxBfzt9Pwwetbjt1ALFDUF
         yVRB9/50ec2FtZnaZ55t+WGBTUEGXNUeNsigFrX/Ggft0vyeZkEH71m+YOD69f8DRnnD
         wbTy6jH+OOWZQHWQSiWXjAbymjxTDhmzOjsN+yMcaAH57eSU57TtxasOLYcKlWLOzt7s
         MRdg==
X-Gm-Message-State: AOJu0Yy/bOwvvDyMNJQqI/knmMy9Y5i8Ll0J/R1p6iv/f3gW+/wBHuL8
        mwq8G5BMURFU8dN9X+ajBtpdDiHTr+HAIwKNrmZ6
X-Google-Smtp-Source: AGHT+IEVaGR9hicczjyUnlHHMH3ZGuO812YIgniv7zsqwxMls+VdSGusfrMHTntRKXjr86FDNscOJ4EnJL/iExkrKpM=
X-Received: by 2002:a25:5d3:0:b0:d0e:b5c8:6359 with SMTP id
 202-20020a2505d3000000b00d0eb5c86359mr13845058ybf.55.1696355441843; Tue, 03
 Oct 2023 10:50:41 -0700 (PDT)
MIME-Version: 1.0
References: <20230923015351.15707-1-phil@nwl.cc> <20230923015351.15707-3-phil@nwl.cc>
In-Reply-To: <20230923015351.15707-3-phil@nwl.cc>
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 3 Oct 2023 13:50:30 -0400
Message-ID: <CAHC9VhRu6G85YGd7yoGxF1eqeg2QJ5onQHvVtDVyn4_JvUV2pw@mail.gmail.com>
Subject: Re: [nf PATCH 2/3] netfilter: nf_tables: Deduplicate nft_register_obj
 audit logs
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
> When adding/updating an object, the transaction handler emits suitable
> audit log entries already, the one in nft_obj_notify() is redundant. To
> fix that (and retain the audit logging from objects' 'update' callback),
> Introduce an "audit log free" variant for internal use.
>
> Fixes: c520292f29b80 ("audit: log nftables configuration change events on=
ce per table")
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  net/netfilter/nf_tables_api.c                 | 44 ++++++++++++-------
>  .../testing/selftests/netfilter/nft_audit.sh  | 20 +++++++++
>  2 files changed, 48 insertions(+), 16 deletions(-)

Thanks for working on this Phil, it looks good to me from an audit perspect=
ive.

Acked-by: Paul Moore <paul@paul-moore.com> (Audit)

--=20
paul-moore.com
