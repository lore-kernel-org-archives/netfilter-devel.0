From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH v3] expr: Introduce nftnl_expr_fprintf()
Date: Tue, 17 Oct 2017 15:19:06 +0200
Message-ID: <20171017131906.GA21376@salvia>
References: <20171017121145.GA18793@salvia>
 <20171017131741.2026-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43002 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755213AbdJQNTN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Oct 2017 09:19:13 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8E9B952306
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Oct 2017 15:19:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 800C4BAC37
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Oct 2017 15:19:12 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20171017131741.2026-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Oct 17, 2017 at 03:17:41PM +0200, Phil Sutter wrote:
> Implement expression printing into a FILE pointer analogous to
> nftnl_rule_fprintf().

Applied, thanks Phil!
