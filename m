Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EE9047D92B
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Sep 2026 09:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790157293; cv=none; b=SsVu2/ZMLHJ9TOISYt7792PzbF5G1MSz+hJcjJvjb5GOu/vKM1cblMyV9KBwzncAH/uT+zfjPou6GO8OTksslWDBmyAhC4/ZHnVDrWkE9vsVTWICSqGxPFdkMEiJoZbJfhWPTEoDy7+oV44QbNfBAe+3CWz+7p/oa0LR8EjP1+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790157293; c=relaxed/simple;
	bh=IUticTq4foak3yxsGQl2vQDiakNmvntsdMGpOFGsCD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N0bo28z5zh2+zH5Qr9y+uXuaCxlRmIhscY+DepGmZt4qPNGKCSf/oX8ZzhJkAOKYLBRjcXJy+fet1TdVWorVzXoKH+4kN8xdKpUzqSSc51kowoTqkUZjkulG2sHzC0wcWy04aJQiTbsVfY+1uYjBWH+he6DkDMu3Ev2qzqDNSdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=iisnueaK; arc=none smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="iisnueaK"
Received: by mail-pj2-f12.google.com with SMTP id d9443c01a7336-2d747eb79f6so3014965ad.0
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Sep 2026 02:54:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1790157288; x=1790762088; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aQDxycOIV80BPgrqxrzM7NANBApnebD30BToWezPxAI=;
        b=iisnueaKSaCz7CXaV8b7t8il/3RUHIYzy6lPx6TVpmG9za1rfF1/0Je4dT+5Ut8icn
         MDCQDiJ3nd2CFnN3rea8FYDjR42/I00+ZXLB+I0amPG2W87scf2m96JZ9n1w5+nFzJ0b
         toCVyg4+DOWleDkqmhccJAFWDdnsdfz1Lwl+eCsdJcFDzyLOoMDOeuuczfH/WNdxmsif
         j1PjijPDrKyO1I6DvULKYCDjVQF8BEhsvhXikiIkTqyGKxKYIdb1FaxQUZNBe3cahPGd
         N6n0b+rajCoH3tcNnrdxv4+9hju/Tz760jp7p/gGY1E++LswVcYcsYZEcIVyL4cIgvwY
         Myag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790157288; x=1790762088;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=aQDxycOIV80BPgrqxrzM7NANBApnebD30BToWezPxAI=;
        b=hV9loZJuc6or1WIoL1btiR80AyEYb/nMCngoTPQ0DTYpsMRRDGNdYUPopA3CwDZ9IT
         Okwp7ZqhAfyV7BJ3cxRsa48Uff4LiPjzVWj79mJIjIbRVPIRKowElXem4huWyaNtruV5
         far1Ox3PsdVMUaFQbTep2C1UAFZXIzDZfsZZYJwlVXoEJsdaZ7DJ5ewws7xAlNwHO1TM
         8MebD/fiVkJxansYkwJEWgSenlmr5GpYpjFd2XDOrnHU54ZVXq3UEQ0RS+lGDAC8I9KS
         jaIrPQ/d2WejRPfs4lp5quWlTAg6//X1oSn9orqs5UYeMLMuxbGOkCY+ZTiYD+sX33+u
         yMGA==
X-Gm-Message-State: AFuF++le7DVf1SGTXtqpRkD7T2+FjUuY4deSX5S9swx32oyIhSiMw25l
	BG/6iRN/4iMxUDzA6HuqOamqEfDaeNpTCXYuaqT7pFO5pO8jF+o+az28WY0g1/2SYaZzT1ZHQLC
	yWR0XvZFH
X-Gm-Gg: AYBFou0dWwyHEN3NrzawXuncPyslcqVPyYwS65947wIVB7Yr36gkRl8/4KSp2YxmsYs
	CmGTIh1Qfpess+W5fzpfrH6pCDVkgJiXzQEoPIP9qj1BhWHlmGdo1ggq5oPd2DZqhCCV0Yrp6SY
	pt+DpjJ7RCWx1x327t6l5z1OmVvm7dt5phS+dNU+IdYHH69FgQg8pXsKa0QaILg88dCu+3EHtmp
	Zsl/PO7o9sePOH3r2R0c983yWTfFZFnCysnK20Oj2GJIcijcANNWxhIznMCCinVpXOrIuoa6OF/
	LL+5bKX+r2YdlpbRfik8e/RPpJdlz9CPV+sB9SLc1M82HeiI0OzRMUuUcT1vKQnfr6isD+LMchN
	5MXbEQKu+sFr3KcW0jeNxcqG2I2er6BzBn8o1iRLRv/zQY51L9AW0cvoQZWAs6B2bfv4VNFLbf7
	1L2HfGaN9zxLMr/aTQsC9ktLkhApOkRi5c40shEXg9O/5nnaOGNG37APrVuiadjmEMPRy9hL0SI
	i3ZztnFQcwfJMp0z1rvr/C0x/ufOg==
X-Received: by 2002:a17:903:234e:b0:2dd:ad73:c983 with SMTP id d9443c01a7336-2df69d595f0mr17906435ad.27.1790157287897;
        Wed, 23 Sep 2026 02:54:47 -0700 (PDT)
Received: from 954df21a5119.. ([122.51.212.64])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a07dc5f3d7sm4793862a91.16.2026.09.23.02.54.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 02:54:47 -0700 (PDT)
From: Zihan Xi <zihanx@nebusec.ai>
To: netfilter-devel@vger.kernel.org
Cc: netdev@vger.kernel.org,
	lvs-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-kernel@vger.kernel.org,
	horms@verge.net.au,
	ja@ssi.bg,
	zihanx@nebusec.ai,
	pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	stable@vger.kernel.org,
	Vega <vega@nebusec.ai>,
	Luxing Yin <root@tr0jan.top>
Subject: [PATCH nf v4 3/3] ipvs: reject FTP control ports as data ports
Date: Wed, 23 Sep 2026 09:54:15 +0000
Message-ID: <b5c5a01607eabe55a6a5a27a9ed40a0ac8ec65fe.1790146910.git.zihanx@nebusec.ai>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1790146910.git.zihanx@nebusec.ai>
References: <cover.1790146910.git.zihanx@nebusec.ai>
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
changes in v4:
  - Resend the FTP helper fix as patch 3/3 with the generic cleanup fixes.
  - v3 Link:
    https://lore.kernel.org/all/cover.1789877273.git.zihanx@nebusec.ai/
changes in v3:
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

