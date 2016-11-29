From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables PATCH] tcp_xlate: Enclose LH flag values in parentheses
Date: Tue, 29 Nov 2016 23:02:14 +0100
Message-ID: <20161129220214.GA31994@salvia>
References: <20161129114725.12735-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46864 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757034AbcK2WCT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Nov 2016 17:02:19 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 31CA5174D13
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2016 23:02:17 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 21C1CDA801
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2016 23:02:17 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 292AFDA385
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2016 23:02:15 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20161129114725.12735-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Nov 29, 2016 at 12:47:25PM +0100, Phil Sutter wrote:
> This fixes TCP flags matches:
> 
> | $ iptables-translate -A invalid -p tcp --tcp-flags SYN,FIN SYN,FIN -j DROP
> | nft add rule ip filter invalid tcp flags & fin|syn == fin|syn counter drop
> 
> Although the generated rule is syntactically correct and accepted by
> nft, it will be interpreted in a different way than expected since
> binary AND takes precedence over OR.

And this one also applied, thanks!
