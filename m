Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C651395AC0
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Sep 2026 03:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789614195; cv=none; b=X/Ptc4QCDJWaO7jHj5d5smfHeCq4Sao2/hLsMBgTdB4yyWxRhETTCm2kVEy30ZkXPH5ez66omjAnj8+NexmjUvpnBxRYBS71e6IDKlV0y/dfF4C9dQdT4GNj0t2VKqIeuZnrtxa3e99w4lLjzNkj6SjH//g3kcQYcX3B3WKTVwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789614195; c=relaxed/simple;
	bh=ZAnMJFfRyn/L7UjKQ6wtOpZX1ERwvLKzcxMf+sbJyxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D+SKahGNB3l98zSoIbc0V23hT3RxEWTeM6WP0PAm1mFsWbPGgukFqfcg12teDP6uiFCPEgd9dtclgUhMtQ2+VHpbgLnF8K2X5h/DIRWVKx/yRjyAmnkFmXpEtjceBB9UhvV7t2gXelWKJxA73SbZZpQcQUVSNIVj1uWdt9IxGzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=ko2XybKf; arc=none smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="ko2XybKf"
Received: by mail-pj2-f12.google.com with SMTP id d9443c01a7336-2d8fb334ddcso3248785ad.0
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Sep 2026 20:03:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1789614190; x=1790218990; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bEiJ73gdk+1H2UniqJzXdx9Ojg0hZPLKGrnSs4IPJHI=;
        b=ko2XybKf+ORIdYCZGisQEx+vJ90W4rwUFC+yt/UmDoIucUX3CJlNfEx/m0E5hYYiiF
         vE3yYs7g03ua78cYT/714tTFpd+T00ig3wnoE6+NSYH70jYFyeqF4rkzXytzfYUkJo8X
         /fG5dy0XxE4zFdIRt8GglWF89aeWyPpK14Q3aK/W3Veco3WmWhwDMNUeTWp+6QMiAcTS
         641xbiHUYWoe5ffuGxAMXfFsrRfR9G0qgGvuQGLLcfAjVSVy5lolL8J5Sp7nz/TXNseI
         FjlOW51EO+2GWMPwo0rKZm/mMldNTQC8TaZ77cPHBtGFvzAgu9NpMuaTsvD9nDj0S5/P
         LmsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789614190; x=1790218990;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=bEiJ73gdk+1H2UniqJzXdx9Ojg0hZPLKGrnSs4IPJHI=;
        b=f8xJMGKq2u7u3ZkMwIvtkUYNuU0mDwA8hbFzmEbLXczCVKJQjcTc8C7C6WEIj7v2kN
         pfLETwKloQ9d4+ImUytptjlEC8T5LmbcseDyA5VYk4WCyEdFoECAMsHGkyvjEGkZq1Wt
         pAH4h9txETm90c+d7q85/JHPQRJWLJWCJw2EzCQz+t50T7jGVw7BUMnduNVpOo4yIgq7
         dGLNGHlbu3jwIBSUt7hm+Uxv/PlRArQhtZHSbx+Foukh5DIM9OYIAMSNZR3p14w/Htun
         zp8BhDIws0p/sYG2Ng3q/8Hi/QBw+yZk7NERT/9V7+HsZgELA7gG1cb8rPTSN7Fouxg1
         pM5w==
X-Forwarded-Encrypted: i=1; AKwUvBz4GPvuLDz9egwENxCp1ikSqPJe+YJRBYoFyU6SpriTDs/RxV3ZDZampRxGrhBYnv/pBwBALPqpYSI7RNTWWk8=@vger.kernel.org
X-Gm-Message-State: AFuF++lhxJglS2hF46tMGoABO34LyyvmERUYSeHD4JoXZPpdopPoYHzL
	DInuWAIHx4vQGwSI5rBSEGD8rxCO77cGmdy1yZH9BUhkBk+4/uDGwi9LJ90i1X8sGuhf
X-Gm-Gg: AYBFou0dWEU14owLt5vAyZVXaALt5DjvZfdcIFTljAXI9o+Prj1uXhzRuD6TXhLtBKY
	l9JJIyHqygJg1OAera4AL+T3211bHX75o20p/wmGjouVRwvCemhiXE0r3ZeGrNRz7W6wnRNYyZ+
	dVzdItQscRr3LsiO+HO7mzKd7P9FOGrFpTaCh3MEEqQQA0dxvRVISy7jqOtUiW9dyuRGo8Z5JLy
	G8yUfaCMubRNZIQfNzRD/AZwu8Dr4PJSHTJPusjv9c3PcwaFeD9CNOPL778UO6NQ3oqPCU31Lnx
	nK6b6opHxHIgmlG5yo8D5CjRn3ncCXvzopi0jzkdL6r8GAOlhnAWOabNyiUYY7cRS75gmnlNeMi
	OGHg/bnVwbhw2Gb5f2OL47+IMnlJ9W6GABx18iaCMQ5/01fXN+gciYy/LUv+EuoHhsJqXw76SZX
	PgLQaQyX4aZaLwG8Ici4s56yBu5fRb+b31D5f3JAMG70p+yOnE6PIZY0vVqmyKn0520UflAglhW
	5ZGHayVFbMya+9ewaFIn/AEi/N7adZykGn7lhTQ
X-Received: by 2002:a17:902:ebc3:b0:2d7:107c:917b with SMTP id d9443c01a7336-2dd8ccaa304mr114450195ad.0.1789614190034;
        Wed, 16 Sep 2026 20:03:10 -0700 (PDT)
Received: from b6ad5085b32f.. ([122.51.212.64])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd89f1b862sm19167845ad.71.2026.09.16.20.03.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 20:03:09 -0700 (PDT)
From: Zihan Xi <zihanx@nebusec.ai>
To: Simon Horman <horms@verge.net.au>
Cc: Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org,
	lvs-devel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-kernel@vger.kernel.org,
	Zihan Xi <zihanx@nebusec.ai>
Subject: [PATCH net v2 2/2] ipvs: reject FTP control ports as data ports
Date: Thu, 17 Sep 2026 03:02:52 +0000
Message-ID: <20260917030301.5502-2-zihanx@nebusec.ai>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1789435989.git.zihanx@nebusec.ai>
References: <cover.1789435989.git.zihanx@nebusec.ai>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ip_vs_ftp_out() creates a wildcard data connection from the
server-advertised passive port. If that port is one of the configured FTP
control ports, ip_vs_conn_new() binds the FTP helper to the new connection
again. A subsequent wildcard lookup can then extend a controlled-connection
chain.

Reject zero and configured control ports before creating passive
connections. For active mode, reject a zero client port and a data port
derived from a configured control port.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: LLM
Co-developed-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
---
changes in v2:
  - Reject the data port derived from a configured control port in
    ip_vs_ftp_in() to cover the active-mode bypass.
  - v1 Link:
    https://lore.kernel.org/all/cover.1789110326.git.zihanx@nebusec.ai/

 net/netfilter/ipvs/ip_vs_ftp.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/net/netfilter/ipvs/ip_vs_ftp.c b/net/netfilter/ipvs/ip_vs_ftp.c
index 9e3e005a82635..4822a1a75212d 100644
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
2.43.0

