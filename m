Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.217.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792879444;
	b=NBxurQ65H9JjQczYNquY9Ag+TKUXSnL2PvpPAAo6ZHEAPdh1Y54/LJ0tB3SPeCCYntMD
	 PYz17X0URlTG3/9Qsyl7uJXotElzCRE0Oc1b2IYlVgM9Ro0vvwQB3ocu66Ch4ARgoxUYm
	 MiVelY5wqjnR6/nxJaptEvXvfwQuBmllIlKlCDKQ13WZin+DfQos5VC+8xApdCiCTu6Wa
	 OZ2l/0kkwMf/7byJClTo5nDvnHWVjalyxRo5NRPay2XRdsxIDnWPDer5wxX+n3scamYyp
	 rgIwXnUszHn4tI0ZZ4uvNrVLonNd8iVpLTJQj4FH83yrQKk55Eph8lIlbZmYjt9Zx6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792879444;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=feA+qfM2JT212n+bZvJFkoTE7dwa45VjU7+TBhyDFMc=;
	b=EYRurvRJJJWDEyVRn8w4PbtNShrIwIJ6RjJAksdqi3OYwpQpgVseVi/JvVz70kjP9Vbi
	 rqpaQcKf9/FnP3qWhZy265HwPdrnnF+pAuevUhdmVqXNR4ZH8jI8A9qRrr0uwAlC9zmjb
	 +Q6gQ+/8OGevi9Z9J5bPkW/ecjXnH1XVzKZz7eVsXNw0CQoQNV+2DEqvOe9YTRo3dzvNi
	 TZiJaXBG1pvQAW3gMQFSrAZXIFJXI5jcjVTE49G7JyX4Uv9af1klQYWr90TVF1kKa9ODm
	 6vnIahsVvnM53nQnlmO/gAxGhtfguOQOV/j9WbWt5elNgbVhLD/2XrVRIHrgTLmMXeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Qpurg3WZ;
	arc=none smtp.remote-ip=209.85.217.44
Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com [209.85.217.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FD7B606A31B
	for <netfilter-devel@vger.kernel.org>; Sat, 24 Oct 2026 22:04:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0FD7B606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Qpurg3WZ
Received: by mail-vs1-f44.google.com with SMTP id ada2fe7eead31-7cc603a168fso517360137.3
        for <netfilter-devel@vger.kernel.org>; Sat, 24 Oct 2026 15:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792879442; x=1793484242; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:content-type:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=feA+qfM2JT212n+bZvJFkoTE7dwa45VjU7+TBhyDFMc=;
        b=Qpurg3WZlVKu/5kUAgA3mUMtBMev8bft64H4KwHPRWTz7VAGhMgBHfEU/UmjoBky6m
         2dn6ym1ynQ6Fr4C5gKOHTfJXH3etTBaq/8bvvGEite2/DQ1cSStxBHJzguex8DVYNEju
         rfatDNsVtGRzFbxWBzRrJ+rJRn5ptLdr2ISd9WjIximFOjOkOEDMImxDlQOuTZCtvtUQ
         Un+s+U3s1b4dkc8RqpZ6+jk+RZnNbE0p1eQIajJNCQE2v2SUD6SFnVltPL5MN4Blb9Z+
         w0capXhjjTmqrLIVjooEoHKPlgtC+qlQ2yZCXxTrxm+kYILlfbNR8EhzufLP7a5c6Exq
         p6nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792879442; x=1793484242;
        h=mime-version:content-transfer-encoding:content-type:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=feA+qfM2JT212n+bZvJFkoTE7dwa45VjU7+TBhyDFMc=;
        b=GY/YpTLG2RNB1uLoDXJAHkD/c+otsG3j+ED6H8kFdg8dXcnln8bxw/P29xzCTuqykD
         yBtRjM0ybsUqlwwvMwMGA7ewxn1jchb2jwHrjh4ydafg+JZeeY2rUK7WK7XuAskZrgYc
         S2r1v8vAoR58EQKkYBBgu+ROM0JIXBBtJB2Dqk55BMorvaOpTI8jM7k4e6XCfW7Yaax7
         3fwilWNV9pwECjzFxz9tiyJxrihv0joLQT/EVMe4A7JktNlHkITZVvFHKiOSY8eqxvLv
         1mhK7V7767p2HNZGYwjUdyUg4yTZR69lj+mdTQECB+irreEMwFnC+MdSr2nTN4adLx/B
         WbZw==
X-Forwarded-Encrypted: i=1; AKwUvBzs/41BxW0s0L3ZyXCE485jcxnluMSyTg+BZv8J2mJMHJURe226mr1wHJ0LJm+JsRaYBAYJ1keDL4+rlGj39Vo=@vger.kernel.org
X-Gm-Message-State: AFq9FYIOxASg4FCBHRbORrrtXbeQlYwoBT5segp+g/XMG3/3CCCBw432
	BiMP+EULmYfjtYs3lbgYkB1xbFsFQ7URj1TEeGG2nHWMm5iv+Q1iq7xOt7IjZ2wDbEuLxw==
X-Gm-Gg: AYBFou1Loj6v23ZpFr1cTQs8QW+yO521OQ/1CbOZfFn01gpeRvXsjSaJyRnffjU+WbI
	Spu8w8Kjgl6tQBumybh1oQk/8r1NUa3em7aZnegUJuagSsdI2Imc5H4Dz1WE8LNwUXmI0OBA4TN
	NbQa09Md69ukE7UwsVWh9gI/YeMEkaH4wCvN4tqug5KdO5yOvdI3nNks3KTeWTvDvBomx5vkzVy
	7OoRsqkGbqMJP220QIF9kggCar/x1YeNNOOGYLKLst+KcDQF69q3GfyNgjWMzFM6d+HVGOAlic6
	/S+OZpCog5gY09I3tk+7UbeYQpAteBJ7hY72JWEa/uJRPgiEFPALG8P3bpb7P4PZWvqU99c41ZC
	OndYylQbD7EtKf2268yW1a4QY+OGCJ4KN+lipb2KTFnYa4EClFdBNhvbtVDwvKVBzxrkVQzq4Fl
	re3eo3PVZ1i7ODfT5FLGqZbFVmvsr57ky1p4dcq2XpL2ABPimPMAy012x9B99NEhzpMWLkzRSIb
	rnp7sZDTn0elwmsXlr3KTnzPPS2GsUnQ2u9SLQCKvoDV/q+vhp1D5kiQu7q/csYd5Yo5kma1u+m
	6hWDXEvzSPeXjl0WnnlzxhbR62uZayO9Csr3/ovWlEGQbO8z52Q=
X-Received: by 2002:a05:6102:604e:b0:7a6:a24e:8140 with SMTP id ada2fe7eead31-7ce5cd16fefmr631925137.14.1792879442011;
        Sat, 24 Oct 2026 15:04:02 -0700 (PDT)
Received: from 1.0.0.127.in-addr.arpa ([2804:7f0:b101:277b:c08d:c9f9:7c08:79c4])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-9910e80e2d6sm3701696241.12.2026.10.24.15.03.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2026 15:04:01 -0700 (PDT)
From: Joas Antonio dos Santos <joasantonio108@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>, Weiming Shi <bestswngs@gmail.com>,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject:
 [PATCH nf] netfilter: nft_set_pipapo: skip transaction elements during GC
Date: Sat, 24 Oct 2026 19:03:55 -0300
Message-ID: <179287943591.17355.17353179557993329094@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Since nft_set_commit_update() runs set commit callbacks before processing
NEWSETELEM transactions, pipapo_gc_scan() can observe elements added by
the transaction being committed: nft_pipapo_commit() calls
pipapo_gc_scan() on the clone, which already holds the freshly inserted
(not yet activated) elements.

pipapo_gc_scan() selects elements to collect using only
__nft_set_elem_expired(), without checking the element's transaction
state.  A new element that is already expired at commit time (for
example a short expiration whose delta elapses during a large batch
parse) is deactivated, dropped and queued on the synchronous gc list,
which frees it after an RCU grace period.  The later NEWSETELEM step of
the same transaction then calls nft_setelem_activate() ->
nft_pipapo_activate() -> nft_clear() on the already freed element,
causing a use-after-free.

This is the pipapo counterpart of the rbtree fix in commit 86b6471e690c
("netfilter: nft_set_rbtree: skip transaction elements during GC"); the
rbtree scan gained an nft_set_elem_active() guard but the pipapo scan
was left unchanged.

Only consider elements that are fully active in both generations, which
keeps transaction-state elements out of the GC scan.

The use-after-free has the same shape as the rbtree one:

  BUG: KASAN: slab-use-after-free in nft_setelem_activate
  nft_setelem_activate net/netfilter/nf_tables_api.c
  nf_tables_commit net/netfilter/nf_tables_api.c

  Allocated by nft_set_elem_init / nft_add_set_elem
  Freed by nft_trans_gc_trans_free / rcu_core

Fixes: 1e3b9e1c77fe ("netfilter: nf_tables: call set ops .commit when building new ruleset blob")
Signed-off-by: Joas Antonio dos Santos <joasantonio108@gmail.com>
Assisted-by: Yaga Agent HackerSec Claude:claude-opus-5-5
---
Compile-tested (arm64, W=1, CONFIG_NF_TABLES=y): nft_set_pipapo.o builds
with no new warnings.

I demonstrated the precondition on a KASAN VM (unpatched 7.3-rc6): adding
20000 fresh elements with a short timeout (so they are already expired at
the commit tstamp) to a timeout+interval pipapo set leaves ~0 elements in
the set afterwards, i.e. pipapo_gc_scan() collects the not-yet-activated
NEWSETELEM elements during the very commit that adds them - exactly what
the nft_set_elem_active() guard prevents. I did not capture the KASAN
splat itself: the free is call_rcu()-deferred (nft_trans_gc_queue_sync_done),
so the subsequent nft_setelem_activate() -> nft_clear() races the grace
period, same as the rbtree sibling.

This is the pipapo counterpart of 86b6471e690c ("netfilter:
nft_set_rbtree: skip transaction elements during GC"): same root cause
(1e3b9e1c77fe runs set .commit before NEWSETELEM activation), same
scan-without-active-check pattern, same nft_setelem_activate()
use-after-free shape. pipapo_gc_scan() was not given the
nft_set_elem_active() guard that the rbtree scan received.

 net/netfilter/nft_set_pipapo.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 978bb0c01..4680969eb 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1745,6 +1745,18 @@ static void pipapo_gc_scan(struct nft_set *set, struct nft_pipapo_match *m)
 		i--;
 		e = f->mt[rulemap[i].to].e;
 
+		/* Skip entries not fully active in both generations: these are
+		 * elements inserted by the transaction currently being
+		 * committed, since nft_set_commit_update() runs the set .commit
+		 * callback before NEWSETELEM activation.  Collecting such an
+		 * element here lets synchronous gc free it before
+		 * nft_setelem_activate() runs on it, causing a use-after-free.
+		 */
+		if (!nft_set_elem_active(&e->ext, NFT_GENMASK_ANY)) {
+			first_rule += rules_f0;
+			continue;
+		}
+
 		/* synchronous gc never fails, there is no need to set on
 		 * NFT_SET_ELEM_DEAD_BIT.
 		 */
