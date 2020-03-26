Return-Path: <SRS0=p5Wx=5L=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BE86C2D0E8
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Mar 2020 14:08:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF66E206F8
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Mar 2020 14:08:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iTYsu7VR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727873AbgCZOIi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 26 Mar 2020 10:08:38 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:46855 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727738AbgCZOIi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Mar 2020 10:08:38 -0400
Received: by mail-lj1-f196.google.com with SMTP id v16so6481385ljk.13;
        Thu, 26 Mar 2020 07:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R7x3umP2TC8yakU3v+4oGVQPiE6U9RCWnMT+EnTIY9Q=;
        b=iTYsu7VRBOnAmTI6XomnCN2ybWI9U0tOpz3CxtwfzF1N90UH42tDHCwJXgxhYp922O
         0C5rMayQrmRHP92FPzizJeJBjG8L1CWc8wgJtlSYLeaAuXYkNInakzfgZN6RP68wPgKH
         SDw//ZM4grCNLRCTE+bLt99D1OF4xzUlot5a0IOyRMLq+0VCcbWOEmXI4uE4k1sqwulS
         yzdDpLZ7L8frOMnls9EDRJQ6upX2QbE9qMRxWHKn4l+EaQ/rywfvC84VbDZeRuh3qQPM
         vAR8ZCM5j6o48D+EWXn8AFt5nhEqwfDPIzYOvz9dENqh7XTomoX+yrY8jWaxqODdwv62
         Ri7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R7x3umP2TC8yakU3v+4oGVQPiE6U9RCWnMT+EnTIY9Q=;
        b=UpxBI8Pudli+Q4gL+FRBnN4Fi1lgaGLdQGH4/l4GiG6ZWNSJNt51pbOBgPlT9JeXYP
         cM9NUEzlIWRmQ8JBbe/1rxjumPJ0eNvGT0SDJ8njBvmy3NPjTJkcj6vdWhYlkcbuIc1C
         8CSAsgm3COOh6mmGhvGdvqZg8HxOAWRLi2dxgVjVBdZNsImzOKa6GF+QW0cGt0O58g8l
         2XtgBtje+1PZ8t6DOI50E3GMKeYqAO6cpUUVOCdASW0y6oS/9q72eO+y9SnxgRFWKDC3
         XOss8zrsOyo2VjZghvDMyY6n4o714maTTnaDC8abj/4kxrM7UJbyaFwueZwivSBMlCDp
         /A+A==
X-Gm-Message-State: ANhLgQ30GucujlWoPhJkiJgWYXgMnDSv+/SteNprrkQHuFcS8H0xZvO2
        kAwnMpo7enzLh3d5Yb7pYHkJcGOXC0mR7Iu2E3Q=
X-Google-Smtp-Source: APiQypL2ITPgEyKcIB4qHYywBAu/yj01FLJuKbS/ks+hfCR70uE+j52PvH+eao8BB15TBwwsRfuspoEqQ++36yImUnc=
X-Received: by 2002:a2e:97c2:: with SMTP id m2mr5219178ljj.228.1585231715054;
 Thu, 26 Mar 2020 07:08:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200320030015.195806-1-zenczykowski@gmail.com> <20200326135959.tqy5i4qkxwcqgp5y@salvia>
In-Reply-To: <20200326135959.tqy5i4qkxwcqgp5y@salvia>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Thu, 26 Mar 2020 07:08:24 -0700
Message-ID: <CAHo-OoyGEPKdU5ZEuY29Zzi4NGzD-QMw7Pb-MTXjdKTj-Kj-Pw@mail.gmail.com>
Subject: Re: [PATCH] iptables: open eBPF programs in read only mode
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Netfilter Development Mailinglist 
        <netfilter-devel@vger.kernel.org>, Chenbo Feng <fengc@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

I don't get it.  It builds for me.

And it doesn't if I insert an intentional syntax error in the same line,
so I'm definitely compiling exactly that code.
