From: "Gutholm, James" <gutholmj@evergreen.edu>
Subject: Conntrackd Segmentation fault due to nfexp_get_attr returning NULL
Date: Wed, 3 Oct 2012 18:52:08 +0000
Message-ID: <3E070A3A9446DB43B8A316366DBEABBE1F26A591@palm.evergreen.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from abalone.evergreen.edu ([192.211.16.10]:64483 "EHLO
	abalone.evergreen.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870Ab2JCTBl convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Oct 2012 15:01:41 -0400
Content-Language: en-US
Content-ID: <CC9CDA26E87F9C4DB5386915ACC30F15@evergreen.edu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Under heavy load conntrackd is crashing. Running under gdb I was able to determine that the crashes are caused by an unchecked null pointer returned by nfexp_get_attr in both exp_filter_find() in filter.c and exp_build_str() in build.c

This only happens when expectation sync is being used. Setting "ExpectationSync Off" in conntrackd.conf stops the crashes.

I coded in a couple of checks on the pointer returned which at least stop the errors. I've included the changes as diffs and also the gdb output in case it is helpful. If there's something else I can provide, I'm happy to help but this might be pushing the limit of my expertise.

James

This is on RHEL6 (2.6.32-300.32.2.el6uek.x86_64) with conntrack-tool built from source.

Conntrack-tools versions
conntrack-tools-1.2.2
libnetfilter_conntrack-1.0.1
libnetfilter_cttimeout-1.0.0
libnfnetlink-1.0.0

Diffs of the NULL pointer check code I added.
$ diff conntrack-tools-1.2.2/src/build.c conntrack-tools-1.2.2-mod/src/build.c
19a20,22
> #include <stdio.h>
> #include <stdlib.h>
> #include <errno.h>
23a27
> #include "log.h"
287c291,296
< 	addattr(n, b, data, strlen(data)+1);
---
> 	if (data != NULL) {
> 		addattr(n, b, data, strlen(data)+1);
> 	} else {
> 		dlog(LOG_ERR, "nfexp_get_attr returned NULL pointer in exp_build_str in build.c: %s", 
> 			strerror(errno));
> 	}


$ diff conntrack-tools-1.2.2/src/filter.c conntrack-tools-1.2.2-mod/src/filter.c
477,479c477,479
< 
< 		/* we allow partial matching to support things like sip-PORT. */
< 		if (strncasecmp(item->helper_name, name,
---
> 		if (name != NULL) {
> 			/* we allow partial matching to support things like sip-PORT. */
> 			if (strncasecmp(item->helper_name, name,
481c481,485
< 			return 1;
---
> 				return 1;
> 			}
> 		} else {
> 			dlog(LOG_ERR, "nfexp_get_attr returned NULL pointer in exp_filter_find in filter.c: %s",
> 				strerror(errno));

(gdb) run
Starting program: /usr/local/sbin/conntrackd -C /etc/conntrackd/conntrackd.conf

Program received signal SIGSEGV, Segmentation fault.
__strlen_sse2 () at ../sysdeps/x86_64/strlen.S:32
32		movdqu	(%rdi), %xmm1
(gdb) backtrace
#0  __strlen_sse2 () at ../sysdeps/x86_64/strlen.S:32
#1  0x000000000040eec7 in exp_build_str (exp=0x6f0140, n=0x637020) at build.c:287
#2  exp2msg (exp=0x6f0140, n=0x637020) at build.c:359
#3  0x000000000040b13e in cache_exp_build_msg (obj=0x1b93810, type=3) at cache-exp.c:283
#4  0x000000000040d0e3 in tx_queue_xmit (n=0x1b93848, data=<value optimized out>) at sync-ftfw.c:521
#5  0x00000000004059cd in queue_iterate (b=0x658cc0, data=0x0, iterate=0x40d0b0 <tx_queue_xmit>) at queue.c:179
#6  0x000000000040cfcb in ftfw_xmit () at sync-ftfw.c:545
#7  0x000000000040c762 in run_sync (readfds=0x7fffffffd330) at sync-mode.c:439
#8  0x0000000000404601 in run_events (next_alarm=<value optimized out>) at run.c:710
#9  0x00000000004042a1 in do_run (run_step=0x4044b0 <run_events>) at run.c:763
#10 0x000000000040430a in run () at run.c:772
#11 0x00000000004039dd in main (argc=3, argv=0x7fffffffe6f8) at main.c:409
(gdb) frame 1
#1  0x000000000040eec7 in exp_build_str (exp=0x6f0140, n=0x637020) at build.c:287
287		addattr(n, b, data, strlen(data)+1);
(gdb) info frame
Stack level 1, frame at 0x7fffffffd240:
 rip = 0x40eec7 in exp_build_str (build.c:287); saved rip 0x40b13e
 inlined into frame 2, caller of frame at 0x7fffffffd200
 source language c.
 Arglist at unknown address.
 Locals at unknown address, Previous frame's sp is 0x7fffffffd200
 Saved registers:
  rip at 0x7fffffffd1f8
(gdb) info locals
data = 0x0
(gdb) 



(gdb) run
Starting program: /usr/local/sbin/conntrackd -C /etc/conntrackd/conntrackd.conf

Program received signal SIGSEGV, Segmentation fault.
__strncasecmp_l_ssse3 () at ../sysdeps/x86_64/strcmp.S:214
214		movlpd	(%rsi), %xmm2
(gdb) backtrace
#0  __strncasecmp_l_ssse3 () at ../sysdeps/x86_64/strcmp.S:214
#1  0x0000000000408772 in exp_filter_find (f=0x654350, exp=0x808f10) at filter.c:479
#2  0x0000000000405044 in exp_event_handler (nlh=0x7fffffffb2d0, type=NFCT_T_NEW, exp=0x808f10, data=<value optimized out>)
    at run.c:363
#3  0x00007ffff7bcc0be in __callback (nlh=0x7fffffffb2d0, nfa=<value optimized out>, data=0x15fb800) at callback.c:75
#4  0x00007ffff79c3288 in nfnl_step (h=<value optimized out>, nlh=0x7fffffffb2d0) at libnfnetlink.c:1345
#5  0x00007ffff79c33ff in nfnl_process (h=0x15fb410, buf=<value optimized out>, len=192) at libnfnetlink.c:1390
#6  0x00007ffff79c4436 in nfnl_catch (h=0x15fb410) at libnfnetlink.c:1544
#7  0x000000000040468c in run_events (next_alarm=<value optimized out>) at run.c:646
#8  0x00000000004042a1 in do_run (run_step=0x4044b0 <run_events>) at run.c:763
#9  0x000000000040430a in run () at run.c:772
#10 0x00000000004039dd in main (argc=3, argv=0x7fffffffe6d8) at main.c:409
(gdb) frame 1
#1  0x0000000000408772 in exp_filter_find (f=0x654350, exp=0x808f10) at filter.c:479
479			if (strncasecmp(item->helper_name, name,
(gdb) info frame
Stack level 1, frame at 0x7fffffffb190:
 rip = 0x408772 in exp_filter_find (filter.c:479); saved rip 0x405044
 called by frame at 0x7fffffffb1c0, caller of frame at 0x7fffffffb160
 source language c.
 Arglist at 0x7fffffffb158, args: f=0x654350, exp=0x808f10
 Locals at 0x7fffffffb158, Previous frame's sp is 0x7fffffffb190
 Saved registers:
  rbx at 0x7fffffffb160, rbp at 0x7fffffffb168, r12 at 0x7fffffffb170, r13 at 0x7fffffffb178, r14 at 0x7fffffffb180,
  rip at 0x7fffffffb188
(gdb) info locals
name = 0x0
item = 0x6544b0
(gdb) 