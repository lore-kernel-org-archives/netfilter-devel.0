From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables] extensions: libxt_connbytes: Add translation to
 nft
Date: Mon, 16 Jan 2017 14:13:30 +0100
Message-ID: <20170116131330.GA19591@salvia>
References: <1482668871-1946-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47362 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751559AbdAPNNj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Jan 2017 08:13:39 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B6A1A303D00
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Jan 2017 14:13:37 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A77788E626
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Jan 2017 14:13:37 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7EFE58E628
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Jan 2017 14:13:35 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1482668871-1946-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Dec 25, 2016 at 08:27:51PM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> For example:
>   # iptables-translate -A OUTPUT -m connbytes --connbytes 200 \
>   --connbytes-dir original --connbytes-mode packets
>   nft add rule ip filter OUTPUT ct original packets ge 200 counter
> 
>   # iptables-translate -A OUTPUT -m connbytes ! --connbytes 200 \
>   --connbytes-dir reply --connbytes-mode packets
>   nft add rule ip filter OUTPUT ct reply packets lt 200 counter
> 
>   # iptables-translate -A OUTPUT -m connbytes --connbytes 200:600 \
>   --connbytes-dir both --connbytes-mode bytes
>   nft add rule ip filter OUTPUT ct bytes 200-600 counter
> 
>   # iptables-translate -A OUTPUT -m connbytes ! --connbytes 200:600 \
>   --connbytes-dir both --connbytes-mode bytes
>   nft add rule ip filter OUTPUT ct bytes != 200-600 counter
> 
>   # iptables-translate -A OUTPUT -m connbytes --connbytes 200:200 \
>   --connbytes-dir both --connbytes-mode avgpkt
>   nft add rule ip filter OUTPUT ct avgpkt 200 counter

Also applied, thanks.
