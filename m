From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH nf 1/2,v3] netfilter: nfnetlink_cthelper: fix runtime
 expectation policy updates
Date: Wed, 22 Mar 2017 13:38:08 +0800
Message-ID: <CAML_gOfHxD6ScxARXJBMtE0SvVDioKBUvipY9Hyk8hLQt0edqw@mail.gmail.com>
References: <1490108275-19537-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>, jeffy.chen@rock-chips.com,
        briannorris@chromium.org, dianders@chromium.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f66.google.com ([209.85.213.66]:36373 "EHLO
        mail-vk0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752173AbdCVFiK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Mar 2017 01:38:10 -0400
Received: by mail-vk0-f66.google.com with SMTP id d188so15825582vka.3
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Mar 2017 22:38:09 -0700 (PDT)
In-Reply-To: <1490108275-19537-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

2017-03-21 22:57 GMT+08:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> We only allow runtime updates of expectation policies for timeout and
> maximum number of expectations, otherwise reject the update.
>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> v3: Fixed expect_class_max semantics. Compile-tested only.

Acked-by: Liping Zhang <zlpnobody@gmail.com>

[...]
> +       /* Check first that all policy attributes are well-formed, so we don't
> +        * leave things in inconsistent state on errors.
> +        */

Good point, I missed this possible error scenario in my original patch 4/5.

> +       for (i = 0; i < helper->expect_class_max + 1; i++) {
> +
> +               if (!tb[NFCTH_POLICY_SET + i])
> +                       return -EINVAL;
> +
> +               err = nfnl_cthelper_update_policy_one(&helper->expect_policy[i],
> +                                                     &new_policy[i],
> +                                                     tb[NFCTH_POLICY_SET + i]);
> +               if (err < 0)
> +                       return err;
> +       }
> +       /* Now we can safely update them. */
