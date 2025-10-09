Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA62202976
	for <netfilter-devel@vger.kernel.org>; Thu,  9 Oct 2025 16:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760027097; cv=none; b=ttpvt1XLiKmMwkrJF5nraN7rbLU6O+ESTEYvI+oDZrwK0nmh5BV/YIAZ0Bmz+p69XRUeRPNkLAUcuzAW2KQ913w9EwTeBZDGtBrzED03eiQGRUentstKRtlkubKZKlRAnmfLE3unhoUsKp+/WkXe9DUghVCJnkoof2jyP/XnOm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760027097; c=relaxed/simple;
	bh=xTGuKVLx0l16AzN0bsAwjIAOTnl0tUYnmjy3AsO+2FQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rKJR6lrtxGHoPIROXZHRTFuFcA4yGZ5H/XdIZiGqGoYFK9/BPbxWGwcpLoh4HA1wG7QOq9MK5wTI9WFs97mJa0BlYMbqxdw9+cCu+Jjw3J4amOTdyIdLPVrk4dCR/bcJHlrsOghKacXGJ+qaSgNeFSRTQv60ujK0U1AOx/PN414=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ubHpd0uR; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=vywo+m0X; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=ubHpd0uR; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=vywo+m0X; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ubHpd0uR";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="vywo+m0X";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="ubHpd0uR";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="vywo+m0X"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1168C22567;
	Thu,  9 Oct 2025 16:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760027093; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=16jOmB7tvwmDn7am8xNEkJrNM3hBgm4EF9wgbhJHDsU=;
	b=ubHpd0uRPTnqXR4jA2DDsdRhtQqbS0xaN69t/GEpDHmg9FYCCnY2Ve5pFwoxnMGazZVbJW
	BzXbKgyfjAtbdFFegCTo5LoPSwnZskYU3AfdL2PxV2K8HSGVx4v1eorFtR3ovny6Mmmi4I
	Gz2OqQB37sCxApCbAjwEHdQAnL2XFqI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760027093;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=16jOmB7tvwmDn7am8xNEkJrNM3hBgm4EF9wgbhJHDsU=;
	b=vywo+m0XSAqPzMsbJq4Sq9dBISIuXmaGoshVS1SvIxKfYXidLzoQa+W9LDpCPlU24Ot5S9
	e2nQ5BU6nnz4mmDA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ubHpd0uR;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=vywo+m0X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760027093; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=16jOmB7tvwmDn7am8xNEkJrNM3hBgm4EF9wgbhJHDsU=;
	b=ubHpd0uRPTnqXR4jA2DDsdRhtQqbS0xaN69t/GEpDHmg9FYCCnY2Ve5pFwoxnMGazZVbJW
	BzXbKgyfjAtbdFFegCTo5LoPSwnZskYU3AfdL2PxV2K8HSGVx4v1eorFtR3ovny6Mmmi4I
	Gz2OqQB37sCxApCbAjwEHdQAnL2XFqI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760027093;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=16jOmB7tvwmDn7am8xNEkJrNM3hBgm4EF9wgbhJHDsU=;
	b=vywo+m0XSAqPzMsbJq4Sq9dBISIuXmaGoshVS1SvIxKfYXidLzoQa+W9LDpCPlU24Ot5S9
	e2nQ5BU6nnz4mmDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BA34713AA6;
	Thu,  9 Oct 2025 16:24:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QzvoKdTh52hKOQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Thu, 09 Oct 2025 16:24:52 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH nft] tests: shell: add packetpath test for meta ibrhwdr
Date: Thu,  9 Oct 2025 18:24:39 +0200
Message-ID: <20251009162439.4232-1-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1168C22567
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,suse.de:dkim,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FROM_EQ_ENVFROM(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 

The test checks that the packets are processed by the bridge device and
not forwarded.

Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
Please keep on mind that this requires:
* https://lore.kernel.org/netfilter-devel/20250902113529.5456-1-fmancera@suse.de/
* https://lore.kernel.org/netfilter-devel/20250902113216.5275-1-fmancera@suse.de/
---
 tests/shell/features/meta_ibrhwdr.nft         |  8 ++
 .../shell/testcases/packetpath/bridge_pass_up | 83 +++++++++++++++++++
 2 files changed, 91 insertions(+)
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
index 00000000..f83d6159
--- /dev/null
+++ b/tests/shell/testcases/packetpath/bridge_pass_up
@@ -0,0 +1,83 @@
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
+ip -net "$ns1" addr add 10.1.1.10/24 dev veth0
+ip -net "$ns3" addr add 10.1.1.20/24 dev veth1
+
+ip netns exec "$ns2" $NFT -f /dev/stdin <<"EOF"
+table bridge nat {
+	chain PREROUTING {
+		type filter hook prerouting priority 0; policy accept;
+		ether daddr de:ad:00:00:be:ef meta pkttype set host ether daddr set meta ibrhwdr
+	}
+}
+
+table bridge process {
+	chain INPUT {
+		type filter hook input priority 0; policy accept;
+		ip protocol icmp ether saddr da:d3:00:01:02:03 counter
+	}
+}
+
+table bridge donotprocess {
+	chain FORWARD {
+		type filter hook forward priority 0; policy accept;
+		ip protocol icmp ether saddr da:d3:00:01:02:03 counter
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
+	exit 1
+fi
+
+ip netns exec "$ns2" $NFT list table bridge donotprocess | grep 'counter packets 0'
+if [ $? -eq 1 ]
+then
+	exit 1
+fi
+
+exit 0
-- 
2.51.0

