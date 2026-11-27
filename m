Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795762078;
	b=AG9tVLnpVrWK+mnpWXbiVzJbwzRvb5eX0qf0BVd8hLx6Rr3eS1uJXT2fP+Jkpm+DF5lH
	 CqVx/+D98tH+/fh1j8RGa5AzmvP9dNVI3knsVzjDuQUgcJNHFxUILlkiD0LJ5KqHY8UYV
	 y1br774PaNzLGNyfYymN9nlo2/rRZPbpaCamT7cNh2/mkX412zr0Re1DYh4DVfJUh8MTv
	 DifHFmEVljP72XK53HvK3al2zpe72sZrJBLJHzAFT4auQPkRhvVQzruGBQ4j02soSuXE9
	 /40oYGKTBiWg47VmeLYkhM+ayWq1DFp1AM7MrU2loyTjuarhO6JVIC36glqgMHAUU1A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795762078;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Endpoint-Received:X-Original-From:Reply-To;
	bh=4kO2/TOIPNkmsIMjXm7Ah4Oz0Gps8OfI9+gvyJMp7b4=;
	b=EuTT1BnlPBQkDWoxBkT/bl1eo/RIo8Md4iy8KiWegQOPom5a4Y4giXkDeSxtEC5vXkfe
	 pSC8bRQIwSNzh8/R5qDCs3ZB20T2eQzqZuiTsBxSH+4kcFlBOopDcp+/URZlwu7oKHp0M
	 atWKy1p8SUIzKRoiPyXUkSB95eKBUbgf5WhT0XPIyAquGn/RA0XZU6whelX1HltW3fVy0
	 dWb7yo2f+/EAEaKFq4Ip/GVjqs2JOkTxaosHtd/MIy7bXG7FAPGGOA6ebSxq3D1X+Pw/m
	 6dr4nYNG3HoK6PfLg6gO/S8YOebuCToLhKmQ2tXdZ/W3toGdAwFESSFtJGsCi2Ij6Tw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jmjkDW8d;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AA08606A331;
	Fri, 27 Nov 2026 06:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jmjkDW8d
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795762077;
	b=hv7gyFFe+FtI+RWPve56WXCIhXG7CRmtyLpYb5TUYjSq/HQmh+J0dLq+h14AHWZ7m5G9
	 jaC3+i5ztUAq4Y2SoK6E691vit650vrRhTCxYg0x59gK1W1PLTk0+MtHP3xFJECAcAgwl
	 WRBe7mS+SQwden9ffS4BIm0tbV5kXrTukKM5PhuwbUM/YU9gjsWyUariQL+7koShtv4qR
	 +Bu/QFsxpBZRx8Qm/65ePz+P7eboqYEkNOyNPAAIylaHoKtr0l/eispE+yavNB06RjiSB
	 t1uPt5HBgkroTLJ4y9OoCjrjLhSi0C0Hp04iDGjk9P5U20AIut+cbzGQmt2kH7kt4lw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795762077;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=4kO2/TOIPNkmsIMjXm7Ah4Oz0Gps8OfI9+gvyJMp7b4=;
	b=qp3itv2nnefNm0krio/vLGn7UWpqLUll4ndHL02VbYUEL2xB92LUmCmzx7UK6xwuk9gi
	 bGbwTSiC+IXjWKzDPFXatqzXvUsqWT+5/d2WUGaO48DbM0gI6F6f6esp/9/80+qLZvUr2
	 SI0hDCeTrROAw1F2tUkvDM8c/f/h0x+hrgGSvJWa+4fTIuoh0uRX/i7dmVHGG67+74UgR
	 UlSkL3jfDKf6Ipt3UhkQ5jNp95Wcy8wXxo6YL4FDA/odtf/hui2cDuJqEtRWHe7KMekB5
	 lFl9W0riTD7jkgdlC6Xsc+t9CEWBvOiWbuIExHswLQdvG/cYyRwPJUxiwxiiTovy+mg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id B78211F00923;
	Fri, 27 Nov 2026 06:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795762077;
	bh=4kO2/TOIPNkmsIMjXm7Ah4Oz0Gps8OfI9+gvyJMp7b4=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=jmjkDW8dLaj1Q+4Jfi74uIP0Ri7k3OuTr7ibXX9O3eN8Ru8TNoILAECh0AKlVkffW
	 cOJyF38piMnzBUbeuy4e+HdAnnh5U2gaRzEKnfMCG9AtuJRrz3002lejdAbFBGX0Ns
	 r9A9U1wRBVQoioR5DR65JJRXj3bXBWdvkB6SakoPvEkzKY59YiDcSBeTjHI5rISHtO
	 KfovdR22uz2aeiWynIXAnV2siDbNDL8svrMT51xIiDpvlubfUAY1AGXUJbHma6fpbn
	 7lnG+8hjFyNBcJRwJqmRdlF9E8XgMnrFUhALE8QRoKa36mVTdACuD1FwE0kvvo3BG5
	 5zcG7CkaGTLDg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 425894B5DC;
	Fri, 27 Nov 2026 06:47:47 +0000 (UTC)
From: Dickson Wu via B4 Relay <devnull+dickson.wu.certik.com@kernel.org>
Date: Fri, 27 Nov 2026 06:30:27 +0000
Subject: [PATCH 5.15.y] netfilter: flowtable_offload: fix using
 __this_cpu_add in preemptible
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261127-so5-nf-515-v1-1-ce02c323f842@certik.com>
X-B4-Tracking: v=1; b=H4sIAIIjCWsC/0WNwQ7CIBBEf6XZs1uFQG38lcYD0MViDBi2NjVN/
 13Qg8d5mXmzAVMOxHBpNsi0BA4pliAODbjJxBthGEsGeZKdEPKMnDRGj1po7JSxSklv+p6gDJ6
 ZfFi/sgF0K3T7huuP88veyc3VVJvWMKHNJrqpIqY4zik9sPLj/wH2/QPcl1T/oQAAAA==
X-Change-ID: 20261127-so5-nf-515-64ab442fa88e
To: stable@vger.kernel.org
Cc: Xin Long <lucien.xin@gmail.com>, 
 Pablo Neira Ayuso <pablo@netfilter.org>, netfilter-devel@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795761026; l=3298;
 i=dickson.wu@certik.com; s=dickson-b4; h=from:subject:message-id;
 bh=DPEyyVIOnnhk/htjRMSlOemmYqz4g1GxjdwvS3F9YOs=;
 b=MeaNcLNv9bCcv5l7LrlZ0n/o/xYXKR9dWAyklAuUAcmIIky9a+iT6ARLq/w+v1/WChbKXDpWz
 N2d7yUEluinBOhhfRNXVbH7zgx6ZgjHsB/COR7BiqJYP2ZmqAy4HP+P
X-Developer-Key: i=dickson.wu@certik.com; a=ed25519;
 pk=fxH7FS4FdojeJSGLJzgKdfO51Rvr4EW30yinj2mc1vg=
X-Endpoint-Received: by B4 Relay for dickson.wu@certik.com/dickson-b4 with
 auth_id=1647
X-Original-From: Dickson Wu <dickson.wu@certik.com>
Reply-To: dickson.wu@certik.com

From: Xin Long <lucien.xin@gmail.com>

commit a81047154e7ce4eb8769d5d21adcbc9693542a79 upstream.

flow_offload_queue_work() can be called in workqueue without
bh disabled, like the call trace showed in my act_ct testing,
calling NF_FLOW_TABLE_STAT_INC() there would cause a call
trace:

  BUG: using __this_cpu_add() in preemptible [00000000] code: kworker/u4:0/138560
  caller is flow_offload_queue_work+0xec/0x1b0 [nf_flow_table]
  Workqueue: act_ct_workqueue tcf_ct_flow_table_cleanup_work [act_ct]
  Call Trace:
   <TASK>
   dump_stack_lvl+0x33/0x46
   check_preemption_disabled+0xc3/0xf0
   flow_offload_queue_work+0xec/0x1b0 [nf_flow_table]
   nf_flow_table_iterate+0x138/0x170 [nf_flow_table]
   nf_flow_table_free+0x140/0x1a0 [nf_flow_table]
   tcf_ct_flow_table_cleanup_work+0x2f/0x2b0 [act_ct]
   process_one_work+0x6a3/0x1030
   worker_thread+0x8a/0xdf0

This patch fixes it by using NF_FLOW_TABLE_STAT_INC_ATOMIC()
instead in flow_offload_queue_work().

Note that for FLOW_CLS_REPLACE branch in flow_offload_queue_work(),
it may not be called in preemptible path, but it's good to use
NF_FLOW_TABLE_STAT_INC_ATOMIC() for all cases in
flow_offload_queue_work().

Fixes: b038177636f8 ("netfilter: nf_flow_table: count pending offload workqueue tasks")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Dickson Wu <dickson.wu@certik.com>
---
6.1.y and newer already have this fix.

Tested on v5.15.226:
- x86_64 allmodconfig W=1 build of net/netfilter/nf_flow_table_offload.o,
  base vs patched, no new warnings
- booted base and patched kernels under QEMU/KVM and ran the netfilter
  software flowtable cases, all passing on both. Hardware offload wasn't
  available, so the offload counters weren't exercised.

The backport and the test runs were prepared with AI coding tools
(OpenAI Codex agents, with review by Claude). I went over the result
before signing off.

net/netfilter/nf_flow_table_offload.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)
---
 net/netfilter/nf_flow_table_offload.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 60e9c03d697f..3400a31c7df7 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -1056,13 +1056,13 @@ static void flow_offload_queue_work(struct flow_offload_work *offload)
 	struct net *net = read_pnet(&offload->flowtable->net);
 
 	if (offload->cmd == FLOW_CLS_REPLACE) {
-		NF_FLOW_TABLE_STAT_INC(net, count_wq_add);
+		NF_FLOW_TABLE_STAT_INC_ATOMIC(net, count_wq_add);
 		queue_work(nf_flow_offload_add_wq, &offload->work);
 	} else if (offload->cmd == FLOW_CLS_DESTROY) {
-		NF_FLOW_TABLE_STAT_INC(net, count_wq_del);
+		NF_FLOW_TABLE_STAT_INC_ATOMIC(net, count_wq_del);
 		queue_work(nf_flow_offload_del_wq, &offload->work);
 	} else {
-		NF_FLOW_TABLE_STAT_INC(net, count_wq_stats);
+		NF_FLOW_TABLE_STAT_INC_ATOMIC(net, count_wq_stats);
 		queue_work(nf_flow_offload_stats_wq, &offload->work);
 	}
 }

---
base-commit: 4f2df9a01754521fbba3493e8ad91ef65515e68c
change-id: 20261127-so5-nf-515-64ab442fa88e

Best regards,
--  
Dickson Wu <dickson.wu@certik.com>


