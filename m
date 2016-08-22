From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables 1/3] xtables-compat: remove useless functions
Date: Mon, 22 Aug 2016 11:51:39 +0200
Message-ID: <20160822095138.GA10679@salvia>
References: <20160821181027.14622-1-pablombg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54598 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750839AbcHVJvn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Aug 2016 05:51:43 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0912316B2AF
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Aug 2016 11:51:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EE719100A58
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Aug 2016 11:51:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E035EFF2C7
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Aug 2016 11:51:39 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160821181027.14622-1-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Aug 21, 2016 at 08:10:25PM +0200, Pablo M. Bermudo Garay wrote:
> The static function nft_rule_list_get was exposed outside nft.c through
> the nft_rule_list_create function, but this was never used out there.
> 
> A similar situation occurs with nftnl_rule_list_free and
> nft_rule_list_destroy.
> 
> This patch removes nft_rule_list_create and nft_rule_list_destroy for
> the sake of simplicity.

Applied this patch 1/3. Thanks.
