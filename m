Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9057C12E1F0
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Apr 2024 14:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713279558; cv=none; b=Od4lv2Gwn9l8gXUDlE29QJxKW+HY2rXBH3vE9jmJmbkMtClQFu9XC2dMdM+Zkhdn2i+FcVAMgAVlsqdmI3woeobMLVM9gFhRekfMvgf/+DNWOQSYeVfX4decsll/QSTGZdS87syzp6HSZSkbTTmrdA286ptYovkfPe3di5vemoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713279558; c=relaxed/simple;
	bh=7lyToubjndBkFS/xjTwm6ZMyDvw4t6Soiztt3CZy43I=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=N1/XB3dHQAmb380mBZDZ3faLNxk8n/POzB3bGtREFTAWTsZ28QdlnwdKVpIdZkzWKBbO32vsDVRFOBIRZ0VxFSeulKO7hkoivA6Su2e+Y+KPmfTsH5Mr652bYjtOXYyNamW0t6zUxS/HOsOJiCH0bLoxUo4WjYH1R8zz4vHB6H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=bTNnjpIa; arc=none smtp.client-ip=185.125.188.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="bTNnjpIa"
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 8C5EB411EB
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Apr 2024 14:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1713278952;
	bh=SQh3gD+ToMzBSqvlRyRoPbaP+xTFtE8pqccMPR/X80o=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
	b=bTNnjpIaXCd5s6ImaVwHNR7OSVdldJr9ZXp9rizlLvN0oab5b/ipYE1rYNTdWZcki
	 sZiYr2Lria1r4Y3P94FTAa6fggkFwnfmoN2+KShG2m4/2STcSOG9IHkidpZ2O4Iug3
	 kZArQ6TkTQkayjwKRqUoNi3Be6Aip/zaV/5es6pil2Y+fW2rJVAJOEXUWZFbGIjFFD
	 ss2W4hgwqToocZT+FvWrvBkcKhYaAiN9S4dDRjGBw3n5gH65e4/4Gx67ThzOrQQTzA
	 Ew+p07TB13snTlofinejF86g628ukNRtOZL4zmzXpAuPav7cFQ31/HxJ2tgLFg/9pV
	 5oT28nwGfqUmg==
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a4e9ac44d37so271631866b.0
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Apr 2024 07:49:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713278952; x=1713883752;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SQh3gD+ToMzBSqvlRyRoPbaP+xTFtE8pqccMPR/X80o=;
        b=GdUUhML5Q4sJMAB50kdVqogX6Jk3OaKr0Gsl7Yd8D5qngMWjGyAyPz+bjYW9xDInO/
         88j1jDYAD+NZkjAq9RohDEs8uTh5DqbRLDspHQETec1th5j4umTsprncsT0X9qv2J2Eo
         HgFTbUC9KRCxYy4h+SbGcTywQHWo0AnPEK088bh/0IRWHRIwX32aMzBEWFI6A5RXU2kx
         goP9qJ5eNPLZrGljPfPi0pA18M6aOViRuh75i5XHPZMgKiT/Hk4ew39axaUuE42T2FXJ
         UK6Se4gpncQJcJjT2NXVN1EXlddCJwexyqToOXz9kpQKB97vW6gwGsmQ7FH2HZj8i21O
         Iubw==
X-Forwarded-Encrypted: i=1; AJvYcCWNMWFHdm76FZktfwIvZhxwj2hjRnP73EhVoq3DL9Iwrl1KOV2qniD1FH/XpBBJGUpFIR43EMLMiZCHzpxWu+fFoIMvaT8I0cF06EGKgFr2
X-Gm-Message-State: AOJu0YzAbaDWxmTGBmwEhz9npL9V/nxbHP5Twk3NGojzj5V9uv5aoqyt
	of9JWnwcl75UZ8GiJPTKovJGlezwGR450RmY84iYMolS9YJthzufZnpMO03jwKvC4h9ezvKThN3
	yP17DE881uaDbMPudJuFgPhpUD2sSm+oSYsVTHzTSD0TTbYJaWGkaYOgrQqCYw56ErobhtDCsof
	fE6681wRP9KWYTpA==
X-Received: by 2002:a17:906:4956:b0:a52:6a4b:c810 with SMTP id f22-20020a170906495600b00a526a4bc810mr3400657ejt.35.1713278951886;
        Tue, 16 Apr 2024 07:49:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEyz7nSFg/BkyuaXVLZ2ohQQZlKhJDri29PE7VWvk9uGXGz9gTCezlFmTExiTaW78zWQV6OQA==
X-Received: by 2002:a17:906:4956:b0:a52:6a4b:c810 with SMTP id f22-20020a170906495600b00a526a4bc810mr3400639ejt.35.1713278951519;
        Tue, 16 Apr 2024 07:49:11 -0700 (PDT)
Received: from amikhalitsyn.lan ([2001:470:6d:781:ef8b:47ab:e73a:9349])
        by smtp.gmail.com with ESMTPSA id gv15-20020a170906f10f00b00a517995c070sm6916856ejb.33.2024.04.16.07.49.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Apr 2024 07:49:11 -0700 (PDT)
From: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To: horms@verge.net.au
Cc: netdev@vger.kernel.org,
	lvs-devel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
	=?UTF-8?q?St=C3=A9phane=20Graber?= <stgraber@stgraber.org>,
	Christian Brauner <brauner@kernel.org>,
	Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next] ipvs: allow some sysctls in non-init user namespaces
Date: Tue, 16 Apr 2024 16:48:14 +0200
Message-Id: <20240416144814.173185-1-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Let's make all IPVS sysctls visible and RO even when
network namespace is owned by non-initial user namespace.

Let's make a few sysctls to be writable:
- conntrack
- conn_reuse_mode
- expire_nodest_conn
- expire_quiescent_template

I'm trying to be conservative with this to prevent
introducing any security issues in there. Maybe,
we can allow more sysctls to be writable, but let's
do this on-demand and when we see real use-case.

This list of sysctls was chosen because I can't
see any security risks allowing them and also
Kubernetes uses [2] these specific sysctls.

This patch is motivated by user request in the LXC
project [1].

[1] https://github.com/lxc/lxc/issues/4278
[2] https://github.com/kubernetes/kubernetes/blob/b722d017a34b300a2284b890448e5a605f21d01e/pkg/proxy/ipvs/proxier.go#L103

Cc: Stéphane Graber <stgraber@stgraber.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Julian Anastasov <ja@ssi.bg>
Cc: Simon Horman <horms@verge.net.au>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>
Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
---
 net/netfilter/ipvs/ip_vs_ctl.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 143a341bbc0a..92a818c2f783 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -4285,10 +4285,22 @@ static int __net_init ip_vs_control_net_init_sysctl(struct netns_ipvs *ipvs)
 		if (tbl == NULL)
 			return -ENOMEM;
 
-		/* Don't export sysctls to unprivileged users */
+		/* Let's show all sysctls in non-init user namespace-owned
+		 * net namespaces, but make them read-only.
+		 *
+		 * Allow only a few specific sysctls to be writable.
+		 */
 		if (net->user_ns != &init_user_ns) {
-			tbl[0].procname = NULL;
-			ctl_table_size = 0;
+			for (idx = 0; idx < ARRAY_SIZE(vs_vars); idx++) {
+				if (!tbl[idx].procname)
+					continue;
+
+				if (!((strcmp(tbl[idx].procname, "conntrack") == 0) ||
+				      (strcmp(tbl[idx].procname, "conn_reuse_mode") == 0) ||
+				      (strcmp(tbl[idx].procname, "expire_nodest_conn") == 0) ||
+				      (strcmp(tbl[idx].procname, "expire_quiescent_template") == 0)))
+					tbl[idx].mode = 0444;
+			}
 		}
 	} else
 		tbl = vs_vars;
-- 
2.34.1

