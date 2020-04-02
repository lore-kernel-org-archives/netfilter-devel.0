Return-Path: <SRS0=05X/=5S=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0168FC43331
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Apr 2020 13:32:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4BB7206E9
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Apr 2020 13:32:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=untangle.com header.i=@untangle.com header.b="AdaaY+gn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388311AbgDBNcV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Apr 2020 09:32:21 -0400
Received: from mail-vs1-f41.google.com ([209.85.217.41]:42059 "EHLO
        mail-vs1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387752AbgDBNcV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Apr 2020 09:32:21 -0400
Received: by mail-vs1-f41.google.com with SMTP id s10so2236587vsi.9
        for <netfilter-devel@vger.kernel.org>; Thu, 02 Apr 2020 06:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=untangle.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qbxYEcxLIAfmwv8/JFI5XlK7N/zQk0sceuC21pvNkUA=;
        b=AdaaY+gn4z7+BZ2xgWzQadQI7VaB3LbrQp8VRIoUic6M+z7EtYYK2rlHlrs2psSrIc
         OtksR+m+TO7hqyOdk4T6DAile9TGDoQhFLfSf7sjPltqkAEDCYZNpBjfiVmwl+Abv3AQ
         gLtbkxRtXJG0EhJ4iyC5KZ6Bfea2ho09JQUcs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qbxYEcxLIAfmwv8/JFI5XlK7N/zQk0sceuC21pvNkUA=;
        b=BRYCCr20iWbB4gLqf4D0BVHqm0NzGrG+BS5C7HHx5DRy800KrYr+4Lw5RudnXzmvzc
         S39kENOyHBLqEDXbGRiQhzRLoR5EmFrTQ+LDV+tUiNqTq8lLWHQe8wbUCYyh6sL7Qy0Y
         9Jc0LjfP8Mr/VkVvHZTVCYFvDWESZ2b+JV/e/Dmp0N7ZXmx/sjUcScCXibceuUUq33rP
         R8/VxdhIbgKr5uLzlfOaF7TIIsyI8yr7Mg00thK7F7ayarCeCrtCRZkYktjcWyJypnv2
         Tug80AMwhXCGGJ9zY79NrL6yoEUBcb1IcVjep4KphBLGmpKWDFsgOT7P3QDBGTSLG5Zn
         JKsw==
X-Gm-Message-State: AGi0PubQb65xXT0fqjnCBkPM95pP3qBZo4YMIkSNx58bTVJSj7ztpDVf
        ylWACkZuF6GtWNFYajJpiMvZiH2vXK9TFcMnHURSyA==
X-Google-Smtp-Source: APiQypIzo5JZ4FoCUGL923E9gS/mAOA37qSLNmFR6zs1LpS6Fzg9QMVVfzTzIN8sXVW82JloTmnXGJkHqmSXXhdX11U=
X-Received: by 2002:a67:fa08:: with SMTP id i8mr2107813vsq.64.1585834339872;
 Thu, 02 Apr 2020 06:32:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200401143114.yfdfej6bldpk5inx@salvia> <8174B383-989D-4F9D-BDCA-3A82DE5090D2@gmail.com>
 <20200402124744.GY7493@orbyte.nwl.cc> <60AB079D-9481-4767-9E07-BDEE7E691B6B@gmail.com>
In-Reply-To: <60AB079D-9481-4767-9E07-BDEE7E691B6B@gmail.com>
From:   Brett Mastbergen <bmastbergen@untangle.com>
Date:   Thu, 2 Apr 2020 09:32:08 -0400
Message-ID: <CANBx8VBF2LuGoE2dODLB_3mQixj5YUQTvvsaUTDyNniwb-Ti4w@mail.gmail.com>
Subject: Re: [ANNOUNCE] nftables 0.9.4 release
To:     sbezverk <sbezverk@gmail.com>
Cc:     Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter <netfilter@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        netdev@vger.kernel.org, lwn@lwn.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

I need to revisit this patch, as I THINK the typeof support for maps
gets us close to where we want to be.


On Thu, Apr 2, 2020 at 8:52 AM sbezverk <sbezverk@gmail.com> wrote:
>
> Hi Phil,
>
> Thank you for letting me know, indeed it is sad, but hopefully it will ge=
t in sooner rather than later.
>
> Best regards
> Serguei
>
> =EF=BB=BFOn 2020-04-02, 8:47 AM, "Phil Sutter" <n0-1@orbyte.nwl.cc on beh=
alf of phil@nwl.cc> wrote:
>
>     Hi Serguei,
>
>     On Thu, Apr 02, 2020 at 08:38:10AM -0400, sbezverk wrote:
>     > Did this commit make into 0.9.4?
>     >
>     > https://patchwork.ozlabs.org/patch/1202696/
>
>     Sadly not, as it is incomplete (anonymous LHS maps don't work due to
>     lack of type info). IIRC, Florian wanted to address this but I don't
>     know how far he got with it.
>
>     Cheers, Phil
>
>
>
