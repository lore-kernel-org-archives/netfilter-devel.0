From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 05/13] Combine IP{,6}T_LIB_DIR into XTABLES_LIBDIR
Date: Sun, 13 Apr 2008 07:16:04 +0200
Message-ID: <48019714.7090505@trash.net>
References: <f8e3139e003f45acd60f10a40644de0ad1eefaec.1207813085.git.jengelh@computergmbh.de> <fe1aa95786eb67a3a417c7dee571e7cc4f6a9ec9.1207813085.git.jengelh@computergmbh.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33281 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbYDMFQJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 13 Apr 2008 01:16:09 -0400
In-Reply-To: <fe1aa95786eb67a3a417c7dee571e7cc4f6a9ec9.1207813085.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> iptables and ip6tables will now recognize the XTABLES_LIBDIR environment
> variable for extensions to look in before going to the (old) IPT_LIB_DIR
> or IP6T_LIB_DIR (depending on program!) or the default location (/usr..).
> 
> XTABLES_LIBDIR can also take multiple directories (like PATH, separated
> by colon).
> ---
>  configure.ac              |   13 ++---
>  extensions/GNUmakefile.in |    6 +-
>  include/ip6tables.h       |    4 --
>  include/iptables.h        |    4 --
>  ip6tables-restore.c       |   11 +++-
>  ip6tables-save.c          |   11 +++-
>  ip6tables-standalone.c    |   11 +++-
>  iptables-restore.c        |   11 +++-
>  iptables-save.c           |   11 +++-
>  iptables-standalone.c     |   11 +++-
>  libiptc/libiptc.c         |    4 --
>  xtables.c                 |   94 ++++++++++++++++++++-----------------
>  12 files changed, 108 insertions(+), 83 deletions(-)

Applied.
