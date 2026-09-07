Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD09D448D14
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Sep 2026 09:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788774780; cv=none; b=MC3l0+D4Js2gEle43s89Iw8lo67TtqMd4ya8/4JjJ87Q3Sk9mmLTvdMQ4t4g0/Xl3+svk1j4K/T8VdTk+IUJaFOjiCke9ipaZEHq2134SgS+vxJ/UOqxtmKRDO8VGU2u7CZweGGQgdR/WBQFrvSEO/Za/Pdtx6AfpDog5CkOBL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788774780; c=relaxed/simple;
	bh=hBg3D/J/ocDdblowAKe4EaRsTJDtpQ8JcltIc+PaO7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sp8/wu4m9F+SBr+lrqzyaCofY6Qqr0lxmQUP9K88LEOQQBzLKzvoLa/zUSGYoRonQjKfF7/BNTI36CKTb1zsYdNpgP0BeCWaxoUse/ljLjqd/yX9INMIR8F1iHzXYHNMae9udqhot22SxzImvA/0Jr5Q/nkjfJ0opT9dpEemnk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ohjgjEDP; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ohjgjEDP"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-cc1cbb64a1fso3214716a12.1
        for <netfilter-devel@vger.kernel.org>; Mon, 07 Sep 2026 02:52:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788774778; x=1789379578; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TmSlKz9c4FGvbJaD9XV0mEk6m2YQk28BnycotBtjlRc=;
        b=ohjgjEDPyWVFXL/YvsUNNYQm3/kg9LXFVuhuqKsFDsQRn8vGwq8OKn8nLjYJSwgYU2
         AqBsIpi3EufW2MKZ+2s4mpF/ue56b/AohW/M1HCQMd8KDsm0mPLz5diUqbwLDuQYi23e
         ilVCH4bD3kOixD+jc55SD6HCuQVfhuX/+SbR522BaY3PinHCbN2JVzHHfKJk04xPGqCm
         aQ729ISMO3khxm1s29kj7hjKeTsXBZ6y9GVK66j59Oepl5ju9xSmNj5f7M1x9yhenmG/
         DwEhWwG9Jxc7PsdIN4Vkhr1JoJpfKohD5/qIY8HFpk8d2hTzLF3BwH4wDyf4C6bO2Axc
         RQfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788774778; x=1789379578;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=TmSlKz9c4FGvbJaD9XV0mEk6m2YQk28BnycotBtjlRc=;
        b=Bx9j/L1pAloWfv0N7poxTaN6lj85Cz9Sjxi4cKND7GosLAcC1aynHPWKqHqHf+osak
         HZgeK851fAAF7zl0otGcvZ0/wKGO29owoG6TYPg1OMT2y4LytTfXsQwWK3XP4b9ipgzP
         KykiHb/Rqog2tuIxmEji+NdyE8pwwTs5RFgIBieRI1N3V9LWbDPYyBoFrRb1Un8xJULR
         S18vkEfB4PNtwQdszfQWrnGQoIjy+hDlDJ0iTuXoAZdlpBtQBzN6exQbz8ongxhZamT0
         reLP+hJdg4I9cyqoPne9IwXYdKPTZksqm9yRb1+cyzJIFS7PvUUg8XtV/GKsWIzHnjIz
         PwXA==
X-Gm-Message-State: AFuF++l1wSfewnrtf9d7w7owmH1x1FvL4Zs0UfyDssWWXsj31NZXGICO
	XQJRRgHQMoxRovadH8o9IuQ2ESdZ42eJVSVWaD7hVReiUMtwPvq+JpAo
X-Gm-Gg: AYBFou0JZs4VGYh/XjPUDuzGq6wRhL9phTGjFg85DimXY7F8evGlI7nI8rPJC2muQZ2
	RjS6bCxWiRceqnYJ8nyC2DykeUw+PrRhFNuiIHhG7ONN+hDbLlLZ88kv46pB51leEne/Yjm3paH
	nhm7nu+MSsyWHnsQ8SwbHDdRADjkRRA+2JhHRCme3xoJ4jsbgqT3wOS/wlIe243IbAv6rN1ZkKj
	5fVT7h/7F6vzI39eplKMvrFy8s/IGKif0EfVlRAZj0a17K5zvlxBlb6yOk44aBiJh4HPKqdU0jX
	GHhU3NLuM8/LJEtTJJlC4FhZFEg9bhrQkAm7uudkBMiBf86YYeeraKjqaTy0CCRtLpjQHhiFglL
	LHK5Yq+Mc+7YS62L2JuY6w/YV/Y40fs3FDhiJHncAyx4MDhb3BvdXzEANVDN+UQfjoTRasIUwOa
	QDqZVc7EJ30YAt6aPYJUgSV4WY5L9da2RElJHkT3H2lyGjWAUUtKLwuVZr8MT2FDW1L+G/NWD8C
	T7sf8YIC5XHCQ==
X-Received: by 2002:a05:6a21:6f12:b0:3bf:49c8:f7b with SMTP id adf61e73a8af0-3da39fdfe0cmr33889558637.13.1788774778035;
        Mon, 07 Sep 2026 02:52:58 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14332405e92sm18924258c88.8.2026.09.07.02.52.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 02:52:57 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Shuah Khan <shuah@kernel.org>
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH nf-next v2 2/3] netfilter: ipset: fix typo "artifical" in comment
Date: Mon,  7 Sep 2026 15:22:40 +0530
Message-ID: <20260907095241.24441-3-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260907095241.24441-1-hemanth.selam@gmail.com>
References: <20260907095241.24441-1-hemanth.selam@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix a typo in comments, found with scripts/checkpatch.pl using the
misspelling list in scripts/spelling.txt. Only touches comments, no code
changes.

Assisted-by: Cursor:claude-opus-5
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
---

Notes:
    v2: designate the patch to nf-next and use a subject prefix naming the
    component, as maintainer-netdev.rst asks; v1 went out with a bare
    [PATCH] and a "net:" prefix. Rebased onto nf-next, diff unchanged.
    
    v1: https://lore.kernel.org/all/20260907064239.39910-1-hemanth.selam@gmail.com/

 net/netfilter/ipset/ip_set_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 0a86a170ba90..4aeb767088cf 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1426,7 +1426,7 @@ static int ip_set_swap(struct sk_buff *skb, const struct nfnl_info *info,
 		return -IPSET_ERR_EXIST_SETNAME2;
 
 	/* Features must not change.
-	 * Not an artifical restriction anymore, as we must prevent
+	 * Not an artificial restriction anymore, as we must prevent
 	 * possible loops created by swapping in setlist type of sets.
 	 */
 	if (!(from->type->features == to->type->features &&
