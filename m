From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [Iptables Patch V3] extensions: libxt_cluster: Add translation
 to nft
Date: Tue, 16 Jan 2018 01:59:53 +0100
Message-ID: <20180116005953.zkoqd73jpz4jgm6i@salvia>
References: <1515995968-10120-1-git-send-email-mayhs11saini@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shyam Saini <mayhs11saini@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41880 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750802AbeAPA75 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Jan 2018 19:59:57 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DA7F853AA23
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jan 2018 01:59:55 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CD47FDA851
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jan 2018 01:59:55 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1515995968-10120-1-git-send-email-mayhs11saini@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Shyam,

On Mon, Jan 15, 2018 at 11:29:28AM +0530, Shyam Saini wrote:
> Add translation for cluster to nft
> 
> $ sudo iptables-translate -A PREROUTING -t mangle -i eth1 -m cluster
> --cluster-total-nodes 7 --cluster-local-node 5 --cluster-hash-seed
> 0xdeadbeef -j MARK --set-mark 0xffff
> 
> nft add rule ip mangle PREROUTING iifname eth1 jhash ct original saddr
> mod 7 seed 0xdeadbeef eq 5 meta pkttype set host counter meta mark set
> 0xffff
>
> $ sudo iptables-translate -A PREROUTING -t mangle -i eth1 -m cluster
> --cluster-total-nodes 7 --cluster-local-nodemask 5 --cluster-hash-seed
> 0xdeadbeef -j MARK --set-mark 0xffff
>
> nft add rule ip mangle PREROUTING iifname eth1 jhash ct original saddr
> mod 7 seed 0xdeadbeef eq { 0, 2 } meta pkttype set host counter meta
> mark set 0xffff

Looks good, applied, thanks!

Would you also send us a test for this?

Have a look at extensions/*.txlate

Thanks.
