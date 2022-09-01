Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD7C9C0502C
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Sep 2022 03:06:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231954AbiIADG2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 31 Aug 2022 23:06:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232211AbiIADGY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 31 Aug 2022 23:06:24 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31030E7258
        for <netfilter-devel@vger.kernel.org>; Wed, 31 Aug 2022 20:06:16 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id w2so15917310pld.0
        for <netfilter-devel@vger.kernel.org>; Wed, 31 Aug 2022 20:06:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=HBoZfnQNI+HfqlpbIESjGhVcV3oI45aOaNXfV3ZCT+M=;
        b=eTuTwVYJ0tOmU7pb1JotZVoA2KlqihO9iBSjlDBRFwaMAH5iJ1lsOrdpz2Pe913xHf
         8NqsUwncBSOtPvPbdv1/ONLmyfZ1lNFYDZ81/b/dFd6dBsv/uifMvEE+GJzCeiWHwfX6
         x7FyuJIu4a/fYrGZJECePZTFpQ3sIYahfwxyQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=HBoZfnQNI+HfqlpbIESjGhVcV3oI45aOaNXfV3ZCT+M=;
        b=P8VBcD1H1q2hZC0u7HUgX1GCfxN/n7CyF10ELdOpZD+DBBRjgXmsthiGFPm5T//z0T
         8ub5K6qHkY6JEMS5abfIlc60vCWYrVAZi96urB+Zqheqr0h0bYr1bQNh2kYN/70MlpMg
         2680YiMpYLrqZ6FcyXqlmb5SuJQF3bKvez+GRAuHCR6h+/IrMcxVitZ5hqR6YZgEz4rR
         vSCXAHPxluyPJlXMxVprhDcn9kWjXwl7+A+mBIUlvHdESVKeUsQOprpqS69I60e+drwP
         qp9LwQslZdCTErTkRzM3QQLV5wjgUT2LW1Sk5GwzZpwuEjpCsxJNaK2kSA/V2WBFkrOc
         SCmg==
X-Gm-Message-State: ACgBeo1xgelZOjNVhYdC8ba8yberYXUSA3S389wPFS9L9/mgmHazPVUR
        6ltbeaBhYloDmBspGWMbj8oDAQ==
X-Google-Smtp-Source: AA6agR5/U6baaN5sD2EdExrJ5F5GC2Bv1QNsCjGqfLFKYQTmttofQxGHKCgZ2TpKIwzvQ9M5FDgCag==
X-Received: by 2002:a17:903:2d0:b0:172:b63b:3a1e with SMTP id s16-20020a17090302d000b00172b63b3a1emr28934419plk.76.1662001575695;
        Wed, 31 Aug 2022 20:06:15 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id u17-20020a627911000000b00536b975b013sm11958015pfc.24.2022.08.31.20.06.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 20:06:14 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        syzbot <syzkaller@googlegroups.com>,
        Yajun Deng <yajun.deng@linux.dev>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH 1/2] netlink: Bounds-check nlmsg_len()
Date:   Wed, 31 Aug 2022 20:06:09 -0700
Message-Id: <20220901030610.1121299-2-keescook@chromium.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220901030610.1121299-1-keescook@chromium.org>
References: <20220901030610.1121299-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1489; h=from:subject; bh=kTIzPiI3XGTCF2tMjW+3PGFXwtUGmpz93ALVlrdAflg=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBjECGinowdI8+RbQIJuuvIuxm1f6BHZsT/hX1WUouh UA4VBdSJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYxAhogAKCRCJcvTf3G3AJlauEA Cjt6bHTa4IjL851iMSju08HCU9JQ6MwajPOCSHt4nnmCGRsSHXlfDDjuj2d58oqlprjPDnQfZud9FS DudDKadlPVZaEtXzu48IydekR5zXcFEBQxZ5bXgNrxSifHhPUy+5OAaJ3fNWmlhY2rh5ANa+rup4Rq VAq5mVSdWRlDQybKX6CmAVsa/vIbuwPHbRaYYX3/3g1/fDO5dwKs67QQ8QCq4OU8RVGLrJgWHJGmu0 mWZhKMqxJq2vcnGtKuo3BVdkgnAxBq3qgOJpMB8Ww45MyWkueEe2xsZ14gDzlMf2cnPwnqsjL5fbPz DnEOtSBNhoBrhTqp4CTuw8P/O/+UVvfcf5DnVhbD8TbPKU/yxmwWqbNQKfv7ullrEcskEGcCGmvhEJ lot0bIf3p/Ac8IRtXqoj+6lX9oOCAiJcx1Qhn7Cdel2YiRdliYS1GkJMiM3TFbXqXuNaX5kyAte9oJ /E2bNIkA3HSZjRGVZVjs5JehwOj6RKLaECUgTLzi6Jl3jJ/RKe3Gp3c8ysX3uCoj8o7OCNiDsFP8Is L00xAMueWLjxGfSChP0JJGc/SSOu17Vl8nGpk08bP/NHhQ0WZpntJbrnLPqinCibDd3mJoAjWPAS0x 6qeYdXnqrYDsDocjZeW1zdzaGdldu7u7vWN9p5o6DM2I3BMsjWCbilArMPAw==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The nlmsg_len() helper returned "int" from a u32 calculation that could
possible go negative. WARN() if this calculation ever goes negative
(instead returning 0), or if the result would be larger than INT_MAX
(instead returning INT_MAX).

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>
Cc: syzbot <syzkaller@googlegroups.com>
Cc: Yajun Deng <yajun.deng@linux.dev>
Cc: netdev@vger.kernel.org
Cc: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/net/netlink.h | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/net/netlink.h b/include/net/netlink.h
index 7a2a9d3144ba..f8cb0543635e 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -576,7 +576,15 @@ static inline void *nlmsg_data(const struct nlmsghdr *nlh)
  */
 static inline int nlmsg_len(const struct nlmsghdr *nlh)
 {
-	return nlh->nlmsg_len - NLMSG_HDRLEN;
+	u32 nlmsg_contents_len;
+
+	if (WARN_ON_ONCE(check_sub_overflow(nlh->nlmsg_len,
+					    (u32)NLMSG_HDRLEN,
+					    &nlmsg_contents_len)))
+		return 0;
+	if (WARN_ON_ONCE(nlmsg_contents_len > INT_MAX))
+		return INT_MAX;
+	return nlmsg_contents_len;
 }
 
 /**
-- 
2.34.1

