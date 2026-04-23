Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30CCD3793DD
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Apr 2026 10:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776939083; cv=none; b=lvjhzAaPCaW/Q+tep6ez3QprZan2vtUap0KBFJ7M+yacN+iBW0QAB4xyG0Mf7gs0y8lwg7OaU2uvcyR4+DkzvlKVd8ojizBN9lGf0pkZVp9WSGtS7ihd/05/qrDwxNIilgjOnH9PACX0VZHvaB0e3wUV4mmdF/7DyY7nf0yr8VA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776939083; c=relaxed/simple;
	bh=xjQUjWjbpDAiISDQNBMkUDGCtKyrq84sk+A4kzEog4c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EvavGtQ2WgW8Nol7hQ/FpnH9SpJgfGFzzQ5cI6KW7Fh55xiHzFnxlI7MedfgsUUZoYoKXukIIPALdSo+jb6cFOan8E38FwBDkdiBRaPHHKHotyGHsu71WFYMyKke9bTnbTnUCX7lRGOOCc03FxFK2Zq8eVGJnKCHqfHCHjawRYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=snu.ac.kr; spf=pass smtp.mailfrom=snu.ac.kr; dkim=pass (1024-bit key) header.d=snu.ac.kr header.i=@snu.ac.kr header.b=eDZPijHU; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=snu.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=snu.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=snu.ac.kr header.i=@snu.ac.kr header.b="eDZPijHU"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-c7961d7bc09so2435714a12.1
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Apr 2026 03:11:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=snu.ac.kr; s=google; t=1776939078; x=1777543878; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jCJAV9MpeZ+Wu2TainXnJP9CzYoU6zUtFE0pUXLwBhA=;
        b=eDZPijHUvDeoRVEZLTUS6CM9bRqOHy3YNJMuRaD+Vdr3JV2LWkAls/8Rh1xN7aAUMp
         ikh8h6BcW7f/Ff2a6Ldxm/nItCBKLUpWxC/K7qzizt/FhVCYdAwF9nyDPJx1hPhegFM7
         zoA/0lId3Ivnd4No4VqPXYdaE6cEqw5oApipg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776939078; x=1777543878;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jCJAV9MpeZ+Wu2TainXnJP9CzYoU6zUtFE0pUXLwBhA=;
        b=VfGlMBjhGFmzvUfKi9vMluNjHzEakmcWLlsL0ceXlP6CWCAx559hiea1xE9/aSZ1WW
         l1n3t/mcsBmTkjMN0DknANJejc6eFAQQtIKAH7oRTHBRGSPYEMkJuKXzZeOzDfH5wK6e
         /RRGxW5jtOh/AoFUmzR/eXim9WsPNiB/mDN9kIeQE9skQ4dlbJw/9le7u03n5kDJZDHT
         KmlVzCvoWH09qyDL/EnJbIcmPRHEtSDKsJytXVNHb20cSyC01oDKW9wV4E6ZsbiAFBPY
         H5vM27pf/DqJzBB+DNCAItRKWIXE1+OOqnuc6w5UQAXmJ+HcnODJjZ2b01PFniKFz95J
         4XfQ==
X-Forwarded-Encrypted: i=1; AFNElJ8zD4tLlZMlVrqx0W4AnuUvNjoJbyhlsN8pmBsrp6++hiHB6efWzeB0rShVAzGrYP3HwMzqccuDMy7Wtc2fZl4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9LS45Jni0q2I8L0I7onsOpysHWFt3jq8X5tf65IGiEMTyyQf4
	j8MsGM4JXTwfqhdhlp5yugKEEZx/HtDP/hDYV6HRj1cQyRV+7SKC76TtzPioElBr91hKQoQtO1l
	K+CVVIWSUGQ==
X-Gm-Gg: AeBDietelMG4j6HRK0fNC5zDqSmS6jNv/m7ACiK3V7iPmlADfzmZ7u83x9DqB757oMQ
	UlNh/S8oHfGHHBIvlpdJcgeCvp4ySivngUnBsKVpAZjoZ776XxJgqCh0vh6ilue/6/laD4BFf6w
	U76Jm2fT/RIM6Q/w3JX7FIuNGRSq2hPmrX/6ts7jDYyTdd9WHKaAKRyfOIpX/w48auke/DBJpUy
	qJe1+aY04WPJvYpjN4BDvAg08OsN0FTiiMsAgxmnweaphE5YDhWRDON++EFLGeAVwYpmMlE13Yw
	1X7SWpimGDy+D40l5w82hJ/F+aREwQwb1em61JM5ssbsVyGkWOZkVk0DmwbGGF31etbDZJGH+7a
	Nnpgcwlm12yUw05xvy9+9aib0sojiXddCIxg3Z918iZsZirt+K1bik63aE3aLtEXOGGOSoEUnLd
	Qm/RZOgl7V/9QdvUIfJqBnXflSbnv8CSxTPqbTPWsSqECYLpMpzuBZj4ATmm+b1q6qjjAqAtH9v
	krEYunffwc+
X-Received: by 2002:a05:6a21:9992:b0:398:7769:f869 with SMTP id adf61e73a8af0-3a08d73bff1mr28383600637.20.1776939078265;
        Thu, 23 Apr 2026 03:11:18 -0700 (PDT)
Received: from eulgyu-desktop.localdomain ([147.46.174.223])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c797703059fsm15040577a12.24.2026.04.23.03.11.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 03:11:17 -0700 (PDT)
From: Eulgyu Kim <eulgyukim@snu.ac.kr>
To: pablo@netfilter.org,
	fw@strlen.de
Cc: phil@nwl.cc,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-kernel@vger.kernel.org,
	byoungyoung@snu.ac.kr,
	jjy600901@snu.ac.kr
Subject: [BUG] KASAN: slab-use-after-free in hash_ipportip6_resize
Date: Thu, 23 Apr 2026 19:11:10 +0900
Message-ID: <20260423101110.1791588-1-eulgyukim@snu.ac.kr>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

We encountered a "KASAN: slab-use-after-free in hash_ipportip6_resize"
on kernel version v7.0.

As this memory corruption bug requires `CAP_NET_ADMIN`,
we report this in public mailing list.

We have included the following items below:
- C reproducer (~150 lines)
- kernel delay patch
- KASAN crash log

To reliably trigger the race condition bug, we patched the kernel
to inject a delay at a specific point.

The kernel config used is the same as the syzbot configuration.

Unfortunately, we do not have a fix ready for this bug yet.
As this issue was identified via fuzzing and we have limited background,
we find it challenging to propose a correct fix or evaluate
its potential severity.

We hope this report helps address the issue. Please let us know
if any further information is needed.

Thank you.

Best Regards,
Eulgyu Kim



kernel delay patch:
==================================================================
diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index b79e5dd2a..babe708ea 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -674,6 +674,8 @@ mtype_resize(struct ip_set *set, bool retried)
         */
        orig = ipset_dereference_bh_nfnl(h->table);
        atomic_set(&orig->ref, 1);
+       if (!strcmp(current->comm, "slowme"))
+               mdelay(3000);
        atomic_inc(&orig->uref);
        pr_debug("attempt to resize set %s from %u to %u, t %p\n",
                 set->name, orig->htable_bits, htable_bits, orig);
==================================================================



C reproducer:
==================================================================
#include <arpa/inet.h>
#include <linux/netfilter/ipset/ip_set.h>
#include <linux/netfilter/nfnetlink.h>
#include <linux/netlink.h>
#include <string.h>
#include <sys/prctl.h>
#include <sys/socket.h>

#define SET "syz1"
#define TYPE "hash:ip,port,ip"

#ifndef IPSET_ATTR_INITVAL
#define IPSET_ATTR_INITVAL 17
#define IPSET_ATTR_HASHSIZE 18
#define IPSET_ATTR_BUCKETSIZE 21
#endif

struct req {
	struct nlmsghdr n;
	struct nfgenmsg g;
	char buf[256];
};

static const unsigned char src[16] = {0xfe, 0x80, [15] = 0xaa};
static const unsigned char dst[16] = {0xfc, [15] = 1};

static void put(struct nlmsghdr *n, int type, const void *data, int len)
{
	struct nlattr *a = (void *)n + NLMSG_ALIGN(n->nlmsg_len);

	a->nla_type = type;
	a->nla_len = NLA_HDRLEN + len;
	memcpy((char *)a + NLA_HDRLEN, data, len);
	memset((char *)a + a->nla_len, 0, NLA_ALIGN(a->nla_len) - a->nla_len);
	n->nlmsg_len = NLMSG_ALIGN(n->nlmsg_len) + NLA_ALIGN(a->nla_len);
}

static struct nlattr *nest(struct nlmsghdr *n, int type)
{
	struct nlattr *a = (void *)n + NLMSG_ALIGN(n->nlmsg_len);

	put(n, type | NLA_F_NESTED, "", 0);
	return a;
}

static void done(struct nlmsghdr *n, struct nlattr *a)
{
	a->nla_len = (void *)n + n->nlmsg_len - (void *)a;
}

static void prep(struct req *r, int cmd)
{
	memset(r, 0, sizeof(*r));
	r->n.nlmsg_len = NLMSG_LENGTH(sizeof(r->g));
	r->n.nlmsg_type = (NFNL_SUBSYS_IPSET << 8) | cmd;
	r->n.nlmsg_flags = NLM_F_REQUEST;
}

static void send_req(int fd, struct nlmsghdr *n)
{
	struct sockaddr_nl sa = {.nl_family = AF_NETLINK};
	struct iovec iov = {.iov_base = n, .iov_len = n->nlmsg_len};
	struct msghdr msg = {
		.msg_name = &sa,
		.msg_namelen = sizeof(sa),
		.msg_iov = &iov,
		.msg_iovlen = 1,
	};

	sendmsg(fd, &msg, 0);
}

static void create_set(int fd)
{
	struct req r;
	struct nlattr *data;
	unsigned char proto = IPSET_PROTOCOL;
	unsigned char family = AF_INET6;
	unsigned char rev = 6;
	unsigned char bucketsize = 2;
	unsigned int hashsize = htonl(64);
	unsigned int initval = htonl(0x11223344);
	unsigned int timeout = 0;

	prep(&r, IPSET_CMD_CREATE);
	put(&r.n, IPSET_ATTR_PROTOCOL, &proto, 1);
	put(&r.n, IPSET_ATTR_SETNAME, SET, sizeof(SET));
	put(&r.n, IPSET_ATTR_TYPENAME, TYPE, sizeof(TYPE));
	put(&r.n, IPSET_ATTR_FAMILY, &family, 1);
	put(&r.n, IPSET_ATTR_REVISION, &rev, 1);

	data = nest(&r.n, IPSET_ATTR_DATA);
	put(&r.n, IPSET_ATTR_HASHSIZE | NLA_F_NET_BYTEORDER, &hashsize, 4);
	put(&r.n, IPSET_ATTR_INITVAL | NLA_F_NET_BYTEORDER, &initval, 4);
	put(&r.n, IPSET_ATTR_BUCKETSIZE, &bucketsize, 1);
	put(&r.n, IPSET_ATTR_TIMEOUT | NLA_F_NET_BYTEORDER, &timeout, 4);
	done(&r.n, data);

	send_req(fd, &r.n);
}

static void add_elem(int fd, int port)
{
	struct req r;
	struct nlattr *data;
	struct nlattr *ip;
	unsigned char proto = IPSET_PROTOCOL;
	unsigned char l4 = IPPROTO_TCP;
	unsigned short p = htons(port);

	prep(&r, IPSET_CMD_ADD);
	put(&r.n, IPSET_ATTR_PROTOCOL, &proto, 1);
	put(&r.n, IPSET_ATTR_SETNAME, SET, sizeof(SET));

	data = nest(&r.n, IPSET_ATTR_DATA);

	ip = nest(&r.n, IPSET_ATTR_IP);
	put(&r.n, IPSET_ATTR_IPADDR_IPV6 | NLA_F_NET_BYTEORDER, src, 16);
	done(&r.n, ip);

	ip = nest(&r.n, IPSET_ATTR_IP2);
	put(&r.n, IPSET_ATTR_IPADDR_IPV6 | NLA_F_NET_BYTEORDER, dst, 16);
	done(&r.n, ip);

	put(&r.n, IPSET_ATTR_PORT | NLA_F_NET_BYTEORDER, &p, 2);
	put(&r.n, IPSET_ATTR_PROTO, &l4, 1);
	done(&r.n, data);

	send_req(fd, &r.n);
}

int main(void)
{
	int fd = socket(AF_NETLINK, SOCK_RAW, NETLINK_NETFILTER);

	create_set(fd);
	add_elem(fd, 1);
	add_elem(fd, 29);
	prctl(PR_SET_NAME, "slowme");
	add_elem(fd, 37);
}

==================================================================



KASAN crash log:
==================================================================
BUG: KASAN: slab-use-after-free in instrument_atomic_read_write include/linux/instrumented.h:112 [inline]
BUG: KASAN: slab-use-after-free in atomic_inc include/linux/atomic/atomic-instrumented.h:435 [inline]
BUG: KASAN: slab-use-after-free in hash_ipportip6_resize+0x525/0x1d90 net/netfilter/ipset/ip_set_hash_gen.h:679
Write of size 4 at addr ffff888178410004 by task slowme/10152
CPU: 2 UID: 0 PID: 10152 Comm: slowme Not tainted 7.0.0-g20d60d956cd5 #27 PREEMPT(full)
Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xca/0x240 mm/kasan/report.c:482
 kasan_report+0x118/0x150 mm/kasan/report.c:595
 check_region_inline mm/kasan/generic.c:-1 [inline]
 kasan_check_range+0x2b0/0x2c0 mm/kasan/generic.c:200
 instrument_atomic_read_write include/linux/instrumented.h:112 [inline]
 atomic_inc include/linux/atomic/atomic-instrumented.h:435 [inline]
 hash_ipportip6_resize+0x525/0x1d90 net/netfilter/ipset/ip_set_hash_gen.h:679
 call_ad+0x54d/0xb00 net/netfilter/ipset/ip_set_core.c:1757
 ip_set_ad+0x791/0x930 net/netfilter/ipset/ip_set_core.c:1841
 nfnetlink_rcv_msg+0xb4d/0x1130 net/netfilter/nfnetlink.c:302
 netlink_rcv_skb+0x208/0x470 net/netlink/af_netlink.c:2550
 nfnetlink_rcv+0x282/0x2590 net/netfilter/nfnetlink.c:669
 netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
 netlink_unicast+0x82f/0x9e0 net/netlink/af_netlink.c:1344
 netlink_sendmsg+0x805/0xb30 net/netlink/af_netlink.c:1894
 sock_sendmsg_nosec net/socket.c:727 [inline]
 __sock_sendmsg net/socket.c:742 [inline]
 ____sys_sendmsg+0x981/0xa00 net/socket.c:2592
 ___sys_sendmsg+0x21f/0x2a0 net/socket.c:2646
 __sys_sendmsg net/socket.c:2678 [inline]
 __do_sys_sendmsg net/socket.c:2683 [inline]
 __se_sys_sendmsg net/socket.c:2681 [inline]
 __x64_sys_sendmsg+0x19b/0x260 net/socket.c:2681
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x160/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x412a64
Code: 00 00 04 00 89 01 e9 c1 fe ff ff e8 d6 01 00 00 66 0f 1f 44 00 00 f3 0f 1e fa 80 3d 1d 80 09 00 00 74 13 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 4c c3 0f 1f 00 55 48 89 e5 48 83 ec 20 89 55
RSP: 002b:00007fff9a547278 EFLAGS: 00000202 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 0000000000412a64
RDX: 0000000000000000 RSI: 00007fff9a5472b0 RDI: 0000000000000003
RBP: 00007fff9a5472f0 R08: 00000000004aa240 R09: 0000000000000110
R10: 0000000000412a64 R11: 0000000000000202 R12: 00007fff9a547588
R13: 00007fff9a547598 R14: 00000000004a5f68 R15: 0000000000000001
 </TASK>
Allocated by task 10152:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
 __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415
 kasan_kmalloc include/linux/kasan.h:263 [inline]
 __do_kmalloc_node mm/slub.c:5260 [inline]
 __kvmalloc_node_noprof+0x552/0x8d0 mm/slub.c:6752
 hash_ipportip_create+0x358/0x1040 net/netfilter/ipset/ip_set_hash_gen.h:1569
 ip_set_create+0xa9a/0x19c0 net/netfilter/ipset/ip_set_core.c:1109
 nfnetlink_rcv_msg+0xb4d/0x1130 net/netfilter/nfnetlink.c:302
 netlink_rcv_skb+0x208/0x470 net/netlink/af_netlink.c:2550
 nfnetlink_rcv+0x282/0x2590 net/netfilter/nfnetlink.c:669
 netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
 netlink_unicast+0x82f/0x9e0 net/netlink/af_netlink.c:1344
 netlink_sendmsg+0x805/0xb30 net/netlink/af_netlink.c:1894
 sock_sendmsg_nosec net/socket.c:727 [inline]
 __sock_sendmsg net/socket.c:742 [inline]
 ____sys_sendmsg+0x981/0xa00 net/socket.c:2592
 ___sys_sendmsg+0x21f/0x2a0 net/socket.c:2646
 __sys_sendmsg net/socket.c:2678 [inline]
 __do_sys_sendmsg net/socket.c:2683 [inline]
 __se_sys_sendmsg net/socket.c:2681 [inline]
 __x64_sys_sendmsg+0x19b/0x260 net/socket.c:2681
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x160/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
Freed by task 44:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:584
 poison_slab_object mm/kasan/common.c:253 [inline]
 __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:285
 kasan_slab_free include/linux/kasan.h:235 [inline]
 slab_free_hook mm/slub.c:2685 [inline]
 slab_free mm/slub.c:6165 [inline]
 kfree+0x1c3/0x640 mm/slub.c:6483
 hash_ipportip6_ahash_destroy net/netfilter/ipset/ip_set_hash_gen.h:445 [inline]
 hash_ipportip6_gc+0x3e1/0x610 net/netfilter/ipset/ip_set_hash_gen.h:587
 process_one_work kernel/workqueue.c:3288 [inline]
 process_scheduled_works+0xb5a/0x1890 kernel/workqueue.c:3371
 worker_thread+0xa54/0xfc0 kernel/workqueue.c:3452
 kthread+0x389/0x480 kernel/kthread.c:436
 ret_from_fork+0x513/0xba0 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
The buggy address belongs to the object at ffff888178410000
 which belongs to the cache kmalloc-cg-1k of size 1024
The buggy address is located 4 bytes inside of
 freed 1024-byte region [ffff888178410000, ffff888178410400)
The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffff888178414000 pfn:0x178410
head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
memcg:ffff888178410411
flags: 0x17ff00000000240(workingset|head|node=0|zone=2|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 017ff00000000240 ffff888100084000 ffffea0005afea10 ffffea00046f7a10
raw: ffff888178414000 000008000010000c 00000000f5000000 ffff888178410411
head: 017ff00000000240 ffff888100084000 ffffea0005afea10 ffffea00046f7a10
head: ffff888178414000 000008000010000c 00000000f5000000 ffff888178410411
head: 017ff00000000003 ffffea0005e10401 00000000ffffffff 00000000ffffffff
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000008
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 5493, tgid 5493 ((udev-worker)), ts 20315379036, free_ts 20313606043
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x23d/0x2a0 mm/page_alloc.c:1889
 prep_new_page mm/page_alloc.c:1897 [inline]
 get_page_from_freelist+0x24e0/0x2580 mm/page_alloc.c:3962
 __alloc_frozen_pages_noprof+0x181/0x370 mm/page_alloc.c:5250
 alloc_slab_page mm/slub.c:3292 [inline]
 allocate_slab+0x77/0x670 mm/slub.c:3481
 new_slab mm/slub.c:3539 [inline]
 refill_objects+0x33a/0x3d0 mm/slub.c:7175
 refill_sheaf mm/slub.c:2812 [inline]
 __pcs_replace_empty_main+0x2e8/0x730 mm/slub.c:4615
 alloc_from_pcs mm/slub.c:4717 [inline]
 slab_alloc_node mm/slub.c:4851 [inline]
 __do_kmalloc_node mm/slub.c:5259 [inline]
 __kmalloc_noprof+0x473/0x770 mm/slub.c:5272
 kmalloc_noprof include/linux/slab.h:954 [inline]
 kzalloc_noprof include/linux/slab.h:1188 [inline]
 alloc_pipe_info+0x1fd/0x4d0 fs/pipe.c:817
 get_pipe_inode fs/pipe.c:896 [inline]
 create_pipe_files+0x8a/0x7e0 fs/pipe.c:928
 __do_pipe_flags+0x46/0x1f0 fs/pipe.c:990
 do_pipe2+0x9c/0x170 fs/pipe.c:1038
 __do_sys_pipe2 fs/pipe.c:1056 [inline]
 __se_sys_pipe2 fs/pipe.c:1054 [inline]
 __x64_sys_pipe2+0x5a/0x70 fs/pipe.c:1054
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x160/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
page last free pid 5394 tgid 5394 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 __free_pages_prepare mm/page_alloc.c:1433 [inline]
 __free_frozen_pages+0xc43/0xde0 mm/page_alloc.c:2978
 __slab_free+0x263/0x2b0 mm/slub.c:5573
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0x97/0x100 mm/kasan/quarantine.c:179
 kasan_quarantine_reduce+0x148/0x160 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x22/0x80 mm/kasan/common.c:350
 kasan_slab_alloc include/linux/kasan.h:253 [inline]
 slab_post_alloc_hook mm/slub.c:4538 [inline]
 slab_alloc_node mm/slub.c:4866 [inline]
 kmem_cache_alloc_noprof+0x2bd/0x660 mm/slub.c:4873
 vm_area_dup+0x2b/0x680 mm/vma_init.c:123
 dup_mmap+0x865/0x1d30 mm/mmap.c:1787
 dup_mm kernel/fork.c:1531 [inline]
 copy_mm+0x13c/0x4a0 kernel/fork.c:1583
 copy_process+0x1883/0x3c60 kernel/fork.c:2223
 kernel_clone+0x21e/0x890 kernel/fork.c:2653
 __do_sys_clone kernel/fork.c:2794 [inline]
 __se_sys_clone kernel/fork.c:2778 [inline]
 __x64_sys_clone+0x18b/0x1e0 kernel/fork.c:2778
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x160/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
Memory state around the buggy address:
 ffff88817840ff00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88817840ff80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff888178410000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                   ^
 ffff888178410080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888178410100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================
