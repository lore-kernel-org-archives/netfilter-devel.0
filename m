From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH v2 1/2] proto: Add some exotic ICMPv6 types
Date: Fri, 17 Mar 2017 12:45:16 +0100
Message-ID: <20170317114516.GA4740@salvia>
References: <20170315214757.GA1289@salvia>
 <20170316124321.23399-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58238 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751017AbdCQLxn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Mar 2017 07:53:43 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3380DA7EE7
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Mar 2017 12:45:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2360BEBAEF
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Mar 2017 12:45:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BBF43FC5EA
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Mar 2017 12:45:16 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170316124321.23399-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 16, 2017 at 01:43:20PM +0100, Phil Sutter wrote:
> This adds support for matching on inverse ND messages as defined by
> RFC3122 (not implemented in Linux) and MLDv2 as defined by RFC3810.
> 
> Note that ICMPV6_MLD2_REPORT macro is defined in linux/icmpv6.h but
> including that header leads to conflicts with symbols defined in
> netinet/icmp6.h.
> 
> In addition to the above, "mld-listener-done" is introduced as an alias
> for "mld-listener-reduction".

Applied, thanks.
