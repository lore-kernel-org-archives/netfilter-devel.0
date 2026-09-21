Received: from mail-vk1-f179.google.com (mail-vk1-f179.google.com [209.85.221.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0607C4DE715
	for <netfilter-devel@vger.kernel.org>; Mon, 21 Sep 2026 20:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790024238; cv=none; b=qhvi1U/GBTvcA15r4Lf3CUkPt7nkit2WRGyPt+QLolv0NP1yw869FNBU+LlGpSu0u332exxEaek7hb1iLLrD7YVvy38t4OJgi7VHP20rcxwMa8MQZWWL1AFqWILbXCeHkR1jhkinBqFXlXSrI8YSVMHFKXU1a7O6FNlVLWdGr9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790024238; c=relaxed/simple;
	bh=XwLRDqoGDPXb6K5PWgL1M7DdV69+VMAJJyWkcb0+NUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U8qkMMw7rubpIDPzaT8fhrtnEe51wZFoiSyGsec8Xkcp1DBYkabPPORWLQKGZk26Dj/8OwtdiI2oVcNfrPfmZR/za3COqSfdlZMditkSg1jiDzjh4hpMZCw2DTauxNeEb4BafNKpD3R+td7UsUyBgTZl7FM+1EYHrptb4SDaO4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gctrSTTw; arc=none smtp.client-ip=209.85.221.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gctrSTTw"
Received: by mail-vk1-f179.google.com with SMTP id 71dfb90a1353d-5c675e64ffcso265226e0c.0
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Sep 2026 13:57:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790024235; x=1790629035; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=83+plyF4HOp6Tc6yDaOIUjOh/yxbiFagCuYc/tYX0qs=;
        b=gctrSTTwh4KNldwSOKV4v9wn6xM3km2liI0bThL0e3MKs+L5sSxsYX6hiLihvTnXdC
         ku2HRaTnNhLChkKO6nZ19EJmAGOhmZVG7nv3aGERcadabr5OjfowsbVJJL2ZNL+IQdTA
         TZ4g4idRdhnJiCM6g3p0R/4z2WiO5RB8d+yp/M35TR7CcNQryP7AGd3W90riorE4KrtR
         YAUbyttQIbVzMSOSl6njNhujmrbYel19QJCVRf/n63I/vUlsrn5zrwB3LHnWF4d0ivff
         ldUJ8MFJd+qZmlerCs+7CyhKP9GCwN915N0WtyHfZQ1Yb03r02cY0BQs9S+JPSBWSrlW
         Xilw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790024235; x=1790629035;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=83+plyF4HOp6Tc6yDaOIUjOh/yxbiFagCuYc/tYX0qs=;
        b=gIDCFFu8kbC+zzTvKND42chupQgYTOwbcKIhjH0HwYcY7ANN6Zzlq24L+65MMkqAP8
         eMbE0fqO7zZVqOOvgQ0wAzbxOLSpw3Elqz4DDbl9Nc29xLKp8ghHHGFNIEWTyUNhCqzx
         uYLwwYU0O9Nkdx0mWc4WXUFQchb8091RQUh+JkLQdtDxtVwIT4PPWHU6tWVfTpTxSpVX
         cd4l/uacx/pl8bmX3fvOabAXiW/Ejfslvu6fCe5+IvBG/Zbg8wPh4wkH+dMdVm7no0RH
         rqfaoEWnvioG6VXfc4GegisIJ72gcW0XtTkmOu7+CO41FzHVWpT8TPInHnvtku2fbnMk
         pNLQ==
X-Forwarded-Encrypted: i=1; AKwUvBzFQDnDMX8z3HES8RTaF236o6pakoPqWEVQol4icVpdS+2aG6NDFVYQB9Xw1cUq1yieGmVu8QsGQkrfOh6dfvI=@vger.kernel.org
X-Gm-Message-State: AFuF++koT5DY6Nq3FO3GyL5j69Mu71QczTSvE6zJLWuUpLGR5OIE35Tg
	Y88z0GCtGBdnJQ4DvoqO6C0f9MP3MgvEDqE4N22g4EPRONN0uH4XrCXB
X-Gm-Gg: AYBFou3VURbN5wCtydQIIeOLVajC8IRY/pgU+gl9mfteiniGTTBm+VKDBrTY78B9FtU
	0wMyd6FpIemsEzzEwFUFTGfgbS/Qge/dh7EyceyxLAH5LFhX8HX6BoDB5JnEVgzGf6C1G84TqyF
	2O8TpeUXIW99wbpiEB1g0bSH8mHlJ04UM7vSmxH9uRfk2BQtuzR53/9lBJWTV0Zwn97BnXbdcXe
	jrVl1aKxtNueQItLfQcFEyBDvqwqP4jWC3pDDi3DaV/86cEukNuhaEMca8T4kxxX+3RigO9Gi/U
	vt+BkUomgpODyJMDinVdP6c1sIQPXSrlBQSHqVtmVaFKJFMywH2RTFUVvweqfJuI44z0SkQJvCx
	XY1Kt3svdjDs4y2Os6cBWX0AHRplhJU3o8ZUWT/ZT/v5WzQxzqAgwCoDexQD+Dt9nyKsNqo6EJS
	QrWiYOSu/NEN87hZYIwGVobaYQJuLG9ocS8rTREfcvSta0WMoxPNUNx58LAZyiar4=
X-Received: by 2002:a67:ef8e:0:b0:7aa:d0a9:c5aa with SMTP id ada2fe7eead31-7aad0a9c60dmr280100137.18.1790024234730;
        Mon, 21 Sep 2026 13:57:14 -0700 (PDT)
Received: from adriano ([190.215.95.120])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c9e591d496sm286884e0c.2.2026.09.21.13.57.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 13:57:14 -0700 (PDT)
From: Adriano Cordova <adrianox@gmail.com>
To: Simon Horman <horms@verge.net.au>,
	Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org,
	lvs-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 nf-next 1/3] ipvs: add flags for per-service secure TCP state table
Date: Mon, 21 Sep 2026 17:57:04 -0300
Message-ID: <20260921205706.1055288-2-adrianox@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260921205706.1055288-1-adrianox@gmail.com>
References: <20260921205706.1055288-1-adrianox@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add IP_VS_SVC_F_SECURE_TCP to mark a virtual service for the
DoS-hardened TCP connection state table, and
IP_VS_CONN_F_SECURE_TCP to carry that capability on a connection
so the TCP state machine can select the hardened table for it.

The service flag is 0x0100: bits 0x0008/0x0010/0x0020 are the
scheduler bits, so leave 0x0040/0x0080 free for schedulers.

Set IP_VS_CONN_F_SECURE_TCP on every connection bound to a
destination whose service carries IP_VS_SVC_F_SECURE_TCP.

Signed-off-by: Adriano Cordova <adrianox@gmail.com>
---
Changes in v2:
- Let IP_VS_SVC_F_SECURE_TCP be 0x0100, leaving 0x0040/0x0080 free for
  scheduler flags.
- Let IP_VS_CONN_F_SECURE_TCP be (1 << 17) and drop it from
  IP_VS_CONN_F_BACKUP_MASK.
- Set the flag in ip_vs_bind_dest() instead of at every ip_vs_conn_new()
  call site.

Changes in v3:
- Merge the uapi flag definition and the ip_vs_bind_dest() stamping into
  a single patch.

(no changes since v3)

 include/uapi/linux/ip_vs.h      | 2 ++
 net/netfilter/ipvs/ip_vs_conn.c | 4 ++++
 net/netfilter/ipvs/ip_vs_core.c | 3 +++
 3 files changed, 9 insertions(+)

diff --git a/include/uapi/linux/ip_vs.h b/include/uapi/linux/ip_vs.h
index 2c37c6ac7525..ade170109ff4 100644
--- a/include/uapi/linux/ip_vs.h
+++ b/include/uapi/linux/ip_vs.h
@@ -27,6 +27,7 @@
 
 #define IP_VS_SVC_F_SCHED_SH_FALLBACK	IP_VS_SVC_F_SCHED1 /* SH fallback */
 #define IP_VS_SVC_F_SCHED_SH_PORT	IP_VS_SVC_F_SCHED2 /* SH use port */
+#define IP_VS_SVC_F_SECURE_TCP	0x0100		/* use the hardened TCP table */
 
 /*
  *      IPVS sync daemon states
@@ -105,6 +106,7 @@
 
 /* Flags that are not sent to backup server start from bit 16 */
 #define IP_VS_CONN_F_NFCT	(1 << 16)	/* use netfilter conntrack */
+#define IP_VS_CONN_F_SECURE_TCP	(1 << 17)	/* use the hardened TCP table */
 
 /* Connection flags from destination that can be changed by user space */
 #define IP_VS_CONN_F_DEST_MASK (IP_VS_CONN_F_FWD_MASK | \
diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index 6fa3e1dc534c..0b465298b64b 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -1090,6 +1090,7 @@ ip_vs_bind_dest(struct ip_vs_conn *cp, struct ip_vs_dest *dest)
 {
 	unsigned int conn_flags;
 	__u32 flags;
+	struct ip_vs_service *svc;
 
 	/* if dest is NULL, then return directly */
 	if (!dest)
@@ -1102,6 +1103,9 @@ ip_vs_bind_dest(struct ip_vs_conn *cp, struct ip_vs_dest *dest)
 	if (cp->protocol != IPPROTO_UDP)
 		conn_flags &= ~IP_VS_CONN_F_ONE_PACKET;
 	flags = cp->flags;
+	svc = rcu_dereference(dest->svc);
+	if (svc && (svc->flags & IP_VS_SVC_F_SECURE_TCP))
+		flags |= IP_VS_CONN_F_SECURE_TCP;
 	/* Bind with the destination and its corresponding transmitter */
 	if (flags & IP_VS_CONN_F_SYNC) {
 		/* Synced conns are hashed, so they can not get this flag */
diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index ba0957798bad..aa8a3a964ffd 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -784,6 +784,9 @@ int ip_vs_leave(struct ip_vs_service *svc, struct sk_buff *skb,
 				      IP_VS_CONN_F_ONE_PACKET : 0;
 		union nf_inet_addr daddr = { .all = { 0, 0, 0, 0 } };
 
+		if (svc->flags & IP_VS_SVC_F_SECURE_TCP)
+			flags |= IP_VS_CONN_F_SECURE_TCP;
+
 		/* create a new connection entry */
 		IP_VS_DBG(6, "%s(): create a cache_bypass entry\n", __func__);
 		{
-- 
2.51.0

