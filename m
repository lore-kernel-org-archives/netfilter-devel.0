From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [iptables-nftables PATCH 0/3] NFPROTO_ARP and arp mangle target
 support (+ one minor fix)
Date: Thu, 03 Oct 2013 11:26:19 +0300
Message-ID: <524D2A2B.1010507@linux.intel.com>
References: <1378453910-17954-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:65004 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753895Ab3JCI1D (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Oct 2013 04:27:03 -0400
In-Reply-To: <1378453910-17954-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

@Pablo: I understand that patch 2 is not necessary, but what about patch 
3? This one is relevant to get xtables-arp being able to handle mangle 
target.
Or is there any issue with it?

Tomasz

> This patchset prepares for arptables-nftables to be included so it will use libxtables for its target.
>
> Tomasz Bursztyka (3):
>    nft: Fix a minor compilation warning
>    libxtables: Add NFPROTO_ARP support for libarpt_* prefixed extensions
>    libxtables: Port libarptc mangle target into libxtables
>
>   configure.ac                              |   5 +
>   extensions/GNUmakefile.in                 |  52 +++-
>   extensions/libarpt_mangle.c               | 388 ++++++++++++++++++++++++++++++
>   include/linux/netfilter_arp.h             |  19 ++
>   include/linux/netfilter_arp/arp_tables.h  | 204 ++++++++++++++++
>   include/linux/netfilter_arp/arpt_mangle.h |  26 ++
>   iptables/nft-shared.c                     |   2 +-
>   libxtables/xtables.c                      |  14 ++
>   8 files changed, 701 insertions(+), 9 deletions(-)
>   create mode 100644 extensions/libarpt_mangle.c
>   create mode 100644 include/linux/netfilter_arp.h
>   create mode 100644 include/linux/netfilter_arp/arp_tables.h
>   create mode 100644 include/linux/netfilter_arp/arpt_mangle.h
>

