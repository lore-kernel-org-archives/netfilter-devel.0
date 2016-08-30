From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables 2/3] extensions: libip[6]t_SNAT/DNAT: use the
 new nft syntax when do xlate
Date: Tue, 30 Aug 2016 11:59:25 +0200
Message-ID: <20160830095925.GB20699@salvia>
References: <1472374248-21912-1-git-send-email-zlpnobody@163.com>
 <1472374248-21912-2-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35742 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755452AbcH3J7d (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Aug 2016 05:59:33 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A9C1A12A691
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Aug 2016 11:59:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9BD5A100A77
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Aug 2016 11:59:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6775E100A78
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Aug 2016 11:59:26 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1472374248-21912-2-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Aug 28, 2016 at 04:50:47PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> After commit "src: add 'to' for snat and dnat" in nftables tree,
> we should recommend the end user to use the new syntax.
> 
> Before this patch:
>   # iptables-translate -t nat -A POSTROUTING -j SNAT --to-source 1.1.1.1
>   nft add rule ip nat POSTROUTING counter snat 1.1.1.1
>   # ip6tables-translate -t nat -A PREROUTING -j DNAT --to-destination
>   2001::1
>   nft add rule ip6 nat PREROUTING counter dnat 2001::1
> 
> Apply this patch:
>   # iptables-translate -t nat -A POSTROUTING -j SNAT --to-source 1.1.1.1
>   nft add rule ip nat POSTROUTING counter snat to 1.1.1.1
>   # ip6tables-translate -t nat -A PREROUTING -j DNAT --to-destination
>   2001::1
>   nft add rule ip6 nat PREROUTING counter dnat to 2001::1

Applied, thanks!

BTW, if you have some spare cycles, it would be great to use the
square brackets in the translation output too I think.

# ip6tables-translate -t nat -A PREROUTING -p tcp -j DNAT --to-destination [abcd::1]:30
nft add rule ip6 nat PREROUTING meta l4proto tcp counter dnat abcd::1 :30
