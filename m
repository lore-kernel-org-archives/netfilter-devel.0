From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Kernel crash with repeated NF invocation
Date: Thu, 10 Feb 2011 00:52:33 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1102100045550.29832@obet.zrqbmnf.qr>
References: <alpine.LNX.2.01.1102031605330.21536@obet.zrqbmnf.qr> <20110203.131004.226772735.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:51918 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754944Ab1BIXwf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Feb 2011 18:52:35 -0500
In-Reply-To: <20110203.131004.226772735.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2011-02-03 22:10, David Miller wrote:

>>I remember there being a kernel config option
>>(CONFIG_DEBUG_STACKOVERFLOW) that would emit messages similar to
>>"process foobar (12345) used greatest stack depth: 2042" -- would
>>that also work for softirqs?
>
>The kernel stack tracer is your best bet right now, it's easy to
>enable, it's something like just writing "1" to the /sys filesystem
>file that controls it.
>
>config STACK_TRACER
>	  This special tracer records the maximum stack footprint of the
>	  kernel and displays it in /sys/kernel/debug/tracing/stack_trace.
>
>	  This tracer works by hooking into every function call that the
>	  kernel executes, and keeping a maximum stack depth value and
>	  stack-trace saved.  If this is configured with DYNAMIC_FTRACE
>	  then it will not have any overhead while the stack tracer
>	  is disabled.

Compiled with DYNAMIC_FTRACE=y, and enabled (writing 1
to /sys/kernel/debug/tracing/tracing_enabled). In the stack_trace
file I can find some lines..

        Depth    Size   Location    (56 entries)
        -----    ----   --------
  0)     5496      48   stack_trace_call+0xfa/0x1aa
  1)     5448     112   ftrace_call+0x5/0x2b
  2)     5336      64   zone_watermark_ok+0x29/0xbf
  3)     5272     288   get_page_from_freelist+0x1b7/0x6ab
  4)     4984     240   __alloc_pages_nodemask+0x11b/0x70e
  5)     4744      48   kmem_getpages+0x65/0x10e
  6)     4696     128   cache_grow+0xc4/0x285
  7)     4568      96   ____cache_alloc+0x21e/0x26d
  8)     4472      64   kmem_cache_alloc+0x5e/0xfb
  9)     4408      16   mempool_alloc_slab+0x15/0x17
 10)     4392     144   mempool_alloc+0x52/0x104
 11)     4248      32   scsi_sg_alloc+0x2d/0x2f
etc.
 
Does the file cover all CPUs and past function executions, is there a
timeout on these entries? At other times, running cat on that file
merely yields 2 entries, being the stack tracing itself.
Will this list dumped to the console in case of a
bug/oops/Illegal_IP?


thanks,
Jan
