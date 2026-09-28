Received: from out-zbxj-a65.jellyfish.systems (out-zbxj-a65.jellyfish.systems [198.54.127.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB4AC38C2D1
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Sep 2026 18:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.54.127.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790620755; cv=none; b=mqDcJ9OWD/PMkoZUvNpAHntJFX/+z8L/1YC2BbjEuoGiiT4cDGDPZzIPsD2qvDEBtokxTUugYYQ6nXlfr2/9YfPGeCmCzdWUklM20RKwIHQIXTGcIehTV5hNW5W0DZjxtRrBawuaNBkhgGeFmZP/LVZBvnK61lL3BiOMAK9r6vU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790620755; c=relaxed/simple;
	bh=ZIgkwmjkinRsWLqg+1iYwC4ORPrx7SRWeIsI3tL7Po4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CwHqMBRauxR9AHEkYu0IANsEfGXdXbrMFuPVuOinaInsCPmcrsJuYG16KG9/WZzZFbbEb3IPnqRExgoFzHMLJmrOYNcDUwMvaXEMy322JKL39HrCnvM5IJ7kkjYy5FRDrUo1ykDqbXBOBMPvr1kLQY5K0cThlKAhajed+7wKYfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rexion.ai; spf=pass smtp.mailfrom=rexion.ai; dkim=fail (0-bit key) header.d=rexion.ai header.i=@rexion.ai header.b=ecFc4q95 reason="key not found in DNS"; arc=none smtp.client-ip=198.54.127.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rexion.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rexion.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rexion.ai header.i=@rexion.ai header.b="ecFc4q95"
Received: from research-box.ec2.internal (ec2-3-80-226-50.compute-1.amazonaws.com [3.80.226.50])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.spacemail.com (Postfix) with ESMTPSA id 4htqpG1h4Xz8sXN;
	Mon, 28 Sep 2026 18:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rexion.ai;
	s=spacemail; t=1790620743;
	bh=2fonSnmr91Dudeazy60rZ3vwRsUStr3BkdW5/6Xy4h8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ecFc4q95L/stfNNDU5Iz574kcavb4YQKLZtXjmKOFapCCHMGBlolEyJgwPuO8dztj
	 CXXvah/v2QQNs0AH62HX8bgcZtd9XcRqPh1zD1dTw8bFsbVwymrgk+kUYvZRAoEPb+
	 IQe+DS5EqKPslmp+6rlPFF8/bo+tAM0aDWlBSHF6cW739lMFx4jCRVpItvmh4R79J+
	 uQmMxE29aqcKColPWlTxaVQn2MVKK1X2aSM+dQjXjOhkXU2fs1E/Rf0NJm5DuBpzMv
	 SSAubOE9gS8v+g692n4ESTKezAFCUDCBlZbYWVlOw4Bvd8cpSaahYsREtQFgelZO0p
	 kXznHZ7ISna5Q==
From: Rahul Chandelkar <rc@rexion.ai>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	Rahul Chandelkar <rc@rexion.ai>
Subject: [PATCH nf-next v5 2/4] netfilter: nf_conntrack_irc: use nf_ct_helper_parse_port()
Date: Mon, 28 Sep 2026 18:39:01 +0000
Message-ID: <7ddfde1970b5daaba5c72a1a0f13455caa5e41f3.1790596690.git.rc@rexion.ai>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1790596690.git.rc@rexion.ai>
References: <cover.1790596690.git.rc@rexion.ai>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Envelope-From: rc@rexion.ai

parse_dcc() stores the result of simple_strtoul() directly into the u16
*port, so a DCC port above 65535 is silently truncated (e.g. 65537
becomes 1) and a conntrack expectation is created for a port that never
appeared in the DCC command.

Use nf_ct_helper_parse_port(), which parses the length-delimited buffer
without relying on NUL termination and rejects port 0, values above
65535 and digit runs longer than five characters.

Since parse_dcc() now fails for port 0, the dcc_port == 0 test in help()
can no longer be true; remove it.  A DCC command with port 0 is now
dropped through the "unable to parse dcc command" debug path instead of
the ratelimited "Forged DCC command" warning; no expectation is created
in either case.

Build-tested with allmodconfig and allyesconfig (W=1) and sparse, and
cross-built for i386 and big-endian powerpc.  It has not
been run-time tested with IRC traffic.

Fixes: 869f37d8e48f ("[NETFILTER]: nf_conntrack/nf_nat: add IRC helper port")
Assisted-by: Claude-Code:claude-opus-5-5 sparse
Signed-off-by: Rahul Chandelkar <rc@rexion.ai>
---
 net/netfilter/nf_conntrack_irc.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_irc.c b/net/netfilter/nf_conntrack_irc.c
index 92360963757a..88c4530c4841 100644
--- a/net/netfilter/nf_conntrack_irc.c
+++ b/net/netfilter/nf_conntrack_irc.c
@@ -88,7 +88,9 @@ static int parse_dcc(char *data, const char *data_end, __be32 *ip,
 		data++;
 	}
 
-	*port = simple_strtoul(data, &data, 10);
+	if (nf_ct_helper_parse_port(data, data_end - data, port, &data))
+		return -1;
+
 	*ad_end_p = data;
 
 	return 0;
@@ -206,9 +208,8 @@ static int help(struct sk_buff *skb, unsigned int protoff,
 
 			/* dcc_ip can be the internal OR external (NAT'ed) IP */
 			tuple = &ct->tuplehash[dir].tuple;
-			if ((tuple->src.u3.ip != dcc_ip &&
-			     ct->tuplehash[!dir].tuple.dst.u3.ip != dcc_ip) ||
-			    dcc_port == 0) {
+			if (tuple->src.u3.ip != dcc_ip &&
+			    ct->tuplehash[!dir].tuple.dst.u3.ip != dcc_ip) {
 				net_warn_ratelimited("Forged DCC command from %pI4: %pI4:%u\n",
 						     &tuple->src.u3.ip,
 						     &dcc_ip, dcc_port);
-- 
2.43.0

