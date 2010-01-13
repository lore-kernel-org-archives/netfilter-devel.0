From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5/6] NFCT: fix number of options (missing one)
Date: Wed, 13 Jan 2010 12:44:02 +0100
Message-ID: <20100113114402.12994.58087.stgit@decadence>
References: <20100113114009.12994.26386.stgit@decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37680 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751809Ab0AMLth (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Jan 2010 06:49:37 -0500
In-Reply-To: <20100113114009.12994.26386.stgit@decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch fixes the number of options in NFCT that is
actually 8, not 7.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 input/flow/ulogd_inpflow_NFCT.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/input/flow/ulogd_inpflow_NFCT.c b/input/flow/ulogd_inpflow_NFCT.c
index da23ada..8e01feb 100644
--- a/input/flow/ulogd_inpflow_NFCT.c
+++ b/input/flow/ulogd_inpflow_NFCT.c
@@ -71,7 +71,7 @@ struct nfct_pluginstance {
 #define EVENT_MASK	NF_NETLINK_CONNTRACK_NEW | NF_NETLINK_CONNTRACK_DESTROY
 
 static struct config_keyset nfct_kset = {
-	.num_ces = 7,
+	.num_ces = 8,
 	.ces = {
 		{
 			.key	 = "pollinterval",

