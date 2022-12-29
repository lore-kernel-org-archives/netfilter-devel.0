Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97AD8C4332F
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Dec 2022 16:35:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233568AbiL2QfV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 29 Dec 2022 11:35:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233258AbiL2QfT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 29 Dec 2022 11:35:19 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F32011A2B
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Dec 2022 08:35:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=DuAMOAZn1tbkWBE2q2bmL8mUdOHTK0dBwGKViPTWaoQ=; b=VTqUpP8qvTEErRr9BWCOJgbIxB
        hjUQGGD4FXsK6SIiiXF6e6prTZIa7zZ5MlPn+2UfZSJ6RQnJiEumAfmv5SBlf7uE2vg5aZ5lUillm
        lkrZd9ZnceEGq9FKN48we9PZuh1CjDFV6yaQO3W1Nend02rSgC7akSOeQopvWvhpehN5OsZJhZP70
        l2RzZDChuqttGbcXbsqxrvM+EioA7rAVELtRJvZVeYdMQfoZd4e1AzQYLcZJ/AhQW5KnFMKx985So
        oL1LgKVBcsgFxQylyYIOYIxDbp9ixVz8V/roMNmJ6TPfd/LRuB4fhm7ozfC+ejSoMjQFmVV7jIqHM
        am9peMvA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1pAvsA-00D08G-3x
        for netfilter-devel@vger.kernel.org; Thu, 29 Dec 2022 16:35:14 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH xtables-addons 0/3] Add Linux 6.2 Support
Date:   Thu, 29 Dec 2022 16:35:04 +0000
Message-Id: <20221229163507.352888-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The main purpose of the patch-set is to add support for 6.2, which
removes `prandom_u32_max`, by replacing it with the function that
supersedes it.  We also introduce the `LT_INIT` into configure.ac.

Jeremy Sowden (3):
  build: replace obsolete `AC_PROG_LIBTOOL` macro with `LT_INIT`
  build: replace `AC_DISABLE_STATIC` macro with an argument to `LT_INIT`
  build: support for Linux 6.2

 configure.ac                | 5 ++---
 extensions/compat_xtables.h | 4 ++++
 extensions/xt_TARPIT.c      | 6 +++---
 3 files changed, 9 insertions(+), 6 deletions(-)

-- 
2.39.0

