Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E9D63290D0
	for <netfilter-devel@vger.kernel.org>; Mon, 13 Jul 2026 16:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783959487; cv=none; b=kwZeUka5TtYY8psZk7vlw+UENXtW1BnDGN1XzTJvK2IeQXVr7TK8NJQjjVPuBr6nIUtK+GKsFFuv6wtfEjPhgD1tAlqgQ+rLxlGhsc2uKkwV6GA/Vv0YDWHWgtjhzkMy1o8oZiDcJka7KHTLck6oOyV1bpu/MZYHOcjIfwwHvcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783959487; c=relaxed/simple;
	bh=tGG0MiHN5UuJi2ociiaK6WiVbWCScdsB+jhAN+MFscQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HrVTPAB97x35ZMoX2qfJerAbgmf3yHQ0KbUOZEk48Q7/g85EiseUKjoggcp3tMpJ5rRa8UJAERzHAm2HNT6uke/pJn3fFZvSY+uc/rmWnjVGn5lBrtIT6xPGB1hr3/5YeD4ewNPL77U3pXWwxZN+EUi3gmSxcKuZkgyLQmKIewU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lsivhO4L; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lsivhO4L"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-845c92bc464so51767b3a.2
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Jul 2026 09:18:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783959485; x=1784564285; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gC15aP2K1fPrSjv7xk93lFLdSIjrxFOeu3cF6pP3adg=;
        b=lsivhO4LBOM5Nhbaonp9n+St27MCZMo9bAjhWVroii5p8C00WXOuktYah8qzD5yRHy
         Us2fDKfnbyk+OywKaZz9ZMFqc6pn9cvIcJv7addycGgTeFnOVPF54cpzm8ywV0ebZyZ6
         eCNMIO6pyyYx0K2YlYMv3X1npmmGnQvxUmcr0edGXlbYLwT2enMvTBLdjKimJpI9/rBJ
         CX12HcSACJS6Ga5uni1heEvaDfl1CJHiqqi/NCKEl+wA0FV03xU04qjRQCHFw5Pp1Duy
         37EotHlmGD+KrK0glX2Ce6wkZDCtzB6h+KkBRMCPn6gpSOB92h/iGFdAmlrLYZXT3VNA
         R1tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783959485; x=1784564285;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=gC15aP2K1fPrSjv7xk93lFLdSIjrxFOeu3cF6pP3adg=;
        b=qqo6OC2mHie8P49IsY/GPuoL+y2rPHenNzavdl7hErtlw1w5zgOvw/sBR7ypQPe9xc
         grtkrSf31/rdaTGdvgV6nwgpYS77XN9rmZAwmOlsgYVmYqJcV1+D5FoYM8YQRvkK0Eq7
         jJvYTnkGecLH4LsFXN2UaJRytZ1WOAS3lJz7Y0PQYHtBhv6GsPhu3IFbBx/2lZ2euaeW
         fl51YdLraecA8RLPx47G7IoWWoh1A+3c2U+fVvDOksOMXWykgo3dzY5+d0+VpbKYxDgr
         gqwKYyKWKoBM70aotqmz3tNFMC4xhHDkTjYrK07Xy8Ty5pdQ3stqauZlKJ2oXENkIw/5
         z+wg==
X-Gm-Message-State: AOJu0Yw2TgkmfUUruHvp060NbbL7sraCqm3H/ocqOPH3OBtEO9jytdxw
	Xp9s/0Wh8I6/F28bnNiUthbGnLNkwoiTWrFoMQOF6G6RhgwqjQfH7TtD
X-Gm-Gg: AfdE7cn5oyQj6YuWn0B4SpzkQTIOPDtKqjg3wvtDwjb7RWLBokb1hNjsni2OMLYa+JA
	Wq/NmwrsWvgWtXo1ukWZFROhEUbxiHKBbLzGSaUd6U0IDmre3GIrXkKU5n7oNfGfyzMvmrJxHkB
	AguXDoLeFYhYa1SxRcTjbHV68Lqsty70RSmWJou0NmuVK0ejr5qpdykfYsjR1mSXweq6IGsbLn9
	gfh5uqDeX2t4Ga8wcCdD3BCUd/vYNuo9HzHFz6VruJCit9YzR+n/NMMbuKbcwZg2g0JtDZUlYFc
	u/cOQ07Yl5z0ThCx7XydNAtH/hkIHJ0eh6xi8huT/59z6ZT5FURiB1nvMPujzuK6Qb4g1v2NKbR
	xJCO/Dqlg89bUL/1gbnYdY+KezczYz5Qy3OtIk8Rv5GkArFU5dcnZijB3hmqaAWYt3HSZQCjthA
	t1AVjZlKLRNlXaTuOuHNh5Lvmtkz2O+xQMFZKNhQYLtP5BOpUmm6L7W6UqCg==
X-Received: by 2002:a05:6a21:4cca:b0:3b4:8a40:85ed with SMTP id adf61e73a8af0-3c11077686bmr9741481637.7.1783959485390;
        Mon, 13 Jul 2026 09:18:05 -0700 (PDT)
Received: from fx.tailc0aff1.ts.net ([206.206.192.132])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-313cb804197sm23026406eec.13.2026.07.13.09.18.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 09:18:04 -0700 (PDT)
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
Subject: [PATCH nf-next v2] netfilter: ipset: skip extension destroy on hash resize replay
Date: Mon, 13 Jul 2026 09:15:28 -0700
Message-ID: <20260713161527.3529006-2-bestswngs@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <PASTE-JOZSEF-MESSAGE-ID-HERE>
References: <PASTE-JOZSEF-MESSAGE-ID-HERE>
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
v2: Rebase onto nf-next; drop the second hunk (already fixed there).

 net/netfilter/ipset/ip_set_hash_gen.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 5e4453e9e..bc909ae2d 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -1080,7 +1080,9 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
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
