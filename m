Return-Path: <SRS0=mIA1=V7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEEEDC31E40
	for <netfilter-devel@archiver.kernel.org>; Sat,  3 Aug 2019 16:34:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BCAE42073D
	for <netfilter-devel@archiver.kernel.org>; Sat,  3 Aug 2019 16:34:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388591AbfHCQer (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 3 Aug 2019 12:34:47 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:36014 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388523AbfHCQer (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 3 Aug 2019 12:34:47 -0400
Received: by mail-lf1-f66.google.com with SMTP id j17so1019379lfp.3
        for <netfilter-devel@vger.kernel.org>; Sat, 03 Aug 2019 09:34:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eyxZxTomFfPbWiAetqtPgtMLib3xCsrhPFW0Jq8wnRg=;
        b=VZEHHIYoF3QFPjQPu+AgKpW1hUWFUDGsNErnhvTj4LwyrObZRU8rrBkG1ORtFBTb41
         IXGUtqIGB2vCsDZGrTjbTHMvH0VxtLKcWWOrv1v+9VwDOaWrnALRmP4DhJV2nybWyEuj
         Vh6+BRqB4TtPLpFzdMC+GsuyDhCOajIKx7X1EEJyy0GjRSrV0QpmYpHi5R6SMlrYtoO5
         L2sD8ZoysCqWP37V1TN01JJzILJDJFx0zWBRmYIkDdhiTyQQ4MK06I/vNLHzbNwZXg7U
         g6qx8s+tUE7JHrotg+w1FTnw0/+gxIvPVJcLW51KAkKxGmAS5aXkRvdWAkau/aMG5FRG
         Xl+A==
X-Gm-Message-State: APjAAAVZB7VajCDr4Dn2WwAmbtKMduLEiCwIJ99mPPVIEwo/cLY+FiVi
        qoR21CVRnjNhgLCLAGCb4SUDuDUgwTFqwT64VclB3Q==
X-Google-Smtp-Source: APXvYqy2Yn4aNBXqRTmW3Ppvae/bzICtUWoK0tK6vCVVBLGba1dgdveQnO4z/rXVFxBcOKGNWGfaP8kwPA571wDc03U=
X-Received: by 2002:a19:ed07:: with SMTP id y7mr28943779lfy.56.1564850085457;
 Sat, 03 Aug 2019 09:34:45 -0700 (PDT)
MIME-Version: 1.0
References: <20190723012303.2221-1-mcroce@redhat.com>
In-Reply-To: <20190723012303.2221-1-mcroce@redhat.com>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Sat, 3 Aug 2019 18:34:09 +0200
Message-ID: <CAGnkfhwen3p9T3mNL3w6dQcLFFDUtfn4g-j=6yoda2o+TpGR5w@mail.gmail.com>
Subject: Re: [PATCH net-next] netfilter: conntrack: use shared sysctl constants
To:     netdev <netdev@vger.kernel.org>, netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jul 23, 2019 at 3:23 AM Matteo Croce <mcroce@redhat.com> wrote:
>
> Use shared sysctl variables for zero and one constants, as in commit
> eec4844fae7c ("proc/sysctl: add shared variables for range check")
>
> Fixes: 8f14c99c7eda ("netfilter: conntrack: limit sysctl setting for boolean options")
> Signed-off-by: Matteo Croce <mcroce@redhat.com>
>

followup, can anyone review it?

Thanks,
-- 
Matteo Croce
per aspera ad upstream
