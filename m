From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [xtables-arptables PATCH v2 0/5] nft changes for xtables-arptables
Date: Tue, 23 Jul 2013 19:16:32 +0300
Message-ID: <51EEAC60.5080300@linux.intel.com>
References: <20130723161017.10040.6256.stgit@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:9765 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933299Ab3GWQQf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Jul 2013 12:16:35 -0400
In-Reply-To: <20130723161017.10040.6256.stgit@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

This version looks fine to me, tested and so on.

Thanks Giuseppe

Tomasz

> The following series implements changes in nft code that permit
> to reuse some functions in other tool (like xtables-arptables).
>
> I changed nft.h, now struct nft_handle gets a struct builtin_table
> pointer used in functions to works with a properly tables and not
> with tables declared in nft.c.
>
> ---
>
> Giuseppe Longo (5):
>        nft: add builtin_table
>        nft: search builtin tables via nft_handle tables pointer
>        nft: nft_xtables_config_load() called only in nft_init()
>        nft: make functions public
>        nft: replace args.family
>
>
>
>   iptables/nft.c                |   82 +++++++++++++++--------------------------
>   iptables/nft.h                |   44 ++++++++++++++++++++++
>   iptables/xtables-config.c     |    9 +++--
>   iptables/xtables-restore.c    |   19 +++++-----
>   iptables/xtables-save.c       |   18 +++++----
>   iptables/xtables-standalone.c |   16 +++-----
>   iptables/xtables.c            |    9 ++++-
>   7 files changed, 111 insertions(+), 86 deletions(-)
>

