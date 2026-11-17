Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794916282;
	b=Ic5wY6lYPQzZhZf3ppHA4nkAoz68Dw2pipLU9FxlkT9WpzmRRnUmbZxH0z/Wl1lLPAny
	 iJ3M8c6mRdKFWeDMx4xVInQRA7sN9k0LM1iXMgtDgw3k7hVGbJTDAkCAIDufL2hq52or/
	 kOQQcJ8f4vqvwmM5jdhCuHfWPIyXOTviipBwhDGSFeCQFrMFio989xRTMkucwNX4VeKhf
	 FULNDW/L6vuhcNVHDBozkCX61JFFIXBUBsOSyi0edlACBdjKJ2elhZrbK4QCUfxHXUdmy
	 GQH+GPP5mhemGmni5azUEhZnc1sTL4ug3qiQgBIkYR0lSoRAxZ9DGVz0seJB47FA3AQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794916282;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=Q/43EgnyXmu8zGfnIPtnl/G4lTIWzZST8qI59NEVzXM=;
	b=1Z3S2Xm91//7Y19H8NtulnbYXsbDBb3AJTnflkXk/YWAye0qd2NhdO5fz5TFSi0/jIJl
	 kcR9eN8V2Q1ojGmF4JyfS2DgkVRgoenfGwSmWp7Zi4gkgmE4NPACBSgjyhLpHPEmSFW0A
	 6QtUy10RI8DWqy9wYeTsd5CXUWiaKhSRSZTpKsIJET7B19sFejaB75uSYuVDqfW/KwRTj
	 qTusl68/yHeOo98z+f8Gw8WJKcLHDD3WLbB1r/SS0QPsSud7bWdy7JFcSQyJlcFSiA1tZ
	 X3NbSVY5YpEBQGpsk8YujlannW8dDHghabm4laA3PuuWc7kmObIuvmgIX/sz/ytmM3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEC40606A31C
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Nov 2026 11:51:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BEC40606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 3C67E6055A; Tue, 17 Nov 2026 12:51:20 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 6/6] netfilter: nfnetlink_log: only add timestamp on the input path
Date: Tue, 17 Nov 2026 12:50:46 +0100
Message-ID: <20261117115046.15435-7-fw@strlen.de>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261117115046.15435-1-fw@strlen.de>
References: <20261117115046.15435-1-fw@strlen.de>
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

The timestamp attribute should only be emitted while the packet is on
the input path, like the hardware header attributes.  On output hooks
skb->tstamp can hold the SO_TXTIME transmit time, a delivery deadline
rather than the time the packet was observed.

The old check compared the raw hooknum against NF_INET_FORWARD, which is
meaningless for families with their own hook numbering: it was too
liberal for NFPROTO_ARP and NFPROTO_NETDEV.  Use nfulnl_pre_egress()
instead, so those no longer emit a timestamp at their output hooks.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nfnetlink_log.c | 32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index ee006d9df0a4..ac3912bbacb0 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -548,6 +548,22 @@ static int nfulnl_put_hwheader(struct sk_buff *nlskb, const struct sk_buff *skb,
 	return nla_put(nlskb, NFULA_HWHEADER, len, hwhdrp);
 }
 
+/* The timestamp is the time the packet was observed at the hook.
+ * Only called while the packet is on the input path: on output
+ * hooks skb->tstamp can hold the SO_TXTIME transmit time, which
+ * is a delivery deadline, not an observation time.
+ */
+static int nfulnl_put_timestamp(struct sk_buff *nlskb, const struct sk_buff *skb)
+{
+	struct timespec64 kts = ktime_to_timespec64(skb_tstamp_cond(skb, true));
+	struct nfulnl_msg_packet_timestamp ts = {
+		.sec = cpu_to_be64(kts.tv_sec),
+		.usec = cpu_to_be64(kts.tv_nsec / NSEC_PER_USEC),
+	};
+
+	return nla_put(nlskb, NFULA_TIMESTAMP, sizeof(ts), &ts);
+}
+
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
 static int nflog_put_master_ifindex(struct sk_buff *nlskb, int attr,
 				    const struct net_device *dev)
@@ -681,18 +697,12 @@ __build_packet_message(struct nfnl_log_net *log,
 	if (nfnetlink_put_hwaddr(inst->skb, skb, indev, NFULA_HWADDR))
 		goto nla_put_failure;
 
-	if (nfulnl_pre_egress(pf, hooknum) &&
-	    indev && skb_mac_header_was_set(skb) &&
-	    nfulnl_put_hwheader(inst->skb, skb, indev))
-		goto nla_put_failure;
-
-	if (hooknum <= NF_INET_FORWARD) {
-		struct timespec64 kts = ktime_to_timespec64(skb_tstamp_cond(skb, true));
-		struct nfulnl_msg_packet_timestamp ts;
-		ts.sec = cpu_to_be64(kts.tv_sec);
-		ts.usec = cpu_to_be64(kts.tv_nsec / NSEC_PER_USEC);
+	if (nfulnl_pre_egress(pf, hooknum)) {
+		if (indev && skb_mac_header_was_set(skb) &&
+		    nfulnl_put_hwheader(inst->skb, skb, indev))
+			goto nla_put_failure;
 
-		if (nla_put(inst->skb, NFULA_TIMESTAMP, sizeof(ts), &ts))
+		if (nfulnl_put_timestamp(inst->skb, skb))
 			goto nla_put_failure;
 	}
 
-- 
2.56.1

