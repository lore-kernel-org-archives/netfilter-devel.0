Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794220511;
	b=W4bqDB/CWU6wHrODRCYd6CpIbyz9dWJyK3Px4yeCJWIE/ARpF9BNLZtXkgUmqx/AUrws
	 lc8RI5A9sS+mFK9n7DOx/eQgOkxbbx44tZH4GXM0n8y/5RFFwHXV+SDkeY4osNohlI3U9
	 2Nitq4TWdDMOfI/vF5wAerw7G5P35yZBX4OAiyGcnuYJlOcP9hKPvF3sIHnysfMUrtmBr
	 Su0Xcr3xxOZje1vMQLATrnm4nKmIW3SEH7eqeSbgmxcc14+b58Ly/zfZJdq3VO6OvU82C
	 LzyuXHIw9MWu1baHQnsRTqUDPWdao2a4ucxISNNgh+bHwFLRMr2mCOcnCIFLI7wsRag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794220511;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8Hb0sYmcLHQnhtWzS9j1woOF2kw5P/sRWChZAP1XD0M=;
	b=KNbHCVKve2FKeI5PKQ+xz4nrhznH4Fu+gbAgoOARENJkkpPM1RxP+aMabaWf9xEfDWYf
	 S9GrbssIVpeHF2KW+vGtyTtK1HLMcwuQNE/L7rOoekdDyZcEAMLXZR/q/AwxhU3tMbSwX
	 F/Ybr4fe6bp9zXQ6SCiqsmI0WCAnbvGiUK4Mbr3iE9lYNvASjbqrfL5o4nU/hd+mbIMTe
	 JwMbxp5HSL0KmWXQGvFTUB6FzHJDC/GeOjL1IQ5MA77QBERCyX4g5/h/M5N9chmHDcXGV
	 9YqMQSQo598lD/8Dr4pySjuqbC56+rrp5I26rfERxPXnyMMaZZbQ6mHG6V/FWnR9tIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="g49MWb5/";
	arc=none smtp.remote-ip=209.85.216.53
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC803606A31C
	for <netfilter-devel@vger.kernel.org>; Mon,  9 Nov 2026 10:35:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DC803606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=g49MWb5/
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3ada8bc2380so316080a91.3
        for <netfilter-devel@vger.kernel.org>; Mon, 09 Nov 2026 02:35:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794220510; x=1794825310; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8Hb0sYmcLHQnhtWzS9j1woOF2kw5P/sRWChZAP1XD0M=;
        b=g49MWb5/yifGNXK9v3uJRzMXvdGfHYwVnDsvkvqEbUJ6QN0jlYqr1ebA6azfClAOT/
         RK/UbwGDRf1IqGGk6TL2Kwi5PkpKUg9C6hmiS1LVRsH41VSiAS/nlk7H4cp+5AJtbbC8
         GSnqjaXUhNuWEVSqFtLKFOu6cE/WcQjuIWQRH2P92DD+wRfV4wAR2aVxlEVHt2SgG/pJ
         srvU7WjvoR/jsUrFzj+vQ8Yl48XoC7MhyKTF1Rap8WKCzascASo+RhvYPclJepG/G00W
         7VgpYVYilAtvFTbNuW/FfaxsImmKv8evAU/LZm2cwA0Xxmi5Lv4IJeerouQbo+5r+rWa
         gWfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794220510; x=1794825310;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8Hb0sYmcLHQnhtWzS9j1woOF2kw5P/sRWChZAP1XD0M=;
        b=jeARBM7myxyk5XceHWkzJYNJW36++8Y1EPwEbaLtWxH1wsZsLQI7tZpOLZSHFE4SoU
         XPaTl2/AOOCcCTYlMeq6/iHJn+pdDFdtdsqPBHbKn73OO2WoArsAzrnomUgucK8XITlx
         Pu5MfmmgYZ3idyroptb8j1ricmlDopaJ8mzdcbZVAamT0zrLNdnJFr22MJUbPPKJ2rT6
         z96G2eZsQza3X9WjVu2YHIV0Dd8TEtyJDJKtmZX52Cz7Oo92Kn3zypx9I7XgaQ+fS8VY
         O/EUJW1TH2qU6FkXNInwJMuGXgq5EJmmYXDBPVQVzd1ldKILqxjtKM9RF3kOdzBKXzJ8
         XHAA==
X-Forwarded-Encrypted: i=1; AL+hErGUCawMik2em9JcIqdQkXidmbpG+fz0aPrnWa09rZaPvsGnb/tOiV596rdF7QOtNmJdu4l8y0D5jOuvmZt0cUk=@vger.kernel.org
X-Gm-Message-State: APuU4Z+k+PvG5idsXzjsNm10yYhrU/6mYHoIrxGycqVNBX1ix+d8sntF
	432tg14VZoE4CXj907WXg7PVg8yYI0lsbQ+7v4TyUzXPdYiB9VR5qB7T
X-Gm-Gg: AYBFou2jDux+rsY8DkYkVAOmPzU6/pqYf7oKOWhz6bKHE0AIxWMlRfkIML7dqFaIaOU
	9VrKerxukAGPMJQTvbJ0nswRr3NClhgeB25hLbLve9A4IExwfTBUPkPhKMDL5HSxO8mSwpl6xsQ
	Hh1u/lqkL+QC1Zhgorx47t5lM3xIp5d/PsrM48CiR4pCXupfYcJzukPd96Yw4c7rHdbhn5QeS/L
	ZryBgzKFIvVtHcf5B3lqj4feY169336e4nLQokVC1eKMd3uHc8+4quTgP+KqdFfJLNHTzyCeP+8
	N0vmsuq/l7O8KtQT57J7IxerqYM04zbH/JQZKt+T4C4f3WCjsSzlgb6BRA/bFxlzj0GxnUCkOpw
	dGADyM906LhqpV+Ksb13TvzcNjel9LOBSaX/ys95CXLG5LdtizvREtodEGXUayIjKBfjMHdLXwL
	FWCGEDc4vjl3+IYhiO5nlhTdQG6fx49bopc4LRK33bLDonxo+bloRqt65DEjkdoFn+taqsp02Va
	D9isle4HM/YZiLjoaI+9IimrmsfRCc3ZnHMZ0S4LAhIYjXD9+y2rbgx+mIMkLOJ325wqPAN4WMV
	BOsbtywO3CAYoX8zuDspAl2cILoyhhwPL/3X12/d5uiavKILuCmeHsnT4xeAOvEqAmx613r74iD
	V
X-Received: by 2002:a17:90b:530c:b0:3a5:c08:4c41 with SMTP id 98e67ed59e1d1-3b12d49b258mr2971323a91.50.1794220509924;
        Mon, 09 Nov 2026 02:35:09 -0800 (PST)
Received: from LDYT9Q2G2M ([2a09:bac1:7680:450::1c:35f])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1058d3310sm10379457a91.15.2026.11.09.02.35.02
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 09 Nov 2026 02:35:09 -0800 (PST)
From: Zhiqi Zhang <zhiqizhangg@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	kunit-dev@googlegroups.com,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Finke Lennart <lfinke@student.ethz.ch>,
	netfilter-devel@vger.kernel.org,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jiri Pirko <jiri@resnulli.us>,
	netdev@vger.kernel.org
Subject: Re: [PATCH v2 0/2] lib/ts_fsm: preserve patterns across tc dump and restore
Date: Mon,  9 Nov 2026 18:34:54 +0800
Message-ID: <20261109103454.50617-1-zhiqizhangg@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261101081736.51803-1-zhiqizhangg@gmail.com>
References: <20261101081736.51803-1-zhiqizhangg@gmail.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Andrew and all,

A gentle ping on this series, sent on November 1:

https://lore.kernel.org/all/20261101081736.51803-1-zhiqizhangg@gmail.com/

v2 describes the tc dump/restore impact, adds the exported-pattern
equality assertion, and splits the fix from the KUnit tests, with
Cc: stable on the fix.

Could you please advise whether this series should go through Andrew's
tree, or whether another tree should handle it?

The netdev CI also flagged the new lib/tests/textsearch_fsm_kunit.c file
as lacking specific MAINTAINERS coverage. How should that file be
covered, in light of the dedicated textsearch entry discussed in the
v1 review? I would appreciate guidance on the intended maintainer and
coverage before preparing an update.

Please let me know if any further changes are needed.

Thanks,
Zhiqi
