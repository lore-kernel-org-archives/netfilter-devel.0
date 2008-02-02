From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 24/34]  Fix IPv4 output.
Date: Sat,  2 Feb 2008 22:24:19 +0100
Message-ID: <12019874713790-git-send-email-eric@inl.fr>
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
Cc: Eric leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:45985 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754918AbYBBWNn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Feb 2008 17:13:43 -0500
In-Reply-To: <1201987471531-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Eric leblond <eric@inl.fr>

Fix a bug in IPv4 output of IP2BIN module.

Signed-off-by: Eric leblond <eric@inl.fr>
---
:100644 100644 7790cbd... 92bfa88... M	filter/ulogd_filter_IP2BIN.c
 filter/ulogd_filter_IP2BIN.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/filter/ulogd_filter_IP2BIN.c b/filter/ulogd_filter_IP2BIN.c
index 7790cbd..92bfa88 100644
--- a/filter/ulogd_filter_IP2BIN.c
+++ b/filter/ulogd_filter_IP2BIN.c
@@ -136,6 +136,7 @@ static char *ip2bin(struct ulogd_key* inp, int index, char family)
 	char tmp[IPADDR_LENGTH];
 	unsigned char *addr8;
 	struct in6_addr *addr;
+	struct in6_addr ip4_addr;
 	char *buffer;
 	int i, written;
 
@@ -145,6 +146,7 @@ static char *ip2bin(struct ulogd_key* inp, int index, char family)
 			break;
 		case AF_INET:
 			/* Convert IPv4 to IPv4 in IPv6 */
+			addr = &ip4_addr;
 			uint32_to_ipv6(GET_VALUE(inp, index).ui32, addr);
 			break;
 		default:
-- 
1.5.2.5

