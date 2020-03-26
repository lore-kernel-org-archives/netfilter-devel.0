Return-Path: <SRS0=p5Wx=5L=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B8E1C43331
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Mar 2020 19:22:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 321752070A
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Mar 2020 19:22:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P/CZJzFV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbgCZTWV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 26 Mar 2020 15:22:21 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:43749 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbgCZTWU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Mar 2020 15:22:20 -0400
Received: by mail-lf1-f65.google.com with SMTP id n20so5848507lfl.10;
        Thu, 26 Mar 2020 12:22:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=dL5Dzf5r8PcP7cDL9x2KnB0YGaWxOuN4eYggn/+YMYw=;
        b=P/CZJzFVmgT8RV1QRSP3ZzId3qq2amzQePYbx2wD9fyBiIgolK7YuA7j3QVTIQmd7T
         YUVaWePtO7UZBEJfWfR6YLkojwPm4abhj8UaywXIE78JzMB7UnPna15HMnOZ7meG3WML
         KejgTfaXgZHcq4U88mvQHW5QOkHMK1MPEo09iWT7D0ozGnfZ6bRfpFJzejlrCWTQ03OU
         WU/2E78+dvtvGg7q0GmNY+25INuUcaNjBms8EgEAYg/1qHtMY5nza+4f9kE2hkSNWBQm
         lLgL7E3fVFUBa02UcmEZDKKRzKEIIlgoGsfXKMm/0UP5Frmyc/CSlI1uV9WJQJbMO3or
         qrBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=dL5Dzf5r8PcP7cDL9x2KnB0YGaWxOuN4eYggn/+YMYw=;
        b=p9829pU2SQlB6yd4orai1OWc19SZ1jXNwGOCSxaSSy58LBeVBEzDsUkc2LqyeZzyjT
         yvTU26hJ8E7ZdXKQP5mjTaB2KTnBDH0ELBG18QTnnI5Pk2kipteNhnGvvsZpK/HW+Ohq
         jTROazm1pIi054pT1ry7KhXXEdw+qJQpSVc14vjD0HXYclx4JtHiYf5PXHTXnf3wVgdo
         9oSseqUo2iHtXvAGPYNtDFSjZAiUG/UYsKT5ng6v0cpKAxUugpJ4Xky+jDfzNbiOWHQ0
         MOsw+2raLbETvSaS37olVQnaF0xswxFpGVfD+cTfwbdeeBGXwal9nBfEYikAxt0eTJL/
         m3Fw==
X-Gm-Message-State: ANhLgQ1VP5vmpzM25WwBhRd+sAx8qnxI7rq1hwV/JmaTNJ6WeZgzipDz
        0WfTNCCkpSUYUOVDEAZxGjvQq8I0aORuQ61vxJY=
X-Google-Smtp-Source: ADFU+vuSPxkCKN5ZH3PluGt3oLeOPzOKSdLYrz4OXdcbSr7OdtXMCwx+ritt3LSNUKwerZ1JbwJuODbTkb7zA1/lPmI=
X-Received: by 2002:ac2:4191:: with SMTP id z17mr6634762lfh.73.1585250537702;
 Thu, 26 Mar 2020 12:22:17 -0700 (PDT)
MIME-Version: 1.0
References: <CAHo-OoxMNBTDZW_xqp1X3SGncM-twAySrdnc=ntS7_e2j0YEaA@mail.gmail.com>
 <20200326142803.239183-1-zenczykowski@gmail.com> <20200326113048.250e7098@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAHo-OoxviTedR+dn5LaaKZtVWXR7bBTDzO23WfcB3kHGr6j48w@mail.gmail.com>
In-Reply-To: <CAHo-OoxviTedR+dn5LaaKZtVWXR7bBTDzO23WfcB3kHGr6j48w@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 26 Mar 2020 12:22:05 -0700
Message-ID: <CAADnVQK7bdMe1iygpHjEQL5GRtU0BDK01t5OLgorN-VUZCRHog@mail.gmail.com>
Subject: Re: [PATCH v2] iptables: open eBPF programs in read only mode
To:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>, Chenbo Feng <fengc@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Mar 26, 2020 at 11:34 AM Maciej =C5=BBenczykowski
<zenczykowski@gmail.com> wrote:
>
> > FWIW the BPF subsystem is about to break uAPI backward-compat and
> > replace the defines with enums. See commit 1aae4bdd7879 ("bpf: Switch
> > BPF UAPI #define constants used from BPF program side to enums").
>
> Shouldn't it do what is normally done in such a case?
> #define BPF_F_RDONLY BPF_F_RDONLY

No. just update the headers.
