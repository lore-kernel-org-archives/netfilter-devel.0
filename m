Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FD3DC2B9F4
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Jun 2021 00:44:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E92861378
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Jun 2021 00:44:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbhFOAq2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 14 Jun 2021 20:46:28 -0400
Received: from mail-pf1-f182.google.com ([209.85.210.182]:34648 "EHLO
        mail-pf1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbhFOAq1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Jun 2021 20:46:27 -0400
Received: by mail-pf1-f182.google.com with SMTP id g6so11939013pfq.1
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Jun 2021 17:44:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=superloop.com; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=b5k2aJeb5qDGwonAs8nLc9NZZiidOnz9OPWCfZKw484=;
        b=wIxwNICS6QfHxyJ6Eh5HA4qw9/hbpsFsFUiA8n4QtV+Eyol3oYeGCu1gQg/E0dNKds
         Q7VT0YiwlN13byYBI/v6KTcZZz61hp7XrF9EmeCgacVEuDxQWeiB44dNKE2XrA+QTX4M
         +mifhjuSzjmUiz7UAohOt/VvIg5D8jKC2KQrc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=b5k2aJeb5qDGwonAs8nLc9NZZiidOnz9OPWCfZKw484=;
        b=If7M2PCurhoxwlHSgtOoIXp0KlHOiQCoxl5KWlIwJwNKVnl74ZY/A93+0VyxOQ1QkV
         qexi8FWAP9BXoNfwffggzOdVA0r9enKyEAbNtlqYwYsqYI7VhDPc8QBKozPFDo69Hsmg
         dgVbLETTCmawFb8okgm9PiKELfZx7v63is0A74GHvaIAujHyRfibZ6sqS0dRCDm32QHu
         ScCbFqgFV3V8xOeoi/bXZgbOjKKg31aVXd9y4UgJ0WXHeQU1QgyqUfdyfRCjc6XCi4Cb
         zXudk/hpMTlQzlECTy/VLvEdSBMQi6m+QZ4YGfeG+4m6HjolYT+/R/ypMM+JDjmU3dX+
         Rl5Q==
X-Gm-Message-State: AOAM530W/6Ro2Fm215DXaQXUlmYX6en1U1wdHZ0zZuPWY9cH1czA6FH6
        nOH5fi03Aa/w1OU0UfL28a8pYyL7QFgfpJ9xvnUO+7y2Vs7Uhw==
X-Google-Smtp-Source: ABdhPJxk5DLSIcsMNBcaBuqwTnseUH0ukMIWX9rLwOrzGkm/sSMiUmB+7jP65xq7Anx9lFkOGM5qb+/LDR/DTZ4eC+0=
X-Received: by 2002:a63:2b8a:: with SMTP id r132mr355893pgr.380.1623717789103;
 Mon, 14 Jun 2021 17:43:09 -0700 (PDT)
MIME-Version: 1.0
From:   Jake Owen <jake.owen@superloop.com>
Date:   Tue, 15 Jun 2021 10:42:58 +1000
Message-ID: <CAD353mmiYns6u5tb3XQz3Rfh_23EMES-4FX1d4pJrQwBd3NvGQ@mail.gmail.com>
Subject: nfqueue hashing on TCP/UDP port
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello!

tl;dr Is there a technical reason why nfqueue balance as implemented
does not use TCP/UDP ports as well as source/destination IP addresses?

We've been having trouble with the queue hashing algorithm used by
iptable's `--queue-balance` for traffic generated on-box (e.g. by a
squid proxy) where a large percentage of traffic would be TCP, source
IP of the proxy, and one google/microsoft/apple destination IP. This
is made worse if the random seed causes two or more of these high
traffic services to hash to the same queue. We are working on
preserving the original client IP as the source IP to provide
sufficient randomness to balance accurately, but in the meantime have
wondered if balancing by port was not implemented because it was
deemed unnecessary, or because of some technical reason which escapes
me.

I've been able to write a kernel patch which hashes based on protocol,
IP and port for the CentOS 7 kernel we have in production which
_appears_ to be stable. Is there an existing test harness I can use to
validate this implementation? I'm willing to propose a solution for
the latest 5.x kernel if other people think that this is a valid
solution/use case.

Kind Regards,
Jake Owen
