From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nf-next PATCH v3 0/6] netfilter: nf_tables: Kill name length
 restrictions
Date: Mon, 31 Jul 2017 19:17:28 +0200
Message-ID: <20170731171727.GA9835@salvia>
References: <20170727145644.16888-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54226 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751737AbdGaRRg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 31 Jul 2017 13:17:36 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 552AA3025A4
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Jul 2017 19:17:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 466F4D1CAF
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Jul 2017 19:17:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1C593D1D96
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Jul 2017 19:17:20 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170727145644.16888-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jul 27, 2017 at 04:56:38PM +0200, Phil Sutter wrote:
> The following series lifts the tight restriction on name length of
> tables, chains, sets and objects. This is done by allocating memory for
> names dynamically, so there is no added overhead when reducing the
> restriction to a mere sanity level of 255 characters.
> 
> The first patch removes a needless check discovered when discussing v2
> of this patch set.
> 
> The second patch introduces nla_strdup() which aids in duplicating a
> string contained in a netlink attribute. It is used to replace the call
> to nla_strlcpy() when populating name fields.
> 
> I've tested the series manually by creating tables, chains, sets and
> counter objects with long names and automated by running the py and
> shell testsuites of nftables repo. Also, kmemleak did not find anything
> nftables related.

Series applied, thanks Phil.
