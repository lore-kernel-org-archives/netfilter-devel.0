From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 0/2] netfilter: helper set support
Date: Mon, 13 Mar 2017 13:43:23 +0100
Message-ID: <20170313124323.GA26477@salvia>
References: <20170308154844.18065-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48018 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752405AbdCMMoP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Mar 2017 08:44:15 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 29A4AC4A65
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Mar 2017 13:44:07 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DE35C6DC6C
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Mar 2017 13:44:06 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B092E1FFC7
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Mar 2017 13:43:23 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170308154844.18065-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 08, 2017 at 04:48:42PM +0100, Florian Westphal wrote:
> This adds support to set the conntrack helper from nftables, using
> nft set ct helper "foo" syntax.
> 
> Helpers are defined through the objref infrastructure.

Series applied, thanks Florian.
