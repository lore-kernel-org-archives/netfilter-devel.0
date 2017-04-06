From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2] iptables: Remove unnecessary braces.
Date: Thu, 6 Apr 2017 18:22:59 +0200
Message-ID: <20170406162259.GB5655@salvia>
References: <cover.1490815157.git.rvarsha016@gmail.com>
 <58dc0ab2.15dc630a.414de.570e@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        outreachy-kernel <outreachy-kernel@googlegroups.com>
To: Varsha Rao <rvarsha016@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33174 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751972AbdDFQXJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Apr 2017 12:23:09 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 68ACB11ADC7
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Apr 2017 18:23:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 58E30DA873
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Apr 2017 18:23:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 50CB3DA86E
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Apr 2017 18:23:03 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <58dc0ab2.15dc630a.414de.570e@mx.google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 30, 2017 at 12:57:43AM +0530, Varsha Rao wrote:
> Remove braces which are not required, to fix the check patch issue.
> The following coccinelle script was used to fix this issue.
> 
> @@
> expression e;
> expression e1;
> @@
> if(e)
> -{
>  e1;
> -}

Applied, thanks.
