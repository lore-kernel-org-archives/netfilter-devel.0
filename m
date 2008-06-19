From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 3/6] Fix warning about unused variable if NFLOG_GID is not available.
Date: Thu, 19 Jun 2008 14:23:04 +0200
Message-ID: <1213878187-909-4-git-send-email-eric@inl.fr>
References: <1213878187-909-1-git-send-email-eric@inl.fr>
Cc: chifflier@inl.fr, Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:60860 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756152AbYFSMXc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Jun 2008 08:23:32 -0400
In-Reply-To: <1213878187-909-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch fixes a warning about an unused variable if NFLOG_GID is not available
in libnetfilter_log.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 input/packet/ulogd_inppkt_NFLOG.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/input/packet/ulogd_inppkt_NFLOG.c b/input/packet/ulogd_inppkt_NFLOG.c
index 728b410..9689929 100644
--- a/input/packet/ulogd_inppkt_NFLOG.c
+++ b/input/packet/ulogd_inppkt_NFLOG.c
@@ -302,7 +302,9 @@ interp_packet(struct ulogd_pluginstance *upi, struct nflog_data *ldata)
 	u_int32_t outdev = nflog_get_outdev(ldata);
 	u_int32_t seq;
 	u_int32_t uid;
+#ifdef HAVE_NFLOG_GET_GID
 	u_int32_t gid;
+#endif
 
 	ret[NFLOG_KEY_OOB_FAMILY].u.value.ui8 = af_ce(upi->config_kset).u.value;
 	ret[NFLOG_KEY_OOB_FAMILY].flags |= ULOGD_RETF_VALID;
-- 
1.5.5.3

