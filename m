From: Eric Leblond <eric@regit.org>
Subject: [nft PATCH 7/7] cli: fix heap buffer overflow
Date: Tue, 11 Jul 2017 00:32:55 +0200
Message-ID: <20170710223255.29885-8-eric@regit.org>
References: <20170710223255.29885-1-eric@regit.org>
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:41168 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754936AbdGJWdZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Jul 2017 18:33:25 -0400
In-Reply-To: <20170710223255.29885-1-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch fixes an invalid read when an empty command was sent.

Found via nft running ASAN and entering an empty command:

nft>
=================================================================
==19540==ERROR: AddressSanitizer: heap-buffer-overflow on address 0x602000008c6f at pc 0x55e3b561704d bp 0x7fffe9a33ac0 sp 0x7fffe9a33ab8
READ of size 1 at 0x602000008c6f thread T0
    #0 0x55e3b561704c in cli_append_multiline /home/eric/git/netfilter/nftables/src/cli.c:65
    #1 0x55e3b561725b in cli_complete /home/eric/git/netfilter/nftables/src/cli.c:109
    #2 0x7f6e0c2ccac2 in rl_callback_read_char (/lib/x86_64-linux-gnu/libreadline.so.7+0x2fac2)
    #3 0x55e3b5617ba6 in cli_init /home/eric/git/netfilter/nftables/src/cli.c:199
    #4 0x55e3b5573b75 in main /home/eric/git/netfilter/nftables/src/main.c:381
    #5 0x7f6e0bc9b2b0 in __libc_start_main (/lib/x86_64-linux-gnu/libc.so.6+0x202b0)
    #6 0x55e3b55725a9 in _start (/usr/local/sbin/nft+0x445a9)

Signed-off-by: Eric Leblond <eric@regit.org>
---
 src/cli.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/src/cli.c b/src/cli.c
index 7cd2f45..9876d06 100644
--- a/src/cli.c
+++ b/src/cli.c
@@ -58,6 +58,10 @@ static char *cli_append_multiline(char *line)
 	}
 
 	len = strlen(line);
+
+	if (len == 0)
+		return NULL;
+
 	if (line[len - 1] == '\\') {
 		line[len - 1] = '\0';
 		len--;
-- 
2.13.2

