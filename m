From: "Holger Eitzenberger" <holger@eitzenberger.org>
Subject: [patch 2/6] ipset: fix the Netlink sequence number
Date: Mon, 24 Jan 2011 22:36:33 +0100
Message-ID: <20110124214010.719680787@jonathan.eitzenberger.org>
References: <20110124213631.195499507@jonathan.eitzenberger.org>
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:62596 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab1AXVkN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Jan 2011 16:40:13 -0500
Content-Disposition: inline; filename=ipset-netlink-sequence.diff
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Do not use time() as a Netlink sequence number for each message,
as otherwise the same seq number will be used when sending
another message in the same second.  Instead use time() just for
initialization, then increment per message.

Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>

Index: ipset/lib/mnl.c
===================================================================
--- ipset.orig/lib/mnl.c
+++ ipset/lib/mnl.c
@@ -75,7 +75,7 @@ ipset_mnl_fill_hdr(struct ipset_handle *
 	nlh->nlmsg_flags = cmdflags[cmd - 1];
 	if (envflags & IPSET_ENV_EXIST)
 	    	nlh->nlmsg_flags &=  ~NLM_F_EXCL;
-	nlh->nlmsg_seq = handle->seq = time(NULL);
+	nlh->nlmsg_seq = ++handle->seq;
 
 	nfg = mnl_nlmsg_put_extra_header(nlh, sizeof(struct nfgenmsg));
 	nfg->nfgen_family = AF_INET;
@@ -135,6 +135,7 @@ ipset_mnl_init(mnl_cb_t *cb_ctl, void *d
 	handle->portid = mnl_socket_get_portid(handle->h);
 	handle->cb_ctl = cb_ctl;
 	handle->data = data;
+	handle->seq = time(NULL);
 	
 	return handle;
 

