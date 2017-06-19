From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next RFC 1/5] netfilter: use
 nf_conntrack_helpers_register when possible
Date: Mon, 19 Jun 2017 19:13:52 +0200
Message-ID: <20170619171352.GA5154@salvia>
References: <1496589909-56730-1-git-send-email-zlpnobody@163.com>
 <1496589909-56730-2-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58114 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750878AbdFSROA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 19 Jun 2017 13:14:00 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 56D742E784D
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Jun 2017 19:13:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4AC786DAC4
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Jun 2017 19:13:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EF196100A7F
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Jun 2017 19:13:44 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1496589909-56730-2-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Jun 04, 2017 at 11:25:05PM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> amanda_helper, nf_conntrack_helper_ras and nf_conntrack_helper_q931 are
> all arrays, so we can use nf_conntrack_helpers_register to register
> the ct helper, this will help us to eliminate some "goto errX"
> statements.
> 
> Also introduce h323_helper_init/exit helper function to register the ct
> helpers, this is prepared for the followup patch, which will add net
> namespace support for ct helper.

Applied, thanks.
