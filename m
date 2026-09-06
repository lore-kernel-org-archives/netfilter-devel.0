Received: from bg-bec.cloudflare-smtp.org (bg-bec.cloudflare-smtp.org [104.30.16.142])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3188E2FC893
	for <netfilter-devel@vger.kernel.org>; Sun,  6 Sep 2026 03:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=104.30.16.142
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788665876; cv=none; b=NF11oAhnb9A/aofrVRaN/ZMMntHUP9deXz79nGYKNKkTpAxZQAsR8wMB4qA9X5pPcQjw8F7PTYB0S5djX6ce970k31eIHqBy2QAmBXCz/ntsrp3mVkJ9vIVvfUMwha79DenEVUifB/gAPxnZGnTGXDeiQiQ228DBHWTvCMjnReQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788665876; c=relaxed/simple;
	bh=gvDvN6y7CKmrFlB1iZJIniLssY/D4WtfLH0eZesiHsA=;
	h=From:Message-ID:Date:Subject:To:Cc:MIME-Version:Content-Type; b=NF4yzpvP3xysfxeWZvBnHNxT94O1U/gSPOxCCJyaVu005vRaHImW5aYWaeGAQpN21o1PynVkjEhhKUzeYlIKY78UsWM2QO8F3dv1fMOxsApfxJiCBKByv6/lA5sHgmYmMBw+FNapwcT7isGM5Q0EIpRj8sVxj5yIAd+1Z+fQNuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bugs.sh; spf=pass smtp.mailfrom=cf-bounce.bugs.sh; dkim=pass (2048-bit key) header.d=cloudflare-smtp.org header.i=@cloudflare-smtp.org header.b=XCxrm0Y1; dkim=pass (2048-bit key) header.d=bugs.sh header.i=@bugs.sh header.b=KwXbdD3v; arc=none smtp.client-ip=104.30.16.142
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bugs.sh
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cf-bounce.bugs.sh
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloudflare-smtp.org header.i=@cloudflare-smtp.org header.b="XCxrm0Y1";
	dkim=pass (2048-bit key) header.d=bugs.sh header.i=@bugs.sh header.b="KwXbdD3v"
DKIM-Signature: v=1; a=rsa-sha256; s=cf2024-1; d=cloudflare-smtp.org; c=relaxed/relaxed;
	h=Cc:To:Subject:Date:From:Feedback-ID:from:reply-to:resent-date
	:resent-from:resent-to:resent-cc:in-reply-to:references:list-id:list-help
	:list-unsubscribe:list-unsubscribe-post:list-subscribe:list-post
	:list-owner:list-archive; t=1788665874; x=1789270674; bh=xc2Ex0uhfXEMXFA1mX
	vRGfAIuRAGTIYECR9dQM48cjw=; b=XCxrm0Y1gLaOw2GA5d92Rt8vZLtlek+011sl0uj9KEBd7
	5D4WLNtsrKRQebQjokDtedP0GUH1XTn2BQgPDZVc1HxZ4uQGin85IJ3V852VQ69E1KCYMr5AUQV
	SQVrHulAOxCBOCci91U/JIlP+x42h0jlrm6VN/e3T8hkWFq/vzV/uUS9jbhWbweMZffZMBaBFTu
	ey8Zel/8xK5zmemuLdupN5pUMF3qlXugL7In+j0T9m80xXo8foZx57yEK1t+eYCVC+juHNefZyb
	o4G1OpvmtNt3kb+FjCEqMmFaSP6qhoponpfbvCu+Xib20BOu0RLHIY6yEEqM4wO8xDQJi5bA==;
DKIM-Signature: v=1; a=rsa-sha256; s=cf-bounce; d=bugs.sh; c=relaxed/relaxed;
	h=Cc:To:Subject:Date:From:Feedback-ID:from:reply-to:resent-date
	:resent-from:resent-to:resent-cc:in-reply-to:references:list-id:list-help
	:list-unsubscribe:list-unsubscribe-post:list-subscribe:list-post
	:list-owner:list-archive; t=1788665874; x=1789270674; bh=xc2Ex0uhfXEMXFA1mX
	vRGfAIuRAGTIYECR9dQM48cjw=; b=KwXbdD3v9+ulQ35hauQCS5DcJ/qPiaH9NV03SD8vqzb1T
	PSsrrmWHuQpx3h8tdfHeJnc2ANZFaAVrrCoyjcr8hPQcBD8wOZ+J2NcQYybo+56cnnpi9L4sb3n
	D790I0TS+gh6VxRS8VIG4UJQ6f7At2zmFXWg99Pj9Wmzh3e0FOLDGR6otSY8IlN2b6s9uuyw2x7
	A0c9I8zFyvNF9yG1OTlQ5L2OqX6yuWg9UWMfK2l2ItMpZKtYbNIO1MwsPtgBEAmgqudDX+vBEmT
	Qse4sBValmZ4Ns2cnelzQh1/gLcz50BPipGKjVUTLagqNYgZaeERGiZp1sYnMklw6zvbbXFg==;
Feedback-ID: bugs.sh:5:6:Cloudflare
From: co <co+459f67f4d8af8ce6@bugs.sh>
Message-ID: <VtWUkE8QzJt5CroTj2V2v3ZQ0gwbXZ7nq7I3@bugs.sh>
Date: Sun, 06 Sep 2026 03:37:42 +0000
Subject: [BUG] net/ipv6: NULL pointer dereference in ip6_rt_copy_init()
To: netfilter-devel@vger.kernel.org, coreteam@netfilter.org, netdev@vger.kernel.org, "Pablo
 Neira Ayuso" <pablo@netfilter.org>, "Florian Westphal" <fw@strlen.de>, "David
 S. Miller" <davem@davemloft.net>, "Eric Dumazet" <edumazet@google.com>, "Jakub
 Kicinski" <kuba@kernel.org>, "Paolo Abeni" <pabeni@redhat.com>
Cc: "Phil Sutter" <phil@nwl.cc>, "Simon Horman" <horms@kernel.org>, linux-kernel@vger.kernel.org, co <co+459f67f4d8af8ce6@bugs.sh>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

We found a bug reachable in:

    path    net/ipv6/netfilter
    crash   NULL pointer dereference in ip6_rt_copy_init()
    commit  2f1baf1fc892 ("Merge tag 'trace-v7.2-rc7' of git://git.kernel.o=
rg/pub/scm/linux/kernel/git/trace/linux-trace")

Config, environment, the sanitizer report and a C reproducer follow.

=3D=3D Notes =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
    If you patch the bug based on our artifacts, a tag would be
    appreciated:

Reported-by: co+459f67f4d8af8ce6@bugs.sh

    Everything in this mail is validated by the reproducer below.

    We also hold an LLM-generated root-cause analysis and a candidate
    patch. The patch passes an A/B test: the same reproducer panics the
    unpatched kernel and runs clean on the patched one. Neither has had
    human review, so both still require validation before you send or
    apply them. Available on:

        patch.diff  https://bugs.sh/b/459f67f4d8af8ce6/patch.diff
        report.md   https://bugs.sh/b/459f67f4d8af8ce6/report.md

    This is an open science project. The code and the full set of PoCs
    are not public at this moment, as we intend to disclose our findings
    in an ethical way.

    Happy to test patches. Complaints and suggestions about our work
    are welcome at:

        cedalion@bugs.sh

=3D=3D Environment =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
    Reproduced on  2f1baf1fc892 ("Merge tag 'trace-v7.2-rc7' of git://git.k=
ernel.org/pub/scm/linux/kernel/git/trace/linux-trace")
    VM setup       https://bugs.sh/b/459f67f4d8af8ce6/run.sh
    config         https://bugs.sh/b/459f67f4d8af8ce6/config.gz
    poc            https://bugs.sh/b/459f67f4d8af8ce6/repro.c

=3D=3D Sanitizer Report =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Oops: general protection fault, probably for non-canonical address 0xdffffc=
0000000000: 0000 [#1] SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 0 UID: 1000 PID: 5001 Comm: exploit Not tainted 7.2.0-15884-g2f38e26a5=
741 #66 PREEMPT(full)
RIP: 0010:rpfilter_lookup_reverse6 (net/ipv6/netfilter/ip6t_rpfilter.c:75) =
(inlined by) rpfilter_mt (net/ipv6/netfilter/ip6t_rpfilter.c:105)
Call Trace:
<IRQ>
ip6t_do_table (net/ipv6/netfilter/ip6_tables.c:316)
nf_hook_slow (./include/linux/netfilter.h:165 net/netfilter/core.c:619)
nf_hook.constprop.0 (./include/linux/rcupdate.h:850 (discriminator 7) ./inc=
lude/linux/netfilter.h:249 (discriminator 7))
ipv6_rcv (./include/linux/netfilter.h:323 net/ipv6/ip6_input.c:351)
__netif_receive_skb_one_core (net/core/dev.c:6264 (discriminator 1))
__netif_receive_skb (net/core/dev.c:6377)
process_backlog (net/core/dev.c:6728)
__napi_poll.constprop.0 (net/core/dev.c:7787)
net_rx_action (net/core/dev.c:7850 net/core/dev.c:8007)
handle_softirqs (kernel/softirq.c:645)
do_softirq (kernel/softirq.c:546 (discriminator 20) kernel/softirq.c:533 (d=
iscriminator 20))
</IRQ>
__local_bh_enable_ip (kernel/softirq.c:473)
__dev_queue_xmit (./include/linux/bottom_half.h:33 (discriminator 1) ./incl=
ude/linux/rcupdate.h:923 (discriminator 1) net/core/dev.c:4961 (discriminat=
or 1))
packet_xmit (./include/linux/netdevice.h:3461 net/packet/af_packet.c:277)
packet_sendmsg (net/packet/af_packet.c:3111 net/packet/af_packet.c:3143)
__sys_sendto (net/socket.c:800 (discriminator 1) net/socket.c:815 (discrimi=
nator 1) net/socket.c:2281 (discriminator 1))
__x64_sys_sendto (net/socket.c:2288 net/socket.c:2284 net/socket.c:2284)
do_syscall_64 (arch/x86/entry/syscall_64.c:61 arch/x86/entry/syscall_64.c:8=
4)
entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
RIP: 0033:0x4266e7
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


