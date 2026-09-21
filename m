Received: from mail-vs2-f42.google.com (mail-vs2-f42.google.com [74.125.227.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5908C4E73BC
	for <netfilter-devel@vger.kernel.org>; Mon, 21 Sep 2026 20:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790024241; cv=none; b=q41ROsHG+ORxNbp6mNPvm8zLGL0NK4WhC/jUuU9Ay6xvT/dYldrYAGJvpeBhFEAG2XzOy0Jw/fMSTHVy8BF5J3fatjhzf9CPrmMJ4duyr5Lr8LGvX5JWVGhwn5tq1hVTjOuontS6TJJ2gXQrMlkP67SARAAuTHQIVtRRHqtdokw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790024241; c=relaxed/simple;
	bh=HvIdQDLYa1Lul0YF3dB9ewaICFXf/uHdEyk3gBqpQVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SEpGDuGAbAfOaM8jGvJ8UGoL8myu48zfCsvf+e7kZ+8F/yDO2JKCIdL4AKZ9VlYaoy4TQ3xPtUc6d43ndvuQgDbhpCin32UBc2tpvvHHlvB8xoOpU/dMCZL/PuQSDVgQbEAUevY022BpwdLMR+xIc7vXYGGxSqqOBOjYUOPo05Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EjBDGapi; arc=none smtp.client-ip=74.125.227.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EjBDGapi"
Received: by mail-vs2-f42.google.com with SMTP id 71dfb90a1353d-5c963d7503fso1157582e0c.0
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Sep 2026 13:57:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790024237; x=1790629037; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AXTKrz4VGvcWU+Xa9prrE8tXzfiajVxX/35uOYLtN8Q=;
        b=EjBDGapilITtv4WiIJKuWO6iBAAOubOgrVtAinW7vEoX+PIvMQbvVHupQCWRNswyaZ
         d5U3948W/sM0IJ36TnZVzfq9BNhORAzmw/zHL7suJH+P0XuWVGhFARWMRDsocCl0Rrr/
         UlLbmgOnAG8fLf0JtTERq0bYwZwHD927l5gUQ4r5y75xb72ft1BwPD55fOlmXfMVeNzs
         R1rpX7Kr5gxWGed4X41ShhcmkodOQOKCyE08a9uTaG6wb/yQ6q1aeV7aHcA0SvT8IkUA
         w+UZZKjij54a/D+FLjGNCXfq9Ri/1r6JHorlEBo4D2XyhO+m+DUwA/WsGNnWUx9HZPSY
         eUZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790024237; x=1790629037;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=AXTKrz4VGvcWU+Xa9prrE8tXzfiajVxX/35uOYLtN8Q=;
        b=z0Dsr3HmGtSonGlMhNMkLQXJiffRTpCO41Huk0dmp2Fpx88j5Z4b/RYBwfMJRkmyXl
         ATiyB3NS3as2zja4xAAUUwf9GEy9Eb5N+7uS4gwzsXcjpQ4A+z9DpfAjSQdkiCEX8iLG
         H6KL4vGDTMcV52wBrw34RaWkDUGDx0FubDfVT/tN1jjy14YTMsHAFnUpBhAXIoEiHweH
         dWnVAUrPgNHOOv4fuYx+/cPu8E0IWvPzOwjnxtSuV69UyfPpk4sVVkFR012l6aRM07Po
         yVT6vHL2DxJTuL81KIcSEP9ivsq0IVFoVrUSMjWsCqwhxUZoj4zKPQ/haWOwE5+IJqB2
         WNCQ==
X-Forwarded-Encrypted: i=1; AKwUvBwG8ux/LuGAG/NcfaFBtb/whc+iJ0Afh1VcmwqQGCeBhIVHNC4HxSRJWYBxJJa0XngGkxLHWKRqknPaFXeECxc=@vger.kernel.org
X-Gm-Message-State: AFuF++lNJ9KU7w/fDYTzIneA5Moo0jbYysBmkY4cgc+BCvu1Z2BuYyP+
	kVVnXwRu2ajo40YyA6Yg5ZcNGTIQQT/H5t67T69GBnSH1dAa7EQu71iq
X-Gm-Gg: AYBFou15GThxcIfpWmQ4tDocULuoUuB7ZJ6y6IMcXysuSJggBraccnh4UY0oRw2PzJY
	Olh7A+/fdNtemOFJUW+0ymZYrbkmZtuJORj+noSRyXbZw0kNJywAxn26VVzttvm6nQjCCgFDxUr
	0G7Ez8boDbtt58BLW6xphpyS2drqlfOB9eeb5DoT4stmOZkbYGyaOYoZFG5Z0KWKUpJEq4h7VCg
	xzDkWIUGCB98p6NVMvvGIoMD3mlv95AAqY9KW8fff+1KIXxaAfmy0p4q322ozPpePXmL7M+EqSu
	kBVozaR9VOHJYH6+rY5XSQKf0fACTCtuJyz1bFKZOKG1DM8BR9fi6j6o6eVwgluRNTmUqaMBqSo
	5kGj6DwKxsoSnKc6jPmE2nsPJkCSnjaeoM7h+/OppIr8u3UEJd0GPZMtLd6P2RcoLL13qVblLA2
	jj1kw8GhVoSrXQZvD6y2OUOjOZHKXcf9n5GYqCDMt3LIEJ0JyOg4vgn9mzN68sEmM=
X-Received: by 2002:a05:6122:4b16:b0:5c9:a60b:e5d7 with SMTP id 71dfb90a1353d-5c9b5a2b125mr6458823e0c.17.1790024237459;
        Mon, 21 Sep 2026 13:57:17 -0700 (PDT)
Received: from adriano ([190.215.95.120])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5c9e591d496sm286884e0c.2.2026.09.21.13.57.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 13:57:17 -0700 (PDT)
From: Adriano Cordova <adrianox@gmail.com>
To: Simon Horman <horms@verge.net.au>,
	Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org,
	lvs-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 nf-next 2/3] ipvs: tcp: enable per-connection secure_tcp in state machine
Date: Mon, 21 Sep 2026 17:57:05 -0300
Message-ID: <20260921205706.1055288-3-adrianox@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260921205706.1055288-1-adrianox@gmail.com>
References: <20260921205706.1055288-1-adrianox@gmail.com>
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
Changes in v5:
- Document that secure_tcp is the netns-wide default and that a service
  can opt in to the hardened table with IP_VS_SVC_F_SECURE_TCP.

 Documentation/networking/ipvs-sysctl.rst |  4 ++++
 net/netfilter/ipvs/ip_vs_proto_tcp.c     | 16 +++++++++-------
 2 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/Documentation/networking/ipvs-sysctl.rst b/Documentation/networking/ipvs-sysctl.rst
index fe36f4fcd3a0..5fc6afd2d39a 100644
--- a/Documentation/networking/ipvs-sysctl.rst
+++ b/Documentation/networking/ipvs-sysctl.rst
@@ -290,6 +290,10 @@ secure_tcp - INTEGER
 	The value definition is the same as that of drop_entry and
 	drop_packet.
 
+	This is the network-namespace default. A virtual service can opt
+	in to the hardened table regardless of this setting by setting
+	IP_VS_SVC_F_SECURE_TCP (0x0100) in its service flags.
+
 svc_lfactor - INTEGER
 	Possible values: -8 (larger table) .. 8 (smaller table)
 
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

