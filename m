Return-Path: <SRS0=BqdC=T5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E288C28CC1
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 May 2019 22:16:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA24D24285
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 May 2019 22:16:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore-com.20150623.gappssmtp.com header.i=@paul-moore-com.20150623.gappssmtp.com header.b="W488NziP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbfE2WQg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 29 May 2019 18:16:36 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:37355 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726454AbfE2WQb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 May 2019 18:16:31 -0400
Received: by mail-lj1-f194.google.com with SMTP id h19so4099504ljj.4
        for <netfilter-devel@vger.kernel.org>; Wed, 29 May 2019 15:16:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Oz7cGsD/P4AYjrQuzbhSqhrqwPvDYoZyUjrCxUd5apo=;
        b=W488NziPak7bX8NLwk8X91sVgaISEiHHggxPCEy5FTn4IJfjT1bBLLNUdZubDFWtPH
         7KoVKeHGWUJXYe/3LbLZBn7H5JwyXSUSceIdUccTOeecjr9Rha/esMd2v5J0QgIJpV+r
         w04dPFkQRPrhrAhVz6CVOLfdZR28+WrUYuPXRMr/nyIluc9YhOFeRWVGdDt44wALPWrq
         PIABiusmnwb5q3e6jTuVcyQq9WGF/T14PHNRDSG8TQJ0AL3qJIxSz6hon1W/8m1HgZoD
         RpTG7XBD0QK5YboiITTVwFV0joTjp8gpqwSWpkPmVhJkcpSP6IsYCYIr59Rl1ujOgBWb
         A8AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Oz7cGsD/P4AYjrQuzbhSqhrqwPvDYoZyUjrCxUd5apo=;
        b=DunS/+aIdUjhvKw2fJ7A/43FqFt55nAC9ynPym6tLi5wggiLCaEahRzmjmC0NpAOoG
         iC5L/r/beiSCh8rzJtIPtd8MNbq5Dnap07ko7+6H4BLXjaN9o/vbnb+HFVUOy3ptxI2Y
         Yvb9JuVUGqyQE9gyc4GS2HfHFwHTde/XcYkLnzFF90gBP49UuP9eVGD3WnE7Y9fJAJtG
         L5zKUMAayd3eSaRsU/9SDYT21vIe35n9pAKR10k6XuNSCLHgtCfR/DWtvMqm44dCNya9
         JCRIylfPod7PaollEJMewrhzAdMasHZ9MRzVfd1KYP5qxnRN7jKq1D55AF0yaI8lxW6V
         IF7A==
X-Gm-Message-State: APjAAAWd7nFFkFZEjX8drt5mBLPRYyI/5gptEqODDPu4GqOWY9xNrxhw
        vBG+MU/uXPOGA2Vtfq/cmExGTEJrvM6qTzKpKNxW
X-Google-Smtp-Source: APXvYqzfNdl8873L36TO9hSNPPYmytZePE3WW4+a9ltLKODcsNQS6Y9bUNbWImIKz7mxDt4DEezNtHhuOjvLWIqNvZM=
X-Received: by 2002:a2e:3e14:: with SMTP id l20mr137436lja.40.1559168188869;
 Wed, 29 May 2019 15:16:28 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1554732921.git.rgb@redhat.com> <0785ee2644804f3ec6af1243cc0dcf89709c1fd4.1554732921.git.rgb@redhat.com>
In-Reply-To: <0785ee2644804f3ec6af1243cc0dcf89709c1fd4.1554732921.git.rgb@redhat.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 29 May 2019 18:16:18 -0400
Message-ID: <CAHC9VhRV-0LSEcRvPO1uXtKdpEQsaLZnBV3T=zcMTZPN5ugz5w@mail.gmail.com>
Subject: Re: [PATCH ghak90 V6 08/10] audit: add containerid filtering
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com,
        simo@redhat.com, Eric Paris <eparis@parisplace.org>,
        Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com,
        nhorman@tuxdriver.com
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Apr 8, 2019 at 11:41 PM Richard Guy Briggs <rgb@redhat.com> wrote:
>
> Implement audit container identifier filtering using the AUDIT_CONTID
> field name to send an 8-character string representing a u64 since the
> value field is only u32.
>
> Sending it as two u32 was considered, but gathering and comparing two
> fields was more complex.
>
> The feature indicator is AUDIT_FEATURE_BITMAP_CONTAINERID.
>
> Please see the github audit kernel issue for the contid filter feature:
>   https://github.com/linux-audit/audit-kernel/issues/91
> Please see the github audit userspace issue for filter additions:
>   https://github.com/linux-audit/audit-userspace/issues/40
> Please see the github audit testsuiite issue for the test case:
>   https://github.com/linux-audit/audit-testsuite/issues/64
> Please see the github audit wiki for the feature overview:
>   https://github.com/linux-audit/audit-kernel/wiki/RFE-Audit-Container-ID
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> Acked-by: Serge Hallyn <serge@hallyn.com>
> Acked-by: Neil Horman <nhorman@tuxdriver.com>
> Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
> ---
>  include/linux/audit.h      |  1 +
>  include/uapi/linux/audit.h |  5 ++++-
>  kernel/audit.h             |  1 +
>  kernel/auditfilter.c       | 47 ++++++++++++++++++++++++++++++++++++++++++++++
>  kernel/auditsc.c           |  4 ++++
>  5 files changed, 57 insertions(+), 1 deletion(-)

...

> diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
> index 63f8b3f26fab..407b5bb3b4c6 100644
> --- a/kernel/auditfilter.c
> +++ b/kernel/auditfilter.c
> @@ -1206,6 +1224,31 @@ int audit_comparator(u32 left, u32 op, u32 right)
>         }
>  }
>
> +int audit_comparator64(u64 left, u32 op, u64 right)
> +{
> +       switch (op) {
> +       case Audit_equal:
> +               return (left == right);
> +       case Audit_not_equal:
> +               return (left != right);
> +       case Audit_lt:
> +               return (left < right);
> +       case Audit_le:
> +               return (left <= right);
> +       case Audit_gt:
> +               return (left > right);
> +       case Audit_ge:
> +               return (left >= right);
> +       case Audit_bitmask:
> +               return (left & right);
> +       case Audit_bittest:
> +               return ((left & right) == right);
> +       default:
> +               BUG();

A little birdy mentioned the BUG() here as a potential issue and while
I had ignored it in earlier patches because this is likely a
cut-n-paste from another audit comparator function, I took a closer
look this time.  It appears as though we will never have an invalid op
value as audit_data_to_entry()/audit_to_op() ensure that the op value
is a a known good value.  Removing the BUG() from all the audit
comparators is a separate issue, but I think it would be good to
remove it from this newly added comparator; keeping it so that we
return "0" in the default case seems reasoanble.

> +               return 0;
> +       }
> +}

--
paul moore
www.paul-moore.com
