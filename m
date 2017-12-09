From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: nf_defrag_ipv4: Skip defrag if
 NOTRACK is set
Date: Sat, 9 Dec 2017 16:10:18 +0100
Message-ID: <20171209151018.GA5551@salvia>
References: <1510623446-9115-1-git-send-email-subashab@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de,
        kadlec@blackhole.kfki.hu
To: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50466 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750886AbdLIPKX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 9 Dec 2017 10:10:23 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8A599EB465
        for <netfilter-devel@vger.kernel.org>; Sat,  9 Dec 2017 16:10:21 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 74EDDDA807
        for <netfilter-devel@vger.kernel.org>; Sat,  9 Dec 2017 16:10:21 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1510623446-9115-1-git-send-email-subashab@codeaurora.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Subash,

Sorry it took a while, but I've been discussing this with Jozsef too,
he's now on Cc.

On Mon, Nov 13, 2017 at 06:37:26PM -0700, Subash Abhinov Kasiviswanathan wrote:
> conntrack defrag is needed only if some module like CONNTRACK or NAT
> explicitly requests it. For plain forwarding scenarios, defrag is
> not needed and can be skipped if NOTRACK is set in a rule.
> 
> Since conntrack defrag is currently higher priority than raw table,
> setting NOTRACK is not sufficient. We need to introduce a lower
> priority rule and deprecate the existing rule.
> 
> Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
> ---
>  include/uapi/linux/netfilter_ipv4.h | 3 ++-
>  net/ipv4/netfilter/nf_defrag_ipv4.c | 6 +++---
>  2 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/include/uapi/linux/netfilter_ipv4.h b/include/uapi/linux/netfilter_ipv4.h
> index e6b1a84..cedf7b4 100644
> --- a/include/uapi/linux/netfilter_ipv4.h
> +++ b/include/uapi/linux/netfilter_ipv4.h
> @@ -57,9 +57,10 @@
>  
>  enum nf_ip_hook_priorities {
>  	NF_IP_PRI_FIRST = INT_MIN,
> -	NF_IP_PRI_CONNTRACK_DEFRAG = -400,
> +	NF_IP_PRI_CONNTRACK_DEFRAG = -400, /* deprecated */
>  	NF_IP_PRI_RAW = -300,
>  	NF_IP_PRI_SELINUX_FIRST = -225,
> +	NF_IP_PRI_CONNTRACK_DEFRAG_V1 = -210,

Would it work for you if this is specific via global modparam? I'm
telling this because:

1) This is changing the default behaviour, which is always tricky.
2) This is already solved in nftables, so whatever solution that we
   apply, it should be iptables specific.

If modparam is fine, just placing a line into
/etc/modprobe.d/options.conf (or similar) should be good enough to
store that you're requesting raw hook registration before defrag.

Let me know,
Thanks!
