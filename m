Received: from mail-ot1-f68.google.com (mail-ot1-f68.google.com [209.85.210.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02BBB81E;
	Fri,  5 Jul 2024 04:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720152038; cv=none; b=XM4POc7h58XVDC5930naz2SC+qFMkwu4o54OL8IOOqoVH+j6s5lRitbdbaiK39QAFm1/9ttCfSn+QaDamwtDUPldFYjQgH55BeRNMECSe7BofLlct0jb2IR0USqTyCLpKuTE5yR23iPqS90cPScBt7Jf9kTbl5jzKj/l2MIqVxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720152038; c=relaxed/simple;
	bh=WaumuGDGrorQizvhwn22mns7Wbc5Sh2UiLhtc9m1eCg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Csjnnort7cbI3RkcghyTSMfSz4K1odZZ1OERosyO5GyD4HUPLIyk+exKusAoxYrOtxJmADqUP/kweUfQRyVYeOGQK4Q/r58MrOdWzgmsj84ICgXtOVSMOWzRDiTgOJP/07gHHsvN5TjwU0QB4Icg56dR+ohWOwzn5aAhHOLpjtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CFYh9zvj; arc=none smtp.client-ip=209.85.210.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CFYh9zvj"
Received: by mail-ot1-f68.google.com with SMTP id 46e09a7af769-70211abf4cbso802238a34.3;
        Thu, 04 Jul 2024 21:00:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720152036; x=1720756836; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vkEn4BlrQbhC1pOzdi5ltRctTkOQPmmbMk4HFASDkZk=;
        b=CFYh9zvj48ZLxAEwqfL79ELsOs0RjA3MKaA1bn032Z1wmRAagnEluPS+pyOvz7AeXs
         t+cuz/7pBY3mBnqRYp2/YCBZZguW/7Az+/ff60xbT1IfV0liSzJpIte3uL2sTOVyrOy/
         fyO4jL7fXq13DToVGuGBl0/0/CcpuyNXUsgOj3CGyOQfV9rckn55TBpB40DsjRTFs8Hw
         aQmaxjjeTyAq7bZ5xwcGlh/0Gem3BThnkFhx5icFsrN8f4JGq7B974Er14klSKF+eOwZ
         LFtDePp4iOil/iUDe0EjECyyQAPFRUtFuXuuhRLL9Tn8ni8XsRHyqQeTi+1RcrkfRSWx
         V4vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720152036; x=1720756836;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vkEn4BlrQbhC1pOzdi5ltRctTkOQPmmbMk4HFASDkZk=;
        b=Zr889/SvVuCgk0xQeTe8LRkzmGXAovNwYFgEV7GVfsVdC8ib5Q3Vi1j1IBBTUemykp
         rcvX1+Ea/5O3pNNyyYKxgZhmbR/mpIuw6hHBZZYaLOAsI6xcsrkTHAXGH6y9TOrX8xD6
         Bnncg06hpZPS37X5EtWvK+03UCfSXiX4+hVa/xDpqqsVyfF+oN/yO8sk1E7e+2vkybGT
         CYlxK85gVTrv0BxFH809EWpIWAgS5uKaXaiXNX8MRAje+QmvlBR2HXVRvDj5fwjrGOz1
         ABmsh2JbFyH+eX3c7tinJm4g7T9W0NtR+rcr7dp7YAnmOx++PfvGTFLP/WrxMi8czsBC
         f2ag==
X-Forwarded-Encrypted: i=1; AJvYcCXEZgnlhPgQ+os4QETF8uWrweade5cQippcG8ZQoadfGb0zJjDRLZ1LA88zyGVmm2u0KHn88IVwjiQ2v3hu/cuM8NN8aWcqOWxGWul+1Q9POrGkXBj2Aus11MYFP3O+HKseBg/ler1qV3XAfov9t8Vxz+y8+UsT9/UhOUgswv6OASuBCfB3
X-Gm-Message-State: AOJu0Yxyf+KnKzRTP4RY5SAX10cDxVSz/L75WUsDUYgKQ8EFuWu+240z
	KBq5ogOFQo0LbT05klq3YqqB/l7zZUjHxGmGKTuXqRARUMJFiegm
X-Google-Smtp-Source: AGHT+IEzVcTG/3nA8s2W+/eTJlO4NkviPp0EvCHcEHRkzD3jDNBYwIycFpwpA+78ZiLgpE6T2daCrg==
X-Received: by 2002:a05:6871:548:b0:24f:eada:e32 with SMTP id 586e51a60fabf-25e2ba220f4mr3167869fac.17.1720152035861;
        Thu, 04 Jul 2024 21:00:35 -0700 (PDT)
Received: from localhost.localdomain ([166.111.236.150])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-72c6afb54basm8809424a12.39.2024.07.04.21.00.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jul 2024 21:00:35 -0700 (PDT)
From: yyxRoy <yyxroy22@gmail.com>
X-Google-Original-From: yyxRoy <979093444@qq.com>
To: pablo@netfilter.org,
	kadlec@netfilter.org,
	gregkh@linuxfoundation.org
Cc: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yyxRoy <979093444@qq.com>
Subject: [PATCH] netfilter: conntrack: tcp: do not lower timeout to CLOSE for in-window RSTs
Date: Fri,  5 Jul 2024 12:00:13 +0800
Message-Id: <20240705040013.29860-1-979093444@qq.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With previous commit https://github.com/torvalds/linux/commit/be0502a
("netfilter: conntrack: tcp: only close if RST matches exact sequence")
to fight against TCP in-window reset attacks, current version of netfilter
will keep the connection state in ESTABLISHED, but lower the timeout to
that of CLOSE (10 seconds by default) for in-window TCP RSTs, and wait for
the peer to send a challenge ack to restore the connection timeout
(5 mins in tests).

However, malicious attackers can prevent incurring challenge ACKs by
manipulating the TTL value of RSTs. The attacker can probe the TTL value
between the NAT device and itself and send in-window RST packets with
a TTL value to be decreased to 0 after arriving at the NAT device.
This causes the packet to be dropped rather than forwarded to the
internal client, thus preventing a challenge ACK from being triggered.
As the window of the sequence number is quite large (bigger than 60,000
in tests) and the sequence number is 16-bit, the attacker only needs to
send nearly 60,000 RST packets with different sequence numbers
(i.e., 1, 60001, 120001, and so on) and one of them will definitely
fall within in the window.

Therefore we can't simply lower the connection timeout to 10 seconds
(rather short) upon receiving in-window RSTs. With this patch, netfilter
will lower the connection timeout to that of CLOSE only when it receives
RSTs with exact sequence numbers (i.e., old_state != new_state).

Signed-off-by: yyxRoy <979093444@qq.com>
---
 net/netfilter/nf_conntrack_proto_tcp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index ae493599a..d06259407 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1280,7 +1280,8 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
 	if (ct->proto.tcp.retrans >= tn->tcp_max_retrans &&
 	    timeouts[new_state] > timeouts[TCP_CONNTRACK_RETRANS])
 		timeout = timeouts[TCP_CONNTRACK_RETRANS];
-	else if (unlikely(index == TCP_RST_SET))
+	else if (unlikely(index == TCP_RST_SET) &&
+		 old_state != new_state)
 		timeout = timeouts[TCP_CONNTRACK_CLOSE];
 	else if ((ct->proto.tcp.seen[0].flags | ct->proto.tcp.seen[1].flags) &
 		 IP_CT_TCP_FLAG_DATA_UNACKNOWLEDGED &&
-- 
2.34.1

