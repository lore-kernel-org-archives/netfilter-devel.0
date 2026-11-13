Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794532505;
	b=plYY0D3Is6pnc6QgBaBm9zB37BJjIrTSvTdYD/tHil1jFnwHwfxhODBktTIURr7LGweK
	 W2ucDkgXN9fp7tVmcw9MPLANciqsJpSno6sz/ozLP81ANjv2Znh79z0BGrGggkn6HOt+I
	 LfKAqzUYuTuf4RoDZ/8tIjFY95FUwXXSMNaRQW9Ua66nfHK5zfNsKGRipueTOeKbV5P+O
	 ozQWBLX7oRq39XDF03mpsU5Nh5WjbULumXTnLhUJd49BBUvTr9F7KoOuaGC/1vHVo7NKH
	 Xh1UJuJGrRUhilO9CsWHMaC4y+yKH7UzVU6D6MnyLhzADKCdntl+OVL+d8RSQLX7KHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794532505;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=L/mDYBLr21Zl+KzenQ/2+WneZOvu1su6eDvZBqxB/YQ=;
	b=ta0gNY/Yk6HyYLnZCYFulQAsIoa+LbeVKzO9aqDJxpT4HAy/MeRvLYH1EEBPQ1fwBfxQ
	 N1SzGvOzLu1QsU3DolTqGKUFWuSNkA/nTLCbqzrZaN1g/ScLuSGqtynhNBKeOfmc2BsVO
	 4UJA4nYjf1naJDfVnBeXKDJDqlqHWbpnBT8GtVvLAJt6QQGZik1hE3XYtai9GbWqPgicq
	 CnT5T0rjyzucdNSgWC5/Y0eH1v4398/llKiPuzH+uny4ubI0aVDS2nBkVsm1f6/T5GR67
	 DmJ7TNSal8lrJXcK4MOGJJgEZC5G7StnFzwpjUkGWdKrL9LlWn7Be0jQ158dmUYDDMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=Ky0wmxXF;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20133606A899;
	Fri, 13 Nov 2026 01:15:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 20133606A899
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=Ky0wmxXF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794532503;
	bh=L/mDYBLr21Zl+KzenQ/2+WneZOvu1su6eDvZBqxB/YQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ky0wmxXFn7yFW79dZpI/uzvN5LUzu8s/xgAFt+2J/7XaQZeBlvtMA1N5bYEZooM/r
	 wfYBSyrQqeviqVkMNRXOa3bUw8DWLev/uIyoh4kIyw3O3qFN3mVxbW4uoN8NNXiQyl
	 YnCna9IvwwzYZrqW8bGeX/2TxD4EhyJEX9FpxSIt3oLKFsZj+bR7q8Jl3w40z8TCfr
	 K3D1fhIJ6RKW+V2a/1eBmPRMhk6W9Z8Ih6AzewGCvu8lbxRViUUkkHElbygX0dv5Jr
	 MDw61huX0nDwDh2GXFndSWgjAs///98P/49ayKevst8o91sadY8WXLAzS3GsNUM6a2
	 Dghbi5faT9Zpw==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id EE44060060;
	Fri, 13 Nov 2026 02:15:02 +0100 (CET)
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
Subject: [PATCH net 05/15] ipvs: reject FTP control ports as data ports
Date: Fri, 13 Nov 2026 02:14:37 +0100
Message-ID: <20261113011447.2357709-6-pablo@netfilter.org>
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

