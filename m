Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793707814;
	b=WxRaDUc1kru/68cSm41/j6yP8RGAm5BVKR46AAMXo3JXkPZKj+6B5QqgaE2MQGXBllJj
	 C6bf6LKD0jZNKjirWB7Xqz5m2JLvnXTVg2o1bQ2hwK5ik/1yaT+1fpmY8ps0B4k6kwIZC
	 UeGKOibOaynwME58xLDxPcizfenvgEPtEoFFd3l7/XW4MSbFi93bNQx1rRAbqbhx6C8Af
	 RrK20V3DJR9ZZXpCShxaBeVBFP/w0Gg/Z5i4kk4bi2IPP3rl4Klhr1jB51mqDT8aen78u
	 SDT/nJBEwJzDpBofuY/2oiDXhGaVq636rvtdNVgOuBoUC7c+fGcTojD1FeSK66dfcXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793707814;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=c9cNvibdhc4Kldnmyj7BlP1RnuMmVJ9iTZkhv8EqO0A=;
	b=rHN1PgKzNj0646EhP5J7HN09HNKU53ouEZixpapPvQnL/Hvod0peBl9rzq+QI9sOJSk2
	 Ku8koIc+UQgS4K1rCndi7E6LoVWsq9V56Ehe1ZZvJVp8B9f+dcuyz+E616MXWamB2FXsm
	 lfYQZ8TbHTZSQZbIM7eyeIw9J4Z44JDTOuKmBZvmO2D72cQ1KguLO9y/iPzGxqBHKc3Xl
	 1uRgpWUiIGrSXk65GVkHnjhCLD2NCQxKbjkxpugpwagIiK0XJWISgaVH6AECR8jn2l3rB
	 29qlo/cnmAJjs8C6T+RGUev94jI2zQKd/SvOeRhs0nV2N7HSJfXTXGO8Kw9uAhHwItA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E3A606A32C
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Nov 2026 12:10:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 69E3A606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id E9FC460678; Tue, 03 Nov 2026 13:10:10 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH ipset] tests: hash:net,iface.t: check wildcard and nomatch ordering
Date: Tue,  3 Nov 2026 13:10:05 +0100
Message-ID: <20261103121005.20482-1-fw@strlen.de>
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

Add more checks that document existing match behaviour of this set type:

1) add a wildcard entry, then a second wildcard entry with nomatch whose
key overlaps first one.  Check the wildcard (first entry) wins.

2) add entry without wildcard and 5s timeout.
Add permanent entry with same key and wildcard.

1. Check that entry is matched
2. Wait for the entry to time out.
3. Check entry also matches via wildcard.

Re-check with different interface, check the wildcard matches.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/hash:net,iface.t | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/tests/hash:net,iface.t b/tests/hash:net,iface.t
index b1d92bef26f8..f1a36e33ff8f 100644
--- a/tests/hash:net,iface.t
+++ b/tests/hash:net,iface.t
@@ -260,5 +260,27 @@
 0 ipset test test 10.0.3.0/24,eth1
 # eth0 is excluded by the nomatch entry; it must not match via the wildcard.
 1 ipset test test 10.0.3.0/24,eth0
+0 ipset flush test
+# Add a wildcard entry
+0 ipset add test 10.0.4.0/24,eth wildcard
+# Add a second entry, same network, with nomatch
+0 ipset add test 10.0.4.0/24,et wildcard nomatch
+# Test wildcard entry match is preferred
+0 ipset test test 10.0.4.0/24,eth0
+0 ipset destroy test
+# Re-create the set with longer gc timeout.
+0 ipset create test hash:net,iface timeout 100
+# Add identical entry without wildcard, for eth0, 5s timeout
+0 ipset add test 10.0.5.0/24,eth0 timeout 5
+# Add permanent wildcard
+0 ipset add test 10.0.5.0/24,eth wildcard timeout 0
+# Test specific entry is matched
+0 ipset test test 10.0.5.0/24,eth0
+# Let the specific entry time out.
+0 sleep 8
+# Specific entry has expired. The wildcard entry must still match.
+0 ipset test test 10.0.5.0/24,eth0
+# Test a 2nd, unrelated interface matches the wildcard too.
+0 ipset test test 10.0.5.0/24,eth1
 0 ipset destroy test
 # eof
-- 
2.56.0

