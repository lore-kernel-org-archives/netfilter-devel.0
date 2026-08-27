Received: from bg-bec.cloudflare-smtp.org (bg-bec.cloudflare-smtp.org [104.30.16.142])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 586E43E6386
	for <netfilter-devel@vger.kernel.org>; Thu, 27 Aug 2026 12:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=104.30.16.142
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787834615; cv=none; b=KaHshMJf+7FU8W1fAb+yNQ6Ssm9Vzc6bEcuM7ipzgr326TaTGnuFc+iJRULMPhLssAUxx54NrPHCqi6R5+88Q433FDb5SXqd89xTLkZTuockeZeSjNt5eLHMiWkRVv24p+uAOYPmJAw9QAOxgSYersME9CSf0zCophUs39oIXis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787834615; c=relaxed/simple;
	bh=b/fC+GD0Bhpx9A6zC42hiP9tocTjMBMLpwkoQn6ACv8=;
	h=From:Message-ID:Date:Subject:To:MIME-Version:Content-Type; b=e7kdtgqOdER52IUCTvtY5Vs29bsPQuN847p++wBAHbG4STS7FHBiRI+N92+6WiLO5WopUlaPwzZS4lK5ybFb3aSlHTFoDn61nciXBM3HWQma1p/B5wH2ikvQ6o2N6SAfGrLGozQOZCnK0Ed44//NirI7VVm4+RUqFtkD0dJh9PY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bugs.sh; spf=pass smtp.mailfrom=cf-bounce.bugs.sh; dkim=pass (2048-bit key) header.d=cloudflare-smtp.org header.i=@cloudflare-smtp.org header.b=KxboZYOv; dkim=pass (2048-bit key) header.d=bugs.sh header.i=@bugs.sh header.b=VX73mdhg; arc=none smtp.client-ip=104.30.16.142
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bugs.sh
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cf-bounce.bugs.sh
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloudflare-smtp.org header.i=@cloudflare-smtp.org header.b="KxboZYOv";
	dkim=pass (2048-bit key) header.d=bugs.sh header.i=@bugs.sh header.b="VX73mdhg"
DKIM-Signature: v=1; a=rsa-sha256; s=cf2024-1; d=cloudflare-smtp.org; c=relaxed/relaxed;
	h=To:Subject:Date:From:Feedback-ID:from:reply-to:cc:resent-date
	:resent-from:resent-to:resent-cc:in-reply-to:references:list-id:list-help
	:list-unsubscribe:list-unsubscribe-post:list-subscribe:list-post
	:list-owner:list-archive; t=1787834604; x=1788439404; bh=sLlAxbEfCVYbW/6A66
	frTETNLK1V+95Rf4TN8BoQAL8=; b=KxboZYOv9iSEGAZ+KxJBIWZwWZgSuB/Wu4YpwapPyr+Dg
	rLErT0tu+7xcN1/69USqHQuN3EqFYo8Dm6fK2LuY0ATgRjZ9KN6LYvC959ta59934cBGRXscEJg
	bjutWFSdthCJL9oOkrw2EFWO6A3QioJcsIfVUjZFRN8LehG4ZAFFL/ZdDkPkoz0aHexe3v1KYIO
	ju/Q6nPBApI+oUrRKqkLntNFXG4Si8VgMnMQq939JS4eZu3OduIDj04f41wYAQDsMgyB7v1wfU1
	9oZ/VYwcC7BUwR9Jf3lPAQYZ1LIGK1hQmR9KpDBrVIOqD8fye+VZrJV+YssfiezI+FVsT2bQ==;
DKIM-Signature: v=1; a=rsa-sha256; s=cf-bounce; d=bugs.sh; c=relaxed/relaxed;
	h=To:Subject:Date:From:Feedback-ID:from:reply-to:cc:resent-date
	:resent-from:resent-to:resent-cc:in-reply-to:references:list-id:list-help
	:list-unsubscribe:list-unsubscribe-post:list-subscribe:list-post
	:list-owner:list-archive; t=1787834604; x=1788439404; bh=sLlAxbEfCVYbW/6A66
	frTETNLK1V+95Rf4TN8BoQAL8=; b=VX73mdhgLZXtFxBwA1C2+7x02PaQqUqYVCLRauW4m2agP
	zm9e//25HvwdmWVm/yP33/y5JdiQGKCCJQr1WuYF/hGxhqbbdNNq7FjXMJd0UzOj9h96W3b1RQ/
	QgOcymRPAuhDs3K1KON5A9WTf6LczXydFpWYQqmmdvDWeOiaT+8FprYEL5KKaTKH1RADKIeBtL4
	PuRCkL5d5QD5EbVflv2EO4nkigImLs360TqwxKwvhQeXof/rD7+vW9twuryiLPFvwgaerateGsG
	Eet3eGGOGSKNZj5FEVQ9XaZ1+xHduipJwP0PVAxt5cT6ABmKgtJbYfExepIboWVHh/m3C/kA==;
Feedback-ID: bugs.sh:5:6:Cloudflare
From: co <co+63bad23bb3b4cd85@bugs.sh>
Message-ID: <fai12uKS5302YnCQV4E3zlDqcsAS5aGcMutS@bugs.sh>
Date: Thu, 27 Aug 2026 12:43:08 +0000
Subject: [BUG] net/bridge: out-of-bounds in br_forward()
To: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, bridge@lists.linux.dev, netdev@vger.kernel.org, "Pablo
 Neira Ayuso" <pablo@netfilter.org>, "Florian Westphal" <fw@strlen.de>, "Nikolay
 Aleksandrov" <razor@blackwall.org>, "Ido Schimmel" <idosch@nvidia.com>, "David
 S. Miller" <davem@davemloft.net>, "Eric Dumazet" <edumazet@google.com>, "Jakub
 Kicinski" <kuba@kernel.org>, "Paolo Abeni" <pabeni@redhat.com>, "Sabrina
 Dubroca" <sd@queasysnail.net>, "Phil Sutter" <phil@nwl.cc>, "Simon Horman" <horms@kernel.org>, linux-kernel@vger.kernel.org
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

We found a bug reachable in:

    path    net/bridge/netfilter
    crash   out-of-bounds in br_forward()
    commit  7b5344954050 ("Merge tag 'nf-26-08-10' of git://git.kernel.org/=
pub/scm/linux/kernel/git/netfilter/nf")

Config, environment, the sanitizer report and a C reproducer follow.

=3D=3D Notes =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
    If you patch the bug based on our artifacts, a tag would be
    appreciated:

Reported-by: co+63bad23bb3b4cd85@bugs.sh

    Everything in this mail is validated by the reproducer below.

    We also hold an LLM-generated root-cause analysis and a candidate
    patch. The patch passes an A/B test: the same reproducer panics the
    unpatched kernel and runs clean on the patched one. Neither has had
    human review, so both still require validation before you send or
    apply them. Available on:

        patch.diff  https://bugs.sh/b/63bad23bb3b4cd85/patch.diff
        report.md   https://bugs.sh/b/63bad23bb3b4cd85/report.md

    This is an open science project. The code and the full set of PoCs
    are not public at this moment, as we intend to disclose our findings
    in an ethical way.

    Happy to test patches. Complaints and suggestions about our work
    are welcome at:

        cedalion@bugs.sh

=3D=3D Environment =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
    Reproduced on  7b5344954050 ("Merge tag 'nf-26-08-10' of git://git.kern=
el.org/pub/scm/linux/kernel/git/netfilter/nf")
    VM setup       https://bugs.sh/b/63bad23bb3b4cd85/run.sh
    config         https://bugs.sh/b/63bad23bb3b4cd85/config.gz
    poc            https://bugs.sh/b/63bad23bb3b4cd85/repro.c

=3D=3D Sanitizer Report =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
BUG: KASAN: slab-out-of-bounds in br_forward+0x3c2/0x420
Read of size 8 at addr ffff888023fc3938 by task exploit/5007
CPU: 0 UID: 1000 PID: 5007 Comm: exploit Not tainted 7.2.0-rc6-00285-g7b534=
4954050 #20 PREEMPT(full)
Call Trace:
 <IRQ>
 dump_stack_lvl+0x10e/0x1f0 (lib/dump_stack.c:123)
 print_report+0xf7/0x600 (mm/kasan/report.c:379)
 kasan_report+0xe4/0x120 (mm/kasan/report.c:597)
 br_forward+0x3c2/0x420 (net/bridge/br_forward.c:151 (discriminator 2))
 nft_reject_br_send_v4_unreach+0x9c/0x130 (net/bridge/netfilter/nft_reject_=
bridge.c:75)
 nft_reject_bridge_eval+0x4f0/0xcc0 (net/bridge/netfilter/nft_reject_bridge=
.c:129)
 nft_do_chain+0x2e5/0x19d0 (net/netfilter/nf_tables_core.c:287)
 nft_do_chain_bridge+0x199/0x290 (net/netfilter/nft_chain_filter.c:235)
 nf_hook_slow+0xbf/0x220 (net/netfilter/core.c:620)
 br_nf_hook_thresh+0x286/0x410 (net/bridge/br_netfilter_hooks.c:1164)
 br_nf_pre_routing_finish+0xb7c/0x1830 (net/bridge/br_netfilter_hooks.c:432)
 br_nf_pre_routing+0xfb6/0x1600 (./include/linux/netfilter.h:319)
 br_handle_frame+0xcbb/0x1520 (net/bridge/br_input.c:292)
 __netif_receive_skb_core.constprop.0+0x6bf/0x3610 (net/core/dev.c:6103 (di=
scriminator 1))
 __netif_receive_skb_one_core+0xb0/0x1e0 (net/core/dev.c:6215)
 __netif_receive_skb+0x1f/0x120 (net/core/dev.c:6329)
 process_backlog+0x399/0x15b0 (./include/linux/rcupdate.h:869)
 __napi_poll.constprop.0+0xb3/0x550 (net/core/dev.c:7740)
 net_rx_action+0xa5e/0x1020 (net/core/dev.c:7804)
 handle_softirqs+0x1ea/0x9b0 (./arch/x86/include/asm/jump_label.h:37)
 do_softirq+0xad/0xe0 (kernel/softirq.c:523 (discriminator 20))
 </IRQ>
 __local_bh_enable_ip+0xfc/0x120 (kernel/softirq.c:450)
 __dev_queue_xmit+0xa2c/0x47f0 (net/core/dev.c:4914)
 packet_xmit+0x243/0x360 (./include/linux/netdevice.h:3448)
 packet_sendmsg+0x32fa/0x5010 (net/packet/af_packet.c:3109 (discriminator 1=
))
 __sys_sendto+0x480/0x4d0 (net/socket.c:775 (discriminator 1))
 __x64_sys_sendto+0xe0/0x1c0 (net/socket.c:2255)
 do_syscall_64+0x116/0x7d0 (arch/x86/entry/syscall_64.c:63 (discriminator 1=
))
The buggy address belongs to the object at ffff888023fc3920
 which belongs to the cache kmalloc-16 of size 16
The buggy address is located 8 bytes to the right of
 allocated 16-byte region [ffff888023fc3920, ffff888023fc3930)
Kernel panic - not syncing: KASAN: panic_on_warn set ...


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


