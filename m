Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794789861;
	b=ZV1WJq5dG7elLbZof4E27gupryJ7xCyhnwCqfcY8mCELYH2cMTce6kEnvVl5uLr3hh6H
	 1Woeg/VM2mrawxWW7Lw7QGgm+idTW5lj+RIuc97VZhK4DllIT0A1doEU7SnEWrCe2ULg+
	 /nND39kyP9vpWIDZMIcPE21049cLIRmJ1OmLuTHPTfnqAZ3pJ91JI5/ZKsLrqJ+fkWmhS
	 TgBGUAm5DoFIlCJSYdxZQnNa3iJDBdDdUYYSkYKSWWjqjjsRP9jwHbixGnZV+rogwilc4
	 wnlxZGI5WZ2jYhfWSQKRYrR7sxC8GjyADt3KVrq8UYhzdsBzxOePN1JHsKRHoq0hZUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794789861;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=JEPD8s17HilseeIGLyWmRryf5OeyuKuLuxwS1EhGQCs=;
	b=0RZ+BGQ51XHqZI3wO0tecjVWQQPGtrqTcMQ7z8ffj6TyLmx7xSHuH0qzV5JBoBrM6n8h
	 62jflZRcNMO/y2bk8MYyWRR+fSbD9B1RcJdd0fwKEJA8UioeO54LV7JyuW01a8Il7z30e
	 KBIqBWlz12icrEYlodn8kX1TCAfBzUfhNjC1+RNxd9hkoF1fZuzLmE9YsEGM77c4Cvv8C
	 tdFoFciy1wle6IX22tn+QqMcGtFyO4l7bJYu27C4DglbaMH935MK5ia4+uaXDogEzuGs3
	 8/0k5HwKr9mGRJxBWQBrSorwizo/sLS1Pckf4SZyKwYvzZeRh6i0PXXqH6jSUJYOEBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=QQ3I8+lY;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D67B606A8A4;
	Mon, 16 Nov 2026 00:44:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0D67B606A8A4
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=QQ3I8+lY
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794789859;
	bh=JEPD8s17HilseeIGLyWmRryf5OeyuKuLuxwS1EhGQCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QQ3I8+lYALhWYt+MRJ6Yd29fGve3G1ePlSJpVr9XNKt5aHo/tyXEKE3OIEYVhoPIl
	 QjkFoSW4jQJR3L1+A46GAQVd1kaRGGLWF8kLE/ef2JNqLzTGeN2Vw4ZA0WMmm9dQ1L
	 62RDj/fWzRhwsnKLZn9YvpT8eJgh7Ilr5nSJulCojNfOwlQ5KAl4BgFC+PKj/mhGM7
	 0FNB1G5uFkOlNlq60vWT3+eADorkp7RRGb/QPxiR2HEbsAbz6D2CjQE5yxb3+UTPCR
	 y4Ekp8+d5C0w65AJWH1eUfOA5YMbvVBcteaQ6hqTvgzNoRB3gdPqeR1UzUBNh+i3JC
	 Z8avndnYquSbA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 741D36005F;
	Mon, 16 Nov 2026 01:44:18 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@kernel.org,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 05/11] ipvs: update flags and seqs in backup server under lock
Date: Mon, 16 Nov 2026 01:43:58 +0100
Message-ID: <20261116004404.2821183-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261116004404.2821183-1-pablo@netfilter.org>
References: <20261116004404.2821183-1-pablo@netfilter.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Julian Anastasov <ja@ssi.bg>

Sashiko reports that we modify the conn flags and seq values in
the backup server without holding cp->lock. The same is true for
other fields such as state, old_state and timeout which are
modified by protocols under lock.

Extend the locked region in ip_vs_proc_conn() to update the
fields atomically.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Link: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260927220816.268206-1-pablo%40netfilter.org
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_sync.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
index 1caacf419af9..ba2fa1f9d08e 100644
--- a/net/netfilter/ipvs/ip_vs_sync.c
+++ b/net/netfilter/ipvs/ip_vs_sync.c
@@ -850,6 +850,7 @@ static void ip_vs_proc_conn(struct netns_ipvs *ipvs, struct ip_vs_conn_param *pa
 			    unsigned long timeout, __u32 fwmark,
 			    struct ip_vs_sync_conn_options *opt)
 {
+	struct ip_vs_conn *cp_new = NULL;
 	struct ip_vs_dest *dest;
 	struct ip_vs_conn *cp;
 
@@ -891,9 +892,6 @@ static void ip_vs_proc_conn(struct netns_ipvs *ipvs, struct ip_vs_conn_param *pa
 		flags &= IP_VS_CONN_F_BACKUP_UPD_MASK;
 		flags |= cp->flags & ~IP_VS_CONN_F_BACKUP_UPD_MASK;
 		cp->flags = flags;
-		spin_unlock_bh(&cp->lock);
-		if (!dest)
-			ip_vs_try_bind_dest(cp);
 	} else {
 		/*
 		 * Find the appropriate destination for the connection.
@@ -920,6 +918,8 @@ static void ip_vs_proc_conn(struct netns_ipvs *ipvs, struct ip_vs_conn_param *pa
 		}
 		if (!(flags & IP_VS_CONN_F_TEMPLATE))
 			kfree(param->pe_data);
+		cp_new = cp;
+		spin_lock_bh(&cp->lock);
 	}
 
 	if (opt) {
@@ -951,6 +951,9 @@ static void ip_vs_proc_conn(struct netns_ipvs *ipvs, struct ip_vs_conn_param *pa
 		else
 			cp->timeout = (3*60*HZ);
 	}
+	spin_unlock_bh(&cp->lock);
+	if (!dest && !cp_new)
+		ip_vs_try_bind_dest(cp);
 	ip_vs_conn_put(cp);
 }
 
-- 
2.47.3

