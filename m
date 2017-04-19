From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables v3] iptables-restore/save: exit when given an
 unknown option
Date: Wed, 19 Apr 2017 18:00:57 +0200
Message-ID: <20170419160057.GA21073@salvia>
References: <20170414115621.13812-1-vincent@bernat.im>
 <20170415101647.20650-1-vincent@bernat.im>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Vincent Bernat <vincent@bernat.im>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58396 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1765628AbdDSQBM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Apr 2017 12:01:12 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7980E2EFEB1
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Apr 2017 18:01:02 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6B6CAEBAD5
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Apr 2017 18:01:02 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AC2D8FC5FC
        for <netfilter-devel@vger.kernel.org>; Wed, 19 Apr 2017 18:00:55 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170415101647.20650-1-vincent@bernat.im>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Apr 15, 2017 at 12:16:47PM +0200, Vincent Bernat wrote:
> When an unknown option is given, iptables-restore should exit instead of
> continue its operation. For example, if `--table` was misspelled, this
> could lead to an unwanted change. Moreover, exit with a status code of
> 1. Make the same change for iptables-save.
> 
> OTOH, exit with a status code of 0 when requesting help.

Applied, thanks.
