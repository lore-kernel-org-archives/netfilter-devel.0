From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nf-next PATCH 0/5] netfilter: nf_tables: Kill name length
 restrictions
Date: Mon, 24 Jul 2017 11:46:25 +0200
Message-ID: <20170724094625.GA3600@salvia>
References: <20170720152450.27693-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37798 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751526AbdGXKD6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Jul 2017 06:03:58 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5FCE01E5D09
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Jul 2017 12:03:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4544A12FB31
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Jul 2017 12:03:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D2340332590
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Jul 2017 11:46:18 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170720152450.27693-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Phil,

On Thu, Jul 20, 2017 at 05:24:45PM +0200, Phil Sutter wrote:
> The following series removes the hard-coded restriction on name length
> of tables, chains, sets and objects.
> 
> The first patch introduces nla_strdup() which aids in duplicating a
> string contained in a netlink attribute. It is used to replace the call
> to nla_strlcpy() when populating name fields.
> 
> I've tested the series manually by creating tables, chains, sets and
> counter objects with long names and automated by running the py and
> shell testsuites of nftables repo. Also, kmemleak did not find anything
> nftables related.

I like this new dynamic name logic via nla_strdup().

I would like we still have a reasonable upper limit on string length.
IIRC, Arturo mentioned he wants to use DNS names to identify sets, so
we can just use 255 bytes as RFC 1035 indicates.

Thanks!
