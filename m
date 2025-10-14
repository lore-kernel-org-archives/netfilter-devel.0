Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A712C0F7C
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Oct 2025 12:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760444461; cv=none; b=Y6ex9E22kpcgumD7TILKTA2gA1lpVDJ0S40ubeWBJ4CCuJxs1yBb9CtjFPWGfHXnGesBPB8JMF4eUEWXXo/yUTZr2B9G0xa+GWTtz6Jlu2+IrU4g4HjOSqOKWkihftkqNFF8ng+juePNdoaz9ymec6YrX5+YrIQ3W/HhMpCpRyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760444461; c=relaxed/simple;
	bh=dhQ1ZyT5FUYW6kd9sqJC75HiqzpEkvlYk4dH4OR32x4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MGsFzc306781Jku1vKBwLduC1wyH6mN1f8Su9QywU/iX4ca5OqN9VePPucwSGrOF2Aepu9iHyjqiT/dtpCJcn/Ok7Sc4f0Fnuyznsbz52LRa++67q/bOs3ob7dpA/8Lq7/qijQvEO0nFAtZhrjE7si20rfhS1CtTqDKE7o79twE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=QWy/BwSm; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=mLhTPaRQ; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=QWy/BwSm; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=mLhTPaRQ; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="QWy/BwSm";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="mLhTPaRQ";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="QWy/BwSm";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="mLhTPaRQ"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 02E341F391;
	Tue, 14 Oct 2025 12:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760444458; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=PIunIJJW+T16wRVDYo1PuSvzrrR3NMmn60XoKqAOZpI=;
	b=QWy/BwSmTmdpSqEMMUWJERvjt6gkbvOjB9ylVegM2tQhf1SXKC1TJ5mIovHLw/vmGuWBeA
	q8G/naFYFMyVhvIrN70ApywuyqTio0HyFBHX7j1EhCHBPfaf3d1+deaheQivDw6CV4llru
	/Ps5CIJV1k1z/V/GCYVGOZB0yBJaiWQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760444458;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=PIunIJJW+T16wRVDYo1PuSvzrrR3NMmn60XoKqAOZpI=;
	b=mLhTPaRQ+Ej8sWTGMSRiQVANw/7JyhbukynCPA/3vl5Ci8mHow8Tm6sN6p2D5kfPNuXcq0
	7zn0d5Hx6gG/6vCQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760444458; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=PIunIJJW+T16wRVDYo1PuSvzrrR3NMmn60XoKqAOZpI=;
	b=QWy/BwSmTmdpSqEMMUWJERvjt6gkbvOjB9ylVegM2tQhf1SXKC1TJ5mIovHLw/vmGuWBeA
	q8G/naFYFMyVhvIrN70ApywuyqTio0HyFBHX7j1EhCHBPfaf3d1+deaheQivDw6CV4llru
	/Ps5CIJV1k1z/V/GCYVGOZB0yBJaiWQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760444458;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=PIunIJJW+T16wRVDYo1PuSvzrrR3NMmn60XoKqAOZpI=;
	b=mLhTPaRQ+Ej8sWTGMSRiQVANw/7JyhbukynCPA/3vl5Ci8mHow8Tm6sN6p2D5kfPNuXcq0
	7zn0d5Hx6gG/6vCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B9C3E13A44;
	Tue, 14 Oct 2025 12:20:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Ym+oKilA7mhYewAAD6G6ig
	(envelope-from <fmancera@suse.de>); Tue, 14 Oct 2025 12:20:57 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH nft v2] meta: introduce meta ibrhwaddr support
Date: Tue, 14 Oct 2025 14:20:42 +0200
Message-ID: <20251014122042.28934-1-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:mid];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_TLS_ALL(0.00)[]
X-Spam-Flag: NO
X-Spam-Score: -2.80

Can be used in bridge prerouting hook to redirect the packet to the
receiving physical device for processing.

table bridge nat {
        chain PREROUTING {
                type filter hook prerouting priority 0; policy accept;
                ether daddr de:ad:00:00:be:ef meta pkttype set host ether daddr set meta ibrhwaddr accept
        }
}

Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
v2: rename the selector to ibrhwaddr
---
 include/linux/netfilter/nf_tables.h |  2 ++
 src/meta.c                          |  4 ++++
 tests/py/bridge/meta.t              |  1 +
 tests/py/bridge/pass_up.t           |  6 ++++++
 tests/py/bridge/pass_up.t.json      | 19 +++++++++++++++++++
 tests/py/bridge/pass_up.t.payload   |  4 ++++
 6 files changed, 36 insertions(+)
 create mode 100644 tests/py/bridge/pass_up.t
 create mode 100644 tests/py/bridge/pass_up.t.json
 create mode 100644 tests/py/bridge/pass_up.t.payload

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index b38d4780..45d0b92b 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -949,6 +949,7 @@ enum nft_exthdr_attributes {
  * @NFT_META_SDIF: slave device interface index
  * @NFT_META_SDIFNAME: slave device interface name
  * @NFT_META_BRI_BROUTE: packet br_netfilter_broute bit
+ * @NFT_META_BRI_IIFHWADDR: packet input bridge interface ethernet address
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -989,6 +990,7 @@ enum nft_meta_keys {
 	NFT_META_SDIFNAME,
 	NFT_META_BRI_BROUTE,
 	__NFT_META_IIFTYPE,
+	NFT_META_BRI_IIFHWADDR,
 };
 
 /**
diff --git a/src/meta.c b/src/meta.c
index 1010209d..c3648602 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -23,6 +23,7 @@
 #include <arpa/inet.h>
 #include <linux/netfilter.h>
 #include <linux/pkt_sched.h>
+#include <linux/if_ether.h>
 #include <linux/if_packet.h>
 #include <time.h>
 
@@ -704,6 +705,9 @@ const struct meta_template meta_templates[] = {
 						BYTEORDER_HOST_ENDIAN),
 	[NFT_META_BRI_BROUTE]	= META_TEMPLATE("broute",   &integer_type,
 						1    , BYTEORDER_HOST_ENDIAN),
+	[NFT_META_BRI_IIFHWADDR] = META_TEMPLATE("ibrhwaddr", &etheraddr_type,
+						 ETH_ALEN * BITS_PER_BYTE,
+						 BYTEORDER_BIG_ENDIAN),
 };
 
 static bool meta_key_is_unqualified(enum nft_meta_keys key)
diff --git a/tests/py/bridge/meta.t b/tests/py/bridge/meta.t
index 171aa610..1e312a27 100644
--- a/tests/py/bridge/meta.t
+++ b/tests/py/bridge/meta.t
@@ -11,3 +11,4 @@ meta protocol ip udp dport 67;ok
 meta protocol ip6 udp dport 67;ok
 
 meta broute set 1;fail
+meta ibrhwaddr;fail
diff --git a/tests/py/bridge/pass_up.t b/tests/py/bridge/pass_up.t
new file mode 100644
index 00000000..642fbafe
--- /dev/null
+++ b/tests/py/bridge/pass_up.t
@@ -0,0 +1,6 @@
+:prerouting;type filter hook prerouting priority 0
+
+*bridge;test-bridge;prerouting
+
+ether daddr set meta ibrhwaddr;ok
+meta ibrhwaddr set 00:1a:2b:3c:4d:5e;fail
diff --git a/tests/py/bridge/pass_up.t.json b/tests/py/bridge/pass_up.t.json
new file mode 100644
index 00000000..7d6a30bf
--- /dev/null
+++ b/tests/py/bridge/pass_up.t.json
@@ -0,0 +1,19 @@
+# ether daddr set meta ibrhwaddr
+[
+    {
+        "mangle": {
+            "key": {
+                "payload": {
+                    "field": "daddr",
+                    "protocol": "ether"
+                }
+            },
+            "value": {
+                "meta": {
+                    "key": "ibrhwaddr"
+                }
+            }
+        }
+    }
+]
+
diff --git a/tests/py/bridge/pass_up.t.payload b/tests/py/bridge/pass_up.t.payload
new file mode 100644
index 00000000..d76c6b94
--- /dev/null
+++ b/tests/py/bridge/pass_up.t.payload
@@ -0,0 +1,4 @@
+# ether daddr set meta ibrhwaddr
+bridge test-bridge prerouting
+  [ meta load ibrhwaddr => reg 1 ]
+  [ payload write reg 1 => 6b @ link header + 0 csum_type 0 csum_off 0 csum_flags 0x0 ]
-- 
2.51.0

