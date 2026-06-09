Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D10648165E
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Jun 2026 16:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781022880; cv=none; b=en68c772XPXru6xw7eqmBP2/pNktZfM8Ls8g3seHaJL4Q1fHvDEHZvYaFTaxTke8KfryOpEYv70qRWQgo6XOfpypq31VuoPC5jtRb2zeR1RVX07p5zcvUd+tLe+Qn50IOknu+WrQSQvQVJsVmG8ANRoXHbbQ6sF1TIQzBP8daCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781022880; c=relaxed/simple;
	bh=M0Xswgf8dr0Qiuep6ei0FPzM2mwRZBPgNEukHeyvUkg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=a30Vgx799mJXOHaK3NjHmDx6+ittV3EtI0Ik6xk85RpQMWdISDN/7nKlsC0wyvk3F04YwVzmrQBAFcEkqyy0v3vkzpcu+ysftDBndhGFFcxkJm7ICQqtrU1cXooHER1F0Xf2sQhqYtUrhg8FIR8kO75DQZLXL6fRRxdWGTZiTPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZrPGDTpl; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZrPGDTpl"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-490ac10e337so50486805e9.3
        for <netfilter-devel@vger.kernel.org>; Tue, 09 Jun 2026 09:34:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781022878; x=1781627678; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hjlfhin5zBH8Pqjlc6XT6TW9No1dObZP4RlO3P48sbQ=;
        b=ZrPGDTplJFaYJXdaMC3MAyuPDyJRHlRizAshW3BHbl75f3wZwle1+8mlNzCzOCR1c/
         oUeZpjFEKzMTm93/DAJnUs+05Q9ZNPIkpO7MikSKsmC83b5tfQDsTOM6sZigDh2zW1v0
         puWqx7VpFXu75rIuqGvZtPvDgYco/Hm7cMqEheP2Z8A9AfHziKqIh0uP1NEJc914mlqp
         3nP5XcIQuuyowIeZhAcwPii/uaJDXNjjW7FEyTfgS43cgyq0NPflCUU3AsLS76tsEkIa
         bJy40+uKSNoOUJJ6lZA7wPW4r9r1ZS5yuItEB2KB3sAnQxp1mvJyxFSlE9PquhrVTEvQ
         P4Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781022878; x=1781627678;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hjlfhin5zBH8Pqjlc6XT6TW9No1dObZP4RlO3P48sbQ=;
        b=jheOGk1u6p9DFXgMX+e4rdwdXnON/VmoieUAxp1shJ2bQZ0+QdcEiXD376BYnRQ27Y
         8KrD0tkKCc3FltLnoJk5AZp/3VxanmxdAm87q4B6RMMKo0js7hFJ2kUZloxmtos/+juq
         SEhpE9zJN9K8worI1RwSq2DEyu4DdNx7cQKiTm0huEaK39zpOxm4gHQsJHPKhLQx04f+
         pIgL3tSTH9qLfXPtLNmDm3jyBGUwl7eQRSQuEKRtrHjIbzvJ70hkVIwr1QwP0zNkr+cK
         UfAfEpAwKbMGYVfgl44AeRZovlxhoDBN+EhzA2srNtq2PJIW0fj7YtdDhjqZiNKbWE3j
         mOLA==
X-Gm-Message-State: AOJu0YxWiQ4Tw/YdARQhfNID02jgBxa4fD5aqK7xgIBnWb3WDjTo/4Ms
	Zd1Z9R3L+ffgRpolDR3Ip6ZvjkoNA4EJ95WUWp+jzX71X2CYd1j1HikFhb6XUGxAfgE=
X-Gm-Gg: Acq92OFgl53E5aw9FT/XhwPZl3dzgr7gs+lYGTiCOyDNgPKoyeyXjmaymWhYXQXUIc9
	Ug3Pte1NVFZULI4Oi8I+PCc0eLTCqCMYL3H+L/uja3YPhwtjVHpOSItG69pbfznzzAyVqg3UBh9
	Yx1luYAmsz/yooSJ87PpFmxGjROVkTCCPrM7lkU9/dl7+kCODF3hZXOHvaWTgAjOiudA3MaXrx+
	yiwbHfC0Ve4iOoejqUImTYjB4ncyPDNMlgCcHd1x0I9sIEiWh1AjW8n7YdKQQP3lJwe+6BRnjfd
	7XI1T8RfjcHpV8Ikep5rDdSBm7Sapzb1+P/ktzN4IWmz5+RQv9/cQxkaeockqTpfP+GoKPz7Jmu
	IIvTKyc2bXGg3nbiJw31qVHd4kRt6SuCtIvkR3BpjC129w6Riu5+MWmQsdHXGaEdj72BWp6o6FX
	apDjFKUbW8Uv63NOefYg1/RmHQaU5gADmZPl7qrOoJFOU+UeAgXiTutYiEt4/PQGfDwjMvV0S9T
	V6nTQqvPQ==
X-Received: by 2002:a05:600c:450a:b0:490:c2a2:b1d3 with SMTP id 5b1f17b1804b1-490c2a2b3c6mr315683295e9.34.1781022877446;
        Tue, 09 Jun 2026 09:34:37 -0700 (PDT)
Received: from manta01.. (host-85-36-215-182.business.telecomitalia.it. [85.36.215.182])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc3b5b06sm449114015e9.3.2026.06.09.09.34.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 09:34:36 -0700 (PDT)
From: Davide Ornaghi <d.ornaghi97@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	coreteam@netfilter.org,
	Davide Ornaghi <d.ornaghi97@gmail.com>
Subject: [PATCH 0/2] netfilter: fix two remaining stale-stack register leaks
Date: Tue,  9 Jun 2026 18:32:13 +0200
Message-Id: <20260609163215.1102215-1-d.ornaghi97@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These are the two register stale-stack leaks that remained after the
nft_byteorder (CVE-2022-1016-class) fix, the nft_exthdr PRESENT fix and
nft_ct (3027ecbdb5fd): a producer marks DIV_ROUND_UP(len, 4) registers
initialised at config time while the eval writes fewer bytes on a
reachable path, so a downstream consumer reads uninitialised
nft_do_chain() stack and can leak it to userspace.

Both are minimal, -stable-friendly fixes that make the eval write the
full declared span. The broader store-helper rework discussed on-list
can supersede the open-coded stores in -next.

  nft_fib:         OIFNAME early-returns and the PRESENT flag
  nft_meta_bridge: IIFHWADDR (6 bytes into an 8-byte register span)

Davide Ornaghi (2):
  netfilter: nft_fib: fix stale stack leak via the OIFNAME register
  netfilter: nft_meta_bridge: fix stale stack leak via IIFHWADDR
    register

 net/bridge/netfilter/nft_meta_bridge.c | 2 ++
 net/ipv4/netfilter/nft_fib_ipv4.c      | 2 +-
 net/ipv6/netfilter/nft_fib_ipv6.c      | 2 +-
 net/netfilter/nft_fib.c                | 3 +++
 4 files changed, 7 insertions(+), 2 deletions(-)

-- 
2.34.1

