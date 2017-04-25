From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf v3] net/openvswitch: Delete conntrack entry clashing
 with an expectation.
Date: Tue, 25 Apr 2017 11:06:09 +0200
Message-ID: <20170425090609.GB2833@salvia>
References: <1492205198-41758-1-git-send-email-jarno@ovn.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, joe@ovn.org
To: Jarno Rajahalme <jarno@ovn.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43416 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1177222AbdDYJGP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Apr 2017 05:06:15 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4B62B6D580
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Apr 2017 11:06:09 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3B1C1FF2DB
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Apr 2017 11:06:09 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2A8DFA6C1
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Apr 2017 11:06:06 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1492205198-41758-1-git-send-email-jarno@ovn.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Apr 14, 2017 at 02:26:38PM -0700, Jarno Rajahalme wrote:
> Conntrack helpers do not check for a potentially clashing conntrack
> entry when creating a new expectation.  Also, nf_conntrack_in() will
> check expectations (via init_conntrack()) only if a conntrack entry
> can not be found.  The expectation for a packet which also matches an
> existing conntrack entry will not be removed by conntrack, and is
> currently handled inconsistently by OVS, as OVS expects the
> expectation to be removed when the connection tracking entry matching
> that expectation is confirmed.
> 
> It should be noted that normally an IP stack would not allow reuse of
> a 5-tuple of an old (possibly lingering) connection for a new data
> connection, so this is somewhat unlikely corner case.  However, it is
> possible that a misbehaving source could cause conntrack entries be
> created that could then interfere with new related connections.
> 
> Fix this in the OVS module by deleting the clashing conntrack entry
> after an expectation has been matched.  This causes the following
> nf_conntrack_in() call also find the expectation and remove it when
> creating the new conntrack entry, as well as the forthcoming reply
> direction packets to match the new related connection instead of the
> old clashing conntrack entry.

Applied, with minor changes that we have already discussed here.

Thanks.
