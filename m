Return-Path: <SRS0=UAOK=W4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 264A4C3A5AB
	for <netfilter-devel@archiver.kernel.org>; Sun,  1 Sep 2019 20:51:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9E0E22CF7
	for <netfilter-devel@archiver.kernel.org>; Sun,  1 Sep 2019 20:51:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="aV1UEERU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729123AbfIAUvd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 1 Sep 2019 16:51:33 -0400
Received: from kadath.azazel.net ([81.187.231.250]:53352 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729013AbfIAUva (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 1 Sep 2019 16:51:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=0XvlM9zt1+jvZJPdOPEDpA6KU3hF66W/o5HOzzvKZ7A=; b=aV1UEERU+v0UIhNUJejV+w81gK
        0pVMqzj2CIgw2uErh5FKr9ry8zloDoepeucuUBpLNJKE/kjKev3DdhY+Ocm30Kla1vsPbtD804QnT
        C2JQNY3VHqxs3VkhKLlj81QDKT1Br5XUMBd1qVyua0QonACZ9+yzYJQAa1H6tLD3h27jDBM7VEpRN
        IQQk36klVPb5R+2XyOnDtfCdjDnIJtplESIDkRH3wrUYa5Cv9V9xW1gNBAIgIyiM4ZzNndPjo4vXC
        +nB2obZPtiL6RxOUNWDB6xNuLZdy9gNzEqNAqY5+/cgEq4D2lFtCBA7ljSiR3aouZbsw79n8qRr1a
        EOrZcEsg==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1i4Woo-0002Uf-OM; Sun, 01 Sep 2019 21:51:26 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next 04/29] netfilter: add GPL-2.0 SPDX ID's to a couple of headers.
Date:   Sun,  1 Sep 2019 21:51:00 +0100
Message-Id: <20190901205126.6935-5-jeremy@azazel.net>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20190901205126.6935-1-jeremy@azazel.net>
References: <20190901205126.6935-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Two headers are missing SPDX licence identifiers.  They contain
copyright notices indicating that the code is GPL.  Add GPL-2.0
identifiers.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/linux/netfilter_ipv4.h | 3 ++-
 include/linux/netfilter_ipv6.h | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/netfilter_ipv4.h b/include/linux/netfilter_ipv4.h
index 082e2c41b7ff..cab891485752 100644
--- a/include/linux/netfilter_ipv4.h
+++ b/include/linux/netfilter_ipv4.h
@@ -1,4 +1,5 @@
-/* IPv4-specific defines for netfilter. 
+/* SPDX-License-Identifier: GPL-2.0 */
+/* IPv4-specific defines for netfilter.
  * (C)1998 Rusty Russell -- This code is GPL.
  */
 #ifndef __LINUX_IP_NETFILTER_H
diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
index 7beb681e1ce5..c2f669581d88 100644
--- a/include/linux/netfilter_ipv6.h
+++ b/include/linux/netfilter_ipv6.h
@@ -1,4 +1,5 @@
-/* IPv6-specific defines for netfilter. 
+/* SPDX-License-Identifier: GPL-2.0 */
+/* IPv6-specific defines for netfilter.
  * (C)1998 Rusty Russell -- This code is GPL.
  * (C)1999 David Jeffery
  *   this header was blatantly ripped from netfilter_ipv4.h 
-- 
2.23.0.rc1

