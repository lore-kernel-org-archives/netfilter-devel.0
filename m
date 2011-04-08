From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Performance issue due to constant "modprobes"
Date: Fri, 8 Apr 2011 02:18:04 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1104080212310.8883@obet.zrqbmnf.qr>
References: <4D9E45C2.7030805@wildgooses.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Ed W <lists@wildgooses.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:56478 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753051Ab1DHASG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Apr 2011 20:18:06 -0400
In-Reply-To: <4D9E45C2.7030805@wildgooses.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2011-04-08 01:16, Ed W wrote:

>Hi, I am using a relatively low powered (embedded) platform and I have a
>significant performance problem due to slow "modprobe" performance.
>
>I have my kernel compiled without modules.  My modprobe takes a little
>under 1ms to execute.  "iptables" appears to try and modprobe some 21
>match/target modules.

This is your kernel calling modprobe through ____call_usermodehelper in 
response to inquiries about modules' ABIs. This will also happen if you 
removed modprobing from iptables - the latter of which is only used to 
load ip_tables.ko itself, since that is the only thing that currently 
is not fully autoloadable by the kernel.

>I have dug through the code a bit and the first thing I notice is that
>there is no --modprobe option actually parsed for, and the undocumented
>"-M" option doesn't appear to pass through to xtables.c? (I thought
>about simply lying about the modprobe binary name)

ip6tables.c:do_command6, near case 'M'.

>My next thought was to collect all the modprobes and run them with a
>single execution (modprobe -a). However, it's not clear to me whether
>it's important that the modprobe occurs in the middle of xtables.c /
>compatible_revision() ?

To determine which ABI/revision is available on the kernel side, and 
based upon the result, display what options the extensions can use when 
you invoke -h.

>The final thought is whether it's possible to notice that a module is
>already loaded and skip the modprobe call altogether? (/proc/modules is
>not enough because the module could be built into the kernel)

If ip_tables.ko is already loaded, iptc_init will not fail (per the 
command above xtables_load_ko(xtables_modprobe_program, false), and 
thus, modprobe will not be called - at least not by iptables.
