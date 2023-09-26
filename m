Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24B8EE7F140
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Sep 2023 22:28:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbjIZW2I (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Sep 2023 18:28:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbjIZW0H (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Sep 2023 18:26:07 -0400
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 401758A76
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Sep 2023 14:25:03 -0700 (PDT)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-59f6763767dso75532477b3.2
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Sep 2023 14:25:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1695763502; x=1696368302; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hwijluXAJKvne9nyx6goJKnLPUI/1CGCM6T80bPQaYM=;
        b=LR2FX1f3DDBRQYRdtvnoDE0f+uH+7KoAD6fh0mCa/BXBlGRZ1icvRDPb0kMIE/+e+h
         mjvU1TMBJmwmU12hmgJnSjO1FE7UivTwxapLI+hC/aEluSvhAYrKYABBFBdKqQS/jPIE
         quHNW3D8taM3MXVGb9x31zKxBN5LmWXD5aVmb8bwGNy0yr+8CU5oylSa9YxaiE5M8jKC
         u8VlzGeO5yGikhZgBGgDRJ7vuVdJNjb+ryEgbmTDYA94D4etrotoNKhikjaTzHW7TSon
         vBZEwmC7ybj0IJXfsTZuMLNZlyAGMBLditaBKy9xbsM6Od9WZT95OQwJ3vlpRscJp+Vp
         GCSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695763502; x=1696368302;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hwijluXAJKvne9nyx6goJKnLPUI/1CGCM6T80bPQaYM=;
        b=GgjkgQKaJdRlKKrt3gpqVkrsDp79W6EgHaAXN79Bpc9KUpVbURnj6N4xuDAfMov+ie
         AldDDKwTjO9aOsAXW9+YDj3tDoMcS8KlpbTT0rHSQo9XJ+i8jqRRnZKPkseeCzR7J5+u
         rRXToQzSiv3NCemhx86a/iGRtKqJm0GzcD5rZZVCIHfX06+ghWZ7vGd3qkB540ws8sG7
         N7r/HMpKlyJk3KwD+s2Iji3RDAba8SXKm//JuH1QTdZiWq/v4Xx5GF/ZGtI77TSud2L2
         WF7RPkJ7ZvEg0JJQ9ab/iScjL9VejVNkP1m+vtBlGm5lOuBeNro4Hfmdrn9GYvpvf/E4
         ELoQ==
X-Gm-Message-State: AOJu0Yw2W31EjOKqdcpkYPqr9F6/S1wZQxwL0rNCAEtxQ3R08ceQ0VS5
        xl4id/ybEoDc8ndEoUChSGjw2bVbz3Q2jbUYikEb
X-Google-Smtp-Source: AGHT+IHWBrVpaEs8oeLeJX4Du6t+Xq/8ntooKfhRzbkI+hrad/LJobEDNuHtrB4FZeMEAvoJSWXS/3Y3U0XqWUf8NlE=
X-Received: by 2002:a0d:cbd6:0:b0:599:da80:e1eb with SMTP id
 n205-20020a0dcbd6000000b00599da80e1ebmr287256ywd.24.1695763502468; Tue, 26
 Sep 2023 14:25:02 -0700 (PDT)
MIME-Version: 1.0
References: <20230923015351.15707-1-phil@nwl.cc>
In-Reply-To: <20230923015351.15707-1-phil@nwl.cc>
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 26 Sep 2023 17:24:51 -0400
Message-ID: <CAHC9VhQv6dbgbfxEn4EjHhhfu3YDT0Ed76gZQNFyhY2mzeE0bg@mail.gmail.com>
Subject: Re: [nf PATCH 0/3] Review nf_tables audit logging
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
> When working on locking for reset commands, some audit log calls had to
> be adjusted as well. This series deals with the "fallout" from adding
> tests for the changed log calls, dealing with the uncovered issues and
> adding more tests.
>
> Patch 1 adds more testing to nft_audit.sh for commands which are
> unproblematic.
>
> Patch 2 deals with (likely) leftovers from audit log flood prevention in
> commit c520292f29b80 ("audit: log nftables configuration change events
> once per table").
>
> Patch 3 changes logging for object reset requests to happen once per
> table (if skb size is sufficient) and thereby aligns output with object
> add requests. As a side-effect, logging is fixed to happen after the
> actual reset has succeeded, not before.
>
> NOTE: This whole series probably depends on the reset locking series[1]
> submitted earlier, but there's no functional connection and reviews
> should happen independently.
>
> [1] https://lore.kernel.org/netfilter-devel/20230923013807.11398-1-phil@n=
wl.cc/
>
> Phil Sutter (3):
>   selftests: netfilter: Extend nft_audit.sh
>   netfilter: nf_tables: Deduplicate nft_register_obj audit logs
>   netfilter: nf_tables: Audit log object reset once per table
>
>  net/netfilter/nf_tables_api.c                 |  95 +++++-----
>  .../testing/selftests/netfilter/nft_audit.sh  | 163 ++++++++++++++++--
>  2 files changed, 203 insertions(+), 55 deletions(-)

Hi Phil,

Thanks for continuing to work on this, my network access is limited at
the moment but I hope to be able to review this next week.

--=20
paul-moore.com
