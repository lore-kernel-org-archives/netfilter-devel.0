From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 02/13] Fix all remaining warnings (missing declarations,
 missing prototypes)
Date: Sun, 13 Apr 2008 07:08:40 +0200
Message-ID: <48019558.5020009@trash.net>
References: <f8e3139e003f45acd60f10a40644de0ad1eefaec.1207813085.git.jengelh@computergmbh.de> <45679164d6bf17f0e66d6213796a02698ae42a28.1207813085.git.jengelh@computergmbh.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33166 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbYDMFIq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 13 Apr 2008 01:08:46 -0400
In-Reply-To: <45679164d6bf17f0e66d6213796a02698ae42a28.1207813085.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> ---
>  configure.ac                |    6 +-----
>  extensions/GNUmakefile.in   |    2 ++
>  extensions/libip6t_policy.c |    5 -----
>  extensions/libipt_ULOG.c    |    2 +-
>  include/iptables.h          |    2 --
>  include/libiptc/libip6tc.h  |    2 ++
>  include/libiptc/libiptc.h   |    2 ++
>  include/xtables.h           |    7 +++++++
>  include/xtables/internal.h  |    6 ++++++
>  ip6tables-multi.h           |    8 ++++++++
>  ip6tables-restore.c         |    4 +++-
>  ip6tables-save.c            |    1 +
>  ip6tables-standalone.c      |    1 +
>  ip6tables.c                 |    6 ++----
>  iptables-multi.h            |    9 +++++++++
>  iptables-restore.c          |    3 ++-
>  iptables-save.c             |    1 +
>  iptables-standalone.c       |    1 +
>  iptables-xml.c              |    1 +
>  iptables.c                  |    4 +---
>  libiptc/libiptc.c           |    9 ++++-----
>  21 files changed, 55 insertions(+), 27 deletions(-)
>  create mode 100644 include/xtables/internal.h
>  create mode 100644 ip6tables-multi.h
>  create mode 100644 iptables-multi.h

Applied.
