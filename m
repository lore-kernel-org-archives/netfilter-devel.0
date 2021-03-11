Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDD6CC4361A
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Mar 2021 00:37:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A559964FC6
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Mar 2021 00:37:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230445AbhCKAgr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 10 Mar 2021 19:36:47 -0500
Received: from correo.us.es ([193.147.175.20]:50122 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229938AbhCKAgY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 10 Mar 2021 19:36:24 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8C1C512E832
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Mar 2021 01:36:23 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7F206DA78C
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Mar 2021 01:36:23 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 74317DA72F; Thu, 11 Mar 2021 01:36:23 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 36CDBDA73D;
        Thu, 11 Mar 2021 01:36:21 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 11 Mar 2021 01:36:21 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 02BEE42DC6E2;
        Thu, 11 Mar 2021 01:36:20 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        Felix Fietkau <nbd@nbd.name>
Subject: [PATCH net-next 13/23] netfilter: flowtable: add dsa support
Date:   Thu, 11 Mar 2021 01:35:54 +0100
Message-Id: <20210311003604.22199-14-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210311003604.22199-1-pablo@netfilter.org>
References: <20210311003604.22199-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Replace the master ethernet device by the dsa slave port. Packets coming
in from the software ingress path use the dsa slave port as input
device.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_flow_offload.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 81a5e2b6c901..143d049fd7f1 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -89,6 +89,7 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 		path = &stack->path[i];
 		switch (path->type) {
 		case DEV_PATH_ETHERNET:
+		case DEV_PATH_DSA:
 		case DEV_PATH_VLAN:
 		case DEV_PATH_PPPOE:
 			info->indev = path->dev;
@@ -97,6 +98,10 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 
 			if (path->type == DEV_PATH_ETHERNET)
 				break;
+			if (path->type == DEV_PATH_DSA) {
+				i = stack->num_paths;
+				break;
+			}
 
 			/* DEV_PATH_VLAN and DEV_PATH_PPPOE */
 			if (info->num_encaps >= NF_FLOW_TABLE_ENCAP_MAX) {
-- 
2.20.1

