From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [Iptables PATCH] extensions: Rename 'flow table' keyword to meter
Date: Mon, 29 Jan 2018 15:25:18 +0100
Message-ID: <20180129142518.tsdedlbslobevj6g@salvia>
References: <1516992076-10321-1-git-send-email-mayhs11saini@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: shyam saini <mayhs11saini@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60044 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751256AbeA2OZX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 29 Jan 2018 09:25:23 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3206B1C4386
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Jan 2018 15:25:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 242B2BAC2D
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Jan 2018 15:25:22 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1516992076-10321-1-git-send-email-mayhs11saini@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jan 27, 2018 at 12:11:16AM +0530, shyam saini wrote:
> After nft v0.8.1 "flow table" is renamed as meter.
> This should reflect in iptables to nftables translation.
> 
> Before this patch:
> $ iptables-translate -A INPUT -m tcp -p tcp --dport 80 -m hashlimit
> --hashlimit-above 200/sec --hashlimit-mode srcip,dstport
> --hashlimit-name http1 -j DROP
> 
> nft add rule ip filter INPUT tcp dport 80 flow table http1 { tcp dport .
> ip saddr limit rate over 200/second } counter drop
> 
> After this patch:
> $ iptables-translate -A INPUT -m tcp -p tcp --dport 80 -m hashlimit
> --hashlimit-upto 200 --hashlimit-mode srcip --hashlimit-name http3
> --hashlimit-srcmask 24 -j DROP
> 
> nft add rule ip filter INPUT tcp dport 80 meter http3 { ip saddr and
> 255.255.255.0 limit rate 200/second } counter drop

Applied, thanks Shyam.
