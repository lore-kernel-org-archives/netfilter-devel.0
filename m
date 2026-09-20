Received: from mail-vs2-f42.google.com (mail-vs2-f42.google.com [74.125.227.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB23D3D9DDE
	for <netfilter-devel@vger.kernel.org>; Sun, 20 Sep 2026 05:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789883245; cv=none; b=UDo/IG+616MJvvV3jbdbJlYvnIL+ZwXR8b3sJp/tWWN9NrSN4IkUl+A7l+JNuWLMSGYYa+2FQqhTQYUHxrlVssVRb+mWHQreEXGCTMl805SpyT4kNp/BvMx/8UhZ0UNkwYgZsVkma3ji6idhmtpVczciLW4KR3pDcBQNV54UsvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789883245; c=relaxed/simple;
	bh=vGxo+U1sJMCVsq3sDI08zPDza2WpfMA+ZZBuxg0Rgp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PM1UvQMj2qE6oWX8ryB5+NSZbX1D6ENWVyBIAqheHt4HOk/gRYBlMR0Wi0d5oAIbiTT9or+Tcrqo24C3Ftx5G4W+3YV4E9BR+C05dazWmaOcMG1c2ml1HSj+H99vlrT7aGq+V9KWJVmy808RoIirf3Q3dkunsoZVzlj7s7N633U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TEQulDE3; arc=none smtp.client-ip=74.125.227.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TEQulDE3"
Received: by mail-vs2-f42.google.com with SMTP id 71dfb90a1353d-5c98e1942dfso1434874e0c.3
        for <netfilter-devel@vger.kernel.org>; Sat, 19 Sep 2026 22:47:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789883243; x=1790488043; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+xdh7oWEQ9m8Qy+E3UVjKRIovBOhuQDCeQrchOYtk/I=;
        b=TEQulDE3nl8kiz1wCPMXCgEJbUO+jVTyndy00etcWmK+1D3JdkS8dv3/IvjMzs3lfY
         VtkEiGed3v/fAZ5gLLH5ggs6wtZGQiVPFCf9H9QDczWG4lL/1fIIB5Hpe8SFi/Lq96fs
         JLmz1FKG8Gv88sRHjiWSUiErOmw3ABuS+ExW4v0rC6NojLc/4nK9DJlNDuJJKsjzGePD
         0duUl17ynITUWEZ7jm2jkw6u3pirvUiQ2x+D4Nbimr8rX5FhZ/cCvjjjq5JoCkH/fyfV
         wEvC/uhsHgsxpGVxk5jYYNVRtBo5EFxHd9CTPx29iW/IUkXFC65TrVpkJVh43tsMg1jw
         loUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789883243; x=1790488043;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+xdh7oWEQ9m8Qy+E3UVjKRIovBOhuQDCeQrchOYtk/I=;
        b=DJb6a6pMHGcCJkbB3AIvYOVMcJ2eHuOqGhIGmUXwk/As74qLt4zpt2OS5q1pOD3On3
         dUVlIkAM+os/F0SLgm/bIJln7lH38u2PBuGgtUFHlvf+Bgks/YN8K3SC6MusLb1nSddY
         cHeN1o5qHogI5jNwsxT6sgD4Po0z+H/2SrxEAlfrNGue/aPFF+DGDDc1hX4d1B2pBVyK
         3SMLemsDyjBovJ0YWEMduCG9iUWxhAy1iwcGojeLqFF6/eOo6KoYRy/hDain/+B5p4PH
         a3Bdl0t1+frBY97zRAc+CqZR9LrFK5RkUIvcqsAZtuoSQnlIJojjx7O0Hd2yuM8H9Y1Q
         7cfg==
X-Forwarded-Encrypted: i=1; AKwUvBx1qCVVdOYosooNBwP5XEjyi7iR/AEpKZzV3R+mBAzaU/msOlfnmfYh5jtE9w2de0WqoS5hWD76/9vHlT7sUn8=@vger.kernel.org
X-Gm-Message-State: AFuF++n1AQk6CeH3WJS5UiI1DH7v7ujJO0o5WvOU6xKOeSEl+ZvDkSTl
	k2gcLbR+D8adC4tubNnpXOJTDFjZqWw4Hxt48lgU8nD2w+mXJHNrFzVV
X-Gm-Gg: AYBFou2s3RpGbCn8zGJAQyorZF6m8noi8BpfBukglQpKb0wijCDH1BPdqWrEHAqOKcI
	vNUENQukQFjYTRmb6uceEXzulO5+oj8JFZDcd4bc56/DPwlqprJAvdibf6ngpecfyHazRecPXEd
	FFLlBWFBzK1wnGmKz/rDePICwt8tDeGWsNirY8AaSJ8KjQHc7SHlIeNl/9ey0uG3OPPq9dIY9p1
	7y0gk2qSeLOszkiWf7vqxVw8PySAsJaYhjeM2w+Mzr4LPjGEevCrKpQNtd9opw4qGijXWBRRQcd
	HZf/CxhoK19gyEwCSV6gfJlkizWyJlyZSZzBf/RAaWcN9pEKs9QC+jfD0yNnIOVHtS+sfuhcCbk
	lVyaAY5xbsTidP/hgXH3yMtKijKjLPFEIfY3NHtPlvDYyDn/fqiGUydv+OYZbKNfVwUsQxewU0G
	G2jJ49vTZiyL+XXAAflQhHlRgGcM7I/sxVfmlCwsRGJGdW7/jxbZqbZ8sJ6hynn/s=
X-Received: by 2002:a05:6102:158c:b0:7a5:2427:ecc1 with SMTP id ada2fe7eead31-7a55ce7d127mr3164716137.19.1789883242711;
        Sat, 19 Sep 2026 22:47:22 -0700 (PDT)
Received: from adriano ([190.215.95.120])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-7a6aa41dac0sm4521732137.2.2026.09.19.22.47.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2026 22:47:21 -0700 (PDT)
From: Adriano Cordova <adrianox@gmail.com>
To: Simon Horman <horms@verge.net.au>,
	Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org,
	lvs-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 nf-next 2/3] ipvs: tcp: enable per-connection secure_tcp in state machine
Date: Sun, 20 Sep 2026 02:47:07 -0300
Message-ID: <20260920054708.988867-3-adrianox@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260920054708.988867-1-adrianox@gmail.com>
References: <20260920054708.988867-1-adrianox@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Let set_tcp_state select tcp_states_dos when the connection
carries IP_VS_CONN_F_SECURE_TCP, otherwise keep using the
global pd->tcp_state_table (the netns default / or if nomem).

Signed-off-by: Adriano Cordova <adrianox@gmail.com>
---
(no changes since v1)

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

