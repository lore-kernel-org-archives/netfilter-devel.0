Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7B50C61DA4
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Feb 2023 23:08:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232766AbjBNXIQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 14 Feb 2023 18:08:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232785AbjBNXIQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Feb 2023 18:08:16 -0500
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80E7B10D1
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Feb 2023 15:08:11 -0800 (PST)
Received: by mail-oi1-x231.google.com with SMTP id t5so14354591oiw.1
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Feb 2023 15:08:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=datadoghq.com; s=google;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=0KbffaCSPfPMo0JlQMj/ELtGYfjLmastzbChrDc2eLQ=;
        b=CRRuPAnuiFzOyvUo3GSYSbUuIBPGlXdvqyeqohxNruPkEw1K+Fb4e1p3kq3QhMcWoX
         Sz/0RzWbNzoZL3Fp5QHWN16wCDozaBfNKaWd9dP/37l4gEZ1XmzSbTgom0vZP4I/z+N2
         mo4aygypx8NmEg0gVpZprz90wbtv+ebnIbhug=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0KbffaCSPfPMo0JlQMj/ELtGYfjLmastzbChrDc2eLQ=;
        b=U9dpMUffyQRI35XlBmxmEt93/1JLeN+E+QERnNqXm3KDQHykthv+02pg+J3epg4vOy
         4f/pXPSnzOsFScco/bF0iQ9FA1oAM/OQFZWVHmWM2471FuydDBaDrh+hcnzFCIiYE0d4
         ZQZRShc7GSRx36wqBvn5Gl1oG5WMeTEpfyDA9yAFu6bcaRMzBjywKvpffCMYF6BCpuJT
         edUh8g8FE9vl6S+nzkjp7g6UETvezcfgZ2fgb77U/rLxj5PRsUiFrlrTx1yrq8gZ6Hi3
         NLTsAWaLHwRGsQaN41YXPDBxdufRtltz+j/iei9haEbmVj6L16LXEslR2PWCorXNpH5a
         cvYw==
X-Gm-Message-State: AO0yUKWh3uraVXccnLkUM/XIuaysHOHZuxEkZYq6r6VFjs7yIOxNM1iL
        PofKFKb2A/u2s3Zoy74ipmMwDFhKgAsjOcsvOdEtIX3hhkNs+AZYLUA=
X-Google-Smtp-Source: AK7set+ffB7N7CHMERwmIM97msXqWih3/wTqxBjXk6Y9mInFnM44+J76Ssy1HE96LBOodNRmx1Sy2Sxdb3TTwPQ8SwU=
X-Received: by 2002:aca:c145:0:b0:37b:70a8:ccc7 with SMTP id
 r66-20020acac145000000b0037b70a8ccc7mr115437oif.40.1676416090737; Tue, 14 Feb
 2023 15:08:10 -0800 (PST)
MIME-Version: 1.0
From:   Bryce Kahle <bryce.kahle@datadoghq.com>
Date:   Tue, 14 Feb 2023 15:08:00 -0800
Message-ID: <CALvGib_xHOVD2+6tKm2Sf0wVkQwut2_z2gksZPcGw30tOvOAAA@mail.gmail.com>
Subject: PROBLEM: nf_conntrack_events autodetect mode invalidates
 NETLINK_LISTEN_ALL_NSID netlink socket option
To:     fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nf_conntrack_events auto mode invalidates NETLINK_LISTEN_ALL_NSID
netlink socket option

commit 90d1daa45849f272b701f29d6ca88b24743c7553 introduced a
nf_conntrack_events=2 mode sysctl intended to avoid an allocation "as
long as no event listener is active in
the namespace".

The netlink socket option NETLINK_LISTEN_ALL_NSID allows a socket to
listen to events "from all network namespaces that have an nsid
assigned into the network namespace where the socket has been opened".

The effect of the above commit is that sockets in other network
namespaces (including the root network namespace) with
NETLINK_LISTEN_ALL_NSID, no longer receive events from any other
network namespace. Once you create a netlink socket in the same
network namespace as the event, then events from that network
namespace flow to all netlink sockets in all namespaces.

I attempted a workaround by setting nf_conntrack_events=1, but that
only applies in the current namespace. I believe this workaround has
no effect, because the default has been changed to 2 for all new
namespaces.

This affects kernels 5.19+. I have git bisected the kernel with a
reproducer to identify the commit above. I can publish the reproducer
on request.

Thanks,
Bryce Kahle
Datadog
