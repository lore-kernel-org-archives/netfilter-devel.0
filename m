From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH 5/6] src/set_elem: Don't return garbage in
 nftnl_set_elems_parse()
Date: Fri, 15 Dec 2017 16:19:24 +0100
Message-ID: <20171215151924.2ohfdod25v2uv2gl@salvia>
References: <20171214194025.21334-1-phil@nwl.cc>
 <20171214194025.21334-6-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35930 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932292AbdLOPT1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 15 Dec 2017 10:19:27 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BFDAFC5142
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Dec 2017 16:19:25 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B05BDFEFB8
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Dec 2017 16:19:25 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171214194025.21334-6-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Dec 14, 2017 at 08:40:24PM +0100, Phil Sutter wrote:
> This might happen if netlink message is malformed (no nested attributes
> are present), so treat this as an error and return -1 instead of
> garbage to caller.

Applied, thanks.
