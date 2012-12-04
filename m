From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] build: resolve link failure for ip6t_NETMAP
Date: Tue, 4 Dec 2012 14:42:16 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1212041440210.28423@nerf07.vanv.qr>
References: <1354472208-25759-1-git-send-email-jengelh@inai.de> <20121203131209.GA32300@1984> <alpine.LNX.2.01.1212031655050.15887@nerf07.vanv.qr> <20121204121647.GA30262@1984>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:50992 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751839Ab2LDNmT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Dec 2012 08:42:19 -0500
In-Reply-To: <20121204121647.GA30262@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2012-12-04 13:16, Pablo Neira Ayuso wrote:

>On Mon, Dec 03, 2012 at 04:58:11PM +0100, Jan Engelhardt wrote:
>> On Monday 2012-12-03 14:12, Pablo Neira Ayuso wrote:
>> 
>> >On Sun, Dec 02, 2012 at 07:16:48PM +0100, Jan Engelhardt wrote:
>> >> Link stage of libip6t_NETMAP failed since recently.
>> >> 
>> >>   CCLD     libip6t_NETMAP.so
>> >> /usr/lib64/gcc/x86_64-suse-linux/4.7/../../../../x86_64-suse-linux/bin/ld:
>> >> cannot find -lip6tc
>> >
>> >Is this problem opensuse specific? Need some diagnosing information on
>> >why that's happening.
>> 
>> This happens whenever you don't have /usr/lib(64)/libip6tc.so.
>> 
>> In openSUSE, iptables is split into the packages iptables, libiptc0, 
>> libiptc-devel, libxtables9 and libxtables-devel, and libip6tc.so is a 
>> -devel thing that is generally not installed on user's machines. (Hence 
>> I spot this.) I think this should be similar in Debian.
>> 
>> Also, note that iptables itself is not installed while building iptables 
>> itself (for obvious reasons) in most distribution build systems.
>
>By this explanation, then I don't see why we need that -lip6tc in the
>makefile.

Without -lip6tc (the current state of the 'next' branch), it would yield 
an error:

libip6t_NETMAP.oo: In function `NETMAP_print':
/home/jengelh/code/iptables/extensions/libip6t_NETMAP.c:64: undefined 
reference to `ipv6_prefix_length'
