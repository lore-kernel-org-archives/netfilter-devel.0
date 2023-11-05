Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73D1EC4332F
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 Nov 2023 19:56:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbjKET4H (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 5 Nov 2023 14:56:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjKET4H (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 Nov 2023 14:56:07 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72675C0
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Nov 2023 11:56:04 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-da0c7d27fb0so4384986276.1
        for <netfilter-devel@vger.kernel.org>; Sun, 05 Nov 2023 11:56:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699214163; x=1699818963; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:mime-version
         :message-id:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QUArnjSIsgXrx7xFAxQVER0QA0qRV6AYyhVWnbMzG4g=;
        b=c08CcNAbZ4pdFhebIO69rhezM3/YJmSlSR4tGE7uLaV+BqGl/3L7zcIbhkbb6Rzn53
         S+wpclAvdGp+ha5ffB+RGFzDbFP6UHY7Mr1GpZq61YCJaQNdJ+iIaUzVe32mR6eXC0n3
         HGylq5QV6PZEOEJDsWb6mZgCg7w1cpzuLge6r5JCoQLL1O1mIb6zwe+kspI35fJF757B
         8v5t7qq82WpCzoAitb0AUQCGdYvvhycy4zoHuh9rgBYfiBgNChgtF9zASAke1oEtngNE
         FKwaRZH5eBuju/HXtClcH8r+foRir1Sk/7X64ywU5IY45k7UnBgk/HmOs+9oSMwDhyJd
         WwAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699214163; x=1699818963;
        h=content-transfer-encoding:cc:to:from:subject:mime-version
         :message-id:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QUArnjSIsgXrx7xFAxQVER0QA0qRV6AYyhVWnbMzG4g=;
        b=NDhJNnuKG+IzYwXsmk0hFDvT5P7ZzuAApDkK/vj0nbV5wsc4MfTUyXJISHWu6NrqIU
         22/PYkiet4UCUSZVSJT0UxiUwa9BHACH2SYh1Nz3Anjsc96d7ULJ+BCh/WOG4AOM1mkr
         qBh4tXXmE/xU/Ofrus8OqPvSbAbuJVl1c2o798OCemnPwjjKL4DA//lfCSTBUjCV8hT8
         +nUChyVJpBBg4TgUONMEDoRRaC2q2gDcVJwLs+yryK+SqS/qGaD/w2X/Lxvzu23SOguE
         qcP0kDLgnCiUtj6rWqFEXnKWtywbCnjwfTVr8E5muG7QCmASS5pQlM/wdQBuzuPWUJcJ
         dSPg==
X-Gm-Message-State: AOJu0YzsLEP2htOHZP4O0sStqjGNXd0MFh8xv642IXulGyVl8sIWs7fE
        R8z79W/F6I1HI4ezlSYm44N68a6g
X-Google-Smtp-Source: AGHT+IFwPAe+YxrftLkpjJj6/uUQsA+ztDwXxVSaYNAZQh9aXwwqjfQlklUxAnhkE+1HsBMjtAcoLzXM
X-Received: from athina.mtv.corp.google.com ([2620:15c:211:200:8452:1b9c:f000:45a5])
 (user=maze job=sendgmr) by 2002:a25:8806:0:b0:da0:ca6a:bdad with SMTP id
 c6-20020a258806000000b00da0ca6abdadmr558919ybl.10.1699214163628; Sun, 05 Nov
 2023 11:56:03 -0800 (PST)
Date:   Sun,  5 Nov 2023 11:56:00 -0800
Message-Id: <20231105195600.522779-1-maze@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Subject: [PATCH net v2] netfilter: xt_recent: fix (increase) ipv6 literal
 buffer length
From:   "=?UTF-8?q?Maciej=20=C5=BBenczykowski?=" <maze@google.com>
To:     "=?UTF-8?q?Maciej=20=C5=BBenczykowski?=" <zenczykowski@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>,
        Jan Engelhardt <jengelh@inai.de>,
        Patrick McHardy <kaber@trash.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Maciej =C5=BBenczykowski <zenczykowski@gmail.com>

in6_pton() supports 'low-32-bit dot-decimal representation'
(this is useful with DNS64/NAT64 networks for example):

  # echo +aaaa:bbbb:cccc:dddd:eeee:ffff:1.2.3.4 > /proc/self/net/xt_recent/=
DEFAULT
  # cat /proc/self/net/xt_recent/DEFAULT
  src=3Daaaa:bbbb:cccc:dddd:eeee:ffff:0102:0304 ttl: 0 last_seen: 973384882=
9 oldest_pkt: 1 9733848829

but the provided buffer is too short:

  # echo +aaaa:bbbb:cccc:dddd:eeee:ffff:255.255.255.255 > /proc/self/net/xt=
_recent/DEFAULT
  -bash: echo: write error: Invalid argument

Cc: Jan Engelhardt <jengelh@inai.de>
Cc: Patrick McHardy <kaber@trash.net>
Fixes: 079aa88fe717 ("netfilter: xt_recent: IPv6 support")
Signed-off-by: Maciej =C5=BBenczykowski <zenczykowski@gmail.com>
---
 net/netfilter/xt_recent.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index 7ddb9a78e3fc..ef93e0d3bee0 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -561,7 +561,7 @@ recent_mt_proc_write(struct file *file, const char __us=
er *input,
 {
 	struct recent_table *t =3D pde_data(file_inode(file));
 	struct recent_entry *e;
-	char buf[sizeof("+b335:1d35:1e55:dead:c0de:1715:5afe:c0de")];
+	char buf[sizeof("+b335:1d35:1e55:dead:c0de:1715:255.255.255.255")];
 	const char *c =3D buf;
 	union nf_inet_addr addr =3D {};
 	u_int16_t family;
--=20
2.42.0.869.gea05f2083d-goog

