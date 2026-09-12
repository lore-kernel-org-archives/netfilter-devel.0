Received: from mail-vs2-f12.google.com (mail-vs2-f12.google.com [74.125.227.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3AA33D6FC
	for <netfilter-devel@vger.kernel.org>; Sat, 12 Sep 2026 01:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789176775; cv=none; b=vCG/baz+it4u886nyuANdFloDezYLJ1OEgGywPVc7Yt4lagyotgcwfTDht+0fNZG26rtiODHrxXROwfigFWLWaqPCkDYRVK//dq/nmbQYrq68ohBkv77xuLMmkNowpHxKUf1x9A2N6UXJfpXHL8VIOD1tILwqoQcpI5zSUq4TOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789176775; c=relaxed/simple;
	bh=W3fiDar/lm5WkpMHbhW77gh+6N9tJ47fTMLt8bhssWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GQiu3ui64T2xVjOthupLHGNhl1ex3pjO0AiF7SuPzHsjysKJ4knLD7qM4rWIj2Yv+Niz7JP/lrIHhYKc8wfV52iHuzh8ws9uWq8Vsp9wb/w+CAD8xLqHGaTKNXndnTMKLBHNCke/G4KTJIccy5iHCrNQ1ZYwVzJJ9aknFJkpKIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kC+AW1Hi; arc=none smtp.client-ip=74.125.227.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kC+AW1Hi"
Received: by mail-vs2-f12.google.com with SMTP id 71dfb90a1353d-5c67e529da9so201320e0c.2
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Sep 2026 18:32:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789176772; x=1789781572; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kO+7YN2IAaySDWCD3o40tVhY4GBw4G0JdF/ryYyBPSg=;
        b=kC+AW1HiZkRNRfJqMHtgTB/1JUQM/kzggxLBNUHtTei4+Y412Z3F8ho/706bnOPYhd
         SbruhTH+XUhfsTE6LpRjZUVx+O5UpsSZ+LYyUOSXv87nLw1jPP8bq+b4gPAN2EHL2hie
         t5c4R0dUk53Lpc5k+1SpMLoU+MHLcChz+dIZrcWx8NsrM9oAt4bbJFtoOwtK1Hqh2X3+
         u9WP4H6rzG/jSWSBJtdDU9oPj2sDc8XjithoqpKKJXcAmwxl0aY2nJfhS8kNMdjv8Ms6
         gQtTIyeCyHWIEf/2DPbNoxVcOkNxibcylo7DUbuGlMEW1WUdV9fbACZ3+67zf3b8Nfj6
         TmBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789176772; x=1789781572;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=kO+7YN2IAaySDWCD3o40tVhY4GBw4G0JdF/ryYyBPSg=;
        b=UvwKa9KyY5Ur6ewEsm8jPi/JS/aNV5CFuOl0wCOA23wdoZphTuiWHY3PXv+6bvY/7K
         Ey9jpKWGDEgp/cL+odjy87IGfAVlxDpmvkIuftVropPArr6LYMWN6e/vL2w+tuQpr/+C
         8dX5WECwSvbyFxSt7Tr5n++dMpTAhR2+b7xB3XTcBATrsMHw2hth/pzOwH1QbyuHe19y
         5mgdK8zybLVNkVXe6Ikdzw8j0iNYeH9X8GXRxbcWrJ2VYjAtBK7Cq+7MfL/rvPpYxQEa
         NMQ/tqcjeJ82OJfRuDq6o99JK/qp1ykjm8KsQRojbKw6lUThrYtjpuORDiNbSYKF14bU
         4R3A==
X-Forwarded-Encrypted: i=1; AKwUvBwZ54kBBC2JbS4tB6Z00ZLZHblBb9RoYce8PxxiC2PQn3yVztJq2sb8DiniSmD4X+H7QMDhknnF48qB3JoAzjg=@vger.kernel.org
X-Gm-Message-State: AFuF++l05hC9DjfRZHEK4VHJXHdKQAoWLdXZxhY+u0cZjKE/wuQmrefo
	t2/Ph6mkK7vIybpFCkmep0wHtpwde61xZz9IWbQWTgUFKHGIrXWbfX31
X-Gm-Gg: AYBFou3FTRGoP+hAxDFpdL5x7dveOyhuK6zxeKePv34a1zk3UBf98EBQ8F6xM1tEpWl
	SP7fdhfb9gcT9viFD7xBLy3BC39V5/XnDnEdMK+2wZxeerw2sHFQR5qJaHaBjrIqYIb9C1PD9bM
	46ngh2hi7ZXJRMh58jfJd0FzhNkyeEUVb2IRf3AAyNfxpcAlHdwgAqMcy1n6tJWBIqOPwX7rksV
	DEdfWKlaLlWKJaplufvDFspcr3p1NBXT4EMVRq/ONvBc8cH46c20OayQPzipNY9raC4Bmsq8O3R
	XkBnmDIryZvro/bOGI/Pl19vBzKf1YrmpY+6hGY0btx2qAdUymSUIxm25qAV+w1SyEqiEW2tsPG
	g51srd/oGzr7jQI5QKEE3eykSF9ViyZ0bAx2S7vuHSgsYKujrYLJp7E2+CLbH2XOK4i8fzYcB4K
	X9HUIIK9PZt7biLKDl72IvkVOE0v8f6efu1h9EnkopxxVhMqlZw11DUeattjHvp2k=
X-Received: by 2002:a05:6122:420e:b0:5c5:731b:11d2 with SMTP id 71dfb90a1353d-5c8463028afmr4284498e0c.8.1789176771974;
        Fri, 11 Sep 2026 18:32:51 -0700 (PDT)
Received: from adriano ([190.215.95.120])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c84714c380sm4738262e0c.15.2026.09.11.18.32.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 18:32:51 -0700 (PDT)
From: Adriano Cordova <adrianox@gmail.com>
To: Simon Horman <horms@verge.net.au>,
	Julian Anastasov <ja@ssi.bg>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	netdev@vger.kernel.org,
	lvs-devel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	Adriano Cordova <adrianox@gmail.com>
Subject: [PATCH 3/4] ipvs: tcp: enable per-connection secure_tcp in state machine
Date: Fri, 11 Sep 2026 22:32:15 -0300
Message-ID: <20260912013216.588300-4-adrianox@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260912013216.588300-1-adrianox@gmail.com>
References: <20260912013216.588300-1-adrianox@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Let set_tcp_state select tcp_states_dos when the connection
carries IP_VS_CONN_F_SECURE_TCP, otherwise it keep using the
global pd->tcp_state_table (the netns default / or if nomem).

Signed-off-by: Adriano Cordova <adrianox@gmail.com>
---
 net/netfilter/ipvs/ip_vs_proto_tcp.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_proto_tcp.c b/net/netfilter/ipvs/ip_vs_proto_tcp.c
index fec0e8b47b71..3b9a2c8e9a52 100644
--- a/net/netfilter/ipvs/ip_vs_proto_tcp.c
+++ b/net/netfilter/ipvs/ip_vs_proto_tcp.c
@@ -451,11 +451,10 @@ static void tcp_timeout_change(struct ip_vs_proto_data *pd, int flags)
 	int on = (flags & 1);		/* secure_tcp */
 
 	/*
-	** FIXME: change secure_tcp to independent sysctl var
-	** or make it per-service or per-app because it is valid
-	** for most if not for all of the applications. Something
-	** like "capabilities" (flags) for each object.
-	*/
+	 * This remains the netns-wide default / global floor (e.g. when
+	 * memory pressure kicks in). Per-service hardening is now carried
+	 * by IP_VS_CONN_F_SECURE_TCP on each connection (set_tcp_state).
+	 */
 	pd->tcp_state_table = (on ? tcp_states_dos : tcp_states);
 }
 
@@ -479,6 +478,7 @@ set_tcp_state(struct ip_vs_proto_data *pd, struct ip_vs_conn *cp,
 	int state_idx;
 	int new_state = IP_VS_TCP_S_CLOSE;
 	int state_off = tcp_state_off[direction];
+	const struct tcp_states_t *table;
 
 	/*
 	 *    Update state offset to INPUT_ONLY if necessary
@@ -496,8 +496,10 @@ set_tcp_state(struct ip_vs_proto_data *pd, struct ip_vs_conn *cp,
 		goto tcp_state_out;
 	}
 
-	new_state =
-		pd->tcp_state_table[state_off+state_idx].next_state[cp->state];
+	table = pd->tcp_state_table;
+	if (cp->flags & IP_VS_CONN_F_SECURE_TCP)
+		table = tcp_states_dos;
+	new_state = table[state_off + state_idx].next_state[cp->state];
 
   tcp_state_out:
 	if (new_state != cp->state) {
-- 
2.51.0

