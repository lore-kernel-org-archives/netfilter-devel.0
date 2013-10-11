From: Hani Benhabiles <kroosec@gmail.com>
Subject: [PATCH conntrack-tools] nfct: Fix use-after-free / double-free
Date: Fri, 11 Oct 2013 21:05:34 +0100
Message-ID: <20131011200534.GD2728@doj>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ea0-f177.google.com ([209.85.215.177]:53697 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759461Ab3JKUFk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Oct 2013 16:05:40 -0400
Received: by mail-ea0-f177.google.com with SMTP id f15so2093864eak.22
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Oct 2013 13:05:38 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

helper's list and flush commands handlers shouldn't call mnl_socket_close on the
passed netlink socket as it is done in the main function after parse_params
call.

Signed-off-by: Hani Benhabiles <kroosec@gmail.com>
---
(gdb) run helper list
Starting program: /usr/local/sbin/nfct helper list
*** glibc detected *** /usr/local/sbin/nfct: double free or corruption (fasttop): 0x0000000000606010 ***
[...]
(gdb) bt
#0  0x00007ffff723e425 in __GI_raise (sig=<optimized out>)
    at ../nptl/sysdeps/unix/sysv/linux/raise.c:64
#1  0x00007ffff7241b8b in __GI_abort () at abort.c:91
#2  0x00007ffff727c39e in __libc_message (do_abort=2, 
    fmt=0x7ffff7386028 "*** glibc detected *** %s: %s: 0x%s ***\n")
    at ../sysdeps/unix/sysv/linux/libc_fatal.c:201
#3  0x00007ffff7286b96 in malloc_printerr (action=3, 
    str=0x7ffff7386218 "double free or corruption (fasttop)", ptr=<optimized out>) at malloc.c:5018
#4  0x00007ffff7bd5e82 in mnl_socket_close (nl=nl@entry=0x606010) at socket.c:249
#5  0x0000000000401a74 in main (argc=3, argv=0x7fffffffe6d8) at nfct.c:115


diff --git a/src/nfct-extensions/helper.c b/src/nfct-extensions/helper.c
index 7544ed7..bfb153f 100644
--- a/src/nfct-extensions/helper.c
+++ b/src/nfct-extensions/helper.c
@@ -144,8 +144,6 @@ static int nfct_cmd_helper_list(struct mnl_socket *nl, int argc, char *argv[])
 		return -1;
 	}
 
-	mnl_socket_close(nl);
-
 	return 0;
 }
 
@@ -397,8 +395,6 @@ nfct_cmd_helper_flush(struct mnl_socket *nl, int argc, char *argv[])
 		return -1;
 	}
 
-	mnl_socket_close(nl);
-
 	return 0;
 }
 
