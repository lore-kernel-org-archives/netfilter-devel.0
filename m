Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E178A1C20;
	Mon, 11 Mar 2024 07:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710140760; cv=none; b=l5ZnHGAfFp3ja8yjAPxrdE3vyku7VamJlBt+wB5l564DrLgv1U13LpNZBf6Fzkd8NAc6iN+Z4sdNsNFQtDokfzr8r1fyQkW7/U8FlU7LkgsLKXam659388y6WATvKCxEW1SskPYSOkSBDL8WnboKQY59tohkNn7p81iFAIirr1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710140760; c=relaxed/simple;
	bh=dkXn7q2DmB4nUnNs48hqh1yxF8euNmEQbXYa3VzdpYo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=bA9GOSPrltujtPwbm3sO7zdehhtsMogAEHx8psz5KgNPu8KShrG1D97EnooNhKWmBPAuNsU3P+/5tEjwXRgpB9bZuY6/e48HBgU9xUj6+sq0dtG+rj2m/+cKnUxNW+T/0BbHbowP3HlOyaa1ZImZ8/8ettZNHIbI7oOrJ/zprNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NubpE3SD; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NubpE3SD"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1dda51bb52eso1095645ad.3;
        Mon, 11 Mar 2024 00:05:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710140758; x=1710745558; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DLbH1FpL/W1pRCQh4HZ1seSYIOwW3M1UWX44cGi5xdA=;
        b=NubpE3SD2npmfOxm7ecMEky+/CAT5dZDVGrkfF7GRI5PiA3sgL0PNjxPfQo4H0SY3t
         i4o56gTJrTjR2T2sJdP1vc4TAsii4kzX+Mp0HJUqklBlbynOGDn6tTD9ZkBkXyrIF95w
         ww10YVhy88+K7ent1QcEUmGmXEWN5PczhRqMR4ZiyLGtBkf0qbg6Lz+Ng0rDwjnFKUP6
         1sNY7BzHyk8RCQoKPZX6QdTEt4oBxxq7kJgXRUBI5x7zpH7NdJtCWzzCh5P9CZriGLrY
         vT7u0vff1EY4T5UDmKIEtSv/Wm8WFzmZpk/nRnbL1cGg6qL9d4ep9+vLsrnDq6TdVfBW
         vmFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710140758; x=1710745558;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DLbH1FpL/W1pRCQh4HZ1seSYIOwW3M1UWX44cGi5xdA=;
        b=WPtR2IB9YsLuL0uNw7hFe7xvlVSgYxWMiFoZdf8hOZMnC1xDEAs5Z+sv8SYT+N3N9J
         3HkTaPcGcSF5XNPV33eQkOzVEyh7Tw9S4gYc30d6zjIY04LoprnkpCtnQf5kVTdebDBC
         9Nek92a4/ecONxxVtpgDCU3nVlUw9n/X4UpDP1yNiDrMuC4Tpk2VoOBKu/xNtouWsiaT
         cGrYyss+IhKAZXyuj2StbxSEjBa1M/sdoyRo7S8DclN50XaD+dWVjG7+dOZBYS/Y8FR7
         3sos8kTye9YVlFF8felK7bAo+kINvd7I/ti9HQe5/kGEHQlZ7ctRLffoZRR0C5IOUQD2
         E9ug==
X-Forwarded-Encrypted: i=1; AJvYcCXVpnlYlHH6uOWXhAgJt2BPUnvxiVdh7jWRmTu+lp7obqta8Ekl/zNBljozW/8XqFYyaF9DG9IhEsCReOIbuba1T6rB+x6d
X-Gm-Message-State: AOJu0YzkLIwZ8MmuyJjdKlGJ1nKTNPE3hQrlKKJnd09ZDGVvwVZZ+Kx+
	1wibXypmPFD3ZUKgdHeNzV/cH1oVcnF0Rrvfoydz2JFdPKz2tyFKHaYyfSmSd0Uj/A==
X-Google-Smtp-Source: AGHT+IGbnoKLMIRqEu0LaKPtnOpgr3d9/3PTmnm5AVamULt41FiaaRgtnlA6CJXUgixOdCOtoP4YzA==
X-Received: by 2002:a17:903:2406:b0:1d8:ab27:d76c with SMTP id e6-20020a170903240600b001d8ab27d76cmr5920250plo.51.1710140758120;
        Mon, 11 Mar 2024 00:05:58 -0700 (PDT)
Received: from KERNELXING-MB0.tencent.com ([43.132.141.25])
        by smtp.gmail.com with ESMTPSA id iz21-20020a170902ef9500b001dc8d6a9d40sm3931132plb.144.2024.03.11.00.05.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Mar 2024 00:05:57 -0700 (PDT)
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
Subject: [PATCH nf-next v2] netfilter: conntrack: avoid sending RST to reply out-of-window skb
Date: Mon, 11 Mar 2024 15:05:50 +0800
Message-Id: <20240311070550.7438-1-kerneljasonxing@gmail.com>
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
server at the beginning, the socket is set up by using 4-tuple:

client_ip:client_port <--> server_ip:b_port

Then, some strange skbs from client or gateway, say, out-of-window
skbs are eventually sent to the server_ip:a_port (not b_port)
in TCP layer due to netfilter clearing skb->_nfct value in
nf_conntrack_in() function. Why? Because the tcp_in_window()
considers the incoming skb as an invalid skb by returning
NFCT_TCP_INVALID.

At last, the TCP layer process the out-of-window
skb (client_ip,client_port,server_ip,a_port) and try to look up
such an socket in tcp_v4_rcv(), as we can see, it will fail for sure
because the port is a_port not our expected b_port and then send
back an RST to the client.

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
matter. However, we can see many strange RST in flight.

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
whole process/behaviour adheres to the original TCP behaviour as
default.

Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Jason Xing <kernelxing@tencent.com>
---
v2
Link: https://lore.kernel.org/netdev/20240307090732.56708-1-kerneljasonxing@gmail.com/
1. add one more test about NAT and then drop the skb (Florian)
---
 net/netfilter/nf_conntrack_proto_tcp.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index ae493599a3ef..19ddac526ea0 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1256,10 +1256,21 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
 	case NFCT_TCP_IGNORE:
 		spin_unlock_bh(&ct->lock);
 		return NF_ACCEPT;
-	case NFCT_TCP_INVALID:
+	case NFCT_TCP_INVALID: {
+		int verdict = -NF_ACCEPT;
+
+		if (ct->status & IPS_NAT_MASK)
+			/* If DNAT is enabled and netfilter receives
+			 * out-of-window skbs, we should drop it directly,
+			 * or else skb would miss NAT transformation and
+			 * trigger corresponding RST sending to the flow
+			 * in TCP layer, which is not supposed to happen.
+			 */
+			verdict = NF_DROP;
 		nf_tcp_handle_invalid(ct, dir, index, skb, state);
 		spin_unlock_bh(&ct->lock);
-		return -NF_ACCEPT;
+		return verdict;
+	}
 	case NFCT_TCP_ACCEPT:
 		break;
 	}
-- 
2.37.3

