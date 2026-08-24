Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E68C5439F87
	for <netfilter-devel@vger.kernel.org>; Mon, 24 Aug 2026 15:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787585156; cv=none; b=p41H4ONDHj9as+nBoEdEC/Wx4851SCrxdWk1QnL9hVtB7X0u/SNwA+r60pE7UDf9rzklGb+3AsOJY6M1I0/GEiXZPJINPuGCsfy6QUL1MYkhGGDUnso5olKuETYh/cLcL2pgQkkuvBS1cC2FILQfzm39RYhR4az8eQ1t8GkAOQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787585156; c=relaxed/simple;
	bh=bCiswidNOF+gGTlavkB3IiTLkWiB+i5gv3lHquaoBBE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rUjrAFKdhSbsPk52htRufimg07CY/zQqFxn4a2q0gIMIZcsI3IVCJScmb6YNJSpsCFXBaubm9wwO5g+0j/jFztrT2eYYU3zZmbqZWDBCq5wYh/ElqJDr39op4XXdnSP9dTbtNoi8Y7Sev0zYOR2O5Csc+6b/c2AR22ndU0SrlQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=snu.ac.kr; spf=pass smtp.mailfrom=snu.ac.kr; dkim=pass (1024-bit key) header.d=snu.ac.kr header.i=@snu.ac.kr header.b=L8clVQR9; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=snu.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=snu.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=snu.ac.kr header.i=@snu.ac.kr header.b="L8clVQR9"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-8486ac3f347so4218391b3a.1
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Aug 2026 08:25:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=snu.ac.kr; s=google; t=1787585141; x=1788189941; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=tPHYryUPRgmJ0RF2TWkWdKaAK2tLXOxhMgb+aitfoAs=;
        b=L8clVQR9R3/ReFVpJ+ccp+UapK4aUSDJSngSOdAzuUAOuRLv2EYPiICBmmbTXF2bFz
         oNRINXv0JpAD+RdJ24MJRapLHlQUvWmX/tAH8VWL9XJ1m7x0PXehxWqbG0VcJWnSHYiD
         nAo61i7MmI5YQL+ktMsgXTYAY+7bOzzhX9PPQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787585141; x=1788189941;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tPHYryUPRgmJ0RF2TWkWdKaAK2tLXOxhMgb+aitfoAs=;
        b=Bx48lDLCPCUYG01eFz8h1V0vTt+2VcyMuhqbGmw76XQ/oGMoHu/acXqVVEdhL2tFpy
         uniwFHRMECs/RJpO5jf5qPgvN9mbmHEwx1vr6pNnmUbVjxjEFj0KWELUg2RY8pnAJ9us
         XYaKanOsQUTukdR6ku0HGfvwcGkcht7sUgnEPI2X5jG4VAXx1Yo81kv5D5FdSSAS0+8J
         v8wWa5+PmWBZdqjruJVDxdT7v4lRxil8fyV+RT+NHlNvm0wcwQCydse0hhpckVN8aw7V
         fz/h+Th3GQNQvMZ4S5qakkBjHzUROWQW6XFmov3JyyS1KUdabTyTEDHrHsJqZecMkt/U
         138g==
X-Forwarded-Encrypted: i=1; AHgh+RpYP6+Cc8pBDKXuYiWDbtw/BrpY5S1cVTYMnYTe8y9hsoBSCsZ0eTBFoQkeGoeVd3wYodYZNk/D2ZAtadRjnTk=@vger.kernel.org
X-Gm-Message-State: AFuF++mhqGVzUbqOJObviyH5amJAb8lDaP0V8LDr8B2YayTIknsKPcP+
	kcmgQJACEtaEA9GlQB1X6A2OMaEvRqUX0gpAcp84FFOAXA+EVFiJa1gjnEG5kXTYWBo=
X-Gm-Gg: AR+sD13Mvk5lB90myVsoF2cSw7bEv74EJGTiUCthYCKR9w8unJpPWZh9+lpHxH0DBCa
	sNNyLf+q1C8u/6vRhkvxz9xw4XpJknScsDDdpqptHf8OtATTvDc/+CaNqXlH/srpP+Fo68EJtMI
	ySHDFd2CcswTAdbjpZl4MGvu2yFKEkaaAWTkdf/xekZv4lfG9R0YLnTh7rM+1lXpyviTyNuTRyX
	ddJ+W6cycukfHtECGTM0xV+6SvOFhts4zKo/LqQwqArjqXTajvb4DHMfzLNFKIXATcazBNdC0CZ
	riGFi8U0aw4nTe+pPtTjK4HWPwMkqKpelvEIL5Xt3AWtvvCVtx4vRbiB9HjDJfopoIEg9e+Cpct
	NF1Pqo6qj0D245QZu2TjMbjbuyzQXxt9n4U+vheuM0ASKg6YlaPAVsEbDARCNvk2qCXUVfq53jL
	87O3bJU43v5HE4GMwgdqZuNRm9bcid5rvXkJK3N99eyVCpk/6sFns+5H1SzRcIEs9IXNBbxWAmG
	menNA7D0B/Vw4vKi2YBgUkRKcVYlG8vHyQWAruAOdlW9VMswjDKvOsauipLpSJTcgEi823boWsQ
	g6Kpaj4bT9fbOZIR7Z5pvqedRWLjNVwoVYACESQVRquwQ3jq+Fc+xw==
X-Received: by 2002:a05:6a00:1256:b0:84f:df11:b78e with SMTP id d2e1a72fcca58-8523ba7ac8cmr26652b3a.2.1787585139581;
        Mon, 24 Aug 2026 08:25:39 -0700 (PDT)
Received: from leesin ([147.46.121.37])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8520ef313f1sm2122599b3a.27.2026.08.24.08.25.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 08:25:39 -0700 (PDT)
From: Jaeyoung Chung <jjy600901@snu.ac.kr>
To: coreteam@netfilter.org,
	davem@davemloft.net,
	edumazet@google.com,
	fw@strlen.de,
	kuba@kernel.org,
	netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	pabeni@redhat.com,
	pablo@netfilter.org
Cc: horms@kernel.org,
	linux-kernel@vger.kernel.org,
	phil@nwl.cc,
	eulgyukim@snu.ac.kr,
	jjy600901@snu.ac.kr
Subject: [BUG] general protection fault in __instance_destroy
Date: Tue, 25 Aug 2026 00:25:25 +0900
Message-ID: <20260824152532.2261892-1-jjy600901@snu.ac.kr>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

We found a "general protection fault in __instance_destroy" on Linux v7.2.
The issue was found by our own race fuzzer. We have not analyzed the root cause,
so we do not have a proposed fix to offer.

To reproduce the race reliably, we applied the delay patch below to the
kernel and ran the C reproducer as root inside an x86_64 QEMU guest. The
crash log we observed, the delay patch and the reproducer are all included
below.

The following kernel config options are required to reproduce the issue:
    CONFIG_NETFILTER=y
    CONFIG_NETFILTER_NETLINK=y
    CONFIG_NETFILTER_NETLINK_LOG=y
    CONFIG_NET=y
    CONFIG_KASAN=y

We hope this report is useful. Please let us know if any further
information would help.

Reported-by: Eulgyu Kim <eulgyukim@snu.ac.kr>
Reported-by: Jaeyoung Chung <jjy600901@snu.ac.kr>

Kernel delay patch:
==================================================================
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 6c7fa2ed34f5..04d2250f992a 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -37,6 +37,8 @@
 
 #include <linux/atomic.h>
 #include <linux/refcount.h>
+#include <linux/delay.h>
+#include <linux/sched.h>
 
 
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
@@ -982,6 +984,9 @@ static int nfulnl_recv_config(struct sk_buff *skb, const struct nfnl_info *info,
 				goto out;
 			}
 
+			if (strncmp(current->comm, "syzrepro1", 10) == 0) {
+				mdelay(100);
+			}
 			instance_destroy(log, inst);
 			goto out_put;
 		default:
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 5202fe0b0867..0ba2ab6c4547 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -25,6 +25,7 @@
 #include <linux/kernel.h>
 #include <linux/filter.h>
 #include <linux/init.h>
+#include <linux/delay.h>
 #include <linux/signal.h>
 #include <linux/sched.h>
 #include <linux/errno.h>
@@ -724,6 +725,9 @@ static int netlink_release(struct socket *sock)
 		return 0;
 
 	netlink_remove(sk);
+	if (strncmp(current->comm, "syzrepro0", 10) == 0) {
+		mdelay(60);
+	}
 	sock_orphan(sk);
 	nlk = nlk_sk(sk);
 
==================================================================

C reproducer:
==================================================================
#define _GNU_SOURCE
#include <errno.h>
#include <pthread.h>
#include <sched.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/prctl.h>
#include <sys/socket.h>
#include <unistd.h>
#include <linux/netlink.h>

#define SYSCHK(x) ({ long __r = (long)(x); if (__r == -1L) { perror(#x); exit(1); } __r; })

#define NETLINK_NETFILTER 12
#define NFNL_SUBSYS_ULOG 4
#define NFULNL_MSG_CONFIG 1
#define NFULA_CFG_CMD 1
#define BIND 1
#define UNBIND 2

/* Two threads take the same portid in turn, overlapping BIND/UNBIND on the
 * same group 0 instance
 */
#define PORTID 0x00524143u
#define SPIN 4000000

static volatile unsigned g_go, g_done;
static volatile int g_stop;

static int build_cfg(char *buf, unsigned char cmd)
{
	struct nlmsghdr *nlh = (struct nlmsghdr *)buf;
	unsigned short nla[2] = { 5, NFULA_CFG_CMD };
	unsigned char *p = (unsigned char *)buf + NLMSG_HDRLEN;

	memset(buf, 0, 64);
	nlh->nlmsg_len = NLMSG_HDRLEN + 12;
	nlh->nlmsg_type = (NFNL_SUBSYS_ULOG << 8) | NFULNL_MSG_CONFIG;
	nlh->nlmsg_flags = NLM_F_REQUEST;
	nlh->nlmsg_seq = 1;
	memcpy(p + 4, nla, 4);
	p[8] = cmd;
	return NLMSG_HDRLEN + 12;
}

static int nl_send(int fd, const char *buf, int len)
{
	struct sockaddr_nl dst = { .nl_family = AF_NETLINK };
	struct iovec iov = { (void *)buf, len };
	struct msghdr mh = { .msg_name = &dst, .msg_namelen = sizeof(dst),
			     .msg_iov = &iov, .msg_iovlen = 1 };

	return sendmsg(fd, &mh, 0);
}

static int nl_open_bind(void)
{
	struct sockaddr_nl a = { .nl_family = AF_NETLINK, .nl_pid = PORTID };
	int fd = SYSCHK(socket(AF_NETLINK, SOCK_RAW, NETLINK_NETFILTER));
	long spin;

	for (spin = 0; spin < SPIN && !g_stop; spin++) {
		if (bind(fd, (struct sockaddr *)&a, sizeof(a)) == 0)
			return fd;
		if (errno != EADDRINUSE)
			break;
		sched_yield();
	}
	close(fd);
	return -1;
}

static void *binder(void *u)
{
	char buf[64];
	int len, i;

	(void)u;
	prctl(PR_SET_NAME, "syzrepro0", 0, 0, 0);
	len = build_cfg(buf, BIND);
	for (i = 1; i <= 120 && !g_stop; i++) {
		long spin;
		int fd = nl_open_bind();

		if (fd < 0 || nl_send(fd, buf, len) < 0) {
			if (fd >= 0)
				close(fd);
			break;
		}
		__sync_synchronize();
		g_go = i;
		__sync_synchronize();
		close(fd);
		for (spin = 0; g_done < (unsigned)i && spin < SPIN; spin++)
			sched_yield();
	}
	g_stop = 1;
	return NULL;
}

static void *unbinder(void *u)
{
	char buf[64];
	unsigned last = 0;
	int len;

	(void)u;
	prctl(PR_SET_NAME, "syzrepro1", 0, 0, 0);
	len = build_cfg(buf, UNBIND);
	while (!g_stop) {
		unsigned cur;
		int fd;

		for (;;) {
			cur = g_go;
			if (cur != last)
				break;
			if (g_stop)
				return NULL;
			sched_yield();
		}
		last = cur;
		fd = nl_open_bind();
		if (fd >= 0) {
			nl_send(fd, buf, len);
			close(fd);
		}
		__sync_synchronize();
		g_done = cur;
		__sync_synchronize();
	}
	return NULL;
}

int main(void)
{
	pthread_t t0, t1;

	pthread_create(&t1, NULL, unbinder, NULL);
	pthread_create(&t0, NULL, binder, NULL);
	pthread_join(t0, NULL);
	g_stop = 1;
	pthread_join(t1, NULL);
	return 0;
}
==================================================================

Crash log:
==================================================================
Oops: general protection fault, probably for non-canonical address 0xfbd59c0000000024: 0000 [#1] SMP KASAN PTI
KASAN: maybe wild-memory-access in range [0xdead000000000120-0xdead000000000127]
CPU: 0 UID: 0 PID: 401 Comm: syzrepro1 Not tainted 7.2.0-dirty #2 PREEMPT 
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
RIP: 0010:__hlist_del include/linux/list.h:1029 [inline]
RIP: 0010:hlist_del_rcu include/linux/rculist.h:599 [inline]
RIP: 0010:__instance_destroy+0x5a/0x190 net/netfilter/nfnetlink_log.c:234
Code: f2 fc 4c 8b 3b 4c 8d 73 08 4c 89 f5 48 c1 ed 03 42 80 7c 2d 00 00 74 08 4c 89 f7 e8 60 b5 f2 fc 4d 8b 26 4c 89 e0 48 c1 e8 03 <42> 80 3c 28 00 74 08 4c 89 e7 e8 37 b6 f2 fc 4d 89 3c 24 4d 85 ff
RSP: 0018:ffff88811118f350 EFLAGS: 00010a06
RAX: 1bd5a00000000024 RBX: ffff888107955000 RCX: 0000000000000001
RDX: 0000000000000001 RSI: 0000000000000004 RDI: ffff888107955000
RBP: 1ffff11020f2aa01 R08: ffff88811118f36f R09: 1ffff11022231e6d
R10: dffffc0000000000 R11: ffffed1022231e6e R12: dead000000000122
R13: dffffc0000000000 R14: ffff888107955008 R15: 0000000000000000
FS:  00007b5300d0a6c0(0000) GS:ffff88817d75f000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007b5300dfc010 CR3: 000000011127e000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 instance_destroy net/netfilter/nfnetlink_log.c:256 [inline]
 nfulnl_recv_config+0x60e/0xf70 net/netfilter/nfnetlink_log.c:990
 nfnetlink_rcv_msg+0x5d5/0x760 net/netfilter/nfnetlink.c:300
 netlink_rcv_skb+0x168/0x310 net/netlink/af_netlink.c:2560
 nfnetlink_rcv+0x370/0x2140 net/netfilter/nfnetlink.c:667
 netlink_unicast_kernel net/netlink/af_netlink.c:1323 [inline]
 netlink_unicast+0x652/0x880 net/netlink/af_netlink.c:1349
 netlink_sendmsg+0x5a1/0x870 net/netlink/af_netlink.c:1904
 sock_sendmsg_nosec net/socket.c:775 [inline]
 __sock_sendmsg+0x18f/0x1a0 net/socket.c:790
 ____sys_sendmsg+0x468/0x660 net/socket.c:2684
 ___sys_sendmsg+0x15e/0x1a0 net/socket.c:2738
 __sys_sendmsg net/socket.c:2770 [inline]
 __do_sys_sendmsg net/socket.c:2775 [inline]
 __se_sys_sendmsg net/socket.c:2773 [inline]
 __x64_sys_sendmsg+0x11e/0x170 net/socket.c:2773
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xf7/0x370 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x76/0x7e
RIP: 0033:0x7b5300e18c4d
Code: 28 89 54 24 1c 48 89 74 24 10 89 7c 24 08 e8 ea ab f7 ff 8b 54 24 1c 48 8b 74 24 10 41 89 c0 8b 7c 24 08 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 33 44 89 c7 48 89 44 24 08 e8 3e ac f7 ff 48
RSP: 002b:00007b5300d09dc0 EFLAGS: 00000293 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000028 RCX: 00007b5300e18c4d
RDX: 0000000000000000 RSI: 00007b5300d09e10 RDI: 0000000000000003
RBP: 0000000000000003 R08: 0000000000000000 R09: 00007ffd57a75617
R10: 0000000000000000 R11: 0000000000000293 R12: 000000000000001c
R13: 00007b5300d09e60 R14: 00007ffd57a75520 R15: 00007b530050a000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
==================================================================


