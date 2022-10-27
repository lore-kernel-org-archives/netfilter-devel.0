Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 448CBFA3743
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Oct 2022 20:15:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236754AbiJ0UPy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 27 Oct 2022 16:15:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236356AbiJ0UPx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Oct 2022 16:15:53 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 502B260C8F
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Oct 2022 13:15:52 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id i10so1817704qkl.12
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Oct 2022 13:15:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=PkxtUHaGFDycP6D2luIHLSXJkXOzlvpiMUNbGq0VIDw=;
        b=AiYRsbNPUrZt3HPq+xtJfDrvafoV3sgbBvDsYvDt8alNybjtz3OkR1xymRkE3QILqj
         mmJ4n9e+K/PVts3cQ2eJ5htk2mJ+mPxzhWMdsaeW6GINZP2CIccvVT49FekPjg7PRFXI
         92WGHwoPAVqBkaMzcdjnmCw5MEE1uFvTm34eA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PkxtUHaGFDycP6D2luIHLSXJkXOzlvpiMUNbGq0VIDw=;
        b=eRU3y5TbQBRCwXNZa8v6HjtLJSCkDaWrHjqsoxbnYNOC8KaNAsZIvdtM3kA3TGZdht
         SqlGY4monpGpNGRyiri/Q+8eU6w2Dho1qkZ/06xdmhQqzsgW2YL2ZlpaPKunzvDl7YsX
         APQmdTl6EwDRBYAUG3KTP0nSOvGAFtkC9pJglhG6ze7R8+kFXrUCabk63lXCv+Ssk4iE
         DM/olZi5x1cUb+Kvp96KCjIl/qMFAfCyOk92zxd4PqRXNL4SHk2KGZG+uY1l8phVCffH
         94/btycJqMaIn4G/UbrGeOLujR6aLHad4/YLHnVwaNEwJa9AXH1wDyn3XZIjnsG8t/nS
         +/dw==
X-Gm-Message-State: ACrzQf13pzyrFptcIw75gqlv4IFoB0D0qXFTVUf3EhhmJzqI8ep9uVp3
        2TSgq6PdkM7ymD+jwqkHrvZ5ZgjIPbW8kQ==
X-Google-Smtp-Source: AMsMyM6otdJG7cWsExmPKduc2ET/rw9AH1h3fdRzyM/ByNUxguncwaO0b0PlitUzcbXv41JGqZ8xMw==
X-Received: by 2002:a05:620a:9de:b0:6ec:3243:b9df with SMTP id y30-20020a05620a09de00b006ec3243b9dfmr36229002qky.623.1666901751754;
        Thu, 27 Oct 2022 13:15:51 -0700 (PDT)
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com. [209.85.128.179])
        by smtp.gmail.com with ESMTPSA id bm11-20020a05620a198b00b006e42a8e9f9bsm1523605qkb.121.2022.10.27.13.15.51
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Oct 2022 13:15:51 -0700 (PDT)
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-369426664f9so27396257b3.12
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Oct 2022 13:15:51 -0700 (PDT)
X-Received: by 2002:a81:d34c:0:b0:349:1e37:ce4e with SMTP id
 d12-20020a81d34c000000b003491e37ce4emr46057341ywl.112.1666901739776; Thu, 27
 Oct 2022 13:15:39 -0700 (PDT)
MIME-Version: 1.0
References: <20221027150525.753064657@goodmis.org> <20221027150928.780676863@goodmis.org>
 <20221027155513.60b211e2@gandalf.local.home>
In-Reply-To: <20221027155513.60b211e2@gandalf.local.home>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 27 Oct 2022 13:15:23 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjAjW2P5To82+CAM0Rx8RexQBHPTVZBWBPHyEPGm37oFA@mail.gmail.com>
Message-ID: <CAHk-=wjAjW2P5To82+CAM0Rx8RexQBHPTVZBWBPHyEPGm37oFA@mail.gmail.com>
Subject: Re: [RFC][PATCH v2 19/31] timers: net: Use del_timer_shutdown()
 before freeing timer
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Menglong Dong <imagedong@tencent.com>,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        bridge@lists.linux-foundation.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, lvs-devel@vger.kernel.org,
        linux-afs@lists.infradead.org, linux-nfs@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Oct 27, 2022 at 12:55 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> I think we need to update this code to squeeze in a del_timer_shutdown() to
> make sure that the timers are never restarted.

So the reason the networking code does this is that it can't just do
the old 'sync()' thing, the timers are deleted in contexts where that
isn't valid.

Which is also afaik why the networking code does that whole "timer
implies a refcount to the socket" and then does the

    if (del_timer(timer))
           sock_put()

thing (ie if the del_timer failed - possibly because it was already
running - you leave the refcount alone).

So the networking code cannot do the del_timer_shutdown() for the same
reason it cannot do the del_timer_sync(): it can't afford to wait for
the timer to stop running.

I suspect it needs something like a new "del_timer_shutdown_async()"
that isn't synchronous, but does that

 - acts as del_timer in that it doesn't wait, and returns a success if
it could just remove the pending case

 - does that "mark timer for shutdown" in that success case

or something similar.

But the networking people will know better.

               Linus
