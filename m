Return-Path: <SRS0=keFs=CC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D7F2C433DF
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Aug 2020 19:38:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40FEC20706
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Aug 2020 19:38:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="ts/mtuAS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgHXTix (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 24 Aug 2020 15:38:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726365AbgHXTiw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Aug 2020 15:38:52 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F26E7C061575
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Aug 2020 12:38:51 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id w11so11760044ybi.23
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Aug 2020 12:38:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=+KNWHt39BeaES4QJyf9uwQ75hxAZKSv16U3yHjZ94QQ=;
        b=ts/mtuAS4Phe5b60Tpb1gUcpi29I2K7oDx3gEEnmURzdhuDVWCXjJ0h7YWE967bLO/
         Hkfb+Ki7yjB9Bvm3hYWb4zAG9oiE0Mg9LZyvwG0TU0zSQ60meMrjmDtsiuXadgoVMh5G
         JVf2M1EdFf5Hp6unvbJjKAjaAclEwkL/gEPN7yzmzdxeDZ30IOWw+EpbwfLCaxXW/ADB
         T/iUjvbkeI3GgS7/kLogGtm1gc8T4XOxxiCTxk+dYekA8li4PsJrHC1JHfXDQIbwu/aK
         UpiZGUyubukLJOSYl+hf+DaNlbXRHuj/pFIJmPR1qhnYiMus3wFswSmi94r8S6FvHSQA
         Milg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=+KNWHt39BeaES4QJyf9uwQ75hxAZKSv16U3yHjZ94QQ=;
        b=BuLbTrnNwibRrSki4IZXTQwx/B/wFHEwHV81bn17wREmSLhHXI6721wwL8qR7kVpI+
         Mk6H+56IZt6x5FfBtVeQb+10M3aRa4A4d2Y4BuXHTK6avS1blx0qn5HluTAkRDW6qaHt
         dIL9zzTnTmOArUSyR1Tf97kuDQyzizvTgKxPmYRFxdiBER/5qNA6EyzPPPXkVRkQMiDl
         sI8TgECLbWjEQTPo+7V+o97dh9cOdOCohlb5QlQ/QCb5hm7nPOBCKFgvYUxSxpdYWpDt
         p/bummLofitW5JTqxg0jAfDN77c2xAcLAcfhWcDK9BsQZZHZUhG9JNHKSs9ra+UkScjJ
         QyMA==
X-Gm-Message-State: AOAM530ch5djzypbvV3EOhfFN1mrm98TkpHCSFhS8MnVqn4q9rSm2h1F
        FjVQ3AYsmTKA3htdT7ssSf1m8ZwXvI8s+/0630c=
X-Google-Smtp-Source: ABdhPJwwO6KvWceO9mUaGNjmT3o+ZQhDwcijuVSccgzCtjjoBlYTOXwFt3vh+n5qXPL7gzVZOdKzC9Ay5dhwedc/Yss=
X-Received: from willmcvicker.c.googlers.com ([fda3:e722:ac3:10:24:72f4:c0a8:2dd0])
 (user=willmcvicker job=sendgmr) by 2002:a25:25cc:: with SMTP id
 l195mr9819663ybl.383.1598297931004; Mon, 24 Aug 2020 12:38:51 -0700 (PDT)
Date:   Mon, 24 Aug 2020 19:38:31 +0000
In-Reply-To: <20200804113711.GA20988@salvia>
Message-Id: <20200824193832.853621-1-willmcvicker@google.com>
Mime-Version: 1.0
References: <20200804113711.GA20988@salvia>
X-Mailer: git-send-email 2.28.0.297.g1956fa8f8d-goog
Subject: [PATCH v3 0/1] netfilter: nat: add a range check for l3/l4 protonum
From:   Will McVicker <willmcvicker@google.com>
To:     stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@android.com, Will McVicker <willmcvicker@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

> This patch is much smaller and if you confirm this is address the
> issue, then this is awesome.

Yes, I can confirm the updated patch does fix the kernel panic. I have retested
on the Pixel 4 XL with version 4.14.180. Please see the updated patchset v3.

Thanks,
Will


Will McVicker (1):
  netfilter: nat: add a range check for l3/l4 protonum

 net/netfilter/nf_conntrack_netlink.c | 2 ++
 1 file changed, 2 insertions(+)

-- 
2.28.0.297.g1956fa8f8d-goog

