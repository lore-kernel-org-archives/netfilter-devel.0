From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 32/38]: nf_conntrack_sctp: remove unused ttag field from conntrack data
Date: Tue, 15 Jan 2008 07:19:55 +0100 (MET)
Message-ID: <20080115061950.3184.50798.sendpatchset@localhost.localdomain>
References: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62258 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587AbYAOGT4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jan 2008 01:19:56 -0500
In-Reply-To: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack_sctp: remove unused ttag field from conntrack data

Spotted by Pablo Neira Ayuso <pablo@netfilter.org>.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 5c06ef38713fa6bc6cb80f7834464e4761a383dc
tree 9e8564b679a5a4a95e0e98c02e0c2040a5f3248e
parent febaa2eab0d9efc458d9cbefef7fa7f9859250d1
author Patrick McHardy <kaber@trash.net> Tue, 15 Jan 2008 06:53:29 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 15 Jan 2008 06:53:29 +0100

 include/linux/netfilter/nf_conntrack_sctp.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_sctp.h b/include/linux/netfilter/nf_conntrack_sctp.h
index 5cf2c11..768f78c 100644
--- a/include/linux/netfilter/nf_conntrack_sctp.h
+++ b/include/linux/netfilter/nf_conntrack_sctp.h
@@ -21,7 +21,6 @@ struct ip_ct_sctp
 	enum sctp_conntrack state;
 
 	__be32 vtag[IP_CT_DIR_MAX];
-	u_int32_t ttag[IP_CT_DIR_MAX];
 };
 
 #endif /* _NF_CONNTRACK_SCTP_H */
