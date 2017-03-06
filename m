From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next v3 2/2] netfilter: nft_hash: support of symmetric
 hash
Date: Mon, 6 Mar 2017 17:56:55 +0100
Message-ID: <20170306165655.GB4529@salvia>
References: <20170302160014.akuuficacpcppfdf@nevthink>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Laura Garcia Liebana <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53566 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753986AbdCFREh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Mar 2017 12:04:37 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7F4F2E629
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Mar 2017 17:57:06 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 701C7DA809
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Mar 2017 17:57:06 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2E87CDA807
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Mar 2017 17:57:04 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170302160014.akuuficacpcppfdf@nevthink>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 02, 2017 at 05:00:14PM +0100, Laura Garcia Liebana wrote:
> This patch provides symmetric hash support according to source
> ip address and port, and destination ip address and port.
> 
> For this purpose, the __skb_get_hash_symmetric() is used to
> identify the flow as it uses FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL
> flag by default.
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
> 
> By default, jenkins hash will be used if no hash type is
> provided for compatibility reasons.

Also applied, thanks Laura.
