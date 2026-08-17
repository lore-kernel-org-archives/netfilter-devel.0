Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 706B440EB88
	for <netfilter-devel@vger.kernel.org>; Mon, 17 Aug 2026 12:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786969621; cv=none; b=aZjwJ76BbIJn5POi9RHx1tqPJ7AGMlqcqCGRndpPHmcWeuP132GAVWVUCNQI/pgV8123iehKHRr/8E9nWiT6e67asuD+QIQZlPhgxOoSP7jsLcBWmj1c61sTzfxg5g8kUMhR7vudsK7a3g0jsArl5MIroVGua6a5IwdEst9vnOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786969621; c=relaxed/simple;
	bh=vxeVfeW6zooT+9KX15Er2Iqr0q1ZzIzweWnGgdvaw2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hEkghoClIZYN7u//K6TXP5JO0VIJ8YSUinzQk3BcpHnr8vgWBWKTTRTD9A7VMv5qG101WKFn5TO6xV9YSiiqRquA3o5l3RgbOnLciIozZY+1oWUrz2WLW0NCkLXN+akXNrYFF05hy1Ig300n4AllTXJIsA/Fw291Hzd7xd1dFJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-84fa3b14ee1so2426382b3a.0
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Aug 2026 05:27:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786969620; x=1787574420;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/57BaLz+tLijcaeADmJoAOsj71IPp4lhVndhbF00yas=;
        b=rA2LY2ex3xhblO5TNfWUF6NN2k7IRJZHlySPzl1oVbk+gRkuFSv5tllSs/jiz6LijI
         Dxpatqqg6BtSPjNsMGsSWpyDpbJxTz9OOePnn6KTF9HjKuWY7f1w8Iyqub0pqvw61pCf
         tuEQsQcI0kFSE5ghf0laKEkYWYER+wv1QmVsPvDeu0cMgrHVolf4B7ouvtZ/9q0OXGxY
         hAPteTB+9koP92LzjLx59y87KRK1FbwRWECgRgSEDygDYiJ5zhtHUYDj1TFnMwIh+C4t
         gHDflBzwfxPeSa8qqHSeyuunl0z2PNhcw0pX6dSq0vzXAQq4kmymSQH62OuX74nSXDLE
         nEwA==
X-Gm-Message-State: AOJu0YwWXlytGYLMjoxHNSIJh4TI4ME0ve4o5kOeyYHaxUClW9YflPKT
	HWfPH7cpXba/gCV7YMldZQDy+fhTUpWcu7bwB1daB4osKrX+9whXRt4wiBQtuNU4GmhlGJ1acil
	iKmD88qEcMg42Xw==
X-Gm-Gg: AR+sD11K1E0/N427stoJ66RcSX/c560ZeTpQW12coVQbuiAb4x+ywgTjswLy82W6xFa
	a/HvPRp5UaGChdmd8vHaaHJlPTQxa859LMjq6SrBOoY2YWM7CXuSYhLbb0yVIhNfJJ4w1ZCdYru
	jXbwybc2daa4XpCMtAnDpub7cHVzkk63Kg0r1XxUnWJEuKpATHsb11SQTha8jLbS/3u9loIeo/4
	xqk09NOe3P4PolMbyYZdUobwKAurfHjxEIifSndpAC7SG+JUvK4OOHweXj2hfP9fppZSFgAfWf5
	VQrbaIOXPzjhFvma11oJ5/zoQUpEZ2ekU6Fom8RsQlN1kxvI1lICkhUhgugjh7xHQzsvRFwcZFw
	W2/yS8gwuaiU2PGZgtQwV8LUL4TkK/w6sGIs8wXpXVNAT0XoU4ie6ysQNZdXkqlUOXce2ot5Pdl
	06lSpqn7WHhPgrK0UvpUb9RWAEGh/ir9LoIi9s5bDOMi8y3XXcugiL86TzLhj8I2651pGqVbOe4
	UT6C1wP2c+GapbQZ5tQXIU=
X-Received: by 2002:a05:6a00:1149:b0:847:7ffd:ce35 with SMTP id d2e1a72fcca58-851b87eaa83mr298344b3a.8.1786969619658;
        Mon, 17 Aug 2026 05:26:59 -0700 (PDT)
Received: from Roxy.localdomain (n220246089185.netvigator.com. [220.246.89.185])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-851b407294fsm465580b3a.25.2026.08.17.05.26.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 05:26:58 -0700 (PDT)
From: Zhiling Zou zhilinz@nebusec.ai
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	horms@kernel.org,
	bazsi@balabit.hu,
	kaber@trash.net,
	hidden@balabit.hu,
	vega@nebusec.ai,
	zhilinz@nebusec.ai
Subject: [PATCH nf 1/1] netfilter: xt_TPROXY: require IPv6 protocol match
Date: Mon, 17 Aug 2026 20:26:37 +0800
Message-ID: <6ca536c61d358bfb1bdfd20aafe3cc16acfd45db.1786968834.git.zhilinz@nebusec.ai>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1786968834.git.zhilinz@nebusec.ai>
References: <cover.1786968834.git.zhilinz@nebusec.ai>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhiling Zou <zhilinz@nebusec.ai>

tproxy_tg6_check() verifies the protocol field value but does not
require IP6T_F_PROTO. A crafted ip6tables rule can set the field to
TCP or UDP while leaving the protocol matching flag clear.

ip6_packet_match() treats such a rule as protocol agnostic and can
invoke tproxy_tg6_v1() for ICMPv6. nf_tproxy_get_sock_v6() warns for
protocols other than TCP and UDP.

Reject rules without IP6T_F_PROTO so TPROXY is invoked only for the
protocols it supports.

Fixes: 6ad7889327a5e ("tproxy: added IPv6 support to the TPROXY target")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
---
 net/netfilter/xt_TPROXY.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/xt_TPROXY.c b/net/netfilter/xt_TPROXY.c
index 5f60e7298a1ea..13a94c9d06c0f 100644
--- a/net/netfilter/xt_TPROXY.c
+++ b/net/netfilter/xt_TPROXY.c
@@ -179,7 +179,8 @@ static int tproxy_tg6_check(const struct xt_tgchk_param *par)
 	if (err)
 		return err;
 
-	if ((i->proto == IPPROTO_TCP || i->proto == IPPROTO_UDP) &&
+	if ((i->flags & IP6T_F_PROTO) &&
+	    (i->proto == IPPROTO_TCP || i->proto == IPPROTO_UDP) &&
 	    !(i->invflags & IP6T_INV_PROTO))
 		return 0;
 
-- 
2.43.0

