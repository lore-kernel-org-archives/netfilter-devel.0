Return-Path: <SRS0=FHqp=CT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DADE8C43461
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Sep 2020 21:22:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92AF0221E2
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Sep 2020 21:22:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yzqm9tzS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728101AbgIJVVw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Sep 2020 17:21:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731107AbgIJOYG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Sep 2020 10:24:06 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50CE5C06134A
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Sep 2020 07:08:47 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d19so974281pld.0
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Sep 2020 07:08:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=q5WwbPeAHuRjPPxhb/XjOn2rrKEN7d12WacysHr6e10=;
        b=Yzqm9tzSN96WHO0dhawZ3keI6Fy62S8UyghDp2xyjR2hctyQtK+mFMVCpPT5skpNKT
         SI1RNXb0pyJjuYueLCQ43oWxYTn5GZQlYS0mwEm12GcYCU+YKKnHhvmws9HedemrShsR
         SNOdAzgI9Rn0yZmCvydycZpwatx8jsA5zX1emyFUHKshp8utLqz0OQxSylpS99OV9bE/
         OrGp/ydcqSlQQgwndfrQGsh/OTTVV9w6V2eNLUT7w6+EEsSsvYkYJDdYpKcmVFV7M/b+
         xL1CSTCsId39pkIPhJe+rDZCdWDK6brR5VyS0oIZqChZv6wl8zLmO6T/gOdhtZ1X27B0
         ZgIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=q5WwbPeAHuRjPPxhb/XjOn2rrKEN7d12WacysHr6e10=;
        b=XE9GOqaikW3oOFfPb8QlNMKypG4SYXVh/Twn17ZN3TUpSewmrXmsjCz4vimFS14oHc
         1cA4fzryx4A5mDZrMyoy+13xpUb4CNkawSRiQoGFXia5W2FQDrl7niCXbVSr60Qmw5D6
         9boHZK7gcXRMekJ/mU5DDHLwD4iuKZGn0CKxiZPT1jzRqSFuUcc+EvS983IZyqDmAozN
         haPBq/WVOTnHytz58mBtHCO1waNBv55eoOg5xfhT9ucqoh52jdITggHo3ZhUisj5IBQ/
         Thf6DRpu8hGbWeJEjdFQTSWcm+evPxzri2jTgKZCrH47FJjFR+aOxA9x7RCY7oSSv4Rv
         uXfw==
X-Gm-Message-State: AOAM533BgxgcGnIf7gzROsYdR2n1r0swYNZgDu+08cvhHRITP5RAaS3C
        Kvgx9p7eG6f6Vo7sqClTS8B1h/fVdjHiTHRa6ea5/LVrNjI=
X-Google-Smtp-Source: ABdhPJxG6VmKrkMhX2c2Lld6MulfgnPOVff3voyphCQmnC6rQ5lBod8il4nKo47eQtPoj+tulN6CUUXXjRG25yfEyI0=
X-Received: by 2002:a17:90b:408b:: with SMTP id jb11mr141501pjb.164.1599746926628;
 Thu, 10 Sep 2020 07:08:46 -0700 (PDT)
MIME-Version: 1.0
From:   Amiq Nahas <m992493@gmail.com>
Date:   Thu, 10 Sep 2020 19:38:35 +0530
Message-ID: <CAPicJaGbaQqfNZe8EYFR3YMduDasAS-uR2UyjdtZpgQvHX_ZYQ@mail.gmail.com>
Subject: [iptables] Multiple labels simultaneously
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Guys,

To use multiple labels with connlabel module in iptables so that we
can do something like this:

iptables -t mangle -I PREROUTING -m connlabel --label "label1:label2:label3"

I made some changes in the libxt_connlabel.c and xt_connlabel.h as shown below.
Now, what changes need to be made in "xt_connlabel.c" module file?
Please advise how this can be done.

xt_connlabel.h:
...
struct xt_connlabel_mtinfo {
    __u16 bit[128];
    __u16 options;
    __u16 count;
};

libxt_connlabel.c:
...
static void connlabel_mt_parse(struct xt_option_call *cb)
{
    struct xt_connlabel_mtinfo *info = cb->data;
    int tmp;

    xtables_option_parse(cb);

    switch (cb->entry->id) {
    case O_LABEL:
        printf("cb->arg: %s\n", cb->arg);
        int len = strlen(cb->arg);
        if (len >= 200)
            xtables_error(PARAMETER_PROBLEM, "arg > 200 bytes\n");

        char temp_arg[200];
        char *token;
        int count = 0;
        strncpy(temp_arg, cb->arg, len);
        temp_arg[len] = '\0';
        printf("temp_arg: %s\n", temp_arg);

        token = strtok(temp_arg, ":");
        for(; token != NULL && count < 128; count++) {
            printf("token: %s \n", token);

            tmp = connlabel_value_parse(token);
            if (tmp < 0 && !connlabel_open())
                tmp = nfct_labelmap_get_bit(map, token);
            if (tmp < 0)
                xtables_error(PARAMETER_PROBLEM,
                      "label '%s' not found or invalid value",
                      token);
            info->bit[count] = tmp;
            token = strtok(NULL, ":");
        }
        info->count = count;
        printf("info->count: %d\n", info->count);

        if (cb->invert)
            info->options |= XT_CONNLABEL_OP_INVERT;
        break;
    case O_SET:
        info->options |= XT_CONNLABEL_OP_SET;
        break;
    }

}
