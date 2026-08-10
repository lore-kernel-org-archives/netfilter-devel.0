Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35BCF282F0C
	for <netfilter-devel@vger.kernel.org>; Mon, 10 Aug 2026 22:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786400195; cv=none; b=tDKRAALCPgUnUi6gg8gMbAUJjLBYulwBYp/gxrQz/FO0PnvORIJbl1HCR8Ta2TBtAjx1vTChhTJuIwA6Yl3xHjRGmBIIIq6URiaD8nDreM7dF+NQRYORLUXyZcRPQ2PFozlpH7Sne+AhDFOvzcgP0bXWtAYazCPYdfTyweyoTRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786400195; c=relaxed/simple;
	bh=uYxhiZqGm8FNfk3nEbeKBpAuZF64uazG6DvZD8QGX/U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gA0JCEY7fYJwQ0pvoFViYz2LgEx4rt7LnouZuZd45FVhwdIDMNZ6IEID1Nds6CnI/n6073IiKkJdT9RNXqIlRp4HY2YrHhD7g+AG0lB3rI/DAnSbMGdg6+dwE+JNA4KBgD352Cjkwax5Ill/AgbkAsVNGgG3R3izQr4V90HyOkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=openai.com; spf=pass smtp.mailfrom=openai.com; dkim=pass (1024-bit key) header.d=openai.com header.i=@openai.com header.b=bcQNgfwm; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=openai.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=openai.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=openai.com header.i=@openai.com header.b="bcQNgfwm"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2cfbbdfa60bso21177045ad.3
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Aug 2026 15:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openai.com; s=google; t=1786400193; x=1787004993; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=mT7jUmlNFDrp1iX8E1gn1RaOCxcycH+YHLaaoGQkKZc=;
        b=bcQNgfwmlpPpapt40RmbCEbsvsJ132cpQhA2jJIm7XAx0TcPor7fm8AC7FoiHqGxR5
         XRk+q3O95LCEDpU49LCOa8AaRIjms2pxXTUnuXETGD7rNf9ZMYZbg9MgAg356/HJOxck
         VWnWHaZFvk6gXgfWtgNgqtJmUoNyPk4XpgTBg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786400193; x=1787004993;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mT7jUmlNFDrp1iX8E1gn1RaOCxcycH+YHLaaoGQkKZc=;
        b=UnnEmm5oGH0K87Q1ByUZPxtUC5ANYsdlFvJCFkxYirnu2Zug8wN7g90oYQfLbfMVfn
         J+3YIY6koUgjuo2NzdWDStaN0oEzNbe8Dg86E2woz49/ZPT39oaxvoSsHDlWmupA2gwo
         XGhR3PMMzWe/8+LtdNf5RJmiuXSQlRCw1WS0xChJ+0fbDey8eIW690dy4kGS9sLMJzpf
         JP9AGlpbkk5yuSx+tV5e/UlF2fi0ERHGcCd4b71UroR9ChBpLfDuy2yPNgx4vU58/2m0
         tY8K9js3a/+7CMQxYxJ/vaYcT1YddD3/vOjJdea26QwJLDKl1jsiPGNE6Blbfrh8fckS
         YAfA==
X-Gm-Message-State: AOJu0YwB69fEHAu0XOmHfuwLoXecU500riTQ8iaJc0jmiCHs1RUnX35I
	kP9geyQDgysTvH656CDOdCjyprJk5QbaicsRWkDcbR5nvjuqwz0rSdBuBwLuoQbFUtUYj6xsesh
	FFCMC+gOMaw==
X-Gm-Gg: AR+sD102AyR2Q7Tx6N79Ez83/pik8hvyCIUvZ7RaKnWdgj9LsAMjSnEzommlbqkMgD1
	6sEoj4FFLQksvEV3hM/MgpxU/B4Z/b+h90tZkmaUMzALfFsOKcTRlnMSc36d7w8GGv16o1HCKDc
	S1ZdVIUQ3GtRE21rMEnAzJJfrKglM+mV2kn2XQgmdRJmNuw4I1nC2YLEtNgKKudpa3TthoFtX++
	lUFOVhuc9/L07ngImmWOH902wXVYe3nGSHBkSEM2G23AJRX570qBbTFIUe+JhEvJxpJE4l14BWQ
	Ijp7+mq/Q9MIn0Gsyr2uRPWR2gJt2SRvA3jLS8KKEs3n+11jo69tNOXj+2xuKrtovQv1QcvlFKk
	J627oN/2GQWmHgqCqH0VcOZyvUBH/K+bhO/prcRWCtiH+qjqIl2cZuRqL97q5DRxQPiJpoibbrT
	77LQiK2Wm+vwp+8k2zc7Pe8PERElG58uwz5bU7CV3HRERnpUZVDvKvMoUjfVN4bHmafnJH3TiXX
	T9ufRRHW0JAN3KN59PNI+Etv8WOLS3j+okEXOt4/peT/2fssUQZIXJg1sbhFSSC
X-Received: by 2002:a17:903:acc:b0:2cf:b68a:340 with SMTP id d9443c01a7336-2d2a8993ef0mr302834195ad.10.1786400193500;
        Mon, 10 Aug 2026 15:16:33 -0700 (PDT)
Received: from com-75606.corp.openai.org ([199.47.143.7])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-315beb88473sm43484475eec.17.2026.08.10.15.16.32
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 10 Aug 2026 15:16:33 -0700 (PDT)
From: Kyle Zeng <kylebot@openai.com>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	netdev@vger.kernel.org,
	Kyle Zeng <kylebot@openai.com>
Subject: [PATCH] netfilter: nf_conntrack: validate template helper protocol
Date: Mon, 10 Aug 2026 15:16:28 -0700
Message-ID: <20260810221628.34800-1-kylebot@openai.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nftables compatibility metadata is used to select an xt_CT helper when
the conntrack template is created, but it does not constrain the protocol
of packets evaluated by the rule. A template can therefore carry a helper
for one transport protocol into a conntrack for another.

Only copy a helper from a template when its registered transport protocol
matches the new conntrack tuple. This restores the invariant expected by
helper callbacks and matches the protocol validation already performed by
native nftables helper assignment and the OVS helper path.

Fixes: 0ca743a55991 ("netfilter: nf_tables: add compatibility layer for x_tables")
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Kyle Zeng <kylebot@openai.com>
---
 net/netfilter/nf_conntrack_helper.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 500509b17..419af6f76 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -205,6 +205,8 @@ int __nf_ct_try_assign_helper(struct nf_conn *ct, struct nf_conn *tmpl,
 	help = nfct_help(tmpl);
 	if (help)
 		helper = rcu_dereference(help->helper);
+	if (helper && helper->tuple.dst.protonum != nf_ct_protonum(ct))
+		helper = NULL;
 
 	help = nfct_help(ct);
 
-- 
2.53.0

