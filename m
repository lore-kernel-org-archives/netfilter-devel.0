Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19F20C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat,  7 May 2022 11:59:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446309AbiEGMD0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 7 May 2022 08:03:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356300AbiEGMD0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 7 May 2022 08:03:26 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C886C4832D
        for <netfilter-devel@vger.kernel.org>; Sat,  7 May 2022 04:59:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=wd08hI0riFBkJfeQULoDfCs4SrHjUMi8faXj3M/WjMM=; b=l/i6WI6PgenkjiGW5uwpCDKgon
        +QPSqgPQ0dz81AGuMrAW7bIFwZ77EgKl6zY24Jtw8Q9nB4/xBhwiO/H7f41HgNTklYOVq5ODosYs3
        XJ2B+YaWoisCVPPzJpLVuxocgOHMVEE4DmmzmsX8F61OPEz1jbIkaIq+BpKcrS8aiGLCull60Ur5v
        zG5X0G+mILf2crnu9Sj18zb2OJjyqhTmiAhsKIXQbLY9hkiw7RcrlYIZAvcshBHDutLJ3R1oQVBvU
        Dc1fTjb3QBDVct+epUci7ZApnQEbxNGqo03PB2QOaVGDmpUqdqqNYdZJuOrTp+r6J9jsIH27+nc2N
        bh6tVjig==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1nnJ60-0025Kn-L2; Sat, 07 May 2022 12:59:36 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH xtables-addons 1/2] doc: fix some typos in man-pages
Date:   Sat,  7 May 2022 12:59:23 +0100
Message-Id: <20220507115924.3590034-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

libxt_ACCOUNT.man:     'accouting' -> 'accounting'
libxt_DELUDE.man:      'belive' -> 'believe'
libxt_DHCPMAC.man:     'allow to' -> 'allow one to'
libxt_SYSRQ.man:       'allows to' -> 'allows one to'
libxt_ipv4options.man: 'allows to' -> 'allows one to'
libxt_psd.man:         'non-priviliged' -> 'non-privileged'

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 extensions/ACCOUNT/libxt_ACCOUNT.man |  2 +-
 extensions/libxt_DELUDE.man          |  2 +-
 extensions/libxt_DHCPMAC.man         |  2 +-
 extensions/libxt_SYSRQ.man           | 12 ++++++------
 extensions/libxt_ipv4options.man     |  2 +-
 extensions/libxt_psd.man             |  2 +-
 6 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/extensions/ACCOUNT/libxt_ACCOUNT.man b/extensions/ACCOUNT/libxt_ACCOUNT.man
index 1772c3084d59..33c1b74aa56c 100644
--- a/extensions/ACCOUNT/libxt_ACCOUNT.man
+++ b/extensions/ACCOUNT/libxt_ACCOUNT.man
@@ -1,7 +1,7 @@
 The ACCOUNT target is a high performance accounting system for large
 local networks. It allows per-IP accounting in whole prefixes of IPv4
 addresses with size of up to /8 without the need to add individual
-accouting rule for each IP address.
+accounting rule for each IP address.
 .PP
 The ACCOUNT is designed to be queried for data every second or at
 least every ten seconds. It is written as kernel module to handle high
diff --git a/extensions/libxt_DELUDE.man b/extensions/libxt_DELUDE.man
index 6b90e0831ccf..a15be9011c4c 100644
--- a/extensions/libxt_DELUDE.man
+++ b/extensions/libxt_DELUDE.man
@@ -2,4 +2,4 @@
 The DELUDE target will reply to a SYN packet with SYN-ACK, and to all other
 packets with an RST. This will terminate the connection much like REJECT, but
 network scanners doing TCP half-open discovery can be spoofed to make them
-belive the port is open rather than closed/filtered.
+believe the port is open rather than closed/filtered.
diff --git a/extensions/libxt_DHCPMAC.man b/extensions/libxt_DHCPMAC.man
index c5677824427e..8a20f05b6b93 100644
--- a/extensions/libxt_DHCPMAC.man
+++ b/extensions/libxt_DHCPMAC.man
@@ -1,7 +1,7 @@
 .PP
 In conjunction with ebtables, DHCPMAC can be used to completely change all MAC
 addresses from and to a VMware-based virtual machine. This is needed because
-VMware does not allow to set a non-VMware MAC address before an operating
+VMware does not allow one to set a non-VMware MAC address before an operating
 system is booted (and the MAC be changed with `ip link set eth0 address
 aa:bb..`).
 .TP
diff --git a/extensions/libxt_SYSRQ.man b/extensions/libxt_SYSRQ.man
index 29944b917e2f..d7b3da0684df 100644
--- a/extensions/libxt_SYSRQ.man
+++ b/extensions/libxt_SYSRQ.man
@@ -1,10 +1,10 @@
 .PP
-The SYSRQ target allows to remotely trigger sysrq on the local machine over the
-network. This can be useful when vital parts of the machine hang, for example
-an oops in a filesystem causing locks to be not released and processes to get
-stuck as a result \(em if still possible, use /proc/sysrq-trigger. Even when
-processes are stuck, interrupts are likely to be still processed, and as such,
-sysrq can be triggered through incoming network packets.
+The SYSRQ target allows one to remotely trigger sysrq on the local machine over
+the network. This can be useful when vital parts of the machine hang, for
+example an oops in a filesystem causing locks to be not released and processes
+to get stuck as a result \(em if still possible, use /proc/sysrq-trigger. Even
+when processes are stuck, interrupts are likely to be still processed, and as
+such, sysrq can be triggered through incoming network packets.
 .PP
 The xt_SYSRQ implementation uses a salted hash and a sequence number to prevent
 network sniffers from either guessing the password or replaying earlier
diff --git a/extensions/libxt_ipv4options.man b/extensions/libxt_ipv4options.man
index 8c16e71d8cb7..9c93eeb2b248 100644
--- a/extensions/libxt_ipv4options.man
+++ b/extensions/libxt_ipv4options.man
@@ -1,5 +1,5 @@
 .PP
-The "ipv4options" module allows to match against a set of IPv4 header options.
+The "ipv4options" module allows one to match against a set of IPv4 header options.
 .TP
 \fB\-\-flags\fP [\fB!\fP]\fIsymbol\fP[\fB,\fP[\fB!\fP]\fIsymbol...\fP]
 Specify the options that shall appear or not appear in the header. Each
diff --git a/extensions/libxt_psd.man b/extensions/libxt_psd.man
index 5777dbf804dc..91e33887a464 100644
--- a/extensions/libxt_psd.man
+++ b/extensions/libxt_psd.man
@@ -16,4 +16,4 @@ possible port scan subsequence.
 Weight of the packet with privileged (<=1024) destination port.
 .TP
 \fB\-\-psd\-hi\-ports\-weight\fP \fIweight\fP
-Weight of the packet with non-priviliged destination port.
+Weight of the packet with non-privileged destination port.
-- 
2.35.1

