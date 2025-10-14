Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0594F312802
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Oct 2025 12:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760444500; cv=none; b=ucEPklRzjVXTgoSzcZjlRtQR+mpQ0P2mgDb0KR3xYFeur0BBQZUB8f7N87oxAMhpmYN6i8/UzfNKlbDuvdnKrUPYeguDebKbKZtIHGMyoTKHAqgLDiKKJVOP7ZtKsO6elqts6ziaa2YqP3Zc4PeHfC0qOshjHlHvVydUo5d8hJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760444500; c=relaxed/simple;
	bh=c1kvb5CKLy9E8ii8xNFMSI+DhYkQB2D++o0JpGJYQ04=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aPuCXgBM65gmE3HBYQAoRXpiUW70TqYKNdHBh9sfYMo2ZH8VZcFQ3Me3C3w/8L+QE8LUxTM+fBe1GkuMJ2NAGayoAOLlMX/bTb1WxeU5fZe9cQ/Qj0jXS6rVyegtW4YOgGqwrYzH8yK3SOFDmykugESOIc8KPYHPtLOuHkijLTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=oB3YkEb4; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=lBG+2BC7; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=IEZFGMfF; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=acmFSaW6; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="oB3YkEb4";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="lBG+2BC7";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="IEZFGMfF";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="acmFSaW6"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id ECD1421D6C;
	Tue, 14 Oct 2025 12:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760444496; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=TsYO/+7h4Y0El9rkFTmnxUOx60FL+daInOGInmYPx2w=;
	b=oB3YkEb4CrIay2ORqyh5UdfgkXs9aXHGXmII8hnRyLlNzXKmSXqm5AXIccEFBiegObLbBh
	oPi9mcCVjrw7lfwuYLqkNegH9zFlbK4inzM3cRCAWwWPQt/p1fLPbzW74JeJh1UTczoIjU
	iDFrXSXk5s78+hkIV+brr9GcF/MeiYU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760444496;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=TsYO/+7h4Y0El9rkFTmnxUOx60FL+daInOGInmYPx2w=;
	b=lBG+2BC7o46PP5B7mpxX5AbeTnteEI0LzZxVbFBTqk4tO0GO79G0gD7G1HYzx71Eq4Tnxs
	xPqEZeeBM3BDXQAQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=IEZFGMfF;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=acmFSaW6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760444495; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=TsYO/+7h4Y0El9rkFTmnxUOx60FL+daInOGInmYPx2w=;
	b=IEZFGMfFFKVwTkq4ayUaHBZqMI5yr9DaZ+LOGbBTnWgLxqvoMSsW8Vhx1N6irRFfGnKEga
	1xeldTHlnn87B3Zaviu3btLliVlu5iUIWOX4sW3sKusCNcPMR0YCDk73vVMJQiOGBkFIcU
	81Xt3Imv1239s+8cznt5Juok8v5K+X4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760444495;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=TsYO/+7h4Y0El9rkFTmnxUOx60FL+daInOGInmYPx2w=;
	b=acmFSaW6HwJ8g6GoNpyyUlQCRj645Xr6sHvS4KuDorf+ZAQ+XmHoXF7OD4wGll1+oU28cB
	vm+ih8K/fByoUtDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AC7B913A44;
	Tue, 14 Oct 2025 12:21:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oRNHJ09A7mjYewAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 14 Oct 2025 12:21:35 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH nft v3] tests: shell: add packetpath test for meta ibrhwaddr
Date: Tue, 14 Oct 2025 14:21:28 +0200
Message-ID: <20251014122128.28956-1-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: ECD1421D6C
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
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid,suse.de:dkim];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
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
v3: rename to ibrhwaddr
---
 tests/shell/features/meta_ibrhwaddr.nft       |   8 ++
 .../shell/testcases/packetpath/bridge_pass_up | 102 ++++++++++++++++++
 2 files changed, 110 insertions(+)
 create mode 100644 tests/shell/features/meta_ibrhwaddr.nft
 create mode 100755 tests/shell/testcases/packetpath/bridge_pass_up

diff --git a/tests/shell/features/meta_ibrhwaddr.nft b/tests/shell/features/meta_ibrhwaddr.nft
new file mode 100644
index 00000000..e41abac8
--- /dev/null
+++ b/tests/shell/features/meta_ibrhwaddr.nft
@@ -0,0 +1,8 @@
+# cbd2257dc96e ("netfilter: nft_meta_bridge: introduce NFT_META_BRI_IIFHWADDR support")
+# v6.16-rc2-16052-gcbd2257dc96e
+table bridge nat {
+	chain PREROUTING {
+		type filter hook prerouting priority 0; policy accept;
+		ether daddr set meta ibrhwaddr
+	}
+}
diff --git a/tests/shell/testcases/packetpath/bridge_pass_up b/tests/shell/testcases/packetpath/bridge_pass_up
new file mode 100755
index 00000000..50c5fc8d
--- /dev/null
+++ b/tests/shell/testcases/packetpath/bridge_pass_up
@@ -0,0 +1,102 @@
+#!/bin/bash
+
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_meta_ibrhwaddr)
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
+		ether daddr de:ad:00:00:be:ef meta pkttype set host ether daddr set meta ibrhwaddr meta mark set 1
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

