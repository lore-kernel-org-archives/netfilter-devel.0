Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CD6FC05052
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Aug 2023 01:07:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbjHIBHr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 8 Aug 2023 21:07:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231441AbjHIBHp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Aug 2023 21:07:45 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E4E319BC
        for <netfilter-devel@vger.kernel.org>; Tue,  8 Aug 2023 18:07:44 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-56942667393so79031867b3.2
        for <netfilter-devel@vger.kernel.org>; Tue, 08 Aug 2023 18:07:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691543263; x=1692148063;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ib6nqOI6OhZk9uVMuCMDveLdue/VtxmtzrsTXPIDYRI=;
        b=ZoQqX5UIeq1jO5/Y5J5W2a7PzzXsb8d0S2K9nNc0sxvuHfEUau2nSLFvWWx5TabJYG
         9AjCKoQscaQ3FibFIL636z6Qkx9MWiHi+jZzcS09eay2ZGG8ou0eqWAgykq7xE935CdT
         Y/BBWwHMbzudYeSVdUcGcDGZAbpW2ULHrvSazCEcoWFyxdgAZRZLgJVtM3QvN5w995cD
         4gKNjSaX2/YVLXjoYMhH6jmDrKOeTQd47uGISSSDdR/wLa+Fr8lRe9HTNHcg+y0+ZlpS
         kC53/iPBs+RI23nXLKLuKb3pyVovbV5P1iJTe8dt2Rr+HJB4qllUtIoJ/lAhndvVoFC4
         KPSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691543263; x=1692148063;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ib6nqOI6OhZk9uVMuCMDveLdue/VtxmtzrsTXPIDYRI=;
        b=cwQIV00wegK+vnzlpinyLbPmnqO0nJjmSTqAN2muKaW9K2l/8KFQnQjORakWBoVqRV
         Gb5lm6clRr+JMkmmDHN2PycS6FCj8M9FQm1Fyi440z44TP8W639vGDrgaQauqWerHdZP
         sZ6sjum6cdYgQwqq/s6kZwEmpbLlgg3Pzen2NJflgXl9eowsPG6RaBvthVcZ0PIyAQ5x
         /ACBY+q3rJVHIlQcdMrtmRAU27s4iAsWOyDwM1FYscvi8uQfMFi+VeLCj+HgPWdwrIWA
         YKBqyyBESDF3Rwpem1UFwr/g17f2+OcqysLdCsO4LfKdyhal6GbcjikvWzaN2ZAeY1Sl
         QgJg==
X-Gm-Message-State: AOJu0Yzq+YaqIEU/I86H9sKRECrlvP++rCNHl6G09+rueeaUqdGVRnNe
        9TfCMZQsBVvss2ewD71l86mIkOt4cKmOpgyCHQ==
X-Google-Smtp-Source: AGHT+IH5kjZOtu7DJJU2kcy5MUvh/1RM5TDPejbuQtilClG6fsAJ6QcOKvf1F+QzpdoZcY4Uz8jB2YjF0tOQbZPbdQ==
X-Received: from jstitt-linux1.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:23b5])
 (user=justinstitt job=sendgmr) by 2002:a25:ab62:0:b0:d4c:f456:d54f with SMTP
 id u89-20020a25ab62000000b00d4cf456d54fmr22714ybi.8.1691543263329; Tue, 08
 Aug 2023 18:07:43 -0700 (PDT)
Date:   Wed, 09 Aug 2023 01:06:07 +0000
In-Reply-To: <20230809-net-netfilter-v2-0-5847d707ec0a@google.com>
Mime-Version: 1.0
References: <20230809-net-netfilter-v2-0-5847d707ec0a@google.com>
X-Developer-Key: i=justinstitt@google.com; a=ed25519; pk=tC3hNkJQTpNX/gLKxTNQKDmiQl6QjBNCGKJINqAdJsE=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1691543258; l=1342;
 i=justinstitt@google.com; s=20230717; h=from:subject:message-id;
 bh=7ETYnKTeQUVzYvHKo3dCw3Fgg8Ju8JACIFGAct1WkOg=; b=vu0OZUT90qel7Bct4/ripVcEolXMpugmp7bRnKPUqOl8EyTjsFcrN5q5j/s4LBuhdPWIHYjOi
 wh7kSdYgds5BsJcyjEsLKuA3/gws5T6+wjRr5B/LR0IzcPd3PBc/Kf/
X-Mailer: b4 0.12.3
Message-ID: <20230809-net-netfilter-v2-4-5847d707ec0a@google.com>
Subject: [PATCH v2 4/7] netfilter: nft_meta: refactor deprecated strncpy
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

Prefer `strscpy_pad` to `strncpy`.

Signed-off-by: Justin Stitt <justinstitt@google.com>
---
 net/netfilter/nft_meta.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 8fdc7318c03c..f7da7c43333b 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -185,12 +185,12 @@ static noinline bool nft_meta_get_eval_kind(enum nft_meta_keys key,
 	case NFT_META_IIFKIND:
 		if (!in || !in->rtnl_link_ops)
 			return false;
-		strncpy((char *)dest, in->rtnl_link_ops->kind, IFNAMSIZ);
+		strscpy_pad((char *)dest, in->rtnl_link_ops->kind, IFNAMSIZ);
 		break;
 	case NFT_META_OIFKIND:
 		if (!out || !out->rtnl_link_ops)
 			return false;
-		strncpy((char *)dest, out->rtnl_link_ops->kind, IFNAMSIZ);
+		strscpy_pad((char *)dest, out->rtnl_link_ops->kind, IFNAMSIZ);
 		break;
 	default:
 		return false;
@@ -206,7 +206,7 @@ static void nft_meta_store_ifindex(u32 *dest, const struct net_device *dev)
 
 static void nft_meta_store_ifname(u32 *dest, const struct net_device *dev)
 {
-	strncpy((char *)dest, dev ? dev->name : "", IFNAMSIZ);
+	strscpy_pad((char *)dest, dev ? dev->name : "", IFNAMSIZ);
 }
 
 static bool nft_meta_store_iftype(u32 *dest, const struct net_device *dev)

-- 
2.41.0.640.ga95def55d0-goog

