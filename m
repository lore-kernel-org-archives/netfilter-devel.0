Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C0FBC433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 Jun 2022 20:12:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbiF2UM1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 29 Jun 2022 16:12:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231329AbiF2UMX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Jun 2022 16:12:23 -0400
Received: from mail-oa1-x31.google.com (mail-oa1-x31.google.com [IPv6:2001:4860:4864:20::31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 152A51F2D9
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Jun 2022 13:12:23 -0700 (PDT)
Received: by mail-oa1-x31.google.com with SMTP id 586e51a60fabf-fb6b4da1dfso22953073fac.4
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Jun 2022 13:12:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b7FcIAhLtymLPf8iqHW4cXWKn49EqgJY2vLBJQ/D4bE=;
        b=KEnEEv558bdDQcDHBeruYhrNJ6LUWgy/A+ZriKkVl3L7Es9q9kFVPnB3WQgw7Hg8b/
         X03ITwUI8BqDkEv0vmHIFy5vVm5M7ZUws86no7WKmZ5wj8EpW3SumytTaabn7YfHio/w
         OncfPPeQ/SZZTRrIR6L28/x3cqF+aloF4PBmaSrSIBj84GRpiiSk1SOfCzjAx5gYgqBc
         6qB2xgVh/ogbIO5Diyec7bx/6rGlEbpSuYt7iaKZir4TO1etGjN17sTvUwbVssHCDm1k
         krbIZuX0nKZMUkUwrc/uQ4He87uEh8gmEKX3c+G8bB8M0odcTRAzp3gi0pOP4VeByIUv
         FJHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b7FcIAhLtymLPf8iqHW4cXWKn49EqgJY2vLBJQ/D4bE=;
        b=xzf2BjJMH6J3nret8pyFsCRE4LIcC55YsBZwqR3QaCHohZHOg7q2i2cCg7euP9wNjd
         IUgnjLb9qP0ozAxO/xEGe6jTuISWZqqFvPakcsYL/8wI7UPgW4t7UggvKaWqFZyy8a5A
         EOfh4eKWRxLCIIh8SPlUFN6ZF6qNknJ2kGLTEoWEnv4boLb60zn2lABGslcNG69OeFWb
         1t/sjQ1SXbAN3kN5WZTY4pwPLT1umprnHqqFgcabWUtsLZtK7GOCxkSNSFJi0got7f/U
         XxomgTZ0OghvbByVezkpjCYRC8IsqN2FB9wpmRjrZH7OXFtYhhDTm47KnwRKFo37nQ9L
         o9dA==
X-Gm-Message-State: AJIora+N7ML9USi6rQlzGbwaK3T/9mSp2VzTXaPNjOSshtEvyQwifHBk
        de/K3tujIpykGmwcecIp8y/SeEZQQtsZZHXY5PPmY5pyY7M=
X-Google-Smtp-Source: AGRyM1t6a0fmrxClr00GZ5XQgd5lxVO1Q0QiB+xjIqbj0uKIQua59XGce9szkgEk/15ICAqkgouWkrV1SnIP9sd1UG4=
X-Received: by 2002:a05:6871:430e:b0:108:4f82:c56a with SMTP id
 lu14-20020a056871430e00b001084f82c56amr4052119oab.129.1656533542404; Wed, 29
 Jun 2022 13:12:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220629200545.75362-1-yuluo@redhat.com>
In-Reply-To: <20220629200545.75362-1-yuluo@redhat.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Wed, 29 Jun 2022 16:11:51 -0400
Message-ID: <CADvbK_f7XSy1aB_P4Q3B8iHcQWMgTv3rw3JE_X8iH7u0FnJghw@mail.gmail.com>
Subject: Re: [PATCH] xt_sctp: support a couple of new chunk types
To:     Yuxuan Luo <luoyuxuan.carl@gmail.com>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Yuxuan Luo <yuluo@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jun 29, 2022 at 4:07 PM Yuxuan Luo <luoyuxuan.carl@gmail.com> wrote:
>
> There are new chunks added in Linux SCTP not being traced by iptables.
>
> This patch introduces the following chunks for tracing:
> I_DATA, I_FORWARD_TSN (RFC8260), RE_CONFIG(RFC6525) and PAD(RFC4820)
>
> Signed-off-by: Yuxuan Luo <luoyuxuan.carl@gmail.com>
> ---
>  extensions/libxt_sctp.c   | 4 ++++
>  extensions/libxt_sctp.man | 4 +++-
>  2 files changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/extensions/libxt_sctp.c b/extensions/libxt_sctp.c
> index a4c5415f..3fb6cf1a 100644
> --- a/extensions/libxt_sctp.c
> +++ b/extensions/libxt_sctp.c
> @@ -112,9 +112,13 @@ static const struct sctp_chunk_names sctp_chunk_names[]
>      { .name = "ECN_ECNE",      .chunk_type = 12,  .valid_flags = "--------", .nftname = "ecne" },
>      { .name = "ECN_CWR",       .chunk_type = 13,  .valid_flags = "--------", .nftname = "cwr" },
>      { .name = "SHUTDOWN_COMPLETE", .chunk_type = 14,  .valid_flags = "-------T", .nftname = "shutdown-complete" },
> +    { .name = "I_DATA",                .chunk_type = 64,   .valid_flags = "----IUBE", .nftname = "i-data"},
> +    { .name = "RE_CONFIG",     .chunk_type = 130,  .valid_flags = "--------", .nftname = "re-config"},
> +    { .name = "PAD",           .chunk_type = 132,  .valid_flags = "--------", .nftname = "pad"},
>      { .name = "ASCONF",                .chunk_type = 193,  .valid_flags = "--------", .nftname = "asconf" },
>      { .name = "ASCONF_ACK",    .chunk_type = 128,  .valid_flags = "--------", .nftname = "asconf-ack" },
>      { .name = "FORWARD_TSN",   .chunk_type = 192,  .valid_flags = "--------", .nftname = "forward-tsn" },
> +    { .name = "I_FORWARD_TSN", .chunk_type = 194,  .valid_flags = "--------", .nftname = "i-forward-tsn" },
>  };
>
>  static void
> diff --git a/extensions/libxt_sctp.man b/extensions/libxt_sctp.man
> index 3e5ffa09..06da04f8 100644
> --- a/extensions/libxt_sctp.man
> +++ b/extensions/libxt_sctp.man
> @@ -19,12 +19,14 @@ Match if any of the given chunk types is present with given flags.
>  only
>  Match if only the given chunk types are present with given flags and none are missing.
>
> -Chunk types: DATA INIT INIT_ACK SACK HEARTBEAT HEARTBEAT_ACK ABORT SHUTDOWN SHUTDOWN_ACK ERROR COOKIE_ECHO COOKIE_ACK ECN_ECNE ECN_CWR SHUTDOWN_COMPLETE ASCONF ASCONF_ACK FORWARD_TSN
> +Chunk types: DATA INIT INIT_ACK SACK HEARTBEAT HEARTBEAT_ACK ABORT SHUTDOWN SHUTDOWN_ACK ERROR COOKIE_ECHO COOKIE_ACK ECN_ECNE ECN_CWR SHUTDOWN_COMPLETE I_DATA RE_CONFIG PAD ASCONF ASCONF_ACK FORWARD_TSN I_FORWARD_TSN
>
>  chunk type            available flags
>  .br
>  DATA                  I U B E i u b e
>  .br
> +I_DATA                I U B E i u b e
> +.br
>  ABORT                 T t
>  .br
>  SHUTDOWN_COMPLETE     T t
> --
> 2.31.1
>

Reviewed-by: Xin Long <lucien.xin@gmail.com>

(This is a patch for iptables.)
