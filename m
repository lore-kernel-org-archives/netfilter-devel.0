Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F7D4C433FE
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Dec 2021 17:33:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351615AbhLARhS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 1 Dec 2021 12:37:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351965AbhLARg3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Dec 2021 12:36:29 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EB3DC061761
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Dec 2021 09:33:07 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id v11so54002526wrw.10
        for <netfilter-devel@vger.kernel.org>; Wed, 01 Dec 2021 09:33:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JxRUTnzhNpE6A+t/cHaRLhU7lgRrlmtnYl4WoLaNQEQ=;
        b=Wmadw/CFtRD/B+Tuqn5TweDK6rurhxUPuZQW4c0ZG0xP82ns07ZIQ7ULARQCi/FI03
         63bhU3yGKefW1eqv+9o+/5upJY9Tg4uZOfjxkkdkaPzxMJdzZMO+TZbwPvUl+L38Lu/n
         FnCyjC941IrQPs67IMsyb+bR6jy8ME0tk/A5Fol3kCYGR5RkZDTgxO0brA5nZQSTmwSy
         pVOFLiTogo61NNhCESJ4lww758rkCcm8+c5aFfI/ixXepbsd4WehJzf70lRcujvwVJS6
         lLyYgpIH7JgUcwT1/UWBOwlCchX6GF2Gxs3RoUpHCNaBnjp7jKz7Yr/7rUcXaFa83zVW
         cbHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JxRUTnzhNpE6A+t/cHaRLhU7lgRrlmtnYl4WoLaNQEQ=;
        b=uaOX7JOT+thaBCky/7AOklpQA/EhFxj0sgkP0nEpao5BRnUaZVe3Il5Po9KkIyTQ9k
         zgJZlaJM1lr8tneXRVj8tad5YVR6owS5jFT6wkzeJKtNUecRKuW2F8P0pVcmxqAkQhat
         mGuvEojb8FbMw4fzhDUz1X9mrK+o995ZVpVLcI1Z6KG6x0kmzZKEqhclzEVwgu5PQF9a
         /VX/0/s/ILUr33bb29TpcpjSZAs91xKl2idRKn3wlxEeHz/U0z+tgmUU/Wl+H49Pjfld
         AlmN6C7dKh9lPE6ym7kbSIL6ystfEk4FE32tzFWxvXO/1D/3TIV9bzeEJwV6mVu016Yb
         xC4w==
X-Gm-Message-State: AOAM530qJjWBcMBa2qjKRcVRpqhp/vuQyP8n4kXC71pA2QKimrQuadwY
        DEHnA8E1ENXd9tcsQHweErpHfh90aeyGCg==
X-Google-Smtp-Source: ABdhPJwN29aE4+R/1w+bopVyKZZJTEIDG4lgZXKdE4EMZiuIPFicSP9lBP2Syc+Qldalv2frRbouLQ==
X-Received: by 2002:a05:6000:1688:: with SMTP id y8mr8717006wrd.420.1638379985395;
        Wed, 01 Dec 2021 09:33:05 -0800 (PST)
Received: from msennikovskii4.fkb.profitbricks.net (ip5f5bf77c.dynamic.kabel-deutschland.de. [95.91.247.124])
        by smtp.gmail.com with ESMTPSA id r17sm1918291wmq.5.2021.12.01.09.33.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 09:33:03 -0800 (PST)
From:   Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
To:     netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        mikhail.sennikovsky@gmail.com
Cc:     Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
Subject: [PATCH 2/6] conntrack: use libmnl for conntrack entry creation
Date:   Wed,  1 Dec 2021 18:32:49 +0100
Message-Id: <20211201173253.33432-3-mikhail.sennikovskii@ionos.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211201173253.33432-1-mikhail.sennikovskii@ionos.com>
References: <20211201173253.33432-1-mikhail.sennikovskii@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Use libmnl and libnetfilter_conntrack mnl helpers to create the conntrack
table entries.

Signed-off-by: Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
---
 src/conntrack.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index d37f130..f042d9d 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -2504,6 +2504,16 @@ nfct_mnl_get(uint16_t subsys, uint16_t type, mnl_cb_t cb, uint8_t family)
 		      cb, NULL);
 }
 
+static int
+nfct_mnl_create(uint16_t subsys, uint16_t type, const struct nf_conntrack *ct)
+{
+	return nfct_mnl_call(subsys, type,
+		      NLM_F_REQUEST|NLM_F_CREATE|NLM_F_ACK|NLM_F_EXCL,
+		      ct, 0,
+		      NULL,
+		      NULL, NULL);
+}
+
 #define UNKNOWN_STATS_NUM 4
 
 static int nfct_stats_attr_cb(const struct nlattr *attr, void *data)
@@ -3321,14 +3331,17 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 			nfct_set_attr(cmd->tmpl.ct, ATTR_CONNLABELS,
 					xnfct_bitmask_clone(cmd->tmpl.label_modify));
 
-		cth = nfct_open(CONNTRACK, 0);
-		if (!cth)
-			exit_error(OTHER_PROBLEM, "Can't open handler");
+		res = nfct_mnl_socket_open(0);
+		if (res < 0)
+			exit_error(OTHER_PROBLEM, "Can't open netlink socket");
 
-		res = nfct_query(cth, NFCT_Q_CREATE, cmd->tmpl.ct);
-		if (res != -1)
+		res = nfct_mnl_create(NFNL_SUBSYS_CTNETLINK,
+							IPCTNL_MSG_CT_NEW,
+							cmd->tmpl.ct);
+		if (res >= 0)
 			counter++;
-		nfct_close(cth);
+
+		nfct_mnl_socket_close();
 		break;
 
 	case EXP_CREATE:
-- 
2.25.1

