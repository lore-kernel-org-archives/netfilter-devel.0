From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 1/2] netfilter: conntrack: merge udp and udplite
 helpers
Date: Tue, 6 Dec 2016 11:52:03 +0100
Message-ID: <20161206105203.GA5539@salvia>
References: <1480704637-14994-1-git-send-email-fw@strlen.de>
 <1480704637-14994-2-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50892 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751471AbcLFKwM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Dec 2016 05:52:12 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C42A5D162A
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Dec 2016 11:52:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B5BAADA85D
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Dec 2016 11:52:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CAA49DA85D
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Dec 2016 11:52:08 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1480704637-14994-2-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Dec 02, 2016 at 07:50:36PM +0100, Florian Westphal wrote:
[...]
> diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
> index 44410d30d461..9c34c2cabd76 100644
> --- a/net/netfilter/Kconfig
> +++ b/net/netfilter/Kconfig
> @@ -169,16 +169,6 @@ config NF_CT_PROTO_SCTP
>  	  If you want to compile it as a module, say M here and read
>  	  <file:Documentation/kbuild/modules.txt>.  If unsure, say `N'.
>  
> -config NF_CT_PROTO_UDPLITE
> -	tristate 'UDP-Lite protocol connection tracking support'
> -	depends on NETFILTER_ADVANCED
> -	help
> -	  With this option enabled, the layer 3 independent connection
> -	  tracking code will be able to do state tracking on UDP-Lite
> -	  connections.
> -
> -	  To compile it as a module, choose M here.  If unsure, say N.
> -

Better keep this so someone explicitly willing to keep this out for
some reason can still do it, and we keep this inlined with other
protocols.
