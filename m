From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [linux PATCH v3 0/5] NAT updates for nf_tables
Date: Fri, 25 Jul 2014 18:48:06 +0200
Message-ID: <20140725164806.GA22375@salvia>
References: <20140701162801.2847.14389.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39019 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934705AbaGYQr5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Jul 2014 12:47:57 -0400
Content-Disposition: inline
In-Reply-To: <20140701162801.2847.14389.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

Would you be OK if we push this patchset into mainstream? I think we
can investigate the fetch interface address and store in register
approach that you proposed to implement masquerading later on. The
missing bits are the conntrack cleanup routine, I think that needs
some "scratchpad" area to store the last address/interface that have
been used. We can probably revisit this later once that generic state
infrastructure for nf_tables (to support stateful expressions in some
generic way) is in place?

If you don't like the idea, please let me know, and I'll defer this
masquerading patchset.

Thanks!

On Tue, Jul 01, 2014 at 06:29:13PM +0200, Arturo Borrero Gonzalez wrote:
> The following series implements some updates for NAT in nf_tables.
> 
> First of all, I add a new flag attribute to allow clients of nft_nat to
> specify additional config flags. This enables implementing port randomization
> and persistence to be set from nft.
> 
> Two patches split the masquerade code from ip[6]t_MASQUERADE.c to generic
> modules, so we can use this NAT type from nft_nat.
> 
> Then, the nft_nat code is splitted in AF specific parts, so we avoid potential
> dependencies regarding AF specific symbols in the last patch.
> 
> The last patch finally implements masquerade for nft_nat.
> 
> The v2 series included some fixes and additionals checks, as requested
> by Florian Westphal.
> 
> This v3 series includes changes requested by Pablo Neira.
> 
> Comments are welcomed.
> 
> ---
> 
> Arturo Borrero Gonzalez (5):
>       netfilter: nft_nat: include a flag attribute
>       netfilter: nf_nat_masquerade_ipv4: code factorization
>       netfilter: nf_nat_masquerade_ipv6: code factorization
>       netfilter: nft_nat: split code in AF parts
>       netfilter: nft_nat: add masquerade support
> 
> 
>  .../net/netfilter/ipv4/nf_nat_masquerade_ipv4.h    |   14 ++
>  .../net/netfilter/ipv6/nf_nat_masquerade_ipv6.h    |   10 +
>  include/net/netfilter/nft_nat.h                    |   22 +++
>  include/uapi/linux/netfilter/nf_nat.h              |    5 +
>  include/uapi/linux/netfilter/nf_tables.h           |   10 +
>  net/ipv4/netfilter/Kconfig                         |   14 ++
>  net/ipv4/netfilter/Makefile                        |    2 
>  net/ipv4/netfilter/ipt_MASQUERADE.c                |  108 +-------------
>  net/ipv4/netfilter/nf_nat_masquerade_ipv4.c        |  155 ++++++++++++++++++++
>  net/ipv4/netfilter/nft_nat_ipv4.c                  |  133 +++++++++++++++++
>  net/ipv6/netfilter/Kconfig                         |   14 ++
>  net/ipv6/netfilter/Makefile                        |    2 
>  net/ipv6/netfilter/ip6t_MASQUERADE.c               |   76 +---------
>  net/ipv6/netfilter/nf_nat_masquerade_ipv6.c        |  121 ++++++++++++++++
>  net/ipv6/netfilter/nft_nat_ipv6.c                  |  132 +++++++++++++++++
>  net/netfilter/nft_nat.c                            |  156 ++++++--------------
>  16 files changed, 688 insertions(+), 286 deletions(-)
>  create mode 100644 include/net/netfilter/ipv4/nf_nat_masquerade_ipv4.h
>  create mode 100644 include/net/netfilter/ipv6/nf_nat_masquerade_ipv6.h
>  create mode 100644 include/net/netfilter/nft_nat.h
>  create mode 100644 net/ipv4/netfilter/nf_nat_masquerade_ipv4.c
>  create mode 100644 net/ipv4/netfilter/nft_nat_ipv4.c
>  create mode 100644 net/ipv6/netfilter/nf_nat_masquerade_ipv6.c
>  create mode 100644 net/ipv6/netfilter/nft_nat_ipv6.c
> 
> -- 
> Arturo Borrero Gonzalez
