Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFE7E3FA5DE;
	Fri, 24 Apr 2026 19:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777057563; cv=none; b=giMwWQmkgo5Zzr9D13EqvuxbmPdZKhqmxxXD4+A4JAANQJUJeF2sN6JmRLsE5/KMGjl2ew+3jjmh9VLFFfcPucWVIrfTKqBojNKuJHNQScMuySN0WyEs2r6gN+dIuuB1Vzuh7srC8rasumfUrl+U0wluBksXObSwWiBSwrE1jDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777057563; c=relaxed/simple;
	bh=29wWlStnyCXeqDvHmB64rl/bAHBUlz5UggpdhR7TL0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ABp1x2mgBJpjtHqXyN9Oiv9jLlvn30IVbMRuoeCatXpYVjXPChCGoTt1qJ+RLR7tFeIynyIqxCjJNBLnoKt+WYqo5zJG2jW658NnvsmkQoYeqF2TxezNinKD93PsDUtYY6njahP3HQxoSJg3C5PnpUp5TZNksDBcp9a2Rrq7aBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=wLf7OWW6; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="wLf7OWW6"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id AF8A960289;
	Fri, 24 Apr 2026 21:05:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1777057558;
	bh=w5WjPpyUh/+YeCeHBR5uyrR2t2Uk2pwl5Ldk2Aq2JOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wLf7OWW6UAsp/eC+3h6Ay1wBrWt8kYMZ8RAM39nlbHWH2x8aWU42VMm7tYILlX/m0
	 FqExYz0JOPV3gGlpgHFY1DYsajfh36KEYX2+DHgCHhxGrxnPWemSzUVctCA9yJFtDe
	 A4I9nqYZUrvwGU6t6UTS/KA+YYZTWoeym5gRgw+aveIgW3WfcjJFN+1cMHfgcvVyf5
	 5Xwvd3pIuPqzj12++nt6TOiqfnRiCBwNAa04IvrxTAFX3w+8JdPahfzodsiZnabb/Y
	 0O6zPCPtjHsPyDq2UFNkETMrQBrJvw3EMoFCRmq8aJ4imtYG0z/oXsEwWC0TktYeKH
	 4ywJ2xQ5k6i/w==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 10/11] ipvs: fix races around the conn_lfactor and svc_lfactor sysctl vars
Date: Fri, 24 Apr 2026 21:05:12 +0200
Message-ID: <20260424190513.32823-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260424190513.32823-1-pablo@netfilter.org>
References: <20260424190513.32823-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Julian Anastasov <ja@ssi.bg>

Sashiko warns that the new sysctls vars can be changed
after the hash tables are destroyed and their respective
resizing works canceled, leading to mod_delayed_work()
being called for canceled works.

Solve this in different ways. conn_tab can be present even
without services and is destroyed only on netns exit, so use
disable_delayed_work_sync() to disable the work instead of
adding more synchronization mechanisms.

As for the svc_table, it is destroyed when the services
are deleted, so we must be sure that netns exit is not
called yet (the check for 'enable') and the work is
not canceled by checking all under same mutex lock.

Also, use WRITE_ONCE when updating the sysctl vars as we
already read them with READ_ONCE.

Link: https://sashiko.dev/#/patchset/20260410112352.23599-1-fw%40strlen.de
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_conn.c |  2 +-
 net/netfilter/ipvs/ip_vs_ctl.c  | 12 +++++++++---
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index 2082bfb2d93c..84a4921a7865 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -1835,7 +1835,7 @@ static void ip_vs_conn_flush(struct netns_ipvs *ipvs)
 
 	if (!rcu_dereference_protected(ipvs->conn_tab, 1))
 		return;
-	cancel_delayed_work_sync(&ipvs->conn_resize_work);
+	disable_delayed_work_sync(&ipvs->conn_resize_work);
 	if (!atomic_read(&ipvs->conn_count))
 		goto unreg;
 
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 27e50afe9a54..caec516856e9 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -2469,7 +2469,7 @@ static int ipvs_proc_conn_lfactor(const struct ctl_table *table, int write,
 		if (val < -8 || val > 8) {
 			ret = -EINVAL;
 		} else {
-			*valp = val;
+			WRITE_ONCE(*valp, val);
 			if (rcu_access_pointer(ipvs->conn_tab))
 				mod_delayed_work(system_unbound_wq,
 						 &ipvs->conn_resize_work, 0);
@@ -2496,10 +2496,16 @@ static int ipvs_proc_svc_lfactor(const struct ctl_table *table, int write,
 		if (val < -8 || val > 8) {
 			ret = -EINVAL;
 		} else {
-			*valp = val;
-			if (rcu_access_pointer(ipvs->svc_table))
+			mutex_lock(&ipvs->service_mutex);
+			WRITE_ONCE(*valp, val);
+			/* Make sure the services are present */
+			if (rcu_access_pointer(ipvs->svc_table) &&
+			    READ_ONCE(ipvs->enable) &&
+			    !test_bit(IP_VS_WORK_SVC_NORESIZE,
+				      &ipvs->work_flags))
 				mod_delayed_work(system_unbound_wq,
 						 &ipvs->svc_resize_work, 0);
+			mutex_unlock(&ipvs->service_mutex);
 		}
 	}
 	return ret;
-- 
2.47.3

