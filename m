Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50F3DC4332F
	for <netfilter-devel@archiver.kernel.org>; Sat,  4 Nov 2023 21:01:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbjKDVBF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 4 Nov 2023 17:01:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbjKDVBD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 4 Nov 2023 17:01:03 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0FE0D65
        for <netfilter-devel@vger.kernel.org>; Sat,  4 Nov 2023 14:00:58 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5a7cc433782so38774857b3.3
        for <netfilter-devel@vger.kernel.org>; Sat, 04 Nov 2023 14:00:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699131658; x=1699736458; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:mime-version
         :message-id:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7DmhC1X9OAQjJSlRCqONzFt0aXmHxKRvFg2VPovcxo4=;
        b=J0eVTXulSu4Xa0vAzbhW7/KriqeZBP75Vo2ypGXMPQUBihQZ+F2mUI3OCFBOQscfjC
         G9HFrbthec8965RvaQ22q5Ovgupa599DDr47Nh9y+5BMCxGMUWMIN+l1Hw/Jt5nCuX4F
         Zca7eA5lu0/8nPPQBoldV163WpYjwxujFEMqqyuPYbJPpZmFVhGCJ5Vf9aZo3WdcuV9k
         0HHdCgfBBItibESVF8h4RXO7+QSYrIbzRO1Y7rg3AgImQCN7YlX67G/HEnRzButAoma4
         ZA1JTx1zbavDP5x6JWKousol/deq+HJb+yK55qgvE2BgTtrhMi/yfCnLdBYxpLcqJJ9T
         yaCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699131658; x=1699736458;
        h=content-transfer-encoding:cc:to:from:subject:mime-version
         :message-id:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7DmhC1X9OAQjJSlRCqONzFt0aXmHxKRvFg2VPovcxo4=;
        b=P0ag0UoxYsLGCz7lYRAm4rcb5weATL594Ki5BK68acMNRaFBxQi2ej3KOIY5UMWhUj
         fZtNBXvfCuKM1BMtZxCMRAO1x/ksIw40los1UaE5LrUUFKqEK89M3T4NwpuW91gNledm
         yKgEAWwAdhyJ8vg6IHH8Q6/o6KsmBeX0K2rURwhLLuQeXW5WLZLlEKEaVpJc827uZCt0
         TWC6F4hffjVKeZgNIYROx9dGTfEGUeQlMZBS69Kdpn4FzhDKhcucav3RoJ7geqCUSIJ5
         H8/B504FfaaF0EFF+YKyvLToLmwPss+2bk66GOLh2keCIZPK1GJYBvhL9I/R6CqnyGzE
         nN5Q==
X-Gm-Message-State: AOJu0Yz1sJBS9KMxRHJEr+6aC7AxPtApwWZ8KWLFtptE7B2GztH2o5Cv
        XGSDaPMSSYGFsnmBzCu9n7bkEhip
X-Google-Smtp-Source: AGHT+IGIDtqtmA/oVN0QNcBMr7oWGUtMmz2Vav0nvFAmRnKyjHoSrAdF6TfPHq/oNfosQzv6u6SZ/Jym
X-Received: from athina.mtv.corp.google.com ([2620:15c:211:200:f00a:d6b3:feb2:6f0c])
 (user=maze job=sendgmr) by 2002:a0d:dbcc:0:b0:5a1:d4a5:7dff with SMTP id
 d195-20020a0ddbcc000000b005a1d4a57dffmr128329ywe.6.1699131657967; Sat, 04 Nov
 2023 14:00:57 -0700 (PDT)
Date:   Sat,  4 Nov 2023 14:00:53 -0700
Message-Id: <20231104210053.343149-1-maze@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Subject: [PATCH net] net: xt_recent: fix (increase) ipv6 literal buffer length
From:   "=?UTF-8?q?Maciej=20=C5=BBenczykowski?=" <maze@google.com>
To:     "=?UTF-8?q?Maciej=20=C5=BBenczykowski?=" <zenczykowski@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>,
        Jan Engelhardt <jengelh@medozas.de>,
        Patrick McHardy <kaber@trash.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Maciej =C5=BBenczykowski <zenczykowski@gmail.com>

IPv4 in IPv6 is supported by in6_pton
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

Cc: Jan Engelhardt <jengelh@medozas.de>
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

