Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2FF82BD59C
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Mar 2026 14:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773153604; cv=none; b=stPV9159PDSsQFBfBnRQw+tg8aibR6zgp1FwIzBqcpTqpdvHQPTfhRE1S4yuLCW4eW3raH7L2JLGQrDADqPO2Y5vaRxNX8e6iZOZ1Yxgb17iMRo8OBxfySgDdXOeKVBjcBYNYeWoarxnMNGXojfPbI0ciOih6d1K2rT8nNFfCwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773153604; c=relaxed/simple;
	bh=L4xLAL1Yd9N3tf7b58kM25ffJo7lGhOKBxE7vOJgMGA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YG9Qipjd8U31o9p2keY734TxL/RaunVAE0CVv9/vG5VfjUx7i6jJ04b4RyTab0WVd74EXz0F33wyTKZe3D+Uc3BKmNTykXasie2QAFUUcMGlI71h0FSWfQu3vUTxn8gR16yLnWsbwih7060MjF2tTcSaRJFN9m0WJT6NW6VftgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nR+gHcEq; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nR+gHcEq"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-485409ab264so11298075e9.1
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Mar 2026 07:40:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773153601; x=1773758401; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=N6ngMfURTFeoJUMi1m1ZTvPPLHw/F0vZbiU6NfPRFFo=;
        b=nR+gHcEqMEwBtPPMDP9VdBn5olqPA3h2iTsGpSbG+OCEzNakqnedQA7mjUjmVb3dPM
         Y8ze5S9XSFx48NGt5z873lrWput+EpP5djD9qrGkWYn3Dk6K6Btm0PFMTWuCrhf/Z0X7
         D0dbPWeh7eqh4zBf8lyvHtzBgOrqowFngy2gzj4gDoC4VbHLHxfDnlPlHiUfIEr69SOW
         iVKpsXPcNFZxyBEr5LIIqYdXRBtC7+midXqh5T0Cxgghs8qjKb9vN7XwDKmgTFVuJm1G
         A725hGvYVPTS+3S4drEBiHzPMAIzozaLafWOWyYrIN1mMZi9LGAXXAus/xgF4gvqEXQj
         ezcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773153601; x=1773758401;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N6ngMfURTFeoJUMi1m1ZTvPPLHw/F0vZbiU6NfPRFFo=;
        b=YfNE+m+88DMYWRIlzSft8gwHVD+sv1YM5PmiGd6HEZqDDPzixZQ/5ELt6x3P/gLWSr
         qwfmYVCUvndUM+zP6aj4mPEMaE7TyvLw927df9EspNI3d09FmYbRbgNHzOLRwOh+lqFX
         7M4QzY+G99yZogpVmqdlzb+md9Cv49Y0Tbk7Wu677qMeCIVe1ywk2n7K4txXkGcWPUk8
         L7pXLjorfwc+cNOJt5aQ61ds1CMl6qa83CS+osZzBjMPBu0iIcZrMqbZqsUpJDcqeuGA
         AfDv2DR2GXubT7xzOvd6YhZSCaoAOuizXqEvPuB0MtcL+/Vh+04XMvdt5Lr8ibsiulKs
         cctw==
X-Gm-Message-State: AOJu0YwJqhmpI+h4NZyNLH5ocWDLHMUz8o+DnAsM7foT6gOQcrDR3WB9
	VN1oCK+DBkwHaQUlnN4P9ETQmNjrnExUT2uLb78uA47Wo99pDG9HBYTd
X-Gm-Gg: ATEYQzzIZiZz0tQj4ggwqKgvwB10GBE6qiCLOGfrU+8Jvyl36xk0Wx5K2Nh3Fy9yAix
	C/PUjiQse4QgEaxqJVBP/eVrX7ccLu78EWWZMlnVXylcLKJ9RakBuiv8v+99VevhM0RstcF1hjC
	shV+he8fp3SXq/SghdzssWjuLiLjD4zsXRY2Q/XhKm7Ye1zdrCZicR0RYYE+oyV+i0ECKn41hAz
	MITJ3LEpB5NKExO+pRdHY7Z1QKklMWQnIRMiWO8EjuO4xMwwI7vL5XTt0ri3DR7QAuG4AFDVq5x
	nJc92Lv6NeNVTPbiepJ9S/o2kTMw4BtjVQB3LGwb9qt9ojIABBQNO94hSh/xSe0iRNC2ckMx3q6
	4Q6wfUfmyHEeallNh+fMzbJtQ/wfoaxx0hj/PKbBlBPimK11ULKPs7hGYJsZJEnl6NruF8ZCwia
	J4Q1C94crMEALt+Sc+6KGaAvCcsdwflgGRzUCFFnXvIFxlpXGESDNYslWblMuup2UlMZgK1pqOC
	wdzUbDh5+3DRkRHFD7e+wAaendQWD9YRkI5nBXaig95wEen1TfZkF4=
X-Received: by 2002:a05:600c:4744:b0:485:33b7:573d with SMTP id 5b1f17b1804b1-485419a2810mr58456235e9.1.1773153600816;
        Tue, 10 Mar 2026 07:40:00 -0700 (PDT)
Received: from eric (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-485358cd26bsm141661055e9.8.2026.03.10.07.39.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 07:40:00 -0700 (PDT)
From: Eric Woudstra <ericwouds@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>
Cc: netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH nf] netfilter: nf_flow_table_ip: reset mac header before vlan push
Date: Tue, 10 Mar 2026 15:39:33 +0100
Message-ID: <20260310143933.354257-1-ericwouds@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With double vlan tagged packets in the fastpath, getting the error:

skb_vlan_push got skb with skb->data not at mac header (offset 18)

Call skb_reset_mac_header() before calling skb_vlan_push().

Signed-off-by: Eric Woudstra <ericwouds@gmail.com>

---

This patch replaces:

"netfilter: nf_flow_table_ip: Introduce nf_flow_vlan_push()"

 net/netfilter/nf_flow_table_ip.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 3fdb10d9bf7f..fd56d663cb5b 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -738,6 +738,7 @@ static int nf_flow_encap_push(struct sk_buff *skb,
 		switch (tuple->encap[i].proto) {
 		case htons(ETH_P_8021Q):
 		case htons(ETH_P_8021AD):
+			skb_reset_mac_header(skb);
 			if (skb_vlan_push(skb, tuple->encap[i].proto,
 					  tuple->encap[i].id) < 0)
 				return -1;
-- 
2.53.0

