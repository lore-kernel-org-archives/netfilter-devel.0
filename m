Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792567297;
	b=dnWBTyoZB5kkpQOOO/A6Mc5jqqFG2Au8fz1Ce/8U1vjGFk0LKPCPlNvW3oj9q/lYZjYf
	 cxB3NWTAzXynD3jOwgnTyTadU5RXmtoRGTnuZe9rM2c5o8gppyFD0favtx5TGF4ti32cg
	 jUyYiHeAY9KcrdQA9JL/EG4fgj2a9YvMgKMVDA1vakCmZLm/yVGRHgPtccW0HoVAtFFGs
	 4b+DmwtujPktgiTld6XtC0Mth4r/8MBw/Eou5z99w6t17hGYcxwOFnfS1Z/HpJo9bFRPB
	 L+4MPFCeQyhBpafaDy63oJ18/xinZTxGcouVqEvKvxP2rh1k0Td6YKOTL6ExT268SHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792567297;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=HmLsFgKYt4hjamblS90ei1R66crwKp0Qqp8Psy34br8=;
	b=DcioUPGLPv7YJj0MKRpTCDWNYzH2XGiYNbhGSyVsT1b0Zk2NXW/13OeuaqSm5UfCGq41
	 xeDBF+hFGY00wbobgQLnypK56kZChNEWem7bKElGuSo6/mff8HEkk2C8qbFF9iCgFTBQp
	 la/yDEuJ2uSE8PabOHvzRuf4ZbiV63VUHBiwZVdNmGQGmuUr77NgAuu3Gx5Z8sZzHFXI8
	 gGNiK5dpFl8qHo4DZ8wuXBcCW1Gvrp/Y9P4AFeycRaq96H/EEKddKDE5ugQhtb3E/SF2w
	 Wl7HVacROFft6sbscdZkmG7bHAepT2j6ChjXjICEGzFUEimgy33x+f73pHzL8Da+6IA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b="i+sy8Qv/";
	arc=none smtp.remote-ip=209.85.208.49
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02C7F606A31A
	for <netfilter-devel@vger.kernel.org>; Wed, 21 Oct 2026 07:21:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 02C7F606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=i+sy8Qv/
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6b1b13e09ffso464780a12.3
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Oct 2026 00:21:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792567295; x=1793172095; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=HmLsFgKYt4hjamblS90ei1R66crwKp0Qqp8Psy34br8=;
        b=i+sy8Qv/+LsMlhZbtZzA9Ad/NJqZpvNaWCk1KsngQyGXEhcPgTTcX/xoFSws/vytND
         2yVp3UabhTI/DYZMlQaKDKMelYuVEukaVrfpXEzNwrEE759iFlChNMQLb2imXpsGlc5z
         17wLHI7NX5xxUCM6sbnoYvt0Pk2a63UVDwq2Zje9luQT75PEvBd9KjYZflkz4XJ1gxG2
         7LRw3w3cK/8yqRQP9FrEK/1cHDhFSa5U1WT9H2Nd2QB80pSfUaFuGaFIfC7RBhkt+XmZ
         RcN03QJw2jvW7ySmL77VOnKmKcwHvcz9U+4QqFa+QLvqDFCEn/n7mlYo4MQOX0XYA4zI
         hBzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792567295; x=1793172095;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HmLsFgKYt4hjamblS90ei1R66crwKp0Qqp8Psy34br8=;
        b=v/SJ7fdvdi2uBP+xwkLY10RfqutaZJghVOlRfJX/FmM0qVWmMoh/M7EpgS0TgHbjU7
         Z/YjNi84g3VJ5ahUJVPLn/KYCBXRSPMkyafay1a+Jj5TFjjwLosHs5phWQpY+0j402xv
         U+BjTpZ4dMXUJsKZsOQT6MhCi5g7pLCFMlbyST9iG+jIxXgDVWXIwVA22IWXDAMRuC6y
         T/ZvcpMkqW+HhAA4k80+9F6Q9eulPrFJy3BRZiQ6PclneQSevvCPyuw+VQcE3501IkK5
         lwjdCVmCstx9aFdG/p3Otlw30I1Ghh69s1orz4x41RTKB9S+wG8zWIbRdrJue3x6uxHP
         D1jg==
X-Forwarded-Encrypted: i=1; AKwUvBxt0R58bEdoP0FdQZGHoaZ2nM8P0OS97arKDfdrL1XyfEVF/sicl9Q+/BO1z+J1a9+uVkpYOhnmuogfgImq+nM=@vger.kernel.org
X-Gm-Message-State: AFq9FYLj+jq7ezIx1lXvvNCEDDp3wpB1cpN66BXxedr6WJG8aAnxR0s8
	U1V3Zx3uJhaSrsu3ezIQVx2UAE03A9hfgGu1maIH8evKaJ/g09vg+83M/jkPWCp0ncyEqqhb
X-Gm-Gg: AYBFou0Z5DQkbms97Y+MmjMh74jMBF29oHYXBkVKqYP8Ail4J6+mf6WfSZaBqzce93t
	8AGb9G0u2G7kz9YAslneJJ0hjhVBjPICy8kuOcpuUBXxTt/1/WJa64hW7ETJVGdWZ529GGhTop5
	vJzB4YHOiluI3HnkQi254m0UI8+b3kp7aj53X2EQdis4n053lmVdR6oAmMuwWUXgk3VJTGUEpTT
	bICUpQV6nkvi/PLY716flYEqVKDo4iRn+maFFTXwuIJWisIl6r0FNXj6GMz85dAg2S+5D3TTv3u
	z90Hb93kjp7TPnJYEvhict98AM3vF322VBVVsuthM/xmWgkhz13v5YZV2g9aHX0fRtrStCaZDYk
	hIeP4b6mIMwi+W0LjdECaRinNt61IuHgmiBGFfmUcdmD31ZhN4yZc4eWhMGXUfX+pLm1RT/kc5i
	KJd2iRM24sCqzqctukPmyqVQSOSNGPzz7DU0C4BiFIxuMu/v4q/SSU6MT9te+st/zibmb71HEKI
	01xstANcKkV8havHUEdX2F0/iYL69n6Ua0oHGj82qK5mQWezSQJKdtBzJgkb86TBM0=
X-Received: by 2002:a05:6402:400c:b0:6b1:d62b:a8dc with SMTP id 4fb4d7f45d1cf-6b408e066d7mr645670a12.1.1792567294939;
        Wed, 21 Oct 2026 00:21:34 -0700 (PDT)
Received: from theodors-laptop.. ([5.255.118.7])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b40315a59esm518881a12.32.2026.10.21.00.21.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 00:21:34 -0700 (PDT)
From: Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>
Cc: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH nf] netfilter: nfnetlink_queue: use the verdict portid for NFQA_EXP events
Date: Wed, 21 Oct 2026 15:21:20 +0800
Message-Id: <20261021072120.218794-1-theodorlarionov@gmail.com>
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

nfqnl_ct_parse() passes NETLINK_CB(entry->skb).portid to attach_expect(),
but entry->skb is the queued packet, so the portid comes from its IPCB.
With NLM_F_ECHO the expectation event is unicast to that portid. For
IPv4 without options it is 0, so the event reaches the kernel nfnetlink
socket and nfnetlink_rcv() dereferences its NULL file:

  KASAN: null-ptr-deref in range [0x0000000000000030-0x0000000000000037]
  RIP: 0010:file_ns_capable+0x43/0xb0
   netlink_net_capable+0x140/0x1c0
   nfnetlink_rcv+0x13a/0x420
   netlink_unicast+0x71d/0x970
   nlmsg_notify+0x108/0x290
   ctnetlink_expect_event+0x4ba/0x600
   nf_ct_expect_event_report+0x164/0x1d0
   nf_ct_expect_related_report+0x178/0x1f0
   ctnetlink_glue_attach_expect+0x2b0/0x380
   nfqnl_recv_verdict+0x8df/0x25d0
   nfnetlink_rcv_msg+0x4ff/0x890

Pass the portid of the verdict message.

Fixes: b7bd1809e078 ("netfilter: nfnetlink_queue: get rid of nfnetlink_queue_ct.c")
Cc: stable@vger.kernel.org
Signed-off-by: Theodor Arsenij Larionov Trichkine <theodorlarionov@gmail.com>
---
Found with a custom syzkaller-based fuzzer.

Pablo's pending "netfilter: nfnetlink_queue: restrict NFQA_EXP to
userspace helpers" still passes NETLINK_CB(entry->skb).portid, so it
does not fix this, and the two patches conflict.

Config:

CONFIG_KASAN=y
CONFIG_USER_NS=y
CONFIG_NET_NS=y
CONFIG_NETFILTER=y
CONFIG_NF_CONNTRACK=y
CONFIG_NF_CONNTRACK_EVENTS=y
CONFIG_NF_CONNTRACK_TFTP=y
CONFIG_NF_CT_NETLINK=y
CONFIG_NETFILTER_NETLINK_QUEUE=y
CONFIG_NETFILTER_NETLINK_GLUE_CT=y
CONFIG_NF_TABLES=y
CONFIG_NF_TABLES_IPV4=y
CONFIG_NFT_CT=y
CONFIG_NFT_QUEUE=y

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000006: 0000 [#1] SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000030-0x0000000000000037]
CPU: 2 UID: 65534 PID: 519 Comm: repro Not tainted 7.3.0-rc5-00195-gab699d296e06 #1 PREEMPT(full)
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
RIP: 0010:file_ns_capable+0x43/0xb0 kernel/capability.c:457
Code: bf 28 00 00 00 e8 bd 18 35 00 41 83 fc 28 77 55 e8 a2 20 35 00 48 8d 7b 30 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 75 52 48 8b 7b 30 31 c9 44 89 e2 48 89 ee e8 16 62 0f
RSP: 0018:ffffc90000f2f078 EFLAGS: 00010206
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: ffffffff8ebc74fe
RDX: 0000000000000006 RSI: 0000000000000201 RDI: 0000000000000030
RBP: ffff88800431a640 R08: 0000000000000201 R09: ffffed10015ef263
R10: 000000000000000c R11: 0000000000048e51 R12: 000000000000000c
R13: ffff88800431a640 R14: ffff888009f57970 R15: 00000000000000dc
FS:  000000002d5723c0(0000) GS:ffff8880d6b52000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f6d70ce4000 CR3: 0000000019718005 CR4: 0000000000770ef0
PKRU: 55555554
Call Trace:
 <TASK>
 __netlink_ns_capable net/netlink/af_netlink.c:852 [inline]
 netlink_ns_capable net/netlink/af_netlink.c:870 [inline]
 netlink_net_capable+0x140/0x1c0 net/netlink/af_netlink.c:901
 nfnetlink_rcv+0x13a/0x420 net/netfilter/nfnetlink.c:659
 netlink_unicast_kernel net/netlink/af_netlink.c:1338 [inline]
 netlink_unicast+0x71d/0x970 net/netlink/af_netlink.c:1364
 nlmsg_unicast include/net/netlink.h:1198 [inline]
 nlmsg_notify+0x108/0x290 net/netlink/af_netlink.c:2626
 ctnetlink_expect_event+0x4ba/0x600 net/netfilter/nf_conntrack_netlink.c:3130
 nf_ct_expect_event_report+0x164/0x1d0 net/netfilter/nf_conntrack_ecache.c:262
 nf_ct_expect_related_report+0x178/0x1f0 net/netfilter/nf_conntrack_expect.c:549
 ctnetlink_glue_attach_expect+0x2b0/0x380 net/netfilter/nf_conntrack_netlink.c:2895
 nfqnl_ct_parse net/netfilter/nfnetlink_queue.c:1743 [inline]
 nfqnl_recv_verdict+0x8df/0x25d0 net/netfilter/nfnetlink_queue.c:1821
 nfnetlink_rcv_msg+0x4ff/0x890 net/netfilter/nfnetlink.c:288
 netlink_rcv_skb+0x14b/0x410 net/netlink/af_netlink.c:2575
 nfnetlink_rcv+0x1af/0x420 net/netfilter/nfnetlink.c:667
 netlink_unicast_kernel net/netlink/af_netlink.c:1338 [inline]
 netlink_unicast+0x71d/0x970 net/netlink/af_netlink.c:1364
 netlink_sendmsg+0x879/0xd50 net/netlink/af_netlink.c:1919
 sock_sendmsg_nosec net/socket.c:800 [inline]
 __sock_sendmsg net/socket.c:815 [inline]
 __sys_sendto+0x48e/0x4e0 net/socket.c:2281
 __do_sys_sendto net/socket.c:2288 [inline]
 __se_sys_sendto net/socket.c:2284 [inline]
 __x64_sys_sendto+0xe0/0x1c0 net/socket.c:2284
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0xf6/0x500 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x44b1aa
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb b9 0f 1f 00 f3 0f 1e fa 41 89 ca 64 8b 04 25 18 00 00 00 85 c0 75 15 b8 2c 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 7e c3 0f 1f 44 00 00 41 54 48 83 ec 30 44 89
RSP: 002b:00007ffd6d44e7e8 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 0000000000000098 RCX: 000000000044b1aa
RDX: 0000000000000098 RSI: 00000000004c9320 RDI: 0000000000000006
RBP: 000000000000002c R08: 00007ffd6d44e7fc R09: 000000000000000c
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000006
R13: 00000000004c93fc R14: 00000000004c934c R15: 00007ffd6d44e8b0
 </TASK>
Modules linked in:

Reproducer:

#define _GNU_SOURCE
#include <arpa/inet.h>
#include <errno.h>
#include <linux/netfilter.h>
#include <linux/netfilter/nf_tables.h>
#include <linux/netfilter/nfnetlink.h>
#include <linux/netfilter/nfnetlink_conntrack.h>
#include <linux/netfilter/nfnetlink_queue.h>
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

#ifndef NFT_OBJECT_CT_HELPER
#define NFT_OBJECT_CT_HELPER 3
#endif

static char buf[8192];
static int len;

static void die(const char *m) { perror(m); exit(1); }

static struct nlmsghdr *msg_begin(uint16_t type, uint16_t flags, uint8_t family, uint16_t res_id)
{
	struct nlmsghdr *nlh = (struct nlmsghdr *)(buf + len);
	struct nfgenmsg *g;

	memset(nlh, 0, NLMSG_HDRLEN + sizeof(*g));
	nlh->nlmsg_type = type;
	nlh->nlmsg_flags = NLM_F_REQUEST | flags;
	nlh->nlmsg_seq = len;
	g = NLMSG_DATA(nlh);
	g->nfgen_family = family;
	g->version = NFNETLINK_V0;
	g->res_id = htons(res_id);
	len += NLMSG_HDRLEN + NLMSG_ALIGN(sizeof(*g));
	return nlh;
}

static void msg_end(struct nlmsghdr *nlh) { nlh->nlmsg_len = buf + len - (char *)nlh; }

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
static void put_u8(uint16_t t, uint8_t v) { put(t, &v, 1); }
static void put_be16(uint16_t t, uint16_t v) { v = htons(v); put(t, &v, 2); }
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

static void tuple(uint16_t type, uint32_t src, uint32_t dst, uint16_t sport, uint16_t dport)
{
	struct nlattr *t = nest(type), *ip, *pr;

	ip = nest(CTA_TUPLE_IP);
	put(CTA_IP_V4_SRC, &src, 4);
	put(CTA_IP_V4_DST, &dst, 4);
	nest_end(ip);
	pr = nest(CTA_TUPLE_PROTO);
	put_u8(CTA_PROTO_NUM, IPPROTO_UDP);
	put_be16(CTA_PROTO_SRC_PORT, sport);
	put_be16(CTA_PROTO_DST_PORT, dport);
	nest_end(pr);
	nest_end(t);
}

int main(void)
{
	struct sockaddr_in dst = { .sin_family = AF_INET, .sin_port = htons(69),
				   .sin_addr.s_addr = htonl(INADDR_LOOPBACK) };
	struct nlmsghdr *nlh;
	struct nlattr *n1, *n2, *n3;
	struct ifreq ifr = { 0 };
	int nft, q, lis, u, grp = NFNLGRP_CONNTRACK_EXP_NEW, r;
	uint32_t id = 0;
	char rb[65536];

	if (unshare(CLONE_NEWNET))
		die("unshare");
	u = socket(AF_INET, SOCK_DGRAM, 0);
	strcpy(ifr.ifr_name, "lo");
	ifr.ifr_flags = IFF_UP;
	if (ioctl(u, SIOCSIFFLAGS, &ifr))
		die("lo up");

	lis = socket(AF_NETLINK, SOCK_RAW, NETLINK_NETFILTER);
	if (lis < 0 || setsockopt(lis, SOL_NETLINK, NETLINK_ADD_MEMBERSHIP, &grp, sizeof(grp)))
		die("listener");

	nft = socket(AF_NETLINK, SOCK_RAW, NETLINK_NETFILTER);
	if (nft < 0)
		die("nft socket");
	msg_end(msg_begin(NFNL_MSG_BATCH_BEGIN, 0, AF_UNSPEC, NFNL_SUBSYS_NFTABLES));
	nlh = msg_begin(NFNL_SUBSYS_NFTABLES << 8 | NFT_MSG_NEWTABLE, NLM_F_CREATE | NLM_F_ACK, NFPROTO_IPV4, 0);
	put_str(NFTA_TABLE_NAME, "t");
	msg_end(nlh);
	nlh = msg_begin(NFNL_SUBSYS_NFTABLES << 8 | NFT_MSG_NEWCHAIN, NLM_F_CREATE | NLM_F_ACK, NFPROTO_IPV4, 0);
	put_str(NFTA_CHAIN_TABLE, "t");
	put_str(NFTA_CHAIN_NAME, "c");
	put_str(NFTA_CHAIN_TYPE, "filter");
	n1 = nest(NFTA_CHAIN_HOOK);
	put_be32(NFTA_HOOK_HOOKNUM, NF_INET_LOCAL_OUT);
	put_be32(NFTA_HOOK_PRIORITY, 0);
	nest_end(n1);
	msg_end(nlh);
	nlh = msg_begin(NFNL_SUBSYS_NFTABLES << 8 | NFT_MSG_NEWOBJ, NLM_F_CREATE | NLM_F_ACK, NFPROTO_IPV4, 0);
	put_str(NFTA_OBJ_TABLE, "t");
	put_str(NFTA_OBJ_NAME, "h");
	put_be32(NFTA_OBJ_TYPE, NFT_OBJECT_CT_HELPER);
	n1 = nest(NFTA_OBJ_DATA);
	put_str(NFTA_CT_HELPER_NAME, "tftp");
	put_u8(NFTA_CT_HELPER_L4PROTO, IPPROTO_UDP);
	nest_end(n1);
	msg_end(nlh);
	nlh = msg_begin(NFNL_SUBSYS_NFTABLES << 8 | NFT_MSG_NEWRULE, NLM_F_CREATE | NLM_F_APPEND | NLM_F_ACK, NFPROTO_IPV4, 0);
	put_str(NFTA_RULE_TABLE, "t");
	put_str(NFTA_RULE_CHAIN, "c");
	n1 = nest(NFTA_RULE_EXPRESSIONS);
	n2 = nest(NFTA_LIST_ELEM);
	put_str(NFTA_EXPR_NAME, "objref");
	n3 = nest(NFTA_EXPR_DATA);
	put_be32(NFTA_OBJREF_IMM_TYPE, NFT_OBJECT_CT_HELPER);
	put_str(NFTA_OBJREF_IMM_NAME, "h");
	nest_end(n3);
	nest_end(n2);
	n2 = nest(NFTA_LIST_ELEM);
	put_str(NFTA_EXPR_NAME, "queue");
	n3 = nest(NFTA_EXPR_DATA);
	put_be16(NFTA_QUEUE_NUM, 0);
	nest_end(n3);
	nest_end(n2);
	nest_end(n1);
	msg_end(nlh);
	msg_end(msg_begin(NFNL_MSG_BATCH_END, 0, AF_UNSPEC, NFNL_SUBSYS_NFTABLES));
	nl_send(nft);
	nl_acks(nft, 4);

	q = socket(AF_NETLINK, SOCK_RAW, NETLINK_NETFILTER);
	if (q < 0)
		die("queue socket");
	{
		struct nfqnl_msg_config_cmd cmd = { .command = NFQNL_CFG_CMD_BIND };
		struct nfqnl_msg_config_params par = { .copy_range = htonl(0xffff), .copy_mode = NFQNL_COPY_META };

		nlh = msg_begin(NFNL_SUBSYS_QUEUE << 8 | NFQNL_MSG_CONFIG, NLM_F_ACK, AF_UNSPEC, 0);
		put(NFQA_CFG_CMD, &cmd, sizeof(cmd));
		put(NFQA_CFG_PARAMS, &par, sizeof(par));
		msg_end(nlh);
		nl_send(q);
		nl_acks(q, 1);
	}

	if (sendto(u, "x", 1, MSG_DONTWAIT, (struct sockaddr *)&dst, sizeof(dst)) != 1)
		die("udp sendto");

	r = recv(q, rb, sizeof(rb), 0);
	if (r < 0)
		die("recv queued packet");
	for (nlh = (struct nlmsghdr *)rb; NLMSG_OK(nlh, r); nlh = NLMSG_NEXT(nlh, r)) {
		struct nlattr *a = (struct nlattr *)((char *)NLMSG_DATA(nlh) + NLMSG_ALIGN(sizeof(struct nfgenmsg)));
		int rem = nlh->nlmsg_len - ((char *)a - (char *)nlh);

		if (nlh->nlmsg_type != (NFNL_SUBSYS_QUEUE << 8 | NFQNL_MSG_PACKET))
			continue;
		for (; rem >= NLA_HDRLEN && a->nla_len >= NLA_HDRLEN && a->nla_len <= rem;
		     rem -= NLA_ALIGN(a->nla_len), a = (struct nlattr *)((char *)a + NLA_ALIGN(a->nla_len)))
			if ((a->nla_type & NLA_TYPE_MASK) == NFQA_PACKET_HDR)
				id = ntohl(((struct nfqnl_msg_packet_hdr *)((char *)a + NLA_HDRLEN))->packet_id);
	}
	if (!id) {
		fprintf(stderr, "no queued packet\n");
		return 1;
	}
	printf("queued packet id %u, sending verdict with NFQA_EXP and NLM_F_ECHO\n", id);
	fflush(stdout);

	{
		struct nfqnl_msg_verdict_hdr vh = { .verdict = htonl(NF_ACCEPT), .id = htonl(id) };
		uint32_t mark = 0;

		nlh = msg_begin(NFNL_SUBSYS_QUEUE << 8 | NFQNL_MSG_VERDICT, NLM_F_ECHO, AF_INET, 0);
		put(NFQA_VERDICT_HDR, &vh, sizeof(vh));
		n1 = nest(NFQA_CT);
		put(CTA_MARK, &mark, 4);
		nest_end(n1);
		n1 = nest(NFQA_EXP);
		tuple(CTA_EXPECT_TUPLE, htonl(INADDR_LOOPBACK), htonl(INADDR_LOOPBACK), 0, 5000);
		tuple(CTA_EXPECT_MASK, 0xffffffff, 0xffffffff, 0, 0xffff);
		nest_end(n1);
		msg_end(nlh);
		nl_send(q);
	}

	r = recv(q, rb, sizeof(rb), MSG_DONTWAIT);
	nlh = (struct nlmsghdr *)rb;
	if (r > 0 && nlh->nlmsg_type == (NFNL_SUBSYS_CTNETLINK_EXP << 8 | IPCTNL_MSG_EXP_NEW))
		printf("echo received on the verdict socket (type 0x%x)\n", nlh->nlmsg_type);
	else
		printf("no echo on the verdict socket (r=%d errno=%d)\n", r, r < 0 ? errno : 0);
	return 0;
}

 net/netfilter/nfnetlink_queue.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index a3bc00280051..a432813001e2 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -1724,7 +1724,7 @@ static int nfqnl_recv_verdict_batch(struct sk_buff *skb,
 }
 
 static struct nf_conn *nfqnl_ct_parse(const struct nfnl_ct_hook *nfnl_ct,
-				      const struct nlmsghdr *nlh,
+				      const struct nlmsghdr *nlh, u32 portid,
 				      const struct nlattr * const nfqa[],
 				      struct nf_queue_entry *entry,
 				      enum ip_conntrack_info *ctinfo)
@@ -1740,8 +1740,7 @@ static struct nf_conn *nfqnl_ct_parse(const struct nfnl_ct_hook *nfnl_ct,
 		return NULL;
 
 	if (nfqa[NFQA_EXP])
-		nfnl_ct->attach_expect(nfqa[NFQA_EXP], ct,
-				      NETLINK_CB(entry->skb).portid,
+		nfnl_ct->attach_expect(nfqa[NFQA_EXP], ct, portid,
 				      nlmsg_report(nlh));
 	return ct;
 #else
@@ -1818,8 +1817,9 @@ static int nfqnl_recv_verdict(struct sk_buff *skb, const struct nfnl_info *info,
 
 	if (nfqa[NFQA_CT]) {
 		if (nfnl_ct != NULL)
-			ct = nfqnl_ct_parse(nfnl_ct, info->nlh, nfqa, entry,
-					    &ctinfo);
+			ct = nfqnl_ct_parse(nfnl_ct, info->nlh,
+					    NETLINK_CB(skb).portid, nfqa,
+					    entry, &ctinfo);
 	}
 
 	if (entry->state.pf == PF_BRIDGE) {
-- 
2.34.1

