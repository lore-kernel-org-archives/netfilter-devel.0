Return-Path: <SRS0=yud9=WI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D82D3C31E40
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Aug 2019 11:57:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0EDA214C6
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Aug 2019 11:57:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="NgnMNwbP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728340AbfHLL5n (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 12 Aug 2019 07:57:43 -0400
Received: from kadath.azazel.net ([81.187.231.250]:42450 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728063AbfHLL5n (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Aug 2019 07:57:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=TQFjTz20dx1DbeMR6z01p+b3WJWX5Zemup/lPRE/znM=; b=NgnMNwbPRWGn/eqXlXecKMR/BG
        j/deMC92xBN41/y1HYMYG15zhsYfuTznqV3YsZpEL3wnAQFT0zxXjjNqZt+LvBVX6jBTJK0lHgZma
        xDIMPi/Qm7ru76O/gbC5m5n+wZTpZZHkX+wjYgzj3vKaeg6eFcWwJGJl4NswoVO6cnHHolourQFXz
        /oBtR4/G21QD2XN8Z6q0tVn9xCqpnH7oS4c35Xz1xGNr5Tbo6kbbiQbS72TlwuCvcka3m0F748AXw
        GjlLtzWqJrv1kP4yOki4c6MkM4IXhUJ898v7OlrFQ1pddcjTp47El9mMXC1ltm1/CQu7+W8qv8pCP
        w1vsFDXQ==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1hx8xK-0002sN-83; Mon, 12 Aug 2019 12:57:42 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     =?UTF-8?q?Franta=20Hanzl=C3=ADk?= <franta@hanzlici.cz>
Subject: [PATCH xtables-addons v2 0/2] Kernel API updates
Date:   Mon, 12 Aug 2019 12:57:40 +0100
Message-Id: <20190812115742.21770-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190811113826.5e594d8f@franta.hanzlici.cz>
References: <20190811113826.5e594d8f@franta.hanzlici.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

v3.3 of xtables-addons does not compile against v5.2 of the kernel owing
to a couple of kernel API changes.  These two patches update the broken
extensions to work with the new API's.

Jeremy Sowden (2):
  xt_pknock, xt_SYSRQ: don't set shash_desc::flags.
  xt_DHCPMAC: replaced skb_make_writable with skb_ensure_writable.

 extensions/pknock/xt_pknock.c | 1 -
 extensions/xt_DHCPMAC.c       | 3 ++-
 extensions/xt_SYSRQ.c         | 1 -
 3 files changed, 2 insertions(+), 3 deletions(-)

Since v1:

 * added this cover-letter;
 * fixed the skb_ensure_writable call in line with Florian Westphal's
   feedback.

-- 
2.20.1

