From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nat: remove rcu_read_lock in
 __nf_nat_decode_session.
Date: Thu, 13 Apr 2017 22:49:39 +0200
Message-ID: <20170413204939.GA1780@salvia>
References: <20170327152850.19812-1-ap420073@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Taehee Yoo <ap420073@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37156 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756172AbdDMUt6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Apr 2017 16:49:58 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 93367AFB1E
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Apr 2017 22:49:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 80E13DA86F
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Apr 2017 22:49:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8A107DA7F7
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Apr 2017 22:49:48 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170327152850.19812-1-ap420073@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 28, 2017 at 12:28:50AM +0900, Taehee Yoo wrote:
> __nf_nat_decode_session is called from nf_nat_decode_session as decodefn.
> before calling decodefn, it already set rcu_read_lock. so rcu_read_lock in
> __nf_nat_decode_session can be removed.

Applied, thanks.
