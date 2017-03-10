From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 0/5] Introduce boolean type and existence checks
Date: Fri, 10 Mar 2017 19:02:34 +0100
Message-ID: <20170310180234.GA25458@salvia>
References: <20170310171353.28868-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48144 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755276AbdCJSCy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 Mar 2017 13:02:54 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BDA1A1B8407
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Mar 2017 19:02:51 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id ACDC2DA7FA
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Mar 2017 19:02:51 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7C8CEDA7E9
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Mar 2017 19:02:49 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170310171353.28868-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Mar 10, 2017 at 06:13:48PM +0100, Phil Sutter wrote:
> The following patch series implements a boolean datatype for use in a
> boolean expression as right-hand side of a relational. Based upon that,
> header existence matches are implemented for IPv6 extension and TCP
> option headers as well as an existence match of a FIB entry.

Nice series Phil, applied from patch 1/5 to 3/5.

Please see comment on 4/5. Thanks!
