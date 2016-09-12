From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] netfilter: nft_hash: Add hash offset value
Date: Mon, 12 Sep 2016 20:31:46 +0200
Message-ID: <20160912183146.GA10467@salvia>
References: <20160906064416.GA32396@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Laura Garcia Liebana <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34520 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751389AbcILSbw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Sep 2016 14:31:52 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8BCFD1392A3
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Sep 2016 20:31:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7C76E114D6C
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Sep 2016 20:31:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6AA4EFB45F
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Sep 2016 20:31:47 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160906064416.GA32396@sonyv>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Sep 06, 2016 at 08:44:19AM +0200, Laura Garcia Liebana wrote:
> Add support to pass through an offset to the hash value. With this
> feature, the sysadmin is able to generate a hash with a given
> offset value.
> 
> Example:
> 
> 	meta mark set jhash ip saddr mod 2 seed 0xabcd sum 100
> 
> This option generates marks according to the source address from 100 to
> 101.

Applied, thanks.

I have renamed all these to _OFFSET.
