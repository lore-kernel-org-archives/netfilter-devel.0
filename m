Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6299B3587DE;
	Tue, 18 Nov 2025 13:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763473636; cv=none; b=SAe+dj/UM4rvA3bZDVpPyYHzXeoc0nPTL09i4YIvg3F0ySyHB1oJ/wj02rnIUPlvW7de9C7QThCJCAsX+qyxcBJ46Fk/HRzy6kKmqU0wbCh7UnwLM/88nIKmilcQJgOeyY3yBkUh7gdsH0QBdNX+g+NckDmj5MkvD2djx+VskTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763473636; c=relaxed/simple;
	bh=6hSJTmIfXFgrzFxCaZoUbCubdXI30Msf3ViDl+lGj1A=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FPap5sqwI45E8OzwSAilV599KZoZ/pKZ+0T5FLYJOdtfvZehMRFyqmkvhC1V3rsEFukpE9jLk96zUYEjebXmQeWBZRQ9MYV7haJ30vnwPJYMx0/SVBuAMqrgii85veCevZbtJbZKwEHVJ8QVGb9U7LURg9GQZNnKB+Pf0BTn9DE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com; spf=pass smtp.mailfrom=huawei-partners.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4d9m9l6PmMzHnH7Y;
	Tue, 18 Nov 2025 21:46:35 +0800 (CST)
Received: from mscpeml500004.china.huawei.com (unknown [7.188.26.250])
	by mail.maildlp.com (Postfix) with ESMTPS id C775214033F;
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
Subject: [RFC PATCH v4 15/19] lsm: Support logging socket common data
Date: Tue, 18 Nov 2025 21:46:35 +0800
Message-ID: <20251118134639.3314803-16-ivanov.mikhail1@huawei-partners.com>
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

Add LSM_AUDIT_DATA_SOCKET type to log socket-related data in
audit_log_lsm_data(). This may be useful (for example) to log socket
creation denials.

Signed-off-by: Mikhail Ivanov <ivanov.mikhail1@huawei-partners.com>
---
 include/linux/lsm_audit.h | 8 ++++++++
 security/lsm_audit.c      | 4 ++++
 2 files changed, 12 insertions(+)

diff --git a/include/linux/lsm_audit.h b/include/linux/lsm_audit.h
index 382c56a97bba..7c7617df41b5 100644
--- a/include/linux/lsm_audit.h
+++ b/include/linux/lsm_audit.h
@@ -57,6 +57,12 @@ struct lsm_ibendport_audit {
 	u8 port;
 };
 
+struct lsm_socket_audit {
+	s32 family;
+	s32 type;
+	s32 protocol;
+};
+
 /* Auxiliary data to use in generating the audit record. */
 struct common_audit_data {
 	char type;
@@ -78,6 +84,7 @@ struct common_audit_data {
 #define LSM_AUDIT_DATA_NOTIFICATION 16
 #define LSM_AUDIT_DATA_ANONINODE	17
 #define LSM_AUDIT_DATA_NLMSGTYPE	18
+#define LSM_AUDIT_DATA_SOCKET	19
 	union 	{
 		struct path path;
 		struct dentry *dentry;
@@ -97,6 +104,7 @@ struct common_audit_data {
 		struct file *file;
 		struct lsm_ibpkey_audit *ibpkey;
 		struct lsm_ibendport_audit *ibendport;
+		struct lsm_socket_audit *socket;
 		int reason;
 		const char *anonclass;
 		u16 nlmsg_type;
diff --git a/security/lsm_audit.c b/security/lsm_audit.c
index 7d623b00495c..7e18241290ce 100644
--- a/security/lsm_audit.c
+++ b/security/lsm_audit.c
@@ -403,6 +403,10 @@ void audit_log_lsm_data(struct audit_buffer *ab,
 	case LSM_AUDIT_DATA_NLMSGTYPE:
 		audit_log_format(ab, " nl-msgtype=%hu", a->u.nlmsg_type);
 		break;
+	case LSM_AUDIT_DATA_SOCKET:
+		audit_log_format(ab, " family=%d sock_type=%d protocol=%d",
+			a->u.socket->family, a->u.socket->type, a->u.socket->protocol);
+		break;
 	} /* switch (a->type) */
 }
 
-- 
2.34.1

