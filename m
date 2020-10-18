Return-Path: <SRS0=5q/u=DZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9135EC43457
	for <netfilter-devel@archiver.kernel.org>; Sun, 18 Oct 2020 19:22:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58ED422314
	for <netfilter-devel@archiver.kernel.org>; Sun, 18 Oct 2020 19:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603048934;
	bh=erirBj+id5WbO7LuzZecGHTrXUTfVKhr636rTk4qpHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=uzU/r/ITsw6Xeq06s2CU5kJucNSjk8AnoGoRfoZ1SCMbu+E2kSNVqvZTgOa0BB85N
	 OavGFzsIAxxSf0ZC/hKLEpRpDtav1UER98iNcbYgIpn3VQnRXzKy5lO5G+oYV1FhX1
	 gFusV+dlmHmj/CUoWUTC6+0jQwFJJwaChVmQRrAU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729758AbgJRTWN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 18 Oct 2020 15:22:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:34846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728304AbgJRTWL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 18 Oct 2020 15:22:11 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75AA5222EA;
        Sun, 18 Oct 2020 19:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603048930;
        bh=erirBj+id5WbO7LuzZecGHTrXUTfVKhr636rTk4qpHo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ABEBVezeUkR+NrJCWoKrTMFlSlQbwCJ0c3zsBbplUp8tvlYDJVnTrqvm60r7MLh3C
         Q9WvxKGROp7ZWSYHYCNYHcawd0PiyzCPRgb/V4r9VGBBNAmknUIFzyOUrzweu5yinr
         DAVTTK27q6cLav4UbA1GWJVnzVcfddDNvTTi8svQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peilin Ye <yepeilin.cs@gmail.com>,
        syzbot+23b5f9e7caf61d9a3898@syzkaller.appspotmail.com,
        Julian Anastasov <ja@ssi.bg>,
        Simon Horman <horms@verge.net.au>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
Subject: [PATCH AUTOSEL 5.8 086/101] ipvs: Fix uninit-value in do_ip_vs_set_ctl()
Date:   Sun, 18 Oct 2020 15:20:11 -0400
Message-Id: <20201018192026.4053674-86-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192026.4053674-1-sashal@kernel.org>
References: <20201018192026.4053674-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Peilin Ye <yepeilin.cs@gmail.com>

[ Upstream commit c5a8a8498eed1c164afc94f50a939c1a10abf8ad ]

do_ip_vs_set_ctl() is referencing uninitialized stack value when `len` is
zero. Fix it.

Reported-by: syzbot+23b5f9e7caf61d9a3898@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?id=46ebfb92a8a812621a001ef04d90dfa459520fe2
Suggested-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
Reviewed-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipvs/ip_vs_ctl.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 412656c34f205..beeafa42aad76 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -2471,6 +2471,10 @@ do_ip_vs_set_ctl(struct sock *sk, int cmd, void __user *user, unsigned int len)
 		/* Set timeout values for (tcp tcpfin udp) */
 		ret = ip_vs_set_timeout(ipvs, (struct ip_vs_timeout_user *)arg);
 		goto out_unlock;
+	} else if (!len) {
+		/* No more commands with len == 0 below */
+		ret = -EINVAL;
+		goto out_unlock;
 	}
 
 	usvc_compat = (struct ip_vs_service_user *)arg;
@@ -2547,9 +2551,6 @@ do_ip_vs_set_ctl(struct sock *sk, int cmd, void __user *user, unsigned int len)
 		break;
 	case IP_VS_SO_SET_DELDEST:
 		ret = ip_vs_del_dest(svc, &udest);
-		break;
-	default:
-		ret = -EINVAL;
 	}
 
   out_unlock:
-- 
2.25.1

