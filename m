Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5C1E664CF
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Feb 2024 11:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708428411; cv=none; b=AomEFI3G530hm2UPTp5vfjuV5XJhec+3rOR6F2oPxO7DHVlB0Rv4qnPTvV7IADGduOq0V9FBcdGbIet1bW3lmu5mpzq2TcTZk/f12yijAAR8cvZiufPlaWLDbx7O635vmZhGIlkp1FgZxkUHcaeTeeO5c1P1uLtNS6ctMJJr8Y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708428411; c=relaxed/simple;
	bh=i9eRxp0YBxIBoudi22UFjDh3B8ycpd5+FB+ltxSoA4k=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=K445UUGHqnNQZH4cjE1YJbNdrKQ45PIuD+4IoeWWHCwEKP0XbvhDP3FJQDMrZYUiAdCpeDGOATujQ6qzKvqRf7GKEDrb+MW+6aFJ85whLSjb+fWAPiAeikw39L/34FvLWlam4njFiUrBk9k7KHcAwspso8PVJmyGTgaFqqJ0LSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH libnftnl] obj: ct_timeout: setter checks for timeout array boundaries
Date: Tue, 20 Feb 2024 12:26:36 +0100
Message-Id: <20240220112636.271115-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use _MAX definitions for timeout attribute arrays and check that
timeout array is not larger than NFTNL_CTTIMEOUT_ARRAY_MAX.

Fixes: 0adceeab1597 ("src: add ct timeout support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/obj/ct_timeout.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/src/obj/ct_timeout.c b/src/obj/ct_timeout.c
index 65b48bda4a97..fedf9e38b7ac 100644
--- a/src/obj/ct_timeout.c
+++ b/src/obj/ct_timeout.c
@@ -21,7 +21,7 @@
 
 #include "obj.h"
 
-static const char *const tcp_state_to_name[] = {
+static const char *const tcp_state_to_name[NFTNL_CTTIMEOUT_TCP_MAX] = {
 	[NFTNL_CTTIMEOUT_TCP_SYN_SENT]		= "SYN_SENT",
 	[NFTNL_CTTIMEOUT_TCP_SYN_RECV]		= "SYN_RECV",
 	[NFTNL_CTTIMEOUT_TCP_ESTABLISHED]	= "ESTABLISHED",
@@ -35,7 +35,7 @@ static const char *const tcp_state_to_name[] = {
 	[NFTNL_CTTIMEOUT_TCP_UNACK]		= "UNACKNOWLEDGED",
 };
 
-static uint32_t tcp_dflt_timeout[] = {
+static uint32_t tcp_dflt_timeout[NFTNL_CTTIMEOUT_TCP_MAX] = {
 	[NFTNL_CTTIMEOUT_TCP_SYN_SENT]		= 120,
 	[NFTNL_CTTIMEOUT_TCP_SYN_RECV]		= 60,
 	[NFTNL_CTTIMEOUT_TCP_ESTABLISHED]	= 432000,
@@ -49,12 +49,12 @@ static uint32_t tcp_dflt_timeout[] = {
 	[NFTNL_CTTIMEOUT_TCP_UNACK]		= 300,
 };
 
-static const char *const udp_state_to_name[] = {
+static const char *const udp_state_to_name[NFTNL_CTTIMEOUT_UDP_MAX] = {
 	[NFTNL_CTTIMEOUT_UDP_UNREPLIED]		= "UNREPLIED",
 	[NFTNL_CTTIMEOUT_UDP_REPLIED]		= "REPLIED",
 };
 
-static uint32_t udp_dflt_timeout[] = {
+static uint32_t udp_dflt_timeout[NFTNL_CTTIMEOUT_UDP_MAX] = {
 	[NFTNL_CTTIMEOUT_UDP_UNREPLIED]		= 30,
 	[NFTNL_CTTIMEOUT_UDP_REPLIED]		= 180,
 };
@@ -156,6 +156,9 @@ static int nftnl_obj_ct_timeout_set(struct nftnl_obj *e, uint16_t type,
 		memcpy(&timeout->l4proto, data, sizeof(timeout->l4proto));
 		break;
 	case NFTNL_OBJ_CT_TIMEOUT_ARRAY:
+		if (data_len < sizeof(uint32_t) * NFTNL_CTTIMEOUT_ARRAY_MAX)
+			return -1;
+
 		memcpy(timeout->timeout, data,
 		       sizeof(uint32_t) * NFTNL_CTTIMEOUT_ARRAY_MAX);
 		break;
-- 
2.30.2

