Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21088C04FE1
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Aug 2023 22:48:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231596AbjHHWsn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 8 Aug 2023 18:48:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231524AbjHHWsl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Aug 2023 18:48:41 -0400
Received: from mail-oo1-xc49.google.com (mail-oo1-xc49.google.com [IPv6:2607:f8b0:4864:20::c49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AFD3109
        for <netfilter-devel@vger.kernel.org>; Tue,  8 Aug 2023 15:48:40 -0700 (PDT)
Received: by mail-oo1-xc49.google.com with SMTP id 006d021491bc7-56c6c502822so9996861eaf.2
        for <netfilter-devel@vger.kernel.org>; Tue, 08 Aug 2023 15:48:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691534920; x=1692139720;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Pvwje1x+fgK9E9IR7qsfn31Dc5XiXldAZ1Fo1xHQpAo=;
        b=ZowPnFVAEOQu1o/+XzT8fcaX6DHlVccwrE7gGNHkAx3YDdV+D3o7fUpYyj/vi1Ct5Q
         +QYJDWnAhftWiK8EgTciXmjxfJNfL1DHfcE3o+XOVVHbUUBr2oc33L84fXDKdg0spibe
         GZ5bqdG9qrHx/UtSzbaBTMqp6lQxfoXnPa2UM0vLrI7Zb2YiefFjL0pSu/+rNaKy1wlN
         XhfOQJjCKLo/y7i/PPyKhKK6HKjXtVSpBWc22UEpkQAx89z/FVCmSvgnGCxbk5FjWRbD
         QKj317GKJBKiDYTXPzGM5v1TxwYmVWI7QXAAaldoX9Tx9r5cTrpz+UfvZC+saxnSr//L
         67Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691534920; x=1692139720;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Pvwje1x+fgK9E9IR7qsfn31Dc5XiXldAZ1Fo1xHQpAo=;
        b=k/3135C8P9pxwZ5oiKT/JGj/IXG2gh71ET+UfDXLXBnipb6anQ+JcXdMtebZ2riiKs
         7R4knbOXWas1bAkUd8LCNZObgk5zcgt4UV5+Xdjl8vQYWjSviuiSOpjDrVSU5Ur/YYzl
         dPZHfjEsP0TADEDRd+5NadqWj3awsz4q9J4CAyvoTuhycxDyUJrATWtEj4nlHlchSA6Q
         iBydnIKWt3a4mzNuCzkA987gjLRXEg/t8ubW8w2Vble596Xn1OiAqGJCNL670soMuFRK
         sfvPAOYNahtVA+XPvkxhEJVVN7RMoP8uwQUdlAoryTx6Xo1ZJKwM9oys3hRxPTPqLZ5B
         2uag==
X-Gm-Message-State: AOJu0YzVeAgr3d+qmTGIJjJXnnXE+YQLM7QwJFw7AEs5i6a+QvqJoeg8
        OhdGXAPSQF3HA28DeL/3yepFbdZIEtSXffGayQ==
X-Google-Smtp-Source: AGHT+IFfTapulzyD7mF8uId+U6qhT9W1jzh/xLHutjoQ+baESmwt1nASohgDjGgqfc8DbSFYevzOUew1G7Fcn9bwfg==
X-Received: from jstitt-linux1.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:23b5])
 (user=justinstitt job=sendgmr) by 2002:a05:6870:5b03:b0:1bf:a06f:ce6f with
 SMTP id ds3-20020a0568705b0300b001bfa06fce6fmr315997oab.9.1691534919982; Tue,
 08 Aug 2023 15:48:39 -0700 (PDT)
Date:   Tue, 08 Aug 2023 22:48:11 +0000
In-Reply-To: <20230808-net-netfilter-v1-0-efbbe4ec60af@google.com>
Mime-Version: 1.0
References: <20230808-net-netfilter-v1-0-efbbe4ec60af@google.com>
X-Developer-Key: i=justinstitt@google.com; a=ed25519; pk=tC3hNkJQTpNX/gLKxTNQKDmiQl6QjBNCGKJINqAdJsE=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1691534912; l=1616;
 i=justinstitt@google.com; s=20230717; h=from:subject:message-id;
 bh=epcsNlzjLL3K9DAOvrsRp37/1eZVu8TeiuJpMs34l/Q=; b=L1P2cQc3z99LSWR/qio44oxncmlWLIBSvxY6HOu5W2BRo4B41BhDGwuAbcow63n2hPhRjceUI
 9E5bGIoGP2nDYAORkqUToKLoCEdCN/nRopReeZhHhL/7pSX4tiOQrrn
X-Mailer: b4 0.12.3
Message-ID: <20230808-net-netfilter-v1-6-efbbe4ec60af@google.com>
Subject: [PATCH 6/7] netfilter: x_tables: refactor deprecated strncpy
From:   Justin Stitt <justinstitt@google.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-hardening@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Justin Stitt <justinstitt@google.com>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Prefer `strscpy` to `strncpy` for use on NUL-terminated destination
buffers.

This fixes a potential bug due to the fact that both `t->u.user.name`
and `name` share the same size.

Signed-off-by: Justin Stitt <justinstitt@google.com>

---
Here's an example of what happens when dest and src share same size:
|  #define MAXLEN 5
|  char dest[MAXLEN];
|  const char *src = "hello";
|  strncpy(dest, src, MAXLEN); // -> should use strscpy()
|  // dest is now not NUL-terminated
---
 net/netfilter/x_tables.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 470282cf3fae..714a38ec9055 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -768,7 +768,7 @@ void xt_compat_match_from_user(struct xt_entry_match *m, void **dstptr,
 	m->u.user.match_size = msize;
 	strscpy(name, match->name, sizeof(name));
 	module_put(match->me);
-	strncpy(m->u.user.name, name, sizeof(m->u.user.name));
+	strscpy(m->u.user.name, name, sizeof(m->u.user.name));
 
 	*size += off;
 	*dstptr += msize;
@@ -1148,7 +1148,7 @@ void xt_compat_target_from_user(struct xt_entry_target *t, void **dstptr,
 	t->u.user.target_size = tsize;
 	strscpy(name, target->name, sizeof(name));
 	module_put(target->me);
-	strncpy(t->u.user.name, name, sizeof(t->u.user.name));
+	strscpy(t->u.user.name, name, sizeof(t->u.user.name));
 
 	*size += off;
 	*dstptr += tsize;
@@ -2014,4 +2014,3 @@ static void __exit xt_fini(void)
 
 module_init(xt_init);
 module_exit(xt_fini);
-

-- 
2.41.0.640.ga95def55d0-goog

