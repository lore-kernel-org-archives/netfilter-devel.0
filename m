From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next,RFC 08/10] netfilter: move NF_QUEUE handling away
 from core
Date: Fri, 14 Oct 2016 12:28:08 +0200
Message-ID: <20161014102808.GA10058@salvia>
References: <1476360171-2991-1-git-send-email-pablo@netfilter.org>
 <1476360171-2991-9-git-send-email-pablo@netfilter.org>
 <CAML_gOd99wfVxM6ZNi95U+Ddee3AzAH=N6s2N0eMpzU0wRg=2g@mail.gmail.com>
 <20161014095330.GA4444@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Liping Zhang <zlpnobody@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59802 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752029AbcJNKfd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 14 Oct 2016 06:35:33 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 852649D330
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Oct 2016 12:28:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 75401DA816
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Oct 2016 12:28:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2927FDA8EE
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Oct 2016 12:28:13 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20161014095330.GA4444@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 14, 2016 at 11:53:30AM +0200, Pablo Neira Ayuso wrote:
[...] 
> BTW, looking at ipt_mangle_out():
> 
>         ret = ipt_do_table(skb, state, state->net->ipv4.iptable_mangle);
>         /* Reroute for ANY change. */
>         if (ret != NF_DROP && ret != NF_STOLEN) {
>                 iph = ip_hdr(skb);
> 
>                 if (iph->saddr != saddr ||
>                     iph->daddr != daddr ||
>                     skb->mark != mark ||
>                     iph->tos != tos) {
>                         err = ip_route_me_harder(state->net, skb, RTN_UNSPEC);
>                         if (err < 0)
>                                 ret = NF_DROP_ERR(err);
>                 }
>         }
> 
> It seems that we're triggering an expensive re-reroute for dropped
> packets from the mangle table, since ret != NF_DROP evaluates false
> given the errno number is encoded in the most significant 16 bits.

Forget this, we never see errno at this stage, so this is fine.
