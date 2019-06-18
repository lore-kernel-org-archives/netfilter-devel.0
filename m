Return-Path: <SRS0=xYYy=UR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53E6AC31E51
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 13:39:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2691720873
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 13:39:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RR5kFCOI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbfFRNjv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Jun 2019 09:39:51 -0400
Received: from mail-ed1-f41.google.com ([209.85.208.41]:46235 "EHLO
        mail-ed1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725919AbfFRNjv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Jun 2019 09:39:51 -0400
Received: by mail-ed1-f41.google.com with SMTP id d4so21778145edr.13
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jun 2019 06:39:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oeybr7dI+Lu86DgNCbmW7iDxBrjLJYKLMpG8NqEkRpc=;
        b=RR5kFCOIIf2+zfPvGRDZZNu1ydRPPFOcWnFF63wTcjjV6uivCYaPyXiFjVZBjk6SAE
         TyBWls8rWFoD93xp+P8LWvZZrxrSSc1CdkNHG5j/kbuWhLinck9NAd7BlvZcPclPGC4S
         f2SnLpU9ZIHfMV7c3ZB8GkOpubbvp2ernpmgPwFRBVRROspMzb3yGN9DRN4qk+a0Gf2e
         vp+fBKMglexH+FDAo8wQTYme6/rdBtfv59GRitogfGG6QPPXzvt2phO+aNwcms+ADQBd
         5edqxcLcgmqgrC6vsJ9aOD6R7oBxUxqTCEaDoflJKsHgodqJzpqY3UHnKO3RS632Jogk
         EIVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oeybr7dI+Lu86DgNCbmW7iDxBrjLJYKLMpG8NqEkRpc=;
        b=MGShYeAtqan/CXlueR6jox0V9QE2tM07RCkSmvlcovEBpS8GK/4aZNQOFMqv0iHeRL
         3yrtTFynvxMoYJ+KAXpIUh3LnRJe1/D9W4uYmqLKKyt5/KkQjq0tbEREQ3vNg/nu7MYt
         NUqSCIPudUsM94oN+6YciYRznI/FCI23wsXE8GhWALIkRj9ajQdiFpd34H/4g70IOyiC
         gdlYPm/Li8UIv+HuihJyI8mn4qD5emDgCJPhQVjqLnDYM1gvkUm4uvtPL5fauCsKnozN
         qsnzjaynOyxkm4o9JZb6JvOFQiIcK21277aENEtTMZFux050FVTiTg1l0SAYJ2s3PyJx
         +D9w==
X-Gm-Message-State: APjAAAW3c7zVKAQ+R2f5j8gsvDhy0YuvKT4rXHdJvrfL8WEHIy2njFA2
        /7HscE9gnL/Do/uLUVZa4q3/ofhc0cUfW1nNHdk=
X-Google-Smtp-Source: APXvYqxgH90Lobv1iJc/kDa0KxQYZetFRiR8N36OY1cAyz1HAIdB0dgLOQaOhIMy+sTRfcU24AgK5IIRzJXSV7rbxkg=
X-Received: by 2002:a50:cac1:: with SMTP id f1mr123452900edi.97.1560865189884;
 Tue, 18 Jun 2019 06:39:49 -0700 (PDT)
MIME-Version: 1.0
References: <CABVi_Eyws89e+y_4tGJNybGRdL4AarHG6GkNB0d0MGgLABuv3w@mail.gmail.com>
 <20190618095021.doh6pc7gzah3bnra@breakpoint.cc> <CABVi_EyyV6jmB8SxuiUKpHzL9NwMLUA1TPk3X=SOq58BFdG9vA@mail.gmail.com>
 <20190618105613.qgfov6jmnov2ba3e@breakpoint.cc> <CABVi_ExMpOnaau6sroSXd=Zzc4=F6t0Hv5iCm16q0jxqp5Tjkg@mail.gmail.com>
 <20190618132350.phtpv2vhteplfj32@breakpoint.cc>
In-Reply-To: <20190618132350.phtpv2vhteplfj32@breakpoint.cc>
From:   Mojtaba <mespio@gmail.com>
Date:   Tue, 18 Jun 2019 18:09:38 +0430
Message-ID: <CABVi_Ey3cHVdnpzRFo_yPFKkPveXeia7WBV4S9iPxPotLkCpuQ@mail.gmail.com>
Subject: Re: working with libnetfilter_queue and linbetfilter_contrack
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Thanks a lot.
Then let me describe what i am doing.
In VoIP networks, One of the ways to solve the one-way audio issue is
TURN. In this case both endpoint have to send their media (voice as
RTP) to server. In this conditions the server works as B2BUA. Because
of the server is processing the media (get media from one hand and
relay it to another hand), It usages a lot of resource of server. So I
am implementing  a new module to do this in kernel level. I test this
idea in my laboratory by adding conntrack entry manually in server and
all things works great. But i need to get more  idea to do this
project in best way and high performance, because the QoS very
importance in VoIP networks. What is the best way? Let me know more
about this.
With Best Regards.Mojtaba

On Tue, Jun 18, 2019 at 5:53 PM Florian Westphal <fw@strlen.de> wrote:
>
> Mojtaba <mespio@gmail.com> wrote:
> > Thanks Florian so much.
> > According the last paragraf of email i get the best way is i should use
> > libnetfilter_conntrack to insert a new conntrack entry in my userspace that
> > is called from raw PREROUTING table as NQUEUE callback queue.
> > Is it right underestanding?
>
> Yes, but since you did not exactly say what you're trying to do
> there might be better ways (ipvs, nft maps, etc).
>
> Nfqueue is slow.



-- 
--Mojtaba Esfandiari.S
