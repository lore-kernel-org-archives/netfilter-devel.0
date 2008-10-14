From: Jesper Bengtsson <jesper.bengtsson@axis.com>
Subject: iptable/netfilter mismatch
Date: Tue, 14 Oct 2008 09:40:49 +0200
Message-ID: <A612847CFE53224C91B23E3A5B48BAC73889B08E3B@xmail3.se.axis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "'netfilter-devel@vger.kernel.org'" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from krynn.se.axis.com ([193.13.178.10]:33236 "EHLO
	krynn.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbYJNH7E convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Oct 2008 03:59:04 -0400
Received: from xmail3.se.axis.com (xmail3.se.axis.com [10.0.5.75])
	by krynn.se.axis.com (8.13.4/8.13.4/Debian-3sarge3) with ESMTP id m9E7endb031558
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Oct 2008 09:40:49 +0200
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

When running iptables on a CRIS cpu (ETRAX FS/100LX) I have a problem with adding error targets.
I've debugged this problem and I found an iptables/netfilter mismatch.

The structure ipt_error_target is defined in two places:
in the kernel, include/linux/netfilter_ipv4/ip_tables.h
struct ipt_error_target
{
        struct ipt_entry_target target;
        char errorname[IPT_FUNCTION_MAXNAMELEN];
};

and in iptables, libiptc/libiptc.c
struct ipt_error_target
{
        STRUCT_ENTRY_TARGET t;
        char error[TABLE_MAXNAMELEN];
};

Before a patch, claiming to fix things for CRIS
(http://lists.netfilter.org/pipermail/netfilter-devel/2007-January/026659.html),
was applied the two structs above had the same size. After the patch the two structs differ by two
bytes in size and when iptables tries to commit an error target to netfilter, netfilter will discard
it since the target has incorrect size. I believe that this will only occur on architectures that don't use structure alignment, e.g. CRIS.

When modifying the struct in libiptc/libiptc.c like this:

struct ipt_error_target
{
        STRUCT_ENTRY_TARGET t;
        char error[FUNCTION_MAXNAMELEN];
};

I can add error targets on my CRIS system.

I'm a iptables/netfilter newbie and I really can't say for sure if FUNCTION_MAXNAMELEN or TABLE_MAXNAMELEN is the correct length to use in the ipt_error_target structure.

Can anyone shed some light over the ipt_error_target structure?

Thanks,
Jesper
