From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: rate limit not working ?
Date: Tue, 20 Sep 2016 10:13:41 +0200
Message-ID: <20160920081341.GA2328@salvia>
References: <a6f9f673-8c5b-4a95-ea38-4fb8b39d4dc8@c-s.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Christophe Leroy <christophe.leroy@c-s.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35740 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753190AbcITINv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Sep 2016 04:13:51 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DE14F1E11A5
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Sep 2016 10:13:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CA587DA841
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Sep 2016 10:13:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 450DBDA841
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Sep 2016 10:13:42 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <a6f9f673-8c5b-4a95-ea38-4fb8b39d4dc8@c-s.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Sep 16, 2016 at 06:50:22PM +0200, Christophe Leroy wrote:
> Hi
> 
> I tried to limit ping flooding by setting the following rule:
> 
> nft add rule filter input icmp type echo-request limit rate 10/second accept

This is matching packets under the rate, so packets under the rate are
accepted.

Your next rule, or default policy, should drop, so packets over the
rate are dropped.

You can invert this logic via:

 # nft add rule filter input icmp type echo-request limit rate over 10/second drop

Does this work for you?

Thanks.
