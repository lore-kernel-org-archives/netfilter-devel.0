Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FF3AC4332F
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Nov 2022 18:04:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbiKJSE3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Nov 2022 13:04:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231565AbiKJSEI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Nov 2022 13:04:08 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A48364E40F
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Nov 2022 10:03:55 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id h132so2641208oif.2
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Nov 2022 10:03:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Xg5yap3etxX9SXgYQQEYxcIIT2ihJ45hJ2KlKRfDPvE=;
        b=eB6Szji6Ceq/Sn+6mCBhXKilNPMqrj+OGrm9hF2vuKf0b6G/L5dm3H99wqb3wlDaUr
         YSb5LTiCOLJ9P/Yer8vXAbqSeg/KGOLMMqoIPga+xzIq6Ph84iCdh1utMoQcoISFxTgC
         GB69DDe+VYz27gJEb5NkJQEN1FNU2WWvEhJmel/2reUVs7bSsLssUmg1TEEw6EaJlOiL
         DXq1tAWBYig6acpZN1HreVYHm8LP1rLvV/1lPtQZpxsPwwt3M9Txu8/M7Uu1QD0nWjCH
         tw/CDKf8WqVJlx5qGcEaHDY3Bawei33vNclsIXwbyV07scumzVWG2tBFBn0P0QqKJB0x
         PSUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Xg5yap3etxX9SXgYQQEYxcIIT2ihJ45hJ2KlKRfDPvE=;
        b=6hUrQPKWJx3lbpIkJm7kfFvVmczGHcqYLgbLDwVlZeSXwx+uYxDXHL0JCh4r/I0fZq
         r6N05irk8pz34umAqyUF7kbiBBd8mtDzVYHwWJCPgEJ1wguHlBhmdyj+VRuLHzuqfj/c
         8xoaXTy5vXL2+b/uUDKVRLqvS9rtKDfV+IIUbuja5uxvAlP9XYTT64NS8LarX+8+AuzR
         4QR8sE91jVcQarwvXn/PJjmYPIDMMjDe5DTsbkuGtNN39J1vn3GjYbt+zcvP4SL1kjBG
         Yj933ldKUz6BxLrAdnlcCvtZ4F/FG2MzNRzdhE3BYaR0AXkzyjtQJX8L8YLvbsG2ECpm
         jSTA==
X-Gm-Message-State: ANoB5pmzIMvUj3ma0w2r2XcMJ9W9OmMroIh9qmxxR4NkP+PkLu9iyt53
        WW6auypvl7t8cSgbDA6wDb2a7PD6itZX4AdKhaI5xy/cwKK9Ag==
X-Google-Smtp-Source: AA0mqf7DTzmYagULjG6Rt/yd+tIaogz3vb10pKRzUuPaCiJpxyPs+sy21odlJyH0e+UorbND13IIFp3nifAWjOBuobA=
X-Received: by 2002:a05:6808:169f:b0:35a:8e8e:1c60 with SMTP id
 bb31-20020a056808169f00b0035a8e8e1c60mr1259409oib.99.1668103434481; Thu, 10
 Nov 2022 10:03:54 -0800 (PST)
MIME-Version: 1.0
From:   Tula Kraiser <tkraiser@arista.com>
Date:   Thu, 10 Nov 2022 10:03:43 -0800
Message-ID: <CAKh0D7xP9rmwes4zjwDAYvrB706Au3aLvfA25NV0+sYR17+-NQ@mail.gmail.com>
Subject: Avoid race between tcp_packet packet processing and timeout set by a
 netfilter CTA_TIMEOUT message
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,

We have been using the nat netfilter module to create NAT translations
and then we offload the translations to our hardware. Once the
translation is offloaded to hardware we expect only FIN and RST to be
received by the linux stack. Once we finish programming the hardware
we send a NETLINK message to the kernel setting the entry timeout to a
larger value (we use the CTA_TIMEOUT for that). That's because we rely
on hardware hitbit to indicate when the entry should be removed due to
inactivity.


Unfortunately there is a delay between receiving the notification of
the translation (we subscribe to netfilter conntrack events for that)
and the time we program the hardware where packets still make it into
the kernel input queue. There is a race between the CTA_TIMEOUT
message and the queue packets where the kernel can replace the timeout
with its default values leading to the entry being removed
prematurely.


To avoid that we are proposing introducing a new attribute to the
CTA_PROTOINFO for TCP where we set the IPS_FIXED_TIMEOUT_FLAG on the
conntrack entry if the conntrack TCP state is less or equal to
TCP_ESTABLISHED.  That takes care of the race.  We are modifying the
tcp_packet routine to reset the IPS_FIXED_TIMEOUT_FLAG when the tcp
state moves the established state so FINs can be processed correctly.


Does this sound like a reasonable solution to the problem or are there
better suggestions? Does this sound like an interesting patch to push
upstream?

Thanks,

Tula
