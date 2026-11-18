Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.225
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032833;
	b=ehfiROeotfjIFg+vz/FL0U7oz3YzT74eITZg2IEYRVhKONRTOVVeELnyyggjIa7r9aw0
	 i4Sz1NH+qzmjnFDsYOEJYqVOzA9lhR2eP7nPlaV9NXCfd7Zcf8mfN4OKlRSJKFxiAX1Nb
	 Uh1pqrMbKOROIjv2igY+sGomyfqTB0RfNEaXpxBG9V6Wm8hCxVyFGrMNFQT8Lap7JvQNZ
	 2BYG3X1GsRepedEm75NsK+fbP/lYw6DwhTWk3swzQ9mGP3qz2HvQ79Wp4mqw3/idPnWI6
	 HB4Ktmzs/V65U9CIgcXLYcpDy02NwQ/+H3Q5CWS0Bki2RcKL3WWtTKx5BnC1FwhCyUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032833;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:X-Relaying-Domain:
	 X-CFilter-Loop:Received:DKIM-Signature:X-Forwarded-Encrypted:
	 X-Received:X-Received:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-DetectorID-Processed;
	bh=aTzD2aWzK4y106Q4turWhvgJUGfskZNqD81yrb/wDlI=;
	b=v7HuYUCcMOKPWJpxpf0gSMGMhx/ihmRaEn/UPBLrVPDn1aEAMHJpD7G5i6sbf+1eIhB9
	 XmjViXgsi6HRQubO90DoIsGUO83YrIcG0+E8dlKhleq0ThYjWS1ZX9qbvI0na3hPW9VmX
	 zttTGK+Y036dwPE7iQ2PUGXvIrxEmH37ktmmQyQr2fB1gB28ELky0vs+2S30guD7547O/
	 CSraetucPc9HfCL/cR3+BnVUzM/M/b5yQqKClrhevlw2RFaF0qaJ5lGZKAHzwAdgwAjxV
	 qDEo5gLkJmHQ5deeligxY4FvXhvJUftDBYuK9DKUgvNk9uk6HmgLMqE/J3/H2SwZvFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=EcnMcg+p;
	arc=none smtp.remote-ip=209.85.210.225
Received: from mail-pf1-f225.google.com (mail-pf1-f225.google.com [209.85.210.225])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8282606A33A
	for <netfilter-devel@vger.kernel.org>; Wed, 18 Nov 2026 20:13:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B8282606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=EcnMcg+p
Received: by mail-pf1-f225.google.com with SMTP id d2e1a72fcca58-8b66d1a08ccso1237666b3a.1
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Nov 2026 12:13:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795032832; x=1795637632;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=aTzD2aWzK4y106Q4turWhvgJUGfskZNqD81yrb/wDlI=;
        b=s8+G0Jjf8zsFG1ChViHngfYIWx0G7S3wUfzGzu4oKPt1xkjlID2BXL1G3U8MLn8KOo
         vUXSc6xeLCFi8CGLfJxOYczT3HgQsqQ2e/bssqLDhSwFpYqpCHezRQDXf3N3LzOn+L60
         pBey1G6zxqwM32qGO/cN2jrNgbfHAATQGCL/dRAsAzfYtdPFUjtLYApeDDFbE7waluuA
         yvVhREJaSZMZU5L77V36cUefkO0jgduIwgQDWosQO44fu2ItCTNUxpfx4b4RqaAFXV1s
         fKqymf26GBmEs1vyDmb33M0atE0uQta0jpOWrNJq1KPvi8PAxnvxKv0tRclFfrWDK9e0
         ttOw==
X-Forwarded-Encrypted: i=1; AL+hErEM7ZAOL2cUY3PJnaOA7eizTEce8Ggiac18KHYg8LPB+I/qGpj3jUj9ijEJJAKgQkzDi6MZkLlgpjAJWvR3fF8=@vger.kernel.org
X-Gm-Message-State: APuU4Z/pROA7fMJORaS0nX/qKu/iVsovwvjLr7V2GvODJqyyWXqGBCAV
	1c+7gyrlJzP2QwujBQX+CbPuqnQLifTTxE62RiqGanpaOQpn0VUFAAnIk0w5AP8CzzuFP21umek
	/KK4uALweoVzd4U7YSH1THhDyZPaJw5wfNffH8iXvqnxY9aQeqQu3UkdOi4tWCWYpkvu2P5XbPk
	Hl26cOkHJvZss+4NCmtKYhT7IPnJLKGbV4qFtHvz8hAWCBrgP6g2slpLUcQjoQ2v+Y8hkdZSGFo
	JuEpaCUcomr9MSq/PviR8BY8mJM
X-Gm-Gg: AYBFou3DCcN2xiFirbB3h2mPE+aPCq888rua2fTpOh+i1vzVg9HpkDmwFyr0qSIeUzv
	ZcQEOpdeoXfgvRVezoQwf4HMv5bGIpdRFHM2NTW1vjMuAJFSPoFEpmBS9Ig2wEhLnae//NTjAie
	T3jWEuWTcS//B2qDrbC3ua3IBpIK6JawiqbI8o9ttlWNxFTjmPKwO2p8lIBVw1xhvFFkBNoutAS
	bRnciYg6RzfSpZrZDcd8fqZSzwN5Gx0EFjEHjN4DD8bOrcAc/0YczE3yKOONJZhGTFhnG91Vj1F
	O43gkpIBuioNMggHeznyzYJD+dEfc6P9ABj+6j4jfxCTucbsqXoKRUjIe8/jgPMuPeP6DgoYsrp
	h/6C21uMSLckoc9ggIMJ1lQDA+8aTWdrT4JmjDOP2zH3OE/KKwvF55hOsZDrRaz080RnOSRvxo8
	95SqcEfbOe7CPXA2BZ5pdLD/YdBeLthCgeAUFfTBgI
X-Received: by 2002:a05:6a00:4f89:b0:878:34d7:697c with SMTP id d2e1a72fcca58-8c5d49d1ac5mr3403127b3a.42.1795032831988;
        Wed, 18 Nov 2026 12:13:51 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-28.dlp.protect.broadcom.com. [144.49.247.28])
        by smtp-relay.gmail.com with ESMTPS id d2e1a72fcca58-8c5c9ee3371sm25251b3a.3.2026.11.18.12.13.50
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 12:13:51 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-55c5cbc838aso30807761cf.3
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Nov 2026 12:13:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1795032829; x=1795637629; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=aTzD2aWzK4y106Q4turWhvgJUGfskZNqD81yrb/wDlI=;
        b=EcnMcg+pj4DD81piCV7cmJQrVefYzvFVLEk4AkTXVzEMWCyqPt+KqltiIdTrmmUrpv
         Xeh+vD355s8wizgxcwUZVm5HWxnXJK/xOtpWJ3zwd9w3YEP2Vo+A/1TVif4Unh9LBDOz
         cwE0zMKljtC9NbA614J0iUSO3AgbackW9Wj3I=
X-Forwarded-Encrypted: i=1; AL+hErHqOTRpUrXP7yZl6GWylsyq1DRA1DZ2TAoceWYe/zAN3A5gRe8fNkf0AnH6fxoYWksxoPRJV8/ZDLWAJcoM5HE=@vger.kernel.org
X-Received: by 2002:a05:622a:4cc9:b0:55d:34ae:98d with SMTP id d75a77b69052e-55d5a36e1famr59604261cf.10.1795032829400;
        Wed, 18 Nov 2026 12:13:49 -0800 (PST)
X-Received: by 2002:a05:622a:4cc9:b0:55d:34ae:98d with SMTP id d75a77b69052e-55d5a36e1famr59603571cf.10.1795032828766;
        Wed, 18 Nov 2026 12:13:48 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55d66c2a5a2sm7675091cf.21.2026.11.18.12.13.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 12:13:48 -0800 (PST)
From: Florian Fainelli <florian.fainelli@broadcom.com>
To: netdev@vger.kernel.org
Cc: Florian Fainelli <florian.fainelli@broadcom.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Toshiaki Makita <toshiaki.makita1@gmail.com>,
	linux-kernel@vger.kernel.org (open list),
	netfilter-devel@vger.kernel.org (open list:NETFILTER),
	coreteam@netfilter.org (open list:NETFILTER),
	linux-kselftest@vger.kernel.org (open list:KERNEL SELFTEST FRAMEWORK)
Subject: [PATCH net 0/4] netfilter: flowtable: Preliminary fixes
Date: Wed, 18 Nov 2026 12:12:46 -0800
Message-ID: <20261118201250.2075007-1-florian.fainelli@broadcom.com>
X-Mailer: git-send-email 2.53.0
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
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

This patch series was created based upon the Sashiko review of the
Broadcom Flow Accelerator support:

https://lore.kernel.org/all/20261116222519.1416501-1-florian.fainelli@broadcom.com/

These changes were not encountered in real world testing but appear to
be valid. Test cases were added to ensure there are no regressions
moving forward.

Florian Fainelli (4):
  netfilter: flowtable: do not queue offload work after DESTROY
  netfilter: flowtable: restore the GRE conntrack timeout on teardown
  selftests: netfilter: check hardware offload work after DESTROY
  selftests: netfilter: check the GRE timeout after flowtable teardown

 net/netfilter/nf_flow_table_core.c            |  12 ++
 net/netfilter/nf_flow_table_offload.c         |  13 ++
 .../testing/selftests/net/netfilter/Makefile  |   2 +
 tools/testing/selftests/net/netfilter/config  |   4 +
 .../net/netfilter/nft_flowtable_gre.sh        | 137 +++++++++++++++
 .../net/netfilter/nft_flowtable_hw_destroy.sh | 162 ++++++++++++++++++
 6 files changed, 330 insertions(+)
 create mode 100755 tools/testing/selftests/net/netfilter/nft_flowtable_gre.sh
 create mode 100755 tools/testing/selftests/net/netfilter/nft_flowtable_hw_destroy.sh

-- 
2.53.0

