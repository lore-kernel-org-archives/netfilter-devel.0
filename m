Return-Path: <SRS0=44Uw=53=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10F6AC2BBC7
	for <netfilter-devel@archiver.kernel.org>; Sat, 11 Apr 2020 23:33:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D54B8206E9
	for <netfilter-devel@archiver.kernel.org>; Sat, 11 Apr 2020 23:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586648006;
	bh=UTiDhzPsf8KLmmjPeQWdvM8WmsScjdB7eAFqqnC3l7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=qIV7bcdx2deLGSVyWJNzAqySwTgSQDjJzmvjcS7bx37lFIhA+SSu9ONEoQoiDOXQO
	 +tRjH6m4ntLKV7MP2H6TM68pxwAeb6+nNXbK6e63h6VD+s7HrHlhzdrxYj2ScsMmW4
	 +ZK0vZS0H+/M0kkmFEt0sSFtweiOzo2HxPhqxC1o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729276AbgDKXJr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 11 Apr 2020 19:09:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:47622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728432AbgDKXJq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 11 Apr 2020 19:09:46 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECCB720787;
        Sat, 11 Apr 2020 23:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646586;
        bh=UTiDhzPsf8KLmmjPeQWdvM8WmsScjdB7eAFqqnC3l7g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=smAsQrMNso0cC7Zv6uB78KdrS7j6NO9RDt52mkGGQpLk40UBhwK/Q4VqXm3vb252F
         WyQWGjlPWX/nt2l9uf8pBWhZao00zIb3GOGWqLtFcopWt+wqZAD3JoLJEm+VQEYDHn
         XQjLhDR7fHLORwMN2un8U9RwkhiE1thW5e3pdMNo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Romain Bellan <romain.bellan@wifirst.fr>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 002/108] netfilter: ctnetlink: be more strict when NF_CONNTRACK_MARK is not set
Date:   Sat, 11 Apr 2020 19:07:57 -0400
Message-Id: <20200411230943.24951-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230943.24951-1-sashal@kernel.org>
References: <20200411230943.24951-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Romain Bellan <romain.bellan@wifirst.fr>

[ Upstream commit 7c6b4121627aeaa79536fbb900feafec740410d3 ]

When CONFIG_NF_CONNTRACK_MARK is not set, any CTA_MARK or CTA_MARK_MASK
in netlink message are not supported. We should return an error when one
of them is set, not both

Fixes: 9306425b70bf ("netfilter: ctnetlink: must check mark attributes vs NULL")
Signed-off-by: Romain Bellan <romain.bellan@wifirst.fr>
Signed-off-by: Florent Fourcot <florent.fourcot@wifirst.fr>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index aa8adf930b3ce..bb9c7569b9729 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -838,7 +838,7 @@ ctnetlink_alloc_filter(const struct nlattr * const cda[], u8 family)
 	struct ctnetlink_filter *filter;
 
 #ifndef CONFIG_NF_CONNTRACK_MARK
-	if (cda[CTA_MARK] && cda[CTA_MARK_MASK])
+	if (cda[CTA_MARK] || cda[CTA_MARK_MASK])
 		return ERR_PTR(-EOPNOTSUPP);
 #endif
 
-- 
2.20.1

