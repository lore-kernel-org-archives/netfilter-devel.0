Return-Path: <SRS0=RvX8=7K=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5293C433DF
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 May 2020 18:51:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EE632073B
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 May 2020 18:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1590691903;
	bh=ET8yM6AWMNpDjaCHAyz3Kke+AsO4jCxWygmB2OrK0MQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=0pj70S1Dgni0NAdH1yOGRMnXRT683ksEsxlhGyQexr9V2/BFIJGxSNdW9vY48ZC+D
	 sYIKy6bXF6z3zEPJK2XFvWPSuw6YHfpWIqJr6O5VVVGMDCOdXc3M2vablyG4o2m/Dn
	 gD4KcfnUsidXo4lFVYWSp2c4QyWZS8cDJpfe/heM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405989AbgE1Svm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 28 May 2020 14:51:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405911AbgE1Svl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 May 2020 14:51:41 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34CB9C08C5C6
        for <netfilter-devel@vger.kernel.org>; Thu, 28 May 2020 11:51:41 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id 202so17191748lfe.5
        for <netfilter-devel@vger.kernel.org>; Thu, 28 May 2020 11:51:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AhLg0g9nIVFkh8Xej4e2gvlmNSMTD4F2E/T/7QsRMv8=;
        b=AYcUjneN2MB3Dg+M1pugzVZJdxa872FQyc0afbyKSWW1oWb/d1rwk9bn7+CzdK3mHa
         tArLlEWWcS0pmgUdgvh4UhxapiHNyCYitzgmuPpFaFrB1CcK1PCfLpwMLGY/rt9ZbGVr
         HuHNIUVtpMtoMJZ4AirU8Bfo1+H2VgFd0PSHQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AhLg0g9nIVFkh8Xej4e2gvlmNSMTD4F2E/T/7QsRMv8=;
        b=LbYG6G3E/7/jR9hgpbWBovBxh3AUbA8p7editPT1cv+fpzAdrkm4ek7DHp8XJYHfa2
         XDdBj0ng441Xju4p0M5q5a8pkF2DBw46MYh1fHueyxeEzuEcIX6/Nl58ZngsB7fXRR2v
         fICvpMe7vkOqCbww6O0wdqC3ac5R0oo1xlVzwUH2qD4cR21ZiJdimO+4DR/y09KdmICp
         YJNTiNPptW9lVeTdDV1TVf/i+nT4VBv1U2DIYBXIzIwTGyJuq3hk2KaNT00hyFggNm4E
         ycAisLJC68kOJdcZ4oPrShVsmEWhZftUJl1M4V04TSy0Y8fL5Gqh6xVxvTOsqkdCFGF+
         4gBg==
X-Gm-Message-State: AOAM533hoHXMjW13AN4YwcV60G/AMIOKciVFBlw54Tr1tPuuHZLCGlyz
        u1mykUpfh2V5T8Nhh3q3RTIJn0NpaLU=
X-Google-Smtp-Source: ABdhPJwVGScUZ9rEwvDWIGqvmwTT+XwikP9kNz1lodIeNHitO5KA1RcjHsnQC/9QSS7QRsdHMDS//Q==
X-Received: by 2002:a19:4b12:: with SMTP id y18mr2334820lfa.169.1590691898777;
        Thu, 28 May 2020 11:51:38 -0700 (PDT)
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com. [209.85.208.175])
        by smtp.gmail.com with ESMTPSA id a8sm1585319ljp.102.2020.05.28.11.51.37
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 May 2020 11:51:38 -0700 (PDT)
Received: by mail-lj1-f175.google.com with SMTP id e4so12265124ljn.4
        for <netfilter-devel@vger.kernel.org>; Thu, 28 May 2020 11:51:37 -0700 (PDT)
X-Received: by 2002:a2e:8090:: with SMTP id i16mr1927771ljg.421.1590691897249;
 Thu, 28 May 2020 11:51:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200528054043.621510-1-hch@lst.de>
In-Reply-To: <20200528054043.621510-1-hch@lst.de>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 28 May 2020 11:51:21 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj3iGQqjpvc+gf6+C29Jo4COj6OQQFzdY0h5qvYKTdCow@mail.gmail.com>
Message-ID: <CAHk-=wj3iGQqjpvc+gf6+C29Jo4COj6OQQFzdY0h5qvYKTdCow@mail.gmail.com>
Subject: Re: clean up kernel_{read,write} & friends v2
To:     Christoph Hellwig <hch@lst.de>
Cc:     Al Viro <viro@zeniv.linux.org.uk>, Ian Kent <raven@themaw.net>,
        David Howells <dhowells@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, May 27, 2020 at 10:40 PM Christoph Hellwig <hch@lst.de> wrote:
>
> this series fixes a few issues and cleans up the helpers that read from
> or write to kernel space buffers, and ensures that we don't change the
> address limit if we are using the ->read_iter and ->write_iter methods
> that don't need the changed address limit.

Apart from the "please don't mix irrelevant whitespace changes with
other changes" comment, this looks fine to me.

And a rant related to that change: I'm really inclined to remove the
checkpatch check for 80 columns entirely, but it shouldn't have been
triggering for old lines even now.

Or maybe make it check for something more reasonable, like 100 characters.

I find it ironic and annoying how "checkpatch" warns about that silly
legacy limit, when checkpatch itself then on the very next few lines
has a line that is 124 columns wide

And yes, that 124 character line has a good reason for it. But that's
kind of the point. There are lots of perfectly fine reasons for longer
lines.

I'd much rather check for "no deep indentation" or "no unnecessarily
complex conditionals" or other issues that are more likely to be
_real_ problems.  But do we really have 80x25 terminals any more that
we'd care about?

               Linus
