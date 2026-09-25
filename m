Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 889493911A8
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Sep 2026 16:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790354509; cv=none; b=QkriiIABfKhWpTph409lLM0oH0jPXMfX4fwU5i+gp2cjvpqAm+tE7CsyGMvsFfRLhBbjmXgl/UzgEPLc/mq9fzXBsJpUmcJqdRSZi1uf45sEKzxG9kWNYC4gDm7x7tDAW0x8l/KjjGR2B1BzUn9TS6l8lkq4SJ0aJ/WCysQjYyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790354509; c=relaxed/simple;
	bh=TtrcUjfhGxN+/Il9E+zFlb127nCYs18NSgDSKBIiHpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sCUMsB6rJMUAfriYfgL0+Dv73epxXwa7sSGkpNSivcrPNEfmYapFwqy52yZFRlboJCPMAEtusTaUzbUWOE3L849WC2lgYqsaMpdJUmPkOJxOhobIT2a17B3w45FTqiBwFFAOS7P6bH2soFnNOupLBJ4lkSGPmkSUSZULpkdRUxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=iJ+EAK6T; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="iJ+EAK6T"
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2dd4b43b20bso4764185ad.1
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Sep 2026 09:41:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1790354483; x=1790959283; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6hQQWvTzGmogv0EMa2VjHO6aB1rZOWzNyIYZn2ueb1k=;
        b=iJ+EAK6Tjdequ3S+h5hPGfQbsMqbmfJT7FDq2pnWNrnK23ZhbpKwx4DqzclvIKVMqn
         ZyBZeXIv9FLiqzYu3OU+jlbwubQsqJHZxpGNwvvgFosXIVdLqZM1Hg+PTv/GQvjE2nI1
         odhYpfnranEYpmHuVqgZK1CaS5EASEtI2/9XiZSccNfrW85cWD0fosvQjOXi7os0kN71
         wMTogkmpcKCh21LaVCYmbCowjf6uU+k0+0ZbCntlgAbGuCbbFZDlOGCjzGFEALkjyzYx
         EWZ7QUQFRLi+yx+aIB/xOZgKMXzK5bSxRfowsV77jopGTtE0+AKUg4nnvbf8qNBZ0Yll
         M9+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790354483; x=1790959283;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6hQQWvTzGmogv0EMa2VjHO6aB1rZOWzNyIYZn2ueb1k=;
        b=MDtc+CWW9+JA1O43ZzohuS5mgiiZnV0d5lH2rK4Dzm+aXVB9DBAGVbzn6dEgtsJMnS
         QluaTH9H/WaX5O3ZHtOLV4XjgbdkgUHuzttv1hG+ijrMY3Zwul+0zRIHcelJiap5FCSr
         /Uvp85SLsNwKKlQe8Qjgzs6JeoC9I1Zm+Qjo6CNO0KuPK5DH5eo4KRiuIvy9VwrSdzZg
         XpTDBdfthyMT5T3ung06ktZzRSdm0wLecR8eX2m4cq+C2rS4J0DWwQxbFS0StnzDqrGk
         NAuf0tT5kRqnFYo49ExIQ9Eg56BnzxU78dk8KALHYHt2YstP3boxL49zmA1IyHqIGXYB
         JdVQ==
X-Forwarded-Encrypted: i=1; AKwUvBzFfg1kW19I5QH10lfySedcdF+TjAZzJj/KS+P5vtMRXsX2pqfWwkXUZX14GR2W29FiAybiudDjfp8fzZ2oSfM=@vger.kernel.org
X-Gm-Message-State: AFuF++kNUicpp0WO48CUZZCreNiWYtWSB9nleeIsANSRlXIGuxIDRgrt
	cIlXKOUkK/8SAqIswHctzBWS1ldIbFyBBOw5/OXV7fB/ZQgN6Wkxliu+pzXUQ3+dgRAC
X-Gm-Gg: AYBFou0sfLjpTHKuNIQ2IXFvZjzR+ThUEIl+PvgnfGJFYTLEi8gSWYlTLJ9NzX2VY+S
	EdXPNB9UXKxOYNWGULE3T/Fo5NC3v8Ufvvxbx4eU/0Cq6FIuZO1CUXn4KcGnXMoBpC+z9PSNYaU
	rTMGiAsmSeMSTB1bv8DhogFGTQDi6OE0riQyX/fHN6DFZ8veQJKz7IE4YXeadZDTEyWcX9oNM93
	r6rny/g65Yc2wF8rBZczn+1dtv5u8LlA5U9JIEaM4aAdcn0ju2Af4t4igYowy0MqQ2kyV+nt9S+
	ft8NOnmg2zJh1J574tgbzC38+LiAeKqB9zD2RARIBHgw8L+HfOEalM7Nut/4mVe47uQ7wMfQcSV
	AAqYfVOnvJkcUXV81GCk61BDGD392ZFDLd9AwGtlprgj/XRddWWsl8yBmLCmV5GTtQ7aKVFzTen
	kIX6CoUwkQtcp4NohwmmTBvU9gCL3ihIh1116g0/MaqZL+deQZK4Hi+x699QGrA1Tut2JTTB7Uj
	5U0NtC4D3PNxtI3/dZ8EMntaVR9//tMjVaKJXoj
X-Received: by 2002:a17:903:1447:b0:2dd:c053:ec73 with SMTP id d9443c01a7336-2df7e11ad13mr46713485ad.38.1790354482412;
        Fri, 25 Sep 2026 09:41:22 -0700 (PDT)
Received: from 954df21a5119.. ([122.51.212.64])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df9146edb4sm13855275ad.81.2026.09.25.09.41.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 09:41:21 -0700 (PDT)
From: Zihan Xi <zihanx@nebusec.ai>
To: netdev@vger.kernel.org,
	lvs-devel@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: horms@verge.net.au,
	ja@ssi.bg,
	pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	zihanx@nebusec.ai,
	stable@vger.kernel.org,
	Vega <vega@nebusec.ai>,
	Luxing Yin <root@tr0jan.top>
Subject: [PATCH nf v5 3/3] ipvs: reject FTP control ports as data ports
Date: Fri, 25 Sep 2026 16:40:48 +0000
Message-ID: <a1fcb8b49e266e1cac9cce78498842167ae0f2a3.1790266803.git.zihanx@nebusec.ai>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1790266803.git.zihanx@nebusec.ai>
References: <cover.1790266803.git.zihanx@nebusec.ai>
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
changes in v5:
  - Rebase this patch on Julian Anastasov's v3 timer-callback fix.
  - v4 Link: https://lore.kernel.org/all/cover.1790146910.git.zihanx@nebusec.ai/
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

