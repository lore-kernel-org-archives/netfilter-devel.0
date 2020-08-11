Return-Path: <SRS0=vjpg=BV=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62E84C433DF
	for <netfilter-devel@archiver.kernel.org>; Tue, 11 Aug 2020 19:07:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 343F6206DA
	for <netfilter-devel@archiver.kernel.org>; Tue, 11 Aug 2020 19:07:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rpEZPRca"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726258AbgHKTH0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 11 Aug 2020 15:07:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbgHKTHZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 11 Aug 2020 15:07:25 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89053C06174A
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Aug 2020 12:07:25 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id kq25so14289842ejb.3
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Aug 2020 12:07:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=SPI4ehrWe/mrC+iYY8NRIdimBaS5aogM5v0lvWU++oE=;
        b=rpEZPRcaJKTO+ORFkYAItsD82ECJe27pNBj0x77sdC8hdUcEAaw64VzLrbwq96s3tz
         x7UFY4iWU95e60XZNQJw541bpx8Ahr1OuYeXpwcZ/fYCrjLx1yujOgwsLhYqp7SCvFVD
         KoXt3JPvo+40/c3sWcyd9VjAAKMlP68srZ3MklqYQ+nMwTuWcPWXyrIwcN9InvAjDuFd
         VjnlgbVQxRKF3OGdfh09sc1XtW95i4TwXCRsE3XE5F4ohJUhvpxE2qerx9L6jXbbL/kd
         nAKHzjywYpxi26JziaN/r0qaepj9Z991PpHCUs2QeIznly/wpwmbhxis08704c3d9b6k
         XCmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=SPI4ehrWe/mrC+iYY8NRIdimBaS5aogM5v0lvWU++oE=;
        b=LAgsISA41bemdXXdEVj6MZ9NFXk5bCiBNOOT8Grg6psohWJP8mgfmchz6GP6vNlFj7
         eIYDCGd2ML8h8iffySXBJI5+6ghbUHAwBGKuN26cOOGZbpOYcVHqyv8QUbT02LzQgt1I
         30h4w1UNdDRPu5dhc3MEKbTp1B51Jp4SPjcn9Jobt691uKfcnm5jJg1tYF2aO5ke3AfT
         rZ7nlWYoE1n9GfLp6CXW6LvQmrYBIUWSylDMdAnJcenLfVU5JAM74aclMuuISlHiI+0F
         g+kWV9fs8dLH+J/t/XYGvp6xAejrLZabntHlta7Kz33/FOTNMtst8f7+EITLRYmWbOPG
         UURA==
X-Gm-Message-State: AOAM5309JrenY/g24FbXejcjUqCoIjihRW+mL+ZrFHCW9UyxVFvlIvpm
        SXvnIDVAFAboq2ucTH2mfNMwn/XP6fRqTA5Kf4D8+hgqoYw=
X-Google-Smtp-Source: ABdhPJwBw29MR2BrhWz7iULjyYn8vKXDRcLuS7qAro0qDAy16gMbo8Euewl4ktTNcinaidlDgqSN/blZCD+HUitMxIo=
X-Received: by 2002:a17:906:3993:: with SMTP id h19mr10059269eje.111.1597172843695;
 Tue, 11 Aug 2020 12:07:23 -0700 (PDT)
MIME-Version: 1.0
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Tue, 11 Aug 2020 12:07:12 -0700
Message-ID: <CAHo-Oowt08J-zcLPgXkpiUd9x57qHJ7nnE3Ko9uiApFMZ254uA@mail.gmail.com>
Subject: iptables memory leak
To:     Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
        Netfilter Development Mailinglist 
        <netfilter-devel@vger.kernel.org>, Ioannis Ilkos <ilkos@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

We've gotten reports of a persistent memory leak in long running
ip{,6}tables-restore processes on Android R (where we merged in a
newer iptables release).

Memory usage has been seen to hit 100MB each.

As a reminder, android runs iptables-restore/ip6tables-restore as a
long running child process of netd (to eliminate process startup
overhead, which is not insignificant) and communicates to it over a
pipe.  We don't use 'nft' nor 'ebtables'.

To quote/paraphrase a coworker: "I got a heap profile while playing
around with the networking config (connect & disconnect from wifi,
change hotspot params etc) which repros a leak. It looks like
xtables_find_target can malloc, but we don't free the results."

We believe (unconfirmed) it's likely due to this commit:
  commit 148131f20421046fea028e638581e938ec985783[log] [tgz]
  author Phil Sutter <phil@nwl.cc>Mon Feb 04 21:52:53 2019 +0100
  committer Florian Westphal <fw@strlen.de>Tue Feb 05 16:09:41 2019 +0100
  xtables: Fix for false-positive rule matching

Is this known? Fixed?  I don't really understand what the commit is
trying to accomplish/fix.  Could we just revert that commit (or the
libxtables/xtables.c portion there of)?  Or is it perhaps obvious
where the free should be happening?

(and is there a similar problem with matches? the target and match
code seem equivalent wrt. to this clone behaviour, maybe there's a
similar issue)

Any hints?

- Maciej
