Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A4CEC64EC4
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Mar 2023 01:35:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbjCIBfM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 8 Mar 2023 20:35:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjCIBfL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Mar 2023 20:35:11 -0500
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CE6C5F507
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Mar 2023 17:35:09 -0800 (PST)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id E84B72C0939;
        Thu,  9 Mar 2023 14:35:03 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1678325703;
        bh=X3nUrZ886/htbepA6mrM1b9fUhoKcR2EIKJK7BGU1MA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qVWjSfIAWS3Dn13pghKHEqZZi1O3o585VtBG+UEyqXCvBNB8U1nC4OAKf3Pj6jc2h
         f+sAg51OEuAsyMf9bqaedbHQSCAJAfTYrZSafLJ3KAU9rgv+S1eOqFuU5OU2szIcQN
         4FBK+rqzm9PixXXgGNGtRuO+XaNwM9KpIgrrZ0YF3U8cHIJiDZsFBnxrFIHu3mzYux
         w+xgD9Rd9mxt/HYmXTSlJXu9ASwaW7jF0w/WN7fM78P4N2u55mn7GjM0ZRF74Xhd2f
         OA6DXzhb4kT7R0UwMqKdqD3Xyx3cH9sHuS1AKSEanWGKzvtPc7wu/Uzx3lqEeH+Arf
         /4AXN9dWHs4+w==
Received: from pat.atlnz.lc (Not Verified[10.32.16.33]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B640937c70000>; Thu, 09 Mar 2023 14:35:03 +1300
Received: from kyuwons-dl.ws.atlnz.lc (unknown [10.33.25.18])
        by pat.atlnz.lc (Postfix) with ESMTP id BF0F813EE44;
        Thu,  9 Mar 2023 14:26:11 +1300 (NZDT)
Received: by kyuwons-dl.ws.atlnz.lc (Postfix, from userid 1880)
        id B3D0F280044; Thu,  9 Mar 2023 14:25:46 +1300 (NZDT)
From:   Kyuwon Shim <kyuwon.shim@alliedtelesis.co.nz>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org,
        Kyuwon Shim <kyuwon.shim@alliedtelesis.co.nz>
Subject: [PATCH v2] ulogd2: Avoid use after free in unregister on global ulogd_fds linked list
Date:   Thu,  9 Mar 2023 14:24:47 +1300
Message-Id: <20230309012447.201582-1-kyuwon.shim@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <1678233154187.35009@alliedtelesis.co.nz>
References: <1678233154187.35009@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-SEG-SpamProfiler-Analysis: v=2.3 cv=GdlpYjfL c=1 sm=1 tr=0 a=KLBiSEs5mFS1a/PbTCJxuA==:117 a=k__wU0fu6RkA:10 a=PanMkhJExRnxMt3dukEA:9
X-SEG-SpamProfiler-Score: 0
x-atlnz-ls: pat
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The issue "core dumped" occurred  from
ulogd_unregister_fd(). One of the processes is unlink
from list and remove, but some struct 'pi' values
freed without ulogd_unregister_fd().
Unlink process needs to access the previous pointer
value of struct 'pi', but it was already freed.

Therefore, the free() process moved location
after finishing all ulogd_unregister_fd().

Signed-off-by: Kyuwon Shim <kyuwon.shim@alliedtelesis.co.nz>
---

Notes:
    Add new patch revision in plain-text that applies cleanly to master

 src/ulogd.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/src/ulogd.c b/src/ulogd.c
index 8ea9793ec..944637e0d 100644
--- a/src/ulogd.c
+++ b/src/ulogd.c
@@ -1334,6 +1334,11 @@ static void stop_pluginstances()
 				(*pi->plugin->stop)(pi);
 				pi->private[0] =3D 0;
 			}
+		}
+	}
+
+	llist_for_each_entry(stack, &ulogd_pi_stacks, stack_list) {
+		llist_for_each_entry_safe(pi, npi, &stack->list, list) {
 			free(pi);
 		}
 	}
--=20
2.39.0

