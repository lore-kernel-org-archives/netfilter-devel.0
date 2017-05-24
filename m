From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] evaluate: prevent using sets in payload statements
Date: Wed, 24 May 2017 17:48:20 +0200
Message-ID: <20170524154820.GC24697@salvia>
References: <149563146450.21555.7985467199304693684.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo@debian.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60488 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S937118AbdEXPsd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 May 2017 11:48:33 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A5B45DFE30
        for <netfilter-devel@vger.kernel.org>; Wed, 24 May 2017 17:48:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 92F28FF2FA
        for <netfilter-devel@vger.kernel.org>; Wed, 24 May 2017 17:48:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 43EA910078C
        for <netfilter-devel@vger.kernel.org>; Wed, 24 May 2017 17:48:15 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <149563146450.21555.7985467199304693684.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, May 24, 2017 at 03:11:04PM +0200, Arturo Borrero Gonzalez wrote:
> Prevent this assert:
> 
> % nft [..] tcp dport set { 0 , 1 }
> BUG: unknown expression type set reference
> nft: netlink_linearize.c:696: netlink_gen_expr: Assertion `0' failed.
> Aborted
> 
> We can't use a set here because we will not known what value to use.
> 
> With this patch, this is produced:
> 
> % nft [..] tcp dport set {1, 2 }
> <cmdline>:1:19-27: Error: you cannot use a set here
> add rule ip nat c tcp dport set {1, 2 }
>                   ^^^^^^^^^~~~~~~~~~~~~
> % nft [..] tcp dport set @s
> <cmdline>:1:19-27: Error: you cannot reference a set here
> add rule ip nat c tcp dport set @s
>                   ^^^^^^^^^~~~~~~~
> 
> Using maps is still allowed:
> 
> % nft [..] tcp dport set numgen inc mod 2 map { 0 : 4040 , 1 : 4050 }

Good catch.

I think we should reject this more generically, ie.

nft add rule x y meta mark set {1, 2 }
