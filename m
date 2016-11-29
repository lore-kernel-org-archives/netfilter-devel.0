From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables] extensions: LOG: add log flags translation to
 nft
Date: Tue, 29 Nov 2016 23:30:25 +0100
Message-ID: <20161129223025.GA7797@salvia>
References: <1480248509-21828-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52330 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751917AbcK2Wae (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Nov 2016 17:30:34 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C6A34186AC1
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2016 23:30:32 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B9A1FDA849
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2016 23:30:32 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C5F16DA848
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2016 23:30:30 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1480248509-21828-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Nov 27, 2016 at 08:08:29PM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> For example:
>  # iptables-translate -A OUTPUT -j LOG --log-uid
>  nft add rule ip filter OUTPUT counter log flags skuid
> 
>  # iptables-translate -A OUTPUT -j LOG --log-tcp-sequence \
>  --log-tcp-options
>  nft add rule ip filter OUTPUT counter log flags tcp sequence,options
> 
>  # iptables-translate -A OUTPUT -j LOG --log-level debug --log-uid
>  nft add rule ip filter OUTPUT counter log level debug flags skuid
> 
>  # ip6tables-translate -A OUTPUT -j LOG --log-ip-options --log-macdecode
>  nft add rule ip6 filter OUTPUT counter log flags ip options flags ether
> 
>  # ip6tables-translate -A OUTPUT -j LOG --log-ip-options --log-uid \
>  --log-tcp-sequence --log-tcp-options --log-macdecode
>  nft add rule ip6 filter OUTPUT counter log flags all

Applied, thanks Liping.
