Received: from mail-vs2-f41.google.com (mail-vs2-f41.google.com [74.125.227.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B338F3BCD25
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Sep 2026 20:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789591849; cv=none; b=JWvCsk4NOs4ysbm1pj5HgRdxSO8vaavmnjRlEfaip+XMjmf6/dN6EYEJDmCHI7p7OBPPtGN+vqm4WjJDsmYifZdLdPyx0nHa8ak5jTbDayZ6RQuNBqC9oBiRtRg7jNuojY8DyM9XVZtlylUHxv5LzQvnJgv+hog1NcyCMGsDfb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789591849; c=relaxed/simple;
	bh=vGxo+U1sJMCVsq3sDI08zPDza2WpfMA+ZZBuxg0Rgp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lOYQm8lv31ROOBVHoa5R8XtANSzJ74UNUi0nlImsMk0CiIfqO4sC8/hYhLbMDbf+p5lNY70iTVtS0MHiPmmyNgknHS2zMtpZeAPAbQSCS1UEquoGkVFZbRgx04OaMa8WK+s2dtx9mHSicevaH4kw4pdrF36HE5xksV3QP/gUgcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rF1hUmsI; arc=none smtp.client-ip=74.125.227.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rF1hUmsI"
Received: by mail-vs2-f41.google.com with SMTP id 71dfb90a1353d-5c963a787c9so36953e0c.2
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Sep 2026 13:50:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789591832; x=1790196632; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+xdh7oWEQ9m8Qy+E3UVjKRIovBOhuQDCeQrchOYtk/I=;
        b=rF1hUmsIT9igjP5btpGYCBgF2a1mg1PwA+mRm9EJo6bGZCYDlfaauCJICTLok1pQI6
         CVczDKxp5D2yAxbN+Fzh+x/xS1YKwrc+RHWnlYTzywaiinQtePqm7Ki4dEhOTzw/wVJH
         HgjNwwl/GPtd3Iji71u1zZXBSavBK0RacrVFxEnwNu+jSkB8ark0r00bEeMk1WZSAgLF
         9GhIPDtJBtUYBx5SdLTVS9G0Fp7C3COCqt3UHm6V+6IF9WzSFNMyqo1/WR61/VcOyX9Y
         tgA5a+EdSnTRGVn5U/DfGpekzYL3CQ/BoEoi+OawtccoFAyhG1dHYySNxRvym1cj4kjr
         c+EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789591832; x=1790196632;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+xdh7oWEQ9m8Qy+E3UVjKRIovBOhuQDCeQrchOYtk/I=;
        b=n3CLiNEfra9lbhYxvR/Vc2vGQdxlVYVmht29RA0n8ZIdNA9iaHphioyxawgoOmEAxh
         lyAlB3SPFuT6c9Ei49qzIUidDJLVLSnFdYbaNvKFnI28lP1Cwmv65t2q3+Ne4Ilm85SS
         LUzipwh6ouc2tARTRYXT4Yl8hHdSBjhaJclaqVGoJxsGq8gSogIoodtW6jHHcTxFrrOz
         srAX+mGmetf5dtBPwZNoWkC2Bs2zKON9kIbv61J3i/Ud/bhjMEl68CO/uLU3l3kiMp0+
         r5LY6mfgffYe9T8igX6d+yv4PDsUcwlXfkpDI1/Z2ifxXagFaiGQFPHDZBp5ccI0LSei
         aq0g==
X-Forwarded-Encrypted: i=1; AKwUvBx/Q7RKPMP4hPk6FqV+VmIqXYj9c+yIx4h1tuDXxYHFKGWU12rw2zF1A8vJA6U9mTY6mdX1n1kq9FpBo4maF+U=@vger.kernel.org
X-Gm-Message-State: AFuF++k6OiigpG1qsT0dGwqxqOSI8puH7g/RJvyEHbiq5wjpcN384fNS
	nHn5GmtIa3zkDyhaoTDJCmkquRTiabxkfryV7ZY1YvPWuEI57Zr424ju
X-Gm-Gg: AYBFou2u8ZV2LOq7jS8A4svnm2xqUvO3Mnsw5lKWy8/FCd/g2kJyFS+EzVPXj7ibRFP
	JcnZIBg4uGzbiZ6BYFf9Fk9fqLKjctmbp7OPDuJedptGBd7akrAEvHZrc9r8KkX7O9Tq6gG5m/p
	UKxWp++7GIUbZ0zJBf+XcUL0znDyhvqvHdmTOTwYXP9jHWzWi3iDCamhdJTO4eadVNr5Wb/IRPH
	El0OXTOYM+omg6UsaOBFFfQInYnRAxTkZ7Onnt/DbZbHCA6QcuxIsCG849AcXSdz0qAloSZ5pfQ
	/O3PSbZNX9gvYTxL5fkd85oUNnsi2o0JshflRGGCY64pYcPNmJa9cMNQKPlPnehWHeXFRBsvtaq
	doShED8ZBqRcwzcgAeHHI9VMYph4IAfXQ5VK8oSynUD2gyd5zPf4GU4qSN04HuPGiE006m4soZH
	83b8JLFRGSZOyUMPbS0wI6Wd36/SHpqfsfVyRkzJGwkJJJI9VCc2Mfoe4HNpAN62M=
X-Received: by 2002:a67:f095:0:b0:7a0:eb10:76aa with SMTP id ada2fe7eead31-7a0eb108b2amr3649070137.2.1789591832274;
        Wed, 16 Sep 2026 13:50:32 -0700 (PDT)
Received: from adriano ([190.215.95.120])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-9832354a8aasm947799241.10.2026.09.16.13.50.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 13:50:31 -0700 (PDT)
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
Subject: [PATCH v3 nf-next 2/3] ipvs: tcp: enable per-connection secure_tcp in state machine
Date: Wed, 16 Sep 2026 17:50:03 -0300
Message-ID: <20260916205004.647194-3-adrianox@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260916205004.647194-1-adrianox@gmail.com>
References: <20260916205004.647194-1-adrianox@gmail.com>
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

