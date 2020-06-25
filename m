Return-Path: <SRS0=ETlx=AG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EC8CC433DF
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jun 2020 18:27:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4487820781
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jun 2020 18:27:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406175AbgFYS0q (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Jun 2020 14:26:46 -0400
Received: from correo.us.es ([193.147.175.20]:33474 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404595AbgFYS0q (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Jun 2020 14:26:46 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7A63AFC5E5
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Jun 2020 20:26:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6B2E2DA78C
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Jun 2020 20:26:44 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5EC01DA789; Thu, 25 Jun 2020 20:26:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 29202DA722;
        Thu, 25 Jun 2020 20:26:42 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 25 Jun 2020 20:26:42 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id F358B42EE393;
        Thu, 25 Jun 2020 20:26:41 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 1/7] netfilter: ipset: fix unaligned atomic access
Date:   Thu, 25 Jun 2020 20:26:29 +0200
Message-Id: <20200625182635.1958-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200625182635.1958-1-pablo@netfilter.org>
References: <20200625182635.1958-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>

When using ip_set with counters and comment, traffic causes the kernel
to panic on 32-bit ARM:

Alignment trap: not handling instruction e1b82f9f at [<bf01b0dc>]
Unhandled fault: alignment exception (0x221) at 0xea08133c
PC is at ip_set_match_extensions+0xe0/0x224 [ip_set]

The problem occurs when we try to update the 64-bit counters - the
faulting address above is not 64-bit aligned.  The problem occurs
due to the way elements are allocated, for example:

	set->dsize = ip_set_elem_len(set, tb, 0, 0);
	map = ip_set_alloc(sizeof(*map) + elements * set->dsize);

If the element has a requirement for a member to be 64-bit aligned,
and set->dsize is not a multiple of 8, but is a multiple of four,
then every odd numbered elements will be misaligned - and hitting
an atomic64_add() on that element will cause the kernel to panic.

ip_set_elem_len() must return a size that is rounded to the maximum
alignment of any extension field stored in the element.  This change
ensures that is the case.

Fixes: 95ad1f4a9358 ("netfilter: ipset: Fix extension alignment")
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipset/ip_set_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 340cb955af25..56621d6bfd29 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -460,6 +460,8 @@ ip_set_elem_len(struct ip_set *set, struct nlattr *tb[], size_t len,
 	for (id = 0; id < IPSET_EXT_ID_MAX; id++) {
 		if (!add_extension(id, cadt_flags, tb))
 			continue;
+		if (align < ip_set_extensions[id].align)
+			align = ip_set_extensions[id].align;
 		len = ALIGN(len, ip_set_extensions[id].align);
 		set->offset[id] = len;
 		set->extensions |= ip_set_extensions[id].type;
-- 
2.20.1

