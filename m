From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 26/34]  Modify IPv6 parser to fill oob_family.
Date: Sat,  2 Feb 2008 22:24:21 +0100
Message-ID: <12019874713782-git-send-email-eric@inl.fr>
References: <1201987469575-git-send-email-eric@inl.fr>
 <1201987469368-git-send-email-eric@inl.fr>
 <12019874692227-git-send-email-eric@inl.fr>
 <12019874701613-git-send-email-eric@inl.fr>
 <12019874702005-git-send-email-eric@inl.fr>
 <12019874703998-git-send-email-eric@inl.fr>
 <12019874701589-git-send-email-eric@inl.fr>
 <12019874701366-git-send-email-eric@inl.fr>
 <12019874704144-git-send-email-eric@inl.fr>
 <12019874703136-git-send-email-eric@inl.fr>
 <12019874701552-git-send-email-eric@inl.fr>
 <12019874701370-git-send-email-eric@inl.fr>
 <12019874702349-git-send-email-eric@inl.fr>
 <12019874703504-git-send-email-eric@inl.fr>
 <12019874704067-git-send-email-eric@inl.fr>
 <12019874703897-git-send-email-eric@inl.fr>
 <12019874712066-git-send-email-eric@inl.fr>
 <1201987471474-git-send-email-eric@inl.fr>
 <1201987471346-git-send-email-eric@inl.fr>
 <12019874712309-git-send-email-eric@inl.fr>
 <12019874714080-git-send-email-eric@inl.fr>
 <12019874712041-git-send-email-eric@inl.fr>
 <12019874711938-git-send-email-eric@inl.fr>
 <1201987471531-git-send-email-eric@inl.fr>
 <12019874713790-git-send-email-eric@inl.fr>
 <12019874712753-git-send-email-eric@inl.fr>
Cc: Eric leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:46022 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762084AbYBBWPc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Feb 2008 17:15:32 -0500
In-Reply-To: <12019874712753-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Eric leblond <eric@inl.fr>

With this patch, BASE filter module is able fill oob_family when parsing IPv6
address.

Signed-off-by: Eric leblond <eric@inl.fr>
---
:100644 100644 e837c62... 48f2993... M	filter/raw2packet/ulogd_raw2packet_BASE.c
 filter/raw2packet/ulogd_raw2packet_BASE.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/filter/raw2packet/ulogd_raw2packet_BASE.c b/filter/raw2packet/ulogd_raw2packet_BASE.c
index e837c62..48f2993 100644
--- a/filter/raw2packet/ulogd_raw2packet_BASE.c
+++ b/filter/raw2packet/ulogd_raw2packet_BASE.c
@@ -795,6 +795,10 @@ static int _interp_ipv6hdr(struct ulogd_pluginstance *pi, u_int32_t len)
 	if (fragment)
 		goto out;
 
+
+	ret[KEY_IP_PROTOCOL].u.value.ui8 = curhdr;
+	ret[KEY_IP_PROTOCOL].flags |= ULOGD_RETF_VALID;
+
 	switch (curhdr) {
 	case IPPROTO_TCP:
 		_interp_tcp(pi, (void *)ipv6h + ptr, len);
-- 
1.5.2.5

