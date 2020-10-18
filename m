Return-Path: <SRS0=5q/u=DZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6BA2C433E7
	for <netfilter-devel@archiver.kernel.org>; Sun, 18 Oct 2020 19:37:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C2C8206CA
	for <netfilter-devel@archiver.kernel.org>; Sun, 18 Oct 2020 19:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603049872;
	bh=JC0Y0QPLd4dv2Chd2uSnFM6k2pNn9+xYOM4MwLSX+Ps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=QtVv+2NdSG/6JiihlogKc/E8J3sIP4wLMC+6OVs7kPgTsubq6rujpj2hRbyEjcoNX
	 8fZIN7I+GOrK8ZCWIUmnU8MOzZBmvojJT44LY6gqWAnJ1UTqTOfPXILMSQBtJy+D2I
	 /1bcMuuwFsZQG+2rLxaGIhyB5bRJkTUFr0b+z9Bw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732833AbgJRTho (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 18 Oct 2020 15:37:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:39718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731228AbgJRTZT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 18 Oct 2020 15:25:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5A2C222C8;
        Sun, 18 Oct 2020 19:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603049119;
        bh=JC0Y0QPLd4dv2Chd2uSnFM6k2pNn9+xYOM4MwLSX+Ps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I/UTwr1vfNZNZnCFBRSRBXlvnAUX8TmcEYTPukCr3taqO0HbZw3QiQvE9wMHzM8Hl
         ZocWgSgRefUzp0BFBoK0erbD4GsDGbwPOa/v52ZcsgYczL4Oe+Lru0OfZO52ZlhyUK
         hyB6RpHjkN7URlIecD5IjgQLA3cjRVoiw8C8IRtE=
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
Subject: [PATCH AUTOSEL 4.19 50/56] ipvs: Fix uninit-value in do_ip_vs_set_ctl()
Date:   Sun, 18 Oct 2020 15:24:11 -0400
Message-Id: <20201018192417.4055228-50-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192417.4055228-1-sashal@kernel.org>
References: <20201018192417.4055228-1-sashal@kernel.org>
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
index c339b5e386b78..3ad1de081e3c7 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -2393,6 +2393,10 @@ do_ip_vs_set_ctl(struct sock *sk, int cmd, void __user *user, unsigned int len)
 		/* Set timeout values for (tcp tcpfin udp) */
 		ret = ip_vs_set_timeout(ipvs, (struct ip_vs_timeout_user *)arg);
 		goto out_unlock;
+	} else if (!len) {
+		/* No more commands with len == 0 below */
+		ret = -EINVAL;
+		goto out_unlock;
 	}
 
 	usvc_compat = (struct ip_vs_service_user *)arg;
@@ -2469,9 +2473,6 @@ do_ip_vs_set_ctl(struct sock *sk, int cmd, void __user *user, unsigned int len)
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

