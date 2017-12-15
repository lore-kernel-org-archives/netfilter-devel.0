From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH 6/6] src/trace: Check return value of
 mnl_attr_parse_nested()
Date: Fri, 15 Dec 2017 16:20:01 +0100
Message-ID: <20171215152000.mic2qm5rieyu66yb@salvia>
References: <20171214194025.21334-1-phil@nwl.cc>
 <20171214194025.21334-7-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36054 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932357AbdLOPUD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 15 Dec 2017 10:20:03 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8B469C514C
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Dec 2017 16:20:02 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6B65AF7319
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Dec 2017 16:20:02 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171214194025.21334-7-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Dec 14, 2017 at 08:40:25PM +0100, Phil Sutter wrote:
> This is done everywhere else as well, so certainly not a bad thing here
> either.

Indeed. Applied, thanks Phil.
