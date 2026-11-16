Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794789858;
	b=zaigJ8DJaSOqFwdNEzS2r/9azqQiNQRcc72W7GbYUGnV7Zcs6Uv4wtXFwlkSCZnvA5yk
	 w0VOey4yQwXrywbpIj2TEyRc6FIblqaq1du3LLFbRSilP5YjFsY18TDstsMcmxfKRVrZA
	 AmhNodPyE77nvW9YfP5zuVa6lnSe+kSwNlp52zGM0pTSkBRwWT9w+a2jQKXMePdm7Wt/N
	 SIvTCeHG7anhBsr/GhLtHyvmfISmBEKZUeOBauMlUreqNCzhNpk0hEe68Wh1aPRXlVG8b
	 UEuFrtjzEt+q/pdi8Yuy8vDVioKKlj1yHLigpaeReRtky4FOWJlA6IB+G9SdXLbXdAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794789858;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=L/mDYBLr21Zl+KzenQ/2+WneZOvu1su6eDvZBqxB/YQ=;
	b=cBcOJm8f77+QGaaIJh2FfAJS5a8HKci96YNjfkDM1UB1n9hFM2v7pOPpcjEpYNWJ0B4G
	 EFVVxm9fIB5EHFh1XMU/d2MCDofp/9r7i9sluQwxpCIDZnnXdkQ53Cn2H3fm4z5zP79uP
	 7uVXs4mMztPl6LOxGNG09oiW4TmraWDwWfpiASnSNv/RUS62tx4x5dh22kUP03PXgujEa
	 YedxP68kd4pFOthTt4NqeDiYx03hfB+cgInG8nZ0QT42ldCkmwejXBmK1Bgtt2MJYBYqg
	 EGlhOWV9Qssclevzj82PJUefOKrdOnH2dCPZvqv10rrRzTTJlFQ6OhPs+BFgIlyXEaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=q9DGE8zO;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E87606A887;
	Mon, 16 Nov 2026 00:44:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D9E87606A887
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=q9DGE8zO
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794789856;
	bh=L/mDYBLr21Zl+KzenQ/2+WneZOvu1su6eDvZBqxB/YQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q9DGE8zO4raa0Bq8gfOUay6B9XREVj852WvGZuQTHSJgw/W4V1ipXaR42c4R8dEPr
	 yCYBssBMBGoYBFvUKSBpQaRcBiZB5hMBtwFvGrQeBgcvHGJ8aO31VSZxNhGLpkVRFP
	 5kWk/6TTWaiJh321npjg7SFwZ3+PagCeEBc5bQItANu933KBTis20wfkYjXPMOFvmq
	 GFVZm2oQlmI8o6kGsvunuAokRAhKKcuKbJZXrvQnGparPQBqlkwDHgjlyuh6nVttSp
	 E7OqPrXVSKQLUizfor95CVWHxsm4LNUDAeUt8RMSMkkUkX349WW+CqvLDoOyfcn5hL
	 VnTWeoc1K3STA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 9DE386005B;
	Mon, 16 Nov 2026 01:44:15 +0100 (CET)
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
Subject: [PATCH net 03/11] ipvs: reject FTP control ports as data ports
Date: Mon, 16 Nov 2026 01:43:56 +0100
Message-ID: <20261116004404.2821183-4-pablo@netfilter.org>
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

From: Zihan Xi <zihanx@nebusec.ai>

The FTP helper must not treat a configured control port as a data port.
Accepting such a port can leave IPVS connections in a state that leads
to recursive expiration and kernel stack exhaustion.

Reject zero and configured control ports before creating passive data
connections. For active mode, reject a zero client port and a derived
data port that is itself a configured control port.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Co-developed-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_ftp.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/net/netfilter/ipvs/ip_vs_ftp.c b/net/netfilter/ipvs/ip_vs_ftp.c
index 9e3e005a8263..4822a1a75212 100644
--- a/net/netfilter/ipvs/ip_vs_ftp.c
+++ b/net/netfilter/ipvs/ip_vs_ftp.c
@@ -62,6 +62,17 @@ static unsigned short ports[IP_VS_APP_MAX_PORTS] = {21, 0};
 module_param_array(ports, ushort, &ports_count, 0444);
 MODULE_PARM_DESC(ports, "Ports to monitor for FTP control commands");
 
+static bool is_control_port(u16 port)
+{
+	unsigned int i;
+
+	for (i = 0; i < ports_count; i++) {
+		if (ports[i] == port)
+			return true;
+	}
+	return false;
+}
+
 
 static char *ip_vs_ftp_data_ptr(struct sk_buff *skb, struct ip_vs_iphdr *ipvsh)
 {
@@ -319,6 +330,10 @@ static int ip_vs_ftp_out(struct ip_vs_app *app, struct ip_vs_conn *cp,
 		return 1;
 	}
 
+	/* Do not redirect data to control ports */
+	if (!port || is_control_port(ntohs(port)))
+		return 0;
+
 	/* Now update or create a connection entry for it */
 	{
 		struct ip_vs_conn_param p;
@@ -529,6 +544,9 @@ static int ip_vs_ftp_in(struct ip_vs_app *app, struct ip_vs_conn *cp,
 		return 1;
 	}
 
+	if (!port || is_control_port(ntohs(cp->vport) - 1))
+		return 0;
+
 	/* Passive mode off */
 	cp->app_data = (void *) IP_VS_FTP_ACTIVE;
 
-- 
2.47.3

