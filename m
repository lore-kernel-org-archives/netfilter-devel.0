From: Patrick McHardy <kaber@trash.net>
Subject: Re: pull request
Date: Thu, 12 Feb 2009 06:29:16 +0100
Message-ID: <4993B3AC.1060707@trash.net>
References: <1234364616-19974-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: jengelh@medozas.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40097 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbZBLF3V (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Feb 2009 00:29:21 -0500
In-Reply-To: <1234364616-19974-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

jengelh@medozas.de wrote:
>  .gitignore                         |    2 +-
>  Makefile.am                        |    8 +-
>  configure.ac                       |    2 +-
>  include/ip6tables.h                |   11 +---
>  include/iptables.h                 |   11 +---
>  include/iptables/internal.h.in     |   13 ++++
>  include/linux/netfilter/xt_NFLOG.h |    2 +-
>  include/xtables.h.in               |   22 +++-----
>  include/xtables/internal.h.in      |   17 ------
>  ip6tables.c                        |   35 ++++-------
>  iptables-xml.c                     |   19 ++++--
>  iptables.c                         |   37 ++++--------
>  xtables.c                          |  111 +++++++++++++-----------------------
>  13 files changed, 108 insertions(+), 182 deletions(-)

This diffstat I get looks quite different:

  11 files changed, 73 insertions(+), 67 deletions(-)

Any idea whats going on there?
