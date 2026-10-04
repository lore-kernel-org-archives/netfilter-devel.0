Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D0A4718D3
	for <netfilter-devel@vger.kernel.org>; Sun,  4 Oct 2026 17:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791134199; cv=none; b=ogdOKq6eHNCwHPmWtHRPX755aoxBEB998Tjqi4mvbuQ7/P/ErL2SEbTGlxq6WDJmbtlOuRzvrR4MsLjwA+3XpaeXGTs/7HCmKdANhD3yHElnPudIAIi2aNxg5709C2AvAKYifZyjvlkt4+XAvrdJaXb0TUb+WL3cgnuCnO0T3PY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791134199; c=relaxed/simple;
	bh=fnDmQBxhOnOzTjP27W0omZjVCFDehhZddO82fJQi+aM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FBM6AhxgbCP8g0Xni0/T3TH+Hi2tcvOejGrlUcfKL1cU0HoHfYeW4sF7+SiXYA5mFHEExsz9JS3xY6vRJ8xvxfAHmD4WQ7gyag5lTZBK4M5T339cufV3arBo/f7Q2Abeu5NMAM8BSgMkY3vQ6YQ495IpWfopvSgS5Y0/Uzrj+Lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=ZoM94L/q; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="ZoM94L/q"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c2e2db5e8e4so190971566b.0
        for <netfilter-devel@vger.kernel.org>; Sun, 04 Oct 2026 10:16:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1791134190; x=1791738990; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MmNComV3+ZHbZ6goXTWe+Pc/3ipzZ4UsXOvFwMxOIvk=;
        b=ZoM94L/qjN2uSSjYUwazhuaiBmf8QQQcHiP9VyB1GA61kr1ONaWGSb4u+ZXY+qTVzk
         9cNHKWrOrZIZzDxBOY7V+2hoH5/PP/6vHKn5Ruksnb8o9Dvk6oU3kTa55Zg6JblmB7g/
         fdX37y/GpeFhU889LbRdUX2hNjqMCpGA//NhtBXYqVtAFnYYqN/O0KZwljrMY3xrn8El
         D/p1Ji6+DCc9axa6Fd/2AwrOZfLXr9QOZJxgcPHvaBrsYF7SXjRLqlyjhVn+xXoAWh+r
         wr7oO/zSv+ah1EFfWywPS6S3Ynme4SzUcmVOODdbS88PtuwuRXl7osa2BlSbpvEnIewT
         nlLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791134190; x=1791738990;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=MmNComV3+ZHbZ6goXTWe+Pc/3ipzZ4UsXOvFwMxOIvk=;
        b=L21Fc93i/USl/t6sw6UWYt0/Qqk27Insz7Wjnr1XG/3UGK7cFKfjNiDijTBNThQ4lA
         LFlbdTE2KUL9vJFNknfgoDp84SfIviFPpHtVsSbNtbNA5Uz4x9hXxH02gNUksfbJ3pUs
         pMargQRhA1nQKd/dblYGBu+NuY/QUBJU+sxjaBeX+mYn5Go7LiDXA0zyOEV9bHUhm2/k
         IdpnVtYNUXsKQxt/ZiDgCYrzAgBzlpNQyBUpH1aPQOc16BY4vZ9o9NZH79wDAVBv8aAm
         33oTA/0UWs0WbdGi3JmGBMzXplANw6GahP2L4/ZW48OMalhqVfIUyoGrnPdbw1J/WePn
         LI0w==
X-Forwarded-Encrypted: i=1; AKwUvBzsxXphY92jJGzwFGoX9OQTXgR86kagGEU9RvKEXPKifZtUj8sQ0x3/wcJT4jbmWdBOAvb3xse9VjqwALgpXVw=@vger.kernel.org
X-Gm-Message-State: AFuF++kfDh3vG9gFtPVouFbo3SQVOjg7fDkWyax/w3pwqQHJx1XCVA3H
	b/FOOaR+iqcDu4wGaKZOygXZ0kd2xpdCdEbTDLthTxDXItboqRMXTkp/bCkGUwzzzQ==
X-Gm-Gg: AYBFou0gzErXP0AG6JaR3+ji94fIVLLqMPaqwg/kq2c0srPhmobEbLP5fAptz9ckGvz
	BfRxhuH6CAr6iKMOn8kfe5aIMUzarspUOzJRRG0hdRD0fulXsYig2B0uGxhBuMqbr1DEqzw4AhM
	yEBxekZDXEr29kfZ+zrmtyc1YQvtFmDQHnDREzEh4Q5bBpcMMZCA29JJw1n+Eas79fB9VuLE9TM
	IsNN7jEqBORgRaQL0z7ipHp3ULRHYLv0pAVSOpvo0ErUAYEtdhT0aYkVKgTgUclqBMvh3PB2CjF
	FmfGjasZXMxa8NsZ+rQ0CPloPnu4LANr2pksVwnVlvDDLNcWGW8OP4mmHeM8Hy5MMX+1uXFGGk3
	CcdQqUYFsZR7J8pgIv650inQaF3fKtptAfmBnoXY42E8F+flyKL0bZh9lC9beb4doLBRKpiK1uL
	iwZgCMDq43BwgYHgznHUxKe9emyXCr5MerjEE6cxQG/gl3y/VcvK0OjGUBuCP693h+N5kgCK/RW
	SC2zjmwrLshs5yHRwD4gG5zbplgIVGDljOe8bFBiG6EMmcACW6a/EjByhPCyeODcdldl4qQpsKc
	wWCn9JFgbrq2JMJ39RB+VAjzLlzlLF0q+BJT0es3d+FUeBMWEeLx35ZltN65LBWLr7fOmRj+Smg
	h3TUPThCLEUNSQWn12W/VHTjSUTVsn659MR+NZ8ky2g7S98jz5GnhrlDw9YHEvC8Zd5h1xwg+CI
	N0M4/qRv0/isIQIrOO+7B2E3WhNISKW2aTdA==
X-Received: by 2002:a17:906:794f:b0:c2e:49b4:ab8b with SMTP id a640c23a62f3a-c2e6ece55e7mr448593666b.8.1791134190462;
        Sun, 04 Oct 2026 10:16:30 -0700 (PDT)
Received: from Desktop (pd9513667.dip0.t-ipconnect.de. [217.81.54.103])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2e4cf9ddbesm317345166b.69.2026.10.04.10.16.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2026 10:16:29 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: pablo@netfilter.org,
	netfilter-devel@vger.kernel.org
Cc: kadlec@netfilter.org,
	fw@strlen.de,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	geldot@protonmail.com,
	shuah@kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH nf-next v2 1/4] netfilter: conntrack: pick up a TCP flow whose SYN was never answered
Date: Sun,  4 Oct 2026 19:16:25 +0200
Message-ID: <20261004171628.3544978-2-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261004171628.3544978-1-julius@bairaktaris.de>
References: <20261004171628.3544978-1-julius@bairaktaris.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Gary Dotzler <geldot@protonmail.com>

When only one direction of a connection passes the host, conntrack sees
the SYN but not the SYN/ACK. The client's next ACK is invalid in
SYN_SENT, as is every packet after it.

Had the SYN not been seen, the loose pickup in tcp_new() would have
taken that ACK, with window checks off in both directions. Delete the
SYN_SENT entry and look the packet up again so that tcp_new() picks it
up. This applies only with nf_conntrack_tcp_loose, without synproxy,
before any reply, and to an original direction ACK at the expected
sequence number. No TCP state or transition is added.

Signed-off-by: Gary Dotzler <geldot@protonmail.com>
Assisted-by: Claude:claude-opus-5
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
 net/netfilter/nf_conntrack_proto_tcp.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index ad6f1986d52a..31bd4b926e48 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1173,6 +1173,22 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
 			return NF_ACCEPT;
 		}
 
+		/* No reply seen and the client continues after its SYN: the
+		 * reply takes another path. Recreate the entry through the
+		 * loose pickup in tcp_new().
+		 */
+		if (tn->tcp_loose && !nfct_synproxy(ct) &&
+		    old_state == TCP_CONNTRACK_SYN_SENT &&
+		    index == TCP_ACK_SET && dir == IP_CT_DIR_ORIGINAL &&
+		    !test_bit(IPS_SEEN_REPLY_BIT, &ct->status) &&
+		    ntohl(th->seq) == ct->proto.tcp.seen[dir].td_end) {
+			spin_unlock_bh(&ct->lock);
+
+			if (nf_ct_kill(ct))
+				return -NF_REPEAT;
+			return NF_DROP;
+		}
+
 		/* Invalid packet */
 		spin_unlock_bh(&ct->lock);
 		nf_ct_l4proto_log_invalid(skb, ct, state,
-- 
2.53.0

