Return-Path: <SRS0=2UWv=XQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0D7EC4CEC4
	for <netfilter-devel@archiver.kernel.org>; Sat, 21 Sep 2019 11:05:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C7D4921835
	for <netfilter-devel@archiver.kernel.org>; Sat, 21 Sep 2019 11:05:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="d/ArAaEI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407520AbfIULFb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 21 Sep 2019 07:05:31 -0400
Received: from kadath.azazel.net ([81.187.231.250]:59680 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407497AbfIULFa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 21 Sep 2019 07:05:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=2XCk3uvQkSBolkvcTLUwG7isIl94JNrVpriYmHDNPb8=; b=d/ArAaEIkyTP14IFxBZO9MPy53
        COxpakkj+HGSC71oxrJ6hbn0wyt4K+kQuYj2GJuXAG5+6l3I4QspN1P/O6HEGk9BcAFeFlSuaQgLY
        jqO40LEz+L5hmR5zO1al36IB5yWTGKb+D88HcW+y/EFvO8kUyrnAPhyz/cLbOQLMjEnYGiUCsEi0G
        00kVOI94Evdcxz22IMigvowk0wZhzsbBTFaBOKmFS97oI/Fp8Z8SRBrPOqf5TBjuKaVzLlkLS4KuS
        6geiKc1F5HIYn4/a8wmShyuNxvaQ8JIsTVKDBs6UxT7JslvJ4rduVmiBGYWdW8hme9+v7/IJwJTbx
        PKwLO41A==;
Received: from ulthar.dreamlands ([192.168.96.2])
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1iBdCd-0007fj-6P; Sat, 21 Sep 2019 12:05:23 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     stable@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH 0/1] netfilter: bridge: build fix for 5.3
Date:   Sat, 21 Sep 2019 12:05:22 +0100
Message-Id: <20190921110523.15085-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 192.168.96.2
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Adam Borowski reported a build-failure in 5.3 when
CONFIG_NF_CONNTRACK_BRIDGE is set but CONFIG_NF_TABLES is not.  It was
introduced into the mainline by:

  3c171f496ef5 ("netfilter: bridge: add connection tracking system")

There is also a fix in the mainline:

  47e640af2e49 ("netfilter: add missing IS_ENABLED(CONFIG_NF_TABLES) check to header-file.")

I've cherry-picked it, and added the "Fixes:", "Reported-by:", "Link:"
and "Cc:" tags.

Please consider applying it to 5-3-y.

Jeremy Sowden (1):
  netfilter: add missing IS_ENABLED(CONFIG_NF_TABLES) check to
    header-file.

 include/net/netfilter/nf_tables.h | 4 ++++
 1 file changed, 4 insertions(+)

-- 
2.23.0

