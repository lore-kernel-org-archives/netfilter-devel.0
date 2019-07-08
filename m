Return-Path: <SRS0=pcH3=VF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31B3EC606BD
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Jul 2019 16:06:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1339D21537
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Jul 2019 16:06:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391338AbfGHQGe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Jul 2019 12:06:34 -0400
Received: from mail.us.es ([193.147.175.20]:52752 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391249AbfGHQGe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Jul 2019 12:06:34 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2803CB6322
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Jul 2019 18:06:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 146BB10219C
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Jul 2019 18:06:32 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 13A82DA708; Mon,  8 Jul 2019 18:06:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0D8DB1021B2;
        Mon,  8 Jul 2019 18:06:29 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 08 Jul 2019 18:06:27 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id D7FFA4265A2F;
        Mon,  8 Jul 2019 18:06:27 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, thomas.lendacky@amd.com, f.fainelli@gmail.com,
        ariel.elior@cavium.com, michael.chan@broadcom.com,
        madalin.bucur@nxp.com, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, jeffrey.t.kirsher@intel.com,
        tariqt@mellanox.com, saeedm@mellanox.com, jiri@mellanox.com,
        idosch@mellanox.com, jakub.kicinski@netronome.com,
        peppe.cavallaro@st.com, grygorii.strashko@ti.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, linux-net-drivers@solarflare.com,
        ogerlitz@mellanox.com, Manish.Chopra@cavium.com,
        marcelo.leitner@gmail.com, mkubecek@suse.cz,
        venkatkumar.duvvuru@broadcom.com, maxime.chevallier@bootlin.com,
        cphealy@gmail.com, netfilter-devel@vger.kernel.org
Subject: [PATCH net-next,v3 06/11] net: flow_offload: add flow_block_cb_{priv,incref,decref}()
Date:   Mon,  8 Jul 2019 18:06:08 +0200
Message-Id: <20190708160614.2226-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190708160614.2226-1-pablo@netfilter.org>
References: <20190708160614.2226-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch completes the flow block API to introduce:

* flow_block_cb_priv() to accept callback private data.
* flow_block_cb_incref() to bump reference counter on this flow block.
* flow_block_cb_decref() to decrement the reference counter.

These function are taken from the existing tcf_block_cb_priv(),
tcf_block_cb_incref() and tcf_block_cb_decref().

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: missing in previous batch.

 include/net/flow_offload.h |  4 ++++
 net/core/flow_offload.c    | 18 ++++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 06acde2960fa..342e6aef7e3a 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -277,6 +277,10 @@ struct flow_block_cb *flow_block_cb_lookup(struct net *net,
 					   struct list_head *driver_flow_block_list,
 					   tc_setup_cb_t *cb, void *cb_ident);
 
+void *flow_block_cb_priv(struct flow_block_cb *block_cb);
+void flow_block_cb_incref(struct flow_block_cb *block_cb);
+unsigned int flow_block_cb_decref(struct flow_block_cb *block_cb);
+
 static inline void flow_block_cb_add(struct flow_block_cb *block_cb,
 				     struct flow_block_offload *offload)
 {
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index 85fd5f4a1e0f..916ff32e53e7 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -212,6 +212,24 @@ struct flow_block_cb *flow_block_cb_lookup(struct net *net,
 }
 EXPORT_SYMBOL(flow_block_cb_lookup);
 
+void *flow_block_cb_priv(struct flow_block_cb *block_cb)
+{
+	return block_cb->cb_priv;
+}
+EXPORT_SYMBOL(flow_block_cb_priv);
+
+void flow_block_cb_incref(struct flow_block_cb *block_cb)
+{
+	block_cb->refcnt++;
+}
+EXPORT_SYMBOL(flow_block_cb_incref);
+
+unsigned int flow_block_cb_decref(struct flow_block_cb *block_cb)
+{
+	return --block_cb->refcnt;
+}
+EXPORT_SYMBOL(flow_block_cb_decref);
+
 int flow_block_cb_setup_simple(struct flow_block_offload *f,
 			       struct list_head *driver_block_list,
 			       tc_setup_cb_t *cb, void *cb_ident, void *cb_priv,
-- 
2.11.0

