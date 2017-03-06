From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft v2] src: hash: support of symmetric hash
Date: Mon, 6 Mar 2017 18:26:25 +0100
Message-ID: <20170306172625.GA16950@salvia>
References: <20170228174250.wx4sjfa6dr5kcno6@nevthink>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Laura Garcia Liebana <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39434 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753396AbdCFRf4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Mar 2017 12:35:56 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 51F08170DB6
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Mar 2017 18:26:43 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3BC9DDA850
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Mar 2017 18:26:43 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 04E2FDA850
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Mar 2017 18:26:41 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170228174250.wx4sjfa6dr5kcno6@nevthink>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Feb 28, 2017 at 06:42:50PM +0100, Laura Garcia Liebana wrote:
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

Applied, thanks Laura.
