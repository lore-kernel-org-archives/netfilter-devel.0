From: Eric Leblond <eric@inl.fr>
Subject: [libnetfilter_log 2/3] Set nflog_errno as needed.
Date: Mon, 29 Dec 2008 22:33:23 +0100
Message-ID: <1230586404-24639-3-git-send-email-eric@inl.fr>
References: <1230586404-24639-1-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:43342 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752783AbYL2Vdc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 29 Dec 2008 16:33:32 -0500
In-Reply-To: <1230586404-24639-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Some FIXME were put to fix some issues related to nflog_errno not being set. In both case, this was
related to error treatment of libnfnetlink function. As these functions are setting errno to the
correct value, this patch simply copy errno to nflog_errno in libnetfilter_log.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 src/libnetfilter_log.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/libnetfilter_log.c b/src/libnetfilter_log.c
index ed92561..9343f90 100644
--- a/src/libnetfilter_log.c
+++ b/src/libnetfilter_log.c
@@ -178,7 +178,7 @@ struct nflog_handle *nflog_open_nfnl(struct nfnl_handle *nfnlh)
 	h->nfnlssh = nfnl_subsys_open(h->nfnlh, NFNL_SUBSYS_ULOG, 
 				      NFULNL_MSG_MAX, 0);
 	if (!h->nfnlssh) {
-		/* FIXME: nflog_errno */
+		nflog_errno = errno;
 		goto out_free;
 	}
 
@@ -210,7 +210,7 @@ struct nflog_handle *nflog_open(void)
 
 	nfnlh = nfnl_open();
 	if (!nfnlh) {
-		/* FIXME: nflog_errno */
+		nflog_errno = errno;
 		return NULL;
 	}
 
-- 
1.5.6.3

