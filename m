From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 2/6] Fix display of IPv6 address.
Date: Wed, 26 Mar 2008 23:49:07 +0100
Message-ID: <12065717511847-git-send-email-eric@inl.fr>
References: <12065717514081-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:36535 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754045AbYCZWtN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Mar 2008 18:49:13 -0400
In-Reply-To: <12065717514081-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

An error in the type of an argument in the call to inet_ntop was causing IPv6
address to be transformed in a string not really related to the real Ipv6
address.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
:100644 100644 9f36d60... e4ec06d... M	filter/ulogd_filter_IP2STR.c
 filter/ulogd_filter_IP2STR.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/filter/ulogd_filter_IP2STR.c b/filter/ulogd_filter_IP2STR.c
index 9f36d60..e4ec06d 100644
--- a/filter/ulogd_filter_IP2STR.c
+++ b/filter/ulogd_filter_IP2STR.c
@@ -174,7 +174,7 @@ static char *ip2str(struct ulogd_key *inp, int index)
 	switch (convfamily) {
 	case AF_INET6:
 		inet_ntop(AF_INET6,
-			  &GET_VALUE(inp, index).ptr,
+			  GET_VALUE(inp, index).ptr,
 			  tmp, sizeof(tmp));
 		break;
 	case AF_INET:
-- 
1.5.2.5

