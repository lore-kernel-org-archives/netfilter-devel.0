Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDE9BC54EBD
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Jan 2023 19:39:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235605AbjAFTjn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 6 Jan 2023 14:39:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231335AbjAFTjm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 6 Jan 2023 14:39:42 -0500
X-Greylist: delayed 855 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 06 Jan 2023 11:39:41 PST
Received: from galois.cryonox.net (galois.cryonox.net [173.255.233.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6427A78A46
        for <netfilter-devel@vger.kernel.org>; Fri,  6 Jan 2023 11:39:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cryonox.net
        ; s=x; h=Subject:Content-Type:MIME-Version:Message-ID:To:From:Date:Sender:
        Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=0BQltuNE4P+dCQakvegSIo573JQB7+XzIsg9vxBmNDA=; b=vnQOmS/eEHnzOVtnLRcxzbxPua
        7c0zKh5a6e7a3fNIGl+Gb+PdiwmNvqNJ+pD+t65lP8lpQcNs3UCPxNFWAK7agvkzqjIBiwBHInABo
        0RS6zWFINmNd5HTmEd3vzVOZZKatJ9cAXegEoVQl7N6Wjg0/XBMpnpXh/ghUhxXJyPr50eqbtV0ea
        Wp3PGp+t1Kj8Sj6e4eDEsGJ60Aodx2+u9ADX17RQXk6jQ2J1Qh9EPtDSG745JK90zbqswReRu9Qt2
        kuRHvZRJ2CboUZ1yBcFX60C/wTpB1/8g+qWrHy96gT14oXbHcupTd+75xg/5sbWPHMDbqH0JEXrBz
        xD+6/Tcg==;
Received: from authenticated_user by galois.cryonox.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        id 1pDsLD-005SEa-DC; Fri, 06 Jan 2023 14:25:25 -0500
Date:   Fri, 6 Jan 2023 14:25:23 -0500
From:   William Blough <devel@blough.us>
To:     netfilter-devel@vger.kernel.org
Message-ID: <Y7h1o0H+dvAz1vtZ@prometheus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-SA-Exim-Connect-IP: 209.170.225.186
X-SA-Exim-Mail-From: devel@blough.us
Subject: [PATCH libnetfilter_conntrack 1/1] conntrack: Allow setting of
 netlink buffer size
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on galois.cryonox.net)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

ENOBUFS is returned in the case that the nfnetlink socket buffer is
exhausted.  The function nfnl_rcvbufsize is provided by libnfnetlink
to set the buffer size in order to handle this error, however
libnetfilter_conntrack does not expose this function for the underlying
netlink socket.

Add nfct_rcvbufsiz function to allow setting of buffer size for netlink
socket.

Signed-off-by: William Blough <devel@blough.us>
---
 .../libnetfilter_conntrack.h                   |  3 +++
 src/conntrack/api.c                            | 18 ++++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/include/libnetfilter_conntrack/libnetfilter_conntrack.h b/include/libnetfilter_conntrack/libnetfilter_conntrack.h
index e229472..d496307 100644
--- a/include/libnetfilter_conntrack/libnetfilter_conntrack.h
+++ b/include/libnetfilter_conntrack/libnetfilter_conntrack.h
@@ -591,6 +591,9 @@ extern int nfct_nlmsg_build_filter(struct nlmsghdr *nlh, const struct nfct_filte
 extern int nfct_nlmsg_parse(const struct nlmsghdr *nlh, struct nf_conntrack *ct);
 extern int nfct_payload_parse(const void *payload, size_t payload_len, uint16_t l3num, struct nf_conntrack *ct);
 
+/* set size of netlink socket buffer */
+unsigned int nfct_rcvbufsize(struct nfct_handle *h, unsigned int size);
+
 /*
  * NEW expectation API
  */
diff --git a/src/conntrack/api.c b/src/conntrack/api.c
index 7f72d07..699f560 100644
--- a/src/conntrack/api.c
+++ b/src/conntrack/api.c
@@ -350,6 +350,24 @@ void nfct_callback_unregister2(struct nfct_handle *h)
 	h->nfnl_cb_ct.attr_count = 0;
 }
 
+/**
+ * nfct_rcvbufsiz - set size of netlink socket buffer
+ * \param h library handler
+ * \param size size of the buffer we want to set
+ *
+ * This function sets the new size of the the netlink socket buffer.  Use this
+ * setting to increase the socket buffer size if your system is reporting
+ * ENOBUFS errors.
+ *
+ * This function returns the new size of the netlink socket buffer.
+ */
+unsigned int nfct_rcvbufsiz(struct nfct_handle *h, unsigned int size)
+{
+	assert(h != NULL);
+
+	return nfnl_rcvbufsiz(h->nfnlh, size);
+}
+
 /**
  * @}
  */
-- 
2.30.2

