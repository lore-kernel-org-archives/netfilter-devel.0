Return-Path: <SRS0=WPBU=CJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13D8BC433E6
	for <netfilter-devel@archiver.kernel.org>; Mon, 31 Aug 2020 09:37:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC6D92068F
	for <netfilter-devel@archiver.kernel.org>; Mon, 31 Aug 2020 09:37:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbgHaJhc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 31 Aug 2020 05:37:32 -0400
Received: from correo.us.es ([193.147.175.20]:40390 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726334AbgHaJg7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 31 Aug 2020 05:36:59 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7EC9215AEAE
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Aug 2020 11:36:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 70FBBDA791
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Aug 2020 11:36:57 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 650DDDA789; Mon, 31 Aug 2020 11:36:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3C4B3DA78E;
        Mon, 31 Aug 2020 11:36:55 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 31 Aug 2020 11:36:55 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 1079A42EF4E0;
        Mon, 31 Aug 2020 11:36:55 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 4/8] selftests: netfilter: exit on invalid parameters
Date:   Mon, 31 Aug 2020 11:36:44 +0200
Message-Id: <20200831093648.20765-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200831093648.20765-1-pablo@netfilter.org>
References: <20200831093648.20765-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>

exit script with comments when parameters are wrong during address
addition. No need for a message when trying to change MTU with lower
values: output is self-explanatory.
Use short testing sequence to avoid shellcheck warnings
(suggested by Stefano Brivio).

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../testing/selftests/netfilter/nft_flowtable.sh  | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/netfilter/nft_flowtable.sh b/tools/testing/selftests/netfilter/nft_flowtable.sh
index 28e32fddf9b2..dc05c9940597 100755
--- a/tools/testing/selftests/netfilter/nft_flowtable.sh
+++ b/tools/testing/selftests/netfilter/nft_flowtable.sh
@@ -96,10 +96,16 @@ do
 	esac
 done
 
-ip -net nsr1 link set veth0 mtu $omtu
+if ! ip -net nsr1 link set veth0 mtu $omtu; then
+	exit 1
+fi
+
 ip -net ns1 link set eth0 mtu $omtu
 
-ip -net nsr2 link set veth1 mtu $rmtu
+if ! ip -net nsr2 link set veth1 mtu $rmtu; then
+	exit 1
+fi
+
 ip -net ns2 link set eth0 mtu $rmtu
 
 # transfer-net between nsr1 and nsr2.
@@ -120,7 +126,10 @@ for i in 1 2; do
   ip -net ns$i route add default via 10.0.$i.1
   ip -net ns$i addr add dead:$i::99/64 dev eth0
   ip -net ns$i route add default via dead:$i::1
-  ip netns exec ns$i sysctl net.ipv4.tcp_no_metrics_save=1 > /dev/null
+  if ! ip netns exec ns$i sysctl net.ipv4.tcp_no_metrics_save=1 > /dev/null; then
+	echo "ERROR: Check Originator/Responder values (problem during address addition)"
+	exit 1
+  fi
 
   # don't set ip DF bit for first two tests
   ip netns exec ns$i sysctl net.ipv4.ip_no_pmtu_disc=1 > /dev/null
-- 
2.20.1

