Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795172245;
	b=up6lk5MCnlX5XTc+l4SbIvwukTTxzJSGTGSiDWiBQMirOIBfyzCFOTKlCzx6dwQhu6J/
	 VV6duXhapvZkRo4MUm4yGxQUcJ0CRhJy43e/gnHnTb45CweZRkLnOlSC1BoFUeObTk2LJ
	 l3Zpm68SvZfqdd++If2L75w5iEVOqRCbfvoRnPAqRv0skG4D0Q54wSLglfzKnwEO29PYm
	 PAcrNvWdWhz0TVj1FZbp+9e310wxbVjswyDwhrR9ZiwwLUa0CKlkgq4iSpReMDDgCMox8
	 BMBTLQxtU4nYG2ogw22mre+RFJ1D8mCSspjZyAhQOal82ZspKe+J6FGvY8PiZfaVBog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795172245;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=DtNV5VxWZRYPm+qkkMJsylA6Vg/UOHe+uIII8BQIetA=;
	b=tgxQZUsg5kizB/gqULIFlEUyaftQsGVBF0zdCwZZB6Z/rP2hsblE/Qvr/Byhb5crC2Re
	 thErN5CY2rwGfntTDNkp+wvlR3PhtophZtf8eFyCE8LK9IoxPJEBTMQ18tduIhTNymgD4
	 UJu7b/tYXIGkQ4zNTBwasuyz6RGlHvuc6Rc++yCS1YXtjzqeNbRrxhLCdiOzeXBDzRV36
	 iEoBeoB5rClEGPgNGCRv0laHSJbExjjpsKgMxyhxUOyvCPdnvKiWCzcBqTYhZCq1ESRbo
	 9v0wRCa52NwJEsERI97dpzJnpn4/FFWuGsMs7DATSded2qv9QiyPsVFQplwPBHaUAxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SoU36Rrp;
	arc=none smtp.remote-ip=209.85.214.175
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBA93606A325
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Nov 2026 10:57:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CBA93606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SoU36Rrp
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2f02ee04378so5831645ad.1
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Nov 2026 02:57:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795172244; x=1795777044; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=DtNV5VxWZRYPm+qkkMJsylA6Vg/UOHe+uIII8BQIetA=;
        b=SoU36RrpP0fAvcxfHnVD1gS9A6b1JLHYlH953RVwxmM3EYg81GAjCqrR03smdAsG9X
         MUUQttVK7hSH6Bp/t+dU3YLFaGzwsQY0RosxNJOGVl/cCcTeB0sIOq5lDj+lGiUcUt/P
         3nMcbs0RABVK4edyFJiHfbBPwo1v70GsNfpYTxui4PP+TY7zFarBa0O+Fag0Qa7qy6eC
         N/6Q4fj8LqN3aL76KXZAVcqjxMPhc5xZhZn+qTKNqIHpjDI9J93r+hK/U6FPB5QU/jAu
         v7NwCdO7Q2opz+nXTbtCos5wZhHiYm5tbPZgJYrT512lDFSipRI3GGKAmj15+OdukaYh
         wl5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795172244; x=1795777044;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DtNV5VxWZRYPm+qkkMJsylA6Vg/UOHe+uIII8BQIetA=;
        b=gdRBIfzO23vykcp6y9a7H3VWFu6vX9fyouVlt8d3Auk9bAmOpRb7RtrVO4PjSq9Y5S
         pHMJTf3exZtDDyJq6Aewy2pttSbv+819maF2ZDm5Vg/X84gYRRkSbJHBjAwKDQDbVHYz
         EnBmDxxO0rd8gta/NHVEKhObrvRopbAwEihAbFeIotAdNTtmJX71RcwbEQCzQgeasZjg
         0OuIi73vxuTXruQ1ANKAz3cfMieOp+uBns0G4jptwQSGa6ckR0jQIKbENBYqeyqS8s3r
         1dgKLkMApbum7bzCgcmGsMhVbo1liaafeEIzYEbKcxFkhmRiyHrvyXF0NVUUKDRvedLx
         Mg8A==
X-Forwarded-Encrypted: i=1; AL+hErEUYvhRBvX2NcGTQcXotTLHype+Rnap0W2+C5HqyUg7iokHHind003D+OgYIPxWpJfW1TuCbe/FchMALjSNArg=@vger.kernel.org
X-Gm-Message-State: APuU4Z/HyHDZmFu9EGj7cGXWUN7vWxtdVBNgMmLjriNwXAv14WPY9JF2
	TRjyMfni1nMpqF6T03YbhWLwYk0mrn/1XciSthYRbpMxGx8aUiD+f7Rdg7csNKla
X-Gm-Gg: AZFdTZcOIf8AbPhx+pq+D8Ku8YAJZUYCQIShijEonEPYuKvltX1U3P/HCUp+qokZWEj
	NWvmWctom+EthMeF+8u1zrOEU7OdeAW3cyVTeXVN/XKJVlUfmCILvOtH7UfcN+rQI36n87SUgAv
	L32evDpPffmtgB9IgyNpR+Vl8R7lFng/P3MaOcY7eE/qRJk02+0q3M4tYRkM1q2RWiVsUueO6xJ
	GZPHTf4nHyZvgT/hG5qa+2QKOZfQUNWPrao/SZZ1BWD2garOQ8x0Z8WVxw0ON8mHLGBInL797WW
	wfTBffzRxVvnwktMfZNiEtXXdc4Z+SuMPxsaT3Uq9vl1VqWiN3gPc4aky9Ymix7tDa1ENeE86s7
	t0AJHWQP2YVmKsPw952iHXDPu/wrQXFtx/EZyk7IV1NH83cXVkQXszkIbdx30eZKT/S+lMDj5ET
	1m21dkkxcAws9DwUQe0RXVOoGdgfqoX+kE9pgNRM3twfyEzUHAdwXQXWgPd5PzBhX4ow2LekTJe
	z+iE4Kob0CmHlneo9YsmC+m8sAhKidQaM12cLiP267N3Txi+m+0ugulO+5IgLzaepIk/RRc+2O9
	sHIUBrSD2KzWjCZWySgfQJZUSJ9vwFOqxY5y8eT62e1O6rd9cZ8=
X-Received: by 2002:a17:90a:d607:b0:3ac:4291:f569 with SMTP id 98e67ed59e1d1-3b41c7c776bmr2760098a91.8.1795172244164;
        Fri, 20 Nov 2026 02:57:24 -0800 (PST)
Received: from localhost.localdomain ([112.170.44.210])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41ad0b52dsm4176886a91.5.2026.11.20.02.57.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 02:57:23 -0800 (PST)
From: Junyoung Jang <graypanda.inzag@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: Junyoung Jang <graypanda.inzag@gmail.com>,
	Gwanhyun Lee <gwanhyunlee@gmail.com>,
	Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH nf] netfilter: nfnetlink_queue: drain cleanup work on netns exit
Date: Fri, 20 Nov 2026 19:57:17 +0900
Message-ID: <20261120105718.866862-1-graypanda.inzag@gmail.com>
X-Mailer: git-send-email 2.43.0
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

NETLINK_URELEASE unlinks an NFQUEUE instance and schedules its
destruction through queue_rcu_work(). The RCU callback queues
instance_destroy_work() on nfq_cleanup_wq. Queued entries retain
entry->state.net, but nf_queue_entry_get_refs() pins only their
sockets and network devices.

A migratable device can return to init_net as the old namespace exits.
cleanup_net() waits for the RCU callback but not the work it queued.
It can free the namespace before instance_destroy_work() calls
nfqnl_reinject(entry, NF_DROP), which dereferences the old state.net
in nf_hook_entries_head().

A source review assisted by a coding agent identified this race. A
65,536-queue reproducer on unmodified mainline with
KASAN and lockdep enabled reported:

  BUG: KASAN: slab-use-after-free in nfqnl_reinject
  Workqueue: nfq_workqueue instance_destroy_work

The free stack included cleanup_net(). The trigger used
initial-namespace CAP_NET_ADMIN and a migratable virtio-net device;
it required no kernel modification or fault injection.

Drain NFQUEUE cleanup in the pernet exit batch. rcu_barrier() waits
for pending RCU callbacks to enqueue their work; flush_workqueue()
then completes that work before cleanup_net() frees the namespace.
The batch hook avoids a barrier for each exiting namespace.

The same mainline revision with this patch built without warnings and
completed two 90-second reproducer runs in KVM with no KASAN or
lockdep reports. No netfilter selftests were run.

Fixes: 936206e3f6ff ("netfilter: nfnetlink_queue: make hash table per queue")
Co-developed-by: Gwanhyun Lee <gwanhyunlee@gmail.com>
Signed-off-by: Gwanhyun Lee <gwanhyunlee@gmail.com>
Signed-off-by: Junyoung Jang <graypanda.inzag@gmail.com>
---
A custom LLM-based coding assistant helped identify this race and prepare the reproducer
and patch draft; both authors manually verified the source paths,
teardown ordering, and KVM test results. The standalone C reproducer
and complete serial logs are available on request.

 net/netfilter/nfnetlink_queue.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index a8aa7ad832c3..5eaa314ed59f 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -2201,9 +2201,17 @@ static void __net_exit nfnl_queue_net_exit(struct net *net)
 		WARN_ON_ONCE(!hlist_empty(&q->instance_table[i]));
 }
 
+static void __net_exit nfnl_queue_net_exit_batch(struct list_head *net_exit_list)
+{
+	/* Wait for RCU callbacks to queue instance cleanup work. */
+	rcu_barrier();
+	flush_workqueue(nfq_cleanup_wq);
+}
+
 static struct pernet_operations nfnl_queue_net_ops = {
 	.init		= nfnl_queue_net_init,
 	.exit		= nfnl_queue_net_exit,
+	.exit_batch	= nfnl_queue_net_exit_batch,
 	.id		= &nfnl_queue_net_id,
 	.size		= sizeof(struct nfnl_queue_net),
 };

base-commit: 65e4fd942f72a9dba0e4e257290c4fa1aa756854
-- 
2.43.0

