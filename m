Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.99
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032836;
	b=KK04pfr1HCsat6nLjC/0fTXIaq9M/UA6c4vNcBWihy6b3yktQKku20w8pWyWZYfRDhNJ
	 7rSxwD4vpbdwmn7/nrIJ/Mo0najwq1LIGDxN3DqiuB6Cvtx1jFvairJz0dPX97eIQtLTI
	 Na201qcuoN2U6O2rA6d+gZMFjFNY5jdKgXMtxRFWaZi271mKL4PHrfKRJkwKLIyyd91Vo
	 ZPeleGuI0BVYX1yZtywZKz51l+siosNobWkshCNOHq48okXDEWqiK5qu9fWu7IKB7dQio
	 1zbGFNnRdRIXjdhgHrwALS8H6LoK+Cqb24yO6Mrq/BD+FstcpZ3kl+LE8V0vMJZThQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032836;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:X-Relaying-Domain:
	 X-CFilter-Loop:Received:DKIM-Signature:X-Forwarded-Encrypted:
	 X-Received:X-Received:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=mqEoSsDLRwiTtXF4QHzskVicsJt/6mayXvEhwI8woOU=;
	b=vC9CpTKXvdKMq+5jG/r1lUxMdVLb+dJDVxIf6VUmDKtrnS8nr3onhov+HETrRcpaFbUt
	 11YD2OVabmAbgXvjqtGoPTGvUlrthsQaKvztiFdX4EWrEh+7xajw8y127qyF6pp2khZxx
	 IfW5BEAF+MjPbWf0ncgHK5/JEHBEQ0fi7Cgx43Dbfgnfq02zbplNYC0Shv1X1UzMHM0Za
	 eHn5fT3nIBuFTeaTvGPZmZnY3R2mswBoKmO/1VTAk1SXVy/uab+rS/eAVNw9jyoRgRn+w
	 ctwvHxaP4Ji4JyLd0vfmzYP0njcYFgx2r5El+nGXP5L8tO35f+C10gMK7lO35aYjnrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=EsALQCsu;
	arc=none smtp.remote-ip=209.85.216.99
Received: from mail-pj1-f99.google.com (mail-pj1-f99.google.com [209.85.216.99])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7863D60A261F
	for <netfilter-devel@vger.kernel.org>; Wed, 18 Nov 2026 20:13:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7863D60A261F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=EsALQCsu
Received: by mail-pj1-f99.google.com with SMTP id 98e67ed59e1d1-3b0bbdeae06so804194a91.1
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Nov 2026 12:13:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795032836; x=1795637636;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mqEoSsDLRwiTtXF4QHzskVicsJt/6mayXvEhwI8woOU=;
        b=jK7A4vFoKizwMMiaUpnLH6PEjEGn+11hhBLKSCtHIF11QCcQ1lsoPTKatvaM0cyF44
         49IR6/Q+9Ys89Ud95X0RQACg4RgWgS0WYTqalqxAJ6zEHVgCeL02UIN3hBWnxKZ/95Ti
         JaXbZIScwhHAMG9UXQ+4Vw2NIuzliZZNC/oxO1398uXvDAPsbYwxu/hAU5tR0efc1NrP
         AJNBA4TIeeqLvFMzfLeS4s1YPiF6PhydSL9blbCErh38cj+pltCov/xsmkNrvdgvZEap
         AnuHtsUGLbLW1EWlrwM0OSQCFzsQnlDBqmHt5t9n6CFl4bin2q70cm7Uvrcups8+ZkU/
         3dQg==
X-Forwarded-Encrypted: i=1; AL+hErHGfEv0tuj7Tqf6/KuVOvwVG1zeP9OuMtESho26mx67N5WHgY0qV5Z1J3m1BpuML5Mo28YsSBAuR+CknFL6kw4=@vger.kernel.org
X-Gm-Message-State: APuU4Z/Txgsk4Bv25RqvTlbEa7+itzgLuVwIcPvOfXWyiYggYYskrB6E
	DE2lq0wnF4MdJf0Z6ejA2+KcC5W3S5ydhTVAL2QvQHiiFqS7bn0fpkzxuASGF6nzJ8PveQim4Lg
	igd+qN7PI0JyE9FewxsapXgNvbvLXo4i4HL3VcNXYEgWKUZDMxM66ynm9QB2DHpx1Zgj+pvjRU9
	PbJ6Rl4z+oQTiPl/Wo1LcTVlzFzA8pCndn8wFladpB0frpcFKgKT4iEnlK8vx3XJPKyRX7D+cQj
	pmOA+dyWBXrTOEcktrv+qrTrt5y
X-Gm-Gg: AZFdTZdJ4hQ1YHJ3mSUuByVQWFnECor64UrqSsJdWdcEMJRilnj6ovtgIqHrek3Whs/
	pniQGbQ0faMQYYV7UmoxZ+skuAUCLTgiL7FTbhtMAFpbHPzmKzgWKBqzeiL585FGRidf1wW/chE
	phX99+RcXVjJQyZQZNT12mA06SZz9r5wDL1gFZ6H7zeLXyp0infvfugsaJbhrSMCc1wXmP/JDM+
	bmQZLwdqgy0cfAuC0QV5scZul5vLKq7HI22p5VWiGG86CcEnHWMzc/bE2FgmqldA7me9rukC+BM
	jkUKbDG2BR+tYOVVIAk+jwEdMBDgDxB/SGVHN3W1u8OUN13voGVrljkl8SzqEM/1w6ErxBNgxqT
	Jrv80xk0wGHkQ5h+0NvMIpg6eVyyxj+jEqKQgWN2ks4bnyh67Il2E8iBSP8eQi7/Exin3Qss4vl
	1f5claTOytDwTvZTLiySsVdN7ZTKkkRrReWsGtNvqRT6k=
X-Received: by 2002:a17:90b:4d82:b0:3b3:b71e:b2ee with SMTP id 98e67ed59e1d1-3b3d07c613cmr3793420a91.35.1795032835847;
        Wed, 18 Nov 2026 12:13:55 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-123.dlp.protect.broadcom.com. [144.49.247.123])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b3d8b8ce6esm868060a91.4.2026.11.18.12.13.55
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Nov 2026 12:13:55 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-55c644cea0bso28290351cf.0
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Nov 2026 12:13:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1795032835; x=1795637635; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mqEoSsDLRwiTtXF4QHzskVicsJt/6mayXvEhwI8woOU=;
        b=EsALQCsuXxhjbc0jqsPBQ6PY9AW7CUvHgg1WNFYHBdp3+Og8jxPxQ5hA8y1U4b72Y7
         7uPr8RyKF+Wd802sl5mW5dhHhacdP3515QnUN/OfZ2kUbIu1czYlJZYqgejHkoW3rRYn
         KFpqZ+gkZMWULEQXh6Igba9wdIX3gLZToMuIA=
X-Forwarded-Encrypted: i=1; AL+hErGudd1imK831nEwrCCXPPQk9ZO9XSL+RvwTQAt28xwcznoS9VFNWc+v444t8wXDkyfIa2TRpqK/blkuMuvC+XI=@vger.kernel.org
X-Received: by 2002:ac8:5ac2:0:b0:535:36d:dd97 with SMTP id d75a77b69052e-55d5a622c5fmr62137751cf.48.1795032834588;
        Wed, 18 Nov 2026 12:13:54 -0800 (PST)
X-Received: by 2002:ac8:5ac2:0:b0:535:36d:dd97 with SMTP id d75a77b69052e-55d5a622c5fmr62137191cf.48.1795032834127;
        Wed, 18 Nov 2026 12:13:54 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55d66c2a5a2sm7675091cf.21.2026.11.18.12.13.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 12:13:53 -0800 (PST)
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
Subject: [PATCH net 2/4] netfilter: flowtable: restore the GRE conntrack timeout on teardown
Date: Wed, 18 Nov 2026 12:12:48 -0800
Message-ID: <20261118201250.2075007-3-florian.fainelli@broadcom.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261118201250.2075007-1-florian.fainelli@broadcom.com>
References: <20261118201250.2075007-1-florian.fainelli@broadcom.com>
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

flow_offload_add() sets the timeout of the conntrack entry to NF_CT_DAY
for every offloaded flow, and the GC keeps extending it for GRE too.
flow_offload_fixup_ct() only restores the conntrack timeout of TCP and
UDP flows when the flow is torn down, so an offloaded GRE entry which does
not see any other packet on the slow path stays for up to a day instead
of expiring after the GRE conntrack timeout.

Restore the GRE timeout, replied or unreplied, as for UDP. GRE has no
offload timeout of its own, flow_offload_get_timeout() uses the default
flowtable timeout for it, so use that one when the flow expired.

Fixes: 4e8d9584d154 ("netfilter: flowtable: Support GRE")
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
---
 net/netfilter/nf_flow_table_core.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 2aa2647ed9df..051b15aecd89 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -237,6 +237,18 @@ static void flow_offload_fixup_ct(struct flow_offload *flow)
 		timeout = READ_ONCE(tn->timeouts[state]);
 		expired = nf_flow_has_expired(flow);
 		offload_timeout = READ_ONCE(tn->offload_timeout);
+#ifdef CONFIG_NF_CT_PROTO_GRE
+	} else if (l4num == IPPROTO_GRE) {
+		const struct nf_gre_net *tn = nf_gre_pernet(net);
+		enum gre_conntrack state =
+			test_bit(IPS_SEEN_REPLY_BIT, &ct->status) ?
+			GRE_CT_REPLIED : GRE_CT_UNREPLIED;
+
+		timeout = READ_ONCE(tn->timeouts[state]);
+		expired = nf_flow_has_expired(flow);
+		/* GRE has no offload timeout: see flow_offload_get_timeout(). */
+		offload_timeout = NF_FLOW_TIMEOUT;
+#endif
 	} else {
 		return;
 	}
-- 
2.53.0

