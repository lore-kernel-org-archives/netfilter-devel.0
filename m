Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D4E12EB5C9
	for <netfilter-devel@vger.kernel.org>; Mon, 13 Oct 2025 08:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760343813; cv=none; b=CP/bNlg9p4YHljOVrzeqU8aokdLl8MrsihD/K4DAba5wziNMrv7daw0Izn5gfXemaH1B/UOJQT+LyPnfC9Lh71PEQ+t9hFJzmLOpHyRZd7hsPorcIk35caYan9kU/txJwyE/g3sj/2FUZJlBeZhJ8hgA6Y4IuvjBPiCZeefzaQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760343813; c=relaxed/simple;
	bh=+Qs7nJ1ve7pUl+gz97jCL/JUfmBkvnm62JnC/tCglKs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tkpJEx37By8p64hpBvWpnLSVCcdDTWxf21jtlbmzYGBSeP6Xws08oqTbVJBkb7CmOAmKT/flKRUGEecFzCswbGpmI3bZTselM85FErgyBBhTwjjvYrVjnJYz8o4se5KoEmQJ/uU0tTQHXOyVFOMyxgC+m5bSLemEVD6KQHjKV2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=bH3Ns4dg; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=QJ/xx0XW; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=bH3Ns4dg; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=QJ/xx0XW; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="bH3Ns4dg";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="QJ/xx0XW";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="bH3Ns4dg";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="QJ/xx0XW"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4D2971F78B;
	Mon, 13 Oct 2025 08:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760343809; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=OZxy3IgKLZHntifKRbFl+tUbqQyFm2PHoQ7wXCqxkYM=;
	b=bH3Ns4dgxb32AB//latnWmEo6CvxtAJI23Lv3kKxA17pgPeOEV5MPDXzHC0jeG/qSY0KJu
	KjCHsfaOw1NsOh7ZnVhqPmNR5HJrW2QU+iY3kkvPQZs4VZk4zDJnyJD7PofRnKyeuqbrXF
	CqFJXnFt5UzUWHJc1zzHxwvGRP4Mhmo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760343809;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=OZxy3IgKLZHntifKRbFl+tUbqQyFm2PHoQ7wXCqxkYM=;
	b=QJ/xx0XWBaQjyQWOAg0QGrCwPGFiFMiKbEEERngCyb+NNXr3gimCfirS7sCRb1dzILRELn
	fbr9pWXFd+E/e9Aw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bH3Ns4dg;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="QJ/xx0XW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760343809; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=OZxy3IgKLZHntifKRbFl+tUbqQyFm2PHoQ7wXCqxkYM=;
	b=bH3Ns4dgxb32AB//latnWmEo6CvxtAJI23Lv3kKxA17pgPeOEV5MPDXzHC0jeG/qSY0KJu
	KjCHsfaOw1NsOh7ZnVhqPmNR5HJrW2QU+iY3kkvPQZs4VZk4zDJnyJD7PofRnKyeuqbrXF
	CqFJXnFt5UzUWHJc1zzHxwvGRP4Mhmo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760343809;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=OZxy3IgKLZHntifKRbFl+tUbqQyFm2PHoQ7wXCqxkYM=;
	b=QJ/xx0XWBaQjyQWOAg0QGrCwPGFiFMiKbEEERngCyb+NNXr3gimCfirS7sCRb1dzILRELn
	fbr9pWXFd+E/e9Aw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 042F713874;
	Mon, 13 Oct 2025 08:23:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1gzjOQC37GjnKQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 13 Oct 2025 08:23:28 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	fw@strlen.de,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH nft v2] tests: shell: add packetpath test for meta ibrhwdr
Date: Mon, 13 Oct 2025 10:23:14 +0200
Message-ID: <20251013082314.4043-1-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4D2971F78B
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	FROM_HAS_DN(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 

The test checks that the packets are processed by the bridge device and
not forwarded.

Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
v2: set ipv4 address on bridge, enable ip_forwarding and check ipv4 forward hook too.
---
 tests/shell/features/meta_ibrhwdr.nft         |   8 ++
 .../shell/testcases/packetpath/bridge_pass_up | 102 ++++++++++++++++++
 2 files changed, 110 insertions(+)
 create mode 100644 tests/shell/features/meta_ibrhwdr.nft
 create mode 100755 tests/shell/testcases/packetpath/bridge_pass_up

diff --git a/tests/shell/features/meta_ibrhwdr.nft b/tests/shell/features/meta_ibrhwdr.nft
new file mode 100644
index 00000000..ba9b3431
--- /dev/null
+++ b/tests/shell/features/meta_ibrhwdr.nft
@@ -0,0 +1,8 @@
+# cbd2257dc96e ("netfilter: nft_meta_bridge: introduce NFT_META_BRI_IIFHWADDR support")
+# v6.16-rc2-16052-gcbd2257dc96e
+table bridge nat {
+	chain PREROUTING {
+		type filter hook prerouting priority 0; policy accept;
+		ether daddr set meta ibrhwdr
+	}
+}
diff --git a/tests/shell/testcases/packetpath/bridge_pass_up b/tests/shell/testcases/packetpath/bridge_pass_up
new file mode 100755
index 00000000..d9689908
--- /dev/null
+++ b/tests/shell/testcases/packetpath/bridge_pass_up
@@ -0,0 +1,102 @@
+#!/bin/bash
+
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_meta_ibrhwdr)
+
+rnd=$(mktemp -u XXXXXXXX)
+ns1="nft1ifname-$rnd"
+ns2="nft2ifname-$rnd"
+ns3="nft3ifname-$rnd"
+
+cleanup()
+{
+	ip netns del "$ns1"
+	ip netns del "$ns2"
+	ip netns del "$ns3"
+}
+
+trap cleanup EXIT
+
+set -e
+
+ip netns add "$ns1"
+ip netns add "$ns2"
+ip netns add "$ns3"
+
+ip link add veth0 netns $ns1 type veth peer name veth0 netns $ns2
+ip link add veth1 netns $ns3 type veth peer name veth1 netns $ns2
+ip link add br0 netns $ns2 type bridge
+
+ip -net "$ns1" link set veth0 addr da:d3:00:01:02:03
+ip -net "$ns3" link set veth1 addr de:ad:00:00:be:ef
+
+ip -net "$ns2" link set veth0 master br0
+ip -net "$ns2" link set veth1 master br0
+
+ip -net "$ns1" link set veth0 up
+ip -net "$ns2" link set veth0 up
+ip -net "$ns3" link set veth1 up
+ip -net "$ns2" link set veth1 up
+ip -net "$ns2" link set br0 up
+
+ip netns exec "$ns2" sysctl -q net.ipv4.ip_forward=1
+
+ip -net "$ns1" addr add 10.1.1.10/24 dev veth0
+ip -net "$ns3" addr add 10.1.1.20/24 dev veth1
+ip -net "$ns2" addr add 10.1.1.1/24 dev br0
+
+ip netns exec "$ns2" $NFT -f /dev/stdin <<"EOF"
+table bridge nat {
+	chain PREROUTING {
+		type filter hook prerouting priority 0; policy accept;
+		ether daddr de:ad:00:00:be:ef meta pkttype set host ether daddr set meta ibrhwdr meta mark set 1
+	}
+}
+
+table bridge process {
+	chain INPUT {
+		type filter hook input priority 0; policy accept;
+		ip protocol icmp meta mark 1 counter
+	}
+}
+
+table bridge donotprocess {
+	chain FORWARD {
+		type filter hook forward priority 0; policy accept;
+		ip protocol icmp meta mark 1 counter
+	}
+}
+
+table ip process {
+	chain FORWARD {
+		type filter hook forward priority 0; policy accept;
+		ip protocol icmp meta mark 1 counter
+	}
+}
+EOF
+
+ip netns exec "$ns1" ping -c 1 10.1.1.20 || true
+
+set +e
+
+ip netns exec "$ns2" $NFT list table bridge process | grep 'counter packets 0'
+if [ $? -eq 0 ]
+then
+	echo "Failure: packets not seen at bridge input hook"
+	exit 1
+fi
+
+ip netns exec "$ns2" $NFT list table bridge donotprocess | grep 'counter packets 0'
+if [ $? -eq 1 ]
+then
+	echo "Failure: packets seen at bridge forward hook"
+	exit 1
+fi
+
+ip netns exec "$ns2" $NFT list table ip process | grep 'counter packets 0'
+if [ $? -eq 0 ]
+then
+	echo "Failure: packets not seen at ipv4 forward hook"
+	exit 1
+fi
+
+exit 0
-- 
2.51.0

