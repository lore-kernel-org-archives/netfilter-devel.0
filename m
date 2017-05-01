From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: snmp: avoid stack size warning
Date: Mon, 1 May 2017 11:43:26 +0200
Message-ID: <20170501094326.GA3490@salvia>
References: <20170427143943.5099-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59006 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756556AbdEAJnf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 1 May 2017 05:43:35 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A8E961F4B7D
        for <netfilter-devel@vger.kernel.org>; Mon,  1 May 2017 11:43:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9089DFF137
        for <netfilter-devel@vger.kernel.org>; Mon,  1 May 2017 11:43:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9DD14A6D6
        for <netfilter-devel@vger.kernel.org>; Mon,  1 May 2017 11:43:26 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170427143943.5099-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 27, 2017 at 04:39:43PM +0200, Florian Westphal wrote:
> net/ipv4/netfilter/nf_nat_snmp_basic.c:1158:1: warning: the frame size
> of 1160 bytes is larger than 1024 bytes

Applied, thanks.
