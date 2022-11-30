Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65660C4321E
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Nov 2022 19:14:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbiK3TOG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Nov 2022 14:14:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiK3TOF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Nov 2022 14:14:05 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A5CE5E3E5
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Nov 2022 11:14:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=bSExz4b7AR8//FttX5rRnDNgGAOn29sKnoYZSvwidwY=; b=I0bwTfnAS7tK0e0ekgW/DtYCpN
        CgQd1UJxYSqtQp5vLiS85GB0srbCXAj3OXGlaLixYY1SlNAFk0I9pq1Ef+BP3AYckUAKiezJ3HSFb
        RFwviexkpMFJzkgapbnUoi1BId7z0whejlNLJXN+XmTyR4cLuc02dkh+6LWeqhH5aVl6javjnL9wp
        DpWlV/LZW8UFHOd+V4d7S+a+XeKYm8XWbF7qaAy2a8fDUuLqOWcApcZuPZ73EDvhcor0hSDCKCLEE
        dhIra1gtRG6N/kmy73XbaxFnP8FTIYgIwZw9ec5Q2Sf5SfcOYkCjSj2wJFXLHa1TYSSQZfaO/b6kP
        XEZ/h1KA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1p0SWx-00019z-Ko
        for netfilter-devel@vger.kernel.org; Wed, 30 Nov 2022 20:14:03 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 8/9] xshared: Free data after printing help
Date:   Wed, 30 Nov 2022 20:13:44 +0100
Message-Id: <20221130191345.14543-9-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221130191345.14543-1-phil@nwl.cc>
References: <20221130191345.14543-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is merely to make valgrind happy, but less noise means less real
issues missed.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xshared.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/iptables/xshared.c b/iptables/xshared.c
index 2a894c19a011d..f93529b11a319 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -1543,6 +1543,9 @@ void do_parse(int argc, char *argv[],
 					XTF_TRY_LOAD, &cs->matches);
 
 			xtables_printhelp(cs->matches);
+			xtables_clear_iptables_command_state(cs);
+			xtables_free_opts(1);
+			xtables_fini();
 			exit(0);
 
 			/*
-- 
2.38.0

