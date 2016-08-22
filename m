From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/4 V6 nft] test: shell: Add tests for deleting rule by
 description
Date: Mon, 22 Aug 2016 18:21:46 +0200
Message-ID: <20160822162146.GB9973@salvia>
References: <20160821212210.26161-1-carlosfg@riseup.net>
 <20160821212210.26161-3-carlosfg@riseup.net>
 <20160822162050.GA9973@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47748 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752158AbcHVQWy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Aug 2016 12:22:54 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 168BE1F18CA
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Aug 2016 18:21:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 08365FB45D
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Aug 2016 18:21:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 06EACFB45D
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Aug 2016 18:21:51 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160822162050.GA9973@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Carlos,

One of this test fails... so please send me a follow up to fix it.

W: [FAILED]     ./testcases/rule_management/0010delete-by-desc_0

This chunk also looks a bit strange to me.

set +e; # Next commands can return 0
REMAINS_RULE2DEL=$($NFT list -a ruleset | grep -c "$RULE2DEL")
REMAINS_RULES=$(( $($NFT list -a ruleset | wc -l) - 4 ))
set -e

Please, send me follow up patchset to fix this.
