From: Yanchuan Nian <ycnian@gmail.com>
Subject: [nftables PATCH] Fix segmentation fault in batch operation
Date: Fri,  4 Jul 2014 19:59:10 +0800
Message-ID: <1404475150-18224-1-git-send-email-ycnian@gmail.com>
Cc: Yanchuan Nian <ycnian@gmail.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43115 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbaGDL4J (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Jul 2014 07:56:09 -0400
Received: by mail-pa0-f46.google.com with SMTP id eu11so1904313pac.5
        for <netfilter-devel@vger.kernel.org>; Fri, 04 Jul 2014 04:56:09 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nftables supports batch operation in order to run many commands in one time.
In batch operation, a large buffer called "batch" is allocated through
xmalloc() and netlink messages are attached to the batch. If batch overflows,
a new batch will be allocated and the last message will be moved to the new one.
Since xmalloc() doesn't clear the buffer, data in batch is uncertain, this will
cause segmentation fault. Let's take creating a new rule for instance.

root@localhost tmp]# nft add rule ip filter input ip saddr 192.168.1.1 drop
In the above command, three netlink messages are generated, they are 
NFNL_MSG_BATCH_BEGIN, NFT_MSG_NEWRULE and NFNL_MSG_BATCH_END, of course
they can be added in one batch. Then mnl_batch_talk() is called to send
messages to kernel. Since batch is not empty, mnl_batch_page_add() is
called in mnl_batch_talk(). Attention, last_nlh points to the end of message
NFNL_MSG_BATCH_END at the time, so data in last_nlh is invalid,
last_nlh->nlmsg_len is invalid. We cannot move those data to the new batch.
At the same time, data in the new batch is also uncertain for it is allocated
through xmalloc(). This will cause uncertain result, maybe the overflow flag
in the new batch will be set to true.

The bug isn't easy to reproduce for batch is too large. It is usuarly created
through mmap(2) directly by glibc, and contents are initialized to zero
automatically. We can reproduce it in such a way:

#!/bin/sh
# filename test.sh
nft add table ip filter
nft add chain ip filter input {type filter hook input priority 0 \;}
for i in $(seq 1000)
do
        nft add rule ip filter input tcp dport $i counter
done

Run the script above, and then go to nft interactive mode.
nft> list table ip filter
      (.... results ....)
nft> add rule ip filter input tcp dport 1001 counter
Segmentation fault (core dumped)

coredump is as follows:
(gdb) bt
#0  0x4cca92fe in __memcpy_ssse3 () from /lib/libc.so.6
#1  0x08a3dbb8 in ?? ()
#2  0x08058f48 in netlink_batch_send (err_list=err_list@entry=0xbff96e0c) at src/netlink.c:1411
#3  0x0804c601 in nft_netlink (msgs=<optimized out>, state=<optimized out>) at src/main.c:190
#4  nft_run (scanner=0x8a3c198, state=0xbff96f3c, msgs=msgs@entry=0xbff96e78) at src/main.c:227
#5  0x0804ca57 in cli_complete (line=<optimized out>) at src/cli.c:121
#6  0x4edc6e62 in rl_callback_read_char () from /lib/libreadline.so.6
#7  0x0804c8bd in cli_init (_state=_state@entry=0xbff96f3c) at src/cli.c:180
#8  0x0804c1fa in main (argc=2, argv=0xbff97444) at src/main.c:327

We first list the rules in filter for two purposes.
(1) Expand the heap. We have added 1000 rules. Since the list command needs
lots of memory, the heap will be expanded. If there is a continuous memory
chunk greater than 33 * pagesize, batch will be allocated in heap.
(2) Randomize the contents of heap, so contents in batch will not be all zeros.

After that, we add a new rule, nft crashed. This is because the new batch
overflowed by mistake. mnl_nlmsg_batch_reset() tries to copy the last message
to the beginning of batch, but the length of message is uncertain. I print the
value of the length, it's 1288824880. memcpy() crashed.

I tested it in Fedora 20 on a x86 machine, with glibc 2.18.

Signed-off-by: Yanchuan Nian <ycnian@gmail.com>
---
 src/mnl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/mnl.c b/src/mnl.c
index a816106..c934e57 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -89,7 +89,7 @@ static struct mnl_nlmsg_batch *mnl_batch_alloc(void)
 	static char *buf;
 
 	/* libmnl needs higher buffer to handle batch overflows */
-	buf = xmalloc(BATCH_PAGE_SIZE + getpagesize());
+	buf = xzalloc(BATCH_PAGE_SIZE + getpagesize());
 	return mnl_nlmsg_batch_start(buf, BATCH_PAGE_SIZE);
 }
 
-- 
1.9.3

