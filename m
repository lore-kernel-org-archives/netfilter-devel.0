Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6EB6182C5;
	Tue,  6 Aug 2024 15:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722959048; cv=none; b=WzEjiFZHNY5h61GEEbLxYRSt1UHe6isJw9TL7w51xB7iex9VHYKNogw9yrIhxMEjJ5ZXEmEJrWcezA+8iXzvkUOz5oQImxEWw+Zt9J2D1hycS8686e6m4LmxiSMptF8gF1VkMVaNypotDhaUQ+nPQQIkOYOeYyLiMambVudd8Dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722959048; c=relaxed/simple;
	bh=lQORiky/o9jQN/c7KAdbYxpKpsT9jXk3AnbwddBVEes=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SdzLF4xgmM3OBhrmdGx31MoVzdsvj7hTZWZwV7qzRGCp51eZFqbjzO1uT4HnGnpJ/r6bSfsKjA5fx0QpGa2pUO6fkiNYwcWvnnAkcav8ptnVMQcGUnpnbc+u6Xnm8X8gDRAg4hOOiXUTJJgf3D6jycugPba8e7qpdb1nimXy5N4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=alcfUekQ; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="alcfUekQ"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-42816ca797fso5503605e9.2;
        Tue, 06 Aug 2024 08:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722959045; x=1723563845; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OcE+mF3GrEcCyIj3G6BtAWvsiNt/2l645H2klOnkjyU=;
        b=alcfUekQdBbhz/qYXjuIlgdSfOw/JP/VHetZ5LozGOtt40cMsH9mo1S3QYkggfBZW9
         ybH3A2JoqVuZQqNWw37wJ4/VIQ/PXkodBzMy0U0dQ86LGknmXaR1I8Wp4PIIWcrB1Tfy
         bGvkqHAXQ/f+9egfhsn0XEh1XnNkKpn2JZ/Sm4gT3HsAXT5Run7upVUvkeKQhogtfFWt
         5sCvys1ILFcIYVW+d/h2Itx7Z1iJ6xnaR+xprapRJ83AQPfens+uOch3Vbdz3RLg/hpj
         MotnQAQO9oi9mqkmsM5VN1TyYDCfba3IoIXydQNhQ40GcMzE7bty8Rqopm8lWk1+UNnI
         8ysQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722959045; x=1723563845;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OcE+mF3GrEcCyIj3G6BtAWvsiNt/2l645H2klOnkjyU=;
        b=dGZanrfg/GBOZGNpoEaalMd4tQ7l5Db4R3KThaSdsgWO+fkqa1wBs1MzsOdIVOqgTi
         Z9e72mhjpGifEztsGyy4S7LaK/4qAGjOJ2tJERos5STPw+AZY0jBSEh2/mHBzHSdNdDN
         N+pTKSMcfweSNx6+JzVwlCv2tCBcvw/Irw+LO3EWwec0sKycF9XpkZXh6I4R/bEQJVLf
         Efu3kVEoO0VhUFrDSOe0brtPHXfvqry+4Oh6AsLn2AiqIjF6MS3fk5AiCj8EoIuwGaeM
         vVLa6GtsZeCh8Ox3TillPWZW5hxqkWEeWJkFA3NtduJzOXIZS/C0zQF1cIiPATWMLiXN
         BsIQ==
X-Forwarded-Encrypted: i=1; AJvYcCXiiIU50KF3HLyGGBrE+UfBTKHdQcx3d54WF+NvLe44bTzi5LhG3vSLm5RiW9RnE1Ie7v8i++Iy1Lbe5dv+pr87jvyreWg2i1TMHFyLwoiWsy83kfSOcCOoV7KeSa0NAcW2hxTGouqX
X-Gm-Message-State: AOJu0YzNLhboUexziCw64vx9YLlo/9DMuyofjnd144nyXXpiYtSywG65
	VjZDMkH4HzyZksfh+nhARDBQ+wwzuvYVazBnt+Mu2p+W1ct9P6leeJ0ciA==
X-Google-Smtp-Source: AGHT+IFbGcmxJ5OZoEGgLWm55zohJe5oJtSyRceDFHi2rH0+DddbHS9poRDICuRdZuEEBzH3mM1z/A==
X-Received: by 2002:a05:600c:45d5:b0:428:1007:6068 with SMTP id 5b1f17b1804b1-428e6b924d4mr111980295e9.34.1722959044707;
        Tue, 06 Aug 2024 08:44:04 -0700 (PDT)
Received: from imac.fritz.box ([2a02:8010:60a0:0:464:e826:cfe4:a57a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-428e6e9cd4esm184621795e9.44.2024.08.06.08.44.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Aug 2024 08:44:04 -0700 (PDT)
From: Donald Hunter <donald.hunter@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org
Cc: donald.hunter@redhat.com,
	Donald Hunter <donald.hunter@gmail.com>
Subject: [PATCH nf v1] netfilter: nfnetlink: Initialise extack before use in ACKs
Date: Tue,  6 Aug 2024 16:43:24 +0100
Message-ID: <20240806154324.40764-1-donald.hunter@gmail.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add missing extack initialisation when ACKing BATCH_BEGIN and BATCH_END.

Fixes: bf2ac490d28c ("netfilter: nfnetlink: Handle ACK flags for batch messages")
Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
---
 net/netfilter/nfnetlink.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 4abf660c7baf..932b3ddb34f1 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -427,8 +427,10 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	nfnl_unlock(subsys_id);
 
-	if (nlh->nlmsg_flags & NLM_F_ACK)
+	if (nlh->nlmsg_flags & NLM_F_ACK) {
+		memset(&extack, 0, sizeof(extack));
 		nfnl_err_add(&err_list, nlh, 0, &extack);
+	}
 
 	while (skb->len >= nlmsg_total_size(0)) {
 		int msglen, type;
@@ -577,6 +579,7 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 			ss->abort(net, oskb, NFNL_ABORT_NONE);
 			netlink_ack(oskb, nlmsg_hdr(oskb), err, NULL);
 		} else if (nlh->nlmsg_flags & NLM_F_ACK) {
+			memset(&extack, 0, sizeof(extack));
 			nfnl_err_add(&err_list, nlh, 0, &extack);
 		}
 	} else {
-- 
2.45.2

