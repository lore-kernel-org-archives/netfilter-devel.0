From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: 32 vs 64 bits
Date: Thu, 26 Mar 2009 15:32:01 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0903261528050.29211@fbirervta.pbzchgretzou.qr>
References: <49CB9079.9070309@dev.6wind.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Nicolas Dichtel <nicolas.dichtel@dev.6wind.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:33127 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756528AbZCZOcE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Mar 2009 10:32:04 -0400
In-Reply-To: <49CB9079.9070309@dev.6wind.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2009-03-26 15:26, Nicolas Dichtel wrote:

> Hi all,
>
> I'm trying to understand why the following commit has been done:
>
> http://git.netfilter.org/cgi-bin/gitweb.cgi?p=iptables.git;a=commitdiff;h=7d5cc229064b0e718046b9ecaebad3426dfff15f
>
>  Removes KERNEL_64_USERSPACE_32
>
>  Yasuyuki KOZAKAI [Sat, 30 Jun 2007 10:47:57 +0000 (10:47 +0000)]
>
>  The recent kernel has compat layer for iptables. It doesn't have
>  compat layer for libipq and ip6tables, but ip6tables with
>  KERNEL_64_USERSPACE_32 is still broken. We should fix kernel instead of
>  fixing them if and when we want use their 32bit binary with 64bit kernel.
>
> Where is the compat layer?

For example, net/netfilter/xt_MARK.c there are some regions with
"#ifdef CONFIG_COMPAT". People used to use the C type "long", which
has different sizes across different platforms, leading to a mess
and evidently the compat conversion functions. Many of the Xtables
modules do not suffer from this and hence there is not that much
compat code left.

> If I look in a recent kernel, it seems that
> ip_queue.h still uses long and is broken.
> [linux/netfilter_ipv4/ip_queue.h]

Indeed this seems so.

> Am I wrong?
> If yes, what is the right way to fix this? Updating the API?

Use libnetfilter_queue ;-)
