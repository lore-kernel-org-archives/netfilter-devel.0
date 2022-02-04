Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10885C433F5
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Feb 2022 13:27:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346215AbiBDN1J (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 4 Feb 2022 08:27:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235551AbiBDN1I (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 4 Feb 2022 08:27:08 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8496BC061714
        for <netfilter-devel@vger.kernel.org>; Fri,  4 Feb 2022 05:27:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=YCEbI8DmzROoIKaPJi4XusGOJo8rKznewTdsD60L5pc=; b=txTCkn/pzBBaWJ1T9x1o4awbEa
        MicCFmobGraf8nrrsY/WfN2itY6EkKYfCCKJbu+ce4IQ4N1RNqGQqbySfVIhAa0F/jK+HX3h5Couv
        0qgL2CpX6b9lCBNwFHxbsA2kdbXLeUPPIIYo67itAmYyfqIS2zuFE52fH7ZTvCSJbIJ1vcy3QUQrC
        5ZU6pG3lDC4/8z66sjnsruzsTLXh2AREw+YsmdtZjaCNq/Ot/FQWj3MGs1ZNJ8Cyj41WZHZTAS7YN
        oIpP7Q31nHQlA0KpAgjCh6UErU6/KbeMcToyAH+tWH76OOOIM3m56VXXzX5cY8vnMjTwZZAiaJhta
        lxiXwjZQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1nFycC-00BLdH-CC; Fri, 04 Feb 2022 13:27:04 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [xtables-addons PATCH 0/2] 5.17 Kernel Support
Date:   Fri,  4 Feb 2022 13:26:41 +0000
Message-Id: <20220204132643.1212741-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The `PDE_DATA` procfs function has been replaced by another function,
`pde_data`, in 5.17.  The first patch adds support for this.  The second
bumps the maximum supported kernel version to 5.17.

Jeremy Sowden (2):
  extensions: replace `PDE_DATA`
  build: bump supported kernel version to 5.17

 configure.ac                  | 2 +-
 extensions/compat_xtables.h   | 4 ++++
 extensions/pknock/xt_pknock.c | 2 +-
 extensions/xt_DNETMAP.c       | 6 +++---
 extensions/xt_condition.c     | 4 ++--
 extensions/xt_quota2.c        | 4 ++--
 6 files changed, 13 insertions(+), 9 deletions(-)

-- 
2.34.1

