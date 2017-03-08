From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/3] libxtables: avoid returning duplicate address for
 host resolution
Date: Wed, 8 Mar 2017 17:45:02 +0100
Message-ID: <20170308164502.GA4076@salvia>
References: <1488983584-26091-1-git-send-email-pablo@netfilter.org>
 <20170308162658.5697-1-jengelh@inai.de>
 <20170308162658.5697-4-jengelh@inai.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39020 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752293AbdCHQpY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Mar 2017 11:45:24 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AD7FE1AEA68
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Mar 2017 17:45:07 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A0B5BDA808
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Mar 2017 17:45:07 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id ADFFBDA80B
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Mar 2017 17:45:03 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170308162658.5697-4-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 08, 2017 at 05:26:58PM +0100, Jan Engelhardt wrote:
> A long-standing problem has been that `iptables -s any_host_here`
> could yield multiple rules with the same address if the DNS was
> indeed so populated.

When did anyone report this problem out of the localhost case?
