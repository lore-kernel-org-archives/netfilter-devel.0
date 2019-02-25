Return-Path: <SRS0=WVDP=RA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 881A5C43381
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Feb 2019 13:27:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C6E220663
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Feb 2019 13:27:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727330AbfBYN1C (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 Feb 2019 08:27:02 -0500
Received: from mail.us.es ([193.147.175.20]:40490 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727296AbfBYN1C (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Feb 2019 08:27:02 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 046DBE2D87
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Feb 2019 14:27:00 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E53E7DA84E
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Feb 2019 14:26:59 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E3EC0DA86A; Mon, 25 Feb 2019 14:26:59 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1C7FBDA84E
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Feb 2019 14:26:57 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 25 Feb 2019 14:26:57 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id EDF4C4265A4C
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Feb 2019 14:26:56 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next] netfilter: ctnetlink: do not bail out with EBUSY on unchangeable bits
Date:   Mon, 25 Feb 2019 14:26:54 +0100
Message-Id: <20190225132654.8710-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Since a963d710f367 ("netfilter: ctnetlink: Fix regression in CTA_STATUS
processing"), the IPS_UNCHANGEABLE_MASK definition specifies what status
bits are unchangeable: this includes the NAT, dying, expected and
confirmed status bits.

Such commit also relaxed the check to ignore userspace updates that do
not make sense from the nfqueue path, ie. expected, confirmed and dying
bits.

This patch just ignores any attempt to disable the unchangeable bits
from nfqueue and usual ctnetlink path, instead of hitting EBUSY.

For seen reply and assured bits, it's safe to disable them since the
kernel does not crash, and state synchronization scenario may need to
update an existing stale conntrack entry that is out-of-sync, rather
than forcing userspace to tear it down and create a clean session.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_netlink.c | 23 -----------------------
 1 file changed, 23 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 349b42a65c8a..3fe7074e25e2 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1563,21 +1563,7 @@ __ctnetlink_change_status(struct nf_conn *ct, unsigned long on,
 static int
 ctnetlink_change_status(struct nf_conn *ct, const struct nlattr * const cda[])
 {
-	unsigned long d;
 	unsigned int status = ntohl(nla_get_be32(cda[CTA_STATUS]));
-	d = ct->status ^ status;
-
-	if (d & (IPS_EXPECTED|IPS_CONFIRMED|IPS_DYING))
-		/* unchangeable */
-		return -EBUSY;
-
-	if (d & IPS_SEEN_REPLY && !(status & IPS_SEEN_REPLY))
-		/* SEEN_REPLY bit can only be set */
-		return -EBUSY;
-
-	if (d & IPS_ASSURED && !(status & IPS_ASSURED))
-		/* ASSURED bit can only be set */
-		return -EBUSY;
 
 	__ctnetlink_change_status(ct, status, 0);
 	return 0;
@@ -2490,15 +2476,6 @@ static int
 ctnetlink_update_status(struct nf_conn *ct, const struct nlattr * const cda[])
 {
 	unsigned int status = ntohl(nla_get_be32(cda[CTA_STATUS]));
-	unsigned long d = ct->status ^ status;
-
-	if (d & IPS_SEEN_REPLY && !(status & IPS_SEEN_REPLY))
-		/* SEEN_REPLY bit can only be set */
-		return -EBUSY;
-
-	if (d & IPS_ASSURED && !(status & IPS_ASSURED))
-		/* ASSURED bit can only be set */
-		return -EBUSY;
 
 	/* This check is less strict than ctnetlink_change_status()
 	 * because callers often flip IPS_EXPECTED bits when sending
-- 
2.11.0

