Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794532509;
	b=VMjUo3d4cQfTqEQ11gotdN0Uba2uFoPiGO0d/8a7WxarOLemBDFRubpl5skuQ0b7C95B
	 4mbSeAB/30/QD/fce68BiDw07zfZilrZ5DM/tRaCISCQjyswk/4aEdvCrcA1yeiIGlQga
	 ARvztZFZoZTtVdUUYkGwCzWFQQMZzbDSHKE4YMuBkx/91+CMIjOWlVMwW/0iINm+qEsG0
	 KvKsMAexCoMW+KygcvhNEdeyQOU6ixfT/nXHMrlQipjnB9unmZs3ZVh4vdISLgvNCBz64
	 7psn3MfWIMZKvLUZDEhp1KAlqQwXTraqQ3yV3CZ13utpvd87ZeK25cB4lY2UVy/vJUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794532509;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=JEPD8s17HilseeIGLyWmRryf5OeyuKuLuxwS1EhGQCs=;
	b=UuPZT3bYhravWTF3Wve1nsKOqW/TM6FjLRsRaKqK/P2ZJlJdTKAWDCj5WKOczoShqRvx
	 bKHjMkpsi4WymQUXEUhh+UWiUYpYxB96JCFPFeYcHGydFl637FB6v5vwJoXczvDeCsd64
	 ueK6CIt/1lpEtwuUz09381qoRDse54XJmCjdshrXXZRfbQ6oXZXCtLxKTBUj1dJp0L6l2
	 a3DY+Xdw9Tk7CarfPDmJCmMwFNzdIRHl8/VUhmFF29KEJ5paEfsADE6Qc+hzYNtItSOjw
	 +/c8bw2Bw2PVFtYzabIw7ZOQv8cPELgcurkNlfnCjfCpqt4YsDoexmA9PmQvLZeQ6lQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=blTOqEz5;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19613606A886;
	Fri, 13 Nov 2026 01:15:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 19613606A886
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=blTOqEz5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794532507;
	bh=JEPD8s17HilseeIGLyWmRryf5OeyuKuLuxwS1EhGQCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=blTOqEz5ApKlxiONpOw0vLCqshWykzTda8+zbqg50Zsl+BY+HPtpYx6lrgmih1xkC
	 scrCUCq3KRtIxRdlovqnpEobiKxzUFjNuplcXVvatcdM15W3WJNg4ybKxcNvbR2nVD
	 dOaIrzrgiWfEdO+Acb2sCcHoFAHub/YcE8s+SDsMkJ646WJ1MbSbcSN7g+ULRGa3RH
	 Orp3hB6Pp85KFwLq5tg1LHCRIQZqPaLo9umRNv0FPATC3aqVuGkVdiBcL51c4Gk7JH
	 cZjBh/ULVj6DE9qQJxvDg4bwH15ATSyG2BqnsViyiGFyHUsKi3EsSnIKCzPOH0CQBS
	 vCk1EworcxAEQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 1C8BE6005B;
	Fri, 13 Nov 2026 02:15:07 +0100 (CET)
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
Subject: [PATCH net 08/15] ipvs: update flags and seqs in backup server under lock
Date: Fri, 13 Nov 2026 02:14:40 +0100
Message-ID: <20261113011447.2357709-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261113011447.2357709-1-pablo@netfilter.org>
References: <20261113011447.2357709-1-pablo@netfilter.org>
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

