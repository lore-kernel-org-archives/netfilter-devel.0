From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] conntrack: Support IPv6 NAT
Date: Fri, 17 Mar 2017 12:42:14 +0100
Message-ID: <20170317114214.GA4396@salvia>
References: <1489664943-25811-1-git-send-email-neil@aldur.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Neil Wilson <neil@aldur.co.uk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50102 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751022AbdCQLnD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Mar 2017 07:43:03 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B39526B19D
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Mar 2017 12:42:16 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A4635DA91A
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Mar 2017 12:42:16 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5F6D9FAB56
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Mar 2017 12:42:14 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1489664943-25811-1-git-send-email-neil@aldur.co.uk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 16, 2017 at 11:49:03AM +0000, Neil Wilson wrote:
> Refactor and improve nat support to allow conntrack to manage IPv6
> NAT entries.
> 
> Refactor and improve conntrack nat tests to include IPv6 NAT.

Applied, thanks Neil!
