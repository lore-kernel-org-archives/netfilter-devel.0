From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables 3/3] extensions: libip[6]t_REDIRECT: use new nft
 syntax when do xlate
Date: Tue, 30 Aug 2016 11:59:43 +0200
Message-ID: <20160830095943.GC20699@salvia>
References: <1472374248-21912-1-git-send-email-zlpnobody@163.com>
 <1472374248-21912-3-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35812 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755400AbcH3J7u (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Aug 2016 05:59:50 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6199912A68F
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Aug 2016 11:59:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 522AC100798
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Aug 2016 11:59:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 48498FF2C7
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Aug 2016 11:59:45 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1472374248-21912-3-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Aug 28, 2016 at 04:50:48PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> After commit "parser_bison: redirect to :port for consistency with
> nat/masq statement" in nftables tree, we should recommend the end
> user to use the new syntax.
> 
> Before this patch:
>   # iptables-translate -t nat -A PREROUTING -p tcp -j REDIRECT --to-ports 1
>   nft add rule ip nat PREROUTING ip protocol tcp counter redirect to 1
> 
> Apply this patch:
>   # iptables-translate -t nat -A PREROUTING -p tcp -j REDIRECT --to-ports 1
>   nft add rule ip nat PREROUTING ip protocol tcp counter redirect to :1

Also applied, thanks.
