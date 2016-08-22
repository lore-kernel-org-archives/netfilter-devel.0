From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables] extensions: libxt_CLASSIFY: Add translation to
 nft
Date: Mon, 22 Aug 2016 11:44:52 +0200
Message-ID: <20160822094452.GA10128@salvia>
References: <1471790095-29856-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52126 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752440AbcHVJo5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Aug 2016 05:44:57 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E2173164198
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Aug 2016 11:44:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D2991100A60
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Aug 2016 11:44:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1C633FC61C
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Aug 2016 11:44:53 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1471790095-29856-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Aug 21, 2016 at 10:34:55PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> For examples:
>   # iptables-translate -A OUTPUT -j CLASSIFY --set-class 0:0
>   nft add rule ip filter OUTPUT counter meta priority set none
>   # iptables-translate -A OUTPUT -j CLASSIFY --set-class ffff:ffff
>   nft add rule ip filter OUTPUT counter meta priority set root
>   # iptables-translate -A OUTPUT -j CLASSIFY --set-class 1:234
>   nft add rule ip filter OUTPUT counter meta priority set 1:234

Applied, thanks.
