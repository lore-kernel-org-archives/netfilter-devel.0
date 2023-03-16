Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FA70C6FD1F
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Mar 2023 11:08:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbjCPLIL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Mar 2023 07:08:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbjCPLIJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Mar 2023 07:08:09 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF0E25C138
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Mar 2023 04:08:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=AXgtNZlOca9B/9BiI0B4S1EsfJeiPqAoI2UmQO2h50w=; b=lcwmjKMMGLBteo1e9sOb72yRA3
        3i5xFHFppaGSAoDiXUoP1nC0lsMN3ZQGeZGo7Ce1wYHIgofWUFSWxweXCzChGMyYgI6XxBoLUbi9A
        isrtZeteoz8pRYqv9R6ELqK26C6CtcnzuKVsmtSTw972cl3MRr5BPlSKORvl7FS15GaZ97DvtgTSl
        ydv+dpHRTMXtCDRa7dG6RQllLmePajx/wH0gAohr1h8ZxODdJIiMAUYJVYyrw2UO1PoqKFCorIAKw
        saBLt6LStPVD00B00Nm5xkLa+zsEJlThl1hRt6i7cpCVpkDRm1gqj+oJTZo/9Ib8xkDEynEveAViX
        4BN8CF3w==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1pclSl-00AuPp-Pf
        for netfilter-devel@vger.kernel.org; Thu, 16 Mar 2023 11:08:03 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH ulogd2 v3 0/2] pcap: prevent crashes when output `FILE *` is null
Date:   Thu, 16 Mar 2023 11:07:52 +0000
Message-Id: <20230316110754.260967-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If ulogd2 receives a signal it will attempt to re-open the pcap output
file.  If this fails (because the permissions or ownership have changed
for example), the FILE pointer will be null and when the next packet
comes in, the null pointer will be passed to fwrite and ulogd will
crash.

The first patch simplifies the logic of the code that opens the output
file, and the second avoids closing the existing stream if `fopen`
fails.

Link: https://bugs.launchpad.net/ubuntu/+source/ulogd2/+bug/1429778

Change since v2

 * The first patch is new.
 * In the second patch, just keep the old stream open, rather than
   disabling output and trying to reopen at intervals.

Change since v1

 * Correct subject-prefix.

Jeremy Sowden (2):
  pcap: simplify opening of output file
  pcap: prevent crashes when output `FILE *` is null

 output/pcap/ulogd_output_PCAP.c | 50 +++++++++++++--------------------
 1 file changed, 19 insertions(+), 31 deletions(-)

-- 
2.39.2

