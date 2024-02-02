Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE5146B9B
	for <netfilter-devel@vger.kernel.org>; Fri,  2 Feb 2024 13:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706881999; cv=none; b=tw9bfXggikJmE3i5e1dxAyJTtU4XlEfSv3/hky2lwXWUVHDcMoE/FgXzRULv+FbtSZtIsnq+Va+gNEpRFefla6b0KPySMOug63YwLEDpxT/0rBg7WYfVwX6XZ2ky0SL808lw58gFtqCHp2UehhzIMjYnaIwVGcexQ5zQi4GQJdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706881999; c=relaxed/simple;
	bh=gZX2rIjryXfa9Lf9h/pv8vnnHgzFWnP4GnLD1gGCMuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IHhE4dEKHv/PgpaCR4b+f/gt/a+mAiKXbKeb6DuTpgnlTZee0zbQyalz7/mEmvWlDG7hUZVaUbtDbpxpN/HpKCK7tRqLCFg1kkubl0H1m3pfAzZrg3KZUDZggFO5plSBXEd8IbO8D017RXJvmaFQXCyp3EzInnSxlLwUDrREJCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=bthhZoPN; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="bthhZoPN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=lpZDlpbaBQCaRBTP/hDAme1s4fShQnxXRxb8CPj0xcE=; b=bthhZoPNnedz4EjXICmQOiXSBp
	yumNuAi3ZBJNEhwFYMNOAwhhQjIIL+6qe0xyQs+PUqHGI4A7bsAbqBObJfFiUkI8WxKy4L7FSG/Pn
	/vUUJ2ZqhytsGbG2MCW3RtueD6ICAIeSyWawe+lWGEFBJyj+xcLJwbVaW4PaQDlnkqoqQPN3vHYg+
	mllM7hMtAeozUzZ5qY3rfLNfZWJ09tFy2iR6LZvHnrkWSJa/hUNzSjTedb5mwJVKFMB4salBHdlIQ
	qMmxnnN23+HFpxP7nGwaO8V5aGqKdrtOq9qDJQjcR4nqs94imHeNnf/JfIkfkl9bzsRsuIcU0uqMU
	3DLpgndg==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97)
	(envelope-from <phil@nwl.cc>)
	id 1rVtyf-000000003BP-1upe;
	Fri, 02 Feb 2024 14:53:09 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>
Subject: [iptables PATCH 03/12] libxtables: Reject negative port ranges
Date: Fri,  2 Feb 2024 14:52:58 +0100
Message-ID: <20240202135307.25331-4-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240202135307.25331-1-phil@nwl.cc>
References: <20240202135307.25331-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Analogous to XTTYPE_UINT*RC value parsing, assert consecutive port
values are not lower than previous ones.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libxt_conntrack.t | 8 ++++----
 extensions/libxt_dccp.t      | 4 ++--
 extensions/libxt_udp.t       | 4 ++--
 libxtables/xtoptions.c       | 7 ++++++-
 4 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/extensions/libxt_conntrack.t b/extensions/libxt_conntrack.t
index 620e7b5436e88..5e27ddce4fe6e 100644
--- a/extensions/libxt_conntrack.t
+++ b/extensions/libxt_conntrack.t
@@ -34,22 +34,22 @@
 -m conntrack --ctorigsrcport 4:;-m conntrack --ctorigsrcport 4:65535;OK
 -m conntrack --ctorigsrcport 3:4;=;OK
 -m conntrack --ctorigsrcport 4:4;-m conntrack --ctorigsrcport 4;OK
--m conntrack --ctorigsrcport 4:3;=;OK
+-m conntrack --ctorigsrcport 4:3;;FAIL
 -m conntrack --ctreplsrcport :;-m conntrack --ctreplsrcport 0:65535;OK
 -m conntrack --ctreplsrcport :4;-m conntrack --ctreplsrcport 0:4;OK
 -m conntrack --ctreplsrcport 4:;-m conntrack --ctreplsrcport 4:65535;OK
 -m conntrack --ctreplsrcport 3:4;=;OK
 -m conntrack --ctreplsrcport 4:4;-m conntrack --ctreplsrcport 4;OK
--m conntrack --ctreplsrcport 4:3;=;OK
+-m conntrack --ctreplsrcport 4:3;;FAIL
 -m conntrack --ctorigdstport :;-m conntrack --ctorigdstport 0:65535;OK
 -m conntrack --ctorigdstport :4;-m conntrack --ctorigdstport 0:4;OK
 -m conntrack --ctorigdstport 4:;-m conntrack --ctorigdstport 4:65535;OK
 -m conntrack --ctorigdstport 3:4;=;OK
 -m conntrack --ctorigdstport 4:4;-m conntrack --ctorigdstport 4;OK
--m conntrack --ctorigdstport 4:3;=;OK
+-m conntrack --ctorigdstport 4:3;;FAIL
 -m conntrack --ctrepldstport :;-m conntrack --ctrepldstport 0:65535;OK
 -m conntrack --ctrepldstport :4;-m conntrack --ctrepldstport 0:4;OK
 -m conntrack --ctrepldstport 4:;-m conntrack --ctrepldstport 4:65535;OK
 -m conntrack --ctrepldstport 3:4;=;OK
 -m conntrack --ctrepldstport 4:4;-m conntrack --ctrepldstport 4;OK
--m conntrack --ctrepldstport 4:3;=;OK
+-m conntrack --ctrepldstport 4:3;;FAIL
diff --git a/extensions/libxt_dccp.t b/extensions/libxt_dccp.t
index 535891a556394..3655ab6f4b7fc 100644
--- a/extensions/libxt_dccp.t
+++ b/extensions/libxt_dccp.t
@@ -10,12 +10,12 @@
 -p dccp -m dccp --sport :4;-p dccp -m dccp --sport 0:4;OK
 -p dccp -m dccp --sport 4:;-p dccp -m dccp --sport 4:65535;OK
 -p dccp -m dccp --sport 4:4;-p dccp -m dccp --sport 4;OK
--p dccp -m dccp --sport 4:3;=;OK
+-p dccp -m dccp --sport 4:3;;FAIL
 -p dccp -m dccp --dport :;-p dccp -m dccp --dport 0:65535;OK
 -p dccp -m dccp --dport :4;-p dccp -m dccp --dport 0:4;OK
 -p dccp -m dccp --dport 4:;-p dccp -m dccp --dport 4:65535;OK
 -p dccp -m dccp --dport 4:4;-p dccp -m dccp --dport 4;OK
--p dccp -m dccp --dport 4:3;=;OK
+-p dccp -m dccp --dport 4:3;;FAIL
 -p dccp -m dccp ! --sport 1;=;OK
 -p dccp -m dccp ! --sport 65535;=;OK
 -p dccp -m dccp ! --dport 1;=;OK
diff --git a/extensions/libxt_udp.t b/extensions/libxt_udp.t
index d62dd5e3f830e..09dff363fc21a 100644
--- a/extensions/libxt_udp.t
+++ b/extensions/libxt_udp.t
@@ -11,13 +11,13 @@
 -p udp -m udp --sport :4;-p udp -m udp --sport 0:4;OK
 -p udp -m udp --sport 4:;-p udp -m udp --sport 4:65535;OK
 -p udp -m udp --sport 4:4;-p udp -m udp --sport 4;OK
--p udp -m udp --sport 4:3;=;OK
+-p udp -m udp --sport 4:3;;FAIL
 -p udp -m udp --dport :;-p udp -m udp;OK
 -p udp -m udp ! --dport :;-p udp -m udp;OK;LEGACY;-p udp
 -p udp -m udp --dport :4;-p udp -m udp --dport 0:4;OK
 -p udp -m udp --dport 4:;-p udp -m udp --dport 4:65535;OK
 -p udp -m udp --dport 4:4;-p udp -m udp --dport 4;OK
--p udp -m udp --dport 4:3;=;OK
+-p udp -m udp --dport 4:3;;FAIL
 -p udp -m udp ! --sport 1;=;OK
 -p udp -m udp ! --sport 65535;=;OK
 -p udp -m udp ! --dport 1;=;OK
diff --git a/libxtables/xtoptions.c b/libxtables/xtoptions.c
index cecf7d3526112..0a995a63a2a88 100644
--- a/libxtables/xtoptions.c
+++ b/libxtables/xtoptions.c
@@ -604,7 +604,7 @@ static void xtopt_parse_mport(struct xt_option_call *cb)
 	const struct xt_option_entry *entry = cb->entry;
 	char *lo_arg, *wp_arg, *arg;
 	unsigned int maxiter;
-	int value;
+	int value, prev = 0;
 
 	wp_arg = lo_arg = xtables_strdup(cb->arg);
 
@@ -634,6 +634,11 @@ static void xtopt_parse_mport(struct xt_option_call *cb)
 			xt_params->exit_err(PARAMETER_PROBLEM,
 				"Port \"%s\" does not resolve to "
 				"anything.\n", arg);
+		if (value < prev)
+			xt_params->exit_err(PARAMETER_PROBLEM,
+				"Port range %d-%d is negative.\n",
+				prev, value);
+		prev = value;
 		if (entry->flags & XTOPT_NBO)
 			value = htons(value);
 		if (cb->nvals < ARRAY_SIZE(cb->val.port_range))
-- 
2.43.0

