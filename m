Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31BBC2F690F
	for <netfilter-devel@vger.kernel.org>; Mon,  6 Apr 2026 21:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775510323; cv=none; b=s8sRfS9OJSn2K2fo6yNXepSvx1npN95XngFwdi6xUE5GoQqNI4BSyikD7DaSqnfxCVoDZXIjq7rHgOIvc2HUysgFSbgafepjhZsZw7RqtFiI449Ce53KJ7f5yWiUCFZEkLThWPe/7hu348bWqIaqnNyTr+tSou8ZGdC7xfwkBec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775510323; c=relaxed/simple;
	bh=v6EVKbIWpLhlaG23jNkBdRtjv2Xhxal/iMgd8gicg4o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IDlGuFCsX93yHQLUoLkE/l7zXt7tzMKoxzZTcrMXixlrxhR5uzAB4K78FnEN6SS9aO1uHUEQA3Pe94BWX8bAH7XLpaTZflXs7v2T4/yt3vPFWtdHZkUeAojJhdTk78ca/E2UozzDmxYsHCzZskxdiAivemgPiGM5nr0qCCRaOjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=wNCkcWmv; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=+K4I52z9; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=wNCkcWmv; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=+K4I52z9; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="wNCkcWmv";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="+K4I52z9";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="wNCkcWmv";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="+K4I52z9"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 368E25BD48;
	Mon,  6 Apr 2026 21:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1775510320; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=JNShLGtF/R+q5EqfrfnvrzpMVHk6e2J804m0xooKGAo=;
	b=wNCkcWmvRYv4vrrlXDSAiAPXLcMzNKRpY4Cf5g+kZolUUHOTCt1jWBJuEdUYQvbPN2NY+R
	T84ByONZyQ9zXonG1/xlYBwaHmdgy+sIACMo0aASi8aGXa62k64S0gyrPDsPe8i0JvD7VB
	BM569OrN+FRGr434IQf/KvcceACaGLw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1775510320;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=JNShLGtF/R+q5EqfrfnvrzpMVHk6e2J804m0xooKGAo=;
	b=+K4I52z9G1bBYN914RpJKi5f//GrIY+L1u8jDwsTsLgelmn9/FlRtYA9TI6TKhpaPR5oPe
	7iw6kiLmpNF2+RAA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wNCkcWmv;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=+K4I52z9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1775510320; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=JNShLGtF/R+q5EqfrfnvrzpMVHk6e2J804m0xooKGAo=;
	b=wNCkcWmvRYv4vrrlXDSAiAPXLcMzNKRpY4Cf5g+kZolUUHOTCt1jWBJuEdUYQvbPN2NY+R
	T84ByONZyQ9zXonG1/xlYBwaHmdgy+sIACMo0aASi8aGXa62k64S0gyrPDsPe8i0JvD7VB
	BM569OrN+FRGr434IQf/KvcceACaGLw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1775510320;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=JNShLGtF/R+q5EqfrfnvrzpMVHk6e2J804m0xooKGAo=;
	b=+K4I52z9G1bBYN914RpJKi5f//GrIY+L1u8jDwsTsLgelmn9/FlRtYA9TI6TKhpaPR5oPe
	7iw6kiLmpNF2+RAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B5B894A0B0;
	Mon,  6 Apr 2026 21:18:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3jJUKC8j1GlMAQAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 06 Apr 2026 21:18:39 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	phil@nwl.cc,
	fw@strlen.de,
	pablo@netfilter.org,
	Fernando Fernandez Mancera <fmancera@suse.de>
Subject: [PATCH nf] selftests: nft_queue.sh: add a parallel stress test
Date: Mon,  6 Apr 2026 23:18:31 +0200
Message-ID: <20260406211831.3758-1-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:mid,suse.de:dkim,suse.de:email];
	FROM_HAS_DN(0.00)[];
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
	RCPT_COUNT_FIVE(0.00)[6];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 368E25BD48

Introduce a new stress test to check for race conditions in the
nfnetlink_queue subsystem, where an entry is freed while another CPU is
concurrently walking the global rhashtable.

To trigger this, `nf_queue.c` is extended with two new flags:
  * -O (out-of-order): Buffers packet IDs and flushes them in reverse.
  * -b (bogus verdicts): Floods the kernel with non-existent packet IDs.

The bogus verdict loop forces the kernel's lookup function to perform
full rhashtable bucket traversals (-ENOENT). Combined with reverse-order
flushing and heavy parallel UDP/ping flooding across 8 queues, this puts
the nfnetlink_queue code under pressure.

Joint work with Florian Westphal.

Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
 .../selftests/net/netfilter/nf_queue.c        | 50 +++++++++--
 .../selftests/net/netfilter/nft_queue.sh      | 83 ++++++++++++++++---
 2 files changed, 115 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/nf_queue.c b/tools/testing/selftests/net/netfilter/nf_queue.c
index 116c0ca0eabb..8bbec37f5356 100644
--- a/tools/testing/selftests/net/netfilter/nf_queue.c
+++ b/tools/testing/selftests/net/netfilter/nf_queue.c
@@ -19,6 +19,8 @@ struct options {
 	bool count_packets;
 	bool gso_enabled;
 	bool failopen;
+	bool out_of_order;
+	bool bogus_verdict;
 	int verbose;
 	unsigned int queue_num;
 	unsigned int timeout;
@@ -31,7 +33,7 @@ static struct options opts;
 
 static void help(const char *p)
 {
-	printf("Usage: %s [-c|-v [-vv] ] [-o] [-t timeout] [-q queue_num] [-Qdst_queue ] [ -d ms_delay ] [-G]\n", p);
+	printf("Usage: %s [-c|-v [-vv] ] [-o] [-O] [-b] [-t timeout] [-q queue_num] [-Qdst_queue ] [ -d ms_delay ] [-G]\n", p);
 }
 
 static int parse_attr_cb(const struct nlattr *attr, void *data)
@@ -275,7 +277,9 @@ static int mainloop(void)
 	unsigned int buflen = 64 * 1024 + MNL_SOCKET_BUFFER_SIZE;
 	struct mnl_socket *nl;
 	struct nlmsghdr *nlh;
+	uint32_t ooo_ids[16];
 	unsigned int portid;
+	int ooo_count = 0;
 	char *buf;
 	int ret;
 
@@ -308,6 +312,9 @@ static int mainloop(void)
 
 		ret = mnl_cb_run(buf, ret, 0, portid, queue_cb, NULL);
 		if (ret < 0) {
+			/* bogus verdict mode will generate ENOENT error messages */
+			if (opts.bogus_verdict && errno == ENOENT)
+				continue;
 			perror("mnl_cb_run");
 			exit(EXIT_FAILURE);
 		}
@@ -316,10 +323,35 @@ static int mainloop(void)
 		if (opts.delay_ms)
 			sleep_ms(opts.delay_ms);
 
-		nlh = nfq_build_verdict(buf, id, opts.queue_num, opts.verdict);
-		if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
-			perror("mnl_socket_sendto");
-			exit(EXIT_FAILURE);
+		if (opts.bogus_verdict) {
+			for (int i = 0; i < 50; i++) {
+				nlh = nfq_build_verdict(buf, id + 0x7FFFFFFF + i,
+							opts.queue_num, opts.verdict);
+				mnl_socket_sendto(nl, nlh, nlh->nlmsg_len);
+			}
+		}
+
+		if (opts.out_of_order) {
+			ooo_ids[ooo_count] = id;
+			if (ooo_count >= 15) {
+				for (ooo_count; ooo_count >= 0; ooo_count--) {
+					nlh = nfq_build_verdict(buf, ooo_ids[ooo_count],
+								opts.queue_num, opts.verdict);
+					if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
+						perror("mnl_socket_sendto");
+						exit(EXIT_FAILURE);
+					}
+				}
+				ooo_count = 0;
+			} else {
+				ooo_count++;
+			}
+		} else {
+			nlh = nfq_build_verdict(buf, id, opts.queue_num, opts.verdict);
+			if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
+				perror("mnl_socket_sendto");
+				exit(EXIT_FAILURE);
+			}
 		}
 	}
 
@@ -332,7 +364,7 @@ static void parse_opts(int argc, char **argv)
 {
 	int c;
 
-	while ((c = getopt(argc, argv, "chvot:q:Q:d:G")) != -1) {
+	while ((c = getopt(argc, argv, "chvoObt:q:Q:d:G")) != -1) {
 		switch (c) {
 		case 'c':
 			opts.count_packets = true;
@@ -375,6 +407,12 @@ static void parse_opts(int argc, char **argv)
 		case 'v':
 			opts.verbose++;
 			break;
+		case 'O':
+			opts.out_of_order = true;
+			break;
+		case 'b':
+			opts.bogus_verdict = true;
+			break;
 		}
 	}
 
diff --git a/tools/testing/selftests/net/netfilter/nft_queue.sh b/tools/testing/selftests/net/netfilter/nft_queue.sh
index ea766bdc5d04..1e1949c6a918 100755
--- a/tools/testing/selftests/net/netfilter/nft_queue.sh
+++ b/tools/testing/selftests/net/netfilter/nft_queue.sh
@@ -11,6 +11,7 @@ ret=0
 timeout=5
 
 SCTP_TEST_TIMEOUT=60
+STRESS_TEST_TIMEOUT=300
 
 cleanup()
 {
@@ -719,6 +720,74 @@ EOF
 	fi
 }
 
+check_tainted()
+{
+	local msg="$1"
+
+	if [ "$tainted_then" -ne 0 ];then
+		return
+	fi
+
+	read tainted_now < /proc/sys/kernel/tainted
+	if [ "$tainted_now" -eq 0 ];then
+		echo "PASS: $msg"
+	else
+		echo "TAINT: $msg"
+		dmesg
+		ret=1
+	fi
+}
+
+test_queue_stress()
+{
+	read tainted_then < /proc/sys/kernel/tainted
+	local i
+
+        ip netns exec "$nsrouter" nft -f /dev/stdin <<EOF
+flush ruleset
+table inet t {
+	chain forward {
+		type filter hook forward priority 0; policy accept;
+
+		queue flags bypass to numgen random mod 8
+	}
+}
+EOF
+	timeout "$STRESS_TEST_TIMEOUT" ip netns exec "$ns2" \
+		socat -u UDP-LISTEN:12345,fork,pf=ipv4 STDOUT > /dev/null &
+
+	timeout "$STRESS_TEST_TIMEOUT" ip netns exec "$ns3" \
+		socat -u UDP-LISTEN:12345,fork,pf=ipv4 STDOUT > /dev/null &
+
+	for i in $(seq 0 7); do
+		ip netns exec "$nsrouter" timeout "$STRESS_TEST_TIMEOUT" \
+			./nf_queue -q $i -t 2 -O -b > /dev/null &
+	done
+
+	ip netns exec "$ns1" timeout "$STRESS_TEST_IMEOUT" \
+		ping -q -f 10.0.2.99 > /dev/null 2>&1 &
+	ip netns exec "$ns1" timeout "$STRESS_TEST_TIMEOUT" \
+		ping -q -f 10.0.3.99 > /dev/null 2>&1 &
+	ip netns exec "$ns1" timeout "$STRESS_TEST_TIMEOUT" \
+		ping -q -f "dead:2::99" > /dev/null 2>&1 &
+	ip netns exec "$ns1" timeout "$STRESS_TEST_TIMEOUT" \
+		ping -q -f "dead:3::99" > /dev/null 2>&1 &
+
+	busywait "$BUSYWAIT_TIMEOUT" udp_listener_ready "$ns2" 12345
+	busywait "$BUSYWAIT_TIMEOUT" udp_listener_ready "$ns3" 12345
+
+	for i in $(seq 1 4);do
+		ip netns exec "$ns1" timeout "$STRESS_TEST_TIMEOUT" \
+			socat -u STDIN UDP-DATAGRAM:10.0.2.99:12345 < /dev/zero > /dev/null &
+		ip netns exec "$ns1" timeout "$STRESS_TEST_TIMEOUT" \
+			socat -u STDIN UDP-DATAGRAM:10.0.3.99:12345 < /dev/zero > /dev/null &
+	done
+
+	wait
+
+	check_tainted "concurrent queueing"
+}
+
 test_queue_removal()
 {
 	read tainted_then < /proc/sys/kernel/tainted
@@ -742,18 +811,7 @@ EOF
 
 	ip netns exec "$ns1" nft flush ruleset
 
-	if [ "$tainted_then" -ne 0 ];then
-		return
-	fi
-
-	read tainted_now < /proc/sys/kernel/tainted
-	if [ "$tainted_now" -eq 0 ];then
-		echo "PASS: queue program exiting while packets queued"
-	else
-		echo "TAINT: queue program exiting while packets queued"
-		dmesg
-		ret=1
-	fi
+	check_tainted "queue program exiting while packets queued"
 }
 
 ip netns exec "$nsrouter" sysctl net.ipv6.conf.all.forwarding=1 > /dev/null
@@ -799,6 +857,7 @@ test_sctp_forward
 test_sctp_output
 test_udp_nat_race
 test_udp_gro_ct
+test_queue_stress
 
 # should be last, adds vrf device in ns1 and changes routes
 test_icmp_vrf
-- 
2.53.0

