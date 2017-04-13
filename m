From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables v1] iptables-restore/save: exit when given an
 unknown option
Date: Thu, 13 Apr 2017 23:16:27 +0200
Message-ID: <20170413211627.GA2387@salvia>
References: <20170403184918.13847-1-vincent@bernat.im>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Vincent Bernat <vincent@bernat.im>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40732 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750915AbdDMVQh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Apr 2017 17:16:37 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 41001BA1A9
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Apr 2017 23:16:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 31CE3DA865
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Apr 2017 23:16:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 18C90DA807
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Apr 2017 23:16:30 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170403184918.13847-1-vincent@bernat.im>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Apr 03, 2017 at 08:49:18PM +0200, Vincent Bernat wrote:
> When an unknown option is given, iptables-restore should exit instead of
> continue its operation. For example, if `--table` was misspelled, this
> could lead to an unwanted change. Moreover, exit with a status code of
> 1. Make the same change for iptables-save.

I was trying to skip this, since this has been working like this since
day 1 and some stupid script may break, but OK, let's fix this.

> OTOH, exit with a status code of 0 when requesting help.

Could you also fix xtables-restore.c that is used for the compat
layer?

Thanks!
