Received: from mail-qv2-f12.google.com (mail-qv2-f12.google.com [74.125.230.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C9FC47DD77
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Sep 2026 14:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790345495; cv=none; b=bx1O8G6Y7vsu6OV74P1lcKBjrOose3/j902buGpEpGZyD0XG7Uk3gtsvMmiZsuPGMbg0lm0CJhxaxe+t6oxLXLSV/hd8M6tkzebstw6f29xBoNDnbN57/M24W0gd+dlnUcGvit6qI13aqCoyfqC9+Yx26rQy6vrGXoTJ+bzvDU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790345495; c=relaxed/simple;
	bh=BnuemxHse+a2/gGmYQjf5SbAdx7uvJn7RYhO3uV+Qmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TH9mxyskRQjNbNxXSMDeUQEffYemV/iqtvWQXz+SWVzAo0vZNeaJ63Jat0Ds0AQvHVuhOeI9lsrQiGNsJ6Wv7jIxZkT9DJf6wbgHSW3Noj560vMHGI8s9MNDhqedY/5wG7QmlDVgDu17SwjOw/jCRAum0rjp9SdsFi/jrBIYxQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=1password.com; spf=pass smtp.mailfrom=agilebits.com; dkim=pass (1024-bit key) header.d=1password.com header.i=@1password.com header.b=B92yiX1u; arc=none smtp.client-ip=74.125.230.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=1password.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=agilebits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=1password.com header.i=@1password.com header.b="B92yiX1u"
Received: by mail-qv2-f12.google.com with SMTP id 6a1803df08f44-90cdfc9b6eeso8874556d6.0
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Sep 2026 07:11:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1password.com; s=google; t=1790345492; x=1790950292; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=h/EePFAN2I0oSDWPKvqO/KiMg/JE8Drv0QT/R0nbfqc=;
        b=B92yiX1u+05EtCtx2AhCFuC8mP4bluVjTL5SEs+sQX308H47b5YOTJL1/9/jtMyAk7
         //lBF1cstwiOOYRgfrZsov950rU8wMWjyf/nEPfKbUBsAejWAxynyeMQ3/bc7Duax25i
         DyZis8JmqoQelvzaBWLPsNhGfyKlTUSzE2NWw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790345492; x=1790950292;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=h/EePFAN2I0oSDWPKvqO/KiMg/JE8Drv0QT/R0nbfqc=;
        b=qBA/N5pt5RYMHi04Mh2tX5sR655M813sPDmou/PNqoVkPuiFZnq64q4Nf74IrSPQ3L
         y9MKTwv7ykroNfM4VRwfMysembsKfblneqAiNixoZljbHyQqdqfNE35qzKW5YSWt56fb
         jevDOwnJpW9Nud5gWyI6fltW2GrKL+a9P7T7iZHKB+0cChrEvdIgq40vMngg0GBtvqRl
         EzX3lgX2oNuU1YKHgoet3Ih2MUpFZRMRAbXHJ5rH8NBFAGvUbWJU6yCpgTi3NEv6lznB
         J0H3+Oo+b8TgMsJAh+FTQKtZBeQ0OQLn0GUAvbSLrkffLwi6w80b5So8sAguVxSPwdP5
         8faA==
X-Forwarded-Encrypted: i=1; AKwUvBwlVrXDDaQyP0VGcGjb4X2n3gHuSwSO7lqdJd0jiI/k2eF6mpKiQWQ/aCNwYRaBr6ObynmH3LbyDfH5zsu/n0c=@vger.kernel.org
X-Gm-Message-State: AFuF++mf+eayuzNL3X++zfHF+5dEMw+P8Gj7BzZ8MW41N4QPWP++Pujm
	glh5Gz7tjKIwKNW3VAhMy/D1EnR0nfcxfIS8HMXngDx7+06ieqU5h4gsLZrn5bZ5Q5A=
X-Gm-Gg: AYBFou1SyrG0JMLHA1NRWVP0aul4DEHGGxZJ0egomodJWmJNX9kw6Z2H7/qF9YjOdP8
	cB31DNt8Azjmm43F3K5//K5li/MJS4rVom4C/gGR2RSleqhMoSXcjlKa6KH7vuq3b1Zx2bbd/mQ
	KUxig+d84Ih1jVJOiHHof3zO1ZL0u0Uu4pQGtidUvTXtVEY+0qy2iHfsZz+eRXBDHwaf5XqmBHI
	ds+F1N/gdpNEJfaSEaT067pwj6m3Yc2TG9OSw1AXahjemytKZA7whqPybptI472TFo1eNeSA2wh
	rI7EM72JIqDiD/N9o8jcIJRdI07Ar6zwJfi8iYqC00rzHtgHdCCwKRCk+uRcr2+/BRr0dUccQ0W
	dYpauceWtEEwyAz9+zvtqN19Vb47l1X/XVREEispXDcUligGIO10KT0tDApVpTSVMT5U2pUwimx
	lEqQXRh0tt0HhNFTraAkqWICO2xQ6DghjP7gVMM2vm2BezRY7/gUCtoHMUTvDddET5EeNPyXCTn
	NP7Ld/P8oNvjsvDfUmzroxWh8kJ9g==
X-Received: by 2002:a05:6214:3116:b0:90c:b843:d679 with SMTP id 6a1803df08f44-9142f8c7f44mr44499816d6.29.1790345491808;
        Fri, 25 Sep 2026 07:11:31 -0700 (PDT)
Received: from localhost ([2600:4041:59c3:300:7917:c7f6:28c6:182b])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9143f0cc9d3sm3637356d6.19.2026.09.25.07.11.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 07:11:31 -0700 (PDT)
From: Axel Mierczuk <axel.mierczuk@1password.com>
To: Julian Anastasov <ja@ssi.bg>,
	Simon Horman <horms@verge.net.au>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org,
	lvs-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	Willy Tarreau <w@1wt.eu>,
	Keith Hoodlet <keith.hoodlet@1password.com>,
	Axel Mierczuk <axel.mierczuk@1password.com>,
	stable@vger.kernel.org
Subject: [PATCH nf 1/2] ipvs: validate cport in received sync records
Date: Fri, 25 Sep 2026 10:11:14 -0400
Message-ID: <20260925141115.16126-2-axel.mierczuk@1password.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260925141115.16126-1-axel.mierczuk@1password.com>
References: <20260925141115.16126-1-axel.mierczuk@1password.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Local templates have cport 0 and IP_VS_CONN_F_NO_CPORT clear, so
ip_vs_conn_in_get() cannot match them. A template received over the
unauthenticated sync protocol with a nonzero cport can reach the
protocol state machine. Before template state validation, this
could cause out-of-bounds reads, crashes and kernel data leaks.

Ordinary records with cport 0 and IP_VS_CONN_F_NO_CPORT clear, or
with a nonzero cport and IP_VS_CONN_F_NO_CPORT set, create connections
that incoming lookups cannot match. The latter also keeps the
cport-zero fallback in ip_vs_conn_in_get() enabled.

Reject all three cases. Continue accepting ordinary connections
with cport 0 and IP_VS_CONN_F_NO_CPORT. The companion patch
"ipvs: filter some flags received in the backup server" rejects
template records carrying IP_VS_CONN_F_NO_CPORT.

Fixes: 87375ab47cd0 ("[IPVS]: ip_vs_ftp breaks connections using persistence")
Cc: stable@vger.kernel.org
Suggested-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Axel Mierczuk <axel.mierczuk@1password.com>
---
 net/netfilter/ipvs/ip_vs_sync.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
index 5383aeafb0ae..3998e9a0a391 100644
--- a/net/netfilter/ipvs/ip_vs_sync.c
+++ b/net/netfilter/ipvs/ip_vs_sync.c
@@ -848,6 +848,25 @@ static void ip_vs_proc_conn(struct netns_ipvs *ipvs, struct ip_vs_conn_param *pa
 	struct ip_vs_dest *dest;
 	struct ip_vs_conn *cp;
 
+	/* Templates require cport 0. Ordinary connections require
+	 * NO_CPORT exactly when cport is 0.
+	 */
+	if (flags & IP_VS_CONN_F_TEMPLATE) {
+		if (param->cport) {
+			IP_VS_DBG(2, "BACKUP, template with cport dropped\n");
+			kfree(param->pe_data);
+			return;
+		}
+	} else if (!param->cport && !(flags & IP_VS_CONN_F_NO_CPORT)) {
+		IP_VS_DBG(2, "BACKUP, conn without cport dropped\n");
+		kfree(param->pe_data);
+		return;
+	} else if (param->cport && (flags & IP_VS_CONN_F_NO_CPORT)) {
+		IP_VS_DBG(2, "BACKUP, conn with cport and NO_CPORT dropped\n");
+		kfree(param->pe_data);
+		return;
+	}
+
 	if (!(flags & IP_VS_CONN_F_TEMPLATE)) {
 		cp = ip_vs_conn_in_get(param);
 		if (cp && ((cp->dport != dport) ||
-- 
2.43.0

