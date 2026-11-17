Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=165.173.180.15
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794939154;
	b=Mvu0viNeowpwv50FpjPS8wqk+HK8Dn1Efcf1kAD4T6WAarYN/XSJl2lCNLyn+Xqm5kTX
	 B8w/Z40v1YaE6AMweHEBTEeX5O7Oqiq27ZEmM6iENYLqFgdik8jy/nVSdPK3tVkn1OY0v
	 zdUoGgLArw00sJLWxMW46EPvQs4n3gQP+EOwHaNKq2UT8ie0n+BP8v9p9HJ16ase54vN0
	 cY+HBBTq0C9VU23qyD57+Df8qvuAcXgd7JLNDjvkQvK77i2M+9gsGNOaYrICsuNl9pQct
	 vGyLyOAKzilUHLtc+8OT4DIrSTvpPXeCfclv065gcCu6LLWOvqKaUe3n7YjPI+SQvsQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794939154;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=9ncxxBe7GKoTncLOaM2IGmBRr5NiBhBbaaIsvj0fMI0=;
	b=Ncv1tNOMp7ec2UAQSrVYrJBhtWlWZqeTr5Juz+TyS4hiuOaV9gUQBBuvpEqE438afpZi
	 AtrZ46e1oz9W+vGmMRrC+3kn3yZRDvFeyO/XdyO9XbrMxSJ31+QKvNN9AzDX6AOEp2S1l
	 VE0vhACEH49+v64bM2ZSI+PG4gXsZs1Br57DBfiImx/pIGfWWXfL/VWlo4Dw5ZaE7JFET
	 aR5UWQ1z3hTnK+COqazrPdBL9YNMNaKP6BX8GXio4ph3K/ASxLpNbjaBCa4NLAW4l7FOq
	 g36bkDMTVZKpuoFTMVvUAjAk2qLSQ0vnGmxY7tuI31tsIWhGT0YzH9nCVR1P75jMdwA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ikuyo.dev;
	spf=pass smtp.mailfrom=ikuyo.dev;
	dkim=pass header.d=ikuyo.dev header.i=@ikuyo.dev header.a=rsa-sha256 header.s=s1 header.b=fNM88yJn;
	arc=pass header.oldest-pass=0 smtp.remote-ip=165.173.180.15
Received: from sender6-op-o15.zoho.com (sender6-op-o15.zoho.com [165.173.180.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AC7E606A32C;
	Tue, 17 Nov 2026 18:12:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0AC7E606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ikuyo.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ikuyo.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ikuyo.dev header.i=@ikuyo.dev header.a=rsa-sha256 header.s=s1 header.b=fNM88yJn
ARC-Seal: i=1; a=rsa-sha256; t=1794939122; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=hp8n2l4ek/mo5GAPuuSxk7LVgM8yT3mAftdKcYrOIGIbcEXtGLowgAWJLyGaNIob2gUtMxzjXQh8xhRcJYxCUG769kwzk6jvQNnJZK/EP1R6eOUXITliEfWLeJ620Edlw4ZOx+kaGPx1rQHzDfJo8vyOFEnkIrfzqIoEcWMp34E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1794939122; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=9ncxxBe7GKoTncLOaM2IGmBRr5NiBhBbaaIsvj0fMI0=; 
	b=e4NM1yQ7WNy6HPaXw4SgU1tXQjwsPqwM0wjV6o8i1JBUmlgxTcxwtd3VFYXahZpgRrj35gCZKTmjwvhHjSXORdJnat8luILPHVhnEDniKfHWNRcBYSeGwi2kndj4kMrhLUTte5iE0dEkOrc0F1K4AR3P7ukDni+0HcgDlDa9MUE=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=ikuyo.dev;
	spf=pass  smtp.mailfrom=eritque-arcus@ikuyo.dev;
	dmarc=pass header.from=<eritque-arcus@ikuyo.dev>
DKIM-Signature: a=rsa-sha256; b=fNM88yJnVxYcPgtCaJwt4KjJBT2EjIvyyUfbe2xy2XoN4R2mZXTHWsw+bszjty6sGZmpgNsW7eTpFW4J7FvQkl7Nw9hUJnthEkQ7Kr7t34StOSiXkS+xOhF78GoKEDjhK0R+QR+f3+qQa3sohe4/Cz5CvhUbZaDBsx52hjAjrn7ATgYSmIIU7Z8Lv2jz2XaolYqITz6q0Lt/NHvljKaXuGQmu4W4p07v96M4Nc6dnt1LxH9dbVIPGWeEt0wJ4IwxFyS5P1tVi5iWWrc6wn+Dg8U68H18EtG37fmeaJX1xk1ewxdKntzWxncoUEhjrredP4ZGOT315rnzMSoJttgDKw==; c=relaxed/relaxed; s=s1; d=ikuyo.dev; v=1; bh=9ncxxBe7GKoTncLOaM2IGmBRr5NiBhBbaaIsvj0fMI0=; h=Content-Description:Content-ID:Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:List-Subscribe:List-Post:List-Owner:List-Id:List-Archive:List-Help:List-Unsubscribe:MIME-Version:Message-ID:Resent-Sender:Resent-Cc:Resent-Date:Resent-To:Reply-To:Resent-Message-ID:Resent-From:Sender:Subject:To:Date:From:Message-Id:Reply-To:Subject:To:Cc;
Received: by smtp.zohomail.com with SMTPS id 1794939120565329.8648114396691;
	Tue, 17 Nov 2026 10:12:00 -0800 (PST)
From: Yiran Qiu <eritque-arcus@ikuyo.dev>
To: pablo@netfilter.org,
	fw@strlen.de
Cc: phil@nwl.cc,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yiran Qiu <eritque-arcus@ikuyo.dev>,
	stable@vger.kernel.org
Subject: [PATCH nf] netfilter: conntrack: skip unconfirmed entries in /proc/net/nf_conntrack
Date: Tue, 17 Nov 2026 13:11:40 -0500
Message-ID: <20261117181140.133758-1-eritque-arcus@ikuyo.dev>
X-Mailer: git-send-email 2.56.1
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

ct_seq_show() takes a reference on a conntrack it found by a lockless
walk of the hash table, but never checks that the conntrack is
confirmed.  nf_conntrack is SLAB_TYPESAFE_BY_RCU, so between
ct_get_next() and refcount_inc_not_zero() the entry can be freed and
its slot reused by init_conntrack() for a new, unconfirmed conntrack.
The increment then succeeds and the dump prints a conntrack that is not
in any table.  nf_ct_key_equal(), gc_worker_skip_ct() and early_drop()
reject unconfirmed entries for this reason.

Since commit 2ad9d7747c10 ("netfilter: conntrack: free extension area
immediately") this is also a use-after-free.  An unconfirmed conntrack
can still grow its extension area, for example when an nft ct helper
object attaches a helper, and nf_ct_ext_add() then frees the old
ct->ext through krealloc().  seq_print_acct() and ct_show_delta_time()
read ct->ext without a lock, so the dump can read the freed buffer and
print what it finds there as counters or a time delta.

Skip entries that are not confirmed.

Found with afb-afl, an LLM-driven kernel audit/repro pipeline; the fix
and this changelog were also drafted with LLM assistance.  Reproduced
on a KASAN build of mainline (v7.4-rc3+) that carried timing counters
in ct_seq_show() (two ktime_get() per entry) but no added delay: an
unprivileged user in its own user and network namespace churns UDP
flows through an nft ct helper object while reading
/proc/net/nf_conntrack, and KASAN reported a slab-use-after-free in
ct_seq_show() after 9 and 41 minutes in two runs.  The same build with
this patch ran the reproducer for 60 minutes with no report.  With only
this patch applied to a KASAN build, the conntrack_resize.sh selftest,
which compares /proc/net/nf_conntrack with ctnetlink dumps, passed in
three runs.

Fixes: ea781f197d6a ("netfilter: nf_conntrack: use SLAB_DESTROY_BY_RCU and get rid of call_rcu()")
Cc: stable@vger.kernel.org
Signed-off-by: Yiran Qiu <eritque-arcus@ikuyo.dev>
---
Tested tree: mainline 141b164bbe18 (v7.4-rc3-133-g141b164bbe18).

The reproducer fills the namespace's conntrack table so that
early_drop() recycles slots, and puts 300 non-matching rules in front
of the helper rule, which delays the helper's krealloc() by about 16us
after the new conntrack's refcount_set(); four threads read
/proc/net/nf_conntrack.  The guest had 8 vCPUs.  The build needs
CONFIG_SLUB_RCU_DEBUG=n: with it, KASAN defers the reuse of the
conntrack slot by a grace period and the race cannot happen.  The
counters saw 136 and 88 recycled unconfirmed conntracks pinned by
ct_seq_show() in the two 60-minute runs; with this patch 98 were
pinned and none reached the printer.  From the first run:

  BUG: KASAN: slab-use-after-free in ct_seq_show+0x5ea/0x830
  Read of size 1 at addr ffff8880108f0a05 by task payload/218
  CPU: 7 UID: 1000 PID: 218 Comm: payload Not tainted 7.4.0-rc3-kasan-hunt+ #16 PREEMPTLAZY
  Call Trace:
  [...]
   ct_seq_show+0x5ea/0x830
   seq_read_iter+0x600/0x7e0
   seq_read+0x203/0x2e0
   proc_reg_read+0xec/0x150
   vfs_read+0x144/0x610
  [...]
  Allocated by task 213:
  [...]
   krealloc_node_align_noprof+0x131/0x3c0
   nf_ct_ext_add+0x110/0x380
   nf_ct_ecache_ext_add+0xa9/0x150
   init_conntrack.isra.0+0x444/0xb90
   nf_conntrack_in+0x652/0xac0
  [...]
  Freed by task 213:
  [...]
   kfree+0x113/0x480
   krealloc_node_align_noprof+0x158/0x3c0
   nf_ct_ext_add+0x110/0x380
   nf_ct_helper_ext_add+0x17/0x50
   nft_ct_helper_obj_eval+0x1e5/0x3a0
  [...]
  The buggy address is located 5 bytes inside of
   freed 128-byte region [ffff8880108f0a00, ffff8880108f0a80)

Offset 5 is ext->offset[NF_CT_EXT_TSTAMP], which ct_show_delta_time()
reads even when the timestamp extension is not present.  An earlier
build with a udelay() added in seq_print_acct() hit the same free
there.

6.12.y has the same code (read in v6.12.118, not run there); the hunk
needs its context adjusted, as c5ba345b2d35 is not in that branch.
Reproducer available on request.

 net/netfilter/nf_conntrack_standalone.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index d88a10230862..299691d7ac1e 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -314,6 +314,9 @@ static int ct_seq_show(struct seq_file *s, void *v)
 	/* load ->status after refcount increase */
 	smp_acquire__after_ctrl_dep();
 
+	if (!nf_ct_is_confirmed(ct))
+		goto release;
+
 	if (nf_ct_should_gc(ct)) {
 		struct ct_iter_state *st = s->private;
 
-- 
2.56.1
