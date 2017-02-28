From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables] extensions: libxt_hashlimit: Add translation to
 nft
Date: Tue, 28 Feb 2017 12:21:00 +0100
Message-ID: <20170228112100.GA19254@salvia>
References: <20170227174308.GA14613@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Elise Lennion <elise.lennion@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53912 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751870AbdB1LVY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Feb 2017 06:21:24 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 820B62D15EE
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Feb 2017 12:21:03 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 72F6EDA849
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Feb 2017 12:21:03 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 390BDDA84F
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Feb 2017 12:21:01 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170227174308.GA14613@lennorien.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Feb 27, 2017 at 02:43:08PM -0300, Elise Lennion wrote:
> Hashlimit has similar functionality to flow tables in nftables. Some
> usage examples are:
> 
> $ iptables-translate -A OUTPUT -m tcp -p tcp --dport 443 -m hashlimit \
> --hashlimit-above 20kb/s --hashlimit-burst 1mb --hashlimit-mode dstip \
> --hashlimit-name https --hashlimit-dstmask 24 -m state --state NEW \
> -j DROP
> 
> nft add rule ip filter OUTPUT tcp dport 443 flow table https { ip \
> daddr and 255.255.255.0 timeout 60s limit rate over 20 kbytes/second \
> burst 1 mbytes} ct state new  counter drop
> 
> $ iptables-translate -A OUTPUT -m tcp -p tcp --dport 443 -m hashlimit \
> --hashlimit-upto 300 --hashlimit-burst 15 --hashlimit-mode \
> srcip,dstip --hashlimit-name https --hashlimit-htable-expire 300000 \
> -m state --state NEW -j DROP
> 
> nft add rule ip filter OUTPUT tcp dport 443 flow table https { ip \
> daddr . ip saddr timeout 300s limit rate 300/second burst 15 packets} \
> ct state new  counter drop
> 
> The translation isn't supported when --hashlimit-mode isn't specified.
> Also, the following options don't apply to flow tables:
> 
> --hashlimit-htable-size
> --hashlimit-htable-max
> --hashlimit-htable-gcinterval

Applied, thanks Elise.

I think it would be good to enhance the flow table article in the wiki
to describe how people can do hashlimit with nft.
