Received: from bg-bec.cloudflare-smtp.org (bg-bec.cloudflare-smtp.org [104.30.16.142])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 370303BB126
	for <netfilter-devel@vger.kernel.org>; Thu, 27 Aug 2026 12:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=104.30.16.142
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787834577; cv=none; b=JcbnKAEpqcOioKKgtEQDigQN4nNx0CAdNhQkhXFlY1cWA+z38lQQoLwuZpJHWUCmcVWEW1aBySzsnTMTo0DwQll9ywuN6fhzpFpHFMlmhSSkB6PPcUo7uLDLL3kn1sxtLtt3CeSamAg97vAHlgn0QS3ZJ9ay0ouAOP14RJGwfpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787834577; c=relaxed/simple;
	bh=Fyq8W1C5NIE2ID3dj//V5ozh3f+RWS9ymH5093GPYoY=;
	h=From:Message-ID:Date:Subject:To:MIME-Version:Content-Type; b=am7qu1uTiNaYmdXlcPiMoI8MkKtjoRTlDFvBIxhn/MbTb9RVQrUz8smVpWIzfvbKFiSnlA3Fd/dIQUSKM8gpmmnBFZC1fCujutAwnLNC9SPqzgAwjidP9eV2c6YGI0yJ+NS5Q4DCoUpRxiKscrbImvdGqIyoEX8QdJ66GFg/dlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bugs.sh; spf=pass smtp.mailfrom=cf-bounce.bugs.sh; dkim=pass (2048-bit key) header.d=cloudflare-smtp.org header.i=@cloudflare-smtp.org header.b=Gik/z/rw; dkim=pass (2048-bit key) header.d=bugs.sh header.i=@bugs.sh header.b=Cx8KHar9; arc=none smtp.client-ip=104.30.16.142
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bugs.sh
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cf-bounce.bugs.sh
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloudflare-smtp.org header.i=@cloudflare-smtp.org header.b="Gik/z/rw";
	dkim=pass (2048-bit key) header.d=bugs.sh header.i=@bugs.sh header.b="Cx8KHar9"
DKIM-Signature: v=1; a=rsa-sha256; s=cf2024-1; d=cloudflare-smtp.org; c=relaxed/relaxed;
	h=To:Subject:Date:From:Feedback-ID:from:reply-to:cc:resent-date
	:resent-from:resent-to:resent-cc:in-reply-to:references:list-id:list-help
	:list-unsubscribe:list-unsubscribe-post:list-subscribe:list-post
	:list-owner:list-archive; t=1787834566; x=1788439366; bh=IETVInWIvmTv02Nai9
	QrkDPchLUk3qge893iEYEYjUA=; b=Gik/z/rwMWNiToV3uZyt84Pk0llATqG30a82UuX/on6ti
	pxJLRmShRaz1a71X9KugptFLrugzTAPjrw/v2t+IqGHUeh9PmQXCsr6OL5shuSWr/tKTWP83g73
	VDFBL0Miu7sTcez9crTFK+GjnVooqksAyS95se+cvbJIAoPjeJipJGlnMQpEybywEGZPFSA4Dj3
	gBMT5F/BPcbd0d/rt7vMSqOpu7wcnoCdDPs1Lxe5rEJ5BDgHUWxJ0iNn1nsDfIOnWqMSDMt+Qck
	bigj3tzj09GTBrTzkqF/ktNHBwmiJWgRLuZo4R7TlpFhESK9a1ttVC+KcwiUHnPxX9M55V9w==;
DKIM-Signature: v=1; a=rsa-sha256; s=cf-bounce; d=bugs.sh; c=relaxed/relaxed;
	h=To:Subject:Date:From:Feedback-ID:from:reply-to:cc:resent-date
	:resent-from:resent-to:resent-cc:in-reply-to:references:list-id:list-help
	:list-unsubscribe:list-unsubscribe-post:list-subscribe:list-post
	:list-owner:list-archive; t=1787834566; x=1788439366; bh=IETVInWIvmTv02Nai9
	QrkDPchLUk3qge893iEYEYjUA=; b=Cx8KHar9vznihLABqlemqceJAVKnKLL4QPuZGPXrP3T+z
	jof8MV6cRtHJL/5VdXDHSQZSC11winNJz+MzJEhQtea55WdzyLiClrOWx265JnOTHj4aFVCgDkB
	1zzFm4SFOIOByyKXDGX3PQtdOz9NGU/vZtKHp0e14v8wDA3wGlvqo8hArP2iwLYOUZmRZW6aawX
	6FBE64O15XGSn1IqpL0rmX9lCJ8DwpD5xUmXeLZ9IjDPUAeHaI6lxliWkc1kC/4bXwyzXWxG2Z2
	sPHbx0LaZqMkE2Pbg2iuwMn8LopW+GSeN+tKDCQdQwZUJkXJtJMsia/7Ff5ipZDj6DevEumQ==;
Feedback-ID: bugs.sh:5:6:Cloudflare
From: co <co+a720ac0c47d2d165@bugs.sh>
Message-ID: <zKVpkZXjE75xVdFiLMgHlG0eo0eFhEoMzS81@bugs.sh>
Date: Thu, 27 Aug 2026 12:42:38 +0000
Subject: [BUG] net/bridge: wild access in br_handle_frame_finish()
To: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, netdev@vger.kernel.org, bridge@lists.linux.dev, "Pablo
 Neira Ayuso" <pablo@netfilter.org>, "Florian Westphal" <fw@strlen.de>, "David
 S. Miller" <davem@davemloft.net>, "Eric Dumazet" <edumazet@google.com>, "Jakub
 Kicinski" <kuba@kernel.org>, "Paolo Abeni" <pabeni@redhat.com>, "Nikolay
 Aleksandrov" <razor@blackwall.org>, "Ido Schimmel" <idosch@nvidia.com>, "Phil
 Sutter" <phil@nwl.cc>, "Simon Horman" <horms@kernel.org>, "Jiri Pirko" <jiri@resnulli.us>, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

We found a bug reachable in:

    path    net/bridge
    crash   wild access in br_handle_frame_finish()
    commit  4e15e89faac9 ("net: bnxt: ring the doorbell when SW USO exits e=
arly")

Config, environment, the sanitizer report and a C reproducer follow.

=3D=3D Notes =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
    If you patch the bug based on our artifacts, a tag would be
    appreciated:

Reported-by: co+a720ac0c47d2d165@bugs.sh

    Everything in this mail is validated by the reproducer below.

    We also hold an LLM-generated root-cause analysis and a candidate
    patch. The patch passes an A/B test: the same reproducer panics the
    unpatched kernel and runs clean on the patched one. Neither has had
    human review, so both still require validation before you send or
    apply them. Available on:

        patch.diff  https://bugs.sh/b/a720ac0c47d2d165/patch.diff
        report.md   https://bugs.sh/b/a720ac0c47d2d165/report.md

    This is an open science project. The code and the full set of PoCs
    are not public at this moment, as we intend to disclose our findings
    in an ethical way.

    Happy to test patches. Complaints and suggestions about our work
    are welcome at:

        cedalion@bugs.sh

=3D=3D Environment =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
    Reproduced on  4e15e89faac9 ("net: bnxt: ring the doorbell when SW USO =
exits early")
    VM setup       https://bugs.sh/b/a720ac0c47d2d165/run.sh
    config         https://bugs.sh/b/a720ac0c47d2d165/config.gz
    poc            https://bugs.sh/b/a720ac0c47d2d165/repro.c

=3D=3D Sanitizer Report =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Oops: general protection fault, probably for non-canonical address 0xe0001b=
ffe0002001: 0000 [#1] SMP KASAN NOPTI
KASAN: maybe wild-memory-access in range [0x0000ffff00010008-0x0000ffff0001=
000f]
CPU: 0 UID: 1000 PID: 146 Comm: exploit Not tainted 7.2.0+ #57 PREEMPTLAZY
RIP: 0010:fdb_find_rcu (include/linux/rhashtable.h:152 include/linux/rhasht=
able.h:629 include/linux/rhashtable.h:672 net/bridge/br_fdb.c:216)
Call Trace:
<IRQ>
br_handle_frame_finish (net/bridge/br_input.c:204 (discriminator 1))
br_nf_hook_thresh (net/bridge/br_netfilter_hooks.c:1165)
br_nf_pre_routing_finish (net/bridge/br_netfilter_hooks.c:430)
br_nf_pre_routing (include/linux/netfilter.h:325 include/linux/netfilter.h:=
319 net/bridge/br_netfilter_hooks.c:539)
br_handle_frame (include/linux/netfilter.h:165 net/bridge/br_input.c:291 ne=
t/bridge/br_input.c:442)
__netif_receive_skb_core.constprop.0 (net/core/dev.c:6151)
__netif_receive_skb_one_core (net/core/dev.c:6262)
process_backlog (net/core/dev.c:6377 net/core/dev.c:6728)
__napi_poll (net/core/dev.c:7787)
net_rx_action (net/core/dev.c:7850 net/core/dev.c:8007)
handle_softirqs (kernel/softirq.c:645)
do_softirq.part.0 (kernel/softirq.c:546 (discriminator 20))
</IRQ>
__local_bh_enable_ip (kernel/softirq.c:538 kernel/softirq.c:473)
__dev_queue_xmit (include/linux/bottom_half.h:33 (discriminator 1) include/=
linux/rcupdate.h:914 (discriminator 1) net/core/dev.c:4961 (discriminator 1=
))
packet_sendmsg (net/packet/af_packet.c:3110 net/packet/af_packet.c:3142)
__sys_sendto (net/socket.c:800 (discriminator 1) net/socket.c:815 (discrimi=
nator 1) net/socket.c:2281 (discriminator 1))
__x64_sys_sendto (net/socket.c:2288 net/socket.c:2284 net/socket.c:2284)
do_syscall_64 (arch/x86/entry/syscall_64.c:61 arch/x86/entry/syscall_64.c:8=
4)
entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
Kernel panic - not syncing: Fatal exception in interrupt


---
The report format is based on syzbot bug report.

This report is generated by a bot. It may contain errors.
See https://github.com/n132/cedalion for more information.

For any issue with this report, reach out to cedalion@bugs.sh

If the report is already addressed, let us know by replying with:
#co fix: <commit hash>

If the report is a duplicate of another one, reply with:
#co dup: <lore link>

If you want to undo deduplication, reply with:
#co undup


