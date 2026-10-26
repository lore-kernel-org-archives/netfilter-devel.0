Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793016464;
	b=TUsYVO7Bp6yXtHMZFfsfqgnsmcIcGnq2FBoHyO6MXXcJrCdmEvP0sHddxKpbGj7hXMmr
	 ob3m6v31GbdVrT3+gFiy6Nd3fg/xc6FWJeYLroiPv18RGMCQXz5QGk3BzPN3tXjl/ISub
	 nSZ0Mdb8yKAIX37msJUvNCgABCKIo00VzK8NrSGHVLkXIsUHu9Sdvy5jAklu+qiz/HUo3
	 sA5udj+IT821vajYQ0aTERL1bGhqxahNepyzvu9OsR1xHMl42R5NO8eY61V9hMNIriNyI
	 4Efk2SgDLAqK4XCDiXKNmqbqex79wIHCoC0dRVL5oN9QWuQh9Smn/L1dpqb+CNzC3iQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793016464;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:X-Spamd-Result:
	 X-Rspamd-Server:X-Rspamd-Action:X-Spam-Flag:X-Spam-Score:X-Spam-Level:
	 X-Rspamd-Queue-Id;
	bh=wza8EDDM8pse920kWAIpicgvu3xAuz30sMPjmSEZFfo=;
	b=d4eqoGwCQ9mMzYkYY2Odspcdd8+hq07N76uzYmlpQtOHp3pV/P2s+yMvAi/Jm5cK38uu
	 2FGJQp8WYxtLQk4nDAmoNYFdXPPFAGsV3/QY+S4DzgTCYeUXGaRfcm5P1ddH/YtUoFQyV
	 SY8rCtvRhf0mL1GVRPaRdtrFwH67aNeuQ5OdaFhkyhyAlUdGnz26JCWXLFrZfE3DLiHPC
	 D0VEqzb/7TVuwlam2mAhBayPmprT00T7ow02wxmYWGlwyuPbNLiUdgGAyEtHjjKy21ZpT
	 TB23+qVPWtFpTVSAfin8vwwwTLXVgQGw3ewIRrqr4/ZIlAehc2mER2uoMgSj5ppWzjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=suse.de;
	spf=pass smtp.mailfrom=suse.de;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=JlHrn4mo;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=9Yuu1LJa;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=1F204N0g;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=TfGuKjdZ;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA2F606A31D
	for <netfilter-devel@vger.kernel.org>; Mon, 26 Oct 2026 12:07:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7FA2F606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=JlHrn4mo;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=9Yuu1LJa;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=1F204N0g;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=TfGuKjdZ
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6B16821F99;
	Mon, 26 Oct 2026 12:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793016461; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=wza8EDDM8pse920kWAIpicgvu3xAuz30sMPjmSEZFfo=;
	b=JlHrn4moWH7oDpnicd74+unWXfXd7SjBlGouxTkRc0LqvvsSIT8ZAKbnT9sUXXGopW9PKv
	4A/iKqaUyyp1tbSHZCwPReOtuPyp5UTXXhZS+6wnuGp7ZJhwW96vS7JLa534HqV4MsiLf2
	x0gSijwihT5Wg5n//xEzeIVKxUqD8GI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793016461;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=wza8EDDM8pse920kWAIpicgvu3xAuz30sMPjmSEZFfo=;
	b=9Yuu1LJanN/VJc6DJUpAXpq9EAZnHa1/l24n8FgUSjd1Qf1M4HjtuuldG36ruUekxN3uTe
	QD0ae1C2SKO6+lBw==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=1F204N0g;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=TfGuKjdZ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793016460; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=wza8EDDM8pse920kWAIpicgvu3xAuz30sMPjmSEZFfo=;
	b=1F204N0gKwXCKcJnf40aoYl+OiLK6GS/Zn1JAn07c+1zJ+zUu3s0p4vtK26OckKprx2KB9
	KwykbxLIQ4XOlFOePlyXx781kMylEtOgcHjdg5jHCfe1rg8XDKwVOe/WHdVoYNVOSFy8E+
	iKM0l8zBEtwxX/BX8TYHVLMcMJt3mFo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793016460;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=wza8EDDM8pse920kWAIpicgvu3xAuz30sMPjmSEZFfo=;
	b=TfGuKjdZOanRo5UUxGGmW3zJOGQOLRjFUeInKbTGfhaiJGiKK4mZH33hm3k5CMSosnVoyv
	GOlpZuNlyV2UlbCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D4BDC13319;
	Mon, 26 Oct 2026 12:07:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id o+kUKYtC32rFIAAAD6G6ig
	(envelope-from <fmancera@suse.de>); Mon, 26 Oct 2026 12:07:39 +0000
From: Fernando Fernandez Mancera <fmancera@suse.de>
To: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org,
	pablo@netfilter.org,
	phil@nwl.cc,
	fw@strlen.de,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	VEGA <vega@nebusec.ai>
Subject: [PATCH nf] netfilter: x_tables: check target name before accessing verdict
Date: Mon, 26 Oct 2026 13:07:10 +0100
Message-ID: <20261026120710.4395-1-fmancera@suse.de>
X-Mailer: git-send-email 2.51.0
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
X-Spamd-Result: default: False [-12.01 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.de:email,suse.de:dkim];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_SEVEN(0.00)[7];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_COUNT_TWO(0.00)[2];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -12.01
X-Spam-Level: 
X-Rspamd-Queue-Id: 6B16821F99

Non-standard targets may contain only struct xt_entry_target.
mark_source_chains() nevertheless reads the target as an
xt_standard_target before checking its name, potentially reading four
bytes beyond a header-only target.

Check that the target is standard before reading its verdict.
Non-standard targets remain handled as fallthrough rules.

See the following KASAN trace:

BUG: KASAN: slab-out-of-bounds in translate_table+0x1660/0x1a40 [ip6_tables]
Read of size 4 at addr ffff88800ed56ff8 by task rep/432

Call Trace:
 kasan_report+0xfa/0x120
 translate_table+0x1660/0x1a40 [ip6_tables]
 do_ip6t_set_ctl+0x667/0xa76 [ip6_tables]
 nf_setsockopt+0x77/0xd0
 do_sock_setsockopt+0x118/0x490
 __sys_setsockopt+0xe4/0x160
 __x64_sys_setsockopt+0xbd/0x190
 do_syscall_64+0xde/0x4f0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Allocated by task 432:
 kasan_save_stack+0x2f/0x50
 __kasan_kmalloc+0x7f/0x90
 __kvmalloc_node_noprof+0x1b1/0x5c0
 xt_alloc_table_info+0x3c/0xa0
 do_ip6t_set_ctl+0x5ee/0xa76 [ip6_tables]
 nf_setsockopt+0x77/0xd0
 do_sock_setsockopt+0x118/0x490
 __sys_setsockopt+0xe4/0x160
 __x64_sys_setsockopt+0xbd/0x190
 do_syscall_64+0xde/0x4f0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Reported-by: VEGA <vega@nebusec.ai>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
---
 net/ipv4/netfilter/arp_tables.c | 5 +++--
 net/ipv4/netfilter/ip_tables.c  | 5 +++--
 net/ipv6/netfilter/ip6_tables.c | 5 +++--
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index cf747e1e17a3..7ff3d1f0ffd4 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -371,11 +371,12 @@ static int mark_source_chains(const struct xt_table_info *newinfo,
 				e->counters.pcnt = pos;
 				pos += size;
 			} else {
-				int newpos = t->verdict;
+				int newpos;
 
 				if (strcmp(t->target.u.user.name,
 					   XT_STANDARD_TARGET) == 0 &&
-				    newpos >= 0) {
+				    t->verdict >= 0) {
+					newpos = t->verdict;
 					/* This a jump; chase it. */
 					if (!xt_find_jump_offset(offsets, newpos,
 								 newinfo->number))
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 809441cedced..b302bd77180a 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -422,11 +422,12 @@ mark_source_chains(const struct xt_table_info *newinfo,
 				e->counters.pcnt = pos;
 				pos += size;
 			} else {
-				int newpos = t->verdict;
+				int newpos;
 
 				if (strcmp(t->target.u.user.name,
 					   XT_STANDARD_TARGET) == 0 &&
-				    newpos >= 0) {
+				    t->verdict >= 0) {
+					newpos = t->verdict;
 					/* This a jump; chase it. */
 					if (!xt_find_jump_offset(offsets, newpos,
 								 newinfo->number))
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 313c4aac377a..010baaa60665 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -440,11 +440,12 @@ mark_source_chains(const struct xt_table_info *newinfo,
 				e->counters.pcnt = pos;
 				pos += size;
 			} else {
-				int newpos = t->verdict;
+				int newpos;
 
 				if (strcmp(t->target.u.user.name,
 					   XT_STANDARD_TARGET) == 0 &&
-				    newpos >= 0) {
+				    t->verdict >= 0) {
+					newpos = t->verdict;
 					/* This a jump; chase it. */
 					if (!xt_find_jump_offset(offsets, newpos,
 								 newinfo->number))
-- 
2.56.0

