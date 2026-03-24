Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEAFF34A77D
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Mar 2026 20:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774384893; cv=none; b=WvjyOvQYQmIWaR0Ujjl3L2PUCXucCaqZrLmPn8kCYYQVB6KzHkpiY7+xkAGyYJiR2P8KZQ87vRpWUoL2hyHflsevo6BiCCLGcnPjHoonwjfsiA3iaonQkjb/+tQ6RQfJ7B0cWdL1B1XbJuMBLIxl7Iyy6Gv6sDofRhVNqUZ8wXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774384893; c=relaxed/simple;
	bh=JST0wXweMblcvbScw9Mq0yslegnTNej/ZY8bqddZfTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QDR7Tx4cSBVeXZ1m1j7Gk0gyfVZgxhqewMGwVrPqBCy3H7+bJlFWiTF3K4cHCLKPPvDR5fhp1DtkKGyonzmn4MW9xqQBjv1HDuzC3Pdr6YXI360tzPvHRv4fBdRZ5CZ17LIu1OYOJCrSJjFbAnIl3tuxL8knJ6FPTLgHjc+bDK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Kwp2MvlY; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Kwp2MvlY"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-48334ee0aeaso15630175e9.1
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Mar 2026 13:41:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774384890; x=1774989690; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BUoxypdfQgAMyIah8TMnPeb4KQBvT5cjozWxWchgdfs=;
        b=Kwp2MvlYjBPeV7omWDQ3PzTV/oqb/w2aKiE9f927+sUFTFntXw/muApuK5UunGe+8d
         svIjFyc3vraclWTTILt/eAjU6LENkAARTzMGw5K0k88mK1AJ0rqYvJsd6/Qi9GsDWshH
         JEwrH2Xbw/+/1w5HFupyUyZeUn7bSh5RfdgmMmxvxucnOASIAwA1kL9zziG1J1XH5lxz
         /5a1+YAtGrpyMOPfUwVpxCrBUTAhGivaPaIoAlZrY33F+BD1Pq7WQk/ereh94LXXq40e
         WYAEN2P0SNSE05H7jCtQ5aQwiEI7j2MYirZsRaqQhssQ5GrDq2YFlaL+K5qcEVfzGc4m
         3VTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774384890; x=1774989690;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BUoxypdfQgAMyIah8TMnPeb4KQBvT5cjozWxWchgdfs=;
        b=hiXDykrL0FfgVZFo3zQMbwt5v6Lghy+noL9WGRU5bvBcW35xBk3h2NTOAkCAGLWEro
         4yc/C/MblYvdYD1tEmQYn2GLeRbGXmKgcpUfDK1Z66M4u6rxTgPAo4thRvWsV60gyfst
         KuZ3Jr6hEGuP8Kqj0WCTLGsRvsbu+6hg5PnmikHyrqgyIDv9e4E80DTCyty+sN8oNZ+D
         lYM4NMZhDo2XAvxt4YTr2/L9JJPvWscOSMScGBus/BOUUrkq97R10bRlYRQ+jHHZ6w2n
         zkpplpmtG9yj9Z7GM5YS2C6DlBDX5t3a5viGyfOd/UyTSHOvpKiRCePtB2pSC+/ar+Yq
         jeIQ==
X-Gm-Message-State: AOJu0YwrOvY2LOwS4DBs3ZkQKWwbXPTnpt/u6Tx3NScMArBL3cceBZ3P
	x2Gy254pP0Oq4vcKzuNRxUFtOMVMdIjBkrzr73qq1QHt1sSPWtZMvPOjM0zyUm+8e2zhcw==
X-Gm-Gg: ATEYQzzbhWzMqAPiuSu+5QfuaHh/+Ot8SxGN4yQQHqbpStpuI3JmGwLl/07opCJbQM4
	mpHN5X36H2J2z879bKxqlsCIG9K70zb6Q/nQ5NdBfTaQi9V1F8HdO1v8IgvIeRPFBdCb2dkiEm8
	pNjb9VQ+YQrHPLvhOMvcVOVcDy127ZSXbFjcZ+wuSTh5vj8hChoNH40Nt6wpn7I+hM8B4ivhfen
	lyXqLWAC/oxi3PrlE4bxoVAjiIQakys3Ijfk8K2AwuBU3WtyhCuFs3+11OqHcdAZqjWyj0I/bbF
	JMh3JOI7gV7GA8IHMWhFkZ1BNjDUWjUSThmzeaAhpGO2TM/Ipnc0jDu2mbFamppYaPLDIp/QTH1
	YCrlxjJeXK9mI3UGbHwvRUbTNPp3MD4xzCWAVslh/NxWgFZzUMcUuPHPJ/PrE3NUUvagBtv+Lc4
	eJ7NvmRH2SIpH8rE8VA6OP
X-Received: by 2002:a05:600c:a0a:b0:487:288:1198 with SMTP id 5b1f17b1804b1-4871605ce9fmr17884155e9.22.1774384889809;
        Tue, 24 Mar 2026 13:41:29 -0700 (PDT)
Received: from azaki-desk1.. ([41.234.201.118])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48716658352sm3686825e9.13.2026.03.24.13.41.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2026 13:41:29 -0700 (PDT)
From: Ahmed Zaki <anzaki@gmail.com>
To: netfilter-devel@vger.kernel.org,
	andrew@lunn.ch,
	olteanv@gmail.com,
	pablo@netfilter.org,
	fw@strlen.de,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com
Cc: coreteam@netfilter.org,
	netdev@vger.kernel.org
Subject: [PATCH nf-next v2 2/2] net: dsa: update net_device stats with HW offloaded flows stats
Date: Tue, 24 Mar 2026 14:40:16 -0600
Message-ID: <20260324204016.2089193-3-anzaki@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260324204016.2089193-1-anzaki@gmail.com>
References: <20260324204016.2089193-1-anzaki@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Set the new net_device flag flow_offload_via_parent to update the
user net_device TX/RX stats with the HW offloaded traffic.

Signed-off-by: Ahmed Zaki <anzaki@gmail.com>
---
 net/dsa/user.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/dsa/user.c b/net/dsa/user.c
index c4bd6fe90b45..331bc581bce7 100644
--- a/net/dsa/user.c
+++ b/net/dsa/user.c
@@ -2807,6 +2807,7 @@ int dsa_user_create(struct dsa_port *port)
 
 	p = netdev_priv(user_dev);
 	user_dev->pcpu_stat_type = NETDEV_PCPU_STAT_TSTATS;
+	user_dev->flow_offload_via_parent = true;
 
 	ret = gro_cells_init(&p->gcells, user_dev);
 	if (ret)
-- 
2.43.0

