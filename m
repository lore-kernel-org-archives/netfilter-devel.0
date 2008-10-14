From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptable/netfilter mismatch
Date: Tue, 14 Oct 2008 14:12:01 +0200
Message-ID: <48F48C91.80302@trash.net>
References: <A612847CFE53224C91B23E3A5B48BAC73889B08E3B@xmail3.se.axis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "'netfilter-devel@vger.kernel.org'" <netfilter-devel@vger.kernel.org>
To: Jesper Bengtsson <jesper.bengtsson@axis.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34329 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753932AbYJNMMG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Oct 2008 08:12:06 -0400
In-Reply-To: <A612847CFE53224C91B23E3A5B48BAC73889B08E3B@xmail3.se.axis.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jesper Bengtsson wrote:
> Hi,
> 
> When running iptables on a CRIS cpu (ETRAX FS/100LX) I have a problem with adding error targets.
> I've debugged this problem and I found an iptables/netfilter mismatch.
> 
> The structure ipt_error_target is defined in two places:
> in the kernel, include/linux/netfilter_ipv4/ip_tables.h
> struct ipt_error_target
> {
>         struct ipt_entry_target target;
>         char errorname[IPT_FUNCTION_MAXNAMELEN];
> };
> 
> and in iptables, libiptc/libiptc.c
> struct ipt_error_target
> {
>         STRUCT_ENTRY_TARGET t;
>         char error[TABLE_MAXNAMELEN];
> };
> 
> Before a patch, claiming to fix things for CRIS
> (http://lists.netfilter.org/pipermail/netfilter-devel/2007-January/026659.html),
> was applied the two structs above had the same size. After the patch the two structs differ by two
> bytes in size and when iptables tries to commit an error target to netfilter, netfilter will discard
> it since the target has incorrect size. I believe that this will only occur on architectures that don't use structure alignment, e.g. CRIS.
> 
> When modifying the struct in libiptc/libiptc.c like this:
> 
> struct ipt_error_target
> {
>         STRUCT_ENTRY_TARGET t;
>         char error[FUNCTION_MAXNAMELEN];
> };
> 
> I can add error targets on my CRIS system.
> 
> I'm a iptables/netfilter newbie and I really can't say for sure if FUNCTION_MAXNAMELEN or TABLE_MAXNAMELEN is the correct length to use in the ipt_error_target structure.
> 
> Can anyone shed some light over the ipt_error_target structure?

The versions I'm looking at uses TABLE_MAXNAMELEN in userspace,
which is 32, and FUNCTION_MAXNAMELEN in the kernel, which is 30.
So yeah, this is still broken. "errorname" is not used within
the kernel at all and the limit of 30 doesn't make any sense,
so the correct fix appears to be to also use 32 within the kernel.

This shouldn't break anything since we align to u64 and the
architectures like CRIS where this causes less than 4 byte alignment
are currently broken, for all others it doesn't have any effect.

Could you send a patch against the latest -git tree please?
