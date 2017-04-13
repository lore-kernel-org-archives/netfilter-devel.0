From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] nf_conntrack: remove double assignment
Date: Fri, 14 Apr 2017 01:27:37 +0200
Message-ID: <20170413232737.GB7721@salvia>
References: <20170412203254.14625-1-aconole@bytheb.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Aaron Conole <aconole@bytheb.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56604 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753019AbdDMX1t (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Apr 2017 19:27:49 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 10F44C1081
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2017 01:27:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4F91ADA865
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2017 01:27:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 313D1DA865
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2017 01:27:47 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170412203254.14625-1-aconole@bytheb.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Apr 12, 2017 at 04:32:54PM -0400, Aaron Conole wrote:
> The protonet pointer will unconditionally be rewritten, so just do the
> needed assignment first.

Also applied, thanks.
