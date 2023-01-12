Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF41EC677F1
	for <netfilter-devel@archiver.kernel.org>; Thu, 12 Jan 2023 18:05:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240346AbjALSFK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 12 Jan 2023 13:05:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240285AbjALSDo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 12 Jan 2023 13:03:44 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 604185D886
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Jan 2023 09:28:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=8TRXkSY1yHK1O/FwzrKH+Znhcgy1W8KeHT/YAVDYDFg=; b=GAhLq760OQN0TWhSxBw+l+4wQt
        YJf47XjJJUNQ6nq2S/zrchxHhmT0HPgKqKsI+edj9tuT/EN++ia7wTzbQNZgarsLiDmaZR2AYC2eK
        yYR7r5cHX2GwZ8aGXaAnOya8r8brRGDzu7Zoxo2u05SF5zLwQKkz+otUdgix5/6UCWZRbsculvqbg
        yLJE3brhGlUSx55UulBKHpQ7FfPYwuyzSQpUgWMYLv9397ZEzBkRz3BB/pdle9zTBQABcRnrLqJgr
        XsvUkIFTfItOEVZzbfHCHIfHqt7jzQ2+L1Nyc09zFqSwXuluDXw6FtaB2lfa6N3b2Vs1Aa1kWSpn6
        6h8T9jmA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1pG1NV-0000DB-HB; Thu, 12 Jan 2023 18:28:37 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 4/5] meta: parse_iso_date() returns boolean
Date:   Thu, 12 Jan 2023 18:28:22 +0100
Message-Id: <20230112172823.7298-5-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230112172823.7298-1-phil@nwl.cc>
References: <20230112172823.7298-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Returning ts if 'ts == (time_t) -1' signals success to caller despite
failure.

Fixes: 4460b839b945a ("meta: fix compiler warning in date_type_parse()")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/meta.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/meta.c b/src/meta.c
index bd8a41ba3a032..013e8cbaf38a5 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -433,7 +433,7 @@ static bool parse_iso_date(uint64_t *tstamp, const char *sym)
 	cur_tm = localtime(&ts);
 
 	if (ts == (time_t) -1 || cur_tm == NULL)
-		return ts;
+		return false;
 
 	/* Substract tm_gmtoff to get the current time */
 	*tstamp = ts - cur_tm->tm_gmtoff;
-- 
2.38.0

