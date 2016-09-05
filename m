From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables] extensions: libip6t_SNAT/DNAT: add square
 bracket in xlat output when port is specified
Date: Mon, 5 Sep 2016 19:13:20 +0200
Message-ID: <20160905171320.GA27213@salvia>
References: <1472820425-7535-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56690 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933264AbcIERN0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Sep 2016 13:13:26 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4C02D231662
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Sep 2016 19:13:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3AB2EDA7E9
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Sep 2016 19:13:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7B2BFFAB21
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Sep 2016 19:13:21 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1472820425-7535-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Sep 02, 2016 at 08:47:05PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> It is better to add square brackets to ip6 address in nft translation
> output when the port is specified. This is keep consistent with the
> nft syntax.
> 
> Before this patch:
>   # ip6tables-translate -t nat -A OUTPUT -p tcp -j DNAT --to-destination \
>   [123::4]:1
>   nft add rule ip6 nat OUTPUT meta l4proto tcp counter dnat to 123::4 :1
>   # ip6tables-translate -t nat -A POSTROUTING -p tcp -j SNAT --to-source \
>   [123::4-123::8]:1
>   nft add rule ip6 nat POSTROUTING meta l4proto tcp counter snat to 123::4-123::8 :1
> 
> Apply this patch:
>   # ip6tables-translate -t nat -A OUTPUT -p tcp -j DNAT --to-destination \
>   [123::4]:1
>   nft add rule ip6 nat OUTPUT meta l4proto tcp counter dnat to [123::4]:1
>   # ip6tables-translate -t nat -A POSTROUTING -p tcp -j SNAT --to-source \
>   [123::4-123::8]:1
>   nft add rule ip6 nat POSTROUTING meta l4proto tcp counter snat to [123::4]-[123::8]:1

Applied, thanks!
