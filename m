Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98EE3376463
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Apr 2026 23:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777504730; cv=none; b=Fo8RGz++f8VjbYcUvnuGmVkSQuC/1QTZBcOPWoyHvzKhcSau+sDkgf7c/YikKMIDUUkijRxPgwKNqpP0aXG/6VmSBhaiqXicHpnT43ZKty8o90xCPmQ0wQFAI0+fQgMvsrOdhm7uuWR+8PmI7MSiWEH0IHhnKZVo9hZC3JDMKMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777504730; c=relaxed/simple;
	bh=Zj6EyFrG27dVsJjtN+0O1fbv1ApMVh3gWAYYHZskTM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WpQjdqhZ7qPrVnbeKvgTKjafSaI0xYXWXgY5Gefftv4JGPSyF/GN40iF0atDoS9DPr6WkmI/n26oQn9oc71AIxYwVKp9bNVkHcew1Owa2RfR1G2QemhhQAI9pNgfw0r4wYu+aKlSHcI/atdGIA+OkI9Mr54o/mCyGkw37h+Wq1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=caWg3WXG; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="caWg3WXG"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-43eb012ac4fso179899f8f.0
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Apr 2026 16:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777504727; x=1778109527; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FuEsegkyryEZOXO6Gpz2sASCEUkFJVzUSqqEieVk9oU=;
        b=caWg3WXGKp44I12qv99rvWt3QFDrvhK/4kKfOurlP6az3hjb+gCKmYyvkucX5fIQU6
         n1N+lJi0AmbB+CPJqEVm/cgL01toJgNx5Ew9fFroeKy+jrsrbVD5PNPSJUfUbXSKfoBa
         Hq3ZHZ782d7aqnluvlOUZ96GxIQ4uxclYLEc7YxIxESHlctCZNgcavc+ODNCAYzrSOa2
         DD+jntWqvSmymvxTja2zMx38cReuXZoZ0HmmY0KKH03lWi60rNhZ10YC0nV9hAon7wU9
         y8Shzg0113ny1P5hxFAAfNYFUR1zt9Ko38voHpYeW4b1uD7kkKiZFZTFh72vzaOl2qOu
         c4eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777504727; x=1778109527;
        h=mime-version:content-transfer-encoding:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FuEsegkyryEZOXO6Gpz2sASCEUkFJVzUSqqEieVk9oU=;
        b=WkqE4Q8hTN2w9EQBDqvughQHfmMUIkg7fj/8x8rxthDWiwT97D1RKb8TiWToaUfjPe
         lBS1D0rwJeDejB8Yveruf1J97NPLdBEHkO7BiAVYzdzH28AvL1M91KBzmNY21BSWOkry
         M3CyjaA25HeSB/NV3IDw1m/dqZR7BGhL3ExidEfchmB+0bWIzVGz36dL/hza0mBEEKSy
         mnk3eGykg2kNSVUJcsOJfxiiIlbejVjal2p8OYEFMkG0uGVB5fJt3ly3nOG4qk6e3DAR
         u5QtzJeQi13ScbzrIH2qveirbSExiYL8t2vsRxiN7an2k2LXnskGkSlPg7pwJLcBfGt+
         8Kug==
X-Forwarded-Encrypted: i=1; AFNElJ91dcjvDp+M5ta/TQB+fdBnYD2KvN8u1JaCzodEJshEM1bNmx3x9Ts1tGIdWaNpBPi1QVKAGThy2Pl5mvOL3Xg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yztzk7caY1JJq703b2dcttBqEqfs+E6TnuXxvw1KdJcrmxJy/oA
	aZkX9n+CW7mzvJl4EuaJmqUnwcjuuTdVVjsN9wv23IHp/xOHAOFoeBY=
X-Gm-Gg: AeBDiet8byLq0T+pbZhqhD3lGHwNAboeeSfzgjT7AYVMB1PYFTwLjrW+SFWOpj9ytse
	j/r8FcJEob5UyG96QgKdPPjQvWeYLuDXhDIzUdU3BvKeYRnqe4lLlJjEanSm5NBSMhMLRa1y7/7
	22cKVM5Hz5G+YaKDdyIQ6G3cSvtA5IhahEMPTNa3hMyPXGmHDUXOat4PrwW9mNn5vAykdzAUwnV
	zy6e38t9AtBBYg/9o2BojEjk1YiSXEnH7sVJMeMuyOkF4BVINypfgHdmB1Vk2mYN8dlbpa8Grio
	6oPl2wTlQq3d5cwGOXNW/z3Uz0xwFqwkX8X9HgMroc0I4tSsOu+chbWipy/s5wC5rsxa5HWNhdm
	WaJ1lqeprYOEldTDi+NezSJa7zY3+oRlNviSs+OFfAgAjuok7VXIPR7aPBlA8JkURSwwFoCAAtB
	1l0Cmwym5meBbZXQ==
X-Received: by 2002:a05:6000:26c2:b0:43d:71f4:7ed4 with SMTP id ffacd0b85a97d-4493d4120c0mr627963f8f.15.1777504726704;
        Wed, 29 Apr 2026 16:18:46 -0700 (PDT)
Received: from debian ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-447b76e5c00sm8707525f8f.25.2026.04.29.16.18.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2026 16:18:46 -0700 (PDT)
From: Tristan Madani <tristmd@gmail.com>
X-Google-Original-From: Tristan Madani <tristan@talencesecurity.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
 netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
 stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject:
 [PATCH v2 0/2] netfilter: fix NULL ops dereference in iptable lazy init
Date: Wed, 29 Apr 2026 23:18:45 -0000
Message-ID: <177750472539.3004201.15967003942391945312@talencesecurity.com>
In-Reply-To: <20260429175613.1459342-1-tristmd@gmail.com>
References: <20260429175613.1459342-1-tristmd@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0


v1 moved the ops allocation before xt_register_table(), but as Phil
Sutter pointed out, new_table->ops is still assigned after the table
becomes visible via list_add() inside xt_register_table(). The race
window was reduced but not eliminated.

v2 takes a different approach: guard the pre_exit path against a NULL
ops pointer. If cleanup_net races against lazy table init and finds the
table before ops has been assigned, it simply skips the
nf_unregister_net_hooks() call. The register path will either complete
normally or fail and clean up via __ipt_unregister_table().

v1: https://lore.kernel.org/netdev/20260429175613.1459342-1-tristmd@gmail.com/

Tristan Madani (2):
  netfilter: ip_tables: guard ipt_unregister_table_pre_exit against NULL ops
  netfilter: ip6_tables: guard ip6t_unregister_table_pre_exit against NULL ops

 net/ipv4/netfilter/ip_tables.c  | 2 +-
 net/ipv6/netfilter/ip6_tables.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)
