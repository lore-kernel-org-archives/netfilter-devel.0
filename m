Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9857B3E49EB
	for <netfilter-devel@vger.kernel.org>; Sun, 20 Sep 2026 09:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789896720; cv=none; b=qhKrC1F2oanQWKAzhgy0PLEkyd9PNI5L15S3qbLQNwEYPrnBrrjklSOVQNZXfdBUEpzUFLWO3S4rUxEevGqiGnlbFkXOj/IEXYnoJunao7+aNOAntThuMYLemjdlv94sq8gyN0P0vmIk5bG56I+90YtDNO3j4ly3YNIGE+n9bcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789896720; c=relaxed/simple;
	bh=DFCad/hdE8IpyPcSDWClzGqWb3Q5eeOIEZMZ4lSwfH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O81qUxiS1VZ+DSZOBDnG/NFki01WepeI3ADv7YEaBMBfbKuAYUOS9BaMXDTRH999x8CTmhGHRDfpjsSydUYYEL77YjsjL7lqg00IR3Wo9NNQeNjjBwNdSibwz2ocYyJ/ROGQNh3LQLF3jdruZUj3iOFeJbjbDE+u9DpbElS3lx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=KJ0WEgBC; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="KJ0WEgBC"
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2d747eb79f6so12877815ad.0
        for <netfilter-devel@vger.kernel.org>; Sun, 20 Sep 2026 02:31:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1789896711; x=1790501511; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AC0BwwxocEHWdEgXzu191R0Fu2SszgpaG8S1TYD6ghM=;
        b=KJ0WEgBC7grVskxFMGrsIAnpCAfK43lh//UevXwE2M69FSD77hYrP934ZjNVXW2gEX
         M6DPtn/M9G/g4NobkBMQ5sEmDAS0wV7OTfCaFwCLBmvseOxw+qDw1Y9df1GxWFH7d1R6
         chKnrLkJYY0ICKhXcPtbQLYF22aSnjS2lFzXN9m1Y8okL1V27uf5WEf4msbOqIyPA3rF
         ZCt7upk+lqbhl2D5M6W92pwPaY8pLP3IUr5LM1oxMvgD4kNyWr8ihwoycfDuAMPxbqZj
         kxOVQkugBdLXtoiDj8q73d97s3t1DzhiAZl5UMVCEGcGPhA0b1Hex6N+1TFXxGduM6xE
         eUFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789896711; x=1790501511;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=AC0BwwxocEHWdEgXzu191R0Fu2SszgpaG8S1TYD6ghM=;
        b=iw59klr4ZizgRKk8IuYkuwBU3cXwubwbNrp6wt0bnBcpJg/DDKEHxcQ/WSoboyTPMI
         fVp4/ioIDD5eUbXjJiq0BWJ3Xl8P75k8GvoaQrSkRY9frwgMSh+/3FXjh8ywR1qBWLVS
         p3NTuFeypRTPFN/tNbZEfVDja3GAhqD85P7+4hnsFzbCBrmYp5U1DYpBzE3Bn0hsFIJT
         lQnVUfisvGBwWEpWgLiCYzOJzgGJZL21SLXeUkKZm1gq4ZNnqOKjTjMDr5Ni7R6k/2xt
         U0AcsuBHtayO3jadH475WG5uaSad3FpQFMaGZcqDEbNCl6GLQzjHdhBVrq657C5VhUrh
         fp+g==
X-Forwarded-Encrypted: i=1; AKwUvByZNsxFQIrlsGSoe9VR2ayZNQhAFM5GZzBc5b/nZjkYEG/6Sktkau2I8sDBQGRstJeviUQT4dpmw3PPWjGrieI=@vger.kernel.org
X-Gm-Message-State: AFuF++klT5W4BvYdJfoaBY1Ncyr4pYbTGc0Tg6SHW+OCkksrOcptp2dY
	YuPIQTQh6C/FdiWVQ/s5r+ieF2TQAaaZOZZ8TGNEr1AoIIiRwGwRMvqCNaSuMIGHLkk8
X-Gm-Gg: AYBFou1iu2PiZ9nbRsEpibKVC/c7DrLD5Ztv3UuwriSVIrKF1UDklv2Fthb2HmPAzwS
	/c6ChnrIJkzIGuEROhQLUhoiMVFtOQgf44x7sgAdFh5LNLIiZF1EsuWiyBxVoZU4tFgbvjAinun
	iIzEPiVWZEeKvq2oabGUiqiTe8qKTxDW+9WZ1ZcP3FcbPh7e2OQkiF97AtszpSSofVdMiNtmQM9
	owASPj/ZCLC0jjyUcjYQNjl3X480mYIsNzZcIhZiI8mHCQvprG8mk4ogG0fUnMxgf2o7BegiREQ
	48/HdIt7NZm0shlvMiY9BZKvdIM1rF+2GZZwtNjVgNzboH/Y5cg24a6sNWZ4j6MlT7QCTYFhRNc
	ngH2M6EJ2raNXoLQ4l2430vEBtb1GPH0CGVz9Vmtdxu4WvWh4h9bssQiUxHR6hcLNG13a4n9dUJ
	sSJ6HzSkaf/AnAPX+0R+GXujL0vclqZk2/MkSfk22TUZehER0UnEqgtVsS6l+pJOKkWOdoIKM3c
	2BCWhQlAir5tlHL8rWPV9NgkwVh/w==
X-Received: by 2002:a17:902:f705:b0:2dd:c053:82f0 with SMTP id d9443c01a7336-2ddc05383e5mr62215595ad.39.1789896711133;
        Sun, 20 Sep 2026 02:31:51 -0700 (PDT)
Received: from b6ad5085b32f.. ([122.51.212.64])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ddc17e17e0sm18435235ad.70.2026.09.20.02.31.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 02:31:49 -0700 (PDT)
From: Zihan Xi <zihanx@nebusec.ai>
To: Simon Horman <horms@verge.net.au>,
	Julian Anastasov <ja@ssi.bg>
Cc: Zihan Xi <zihanx@nebusec.ai>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	netdev@vger.kernel.org,
	lvs-devel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH nf v3 2/2] ipvs: reject FTP control ports as data ports
Date: Sun, 20 Sep 2026 09:31:20 +0000
Message-ID: <4f45973a22e67d5ad1c6f2e5455d8b057be60ae6.1789877273.git.zihanx@nebusec.ai>
In-Reply-To: <cover.1789877273.git.zihanx@nebusec.ai>
References: <cover.1789877273.git.zihanx@nebusec.ai>
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
changes in v3:
  - Resend this FTP helper fix with the generic cleanup fix as one nf
    series, as requested by the maintainer.
  - Keep the active-mode guard for configured FTP control ports.
  - v2 Link:
    https://lore.kernel.org/all/cover.1789435989.git.zihanx@nebusec.ai/
changes in v2:
  - Add the active-mode check for a data port derived from a configured
    control port.
  - v1 Link:
    https://lore.kernel.org/all/cover.1789110326.git.zihanx@nebusec.ai/

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
2.43.0

