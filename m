Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C59362133
	for <netfilter-devel@vger.kernel.org>; Mon, 13 Jul 2026 16:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783960474; cv=none; b=uKrGq0rZJ8l38UpuaWlY6W8Xnz6M529jVFPx8dR58NHO9NKQKk1Ks1l6xMEejBMAWd50JcPyuYrgH3IQ2F4jXAxT3mdXveWvHsiC87g1Q7ePzvebFnuwo7JVVNOf5x3onUaQ1MDA7dbcavWFoc7GbAoVI14vQ5+oIJzAE4qhisg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783960474; c=relaxed/simple;
	bh=i2xJ03C51CJD6Lr8+AW4JJYOEHv1to9FFj52n/dJlPc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ckj6JnlmbFMHHiC9Scozf8wH/H8PsTOOzK4MWrwbiwEAT8pVOQfri2Xjk+D0q+/VRnGPoiaKJ0cCAgMwMnSfe2xLcNy6ZJWhgBvPNzVW+KbKPmmZsGG0+Bqray/0EjGbVWx+19aNEe5idWbgElH2Ligak/9IqbEzX8I/BKXo+4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MJqBkbip; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MJqBkbip"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-383cb94f742so2996287a91.3
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Jul 2026 09:34:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783960473; x=1784565273; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=RM63TYqsinly5sLCnipxpmwH364OMd0EzvumJ2wtwGE=;
        b=MJqBkbip0Za3MaR0Zx95OsKhK1bU75OK/7+yRSRE6kubuolvfDcqlh6bykbZexxNBv
         OMqyHRmtwEvHie5Qk8FFIxVeToSwJEW+LE9rUz/apZ2GKlowFvSHW+Tu1l8ydA95NXOZ
         wfMSN3xKzXUtzpnWDbqr9VzKmW0emuY7j3+WEwhPBzaZV0XAXT6XBviUKiQgZgxQLpO3
         6B/9ydbyR4cll5OewHxo02istppt009xDt/uT3juZLQa0lPVMY1H8EOIgWWjVQQcP+JW
         pPnAY+5Dz6qoi0hIbLY/W4GOO5ncnoYuIocyHiA3lt8ZiakwD3upIvHIcXKODALpgj4c
         RPnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783960473; x=1784565273;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RM63TYqsinly5sLCnipxpmwH364OMd0EzvumJ2wtwGE=;
        b=X6TtQapNn7KVNFt8RbRHI6lu6QrIIweng0Aqc7Tc24gES3r72a8kfvXMPk6qgv7qsH
         Fo2pbw7/l9GUAZJlQ4Rb8a2yyNec7uaIlV9a3xFI/r57TQLTU2GHq6xhWmzGOOlFwRDy
         WRyDjexfmheIgFkpP2peEW3k8lUBgv487AYBX2WOWO8MGvSkMXhaKpt2DZH2+mnOeUaY
         JeUkMh9bboTFmJ03mrYDmIrBNp6TFO9CdigEiN73VCTzsxC+tCnyxfmfwCxk/iTPM9R3
         gW4AuUecauYfIzctfswm28HaxZOeQbeTMfrNOLu9ZhEhjDM2sxOmB8L0tkNrLPeia9B5
         quRg==
X-Gm-Message-State: AOJu0YxQCy33EEb90xgXwsOw1JOupTeeQ9K8n//GWIzxvMvjRZB33qRD
	rebaJ1h9ywyEMmDdD76Ipl91mhkU5qc5B8ynah0IJqJiQ3JpAMNhWSM/lRHsKKyO8pY=
X-Gm-Gg: AfdE7cnqYQA+63i6lgSLJGRVpu9kE9fQlnNPqttl+ndY8mNJh6YsUfAJ+rM568JT9+4
	fZ6jkg+vk4MLbs810mWVZ5VGM3PG379n0yYvbCuffxCzdR+a5teK940rYtPVva6GxBfN4igUxLr
	zBFCz7gTgJYwKSMLgGJVU7lzZHf03IDhIIPSyESzX3ntbe2yIAnlmYwCeVSFdeu1JRU1bX9UFZY
	FLuvCgC0xYApg+wbmDHXAoKoKCbP2YnBsfXe9oi5ZiDf5vkZC/T43p12PLaqxfTkGAZ/etieE2b
	WPxVYZX+O+j8d/YFyvyNla8M2mfFWMbrgnyv593iHYT2inW0eVGAQN+G+oI4RTj4K/UkNQi+E+J
	nul0HgsSe3xjCDe2THgoJjZ/KLnOXxSYWYFVlulVktBpkD+1POwvSQo93PkuGbQIRVQYGarWekU
	6Putni2zvL0hg9khIlJvaMUqgTYe6ukd3Vn535bPltVa2yN9rGxvViQtJMsH5yOCWRyzE2
X-Received: by 2002:a17:90b:510a:b0:38c:a59b:5189 with SMTP id 98e67ed59e1d1-38dc7a3e3a9mr9034978a91.15.1783960472613;
        Mon, 13 Jul 2026 09:34:32 -0700 (PDT)
Received: from fx.tailc0aff1.ts.net ([206.206.192.132])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3118ee6091dsm81674219eec.14.2026.07.13.09.34.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 09:34:32 -0700 (PDT)
From: Weiming Shi <bestswngs@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>
Subject: [PATCH nf-next v3] netfilter: ipset: skip extension destroy on hash resize replay
Date: Mon, 13 Jul 2026 09:33:55 -0700
Message-ID: <20260713163354.3533575-2-bestswngs@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

During a hash set resize, mtype_resize() copies each element into the
new table with memcpy(), so the new-table element shares the old-table
element's comment extension.  An xt_SET delete on the old table during
the resize destroys that shared comment via ip_set_ext_destroy() and
queues a replayed delete on h->ad.  After the table swap mtype_resize()
replays it with mtype_del() on the new table, whose copy still points at
the freed comment, so ip_set_ext_destroy() frees it a second time:

 ODEBUG: activate active (active state 1) object: ... object type: rcu_head
 WARNING: CPU: 3 PID: 5311 at lib/debugobjects.c:514 debug_print_object
 Call Trace:
  <IRQ>
  kvfree_call_rcu (kernel/rcu/tree.c:3825)
  ip_set_comment_free (net/netfilter/ipset/ip_set_core.c:397)
  hash_ip4_del (net/netfilter/ipset/ip_set_hash_gen.h:1098)
  hash_ip4_kadt (net/netfilter/ipset/ip_set_hash_ip.c:96)
  ip_set_del (net/netfilter/ipset/ip_set_core.c:813)
  set_target_v3 (net/netfilter/xt_set.c:412)
  ipt_do_table (net/ipv4/netfilter/ip_tables.c:346)
  __ip_local_out (net/ipv4/ip_output.c:119)
  icmp_push_reply (net/ipv4/icmp.c:397)
  __icmp_send (net/ipv4/icmp.c:804)
  __udp4_lib_rcv (net/ipv4/udp.c:2521)
  ip_local_deliver (net/ipv4/ip_input.c:254)
  ip_rcv (net/ipv4/ip_input.c:569)
  </IRQ>

The replay passes a NULL ext (the kernel-side delete that queued it
already destroyed the extensions), so skip ip_set_ext_destroy() when ext
is NULL.

Reachable from an unprivileged user namespace.

Fixes: f66ee0410b1c ("netfilter: ipset: Fix \"INFO: rcu detected stall in hash_xxx\" reports")
Reported-by: Xiang Mei <xmei5@asu.edu>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
---
v3: Repost as a new thread; v2 was sent in reply to v1.
v2: Rebase onto nf-next; drop the second hunk (already fixed there).

 net/netfilter/ipset/ip_set_hash_gen.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 8231317b0..d15530241 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -1112,7 +1112,9 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 			mtype_del_cidr(set, h,
 				       NCIDR_PUT(DCIDR_GET(d->cidr, j)), j);
 #endif
-		ip_set_ext_destroy(set, data);
+		/* On a resize replay the extensions were already destroyed. */
+		if (ext)
+			ip_set_ext_destroy(set, data);
 
 		if (t->resizing && ext && ext->target) {
 			/* Resize is in process and kernel side del,
-- 
2.43.0

