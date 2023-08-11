Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E59EDC001DE
	for <netfilter-devel@archiver.kernel.org>; Fri, 11 Aug 2023 12:59:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbjHKM7c (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 11 Aug 2023 08:59:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbjHKM7c (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 11 Aug 2023 08:59:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B90A7119
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Aug 2023 05:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691758733;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QpkcRcv9M2IrEGdTxWn63t7XdhO5s6HMLm6pgncVFiw=;
        b=SyKzGNjtevpbJDdzkJvDLG6Jm/KzgO8xy7EqftwNgPN0Q5y2a2C9ok27bfZXaUbfi1KfTf
        7uKmb4bZNWvtJxgOAAE39myD+yb9iuSryKPG3cUJ7DHX0wdHEZAom2JnH5+f8sY/p9zsiJ
        oXzXJsE695142hnZpZAFsjwAGK48UcU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-158-u3OCiL0HOEW6ptIIJ542eg-1; Fri, 11 Aug 2023 08:58:51 -0400
X-MC-Unique: u3OCiL0HOEW6ptIIJ542eg-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-3fe12bf2db4so4173705e9.0
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Aug 2023 05:58:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691758730; x=1692363530;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QpkcRcv9M2IrEGdTxWn63t7XdhO5s6HMLm6pgncVFiw=;
        b=Nf/MCYF28PbtKDH9YOsyFKC5Z4faNaGrSE9SDnZnyucS3iWN89RE77TDrUhEymiCjC
         qKH6IR0ON1g/EJ1M4pZhJd360ubJFYRoN2Z/dWG0cB51gHiJ+0jHwSTxg5j5TNzuJOiA
         P+G+mJx1gDqKJdUhJUMWZk0Cxd7+1eb7/z0q0YMv7m74d7j4bF5O5RDd/VBgaelNaTyW
         UpGgPGAGo7o9VEckJ2TIAoZp5b6ttTc1PNcz0qvsQupnkNjbIW32owvN4vJ2dwL709+K
         wdtxSveKDasrTI29zq7kKlPiKo2FweZUIuhIYqcLLNWcin1sWaT45lGhMRtncKpE5x0N
         0m8w==
X-Gm-Message-State: AOJu0YzNkpSr5nNh8jf2UR9HCs1AnbkCCAxsvI/6R2m7Art4MUlXaxDD
        8tqAOothDp+VyhtOOhaFG66qsMX/TPeFS8bFs0OmOVDjCjQqomdODzq7DmoYMBbi1ljrMnIW/Ri
        Pb7hp9fRhWfMcVl9xAyw6lI+UozgFMEJFU2T6
X-Received: by 2002:a05:600c:34cb:b0:3fe:4d2d:f79b with SMTP id d11-20020a05600c34cb00b003fe4d2df79bmr1774656wmq.4.1691758730189;
        Fri, 11 Aug 2023 05:58:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFZxV3SBGSHcQYRdXrOIqN520b6zkU+yyb7y72zDMbE5j6NFi/HeinqiBPvRludX7c4sf0FOA==
X-Received: by 2002:a05:600c:34cb:b0:3fe:4d2d:f79b with SMTP id d11-20020a05600c34cb00b003fe4d2df79bmr1774648wmq.4.1691758729921;
        Fri, 11 Aug 2023 05:58:49 -0700 (PDT)
Received: from [10.0.0.196] ([37.186.180.70])
        by smtp.gmail.com with ESMTPSA id 17-20020a05600c231100b003fc01495383sm8170478wmo.6.2023.08.11.05.58.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Aug 2023 05:58:49 -0700 (PDT)
Message-ID: <c5d1ed7aa26a439314fd26a959fd03b77d7ee7c0.camel@redhat.com>
Subject: Re: [nft PATCH] src: use reentrant
 getprotobyname_r()/getprotobynumber_r()/getservbyport_r()
From:   Thomas Haller <thaller@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Date:   Fri, 11 Aug 2023 14:58:48 +0200
In-Reply-To: <ZNYng8dQBhk48kj9@calendula>
References: <20230810123035.3866306-1-thaller@redhat.com>
         <ZNYng8dQBhk48kj9@calendula>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Fri, 2023-08-11 at 14:20 +0200, Pablo Neira Ayuso wrote:
> On Thu, Aug 10, 2023 at 02:30:30PM +0200, Thomas Haller wrote:
> > If the reentrant versions of the functions are available, use them
> > so
> > that libnftables is thread-safe in this regard.
>=20
> At netlink sequence tracking is not thread-safe, users hit EILSEQ
> errors when multiple threads recycle the same nft_ctx object. Updates
> are serialized by mutex per netns, batching is usually the way to go
> to amortize the cost of ruleset updates.

The problem already happens when one thread is using libnftables and
another thread calls one of those libc functions at an unfortunate
moment. It doesn't require multi-threaded uses of libnftables itself.

Also, why couldn't you have two threads, handling one netns each, with
separate nft_ctx objects?



> Are you planning to have a user of libnftables that is multi-thread?

No, I don't :) I was just interested in this topic.


Thomas

