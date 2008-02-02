From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 33/34]  ULOGD_RET_IPADDR is for IPv4 or IPv6 address: fix description.
Date: Sat,  2 Feb 2008 22:24:28 +0100
Message-ID: <12019874721483-git-send-email-eric@inl.fr>
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
 <12019874713782-git-send-email-eric@inl.fr>
 <12019874711816-git-send-email-eric@inl.fr>
 <1201987471602-git-send-email-eric@inl.fr>
 <12019874711187-git-send-email-eric@inl.fr>
 <12019874721299-git-send-email-eric@inl.fr>
 <12019874721188-git-send-email-eric@inl.fr>
 <12019874721527-git-send-email-eric@inl.fr>
Cc: Eric leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:46055 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762465AbYBBWQl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Feb 2008 17:16:41 -0500
In-Reply-To: <12019874721527-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Eric leblond <eric@inl.fr>

Description of ULOGD_RET_IPADDR was incorrect in information display mode.

Signed-off-by: Eric leblond <eric@inl.fr>
---
:100644 100644 e1eb951... 48529ca... M	src/ulogd.c
 src/ulogd.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/src/ulogd.c b/src/ulogd.c
index e1eb951..48529ca 100644
--- a/src/ulogd.c
+++ b/src/ulogd.c
@@ -264,10 +264,7 @@ char *type_to_string(int type)
 			return strdup("boolean");
 			break;
 		case ULOGD_RET_IPADDR:
-			return strdup("IPv4 addr");
-			break;
-		case ULOGD_RET_IP6ADDR:
-			return strdup("IPv6 addr");
+			return strdup("IP addr");
 			break;
 		case ULOGD_RET_STRING:
 			return strdup("string");
-- 
1.5.2.5

