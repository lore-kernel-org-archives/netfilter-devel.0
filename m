Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C551ECAAA1
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Aug 2022 13:07:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbiH3NHQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Aug 2022 09:07:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbiH3NHO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Aug 2022 09:07:14 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52613AF4A3
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Aug 2022 06:07:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=rQnl5LpWdBTP8IHCdy0wYXGl2o1U058n1HUUINmGwls=; b=TY2dF3jws2k/w2XV4V862dh0UG
        d4il5A0EkB8GeyaQW+v5gjZ7o8UpSjxxr0TYGYykjGIqfTaeYLRMOpdswqEVushzlj6LpJoDEsgJZ
        iLSNGUGpgVDM8jzpocoVwzh4/nHL/iIzn6YquPt6t/7saYLINps2yzSrHq+6fWxjMV41fq2ZH48PC
        2h/UbfPxY1kuoPIVzrg+zGGJgMatsyZ9FyTdPjSzbj9vxRsvj0/2eoNoVT/0WAqNdeAro1vX6mbNm
        +yzjrzua7Rn3chlJGV+oKpC/Qklm4f5BECc5cQSnOco0Rgr8j0dmaqL1Me2c+2EApZP/EhxtsnUw6
        u0TVa7qA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1oT0xN-0004S1-2k; Tue, 30 Aug 2022 15:07:05 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org,
        =?UTF-8?q?Fran=C3=A7ois=20Rigault?= <frigo@amadeus.com>
Subject: [nft PATCH] erec: Dump locations' expressions only if set
Date:   Tue, 30 Aug 2022 15:06:59 +0200
Message-Id: <20220830130659.32084-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Calling netlink_dump_expr() with a NULL pointer leads to segfault within
libnftnl. Internal ("fake") locations such as 'netlink_location' don't
have an expression assigned so expect this and skip the call. Simple
reproducer (list ruleset with netlink debugging as non-root):

| $ nft -d netlink list ruleset

Reported-by: François Rigault <frigo@amadeus.com>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/erec.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/erec.c b/src/erec.c
index a4b93fb0d0d61..aebb8632583a1 100644
--- a/src/erec.c
+++ b/src/erec.c
@@ -170,6 +170,8 @@ void erec_print(struct output_ctx *octx, const struct error_record *erec,
 		fprintf(f, "%s\n", erec->msg);
 		for (l = 0; l < (int)erec->num_locations; l++) {
 			loc = &erec->locations[l];
+			if (!loc->nle)
+				continue;
 			netlink_dump_expr(loc->nle, f, debug_mask);
 		}
 		return;
-- 
2.34.1

