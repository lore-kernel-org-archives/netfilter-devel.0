Received: from mail-ed2-f6.google.com (mail-ed2-f6.google.com [74.125.228.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF889478875
	for <netfilter-devel@vger.kernel.org>; Tue, 25 Aug 2026 15:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787671655; cv=none; b=iWtQBax3Rz0isyybHC+7h0POz5yAzZvb7d1+ogpGNQyfkTbgk7TUenwyhwvOunkfmmsZH7K09bXzjUTwQggRd3AtMw7xUILR9h4uF495GAEUJtDobasQl6kMAoB0U+Mhs/ls7rUfrAqKUe+osSPqqPklsCvGCGpmx3o2DOBgCCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787671655; c=relaxed/simple;
	bh=uQVz+K1/tiwkasTG+w79z8H2afc5AsmIftpAEk5RMkY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BwZJfCe+99NOwEEEVgSzFI+2c8IXCClHQUkhUpNlwl/RMQQBT322GofQ4CWrevMoLJsG6Qr9UHpbz3e9hsiW5/6/pRQaHJD42ViIo3KS0fFK0ld5r3GsOQzqxgSLbJkHes8FSSTZUIDa2E9UqlE+Cfz02TuRJOI1s+Pj7XLQe+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ovn.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=74.125.228.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ovn.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed2-f6.google.com with SMTP id 4fb4d7f45d1cf-6a5d790cce1so255887a12.1
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Aug 2026 08:27:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787671651; x=1788276451;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+5k9HBpOvCsTp3v94rUbWHBbfWVbyD8PJy/u/PILaBw=;
        b=A09iAnt7cUpaUyZv5JDh/H0uxvxtOiZkF4s4eXGlFLDZnutwZlyQh5Q/C+NesjmNxL
         hSPRzqt1LvyiGdd3Y3UX1Y4XHlnW6gl07Hma7l1dt+zBUQoUAtvz86VwW3tcVYCyUDS8
         IyCQ9o6MpUI4gMdgvfC+QYCNIDfKu/b3jfMu0o8Ead5VrZ/65haykq3TV7dd20uoh1aS
         Fn/suifUh0vLGz7/oULM2panP4F7hm3Qma7w9kHt7s128aIp5vD4pCL38e+qagQxExbT
         +8umw4kQKdXAKV6ekY2erWEprVfc3lAzuyRXOecJQH/hdyv6G7m8wF0M1lm14LSZ/IID
         LNPA==
X-Gm-Message-State: AFuF++katFXrPBcH+VvM2SzD4+L86A2X4PHPgddE9NK8poBbBeYNnmuP
	/AeXwwJlVHPdh80en6s5phpSRl4VN1lx0+rw+GphPfvADWUHgIAORj84oT7af8Il
X-Gm-Gg: AR+sD11SmA7LUi/lte4yq6hq5GU5FM2hv1PyNH3sVR85x+ub7dJwqGCV0+pwUK2f3M8
	UEBEVjfbYsRC3kNU60VqvDiRhELWEFe+rBcXYuTX0IPUYrKdUzicXg3/UYEXUsaLID2zK0/RK7t
	TswicLQQ+zn0skCxsSElkwQrS0XUp0UCUVsliq6PuAMnMvCP6Erk4EXqbNDFJwOdMhyarhR73gU
	GsYAVNYyzhnb+osBNlYeFiK4+HCumewHnR6wTseUGuGsFRina0b9WSX/WM0+P9rIOlEKjEAEBYO
	DX4UAKrTd5jGOwB5qj3hVwD2uuTKVutdC3xCa4sxsY01pAjD72ucZ5F/5XE8itE75eVLOP9O7WS
	7UpncycXeD3gUPsgiMmgnUA24vg799J00e1umnMsY0rYzLiOBHIXbtiUq+vH43Npeev8UfkkuDW
	yxzkyYDwQzp2jKhcqQTzQ1xtE6en+lm3TUGM3fusILMB610Mbg+U/Ou54TFGFsAUdxGuyxOofaq
	nzyTBJ2RPsaAAVQDhz4afuF0wNiHJo=
X-Received: by 2002:a17:906:f591:b0:c24:6045:2a94 with SMTP id a640c23a62f3a-c24e5c8ad60mr1019878166b.4.1787671650465;
        Tue, 25 Aug 2026 08:27:30 -0700 (PDT)
Received: from im-t490s.redhat.com (89-24-33-32.nat.epc.tmcz.cz. [89.24.33.32])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c250a9ef996sm1808866b.62.2026.08.25.08.27.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 08:27:29 -0700 (PDT)
From: Ilya Maximets <i.maximets@ovn.org>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Romain Bellan <romain.bellan@wifirst.fr>,
	Florent Fourcot <florent.fourcot@wifirst.fr>,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ilya Maximets <i.maximets@ovn.org>,
	stable@vger.kernel.org
Subject: [PATCH nf] net: netfilter: report NLM_F_DUMP_FILTERED when all is filtered out
Date: Tue, 25 Aug 2026 17:27:24 +0200
Message-ID: <20260825152725.3678225-1-i.maximets@ovn.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

NLM_F_DUMP_FILTERED is only set on data elements in the conntrack dump.
But when everything is filtered out it is confusing for the user space,
since the flag is not reported anymore and it looks like the table was
empty, which may or may not be the case.

'answer_flags' were introduced precisely for this use case, and the
conntrack dump should set the flag in there in case the filtering was
applied.

This is important, for example, to be able to tell if the filters are
supported or not by the kernel without modifying the kernel state.

With the proper reporting of NLM_F_DUMP_FILTERED on NLMSG_DONE, an
application in user space can just try and dump with an arbitrary
filter without worrying that there could be no matching entry.  The
reported flag will signal that the filtering was applied and therefore
supported.

Fixes: cb8aa9a3affb ("netfilter: ctnetlink: add kernel side filtering for dump")
Cc: stable@vger.kernel.org
Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
---
 net/netfilter/nf_conntrack_netlink.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 9b4e29557ec3..579ada063b1b 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1077,6 +1077,8 @@ static int ctnetlink_start(struct netlink_callback *cb)
 	}
 
 	cb->data = filter;
+	if (filter)
+		cb->answer_flags = NLM_F_DUMP_FILTERED;
 	return 0;
 }
 
-- 
2.55.0

