Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CB7982D8A;
	Thu,  7 Mar 2024 09:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709802461; cv=none; b=vGbUMJzte4hgmy23dkDSSYxDQaEe1yh/bb9K9z8JA+nj/V24uEIqbF4GMRCGNWQBvqVTgSlNu6gMEPCpqdzV9IIepkZbiWS0SXfkk0ka60/eqv5/Lxm+GPQO8qwYBPq/7YVjEj6WBE37DTzh3KPraQvtDruFOLj640Tn2TH3OnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709802461; c=relaxed/simple;
	bh=UxIu790UMq7PyKH4TgWNvaWUuxd7iDUECHp+K7YlsQM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZUWKbVv2qmj6Cy8ZiHplVFNOxCLqFAvgzCblCdt8fVuWS/7a7l61t5v9JYzWr8zhb/i03oAJtWNGFvVgqdt/kVRi3spzypw3gW0VrUJ9tDEUc3esIc46+3sfQEgjiplLU7QCGQ+0LG5rla70sZlBpQbLCcJOCwNk1WqNHCtZi8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cvbgPq1u; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cvbgPq1u"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-6d9f94b9186so637992b3a.0;
        Thu, 07 Mar 2024 01:07:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709802459; x=1710407259; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=isBEE2Kbh/RsWZtSJL5JZIHo/Vm1CNmsxYb0aYwtQ1I=;
        b=cvbgPq1uc8umrD3hP5Uvw4UE7598/ynoiJhVb0+WGUwdrC1ZNcduQXgFNmmf/uareP
         rV4XDDNXDuzPcYeEQqEnKsj3LIA5H2CaUKW8HSq1R+FE2zvvf47T245b7VHgBFv3Rwas
         noQI5oyWRCWInCCvC4KbonQ+vZ+kpoHAjQXRWqmo7pqO4nHOz4yhvWf67CN+PpECwobc
         m9C5OqRFX9G2pC6MZUaxkCtinxp5GAtqYamNrED1MLmb9AtfiD/rdCMumlJeHN4Cgyax
         qlnFgN60ODzetvWpfXZjw0ivjq68mkE6VD+ySiki2bcgZZt9kcKRicB85NpAgQpxtWN/
         Wz2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709802459; x=1710407259;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=isBEE2Kbh/RsWZtSJL5JZIHo/Vm1CNmsxYb0aYwtQ1I=;
        b=IZQLs7t06j3cPE4wuWDuohfqQuKD8J2wGIZcwInPuGVUcl1geYDMQpOLd8eBsSFmsM
         sCe7jzjtj2XuZidWoThZEQ1vG+TG/YKnzMILrDljexYCFCoG7EhaGr6cShVkFFpVNMjH
         bH4Fvb8UxDPxvEv7uzECcpzqRwlHkODjNpS7vdqHhyhwP+Pb6I4AF/Q62Ea0pE7aNVa/
         qmvkDOPKqEhgmmP+GqAMG+2xMIk0uYGLtcFWd2TlfjW8pKEP0jwPcoTV4uEHPQKhWMkv
         nyJFrA0vXsG0D17V+6T3d/Z9CuKBp3BrNxMUprm64hTwAptoMpg7GncNSnLzmvJqXptK
         wTJA==
X-Forwarded-Encrypted: i=1; AJvYcCUyII90YI9xGNo2EVXgfBxxyC+CHeSiOb94NRDfytfqDHpoZONWiKA34fDtaZqkADHXPB/bqNBb7dRh6gL1Gpx5ALJ5UNQ2
X-Gm-Message-State: AOJu0YyECCRcGb749jy1pILpThTBkdR04Kkcu+lTLWC/ts8sM7ub41vw
	yyZU6M7ygyC8SfgCkdcMnwTu/XGuCR1qd2SgLiEaKdXJWph/HGvHZrgFiB5i7V0=
X-Google-Smtp-Source: AGHT+IHua3E3u+tEamOkSDuiSY4F6VeNjSO0W/xG2LJha5CaDkJLVJMO2nFcx0dV8eUkCIcXbKrPkg==
X-Received: by 2002:a05:6a00:b81:b0:6e6:830:cd46 with SMTP id g1-20020a056a000b8100b006e60830cd46mr17395040pfj.5.1709802459443;
        Thu, 07 Mar 2024 01:07:39 -0800 (PST)
Received: from KERNELXING-MB0.tencent.com ([43.132.141.21])
        by smtp.gmail.com with ESMTPSA id s16-20020a62e710000000b006e5a6e83f8esm11176108pfh.134.2024.03.07.01.07.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Mar 2024 01:07:38 -0800 (PST)
From: Jason Xing <kerneljasonxing@gmail.com>
To: edumazet@google.com,
	pablo@netfilter.org,
	kadlec@netfilter.org,
	fw@strlen.de,
	kuba@kernel.org,
	pabeni@redhat.com,
	davem@davemloft.net
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	kerneljasonxing@gmail.com,
	Jason Xing <kernelxing@tencent.com>
Subject: [PATCH net-next] netfilter: conntrack: avoid sending RST to reply out-of-window skb
Date: Thu,  7 Mar 2024 17:07:32 +0800
Message-Id: <20240307090732.56708-1-kerneljasonxing@gmail.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jason Xing <kernelxing@tencent.com>

Supposing we set DNAT policy converting a_port to b_port on the
server at the beginning, the socket is set up by using 4-turple:

client_ip:client_port <--> server_ip:b_port

Then, some strange skbs from client or gateway, say, out-of-window
skbs are sent to the server_ip:a_port (not b_port) due to DNAT
clearing skb->_nfct value in nf_conntrack_in() function. Why?
Because the tcp_in_window() considers the incoming skb as an
invalid skb by returning NFCT_TCP_INVALID.

At last, the TCP layer process the out-of-window
skb (client_ip,client_port,server_ip,a_port) and try to look up
such an socket in tcp_v4_rcv(), as we can see, it will fail for sure
and send back an RST to the client.

The detailed call graphs go like this:
1)
nf_conntrack_in()
  -> nf_conntrack_handle_packet()
    -> nf_conntrack_tcp_packet()
      -> tcp_in_window() // tests if the skb is out-of-window
      -> return -NF_ACCEPT;
  -> skb->_nfct = 0; // if the above line returns a negative value
2)
tcp_v4_rcv()
  -> __inet_lookup_skb() // fails, then jump to no_tcp_socket
  -> tcp_v4_send_reset()

The moment the client receives the RST, it will drop. So the RST
skb doesn't hurt the client (maybe hurt some gateway which cancels
the session when filtering the RST without validating
the sequence because of performance reason). Well, it doesn't
matter. However, we can see many RST in flight.

The key reason why I wrote this patch is that I don't think
the behaviour is expected because the RFC 793 defines this
case:

"If the connection is in a synchronized state (ESTABLISHED,
 FIN-WAIT-1, FIN-WAIT-2, CLOSE-WAIT, CLOSING, LAST-ACK, TIME-WAIT),
 any unacceptable segment (out of window sequence number or
 unacceptible acknowledgment number) must elicit only an empty
 acknowledgment segment containing the current send-sequence number
 and an acknowledgment..."

I think, even we have set DNAT policy, it would be better if the
whole process/behaviour adheres to the original TCP behaviour.

Signed-off-by: Jason Xing <kernelxing@tencent.com>
---
 net/netfilter/nf_conntrack_proto_tcp.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index ae493599a3ef..3f3e620f3969 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1253,13 +1253,11 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
 	res = tcp_in_window(ct, dir, index,
 			    skb, dataoff, th, state);
 	switch (res) {
-	case NFCT_TCP_IGNORE:
-		spin_unlock_bh(&ct->lock);
-		return NF_ACCEPT;
 	case NFCT_TCP_INVALID:
 		nf_tcp_handle_invalid(ct, dir, index, skb, state);
+	case NFCT_TCP_IGNORE:
 		spin_unlock_bh(&ct->lock);
-		return -NF_ACCEPT;
+		return NF_ACCEPT;
 	case NFCT_TCP_ACCEPT:
 		break;
 	}
-- 
2.37.3

