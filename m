Received: from mail.mdapi.ch (mail.mdapi.ch [31.3.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F34093769F6
	for <netfilter-devel@vger.kernel.org>; Mon,  5 Oct 2026 11:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=31.3.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791201236; cv=none; b=QAsnUeaTA1t+QKUDHvGSCxqSym/O1v/oSKLmPJ9BPi+d9cykZ2JyxHl9GTDmvb6t77i5bpsSlk9aVUj82d/pnR+QDrG5vWLAB61LNW64HneoMqYQvd796QESn0GkuP78lNYXDF5QeaoEq/p2xuKkb1qUShIU+G8q50v5IWsoTx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791201236; c=relaxed/simple;
	bh=QnsS/j/9h7FYQmXOBjKfsBtmq7qBG4GfqOqgnQm1Y0o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=qyJW9pwtVE5nruYg7zVOFwkbH7t92CbLvIHpmqao9eyxi3/SWub7XYfcntMg9wacllGeTFeBl+/KGOw+eWN9G6//IKsCAskf/YcN2XXMbzekzEQkz20tCCKezNTF6DPLFqJ23yk1HcW18e1egRyE2fVhpQXoWBzkHOpc0QURvKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=tillo.ch; spf=pass smtp.mailfrom=tillo.ch; dkim=pass (2048-bit key) header.d=tillo.ch header.i=@tillo.ch header.b=gK7mnksE; arc=none smtp.client-ip=31.3.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=tillo.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tillo.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=tillo.ch header.i=@tillo.ch header.b="gK7mnksE"
From: Martino Dell'Ambrogio <tillo@tillo.ch>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tillo.ch; s=mail202603;
	t=1791200891;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=DG/TjuwU3+U6oTN/2vcEUMwEJKNff7Uc8Q9Sd10RofU=;
	b=gK7mnksEziLM6QF/Pu6AJrgz9OSP1vCG7FZ4ktnZnzf74kscJsAJs7qai90OvrUqYwdEm9
	01kC4l2Zei0JynWJDhno11pXBUvtneFdy1Uw8afVDh9UeRT+DYcanbD8V7AIKcWcRdxi0c
	zRTDF+yH483+baagWYPeBpvQFUgA6ZCE+plmCGIB9TxQs/16jTWAUS5gOEkpBJK9wahitx
	8dmLAA2PGlxoGrgFSCc5oXg5TyuUMhjiFbcmxxFd3zwDYbGcGJmjRkEh/eFNOFlpJSl2un
	9Dge7cNpwr4LmVBIBjwgATposCuIYITIgrjvmR4CveTCHpDBo+jT7PSOMIWdow==
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc
Subject: hardware flows are left behind when a flowtable is deleted (nf_tables unbinds the offload block at commit time)
Date: Mon, 5 Oct 2026 13:48:10 +0200
Message-ID: <20261005134810.312747-1-tillo@tillo.ch>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Deleting a flowtable leaves the flows its devices offloaded behind in the
hardware. Reported against stable v6.12.108 on a Banana Pi R4 (MT7988,
mtk_eth_soc PPE) running OpenWrt, and reproduced there; the analysis below is
from that source and from net.git main, where the function is identical.

Symptom

After the flowtable is deleted, the offloaded flows stay BND in the PPE and
keep forwarding. Their conntrack entries are not released either: they stop
being refreshed and expire (60 s for UDP), after which the device is
forwarding flows that exist in hardware only and that conntrack no longer
knows about. On the router this is visible as entries in
/sys/kernel/debug/ppe{1,2}/bind with no matching entry in `conntrack -L`.

OpenWrt's fw4 deletes and recreates its flowtable in one transaction on every
firewall reload, so this happens on every reload rather than in some rare
teardown path.

Why

  - Deleting a flowtable moves FLOW_BLOCK_UNBIND to commit time.
    __nft_unregister_flowtable_net_hooks() asks the driver to unbind, and
    nf_flow_table_block_setup() frees the driver callback there.
  - The flowtable itself is freed later, from the transaction destroy work
    after synchronize_rcu(): nft_commit_release() ->
    nf_tables_flowtable_destroy() -> type->free() -> nf_flow_table_free().
    That last step tears the remaining flows down and queues
    FLOW_CLS_DESTROY for each one.
  - nf_flow_offload_tuple() delivers those commands by walking
    flowtable->flow_block.cb_list, which has been empty since the commit. It
    reports no error for an empty list, so nothing notices.

This is not a race between the last GC run and the unbind: the unbind always
happens first, at commit time, so the hardware entries are never removed.

It is a regression from 13210fc63f35 ("netfilter: nf_tables: imbalance in
flowtable binding"). That commit removed the late FLOW_BLOCK_UNBIND from the
flowtable destroy path, which 5acab91458ce ("netfilter: nf_tables: unbind
callbacks from flowtable destroy path") had placed after
nf_flow_table_free() on purpose:

    Callback unbinding needs to be done after nf_flow_table_free(),
    otherwise entries are not removed from the hardware.

13210fc63f35's thread only checked BIND/UNBIND balance; nothing there is
about hardware entries left behind. It is in 6.12.y as 2e87c203b72f.

All of the above is read from the sources rather than instrumented at run
time: nothing here traces cb_list directly. What the reproducer below shows
is the consequence, and that part is measured.

Reproducer (~2 minutes, one host)

  1. Drive a busy UDP flow (~100 pps) through the flowtable so it binds in
     hardware: confirm a BND entry in /sys/kernel/debug/ppe*/bind and
     [HW_OFFLOAD] in `conntrack -L`.
  2. Delete the flowtable (on OpenWrt: `fw4 reload`, which deletes and
     recreates it).
  3. Keep the same socket sending, at a low rate, for longer than the
     conntrack timeout. The window has to exceed it: a stranded flow still has
     a conntrack entry until that expires, so a shorter window shows nothing.

  Unpatched: the tuple stays BND and keeps forwarding while conntrack has no
  entry for it any more.
  The discriminator has to be per tuple -- bound in hardware AND absent from
  conntrack. An aggregate "no conntrack entries left" test never fires, because
  other hosts on the LAN are talking to the same destination.

Scope

Drivers that offload through TC_SETUP_FT and rely on FLOW_CLS_DESTROY to
release hardware state look affected by inspection: mtk_eth_soc (measured),
mtk_wed, airoha, mt76 npu, mlx5 representor FT. Drivers that flush their own
entries when they remove their callback (mlx5 tc_ct, nfp, sfc) are not. Only
mtk_eth_soc was tested.

A possible fix, and what I measured

Remove the flows using the device before the block is unbound:
nf_flow_table_offload_setup() on FLOW_BLOCK_UNBIND could call
nf_flow_table_gc_cleanup(flowtable, dev) first, so the FLOW_CLS_DESTROY is
delivered while the callback is still on cb_list. That is what the kernel
already does for indirect devices (nf_flow_table_indr_cleanup()) and on
NETDEV_DOWN, and one site covers the commit, update, netdev-event and abort
paths. I am aware that "generalize pending status bit" reworks this area.

I have not sent a patch, but I have built that change and run it on the
hardware: two images differing by that one hunk and nothing else, the same
reproducer on each.

  - Unmodified kernel: the reproducer strands the flows. All 4 flows stay
    bound in the PPE, in 26 of 26 samples taken after the reload -- first
    sustained 22.7 s in and still true at 167 s, past both the 20 s and the
    60 s UDP timeouts.
  - With the change: no flow is left bound with no conntrack entry behind
    it -- 0 of 4, clean in all 25 samples, and the flows re-bind under the
    new flowtable.

An orphan check on the patched image (every bound entry cross-referenced
against conntrack, with a synthetic control entry injected to show the check
can fire) found none at +10 minutes or +1 hour. The change is carried as a
downstream patch in OpenWrt.

  - Martino Dell'Ambrogio <tillo@tillo.ch>

Assisted-by: LLM

