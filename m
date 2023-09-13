Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A16AEDEC73
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Sep 2023 15:33:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbjIMPdh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 Sep 2023 11:33:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbjIMPdf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Sep 2023 11:33:35 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6BB71724;
        Wed, 13 Sep 2023 08:33:31 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id 98e67ed59e1d1-26b41112708so5510506a91.3;
        Wed, 13 Sep 2023 08:33:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694619211; x=1695224011; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=LsIGUVYLG51ZiWYJq7FwzO7gDs/2DvpvrxoOWIorm5c=;
        b=YVAsNLcw19E+fD/tOBmYWo16Cx0Z+hK1DpZVcdGzfUs7OAp3Gg8urLA9E/JIhpBL0u
         WPujZQBaUINbV/ky5RopMd6oKB0oRDGYL7NJWtNMyGRJr432+LjUJFoyTh/6pqqO9KCv
         ukYq/vR/ugr2HUmKrNE1WnSkm7dQNMQNGHc5oggrS9Mje4mH7mPuu2Yxs7fgeIu+eqXC
         Ygtns4cnXNZlA3Ft6iRWQU/RYMY0WchxelN0V73FYRsvMfbAvHWeEAMl18jbLpvTSmYY
         F+drOKKuXf4vffnJWBgTooKSdB5UMJQB5x8OyjWpZq4Ubahi1gEg5Oh0lvxSyfUn6ji2
         eq1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694619211; x=1695224011;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LsIGUVYLG51ZiWYJq7FwzO7gDs/2DvpvrxoOWIorm5c=;
        b=ip+0Q9sZD2VsO+VbS/6sko9Kg9XuB8KJ4p/mxbDf0AIwLH0m1lGgzcdtFG7dCTa+QL
         zf682s+Nph4l2TL1Nq6x/2BxHS5NB2G/orXPHf5YHD7EzpAj6Cf14dbCaeHkXc5shfOu
         +Ld0A4Srx09UuuHLMJngQimWcEGHbJukafRYPTyZOpy4nEv6bm7T7ivGuazdhKuTlnPm
         1BmkuxXW6LYSFBcHakQ9NSuaPHafvuZR6VI0+p0sZwlI62d8ghBQcI2kOj7EKNukdJ4A
         SHZ/r9r5F2Xk17uWWNA2Ozqmcv/QflK+uUuP46whxV2pINmnWfmkCS72gSIHAKMGlrJl
         Jsbw==
X-Gm-Message-State: AOJu0YxRpec53fkhMckHRQ0tg5M+7Z70t08TWEJGUVPF3QY2+G4b69yX
        jet4JEkL261sxTpEm+MlPkgh2j+RAIwBYYZjd4t9wO9N/XE=
X-Google-Smtp-Source: AGHT+IFz3M+tPdrij2W3dYpUfeR5oHDVo4rQvxpsvmmrRXQY/BDoQRfHVpRWN3Zj/SkYQaYS+RYI6HdDOwxmYTR37FU=
X-Received: by 2002:a17:90b:3ecd:b0:271:9e59:df28 with SMTP id
 rm13-20020a17090b3ecd00b002719e59df28mr2376068pjb.29.1694619211204; Wed, 13
 Sep 2023 08:33:31 -0700 (PDT)
MIME-Version: 1.0
From:   =?UTF-8?Q?Laura_Garc=C3=ADa_Li=C3=A9bana?= <nevola@gmail.com>
Date:   Wed, 13 Sep 2023 17:32:33 +0200
Message-ID: <CAF90-Wg4NTjfUE7pomw8VnQAjSQC2OXa5FQFH_XwK=zf1nOn4A@mail.gmail.com>
Subject: [ANNOUNCE] nftlb 1.0.9 release
To:     Mail List - Netfilter <netfilter@vger.kernel.org>,
        Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi!

I'm honored to present

    nftlb 1.0.9

nftlb stands for nftables load balancer, a user-space tool
that builds a complete load balancer and traffic distributor
using the nft infrastructure.

nftlb is a nftables rules manager that creates virtual services
for load balancing at layer 2, layer 3 and layer 4, minimizing
the number of rules and using structures to match efficiently the
packets. It comes with an easy JSON API service to control,
to monitor and automate the configuration.

Most important changes in this version are:

* Protect daemon authentication key against timing attack
* Fix bulk application of farm policies with PATCH


For further details, please refer to the official repository:

https://github.com/relianoid/nftlb

You can download this tool from:

https://github.com/relianoid/nftlb/releases/tag/v1.0.9

Special thanks to the contribution of Samuel Forestier.

Happy load balancing!
