From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH 3/6] src/object: Avoid returning garbage in
 nftnl_obj_do_parse()
Date: Fri, 15 Dec 2017 16:18:40 +0100
Message-ID: <20171215151840.4cr5hn7cmw5xzkji@salvia>
References: <20171214194025.21334-1-phil@nwl.cc>
 <20171214194025.21334-4-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35730 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932195AbdLOPSm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 15 Dec 2017 10:18:42 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9C29FC5142
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Dec 2017 16:18:41 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8D3A7FEFB4
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Dec 2017 16:18:41 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171214194025.21334-4-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Dec 14, 2017 at 08:40:22PM +0100, Phil Sutter wrote:
> It may happen that 'perr' variable does not get initialized, so making
> parameter 'err' point to it in any case is error-prone. Avoid this by
> initializing 'perr' upon declaration.

Applied, thanks.
