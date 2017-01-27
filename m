From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft v3 1/6] src: Allow reset single stateful object
Date: Fri, 27 Jan 2017 13:34:41 +0100
Message-ID: <20170127123441.GA5341@salvia>
References: <20170126170944.GA7842@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Elise Lennion <elise.lennion@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37672 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754539AbdA0MnV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 27 Jan 2017 07:43:21 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7673016B289
        for <netfilter-devel@vger.kernel.org>; Fri, 27 Jan 2017 13:34:44 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 606C4FF15F
        for <netfilter-devel@vger.kernel.org>; Fri, 27 Jan 2017 13:34:44 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 33B10A7EE7
        for <netfilter-devel@vger.kernel.org>; Fri, 27 Jan 2017 13:34:42 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170126170944.GA7842@lennorien.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 26, 2017 at 03:09:44PM -0200, Elise Lennion wrote:
> Currently the stateful objects can only be reseted in groups. With this
> patch reseting a single object is allowed:
> 
> $ nft reset counter filter https-traffic
> table ip filter {
> 	counter https-traffic {
> 		packets 8774 bytes 542668
> 	}
> }
> 
> $ nft list counter filter https-traffic
> table ip filter {
> 	counter https-traffic {
> 		packets 0 bytes 0
> 	}
> }

Series from 1/6 to 6/6 applied, thanks Elise.
