Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66F5BC433EF
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Feb 2022 05:14:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234620AbiBCFOD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Feb 2022 00:14:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236558AbiBCFOC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Feb 2022 00:14:02 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F034C061714
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Feb 2022 21:14:02 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id d5so1377912pjk.5
        for <netfilter-devel@vger.kernel.org>; Wed, 02 Feb 2022 21:14:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dmoRoT8I7I9kz//lyHwib/w9kuPCbd/kFHLbqIRC3pA=;
        b=EopiYDmWHWXRJV9Spvar3CjynZ6gnIDneSWHHUeNoIFM0ndYOYZjDTFg2TjJJ4AGYg
         Yzzzh+UOAQiGn4MDIP5veIyQxct81wWXNvDbeQ3clrYpkdoXrorpFS/CVnZYaHqy0XhL
         HwULhvhGiCRApvRSE5jUSOtXfZPW8fKcO3ymJXNe+PbRNJr3U6Fa4sJGg75jf+ANbMul
         W394DlCYQQWyKQWXkpUsFny6A5LwGA1FeUjs04SFQu/fjJKf4G2yAxXZWDuaoqS8TuW3
         KMG5Y1G+gjdV3ipb024hRjJKmvbdYBqzvUka9ZKROc48fbSCdXkF6U7dCV+PjW5Cy1vV
         Eg5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dmoRoT8I7I9kz//lyHwib/w9kuPCbd/kFHLbqIRC3pA=;
        b=lDWz4kKz0TRth3xD5rtThpOiuvFWVW7IwvrATF5jUZfta8ZwY5U5hEzg8tEIMBWk3Q
         o7dFQYcdRPOyaqGlEkuywTB/AgOxVYYPM8HeTowpUhkDVZEyWWYOg0+02zwdY+0XKImR
         1VTrMIlBxXbBJhRqZi4RlkMjxhR01Wqp7oQqjELlnLLavoggA773eQtEmy1XtrmvKU1a
         67eJkyZ9xl/GkUCZsUwj5nVJKMGbS9xUZzctNFSJ55HJp/TkTQVg6U0xnntUFzMG3CQQ
         DYye7MuBZYDqb4dKbdSMY4WpcYJnNpVNradfN7/TaOGCVPIrCPeLXLC45TTwUBv5x787
         aAjQ==
X-Gm-Message-State: AOAM531n8jzjli0yjRoYNmANs3vZQnj8zW4DClCEdJ5B1mKx5fXHbT8X
        6NazdDZFqCtPN0hj550Gn2PRh3zFisA=
X-Google-Smtp-Source: ABdhPJw4l6WkngwN7nTwyoA5R73n+qvbUyy12GuoFzsomEhI0R9QVGJhRGwl50vAwtA+rD0xfy0dwg==
X-Received: by 2002:a17:90b:1881:: with SMTP id mn1mr11871422pjb.236.1643865241640;
        Wed, 02 Feb 2022 21:14:01 -0800 (PST)
Received: from vimal-VirtualBox.. ([49.207.201.237])
        by smtp.gmail.com with ESMTPSA id ot9sm5372279pjb.47.2022.02.02.21.13.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 21:14:01 -0800 (PST)
From:   Vimal Agrawal <avimalin@gmail.com>
X-Google-Original-From: Vimal Agrawal <vimal.agrawal@sophos.com>
To:     netfilter-devel@vger.kernel.org, pablo@netfilter.org, fw@strlen.dea
Cc:     vimal.agrawal@sophos.com, avimalin@gmail.com
Subject: [PATCH] netfilter: nat: limit port clash resolution attempts
Date:   Thu,  3 Feb 2022 10:43:29 +0530
Message-Id: <20220203051329.118778-1-vimal.agrawal@sophos.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

commit a504b703bb1da526a01593da0e4be2af9d9f5fa8 ("netfilter: nat:
limit port clash resolution attempts")

In case almost or all available ports are taken, clash resolution can
take a very long time, resulting in soft lockup.

This can happen when many to-be-natted hosts connect to same
destination:port (e.g. a proxy) and all connections pass the same SNAT.

Pick a random offset in the acceptable range, then try ever smaller
number of adjacent port numbers, until either the limit is reached or a
useable port was found.  This results in at most 248 attempts
(128 + 64 + 32 + 16 + 8, i.e. 4 restarts with new search offset)
instead of 64000+,

Signed-off-by: Vimal Agrawal <vimal.agrawal@sophos.com>
---
 net/netfilter/nf_nat_proto_common.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_nat_proto_common.c b/net/netfilter/nf_nat_proto_common.c
index 7d7466dbf663..d0d9747f68a9 100644
--- a/net/netfilter/nf_nat_proto_common.c
+++ b/net/netfilter/nf_nat_proto_common.c
@@ -41,9 +41,10 @@ void nf_nat_l4proto_unique_tuple(const struct nf_nat_l3proto *l3proto,
 				 const struct nf_conn *ct,
 				 u16 *rover)
 {
-	unsigned int range_size, min, max, i;
+	unsigned int range_size, min, max, i, attempts;
 	__be16 *portptr;
-	u_int16_t off;
+	u16 off;
+	static const unsigned int max_attempts = 128;
 
 	if (maniptype == NF_NAT_MANIP_SRC)
 		portptr = &tuple->src.u.all;
@@ -87,14 +88,30 @@ void nf_nat_l4proto_unique_tuple(const struct nf_nat_l3proto *l3proto,
 		off = *rover;
 	}
 
-	for (i = 0; ; ++off) {
+	attempts = range_size;
+	if (attempts > max_attempts)
+		attempts = max_attempts;
+
+	/* We are in softirq; doing a search of the entire range risks
+	 * soft lockup when all tuples are already used.
+	 *
+	 * If we can't find any free port from first offset, pick a new
+	 * one and try again, with ever smaller search window.
+	 */
+another_round:
+	for (i = 0; i < attempts; i++, off++) {
 		*portptr = htons(min + off % range_size);
-		if (++i != range_size && nf_nat_used_tuple(tuple, ct))
+		if (nf_nat_used_tuple(tuple, ct))
 			continue;
 		if (!(range->flags & NF_NAT_RANGE_PROTO_RANDOM_ALL))
 			*rover = off;
 		return;
 	}
+	if (attempts >= range_size || attempts < 16)
+		return;
+	attempts /= 2;
+	off = prandom_u32();
+	goto another_round;
 }
 EXPORT_SYMBOL_GPL(nf_nat_l4proto_unique_tuple);
 
-- 
2.32.0

