Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06F34C41513
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Aug 2023 22:48:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230410AbjHHWsg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 8 Aug 2023 18:48:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbjHHWsf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Aug 2023 18:48:35 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC672125
        for <netfilter-devel@vger.kernel.org>; Tue,  8 Aug 2023 15:48:34 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-58960b53007so24636337b3.3
        for <netfilter-devel@vger.kernel.org>; Tue, 08 Aug 2023 15:48:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691534914; x=1692139714;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TmxbnIjb/GqnmOwdg1rDIRZFSHSZsVM8YSAQMHLnbME=;
        b=aIe42t0D+ftKfG+ClAKmcOJv9mfebYDaQmvdUgboDYiuG7ilotz/5nbttvtF9fDi1O
         rDs+7df7Cjn2shLvTm3qNsiEBm8OAhAGyBYA8+AW/pofGiv6RHPapbcws6nbEk9HrPGS
         jdpUQ2BCppjQpV6sMqGiCLG4WGKm2D7YKRlPEGM+eVzHKsUpnoDU0g025UZnAtmR5xKS
         69kyYON2cNSaE9f11a+LbFMqSZNt4tUq/usnE638ystMj35JNiukiKDpxLr0+iFW4Iwk
         J0bUrgboDjs3jAOSnOJyEJ65ZJ5Jx29Wa8GeSwiRYeXVg8OBaqUv/tSju9f+CoMdqa+d
         o0+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691534914; x=1692139714;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TmxbnIjb/GqnmOwdg1rDIRZFSHSZsVM8YSAQMHLnbME=;
        b=GI/jFy4C9wdsmmludz0xnp5UU2hrykWVnDha7ynhx3Va5ix5I8na1TBeWargHtyt/A
         t4UGKtDVsZWOHRSSSYg+e4SAn82cL0Xc1nqOm14Q99GpVEUr1HwXkuxn7u76+HGixU8G
         PB2XFVonYfp19ttF7rSwL9mNC6aCTLq04/4d1B+OpaF1xcm/A3MXc6uezb2rIbtJFSsa
         Y2uakhuf4ZjS5cQSLXAEj8ogvmmofe4lNiaUMBZzALZLvl/mKGvc+C13ugjsNRFokah2
         RMObOFC5KuSZONK4YRvAygf8C1etLKeK4xspgU44u4uyqfYh01q6J2TvOBiv0VzPMZwX
         4oWg==
X-Gm-Message-State: AOJu0Yxrq6COdr8xpFu373Ew/a5m/b6LsCy+sJE1zaeHdH4n0Uf8qOgm
        jMcsDYWizGn2HyEM0CumGkxzcI4U6zpLQlT4/w==
X-Google-Smtp-Source: AGHT+IH1R6MtPcgGGYPgM2RykK/TeOvNqFtYstVlX2iypy2EipYIxRKnBXKcog/LYd4QF5rzW3sffHKNadArPUWkLg==
X-Received: from jstitt-linux1.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:23b5])
 (user=justinstitt job=sendgmr) by 2002:a81:440f:0:b0:576:9519:7085 with SMTP
 id r15-20020a81440f000000b0057695197085mr21593ywa.7.1691534914271; Tue, 08
 Aug 2023 15:48:34 -0700 (PDT)
Date:   Tue, 08 Aug 2023 22:48:06 +0000
In-Reply-To: <20230808-net-netfilter-v1-0-efbbe4ec60af@google.com>
Mime-Version: 1.0
References: <20230808-net-netfilter-v1-0-efbbe4ec60af@google.com>
X-Developer-Key: i=justinstitt@google.com; a=ed25519; pk=tC3hNkJQTpNX/gLKxTNQKDmiQl6QjBNCGKJINqAdJsE=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1691534912; l=2289;
 i=justinstitt@google.com; s=20230717; h=from:subject:message-id;
 bh=DmlnBBnHsP5QeIGI++tEAn9BIzXi+bfjHimTMSaz/pg=; b=620tlRlsF6w/UUZG5WGZx2U4Mf2LH5YYLrf8rikieAPOtoORP/uUHedtmuqLWAwhLMG5oiohV
 aRW3uUVCq+7BzN6wbjpH81lJbtdkmWqFFVPVtC/eGuYqCKR1vIDbvcj
X-Mailer: b4 0.12.3
Message-ID: <20230808-net-netfilter-v1-1-efbbe4ec60af@google.com>
Subject: [PATCH 1/7] netfilter: ipset: refactor deprecated strncpy
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

Fixes several buffer overread bugs present in `ip_set_core.c` by using
`strscpy` over `strncpy`.

Link: https://github.com/KSPP/linux/issues/90
Cc: linux-hardening@vger.kernel.org
Signed-off-by: Justin Stitt <justinstitt@google.com>

---
There exists several potential buffer overread bugs here. These bugs
exist due to the fact that the destination and source strings may have
the same length which is equal to the max length `IPSET_MAXNAMELEN`.

Here's an example:
|  #define MAXLEN 5
|  char dest[MAXLEN];
|  const char *src = "hello";
|  strncpy(dest, src, MAXLEN); // -> should use strscpy()
|  // dest is now not NUL-terminated

Note:
This patch means that truncation now happens silently (which is better
than a silent bug) but perhaps we should have some assertions that
fail when a truncation is imminent. Thoughts?
---
 net/netfilter/ipset/ip_set_core.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 0b68e2e2824e..fc77080d41a2 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -872,7 +872,7 @@ ip_set_name_byindex(struct net *net, ip_set_id_t index, char *name)
 	BUG_ON(!set);
 
 	read_lock_bh(&ip_set_ref_lock);
-	strncpy(name, set->name, IPSET_MAXNAMELEN);
+	strscpy(name, set->name, IPSET_MAXNAMELEN);
 	read_unlock_bh(&ip_set_ref_lock);
 }
 EXPORT_SYMBOL_GPL(ip_set_name_byindex);
@@ -1326,7 +1326,7 @@ static int ip_set_rename(struct sk_buff *skb, const struct nfnl_info *info,
 			goto out;
 		}
 	}
-	strncpy(set->name, name2, IPSET_MAXNAMELEN);
+	strscpy(set->name, name2, IPSET_MAXNAMELEN);
 
 out:
 	write_unlock_bh(&ip_set_ref_lock);
@@ -1380,9 +1380,9 @@ static int ip_set_swap(struct sk_buff *skb, const struct nfnl_info *info,
 		return -EBUSY;
 	}
 
-	strncpy(from_name, from->name, IPSET_MAXNAMELEN);
-	strncpy(from->name, to->name, IPSET_MAXNAMELEN);
-	strncpy(to->name, from_name, IPSET_MAXNAMELEN);
+	strscpy(from_name, from->name, IPSET_MAXNAMELEN);
+	strscpy(from->name, to->name, IPSET_MAXNAMELEN);
+	strscpy(to->name, from_name, IPSET_MAXNAMELEN);
 
 	swap(from->ref, to->ref);
 	ip_set(inst, from_id) = to;

-- 
2.41.0.640.ga95def55d0-goog

