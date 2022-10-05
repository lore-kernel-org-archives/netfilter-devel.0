Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72B1DC433F5
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Oct 2022 23:34:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbiJEXey (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Oct 2022 19:34:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiJEXex (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Oct 2022 19:34:53 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F7B0B1D4;
        Wed,  5 Oct 2022 16:34:52 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id z23so899726ejw.12;
        Wed, 05 Oct 2022 16:34:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:date:message-id:subject:mime-version:content-transfer-encoding
         :from:from:to:cc:subject:date;
        bh=bByOM+CUYguQdEPVi7mpacb76chDau8LL1PzlsNTNGc=;
        b=RMAK7AubNxjXHwBrPijHPz2rtSpDwtGEygcMUWsHfARi6xhEIU8tPq3tTZYG29o5BW
         t2UxXlawXmunXBM3VviLiL17WfQHFkYJY4h2Ssl2W6cKiy4sHFsB0myvKD8iJjX6GdN2
         nDJAsX2My7aH0TAQItUdVkHBSbgEPQh9NHWAz/Hpp7ZxTafKFCEeslvAjBDOANL7fJQN
         bNmy8DOy6V0JzVvAVmULNQVgBhKdjPApNDGOtbEAiMMmrw3KrJ2lUNU693YrT7+e9MXf
         TkgFwsfKfiJGmbdK/+kKtSOVts7FDuE6jV+VgP0XFKozRX5RKue3Ey3B0XfmJEtqh8sg
         dxCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:date:message-id:subject:mime-version:content-transfer-encoding
         :from:x-gm-message-state:from:to:cc:subject:date;
        bh=bByOM+CUYguQdEPVi7mpacb76chDau8LL1PzlsNTNGc=;
        b=oobK7lF1BJmLpKzt28rxXrH3lQlPK80O5H4THINpqesm8v2QVGMKjK28dnYGSDqZ31
         0tJQ+31NRK70XIWybaYvGu/sRI92tIAbkZlNqf2cWgPMkS5fgRP/eKJjRX/fb9OmKvN0
         mIIlM75bvqyFsrgRWm9WXG0n78jjUQTrlUKf4fsMHjw1NRu9MN4jPt57/NxnyUyXMNb/
         bSJ4wurYLrll3pAuSr1FHmqaoR7ocEDd4N1a4GSamQm55R146W7FY1pLq+45k9eSnNMi
         KMvRUrR9isbfVbza2JjgF3G2Gzle4hJ6WPSXqnp3Yq+AzM5JRevUd2xqG59X1/h065/z
         rpfQ==
X-Gm-Message-State: ACrzQf33MvCu0F1fbMVjsVFEVDdyG/XcQTDPILTkJcUEHaGK664lHoQS
        s71fXmIxWQ27nz0r2bktVWw=
X-Google-Smtp-Source: AMsMyM4l3ZVFAvVJvEjZjh/AOWIneg9x7leuXotev6N989HTp+76r5QZJgWrujuSr6LgwoMizBTAgw==
X-Received: by 2002:a17:906:ef8f:b0:77e:44be:790 with SMTP id ze15-20020a170906ef8f00b0077e44be0790mr1625417ejb.409.1665012890672;
        Wed, 05 Oct 2022 16:34:50 -0700 (PDT)
Received: from smtpclient.apple ([178.254.237.20])
        by smtp.gmail.com with ESMTPSA id c17-20020a17090618b100b007826c0a05ecsm9194017ejf.209.2022.10.05.16.34.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Oct 2022 16:34:50 -0700 (PDT)
From:   Martin Zaharinov <micron10@gmail.com>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Kernel 6.0.0 bug pptp not work
Message-Id: <3D70BC1B-A19E-45E3-B6BC-6B2719BA9B46@gmail.com>
Date:   Thu, 6 Oct 2022 02:34:48 +0300
To:     Florian Westphal <fw@strlen.de>, pablo@netfilter.org,
        Paolo Abeni <pabeni@redhat.com>,
        netfilter-devel@vger.kernel.org,
        netfilter <netfilter@vger.kernel.org>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Team

I make test image with kernel 6.0.0 and schem is :

internet <> router NAT <> windows client pptp

with l2tp all is fine and connections is establesh.

But when try to make pptp connection  stay on finish phase and not connect .

try to remove module : nf_conntrack_pptp and same not work.


how to debug and find why not work ?


Best regards,
Martin
