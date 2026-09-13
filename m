Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A1A63859FC
	for <netfilter-devel@vger.kernel.org>; Sun, 13 Sep 2026 10:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789296176; cv=none; b=JrgYvneCkmJyvO1AIA0uNzUvsRBqOkkCSTvBnOdnp331XzR2NNMORuyj8RlznypEJcdg/HhNB5r9yyI82hv3XcpFdtO1xWqbCAUWOCPWGufiuOY+ajLumzrdkiNp96apy1OFmcrnhref2uPadjNmxCQCzERqnsG1VaF1DfjtQBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789296176; c=relaxed/simple;
	bh=fTfKStrClqR55tzhyaDyK+BD9gze8UiiG0g5UehBaTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SGhJ1EKQp0FW2FDqvCTSTwo914DA0hNNXDzwXWvPg5JOTtiIyNT02hsy+OJRsoBtbJWi53SjuhWY1AXRubYgl9zf9DvC1VnHM1btQZNB2wWRbZzOES7TrrhuDIHRhY0LgeildAh2oMUZenJ5yDrb4QlUr2iZSjeY45AtN///D4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=t2A/LOPq; arc=none smtp.client-ip=74.125.228.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="t2A/LOPq"
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c254f705536so304370866b.1
        for <netfilter-devel@vger.kernel.org>; Sun, 13 Sep 2026 03:42:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1789296173; x=1789900973; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9nM7ywUqdFcMRbh5STvNAn1ZHgHDbVHpRXhuS1Nnh+0=;
        b=t2A/LOPqsqLafjN3ufMn2iuoWl7TZ8gbsTMwB9L1YDETNnm4xl3u8XsS4DmxCz5g6D
         0q7pY08DSAKDRxOkfYIVK97w7pnIXSU9IZyqBYBlyXGCb43QhqhBeaegCLqCma1ojn60
         hO3BYignmgzppRiYD/eb1zH6YLJcb/Ha97zkqcLXsZ8Zvc4ATwTGi1AMxpGgJw82pq8H
         JAZy5GWUsCSQLHwXH0iL52zmtJgA4Fs9MohSjOdme380EqVVlhytI0SlWCDbzsK6vitJ
         J/gvTYKDprHFXn0Cxp/6jn7+ysE/xx/+SpjrGhs0gyClRe21kG1Lnpa02TMXcLbJfrTH
         bHfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789296173; x=1789900973;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9nM7ywUqdFcMRbh5STvNAn1ZHgHDbVHpRXhuS1Nnh+0=;
        b=CcrvM11KtwqYvsYuKE8i3C9Ez4HZZWMp11GZvz6/hWxZ2XCG7a33HJpTZa2r7LzZRR
         GiZLKA3cg/kBeC9P4cLczBvAIckTz8wbc1R1fhI6IBFATIl73shyxFdqpSWjY8IjQzEu
         fJDEVwt9lkamytFz81VKjGixW43u3PLQ/FFaOasEDvdKq3M0emFtwNYrkwonoFiv1KqK
         tNr2M8Ulp7PaYM+qDYhlhlI33JXaX3sCfEmA23aXyfpsuVdp+dcDYk7Gk64iXyUmeJDf
         myHICAGM57MWJsDJDfPWXo8TxzW/14iRbhtw5YstCAHMlH7Xi05exFw15uZyhEJf/eil
         dDuA==
X-Gm-Message-State: AFuF++ntXRF/reePCtx4wBHlaAEtRZvEQi0XnsUTu2ir1UYlSbkAAzsx
	ZKUWsNSJ8ozxgpj4svvd6mdOH5U1pJV8x22/iar5g5sMGGEXAvXqmCblcp7pS+VZY0GXV8o58mr
	Tp4aOEe9MAy1/vA==
X-Gm-Gg: AYBFou2LI2YztMwhyJ2gpboMsEvor8bYHuukm2189y60ltxpd0VDpLUZ9yO+EhJSiHw
	hzTLmVKTAw5BDkn8SfVP0958aPFhdKQYyn+uIRLx37wScvGTLl+45CBPWAtlqoEzQ0ccdFmtZOA
	VUP/lC3iHGMHRmJ6IpCfc96LpLustNYi5M6SeyVomSrQdbXHn6rId/Yc28giNx90u+hoL/jwWSe
	GiKWICabrTtF9HkIKyI7U/BaXY9em79NIGPZjk1ACYuq49tPf2Y1xAKOqGA1jWYyONZ2kYMWO7N
	piGcwzubIFzkK6HygFaxKU8YM5HNniv5jDrUtSCHSViBf0exSpPtYuZeqbWwlZQ10wqigyGGyTP
	6NSfIiRZ3bx6jX7QjRT4umMF0YPz8MjY5F5R8NB/dCsQtg4Uu3mCDKZynCBHfAdrRBqRW67zCAN
	JBSeRCF5Pdre6OS6ulA8Txpri4IIQ1rvD7wUPJ60pwYdgkacssQ+9g8cLj2uAuIVidlGlHVtsiM
	Tvyui6C7rDXosSKiH3spFZLAop3TmvfZ1WbQ0hJH8iFSJETK45np+I3oSDGMkgdEHKUDM7CYXPA
	MBKyF8lsb/ID9UWuLAfJ2qU989fWLV6LYsl8zeiQrEnjev9gj9/0rtzk1pH16aingGmWkZf1DxL
	tafwCkHp0Vlu4sjfceSBBQLEDDDDf3rRuO+6j5yXii/znKwhB6O8QcZ4LtZ0nUf3yprGg7VqIfS
	EmCeBS2WO/U2dl0ETuLeVEosw=
X-Received: by 2002:a17:906:4785:b0:c29:41c1:3779 with SMTP id a640c23a62f3a-c296654863amr641767066b.11.1789296173373;
        Sun, 13 Sep 2026 03:42:53 -0700 (PDT)
Received: from Desktop (p54aff833.dip0.t-ipconnect.de. [84.175.248.51])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c296605b438sm278678266b.26.2026.09.13.03.42.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Sep 2026 03:42:52 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	wenxu@ucloud.cn,
	saeedm@nvidia.com,
	tariqt@nvidia.com,
	mbloch@nvidia.com
Subject: [PATCH nf v2 1/2] netfilter: flowtable: fill the vlan key from the outermost tag only
Date: Sun, 13 Sep 2026 12:42:50 +0200
Message-ID: <20260913104251.648421-2-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260913104251.648421-1-julius@bairaktaris.de>
References: <20260906141947.480524-1-julius@bairaktaris.de>
 <20260913104251.648421-1-julius@bairaktaris.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The else branch of the second encapsulation block stores encap[1] in
the vlan key whenever the first block left it unfilled. The first
block skips encap[0] when the switch strips it, and also when it is
not 802.1Q. In the second case, an 802.1ad tag outside an 802.1Q tag,
encap[0] is still the first tag on the frame and the key describes
the inner tag as the outer one.

Store encap[1] in the vlan key only when encap[0] is stripped. The
802.1ad case then gets no vlan key, as a single 802.1ad tag does
today. The action list is unchanged.

Fixes: 3e1b0c168f6c ("netfilter: flowtable: add vlan match offload support")
Assisted-by: Claude:claude-fable-5-1
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
 net/netfilter/nf_flow_table_offload.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 801a3dd9ceea..19adc6c7725f 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -137,7 +137,7 @@ static int nf_flow_rule_match(struct nf_flow_match *match,
 			nf_flow_rule_vlan_match(&key->cvlan, &mask->cvlan,
 						tuple->encap[1].id,
 						tuple->encap[1].proto);
-		} else {
+		} else if (tuple->in_vlan_ingress & BIT(0)) {
 			NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_VLAN,
 					  vlan);
 			nf_flow_rule_vlan_match(&key->vlan, &mask->vlan,
-- 
2.53.0

