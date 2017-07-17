From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH v2] set_expr: Allow passing the parent set to
 set_expr_alloc()
Date: Mon, 17 Jul 2017 17:31:31 +0200
Message-ID: <20170717153131.GA29725@salvia>
References: <20170712120315.GR16375@orbyte.nwl.cc>
 <20170712121416.22871-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        Arturo Borrero Gonzalez <arturo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34512 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751280AbdGQPbf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jul 2017 11:31:35 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9395F249D2
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jul 2017 17:31:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 833E41B3D5E
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jul 2017 17:31:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 690731B3D58
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jul 2017 17:31:20 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170712121416.22871-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jul 12, 2017 at 02:14:16PM +0200, Phil Sutter wrote:
> Usually one wants to at least initialize set_flags from the parent, so
> make allocation of a set's set expression more convenient.
> 
> The idea to do this came when fixing an issue with output formatting of
> larger anonymous sets in nft monitor: Since
> netlink_events_cache_addset() didn't initialize set_flags,
> calculate_delim() didn't detect it's an anonymous set and therefore
> added newlines to the output.

Applied, thanks Phil.
