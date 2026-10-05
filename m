Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A3B480DFF
	for <netfilter-devel@vger.kernel.org>; Mon,  5 Oct 2026 13:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791205648; cv=none; b=qSpIbQh60GzH7T1FvhHqGtibS+LnXIRXDWMRMK9adWQG58+7k+3lkvfbeVNoM4RZzayrYwL3+vuw+cHD9YiWUCeZWMjMOGwqg7/D1lwOdWPRdPWkAuiCMjdE5Ya3kOLU6O0GTm05UZswMlpE17OXpBSIsP+4faNMckM6SdEdSJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791205648; c=relaxed/simple;
	bh=XwySVB2S3K2fELeHfVKS7iWSBZyZjhy12mietMyqu/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tAjpQ9gJyjoGzC10wMvVSYhFJO8zqp08I+N8eZfO7TYzIoTCfWSDR0qwxbFBf3KW3PrtCmqgo7WCw3xE0dOXz1Pc5P78PcoXLaqv/X1XgudldeqgjrdnOL/vLl1Iz0qktQpGbuLSfW/4nYSi0aBFryTS6EpZuMd0b6axQTWiJkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=ii1GIl8q; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="ii1GIl8q"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-cc1bc88a20eso1154679a12.3
        for <netfilter-devel@vger.kernel.org>; Mon, 05 Oct 2026 06:07:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1791205645; x=1791810445; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fstljnTXcLzoaOLXPXcbSY/ujWVOIvCu8QU4eYxFWFk=;
        b=ii1GIl8qvQ8CwZ9uPhF8fy+JNQvxoNFjnIj23WpXc9rP15jgl7zQ6ImA4CpWglRYpz
         Lo7oyu6J+1GonoyW6T4LBfV18Nl1xjaRVD9p/IkhleL/cvXxJ8sVaWjK1iTXOYZ4Z8sD
         dA6g/DdJcQFv5zTsnrgvO5BNsf0+Q4+x4Z/TssuZpfWSxgZJa20Cl6gw6z80clYX/n4s
         vswLAZYJPlbn0UM9g1+gjARvrqk096qDMIyzmPOHIbWgCBQ1Juvog4ndPuePVYj705gB
         g9ZFXqc918/WoJQqZ6RWkZBNI2+0XEURWTIWpqwSYfN8bQed4Dkp7KROaBPYgVliLwzy
         TAYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791205645; x=1791810445;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=fstljnTXcLzoaOLXPXcbSY/ujWVOIvCu8QU4eYxFWFk=;
        b=xwH18sGtRwlwG/mJ6i2yyBvcw3ibF2X4DOrxDL9fzGVct443iKFtYOk/ZDw+B308hR
         Z9UpqYz38IBn8y2Y10yYwtR/58zrf9vBBSmU3yKAfxlrbQwfdMeGEOYqdST3hV6uXUjB
         K7lZTUGLDqSJKzApsex8VnG7CyBEmOtBNUk0hBCojcn5a/4oDSQM59DAWR5QssAXNFlA
         fwOkBGQmJFSkSoJPtayD8cEqZZjxZx7qqhFpwpxgBC8HllmN+8AmJs7f4ThkM/QCyldi
         p795DwkDoje4SyNciGd0UNkbJpno0ZXy0hPtDYyuZnQLVzBZkl9UD98xi+jW+vJJgT0/
         nsYg==
X-Forwarded-Encrypted: i=1; AKwUvByYl3pDYW9wZ+9+8gvKlBI5CVM4u/BsOGz5aFRwKDRuMi2zqSa6NaVmmk3wNjYnLzx1X+LmE+51KiGycM5go+0=@vger.kernel.org
X-Gm-Message-State: AFuF++lYFedXc4LqIASdQbDZB12DxCGq32yLuvf51eofYpMHTpT5vC4v
	XplXbw6oRnphZEqR1D7/jzL7ioRoALJKOXHjRSb+DiqEEGa9Lo6MS72dh80GDBUxvQ00
X-Gm-Gg: AYBFou0QXEecJvvxfk4lbggjlnd8klPBt4SPwCPFMqgxjTkFHboEIYfSG4X9vMUGexc
	5974WAAZa2R1EgWgjvNZ9ypKe9oyEXrSTe+kxzXQn41mLAwuE0yU4/yh0lvNsCs4wXlnDVj2pGN
	2IChrVR2HvBMMs0K8iZ+JvV0sgGO9gfTjAXzfAuQlUE9dzWMiNrXBOgg/A7gnaQwLk6yoQZPVhq
	TUpeeuFTK2hbgfbdZzPqrNIqSsqfr0a3HxznDfuH+B+MVsGgXJwEWdRMy3MHRYYVqDFT9B5Vzqh
	VL1l8ep8l21uD2B8mQkZzEXGzsG9czgwZVZvCBeGw8RjK0uOb4rwCuuCqYPlGxXo8FrDXUs3Z/Z
	RG6qboZAyBA1h/wSD0JeDkNjNPBPKGtLDlCotiT7KYECjbSJU/Ue6SIhNDk15s/w3jR+K9GHe73
	KjIzwsMYnFkwo747zfLape6i+IAEozZmRLA4P0w/0AtCjGIpHurEGS+GiIvMjlgS1fm2mKS13hm
	uLG/tsh3GOZlfWD4egXIhLSB+2cZkU=
X-Received: by 2002:a05:6a20:9386:b0:3de:7add:6551 with SMTP id adf61e73a8af0-3e0d6a963b2mr6944899637.16.1791205645347;
        Mon, 05 Oct 2026 06:07:25 -0700 (PDT)
Received: from 954df21a5119.. ([122.51.212.64])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cce6d334dd6sm785236a12.9.2026.10.05.06.07.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2026 06:07:24 -0700 (PDT)
From: Zihan Xi <zihanx@nebusec.ai>
To: lvs-devel@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: dsahern@kernel.org,
	idosch@nvidia.com,
	horms@verge.net.au,
	ja@ssi.bg,
	davem@davemloft.net,
	edumazet@kernel.org,
	pabeni@redhat.com,
	pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	vega@nebusec.ai,
	root@tr0jan.top,
	zihanx@nebusec.ai
Subject: [PATCH nf v6 3/3] ipvs: reject FTP control ports as data ports
Date: Mon,  5 Oct 2026 13:06:19 +0000
Message-ID: <812b6ab08e637138e341ace36bcae6aa072bf6b0.1791194172.git.zihanx@nebusec.ai>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1791194172.git.zihanx@nebusec.ai>
References: <cover.1791194172.git.zihanx@nebusec.ai>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The FTP helper must not treat a configured control port as a data port.
Accepting such a port can leave IPVS connections in a state that leads
to recursive expiration and kernel stack exhaustion.

Reject zero and configured control ports before creating passive data
connections. For active mode, reject a zero client port and a derived
data port that is itself a configured control port.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: LLM
Co-developed-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
---
changes in v6:
  - Summarize the FTP failure mechanism in the commit message.
  - Correct the cover commands to invoke the shell-script PoCs.
changes in v5:
  - Resend the FTP helper checks as patch 3/3 after the deletion fixes.
  - v4 Link: https://lore.kernel.org/all/cover.1790146910.git.zihanx@nebusec.ai/
changes in v4:
  - Add the active-mode guard for configured FTP control ports.
  - v3 Link: https://lore.kernel.org/all/cover.1789877273.git.zihanx@nebusec.ai/
changes in v3:
  - Add the active-mode guard for configured FTP control ports.
  - v2 Link: https://lore.kernel.org/all/cover.1789435989.git.zihanx@nebusec.ai/
changes in v2:
  - Add the passive FTP checks for zero and configured control ports.
  - v1 Link: https://lore.kernel.org/all/cover.1789110326.git.zihanx@nebusec.ai/
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

