Return-Path: <SRS0=HFPz=AM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5FB5C433E0
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Jul 2020 12:34:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86C34206CB
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Jul 2020 12:34:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730393AbgGAMen (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 1 Jul 2020 08:34:43 -0400
Received: from correo.us.es ([193.147.175.20]:57728 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730199AbgGAMen (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Jul 2020 08:34:43 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1C2D09ED52
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Jul 2020 14:34:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0CF7DDA791
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Jul 2020 14:34:41 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 02A21DA73D; Wed,  1 Jul 2020 14:34:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 99463DA73D
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Jul 2020 14:34:38 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 01 Jul 2020 14:34:38 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 81FB14265A32
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Jul 2020 14:34:38 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: nf_conntrack: refetch conntrack after nf_conntrack_update()
Date:   Wed,  1 Jul 2020 14:34:35 +0200
Message-Id: <20200701123435.1806-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

__nf_conntrack_update() might refresh the conntrack object that is
attached to the skbuff. Otherwise, this triggers UAF.

[  633.200434] ==================================================================
[  633.200472] BUG: KASAN: use-after-free in nf_conntrack_update+0x34e/0x770 [nf_conntrack]
[  633.200478] Read of size 1 at addr ffff888370804c00 by task nfqnl_test/6769

[  633.200487] CPU: 1 PID: 6769 Comm: nfqnl_test Not tainted 5.8.0-rc2+ #388
[  633.200490] Hardware name: LENOVO 23259H1/23259H1, BIOS G2ET32WW (1.12 ) 05/30/2012
[  633.200491] Call Trace:
[  633.200499]  dump_stack+0x7c/0xb0
[  633.200526]  ? nf_conntrack_update+0x34e/0x770 [nf_conntrack]
[  633.200532]  print_address_description.constprop.6+0x1a/0x200
[  633.200539]  ? _raw_write_lock_irqsave+0xc0/0xc0
[  633.200568]  ? nf_conntrack_update+0x34e/0x770 [nf_conntrack]
[  633.200594]  ? nf_conntrack_update+0x34e/0x770 [nf_conntrack]
[  633.200598]  kasan_report.cold.9+0x1f/0x42
[  633.200604]  ? call_rcu+0x2c0/0x390
[  633.200633]  ? nf_conntrack_update+0x34e/0x770 [nf_conntrack]
[  633.200659]  nf_conntrack_update+0x34e/0x770 [nf_conntrack]
[  633.200687]  ? nf_conntrack_find_get+0x30/0x30 [nf_conntrack]

Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1436
Fixes: ee04805ff54a ("netfilter: conntrack: make conntrack userspace helpers work again")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 79cd9dde457b..f33d72c5b06e 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2158,6 +2158,8 @@ static int nf_conntrack_update(struct net *net, struct sk_buff *skb)
 		err = __nf_conntrack_update(net, skb, ct, ctinfo);
 		if (err < 0)
 			return err;
+
+		ct = nf_ct_get(skb, &ctinfo);
 	}
 
 	return nf_confirm_cthelper(skb, ct, ctinfo);
-- 
2.20.1

