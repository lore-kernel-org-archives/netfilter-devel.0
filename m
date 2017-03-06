From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libnftnl] expr: hash: support of symmetric hash
Date: Mon, 6 Mar 2017 17:59:37 +0100
Message-ID: <20170306165937.GA5076@salvia>
References: <20170223111108.r2sw3wr6nbpuip7v@nevthink>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Laura Garcia Liebana <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35782 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753087AbdCFRZR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Mar 2017 12:25:17 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 307BBE770
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Mar 2017 17:59:55 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1D4D2DA7E9
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Mar 2017 17:59:55 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CDF4BDA81B
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Mar 2017 17:59:52 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170223111108.r2sw3wr6nbpuip7v@nevthink>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Feb 23, 2017 at 12:11:08PM +0100, Laura Garcia Liebana wrote:
> This patch provides symmetric hash support according to source
> ip address and port, and destination ip address and port.
> 
> The new attribute NFTA_HASH_TYPE has been included to support
> different types of hashing functions. Currently supported
> NFT_HASH_JENKINS through jhash and NFT_HASH_SYM through symhash.
> 
> The main difference between both types are:
>  - jhash requires an expression with sreg, symhash doesn't.
>  - symhash supports modulus and offset, but not seed.
> 
> Examples:
> 
>  nft add rule ip nat prerouting ct mark set jhash ip saddr mod 2
>  nft add rule ip nat prerouting ct mark set symhash mod 2

Applied, thanks.
