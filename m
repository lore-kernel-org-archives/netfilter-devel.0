Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795573101;
	b=VlIb/4Sc3DE9bt/fbcZbjqXO87wPKINdZekE0cjEzV4z3/BRKFYjGZ49VZGEEKeqE6kZ
	 TFP956nnxqfl3jZDsQoCnlN6ym8/9Nkldi6SQv2RavMKhc3RFONXez8D3iQVUwLlaXa+2
	 fommNpIHbYGIetVuVpNzXZj6+tZ3pUfGCe1mi5jGdZQJTpo7BIZxLAv9/zNVgQEBamuDb
	 JIwfE+BaK3kaS71n3LlkkxxmZVyz5SzNidyDl/kbET1NkW93yhNCp7SwQrgZGx9o1/CtY
	 6ym/nPOQlsUK2x71q4vwJhu1yKbPUFkIGas8UFEAwycJuOKaLMNzBwdlEbw5WUpRNMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795573101;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 Content-Type:MIME-Version:Content-Transfer-Encoding;
	bh=BfBc2nl/+x1jei32QWJml8gTyYfpGpADR+dK5QnbKzw=;
	b=Yhh/xLrcXsKDC9yAjuoG0iZSqKfoEcmNUrdkyRheaGDCEkFWKdVkQpUZWSUE8KpC16g2
	 NZc1HGv4cg6ck3KDUv4bmcdffey79shp1HXOXOEX6ZE7seMSmD1O7SVln/E8K0iOa3W95
	 8cuxLL968Pg8twr1WEFORdniMJaeyS7KPcLOvDVlpyPDThKIJ2aM4weGKqPRJyOq1dU+2
	 S1sPbmd+uIy867IjOV2aq5NFWFZrCn7pkN1h3Qz3ZfInsClR/R6GOFtD6y8G/gVlu62Mn
	 S0oGf9HZym6lMDdkDiJN7ii7tO69gxrqJfFX8pNTZG1nngxrqU2XuQ28MCq2UBLUZfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mMUfAWXc;
	arc=none smtp.remote-ip=209.85.210.173
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDE89606A31E
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Nov 2026 02:18:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EDE89606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mMUfAWXc
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-8b2f59de176so4086263b3a.2
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Nov 2026 18:18:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795573100; x=1796177900; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:content-type:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BfBc2nl/+x1jei32QWJml8gTyYfpGpADR+dK5QnbKzw=;
        b=mMUfAWXcVM1xIZ/sjsn1fq08fH4cNvvV+oUQ3eA29ZMZ7A+eR49KLC6qpO8DNy1F2r
         gkd92auy0Mt4Zky/nz7SbVEL/AGIvelnKaoFgD+J+iDepSfvxxqWY0+T0Z39kxdHTzTY
         eMscrxm14uebLO9hUbvAA+qdI7KIr5bdpvPWPLiyqQe+mp5hQH4oZ5Ub3qD3qJ74mSua
         sFJIhhKkRaV9B23MWw4rMZLzDyZ7CbJxvlRCJ6Qpqb1m64EzWOGlB1eu9cvA2wprbAwF
         KXWhsJVnHVM8dnPdGTgKarfqJIVO7dc6UBO0xheja2CQ0m0G+8S0YM5Dy4YVRFWmMctE
         dIxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795573100; x=1796177900;
        h=content-transfer-encoding:mime-version:content-type:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BfBc2nl/+x1jei32QWJml8gTyYfpGpADR+dK5QnbKzw=;
        b=WzENwdrPIXaL/xhPt/E+uuB6wB/WL30FT6ZRq5GklFLOiPYeyF1miLaqpO5ocoVhHP
         ItrNYbLrRm97XtUrhDYpRyBswxNEP0PWWjt0rlJgAynpZAyQSVsu2QrSQsOC2eOdCTCI
         AOufoeRa7CdBguh83JSuJDbIH/J+tF4uDPsRmWV7gYsrS4OfPZeHaFsLV/68ySPFztzT
         VGqXOWgUdHBVBUMF2V9xB+ZwTdcH+BA7OGd4hEtpp13FQtqMaJEvq70Q4Hpz7PizSYNg
         xJ38nu5HbalbaS6pqhGKcuK3bOq45GhTACPPKsmRiXEbB15hdcir3oOW6cG7nMuKIptB
         4dhw==
X-Forwarded-Encrypted: i=1; AL+hErHe+FV2oqwFttGQDJVJ3KWHHKtmouj8QGeuUtxKLqtBHC82cy433EPzgVc5UEoie1BnZiKm7xhY+Mxgu017cMM=@vger.kernel.org
X-Gm-Message-State: APuU4Z+kyg05rKeUVBr1hs1abdJzmrxCzleT9s1ezDdo/EOz89O0a9p3
	O9+xLgeM0M4QM9cxGq3nRDKDRj/cVyowRSikmm+hlWF5PKvP0YWD5hnB
X-Gm-Gg: AZFdTZdTOKKajH0cdh9JLTa3m/Phwz3FTVV/IkUNaIquEuNmPAx59NgzmfdXW/32rJ2
	R07GLCtrkXP0sYS6Gf7t4l7EEKtraTVDrFZxlkc8mA9WZ6nJ4ZWWEvGDR55e4dmibY1ix6gUY/o
	4nNnVRFG2h30YmiFehgSbokZxbNNiazVz+J7+cDFPSak1yMLHQAawaNUQ8V5nyJP4iw0ajnMY5K
	qgMMELeCJ8TY+fsS2LPohcS3F9E2mjjFUkyCYbWCPPvb+5QNCr83b7f5MKWAPjypLevNcEhbXWo
	aLcQLpgbGuvuI+GVcug5NFBHull499fM7JZx5q2G/YKW8Owm71LpHNPnvbifN7TxJTyXDbm+jCZ
	sFlzdVUlBu6ji94HwRbLxsEzgM4HUmdr4t082wQJVhw4+eK5aYX9TT+DIwAuZ2fcx40fgv+rS07
	jn+JUlRKN7snobJaeqliqO/ws6fHS5CkMZ7Em6GZEm8rhvdOuBUEK3kzIgOI3An9jI0tmi3wZRU
	lXUlbrSJ64pVfgUgKukUalV++weDiC63ZajrwYJF6y8jysTpk3pkGZMd7sHDZX/jVtTVTEt8xKZ
	bCMq6kHk18etvrDRXQLMhoRpPALPqK9i+0WiazzRg7GMOfWs97K878prva2urYO40OV5ppmFdeY
	Gsht8eJXXuQpGBbjWN2yJSaPwP0chrO2VNEJcmy+tNxh5p6Ik6KwDCDTC+BtueI0osQ==
X-Received: by 2002:aa7:88cf:0:b0:8b6:594d:7030 with SMTP id d2e1a72fcca58-8c87ca51fe7mr14842703b3a.42.1795573100263;
        Tue, 24 Nov 2026 18:18:20 -0800 (PST)
Received: from LDYT9Q2G2M.pvgl.sap.corp ([180.166.22.226])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c872e45eccsm8048734b3a.31.2026.11.24.18.18.17
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 24 Nov 2026 18:18:19 -0800 (PST)
From: Zhiqi Zhang <zhiqizhangg@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	kunit-dev@googlegroups.com,
	pablo@netfilter.org,
	lfinke@student.ethz.ch,
	netfilter-devel@vger.kernel.org,
	jhs@mojatatu.com,
	jiri@resnulli.us,
	netdev@vger.kernel.org
Subject: Re: [PATCH v2 0/2] lib/ts_fsm: preserve patterns across tc dump and restore
Date: Wed, 25 Nov 2026 10:18:14 +0800
Message-ID: <20261125101335.7868acd102b6-ts-fsm-ping-zhiqizhangg@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261109103454.50617-1-zhiqizhangg@gmail.com>
References: <20261101081736.51803-1-zhiqizhangg@gmail.com> <20261109103454.50617-1-zhiqizhangg@gmail.com>
Content-Type: text/plain; charset="utf-8"
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

A follow-up ping on this two-patch series, sent on November 1:

https://lore.kernel.org/all/20261101081736.51803-1-zhiqizhangg@gmail.com/

It fixes a userspace-visible issue where restoring a tc FSM text ematch
from its dump can change which packets the filter matches, or fail with
EINVAL.

v2 describes that impact, splits the fix from the KUnit tests, adds the
exported-pattern equality assertion, and includes Cc: stable on the fix.

Could you please advise which tree should carry this series, and whether
any further changes are needed before it can be picked up? I would also
appreciate guidance on MAINTAINERS coverage for the new
lib/tests/textsearch_fsm_kunit.c file. I can prepare a follow-up revision
once the intended coverage is clear.

Thanks for your time,
Zhiqi
