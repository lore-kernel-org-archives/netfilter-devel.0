Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793789907;
	b=z9khckGixqjNUebwrjOhtn6Icn04PituTNnI5RDa4l2FByDnOeZKEvYnb7pEgXWGj+kb
	 rkglQVelP+4XPCtUldwNKxKSeDHL1gAaWsNltUzLv649cl6/ERMr35urV3wX5CY5NrUWS
	 xf1rXIiDaFKrBEzSVHTxu1ghqIemTDyoLachxrekr/Gly/gv7iVm/h2wxD5/mzZdoJ2bM
	 BNaMm5MveoXSBReXCHVTbwCSj2/qgMsWmbAHyJQOOdWS8P8p+GpndzVXxBjH01gqlqVSd
	 zoGlhYqBUFFWSmc2sosJAe6PEu1mRjaTo/YnG2rTNajS6GNEOoikW/dqemmXfgpYufQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793789907;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+Z+GzzVOx1aNjSWBe6AS1wSTsiH+YO5K/0zVvPIYf1E=;
	b=j9AU2+emavx71ikfkl74qU66ABcFAC6aFxSzBT2MurmcRed+229x7fosZx8b69PKRZzt
	 ZvLWM50FiCQpwV0Y1XaiOdijEYWqFU34UxT/NbDeZLmypVWC7Y2OVdOkI9dHn1fKzhFO4
	 Z3RDdQZjyGOG3ZGjsIbqQuPimAvV8P58GlXXaryMkyDchu9UOtuUeTe1w7RIti+6g1ZGU
	 t7yzOpagzF/vkvxVXaq63s71wieFu6TASpjDx/3XgXmApthT307B/iugsKekTo6nIAdS/
	 0vq6+r6abxV8jrPRGxO9zj8cwTfdcDPG5P5L9JawY6iGhpV6XXBWVjRhGhGWRnrWU1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4F4A606A329
	for <netfilter-devel@vger.kernel.org>; Wed,  4 Nov 2026 10:58:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E4F4A606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id B2D2060218; Wed, 04 Nov 2026 11:58:17 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH ipset] tests: hash:net,iface.t: check wildcard add and delete
Date: Wed,  4 Nov 2026 11:58:10 +0100
Message-ID: <20261104105810.21171-1-fw@strlen.de>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The existing implementation allows to delete an element that was added
with wildcard flag provided the key matches.

Check kernel doesn't require a wildcard flag to delete the element.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 One more quirk worth testing for: check we can remove
 an element that had wildcard flag applied to it.

 tests/hash:net,iface.t | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tests/hash:net,iface.t b/tests/hash:net,iface.t
index f1a36e33ff8f..9f3d9e36e232 100644
--- a/tests/hash:net,iface.t
+++ b/tests/hash:net,iface.t
@@ -282,5 +282,12 @@
 0 ipset test test 10.0.5.0/24,eth0
 # Test a 2nd, unrelated interface matches the wildcard too.
 0 ipset test test 10.0.5.0/24,eth1
+0 ipset flush test
+# Add a wildcard-flagged element
+0 ipset add test 10.0.6.0/24,eth wildcard
+# Delete the element. ipset del does not expose a wildcard flag
+0 ipset del test 10.0.6.0/24,eth
+# Check the wildcard element was removed
+1 ipset test test 10.0.6.0/24,eth1
 0 ipset destroy test
 # eof
-- 
2.56.0

