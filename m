Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=1.95.144.110
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793154960;
	b=YQpkejwczZUNVvAYJ9lkGXS+HtHN1MzLy2nxdiWfcK0A16+MsFZcvnqV4siE34mA/O3B
	 oMiKGo1vHociKgYFawup5Pl62j2w4LQ56J/TpjRgPjb7GIzyS9Nf62ZKg16kaQCkyxBN+
	 X85AgGrjyMhOUuTY0ERJNKGQFxw4jrhRRc3bGIdiNqehEq6wHIkP2QVIR0aHC7Su2gpeT
	 wl8PgSI/XiFFfypLt3OkWgZWVHQKZuDKFwRF+qts1mHwnm+LZnK8rqtpOV87GP3PvLYID
	 LUk9N1f210DXn9+VZ41qm5jYzF1NkSxPbXfPOM/KYAjVVY1hDh082hGlPgZvgkBLzJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793154960;
	h=DMARC-Filter:Received:Received:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:Accept-Language:
	 Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 x-originating-ip:Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=TVR/bders8gsLGGxNVhzSC/dKCCM/SvZvbArKF+vv/w=;
	b=E+5DMa7hmOMkdX7AD3C1SmPXsVls2gPCrUXyarXz2NPFtqnuBbkVV5fC0XDXJW9jltKU
	 MBPcVz8E0AbIziUpEYlr/pAuf0vezuhQIEbwwDd4uaT/npb9I2+/c9037nXAflvYZItCq
	 KXOOTsW3QPc6jV7dXNf3Ubi5BzAuMsPxZLxIjhK/j+wpC72k15//ar7WOY59h43KEutPk
	 RMj7RcQDJq9GvH46d139qIGnqMba+7G+1ehOjHvDPpPzzFl/4q+h1wkpr+t2eHaeG9zI9
	 ViUI+3msUno82PWVxz35MR22o6X+3PJ653ags7iNGk0Eny3maEfCBNO7IZH0yAZDPpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=yinwang.com;
	spf=pass smtp.mailfrom=yinwang.com;
	arc=none smtp.remote-ip=1.95.144.110
Received: from segout02.yinwang.com (segout02.yinwang.com [1.95.144.110])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54AE2606A31A;
	Wed, 28 Oct 2026 02:35:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 54AE2606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=yinwang.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yinwang.com
Received: from mail.maildlp.com (unknown [10.15.1.214])
	by segout02.yinwang.com (SkyGuard) with ESMTPS id 4jDs2q3k8Rz64FT6;
	Wed, 28 Oct 2026 10:37:23 +0800 (CST)
Received: from KWEEX06.china.yinwang.com (unknown [10.16.5.49])
	by mail.maildlp.com (Postfix) with ESMTPS id A2E201A0FF4;
	Wed, 28 Oct 2026 10:35:54 +0800 (CST)
Received: from KWEEX08.china.yinwang.com (10.16.0.84) by
 KWEEX06.china.yinwang.com (10.16.5.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 28 Oct 2026 10:35:54 +0800
Received: from KWEEX08.china.yinwang.com ([fe80::1c58:6ee9:dd1f:a39d]) by
 KWEEX08.china.yinwang.com ([fe80::1c58:6ee9:dd1f:a39d%8]) with mapi id
 15.02.2562.049; Wed, 28 Oct 2026 10:35:44 +0800
From: "huangwenqing (A)" <huangwenqing@yinwang.com>
To: "pablo@netfilter.org" <pablo@netfilter.org>, "kadlec@netfilter.org"
	<kadlec@netfilter.org>, "fw@strlen.de" <fw@strlen.de>
CC: "netfilter@vger.kernel.org" <netfilter@vger.kernel.org>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>, "Phil
 Sutter" <phil@nwl.cc>, "wangli (D)" <wangli2@yinwang.com>, guxizhi
	<guxizhi@yinwang.com>
Subject: [BUG Report] UAF in ipt_do_table() on table replace (v5.10/v6.6)
Thread-Topic: [BUG Report] UAF in ipt_do_table() on table replace (v5.10/v6.6)
Thread-Index: Ad1l8bEV24cQrxkbR+y4apxm7MsIpA==
Date: Wed, 28 Oct 2026 02:35:44 +0000
Message-ID: <9fc5fe14207146a4a9d12c12cf17e652@yinwang.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Hello,

We hit a field panic in ipt_do_table() on an OEM kernel based on
v5.10.43 (arm64), several times per fleet per week, sometimes as
reboot storms on the same device; in most logs netd /
iptables-restore had run 0.7 to 2.2 seconds before the crash.  It
looks similar to the ip6t_do_table() use-after-free that motivated
cc00bcaa5899.  Field logs are customer-confidential; a sanitized
representative stack is at [2].

Root cause we suspect is as follows:

xt_replace_table (setsockopt IPT_SO_SET_REPLACE)
  table->private =3D newinfo
  /* ... wait for even xt_recseq on all cpus ... */
  for_each_possible_cpu(cpu)
    raw_read_seqcount(&per_cpu(xt_recseq, cpu))   // scan misses a walker
  return private
    xt_free_table_info
      cleanup_entry -> string_mt_destroy -> textsearch_destroy
        kfree(pattern)                            // old table + matches fr=
eed

ipt_do_table (reader, packet path, e.g. INPUT softirq)
  addend =3D xt_write_recseq_begin()          // seq -> odd
  private =3D READ_ONCE(table->private)       // still the old table
  ... walk the whole table ...              // reads freed memory
  xt_write_recseq_end(addend)               // seq -> even

A reader that fetched the old ->private but is missed by this
single-pass per-CPU scan keeps walking the old table while the
caller frees it.  Note xt_recseq is a seqcount_t used with
inverted roles: the entity marking the count (ipt_do_table) is the
*reader* of the protected data, the data writer (the replacer)
only polls the count, and nothing anywhere does
read_seqcount_begin()/retry on it -- it is a hand-rolled per-CPU
quiescence wait.

We reproduced this on vanilla v6.6.160 + KASAN: forcing the miss
once -- a single debugger write making the scan read "even" for
CPUs whose readers are still walking -- reproduces the
use-after-free with high probability, and the other in-flight
walkers then fault concurrently, ending in the same panic form as
the field (setup and method in [1]).  Without the flip we only see
long-tail wedges (replacers never returning from setsockopt()).
The flip does not prove the scan misses readers by itself; the
field crash is our natural occurrence.

History we may be misreading: cc00bcaa5899 (Dec 2020) converted
this scheme to RCU to fix a reported ip6t_do_table() UAF, was
reverted in March 2021 (d3d40f237480) because synchronize_rcu()
slowed table replaces by an order of magnitude (200 iptables
invocations: 1.16 s -> 11.59 s), and 175e476b8cdf then upgraded two
of the smp_wmb()s to smp_mb().  Our OEM kernel and current mainline
are both in that post-revert shape, so the field crash happens on
a kernel that already carries 175e476b8cdf.  One gap it did not
touch: xt_write_recseq_end() still only issues smp_wmb() before
the even store, leaving the walk's loads unordered against it.

Maybe the destruction of the old table could be deferred with
call_rcu() (as nftables does for replaced rules), which would keep
the replace latency as it is today while removing this whole class
of ordering subtleties.

Does anyone have a good idea to solve this problem?  Also, is the
single-pass scan believed to be correct on all architectures with
the 175e476b8cdf barriers, and is the end-side smp_wmb()-only
ordering known or considered harmless?

Best Regards,
Wenqing Huang

[1] Reproduction on vanilla v6.6.160 + KASAN (QEMU virt-aarch64,
16 vCPU):

    Kernel: kernel.org linux-6.6.160, arm64 defconfig +
    CONFIG_KASAN=3Dy (generic) + CONFIG_KASAN_VMALLOC=3Dy, booted with
    nokaslr.

    Load: per-CPU UDP senders crossing a filter table with ~45
    xt_string rules, plus processes looping
    setsockopt(IPT_SO_SET_REPLACE).

    Trigger: the window is narrow, so we forced exactly one event
    with a debugger.  On entry to xt_replace_table(), flip the
    per-CPU xt_recseq of the in-flight walkers odd -> even --
    i.e. make the scan read "even" for CPUs whose readers are
    still inside the table, the event the scan exists to rule out.
    This is the single debugger write (no memory poisoning, no
    page recycling); everything after it was natural: the scan
    passed, the old table and its xt_string/textsearch allocations
    were freed, and the walkers still walking were caught by KASAN.

    Full report:

    BUG: KASAN: slab-use-after-free in kmp_find+0x188/0x294
    Read of size 1 at addr ffff0000c81b8934 by task init/146
    CPU: 4 PID: 146 Comm: init Not tainted 6.6.160

    Call Trace (access -- an in-flight walker, softirq INPUT path,
    entered from sendto -> ip_output -> loopback delivery):
     kmp_find+0x188/0x294
     skb_find_text+0x130/0x198
     string_mt+0x6c/0x94
     ipt_do_table+0x494/0x7e4
     nf_hook_slow+0xa4/0x148
     ip_local_deliver+0x264/0x29c
     ip_rcv+0xb0/0x188
     __netif_receive_skb+0xac/0x1cc
     ... process_backlog -> net_rx_action

    Allocated by task 151 (the table install):
     __kmalloc+0xb8/0x10c
     kmp_init+0x54/0x2bc
     textsearch_prepare+0x128/0x18c
     string_mt_check+0xac/0xcc
     xt_check_match+0x3c8/0x42c
     translate_table+0x824/0xb40
     do_ipt_set_ctl (setsockopt IPT_SO_SET_REPLACE)

    Freed by task 150 (the next replace, tearing down the old
    table):
     kfree+0x58/0x78
     textsearch_destroy+0x5c/0x6c
     string_mt_destroy+0x30/0x40
     cleanup_entry+0x124/0x1f0
     do_ipt_set_ctl+0x800/0x8f4
     ... __arm64_sys_setsockopt (setsockopt IPT_SO_SET_REPLACE)

    The buggy address belongs to the object at ffff0000c81b8900, 52
    bytes inside it: the kmp pattern configuration of the old
    table's xt_string match -- the same object class whose bytes
    appear as wild match pointers in the field logs.

[2] Sanitized representative field stack (OEM v5.10.43):

    WARNING: CPU: 1 PID: 0 at net/ipv4/netfilter/ip_tables.c:305
              ipt_do_table+0x48c/0x6c4
    x8 : 0000000000000000            <- t->u.kernel.target
    Call trace:
     ipt_do_table+0x48c/0x6c4
     iptable_filter_hook+0x30/0x40
     nf_hook_slow+0xa8/0x1e8
     ip_local_deliver+0xa8/0x17c
     ip_rcv+0xfc/0x15c
     __netif_receive_skb_core+0xe58/0x114c
    [1.3 ms later]
    Unable to handle kernel NULL pointer dereference at virtual
    address 0000000000000030
    pc : ipt_do_table+0x2d8/0x6c4
    Kernel panic - not syncing: Oops: Fatal exception in interrupt

    Eleven captured occurrences all fault inside ipt_do_table(), at
    neighboring instructions of the same 0x6c4-byte function
    (+0xfc/+0x2ac/+0x2d8/+0x338/+0x48c), always from packet
    processing.  In other logs the faulting addresses are wild
    non-canonical (e.g. 0xffffff9c71769000), and in the clearest
    ones the in-register match pointer contains bytes of xt_string
    pattern data while the entry pointer is tens of KB past the end
    of the table blob.  Six product software versions from 2024 to
    2026 share the same kernel image (same faulting offsets, only
    the KASLR base differs), so this is a long-standing defect.
