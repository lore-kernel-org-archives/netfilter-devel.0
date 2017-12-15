From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH 2/6] src/gen: Remove a pointless call to
 mnl_nlmsg_get_payload()
Date: Fri, 15 Dec 2017 16:17:55 +0100
Message-ID: <20171215151755.auwyloz6n65potwh@salvia>
References: <20171214194025.21334-1-phil@nwl.cc>
 <20171214194025.21334-3-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35502 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756692AbdLOPR5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 15 Dec 2017 10:17:57 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AE40AC5142
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Dec 2017 16:17:56 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9D921FC5E6
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Dec 2017 16:17:56 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171214194025.21334-3-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Dec 14, 2017 at 08:40:21PM +0100, Phil Sutter wrote:
> It is a common idiom in all *_nlmsg_parse() functions, but
> nftnl_gen_nlmsg_parse() doesn't make use of the data pointer and the
> compiler probably can't eliminate it since there could be a side-effect.

Also applied, thanks.
