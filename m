From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 3/3] build: support compilation on non-Linuxes
Date: Wed, 9 Mar 2011 20:03:46 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1103091957140.9143@obet.zrqbmnf.qr>
References: <1299328292-4469-1-git-send-email-jengelh@medozas.de> <1299328292-4469-4-git-send-email-jengelh@medozas.de> <4D77863F.5080405@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:33869 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698Ab1CITDs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Mar 2011 14:03:48 -0500
In-Reply-To: <4D77863F.5080405@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2011-03-09 14:53, Pablo Neira Ayuso wrote:
>
>One comment:
>
>> ---
>>  configure.ac                    |   13 ++--
>>  include/generic/linux/netlink.h |  152 +++++++++++++++++++++++++++++++++++++++
>
>This duplicates the header that it's in include/linux/netlink.h, the
>only difference that I see at a quick glance is:
>
>+#ifndef AF_NETLINK
>+#	define AF_NETLINK 0
>+#endif
>
>right?
>
>I have kept this patch until we've got some discussion.

And replacing __u16/32 by uint16_t/32_t plus #include <stdint.h>
because Other OS don't have linux/types.h (and all the other linux/ 
includes that will be pulled in as a result of it).
