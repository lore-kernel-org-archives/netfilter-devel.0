From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] ct: add average bytes per packet counter support
Date: Mon, 16 Jan 2017 14:10:34 +0100
Message-ID: <20170116131034.GA19407@salvia>
References: <1482667975-736-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45350 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751187AbdAPNKr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Jan 2017 08:10:47 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 474012EFEA7
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Jan 2017 14:10:39 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 357A929B12
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Jan 2017 14:10:39 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 41A0650F34
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Jan 2017 14:10:35 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1482667975-736-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Dec 25, 2016 at 08:12:55PM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> Similar to connbytes extension in iptables, now you can use it to match
> average bytes per packet a connection has transferred so far.
> 
> For example, match avgpkt in "BOTH" diretion:
>   # nft add rule x y ct avgpkt \> 100
> 
> Match avgpkt in reply direction:
>   # nft add rule x y ct reply avgpkt \< 900
> 
> Or match avgpkt in original direction:
>   # nft add rule x y ct original avgpkt \> 200

Applied, thanks Liping.
