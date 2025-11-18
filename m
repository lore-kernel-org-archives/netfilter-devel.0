Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3B7357A45;
	Tue, 18 Nov 2025 13:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763473635; cv=none; b=Z4cxTqiAcjZqpsKlXy/+X9PF6iGxZnILu8mjZBgSdeiWQiJLZbGYKHR7O7EwS8cEu03SBpZdk4KGvRetmwyn3SHXNddQljEUQ+yrQjZoElAnK+L3UhDEyHleVHX1wEOkVt5cc69mOEMep2k6AqgzDxscNcmj78ZfD5fLTNDXb68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763473635; c=relaxed/simple;
	bh=w4hyAIL+6jmpB9z3CpLYiz5UDPbudmcFfZpMhGpeoOI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Yx7HaII9GOY/k1Q53EI4HQmI5fEDB5wEh2JUWs071qDd746qsAQ6bKhkCDKelGWYkTxmM7xEM45n/ZeCAoAXUjExFbn6nE+crc8fZb9N/8PmxpO2waGSvEsHVNEB2wp/KFEu/9drk9Ees01AmJvhCwmTGczdX3/K5ROZRtX1XJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4d9m9X4G4CzJ46dN;
	Tue, 18 Nov 2025 21:46:24 +0800 (CST)
Received: from mscpeml500004.china.huawei.com (unknown [7.188.26.250])
	by mail.maildlp.com (Postfix) with ESMTPS id E08581402F3;
	Tue, 18 Nov 2025 21:47:06 +0800 (CST)
Received: from mscphis02103.huawei.com (10.123.65.215) by
 mscpeml500004.china.huawei.com (7.188.26.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 18 Nov 2025 16:47:06 +0300
From: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
To: <mic@digikod.net>, <gnoack@google.com>
CC: <willemdebruijn.kernel@gmail.com>, <matthieu@buffet.re>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>, <konstantin.meskhidze@huawei.com>
Subject: [RFC PATCH v4 16/19] landlock: Log socket creation denials
Date: Tue, 18 Nov 2025 21:46:36 +0800
Message-ID: <20251118134639.3314803-17-ivanov.mikhail1@huawei-partners.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251118134639.3314803-1-ivanov.mikhail1@huawei-partners.com>
References: <20251118134639.3314803-1-ivanov.mikhail1@huawei-partners.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: mscpeml500004.china.huawei.com (7.188.26.250) To
 mscpeml500004.china.huawei.com (7.188.26.250)

Add new type in landlock_requet_type related to socket access checks
auditing. Print blocker related to socket access in get_blocker() and
log socket creation denials in hook_socket_create().

Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
---
 security/landlock/audit.c  | 12 ++++++++++++
 security/landlock/audit.h  |  1 +
 security/landlock/socket.c | 15 +++++++++++++++
 3 files changed, 28 insertions(+)

diff --git a/security/landlock/audit.c b/security/landlock/audit.c
index c52d079cdb77..c2c0e8fd38cb 100644
--- a/security/landlock/audit.c
+++ b/security/landlock/audit.c
@@ -48,6 +48,12 @@ static const char *const net_access_strings[] = {
 
 static_assert(ARRAY_SIZE(net_access_strings) == LANDLOCK_NUM_ACCESS_NET);
 
+static const char *const socket_access_strings[] = {
+	[BIT_INDEX(LANDLOCK_ACCESS_SOCKET_CREATE)] = "socket.create",
+};
+
+static_assert(ARRAY_SIZE(socket_access_strings) == LANDLOCK_NUM_ACCESS_SOCKET);
+
 static __attribute_const__ const char *
 get_blocker(const enum landlock_request_type type,
 	    const unsigned long access_bit)
@@ -71,6 +77,12 @@ get_blocker(const enum landlock_request_type type,
 			return "unknown";
 		return net_access_strings[access_bit];
 
+	case LANDLOCK_REQUEST_SOCKET_ACCESS:
+		if (WARN_ON_ONCE(access_bit >=
+				 ARRAY_SIZE(socket_access_strings)))
+			return "unknown";
+		return socket_access_strings[access_bit];
+
 	case LANDLOCK_REQUEST_SCOPE_ABSTRACT_UNIX_SOCKET:
 		WARN_ON_ONCE(access_bit != -1);
 		return "scope.abstract_unix_socket";
diff --git a/security/landlock/audit.h b/security/landlock/audit.h
index 92428b7fc4d8..b78d4503b0a5 100644
--- a/security/landlock/audit.h
+++ b/security/landlock/audit.h
@@ -19,6 +19,7 @@ enum landlock_request_type {
 	LANDLOCK_REQUEST_FS_CHANGE_TOPOLOGY,
 	LANDLOCK_REQUEST_FS_ACCESS,
 	LANDLOCK_REQUEST_NET_ACCESS,
+	LANDLOCK_REQUEST_SOCKET_ACCESS,
 	LANDLOCK_REQUEST_SCOPE_ABSTRACT_UNIX_SOCKET,
 	LANDLOCK_REQUEST_SCOPE_SIGNAL,
 };
diff --git a/security/landlock/socket.c b/security/landlock/socket.c
index d7e6e7b92b7a..6afd5a0ac6d7 100644
--- a/security/landlock/socket.c
+++ b/security/landlock/socket.c
@@ -10,6 +10,7 @@
 #include <linux/stddef.h>
 #include <net/ipv6.h>
 
+#include "audit.h"
 #include "limits.h"
 #include "ruleset.h"
 #include "socket.h"
@@ -132,6 +133,11 @@ static int hook_socket_create(int family, int type, int protocol, int kern)
 	const struct landlock_cred_security *const subject =
 		landlock_get_applicable_subject(current_cred(), masks, NULL);
 	uintptr_t key;
+	struct lsm_socket_audit audit_socket = {
+		.family = family,
+		.type = type,
+		.protocol = protocol,
+	};
 
 	if (!subject)
 		return 0;
@@ -169,6 +175,15 @@ static int hook_socket_create(int family, int type, int protocol, int kern)
 				handled_access) == 0)
 		return 0;
 
+	landlock_log_denial(subject,
+			    &(struct landlock_request){
+				    .type = LANDLOCK_REQUEST_SOCKET_ACCESS,
+				    .audit.type = LSM_AUDIT_DATA_SOCKET,
+				    .audit.u.socket = &audit_socket,
+				    .access = LANDLOCK_ACCESS_SOCKET_CREATE,
+				    .layer_masks = &layer_masks,
+				    .layer_masks_size = ARRAY_SIZE(layer_masks),
+			    });
 	return -EACCES;
 }
 
-- 
2.34.1

