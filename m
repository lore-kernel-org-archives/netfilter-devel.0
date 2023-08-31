Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CB0AC6FA8F
	for <netfilter-devel@archiver.kernel.org>; Thu, 31 Aug 2023 02:26:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236318AbjHaC03 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Aug 2023 22:26:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234922AbjHaC02 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Aug 2023 22:26:28 -0400
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6943BCDD
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Aug 2023 19:26:24 -0700 (PDT)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-594ebdf7bceso4706767b3.2
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Aug 2023 19:26:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1693448783; x=1694053583; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZsfJ/MEEgYAJXY6xphXxWpd/ISMRnmTjf9MyGGBs+Ec=;
        b=LyFjxapqLRg0XbM6jbuKV4fyzyCyYH53P5dLVW+xY3ZFv7I4O2uddBsOWog2jDitZm
         zRszndLqGwRQr2OXaf7+FWYeIjGiWGFD+cji17+AvHJqyZ5VBfihQ6ptoS+uyJ1jb7v4
         UWT7EfLQbNCISgt6o2ILB6ARZ0xI4QoweoFw2SyhE1FReJh/rtIN0EGDDWHP6ZGV3yPn
         dNOUAOUBp82b3YY1+HGPn1LZtvdRBP66SQRWjpy7vUcSmbKMswS5wVgo9D9TLHaldlLY
         FSS54rgF1zZjNw1jAw7Jj59Q1gMB38X7c8PQwx+SPBikYvaLmQ/XtjoQPlFwB4Peb0vg
         S+Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693448783; x=1694053583;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZsfJ/MEEgYAJXY6xphXxWpd/ISMRnmTjf9MyGGBs+Ec=;
        b=AuUfn9XN9Ii6svbwEvq5lSDs7bey3c/v2pCZ0rhHC8GFl6E9CawAIWBUfR95NMvJ2z
         khXLfcAcPRrnR5AuWHhd808fjYxb6AmRcrjLFM1+C08QruGkaQA7p7VBHF5FAGO53DJy
         eC+MKMzEl8PvpgAZ3xmhv/cGLyiDvHDKE5MaTmc5WavkJZO5zvDB4nKR5ZuzjVBIOxvo
         cWOnoDlGrUhftGO7/I0b9C7B7IoeeidJ283rZdwhqITPtlsyMmTULml+QH+2ezgz+mhb
         RThiV3knEen9tsZBwANehtJmny2YZoh/QQcyVbuBEb1CJ4jJ7QwPqnfnDyIviRFppwiC
         l6Nw==
X-Gm-Message-State: AOJu0YzKmrEEdQ71wFNsQYFpKL8zcw/8ErNoKnlIy16i2Ef91skZsRjz
        7riaNC6xchtRrtgBkWkBYv20ezXA4HII8wnDVe4J
X-Google-Smtp-Source: AGHT+IH4UOT9KZGz6mMxMoKEsv724UIFMMXL1G/OLrTQrFR1/baKTwwLhVq6AEEM0LNJnjVnhlHHLhruUHmjvhx6gjE=
X-Received: by 2002:a0d:d9ca:0:b0:570:7b4d:f694 with SMTP id
 b193-20020a0dd9ca000000b005707b4df694mr3547864ywe.3.1693448783584; Wed, 30
 Aug 2023 19:26:23 -0700 (PDT)
MIME-Version: 1.0
References: <20230829175158.20202-1-phil@nwl.cc> <ZO9kberk3iNZv2qj@calendula> <ZO+sbVTuNOZ4hfOe@madcap2.tricolour.ca>
In-Reply-To: <ZO+sbVTuNOZ4hfOe@madcap2.tricolour.ca>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 30 Aug 2023 22:26:12 -0400
Message-ID: <CAHC9VhTJofX9c6fsB_x6wbmXunPjdaOjJe0o78AMrTHGcUAmdw@mail.gmail.com>
Subject: Re: [nf PATCH 1/2] netfilter: nf_tables: Audit log setelem reset
To:     Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, linux-audit@redhat.com,
        Richard Guy Briggs <rgb@redhat.com>, audit@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Aug 30, 2023 at 4:54=E2=80=AFPM Richard Guy Briggs <rgb@redhat.com>=
 wrote:
> On 2023-08-30 17:46, Pablo Neira Ayuso wrote:
> > On Tue, Aug 29, 2023 at 07:51:57PM +0200, Phil Sutter wrote:
> > > Since set element reset is not integrated into nf_tables' transaction
> > > logic, an explicit log call is needed, similar to NFT_MSG_GETOBJ_RESE=
T
> > > handling.
> > >
> > > For the sake of simplicity, catchall element reset will always genera=
te
> > > a dedicated log entry. This relieves nf_tables_dump_set() from having=
 to
> > > adjust the logged element count depending on whether a catchall eleme=
nt
> > > was found or not.
> >
> > Applied, thanks Phil
>
> Thanks Phil, Pablo.  If it isn't too late, please add my
> Reviewed-by: Richard Guy Briggs <rgb@redhat.com>

Similarly, you can add my ACK.  FWIW, if you're sending patches out
during the first few days of the merge window it might be advisable to
wait more than a day or two to give the relevant maintainers a chance
to review the patch.

Also, as a note for future submissions, we've moved the audit kernel
mailing list to audit@vger.kernel.org.

Acked-by: Paul Moore <paul@paul-moore.com>

--=20
paul-moore.com
