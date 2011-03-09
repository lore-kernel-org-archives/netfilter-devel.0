From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/3] build: support compilation on non-Linuxes
Date: Wed, 09 Mar 2011 14:53:03 +0100
Message-ID: <4D77863F.5080405@netfilter.org>
References: <1299328292-4469-1-git-send-email-jengelh@medozas.de> <1299328292-4469-4-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34392 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932208Ab1CINxI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Mar 2011 08:53:08 -0500
In-Reply-To: <1299328292-4469-4-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 05/03/11 13:31, Jan Engelhardt wrote:
> Netlink is a usable TLV protocol for IPC (e.g. over AF_LOCAL sockets)
> in itself even if other operating systems do not have kernel support
> for it.
> This tested on FreeBSD 8.2.

Interesting, I'll apply some example file to the tree if you have it.

One comment:

> ---
>  configure.ac                    |   13 ++--
>  include/generic/linux/netlink.h |  152 +++++++++++++++++++++++++++++++++++++++

This duplicates the header that it's in include/linux/netlink.h, the
only difference that I see at a quick glance is:

+#ifndef AF_NETLINK
+#	define AF_NETLINK 0
+#endif

right?

I have kept this patch until we've got some discussion.
