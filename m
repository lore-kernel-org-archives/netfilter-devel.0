From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH v2 0/3] monitor: Some fixes and improvements
Date: Thu, 27 Jul 2017 10:50:56 +0200
Message-ID: <20170727085056.GA5843@salvia>
References: <20170725183944.9377-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46012 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750836AbdG0IvI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Jul 2017 04:51:08 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4029BE1236
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Jul 2017 10:50:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 30F73DA87A
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Jul 2017 10:50:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0FEECDA46C
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Jul 2017 10:50:53 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170725183944.9377-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jul 25, 2017 at 08:39:41PM +0200, Phil Sutter wrote:
> This is v2 containing the patches not applied from v1. Apart from
> rebasing upon current upstream master, I folded patch 4 into patch 1
> since they really belong together: The code changes to make 'nft
> monitor' print correct syntax (by including the mandatory semicolons)
> harmed readability since it dropped whitespace from the output. Former
> patch 4 resolved this, not only for the cases patch 1 broke, but also at
> another spot (i.e. between 'type' attribute and the following ones).
> 
> Patch 2 of this series depends on patch 1 since the simplification
> requires that 'nft monitor' output matches given input (apart from
> whitespace change) which wasn't the case before patch 1.
> 
> Finally, patch 3 (along with patch 2) remains unchanged.

Series applied, thanks a lot for addressing all my feedback!
