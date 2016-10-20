From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 1/3] netfilter: built-in NAT support for DCCP
Date: Thu, 20 Oct 2016 14:37:26 +0200
Message-ID: <20161020123726.GA10040@salvia>
References: <cover.1476956422.git.dcaratti@redhat.com>
 <96409ea5aa35dd371f7ad0efa622339f82318b24.1476956422.git.dcaratti@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S. Miller" <davem@davemloft.net>,
        Arturo Borrero Gonzalez <arturo@debian.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: Davide Caratti <dcaratti@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39640 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751873AbcJTMhc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Oct 2016 08:37:32 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DA8789B7FD
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Oct 2016 14:37:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CAEDA20EF6
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Oct 2016 14:37:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 79A0320EF8
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Oct 2016 14:37:27 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <96409ea5aa35dd371f7ad0efa622339f82318b24.1476956422.git.dcaratti@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 20, 2016 at 12:26:23PM +0200, Davide Caratti wrote:
> CONFIG_NF_NAT_PROTO_DCCP is no more a tristate. When set to y, NAT
> support for DCCP protocol is built-in into nf_nat.ko.
> 
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>
> ---
>  include/net/netfilter/nf_nat_l4proto.h |  3 +++
>  net/netfilter/Kconfig                  |  2 +-
>  net/netfilter/Makefile                 |  3 ++-
>  net/netfilter/nf_nat_core.c            |  4 ++++
>  net/netfilter/nf_nat_proto_dccp.c      | 36 +---------------------------------
>  5 files changed, 11 insertions(+), 37 deletions(-)
> 
> diff --git a/include/net/netfilter/nf_nat_l4proto.h b/include/net/netfilter/nf_nat_l4proto.h
> index 12f4cc8..6328c18 100644
> --- a/include/net/netfilter/nf_nat_l4proto.h
> +++ b/include/net/netfilter/nf_nat_l4proto.h
> @@ -54,6 +54,9 @@ extern const struct nf_nat_l4proto nf_nat_l4proto_udp;
>  extern const struct nf_nat_l4proto nf_nat_l4proto_icmp;
>  extern const struct nf_nat_l4proto nf_nat_l4proto_icmpv6;
>  extern const struct nf_nat_l4proto nf_nat_l4proto_unknown;
> +#if IS_ENABLED(CONFIG_NF_NAT_PROTO_DCCP)

I think you can replace this by:

#ifdef CONFIG_NF_NAT_PROTO_DCCP

given that IS_ENABLED catches the module case too.

This is is just a code readability nitpick, so whoever reads this code
understands that we have no module support for this anymore.
