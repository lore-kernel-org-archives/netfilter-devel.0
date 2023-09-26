Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2FBCE7F120
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Sep 2023 20:05:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231564AbjIZUFR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Sep 2023 16:05:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235803AbjIZUFR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Sep 2023 16:05:17 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C39E11D
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Sep 2023 13:05:10 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d8943298013so5951350276.2
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Sep 2023 13:05:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695758709; x=1696363509; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=LUHQqKLA03cvxOqIb9LV+319kkd0FdCrPANHPM/IRTw=;
        b=atLFwbr8blVejomJeCh4lmIxX20DbV2RNAqifweKxAWRvnZExZjZrAw4c31yp0sInI
         k2Hxy3zQagyqWF2rNcnY093lwRXKqSU94jdl1tb/lHJNSgc6KJZCVmEDBtACX+3RtX5G
         Y6t8S3aIZJ0R1KvnNPmlwJJ4XmU+XFr25Wy2y3xy6l0SNA1QIT0X5LaFaZRqfOr9Bcbi
         hAxZPer1LDuotdMLhHuR4h+7lWENJyHmJ5RQ+nCamGDs/YI0eFAAMg3ner6O1UseAx77
         hwR9F7FEDxieu6VbJniVZ9nA/XvlLgwVHTtpwGBV19bLXmn+bTnETagjXvy+tlbgBUIp
         RkkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695758709; x=1696363509;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LUHQqKLA03cvxOqIb9LV+319kkd0FdCrPANHPM/IRTw=;
        b=pU6/9FYjkt0uLSKOK8iMNCD2w/kZPrDXVW+CO3I86ZzEZRmFl7r/i6g0AVSTmQrRML
         kuhKZDVw5m8qibK7O1FrDPNsOn9UJloZOzhyu8fhZ4h2hBfcfAd98pDGE2v20ljcVg9S
         0+M1uLnaEB8qk4FXxIZCy5EwqeNNqWMPcAvg5bGq0NEE6UFFUBbmGyS2PLqfoPcIpttH
         1Ew/wPUHabS7EBWcf6ZLHi8OqE/PERCsBifLSLaDmVr/tr9cpXzngnrg+Y741pLuJRSb
         tUs0YkY6J75tLn5TEyjkYO0U2EGocEXVUh4UqTn3LGGn1p4JuhntM7SrhyNigvwWzQak
         3vkQ==
X-Gm-Message-State: AOJu0YyCM+PdDlTUVKUeQ2EcsBVsdGZqedjRWO6tIfYw2cTwDi3FVfsP
        i1f2/f/eWy4Ah9URTOhOEqeq4mwM+Q==
X-Google-Smtp-Source: AGHT+IHiar7acMg7OZkqRteQy8u+g7Q3fC4ZlZH6+0avyWJDsbyt98fkghdeToG/rJkXrrHt5fTNug6bGg==
X-Received: from jrife.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:9f])
 (user=jrife job=sendgmr) by 2002:a5b:752:0:b0:d89:4d2c:d846 with SMTP id
 s18-20020a5b0752000000b00d894d2cd846mr52999ybq.12.1695758709189; Tue, 26 Sep
 2023 13:05:09 -0700 (PDT)
Date:   Tue, 26 Sep 2023 15:05:02 -0500
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.515.g380fc7ccd1-goog
Message-ID: <20230926200505.2804266-1-jrife@google.com>
Subject: [PATCH net v6 0/3] Insulate Kernel Space From SOCK_ADDR Hooks
From:   Jordan Rife <jrife@google.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, willemdebruijn.kernel@gmail.com,
        netdev@vger.kernel.org
Cc:     dborkman@kernel.org, horms@verge.net.au, pablo@netfilter.org,
        kadlec@netfilter.org, fw@strlen.de, santosh.shilimkar@oracle.com,
        ast@kernel.org, rdna@fb.com, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com, coreteam@netfilter.org,
        netfilter-devel@vger.kernel.org, ja@ssi.bg,
        lvs-devel@vger.kernel.org, kafai@fb.com, daniel@iogearbox.net,
        daan.j.demeyer@gmail.com, Jordan Rife <jrife@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

==OVERVIEW==

The sock_sendmsg(), kernel_connect(), and kernel_bind() functions
provide kernel space equivalents to the sendmsg(), connect(), and bind()
system calls.

When used in conjunction with BPF SOCK_ADDR hooks that rewrite the send,
connect, or bind address, callers may observe that the address passed to
the call is modified. This is a problem not just in theory, but in
practice, with uninsulated calls to kernel_connect() causing issues with
broken NFS and CIFS mounts.

commit 0bdf399342c5 ("net: Avoid address overwrite in kernel_connect")
ensured that callers to kernel_connect() are insulated from such effects
by passing a copy of the address parameter down the stack, but did not
go far enough:

- There remain many instances of direct calls to sock->ops->connect()
  throughout the kernel which do not benefit from the change to
  kernel_connect().
- sock_sendmsg() and kernel_bind() remain uninsulated from address
  rewrites and there exist many direct calls to sock->ops->bind()
  throughout the kernel.

This patch series is the first step to ensuring all socket operations in
kernel space are safe to use with BPF SOCK_ADDR hooks. It

1) Wraps direct calls to sock->ops->connect() with kernel_connect() to
   insulate them.
2) Introduces an address copy to sock_sendmsg() to insulate both calls
   to kernel_sendmsg() and sock_sendmsg() in kernel space.
3) Introduces an address copy to kernel_bind() and wraps direct calls to
   sock->ops->bind() to insulate them.

Earlier versions of this patch series wrapped all calls to
sock->ops->conect() and sock->ops->bind() throughout the kernel, but
this was pared down to instances occuring only in net to avoid merge
conflicts. A set of patches to various trees will be made as a follow up
to this series to address this gap.

==CHANGELOG==

V5->V6
------
- Preserve original value of msg->msg_namelen in sock_sendmsg() in
  anticipation of this patch that adds support for SOCK_ADDR hooks to
  Unix sockets and the ability to modify msg->msg_namelen:
  - https://lore.kernel.org/bpf/202309231339.L2O0CrMU-lkp@intel.com/T/#m181770af51156bdaa70fd4a4cb013ba11f28e101

V4->V5
------
- Removed non-net changes to avoid potential merge conflicts.

V3->V4
------
- Removed address length precondition checks from kernel_connect() and
  kernel_bind().
- Reordered variable declarations in sock_sendmsg() to maintain reverse
  xmas tree order.

V2->V3
------
- Added "Fixes" tags
- Added address length precondition checks to kernel_connect() and
  kernel_bind().

V1->V2
------
- Split up single patch into patch series.
- Wrapped all direct calls to sock->ops->connect() with kernel_connect()
  instead of pushing the address deeper into the stack to avoid
  duplication of address copy logic and to encourage a consistent
  interface.
- Moved address copy up the stack to sock_sendmsg() to avoid duplication
  of address copy logic.
- Introduced address copy to kernel_bind() and insulated direct calls to
  sock->ops->bind().

Jordan Rife (3):
  net: replace calls to sock->ops->connect() with kernel_connect()
  net: prevent rewrite of msg_name and msg_namelen in sock_sendmsg()
  net: prevent address rewrite in kernel_bind()

 net/netfilter/ipvs/ip_vs_sync.c |  8 ++++----
 net/rds/tcp_connect.c           |  4 ++--
 net/rds/tcp_listen.c            |  2 +-
 net/socket.c                    | 36 ++++++++++++++++++++++++++-------
 4 files changed, 36 insertions(+), 14 deletions(-)

-- 
2.42.0.515.g380fc7ccd1-goog

