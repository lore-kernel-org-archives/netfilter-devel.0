Return-Path: <SRS0=76Lg=ZW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C1ABC432C0
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Nov 2019 17:58:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D3C52075C
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Nov 2019 17:58:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="JKT97m7M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727201AbfK3R6t (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 30 Nov 2019 12:58:49 -0500
Received: from kadath.azazel.net ([81.187.231.250]:54252 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727101AbfK3R6s (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 Nov 2019 12:58:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=EfsxDPU1ZjmVmoJmG3gpJVLLX8CmNaimpeodxYRAe68=; b=JKT97m7Ml4BsFX03r4JR9lT9Jd
        xSNzKMD1GBavUQiq4TJEz5HhNDc+dcFRgUtCeLtEAg2jhK8kzQa+9UTrIPcUiSAE38M2TPalrgpmH
        sX+BeYW86tRqM7rzkW/AHf+9bUKQFVqp+m12+m6SLTUeEcox5ah5KqWu2f8V5k8O7VQnGBvsNLvpG
        o/uhPwyPmclrpgDN1yO874qh58O7CGWbOcnxPZnnD8GH5+2l5iXCYIJTDzVU0yR1GiWArBQdP0enr
        BlX7TmAUvf5z/M0DTPNBlYv/5XTp6513c/luhEpxKtC/WwWX7L/dJD3S+DpBI8HFXCMX1fqaK+97W
        meTe9yhw==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1ib714-0002eP-01; Sat, 30 Nov 2019 17:58:46 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        "Thomas B . Clark" <kernel@clark.bz>
Subject: [PATCH xtables-addons v2 0/3] xt_geoip: ipv6 fixes
Date:   Sat, 30 Nov 2019 17:58:42 +0000
Message-Id: <20191130175845.369240-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <3971b408-51e6-d90e-f291-7a43e46e84c1@ferree-clark.org>
References: <3971b408-51e6-d90e-f291-7a43e46e84c1@ferree-clark.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Thomas Clark reported that geoip matching didn't work for ipv6.  This
series fixes that and a couple of other minor issues.

Since v1:

  * fixed the commit-message in patch 03.

Jeremy Sowden (3):
  configure: update max. supported kernel version.
  xt_geoip: white-space fixes.
  xt_geoip: fix in6_addr little-endian byte-swapping.

 configure.ac             |  2 +-
 extensions/libxt_geoip.c | 28 ++++++++--------------------
 extensions/xt_geoip.c    |  6 +++---
 3 files changed, 12 insertions(+), 24 deletions(-)

-- 
2.24.0

